# 🏦 Application Web de Gestion Bancaire avec Module IA

## 1. Architecture générale du projet (vue d’ensemble)

Ce projet repose sur une **architecture modulaire et découplée**, combinant une application **Java EE (JEE)** pour la gestion bancaire et un **module d’intelligence artificielle en Python** exposé via une **API Flask**, initialement développé et testé sous **Jupyter Notebook**.

L’architecture suit une logique **multi-couches** et **orientée services**, permettant une séparation claire des responsabilités :

- **Couche Présentation** : JSP / HTML / CSS (interface utilisateur)
- **Couche Métier** : Servlets Java EE
- **Couche Accès aux Données** : DAO + MySQL
- **Module IA externe** : Flask + modèle de machine learning
- **Communication inter-modules** : API REST (HTTP / JSON)

### Schéma logique simplifié :

Utilisateur
│
▼
Interface Web (JSP / CSS)
│
▼
Servlets Java EE (Contrôleurs)
│
├── DAO (MySQL)
│
└── Appels HTTP REST
│
▼
API Flask (Python)
│
▼
Modèle IA (Régression logistique)

markdown
Copy code

Cette architecture permet :
- une **indépendance totale du module IA**
- une **évolutivité** (remplacement du modèle sans toucher au Java)
- une **approche réaliste proche des systèmes bancaires modernes**

---

## 2. Objectif du projet

Ce projet consiste en le développement d’une **application web de gestion bancaire** basée sur **Java EE**, visant à **simuler le fonctionnement d’une banque digitale moderne**.

L’application permet :
- la gestion des **clients**
- la gestion des **prêts bancaires**
- la prise de **décisions basées sur l’IA**
- la génération de **rapports et graphiques**
- l’intégration d’un **système de prédiction du risque bancaire**

Le projet combine des concepts de :
- génie logiciel
- bases de données
- architectures web
- intelligence artificielle appliquée
- systèmes d’information bancaires

---

## 3. Fonctionnalités principales

### 3.1 Gestion des utilisateurs
- Authentification sécurisée
- Gestion des rôles :
  - Client
  - Agent bancaire
- Accès différencié selon le rôle

### 3.2 Gestion des clients
- Création et consultation des clients
- Affichage des informations financières
- Historique des opérations et des prêts

### 3.3 Gestion des prêts bancaires
- Création de prêts (immobilier, automobile, etc.)
- Calcul automatique :
  - mensualité
  - taux
  - durée
- Validation ou refus par l’agent bancaire

### 3.4 Module de prédiction par Intelligence Artificielle
- Évaluation du **risque de prêt**
- Basée sur une **régression logistique**
- Prend en compte plusieurs paramètres financiers
- Résultat retourné sous forme de score et de décision

### 3.5 Rapports et visualisation
- Génération automatique de graphiques :
  - distribution de l’endettement
  - évolution des risques
  - matrices de corrélation
- Intégration directe des graphiques dans l’interface Java EE

---

## 4. Technologies utilisées

### Backend principal (Gestion bancaire)
- Java EE (Servlets, JSP)
- Apache Tomcat
- JDBC
- MySQL
- JSTL
- JSON / GSON

### Module Intelligence Artificielle
- Python 3
- Flask (API REST)
- Scikit-learn
- Pandas
- Matplotlib
- Joblib
- Jupyter Notebook (phase de développement et tests)

### Frontend
- JSP
- HTML5
- CSS3

### Outils
- Eclipse IDE (Java EE)
- Jupyter Notebook
- Git / GitHub
- Visual Studio Code (optionnel)

---

## 5. Structure du dépôt GitHub

Gestion_bancaire/
│
├── backend-jee/
│ └── src/main/
│ ├── java/com/banque/
│ │ ├── dao/
│ │ ├── model/
│ │ ├── servlet/
│ │ ├── service/
│ │ └── util/
│ │
│ └── webapp/
│ ├── WEB-INF/
│ ├── agent_bancaire/
│ ├── client/
│ ├── css/
│ └── static/graphs/
│
├── ai-module/
│ ├── app_scheduler.py
│ ├── model_pret.pkl
│ ├── requirements.txt
│ ├── notebooks/
│ └── static/graphs/
│
├── .gitignore
├── README.md

yaml
Copy code

---

## 6. Communication Java EE ↔ Module IA

- Le backend Java EE communique avec le module IA via **requêtes HTTP REST**
- Les données sont envoyées au format **JSON**
- Flask traite la requête, interroge le modèle IA et retourne :
  - un score de risque
  - une décision (faible / moyen / élevé)

Cette approche reflète une **architecture microservice simplifiée**.

---

## 7. Sécurité et bonnes pratiques

- Séparation claire des couches
- DAO pour l’accès aux données
- Validation des entrées utilisateur
- Modèle IA isolé du backend principal
- Utilisation de `.gitignore` pour éviter les fichiers inutiles ou sensibles

---

## 8. Perspectives d’amélioration

- Ajout de Spring Boot
- Authentification JWT
- Déploiement Docker
- Tableau de bord analytique avancé
- Remplacement du modèle IA par un modèle plus complexe
- Journalisation avancée des décisions IA

---

## 9. Auteur

**Fathi Chaybi**  
Étudiant en cycle d’ingénierie – Systèmes informatiques & Intelligence Artificielle  
Projet académique – Application bancaire intelligente
