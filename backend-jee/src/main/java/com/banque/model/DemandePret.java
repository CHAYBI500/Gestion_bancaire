package com.banque.model;

import java.sql.Timestamp;

public class DemandePret {
    private int idDemande;
    private int clientId;
    private String typePret;
    private double montantSouhaite;
    private int dureeMois;
    private double tauxEndettementCalcule;
    private String niveauRisque;
    private String statut; // EN_ATTENTE, APPROUVE, REJETE
    private Timestamp dateDemande;
    private String commentaireAdmin;
    
    // Constructeur vide
    public DemandePret() {}
    
    // Getters et Setters
    public int getIdDemande() { return idDemande; }
    public void setIdDemande(int idDemande) { this.idDemande = idDemande; }
    
    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }
    
    public String getTypePret() { return typePret; }
    public void setTypePret(String typePret) { this.typePret = typePret; }
    
    public double getMontantSouhaite() { return montantSouhaite; }
    public void setMontantSouhaite(double montantSouhaite) { 
        this.montantSouhaite = montantSouhaite; 
    }
    
    public int getDureeMois() { return dureeMois; }
    public void setDureeMois(int dureeMois) { this.dureeMois = dureeMois; }
    
    public double getTauxEndettementCalcule() { return tauxEndettementCalcule; }
    public void setTauxEndettementCalcule(double tauxEndettementCalcule) { 
        this.tauxEndettementCalcule = tauxEndettementCalcule; 
    }
    
    public String getNiveauRisque() { return niveauRisque; }
    public void setNiveauRisque(String niveauRisque) { 
        this.niveauRisque = niveauRisque; 
    }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public Timestamp getDateDemande() { return dateDemande; }
    public void setDateDemande(Timestamp dateDemande) { 
        this.dateDemande = dateDemande; 
    }
    
    public String getCommentaireAdmin() { return commentaireAdmin; }
    public void setCommentaireAdmin(String commentaireAdmin) { 
        this.commentaireAdmin = commentaireAdmin; 
    }
}