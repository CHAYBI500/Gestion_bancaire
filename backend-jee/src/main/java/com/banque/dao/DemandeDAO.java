package com.banque.dao;

import com.banque.model.DemandePret;
import com.banque.dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DemandeDAO {
    
    /**
     * Insère une nouvelle demande de prêt dans la table demandespret
     */
    public boolean insererDemande(DemandePret demande) {
        String sql = """
            INSERT INTO demandespret 
            (client_id, type_pret, montant_souhaite, duree_mois, 
             taux_endettement_calcule, statut, date_demande)
            VALUES (?, ?, ?, ?, ?, ?, NOW())
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, demande.getClientId());
            stmt.setString(2, demande.getTypePret());
            stmt.setDouble(3, demande.getMontantSouhaite());
            stmt.setInt(4, demande.getDureeMois());
            stmt.setDouble(5, demande.getTauxEndettementCalcule());
            stmt.setString(6, demande.getStatut());
            
            int rows = stmt.executeUpdate();
            
            if (rows > 0) {
                // Récupérer l'ID généré
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    demande.setIdDemande(generatedKeys.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    
    /**
     * Récupère toutes les demandes d'un client
     */
    public List<DemandePret> getDemandesParClient(int clientId) {
        List<DemandePret> demandes = new ArrayList<>();
        String sql = """
            SELECT * FROM demandespret 
            WHERE client_id = ? 
            ORDER BY date_demande DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, clientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                DemandePret d = new DemandePret();
                d.setIdDemande(rs.getInt("id_demande"));
                d.setClientId(rs.getInt("client_id"));
                d.setTypePret(rs.getString("type_pret"));
                d.setMontantSouhaite(rs.getDouble("montant_souhaite"));
                d.setDureeMois(rs.getInt("duree_mois"));
                d.setTauxEndettementCalcule(rs.getDouble("taux_endettement_calcule"));
                d.setNiveauRisque(rs.getString("niveau_risque"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                d.setCommentaireAdmin(rs.getString("commentaire_admin"));
                
                demandes.add(d);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return demandes;
    }
    
    
    /**
     * Récupère toutes les demandes EN_ATTENTE
     */
    public List<DemandePret> getDemandesEnAttente() {
        List<DemandePret> demandes = new ArrayList<>();
        String sql = """
            SELECT d.*, c.nom, c.prenom, c.revenu_mensuel
            FROM demandespret d
            JOIN client c ON d.client_id = c.id_client
            WHERE d.statut = 'EN_ATTENTE'
            ORDER BY d.date_demande DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                DemandePret d = new DemandePret();
                d.setIdDemande(rs.getInt("id_demande"));
                d.setClientId(rs.getInt("client_id"));
                d.setTypePret(rs.getString("type_pret"));
                d.setMontantSouhaite(rs.getDouble("montant_souhaite"));
                d.setDureeMois(rs.getInt("duree_mois"));
                d.setTauxEndettementCalcule(rs.getDouble("taux_endettement_calcule"));
                d.setNiveauRisque(rs.getString("niveau_risque"));
                d.setStatut(rs.getString("statut"));
                d.setDateDemande(rs.getTimestamp("date_demande"));
                
                demandes.add(d);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return demandes;
    }
    
    
    /**
     * Met à jour le statut d'une demande (APPROUVE/REJETE)
     */
    public boolean updateStatut(int idDemande, String nouveauStatut, String commentaire) {
        String sql = """
            UPDATE demandespret 
            SET statut = ?, commentaire_admin = ?
            WHERE id_demande = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nouveauStatut);
            stmt.setString(2, commentaire);
            stmt.setInt(3, idDemande);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
