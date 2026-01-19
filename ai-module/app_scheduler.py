from flask import Flask, jsonify
import mysql.connector
import joblib
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns
import os
from datetime import datetime
import logging
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import atexit

# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# ========================
# Configuration
# ========================
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "pret_bancaires"
}

# ========================
# Configuration des chemins
# ========================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
GRAPHS_DIR = os.path.join(BASE_DIR, "static", "graphs")
os.makedirs(GRAPHS_DIR, exist_ok=True)

MODEL_PATH = os.path.join(BASE_DIR, "model_pret.pkl")

# ========================
# Chargement du modèle
# ========================
try:
    model = joblib.load(MODEL_PATH)
    logger.info(f"✓ Modèle IA chargé depuis {MODEL_PATH}")
except Exception as e:
    logger.error(f"❌ Erreur chargement modèle: {e}")
    model = None


# ========================
# Fonctions de traitement
# ========================
def calculate_debt_ratio(mensualite, revenu):
    """Calcule le taux d'endettement"""
    if revenu > 0:
        return round(mensualite / revenu, 6)
    return 0.0


def predict_risk_level(taux_endettement):
    """Prédit le niveau de risque avec le modèle IA"""
    if model is None:
        # Règle de fallback si modèle indisponible
        if taux_endettement < 0.33:
            return "Faible"
        elif taux_endettement < 0.50:
            return "Moyen"
        else:
            return "Eleve"
    
    try:
        df = pd.DataFrame([[taux_endettement]], columns=['taux_endettement'])
        prediction = model.predict(df)[0]
        return prediction
    except Exception as e:
        logger.error(f"Erreur prédiction modèle: {e}")
        # Fallback
        if taux_endettement < 0.33:
            return "Faible"
        elif taux_endettement < 0.50:
            return "Moyen"
        else:
            return "Eleve"


def process_pret_table():
    """
    Traite la table PRET :
    - Calcule taux_endettement si NULL
    - Insère dans prediction_risque si manquant
    """
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    total_processed = 0
    
    try:
        # Récupérer les prêts avec taux_endettement NULL ou sans prédiction
        cursor.execute("""
            SELECT 
                p.id_pret,
                p.client_id,
                p.mensualite,
                p.taux_endettement,
                c.revenu_mensuel,
                pr.id_prediction
            FROM pret p
            JOIN client c ON p.client_id = c.id_client
            LEFT JOIN prediction_risque pr ON p.id_pret = pr.pret_id
            WHERE p.taux_endettement IS NULL 
               OR pr.id_prediction IS NULL
        """)
        
        prets = cursor.fetchall()
        logger.info(f"📋 {len(prets)} prêts à traiter dans la table PRET")
        
        for pret in prets:
            id_pret = pret['id_pret']
            mensualite = float(pret['mensualite'])
            revenu = float(pret['revenu_mensuel'])
            taux_actuel = pret['taux_endettement']
            
            # 1. Calculer le taux d'endettement si NULL
            if taux_actuel is None:
                taux_endettement = calculate_debt_ratio(mensualite, revenu)
                cursor.execute("""
                    UPDATE pret 
                    SET taux_endettement = %s
                    WHERE id_pret = %s
                """, (taux_endettement, id_pret))
                logger.info(f"  ✓ Taux endettement calculé pour prêt {id_pret}: {taux_endettement:.4f}")
            else:
                taux_endettement = float(taux_actuel)
            
            # 2. Insérer prédiction si manquante
            if pret['id_prediction'] is None:
                niveau_risque = predict_risk_level(taux_endettement)
                cursor.execute("""
                    INSERT INTO prediction_risque 
                    (pret_id, taux_endettement, niveau_risque, score_confiance, date_prediction)
                    VALUES (%s, %s, %s, %s, NOW())
                """, (id_pret, taux_endettement, niveau_risque, 0.85))
                logger.info(f"  ✓ Prédiction insérée pour prêt {id_pret}: {niveau_risque}")
            
            total_processed += 1
        
        conn.commit()
        logger.info(f"✅ {total_processed} prêts traités dans la table PRET")
        
    except Exception as e:
        logger.error(f"❌ Erreur traitement PRET: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
    
    return total_processed


def process_demandespret_table():
    """
    Traite la table DEMANDESPRET :
    - Calcule taux_endettement_calcule si NULL/0
    - Prédit niveau_risque si NULL
    - Auto-approuve si risque FAIBLE
    """
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    total_processed = 0
    total_approved = 0
    
    try:
        # Récupérer les demandes incomplètes ou en attente
        cursor.execute("""
            SELECT 
                d.id_demande,
                d.client_id,
                d.type_pret,
                d.montant_souhaite,
                d.duree_mois,
                d.taux_endettement_calcule,
                d.niveau_risque,
                d.statut,
                c.revenu_mensuel
            FROM demandespret d
            JOIN client c ON d.client_id = c.id_client
            WHERE (d.taux_endettement_calcule IS NULL 
                   OR d.taux_endettement_calcule = 0 
                   OR d.niveau_risque IS NULL
                   OR d.statut = 'EN_ATTENTE')
              AND c.revenu_mensuel > 0
        """)
        
        demandes = cursor.fetchall()
        logger.info(f"📋 {len(demandes)} demandes à traiter dans DEMANDESPRET")
        
        for demande in demandes:
            id_demande = demande['id_demande']
            montant = float(demande['montant_souhaite'])
            duree = int(demande['duree_mois'])
            revenu = float(demande['revenu_mensuel'])
            taux_actuel = demande['taux_endettement_calcule']
            niveau_actuel = demande['niveau_risque']
            
            # 1. Calculer mensualité approximative et taux d'endettement
            if taux_actuel is None or float(taux_actuel) == 0:
                mensualite_estimee = montant / duree if duree > 0 else 0
                taux_endettement = calculate_debt_ratio(mensualite_estimee, revenu)
                
                cursor.execute("""
                    UPDATE demandespret 
                    SET taux_endettement_calcule = %s
                    WHERE id_demande = %s
                """, (taux_endettement, id_demande))
                logger.info(f"  ✓ Taux calculé pour demande {id_demande}: {taux_endettement:.4f}")
            else:
                taux_endettement = float(taux_actuel)
            
            # 2. Prédire le niveau de risque si NULL
            if niveau_actuel is None:
                niveau_risque = predict_risk_level(taux_endettement)
                cursor.execute("""
                    UPDATE demandespret 
                    SET niveau_risque = %s
                    WHERE id_demande = %s
                """, (niveau_risque, id_demande))
                logger.info(f"  ✓ Risque prédit pour demande {id_demande}: {niveau_risque}")
            else:
                niveau_risque = niveau_actuel
            
            # 3. Auto-approuver si FAIBLE et EN_ATTENTE
            if niveau_risque == 'FAIBLE' and demande['statut'] == 'EN_ATTENTE':
                # Calculer taux annuel estimé (exemple: 4%)
                taux_annuel = 0.04
                mensualite_finale = montant / duree
                
                # Insérer dans la table PRET
                cursor.execute("""
                    INSERT INTO pret 
                    (client_id, type_pret, duree_mois, taux_annuel, mensualite, taux_endettement)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, (demande['client_id'], demande['type_pret'], duree, 
                      taux_annuel, mensualite_finale, taux_endettement))
                
                new_pret_id = cursor.lastrowid
                
                # Insérer prédiction
                cursor.execute("""
                    INSERT INTO prediction_risque 
                    (pret_id, taux_endettement, niveau_risque, score_confiance, date_prediction)
                    VALUES (%s, %s, %s, %s, NOW())
                """, (new_pret_id, taux_endettement, niveau_risque, 0.90))
                
                # Mettre à jour le statut de la demande
                cursor.execute("""
                    UPDATE demandespret 
                    SET statut = 'APPROUVE',
                        commentaire_admin = 'Auto-approuvé - Risque faible'
                    WHERE id_demande = %s
                """, (id_demande,))
                
                total_approved += 1
                logger.info(f"  ✅ Demande {id_demande} AUTO-APPROUVÉE (Prêt #{new_pret_id})")
            
            total_processed += 1
        
        conn.commit()
        logger.info(f"✅ {total_processed} demandes traitées, {total_approved} auto-approuvées")
        
    except Exception as e:
        logger.error(f"❌ Erreur traitement DEMANDESPRET: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
    
    return total_processed, total_approved


def auto_predict_new_loans():
    """Fonction principale de traitement automatique"""
    logger.info("🔄 Début du traitement automatique...")
    
    # Traiter les deux tables
    prets_count = process_pret_table()
    demandes_count, approved_count = process_demandespret_table()
    
    total = prets_count + demandes_count
    
    return {
        "success": True, 
        "total_processed": total,
        "prets_updated": prets_count,
        "demandes_updated": demandes_count,
        "auto_approved": approved_count
    }


def generate_analytics_graphs():
    """Génération des graphiques d'analyse"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)

        # 1. Répartition des risques
        cursor.execute("""
            SELECT niveau_risque, COUNT(*) AS total
            FROM prediction_risque
            GROUP BY niveau_risque
        """)
        risques = cursor.fetchall()
        if risques:
            risque_df = pd.DataFrame(risques)
            colors = {'Faible': '#16a34a', 'Moyen': '#facc15', 'Eleve': '#dc2626'}
            bar_colors = [colors.get(r, '#6b7280') for r in risque_df['niveau_risque']]

            plt.figure(figsize=(10, 6))
            plt.bar(risque_df['niveau_risque'], risque_df['total'], color=bar_colors, edgecolor='white', linewidth=2)
            plt.title('Répartition des Prêts par Niveau de Risque', fontsize=14, fontweight='bold')
            plt.ylabel('Nombre de Prêts', fontsize=11)
            plt.xlabel('Niveau de Risque', fontsize=11)
            plt.grid(axis='y', alpha=0.3)
            plt.tight_layout()
            graph_path = os.path.join(GRAPHS_DIR, 'repartition_risques.png')
            plt.savefig(graph_path, dpi=100, bbox_inches='tight')
            plt.close()

        # 2. Distribution de l'endettement
        cursor.execute("SELECT taux_endettement FROM prediction_risque WHERE taux_endettement IS NOT NULL")
        te_data = [row['taux_endettement'] for row in cursor.fetchall()]
        if te_data:
            plt.figure(figsize=(10, 6))
            plt.hist(te_data, bins=25, color='#3b82f6', alpha=0.7, edgecolor='white')
            plt.axvline(x=0.33, color='red', linestyle='--', linewidth=2, label='Seuil 33%')
            plt.title('Distribution du Taux d\'Endettement', fontsize=14, fontweight='bold')
            plt.xlabel('Taux d\'Endettement', fontsize=11)
            plt.ylabel('Fréquence', fontsize=11)
            plt.legend()
            plt.grid(axis='y', alpha=0.3)
            plt.tight_layout()
            graph_path = os.path.join(GRAPHS_DIR, 'distribution_endettement.png')
            plt.savefig(graph_path, dpi=100, bbox_inches='tight')
            plt.close()

        # 3. Évolution temporelle
        cursor.execute("""
            SELECT DATE(date_prediction) AS date, niveau_risque, COUNT(*) AS total
            FROM prediction_risque
            WHERE date_prediction IS NOT NULL
            GROUP BY DATE(date_prediction), niveau_risque
            ORDER BY date
        """)
        evolution = cursor.fetchall()
        if evolution:
            evo_df = pd.DataFrame(evolution)
            pivot_df = evo_df.pivot(index='date', columns='niveau_risque', values='total').fillna(0)

            plt.figure(figsize=(10, 6))
            pivot_df.plot(kind='area', stacked=True, ax=plt.gca(),
                          color=['#16a34a', '#facc15', '#dc2626'], alpha=0.7)
            plt.title('Évolution des Risques', fontsize=14, fontweight='bold')
            plt.xlabel('Date', fontsize=11)
            plt.ylabel('Nombre de Prêts', fontsize=11)
            plt.legend(title='Niveau de Risque')
            plt.grid(axis='y', alpha=0.3)
            plt.tight_layout()
            graph_path = os.path.join(GRAPHS_DIR, 'evolution_risques.png')
            plt.savefig(graph_path, dpi=100, bbox_inches='tight')
            plt.close()

        cursor.close()
        conn.close()
        logger.info(f"✅ Graphiques générés dans {GRAPHS_DIR}")
        return {"success": True}

    except Exception as e:
        logger.error(f"❌ Erreur graphiques: {e}")
        return {"success": False, "message": str(e)}


# ========================
# Tâche planifiée
# ========================
def scheduled_prediction_task():
    """Tâche exécutée automatiquement toutes les X minutes"""
    logger.info("⏰ Exécution de la tâche planifiée...")
    
    result = auto_predict_new_loans()
    
    if result['success'] and result['total_processed'] > 0:
        logger.info(f"✓ {result['total_processed']} éléments traités "
                   f"({result['auto_approved']} auto-approuvés)")
        generate_analytics_graphs()
    else:
        logger.info("ℹ Aucune donnée à traiter")


# ========================
# Configuration du Scheduler
# ========================
scheduler = BackgroundScheduler()

scheduler.add_job(
    func=scheduled_prediction_task,
    trigger=IntervalTrigger(minutes=5),
    id='auto_prediction_job',
    name='Prédiction automatique des prêts',
    replace_existing=True
)

atexit.register(lambda: scheduler.shutdown())


# ========================
# ROUTES API
# ========================
@app.route("/report", methods=["GET"])
def report():
    """Rapport global avec données en temps réel"""
    auto_predict_new_loans()
    generate_analytics_graphs()
    
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT niveau_risque, COUNT(*) AS total
        FROM prediction_risque
        GROUP BY niveau_risque
    """)
    risques = cursor.fetchall()
    
    cursor.execute("SELECT COUNT(*) AS total_prets FROM pret")
    total_prets = cursor.fetchone()["total_prets"]
    
    cursor.execute("""
        SELECT COUNT(*) AS en_attente 
        FROM demandespret 
        WHERE statut = 'EN_ATTENTE'
    """)
    demandes_attente = cursor.fetchone()["en_attente"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "total_prets": total_prets,
        "demandes_en_attente": demandes_attente,
        "repartition_risque": risques,
        "timestamp": datetime.now().isoformat()
    })


@app.route("/predict/manual", methods=["POST"])
def manual_predict():
    """Déclencher manuellement une prédiction"""
    result = auto_predict_new_loans()
    if result['success'] and result['total_processed'] > 0:
        generate_analytics_graphs()
    return jsonify(result)


@app.route("/scheduler/status", methods=["GET"])
def scheduler_status():
    """Vérifier l'état du scheduler"""
    jobs = []
    for job in scheduler.get_jobs():
        jobs.append({
            "id": job.id,
            "name": job.name,
            "next_run": str(job.next_run_time)
        })
    
    return jsonify({
        "scheduler_running": scheduler.running,
        "jobs": jobs
    })


@app.route("/health", methods=["GET"])
def health():
    """État du service"""
    return jsonify({
        "status": "running",
        "model_loaded": model is not None,
        "scheduler_active": scheduler.running,
        "timestamp": datetime.now().isoformat()
    })


# ========================
# Démarrage
# ========================
if __name__ == "__main__":
    logger.info("🚀 Démarrage du serveur Flask IA avec Scheduler")
    
    # Traitement initial
    logger.info("📊 Traitement initial des données...")
    auto_predict_new_loans()
    generate_analytics_graphs()
    
    # Démarrer le scheduler
    scheduler.start()
    logger.info("⏰ Scheduler démarré - Vérification toutes les 5 minutes")
    
    # Démarrer Flask
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)