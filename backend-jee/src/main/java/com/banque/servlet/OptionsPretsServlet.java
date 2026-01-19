package com.banque.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;

@WebServlet("/OptionsPretsServlet")
public class OptionsPretsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pret_bancaires?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        Gson gson = new Gson();
        
        // Vérification de la session
        HttpSession session = request.getSession(false);
        if (session == null || !"AGENT".equals(session.getAttribute("role"))) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Session expirée ou accès non autorisé");
            response.getWriter().write(gson.toJson(error));
            return;
        }
        
        String clientIdStr = request.getParameter("idClient");
        String typePret = request.getParameter("typePret");
        String montantStr = request.getParameter("montant");
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            int clientId = Integer.parseInt(clientIdStr);
            double montantSouhaite = Double.parseDouble(montantStr);
            
            // Connexion à la base de données
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Récupérer les informations du client
            String sql = "SELECT identifiant_original, ville, revenu_mensuel FROM client WHERE id_client = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, clientId);
            rs = ps.executeQuery();
            
            if (!rs.next()) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Client introuvable avec l'ID " + clientId);
                response.getWriter().write(gson.toJson(error));
                return;
            }
            
            int identifiantOriginal = rs.getInt("identifiant_original");
            String ville = rs.getString("ville");
            double revenuMensuel = rs.getDouble("revenu_mensuel");
            
            // Calculer un credit score basique
            int creditScore = calculerCreditScore(revenuMensuel);
            
            // Générer les options
            Map<String, Object> result = new HashMap<>();
            result.put("clientNom", "Client #" + identifiantOriginal + " - " + ville);
            result.put("revenuMensuel", revenuMensuel);
            result.put("creditScore", creditScore);
            
            List<Map<String, Object>> options = genererOptions(typePret, montantSouhaite, revenuMensuel, creditScore);
            result.put("options", options);
            
            // Déterminer la recommandation
            int indexRecommande = determinerRecommandation(options, revenuMensuel, creditScore);
            result.put("recommande", indexRecommande);
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (NumberFormatException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Format de données invalide");
            response.getWriter().write(gson.toJson(error));
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de l'analyse: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    /**
     * Génère les différentes options de prêt
     */
    private List<Map<String, Object>> genererOptions(String typePret, double montant, double revenu, int creditScore) {
        List<Map<String, Object>> options = new ArrayList<>();
        
        double tauxBase = typePret.equals("IMMOBILIER") ? 4.50 : 6.75;
        
        // OPTION 1: Remboursement Accéléré
        int duree1 = typePret.equals("IMMOBILIER") ? 120 : 36;
        double taux1 = tauxBase - 0.50;
        options.add(creerOption(
            "Remboursement Accéléré",
            "Taux préférentiel pour un remboursement rapide",
            "flash",
            montant, duree1, taux1, revenu
        ));
        
        // OPTION 2: Formule Équilibrée
        int duree2 = typePret.equals("IMMOBILIER") ? 180 : 60;
        options.add(creerOption(
            "Formule Équilibrée",
            "Équilibre optimal entre mensualité et coût total",
            "balance",
            montant, duree2, tauxBase, revenu
        ));
        
        // OPTION 3: Confort Mensuel
        int duree3 = typePret.equals("IMMOBILIER") ? 240 : 84;
        double taux3 = tauxBase + 0.25;
        options.add(creerOption(
            "Confort Mensuel",
            "Mensualités allégées pour plus de flexibilité budgétaire",
            "calendar",
            montant, duree3, taux3, revenu
        ));
        
        // OPTION 4: Privilège Premium (si bon credit score)
        if (creditScore >= 700) {
            int duree4 = typePret.equals("IMMOBILIER") ? 150 : 48;
            double taux4 = tauxBase - 0.75;
            options.add(creerOption(
                "Privilège Premium",
                "Conditions exceptionnelles pour profil d'excellence",
                "crown",
                montant, duree4, taux4, revenu
            ));
        }
        
        return options;
    }
    
    /**
     * Crée une Map représentant une option de prêt
     */
    private Map<String, Object> creerOption(String nom, String description, String icone,
                                           double montant, int duree, double taux, double revenu) {
        Map<String, Object> option = new HashMap<>();
        
        // Calcul de la mensualité
        double tauxMensuel = taux / 100 / 12;
        double mensualite;
        
        if (tauxMensuel == 0) {
            mensualite = montant / duree;
        } else {
            mensualite = montant * (tauxMensuel * Math.pow(1 + tauxMensuel, duree)) 
                        / (Math.pow(1 + tauxMensuel, duree) - 1);
        }
        
        double coutTotal = mensualite * duree;
        double interets = coutTotal - montant;
        double tauxEndettement = (mensualite / revenu) * 100;
        
        // Calcul du score de qualité
        int score = calculerScoreOption(tauxEndettement, taux, duree, montant);
        
        option.put("nom", nom);
        option.put("description", description);
        option.put("icone", icone);
        option.put("duree", duree);
        option.put("taux", Math.round(taux * 100.0) / 100.0);
        option.put("mensualite", Math.round(mensualite * 100.0) / 100.0);
        option.put("coutTotal", Math.round(coutTotal * 100.0) / 100.0);
        option.put("interets", Math.round(interets * 100.0) / 100.0);
        option.put("tauxEndettement", Math.round(tauxEndettement * 100.0) / 100.0);
        option.put("score", score);
        
        return option;
    }
    
    /**
     * Calcule un score de qualité pour une option (0-100)
     */
    private int calculerScoreOption(double tauxEndettement, double taux, int duree, double montant) {
        int score = 85; // Score de base
        
        // Critère 1: Taux d'endettement (le plus important)
        if (tauxEndettement < 20) {
            score += 15;
        } else if (tauxEndettement < 25) {
            score += 10;
        } else if (tauxEndettement < 30) {
            score += 5;
        } else if (tauxEndettement < 33) {
            score += 0;
        } else if (tauxEndettement < 40) {
            score -= 15;
        } else {
            score -= 30;
        }
        
        // Critère 2: Taux d'intérêt
        if (taux < 4.0) {
            score += 10;
        } else if (taux < 5.0) {
            score += 5;
        } else if (taux > 7.0) {
            score -= 10;
        }
        
        // Critère 3: Durée raisonnable
        if (duree <= 120) {
            score += 5;
        } else if (duree > 240) {
            score -= 5;
        }
        
        return Math.max(0, Math.min(100, score));
    }
    
    /**
     * Détermine l'index de l'option recommandée
     */
    private int determinerRecommandation(List<Map<String, Object>> options, double revenu, int creditScore) {
        int meilleurIndex = 0;
        double meilleurScore = 0;
        
        for (int i = 0; i < options.size(); i++) {
            Map<String, Object> option = options.get(i);
            
            double score = ((Number) option.get("score")).doubleValue();
            double tauxEndettement = ((Number) option.get("tauxEndettement")).doubleValue();
            String nom = (String) option.get("nom");
            
            // Bonus pour clients premium
            if (creditScore >= 700 && nom.contains("Premium")) {
                score += 15;
            }
            
            // Bonus pour taux d'endettement très faible
            if (tauxEndettement < 20) {
                score += 10;
            }
            
            // Pénalité si taux d'endettement trop élevé
            if (tauxEndettement > 35) {
                score -= 25;
            }
            
            // Bonus pour option équilibrée
            if (nom.contains("Équilibrée")) {
                score += 5;
            }
            
            if (score > meilleurScore) {
                meilleurScore = score;
                meilleurIndex = i;
            }
        }
        
        return meilleurIndex;
    }
    
    /**
     * Calcule un credit score basique basé sur le revenu
     */
    private int calculerCreditScore(double revenuMensuel) {
        if (revenuMensuel >= 15000) {
            return 750 + (int)(Math.random() * 100); // 750-850
        } else if (revenuMensuel >= 10000) {
            return 700 + (int)(Math.random() * 50);  // 700-750
        } else if (revenuMensuel >= 6000) {
            return 650 + (int)(Math.random() * 50);  // 650-700
        } else if (revenuMensuel >= 4000) {
            return 600 + (int)(Math.random() * 50);  // 600-650
        } else {
            return 550 + (int)(Math.random() * 50);  // 550-600
        }
    }
}