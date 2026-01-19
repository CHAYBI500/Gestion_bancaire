package com.banque.model;

public class Pret {
    // Informations sur le prêt
    private int idPret;
    private int clientId;           // Identifiant client (int)
    private String typePret;
    private int dureeMois;
    private double tauxAnnuel;
    private double mensualite;
    private double tauxEndettement;
    private String niveauRisque;    // ⚠️ Nouveau champ pour le niveau de risque
    private String statut;

    // Informations du client (pour affichage)
    private String clientIdentifiant;  // Peut être un identifiant externe (String)
    private String clientVille;
    private double clientRevenu;
    
    // Constructeurs
    public Pret() {}
    
    public Pret(int idPret, int clientId, String typePret, int dureeMois, double tauxAnnuel,
                double mensualite, double tauxEndettement, String niveauRisque,
                String clientIdentifiant, String clientVille, double clientRevenu) {
        this.idPret = idPret;
        this.clientId = clientId;
        this.typePret = typePret;
        this.dureeMois = dureeMois;
        this.tauxAnnuel = tauxAnnuel;
        this.mensualite = mensualite;
        this.tauxEndettement = tauxEndettement;
        this.niveauRisque = niveauRisque;
        this.clientIdentifiant = clientIdentifiant;
        this.clientVille = clientVille;
        this.clientRevenu = clientRevenu;
    }
    
    // =======================
    // Getters et Setters
    // =======================
    public int getIdPret() { return idPret; }
    public void setIdPret(int idPret) { this.idPret = idPret; }
    
    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }
    
    public String getTypePret() { return typePret; }
    public void setTypePret(String typePret) { this.typePret = typePret; }
    
    public int getDureeMois() { return dureeMois; }
    public void setDureeMois(int dureeMois) { this.dureeMois = dureeMois; }
    
    public double getTauxAnnuel() { return tauxAnnuel; }
    public void setTauxAnnuel(double tauxAnnuel) { this.tauxAnnuel = tauxAnnuel; }
    
    public double getMensualite() { return mensualite; }
    public void setMensualite(double mensualite) { this.mensualite = mensualite; }
    
    public double getTauxEndettement() { return tauxEndettement; }
    public void setTauxEndettement(double tauxEndettement) { this.tauxEndettement = tauxEndettement; }
    
    public String getNiveauRisque() {
        return niveauRisque;
    }
    public void setNiveauRisque(String niveauRisque) {
        this.niveauRisque = niveauRisque;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getClientIdentifiant() { return clientIdentifiant; }
    public void setClientIdentifiant(String clientIdentifiant) { this.clientIdentifiant = clientIdentifiant; }
    
    public String getClientVille() { return clientVille; }
    public void setClientVille(String clientVille) { this.clientVille = clientVille; }
    
    public double getClientRevenu() { return clientRevenu; }
    public void setClientRevenu(double clientRevenu) { this.clientRevenu = clientRevenu; }
    
    // =======================
    // Méthodes utilitaires
    // =======================
    public double getMontantTotal() {
        return mensualite * dureeMois;
    }
    
    public double getTauxEndettementPourcentage() {
        return tauxEndettement * 100;
    }
}
