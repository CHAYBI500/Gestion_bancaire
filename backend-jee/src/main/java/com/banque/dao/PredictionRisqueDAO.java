package com.banque.dao;

import com.banque.model.PredictionRisque;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PredictionRisqueDAO {
    
    /**
     * Récupère toutes les prédictions de la table prediction_risque
     */
    public List<PredictionRisque> findAll() {
        List<PredictionRisque> list = new ArrayList<>();
        String sql = "SELECT * FROM prediction_risque ORDER BY date_prediction DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("=== DEBUG: Exécution de la requête findAll() ===");
            
            while (rs.next()) {
                PredictionRisque pr = new PredictionRisque();
                pr.setIdPrediction(rs.getInt("id_prediction"));
                pr.setPretId(rs.getInt("pret_id"));
                pr.setTauxEndettement(rs.getDouble("taux_endettement"));
                pr.setNiveauRisque(rs.getString("niveau_risque"));
                pr.setScoreConfiance(rs.getDouble("score_confiance"));
                pr.setDatePrediction(rs.getTimestamp("date_prediction"));
                
                // Gérer le cas où modele_version peut être NULL
                String modeleVersion = rs.getString("modele_version");
                pr.setModeleVersion(modeleVersion != null ? modeleVersion : "v1.0");
                
                // Colonnes optionnelles (peuvent être NULL)
                try {
                    Double probaFaible = rs.getDouble("proba_faible");
                    if (!rs.wasNull()) pr.setProbaFaible(probaFaible);
                } catch (SQLException e) {
                    // Colonne n'existe pas
                }
                
                try {
                    Double probaMoyen = rs.getDouble("proba_moyen");
                    if (!rs.wasNull()) pr.setProbaMoyen(probaMoyen);
                } catch (SQLException e) {
                    // Colonne n'existe pas
                }
                
                try {
                    Double probaEleve = rs.getDouble("proba_eleve");
                    if (!rs.wasNull()) pr.setProbaEleve(probaEleve);
                } catch (SQLException e) {
                    // Colonne n'existe pas
                }
                
                list.add(pr);
                System.out.println("DEBUG: Prédiction trouvée - ID: " + pr.getIdPrediction() + 
                                   ", Prêt: " + pr.getPretId() + 
                                   ", Risque: " + pr.getNiveauRisque());
            }
            
            System.out.println("DEBUG: Nombre total de prédictions trouvées: " + list.size());
            
        } catch (SQLException e) {
            System.err.println("ERREUR dans findAll(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Récupère une prédiction par ID de prêt
     */
    public PredictionRisque findByPretId(int pretId) {
        String sql = "SELECT * FROM prediction_risque WHERE pret_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pretId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                PredictionRisque pr = new PredictionRisque();
                pr.setIdPrediction(rs.getInt("id_prediction"));
                pr.setPretId(rs.getInt("pret_id"));
                pr.setTauxEndettement(rs.getDouble("taux_endettement"));
                pr.setNiveauRisque(rs.getString("niveau_risque"));
                pr.setScoreConfiance(rs.getDouble("score_confiance"));
                pr.setDatePrediction(rs.getTimestamp("date_prediction"));
                
                String modeleVersion = rs.getString("modele_version");
                pr.setModeleVersion(modeleVersion != null ? modeleVersion : "v1.0");
                
                // Colonnes optionnelles
                try {
                    Double probaFaible = rs.getDouble("proba_faible");
                    if (!rs.wasNull()) pr.setProbaFaible(probaFaible);
                } catch (SQLException e) {}
                
                try {
                    Double probaMoyen = rs.getDouble("proba_moyen");
                    if (!rs.wasNull()) pr.setProbaMoyen(probaMoyen);
                } catch (SQLException e) {}
                
                try {
                    Double probaEleve = rs.getDouble("proba_eleve");
                    if (!rs.wasNull()) pr.setProbaEleve(probaEleve);
                } catch (SQLException e) {}
                
                return pr;
            }
        } catch (SQLException e) {
            System.err.println("ERREUR dans findByPretId(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Compte le nombre total de prédictions
     */
    public int count() {
        String sql = "SELECT COUNT(*) as total FROM prediction_risque";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("ERREUR dans count(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
}