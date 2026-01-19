package com.banque.model;

import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

public class Notification {

    private int id;
    private String type;
    private String titre;
    private String message;
    private int idPret;
    private String niveauRisque;
    private Timestamp createdAt;

    // Champ dérivé (non stocké en base)
    private String createdAtFormatted;

    /* =======================
       Getters & Setters
       ======================= */

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getIdPret() {
        return idPret;
    }

    public void setIdPret(int idPret) {
        this.idPret = idPret;
    }

    public String getNiveauRisque() {
        return niveauRisque;
    }

    public void setNiveauRisque(String niveauRisque) {
        this.niveauRisque = niveauRisque;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;

        // Formatage automatique de la date
        if (createdAt != null) {
            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            this.createdAtFormatted =
                    createdAt.toLocalDateTime().format(formatter);
        }
    }

    public String getCreatedAtFormatted() {
        return createdAtFormatted;
    }
}
