package com.banque.dao;

import com.banque.model.Pret;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PretDAO {
    
	public List<Pret> findByUserId(int userId) {
        List<Pret> prets = new ArrayList<>();
        
        String sql = "SELECT dp.id_demande, dp.user_id, dp.type_pret, dp.montant_souhaite, " +
                     "dp.duree_mois, dp.taux_endettement_calcule, dp.niveau_risque, " +
                     "dp.statut, dp.date_demande, " +
                     "u.login as client_identifiant, " +
                     "c.ville as client_ville, c.revenu_mensuel as client_revenu " +
                     "FROM demandespret dp " +
                     "LEFT JOIN utilisateur u ON dp.user_id = u.id_user " +
                     "LEFT JOIN client c ON u.id_user = c.user_id " +
                     "WHERE dp.user_id = ? " +
                     "ORDER BY dp.date_demande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Pret pret = new Pret();
                
                // Informations du prêt
                pret.setIdPret(rs.getInt("id_demande"));
                pret.setClientId(rs.getInt("user_id"));
                pret.setTypePret(rs.getString("type_pret"));
                pret.setDureeMois(rs.getInt("duree_mois"));
                pret.setTauxEndettement(rs.getDouble("taux_endettement_calcule"));
                pret.setNiveauRisque(rs.getString("niveau_risque"));
                pret.setStatut(rs.getString("statut"));
                
                // Calcul de la mensualité
                double montantTotal = rs.getDouble("montant_souhaite");
                int duree = rs.getInt("duree_mois");
                double mensualite = duree > 0 ? montantTotal / duree : 0;
                pret.setMensualite(mensualite);
                
                // Taux annuel (peut être calculé ou récupéré d'une autre table)
                pret.setTauxAnnuel(3.5); // Valeur par défaut ou à récupérer
                
                // Informations du client
                pret.setClientIdentifiant(rs.getString("client_identifiant"));
                pret.setClientVille(rs.getString("client_ville"));
                pret.setClientRevenu(rs.getDouble("client_revenu"));
                
                prets.add(pret);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return prets;
    }
    
    /**
     * Récupère un prêt spécifique par son ID
     */
    public Pret findById1(int idPret) {
        String sql = "SELECT dp.id_demande, dp.user_id, dp.type_pret, dp.montant_souhaite, " +
                     "dp.duree_mois, dp.taux_endettement_calcule, dp.niveau_risque, " +
                     "dp.statut, dp.date_demande, " +
                     "u.login as client_identifiant, " +
                     "c.ville as client_ville, c.revenu_mensuel as client_revenu " +
                     "FROM demandespret dp " +
                     "LEFT JOIN utilisateur u ON dp.user_id = u.id_user " +
                     "LEFT JOIN client c ON u.id_user = c.user_id " +
                     "WHERE dp.id_demande = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idPret);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Pret pret = new Pret();
                
                pret.setIdPret(rs.getInt("id_demande"));
                pret.setClientId(rs.getInt("user_id"));
                pret.setTypePret(rs.getString("type_pret"));
                pret.setDureeMois(rs.getInt("duree_mois"));
                pret.setTauxEndettement(rs.getDouble("taux_endettement_calcule"));
                pret.setNiveauRisque(rs.getString("niveau_risque"));
                pret.setStatut(rs.getString("statut"));
                
                double montantTotal = rs.getDouble("montant_souhaite");
                int duree = rs.getInt("duree_mois");
                pret.setMensualite(duree > 0 ? montantTotal / duree : 0);
                pret.setTauxAnnuel(3.5);
                
                pret.setClientIdentifiant(rs.getString("client_identifiant"));
                pret.setClientVille(rs.getString("client_ville"));
                pret.setClientRevenu(rs.getDouble("client_revenu"));
                
                return pret;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Calcule le nombre total de prêts pour un utilisateur
     */
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM demandespret WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Calcule le montant total emprunté par un utilisateur
     */
    public double getTotalMontantByUserId(int userId) {
        String sql = "SELECT SUM(montant_souhaite) FROM demandespret WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    /**
     * Compte les prêts en cours pour un utilisateur
     */
    public int countEnCoursByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM demandespret WHERE user_id = ? AND statut = 'EN_ATTENTE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Récupérer tous les prêts
    public List<Pret> findAll() {
        List<Pret> prets = new ArrayList<>();
        String sql = "SELECT p.*, c.identifiant_original, c.ville, c.revenu_mensuel " +
                     "FROM pret p " +
                     "JOIN client c ON p.client_id = c.id_client " +
                     "ORDER BY p.id_pret DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pret pret = new Pret();
                pret.setIdPret(rs.getInt("id_pret"));
                pret.setClientId(rs.getInt("client_id"));
                pret.setTypePret(rs.getString("type_pret"));
                pret.setDureeMois(rs.getInt("duree_mois"));
                pret.setTauxAnnuel(rs.getDouble("taux_annuel"));
                pret.setMensualite(rs.getDouble("mensualite"));
                pret.setTauxEndettement(rs.getDouble("taux_endettement"));
                
                // Informations du client
                pret.setClientIdentifiant(rs.getString("identifiant_original"));
                pret.setClientVille(rs.getString("ville"));
                pret.setClientRevenu(rs.getDouble("revenu_mensuel"));
                
                prets.add(pret);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return prets;
    }
    
    // Récupérer un prêt par ID
    public Pret findById(int idPret) {
        String sql = "SELECT p.*, c.identifiant_original, c.ville, c.revenu_mensuel " +
                     "FROM pret p " +
                     "JOIN client c ON p.client_id = c.id_client " +
                     "WHERE p.id_pret = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idPret);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Pret pret = new Pret();
                pret.setIdPret(rs.getInt("id_pret"));
                pret.setClientId(rs.getInt("client_id"));
                pret.setTypePret(rs.getString("type_pret"));
                pret.setDureeMois(rs.getInt("duree_mois"));
                pret.setTauxAnnuel(rs.getDouble("taux_annuel"));
                pret.setMensualite(rs.getDouble("mensualite"));
                pret.setTauxEndettement(rs.getDouble("taux_endettement"));
                
                pret.setClientIdentifiant(rs.getString("identifiant_original"));
                pret.setClientVille(rs.getString("ville"));
                pret.setClientRevenu(rs.getDouble("revenu_mensuel"));
                
                return pret;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Récupérer les prêts d'un client
    public List<Pret> findByClient(int clientId) {
        List<Pret> prets = new ArrayList<>();
        String sql = "SELECT p.*, c.identifiant_original, c.ville, c.revenu_mensuel " +
                     "FROM pret p " +
                     "JOIN client c ON p.client_id = c.id_client " +
                     "WHERE p.client_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Pret pret = new Pret();
                pret.setIdPret(rs.getInt("id_pret"));
                pret.setClientId(rs.getInt("client_id"));
                pret.setTypePret(rs.getString("type_pret"));
                pret.setDureeMois(rs.getInt("duree_mois"));
                pret.setTauxAnnuel(rs.getDouble("taux_annuel"));
                pret.setMensualite(rs.getDouble("mensualite"));
                pret.setTauxEndettement(rs.getDouble("taux_endettement"));
                
                pret.setClientIdentifiant(rs.getString("identifiant_original"));
                pret.setClientVille(rs.getString("ville"));
                pret.setClientRevenu(rs.getDouble("revenu_mensuel"));
                
                prets.add(pret);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return prets;
    }
    
    
    // Créer un prêt
    public boolean save(Pret pret) {
        // On n'inclut PAS niveau_risque ici, l'IA s'en chargera plus tard
        String sql = "INSERT INTO demandespret (client_id, type_pret, montant_souhaite, duree_mois, " + 
                     "taux_endettement_calcule, statut, date_demande) " + 
                     "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pret.getClientId());
            ps.setString(2, pret.getTypePret().toUpperCase()); // Pour avoir IMMOBILIER au lieu de immobilier
            ps.setDouble(3, pret.getMensualite() * pret.getDureeMois()); // Montant total
            ps.setInt(4, pret.getDureeMois());
            ps.setDouble(5, pret.getTauxEndettement());
            ps.setString(6, "EN_ATTENTE");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    // Mettre à jour un prêt
    public boolean update(Pret pret) {
        String sql = "UPDATE pret SET client_id=?, type_pret=?, duree_mois=?, " +
                     "taux_annuel=?, mensualite=? WHERE id_pret=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pret.getClientId());
            ps.setString(2, pret.getTypePret());
            ps.setInt(3, pret.getDureeMois());
            ps.setDouble(4, pret.getTauxAnnuel());
            ps.setDouble(5, pret.getMensualite());
            ps.setInt(6, pret.getIdPret());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Supprimer un prêt
    public boolean delete(int idPret) {
        String sql = "DELETE FROM pret WHERE id_pret = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idPret);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean updateStatus(int idDemande, String nouveauStatut) {
        String sql = "UPDATE demandespret SET statut = ? WHERE id_demande = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, nouveauStatut);
            ps.setInt(2, idDemande);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
private Pret mapResultSetToPret(ResultSet rs) throws SQLException {
    Pret pret = new Pret();

    pret.setIdPret(rs.getInt("id_demande"));
    pret.setClientId(rs.getInt("client_id"));
    pret.setTypePret(rs.getString("type_pret"));
    pret.setDureeMois(rs.getInt("duree_mois"));

    // On récupère juste les valeurs stockées dans la base
    pret.setMensualite(rs.getDouble("montant_souhaite"));
    pret.setClientRevenu(rs.getDouble("revenu_mensuel"));

    // ✅ On récupère directement le taux déjà calculé
    pret.setTauxEndettement(rs.getDouble("taux_endettement_calcule"));

    // Infos client
    pret.setClientIdentifiant(rs.getString("identifiant_original"));
    pret.setClientVille(rs.getString("ville"));

    // Niveau de risque (déjà dans la table)
    pret.setNiveauRisque(rs.getString("niveau_risque"));

    // Statut
    pret.setStatut(rs.getString("statut"));

    return pret;
}
 // --- MÉTHODE À AJOUTER : Récupérer uniquement les demandes en attente ---
    public List<Pret> findPending() {
        List<Pret> prets = new ArrayList<>();
        String sql = "SELECT d.*, c.identifiant_original, c.ville, c.revenu_mensuel " +
                     "FROM demandespret d " +
                     "JOIN client c ON d.client_id = c.id_client " +
                     "WHERE d.statut = 'EN_ATTENTE' " +
                     "ORDER BY d.date_demande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                prets.add(mapResultSetToPret(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prets;
    }
    public List<Pret> getDemandesEnAttente() {
        List<Pret> demandes = new ArrayList<>();

        String sql = """
            SELECT 
                d.id_demande,
                d.client_id,
                d.type_pret,
                d.montant_souhaite,
                d.duree_mois,
                d.taux_endettement_calcule,
                d.niveau_risque,
                d.statut,
                c.identifiant_original
            FROM demandespret d
            JOIN client c ON d.client_id = c.id_client
            WHERE d.statut = 'EN_ATTENTE'
            ORDER BY d.date_demande DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Pret p = new Pret();
                p.setIdPret(rs.getInt("id_demande"));
                p.setClientId(rs.getInt("client_id"));
                p.setClientIdentifiant(rs.getString("identifiant_original"));
                p.setTypePret(rs.getString("type_pret"));
                p.setMensualite(rs.getDouble("montant_souhaite"));
                p.setDureeMois(rs.getInt("duree_mois"));

                // ✅ DÉJÀ CALCULÉ EN BASE
                p.setTauxEndettement(rs.getDouble("taux_endettement_calcule"));
                p.setNiveauRisque(rs.getString("niveau_risque"));
                p.setClientId(rs.getInt("client_id"));
                p.setNiveauRisque(rs.getString("niveau_risque"));


                demandes.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return demandes;
    }
}