package com.banque.model;

import java.sql.Timestamp;

public class PredictionRisque {

    private int idPrediction;
    private int pretId;                  // correspond à pret_id
    private double tauxEndettement;
    private String niveauRisque;
    private double scoreConfiance;
    private Timestamp datePrediction;
    private Double probaFaible;
    private Double probaMoyen;
    private Double probaEleve;
    private String modeleVersion;

    // ----- Getters et Setters -----

    public int getIdPrediction() {
        return idPrediction;
    }

    public void setIdPrediction(int idPrediction) {
        this.idPrediction = idPrediction;
    }

    public int getPretId() {
        return pretId;
    }

    public void setPretId(int pretId) {
        this.pretId = pretId;
    }

    public double getTauxEndettement() {
        return tauxEndettement;
    }

    public void setTauxEndettement(double tauxEndettement) {
        this.tauxEndettement = tauxEndettement;
    }

    public String getNiveauRisque() {
        return niveauRisque;
    }

    public void setNiveauRisque(String niveauRisque) {
        this.niveauRisque = niveauRisque;
    }

    public double getScoreConfiance() {
        return scoreConfiance;
    }

    public void setScoreConfiance(double scoreConfiance) {
        this.scoreConfiance = scoreConfiance;
    }

    public Timestamp getDatePrediction() {
        return datePrediction;
    }

    public void setDatePrediction(Timestamp datePrediction) {
        this.datePrediction = datePrediction;
    }

    public Double getProbaFaible() {
        return probaFaible;
    }

    public void setProbaFaible(Double probaFaible) {
        this.probaFaible = probaFaible;
    }

    public Double getProbaMoyen() {
        return probaMoyen;
    }

    public void setProbaMoyen(Double probaMoyen) {
        this.probaMoyen = probaMoyen;
    }

    public Double getProbaEleve() {
        return probaEleve;
    }

    public void setProbaEleve(Double probaEleve) {
        this.probaEleve = probaEleve;
    }

    public String getModeleVersion() {
        return modeleVersion;
    }

    public void setModeleVersion(String modeleVersion) {
        this.modeleVersion = modeleVersion;
    }

}
