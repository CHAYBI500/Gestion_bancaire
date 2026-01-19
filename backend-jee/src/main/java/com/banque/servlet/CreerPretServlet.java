package com.banque.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CreerPretServlet")
public class CreerPretServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Configuration de la base de données
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pret_bancaires?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Encodage UTF-8 pour les caractères spéciaux
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Vérification de la session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"AGENT".equals(role)) {
            String errorMsg = "Accès refusé. Seuls les agents bancaires peuvent créer des demandes de prêt.";
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/dashboard.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            return;
        }
        
        // Récupération des paramètres
        String clientIdStr = request.getParameter("idClient");
        String typePret = request.getParameter("typePret");
        String montantStr = request.getParameter("montant");
        String dureeStr = request.getParameter("duree");
        String tauxStr = request.getParameter("taux");
        
        Connection conn = null;
        PreparedStatement psCheckClient = null;
        PreparedStatement psInsert = null;
        PreparedStatement psGetRevenu = null;
        ResultSet rsClient = null;
        ResultSet rsRevenu = null;
        
        try {
            // Validation des données d'entrée
            if (clientIdStr == null || typePret == null || montantStr == null || 
                dureeStr == null || tauxStr == null) {
                throw new IllegalArgumentException("Tous les champs sont obligatoires");
            }
            
            int clientId = Integer.parseInt(clientIdStr);
            double montant = Double.parseDouble(montantStr);
            int duree = Integer.parseInt(dureeStr);
            double taux = Double.parseDouble(tauxStr);
            
            // Validation métier
            if (montant < 1000) {
                throw new IllegalArgumentException("Le montant minimum est de 1 000 DH");
            }
            
            if (duree < 1 || duree > 360) {
                throw new IllegalArgumentException("La durée doit être comprise entre 1 et 360 mois");
            }
            
            if (!typePret.equals("IMMOBILIER") && !typePret.equals("AUTOMOBILE")) {
                throw new IllegalArgumentException("Type de prêt invalide");
            }
            
            // Connexion à la base de données
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Vérifier si le client existe
            String sqlCheckClient = "SELECT id_client FROM client WHERE id_client = ?";
            psCheckClient = conn.prepareStatement(sqlCheckClient);
            psCheckClient.setInt(1, clientId);
            rsClient = psCheckClient.executeQuery();
            
            if (!rsClient.next()) {
                throw new IllegalArgumentException(
                    "Client introuvable avec l'ID " + clientId + ". Veuillez vérifier l'identifiant.");
            }
            
            // Récupérer le revenu du client pour calculer le taux d'endettement
            String sqlRevenu = "SELECT revenu_mensuel FROM client WHERE id_client = ?";
            psGetRevenu = conn.prepareStatement(sqlRevenu);
            psGetRevenu.setInt(1, clientId);
            rsRevenu = psGetRevenu.executeQuery();
            
            double revenuMensuel = 0;
            String niveauRisque = "MOYEN";
            double tauxEndettement = 0.0;
            
            if (rsRevenu.next()) {
                revenuMensuel = rsRevenu.getDouble("revenu_mensuel");
                
                // Calcul de la mensualité
                double tauxMensuel = taux / 100 / 12;
                double mensualite;
                
                if (tauxMensuel == 0) {
                    mensualite = montant / duree;
                } else {
                    mensualite = montant * (tauxMensuel * Math.pow(1 + tauxMensuel, duree)) 
                                / (Math.pow(1 + tauxMensuel, duree) - 1);
                }
                
                // Calcul du taux d'endettement
                if (revenuMensuel > 0) {
                    tauxEndettement = mensualite / revenuMensuel;
                    
                    // Détermination du niveau de risque
                    if (tauxEndettement < 0.25) {
                        niveauRisque = "Faible";
                    } else if (tauxEndettement < 0.33) {
                        niveauRisque = "Moyen";
                    } else {
                        niveauRisque = "Élevé";
                    }
                }
            }
            
            // Insertion de la demande de prêt
            String sqlInsert = "INSERT INTO demandespret " +
                             "(client_id, type_pret, montant_souhaite, duree_mois, " +
                             "taux_endettement_calcule, niveau_risque, statut, date_demande) " +
                             "VALUES (?, ?, ?, ?, ?, ?, 'EN_ATTENTE', NOW())";
            
            psInsert = conn.prepareStatement(sqlInsert);
            psInsert.setInt(1, clientId);
            psInsert.setString(2, typePret);
            psInsert.setDouble(3, montant);
            psInsert.setInt(4, duree);
            psInsert.setDouble(5, tauxEndettement);
            psInsert.setString(6, niveauRisque);
            
            int rowsAffected = psInsert.executeUpdate();
            
            if (rowsAffected > 0) {
                // Message de succès détaillé
                String typePretLabel = typePret.equals("IMMOBILIER") ? "Immobilier" : "Automobile";
                String successMsg = String.format(
                    "✅ Demande de prêt créée avec succès ! " +
                    "Type: %s | Montant: %.0f DH | Durée: %d mois | " +
                    "Taux d'endettement: %.1f%% | Risque: %s | " +
                    "Statut: En attente de validation administrative",
                    typePretLabel, montant, duree, (tauxEndettement * 100), niveauRisque
                );
                
                response.sendRedirect(request.getContextPath() + 
                    "/agent_bancaire/dashboard.jsp?success=" + URLEncoder.encode(successMsg, "UTF-8"));
            } else {
                throw new SQLException("Échec de l'insertion en base de données");
            }
            
        } catch (NumberFormatException e) {
            String errorMsg = "❌ Données invalides. Veuillez vérifier que tous les champs numériques sont correctement renseignés.";
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/CreerPret.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            
        } catch (IllegalArgumentException e) {
            String errorMsg = "❌ " + e.getMessage();
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/CreerPret.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            String errorMsg = "❌ Erreur technique : Driver MySQL introuvable. Contactez l'administrateur.";
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/CreerPret.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = "❌ Erreur de base de données : " + e.getMessage();
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/CreerPret.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "❌ Erreur inattendue : " + e.getMessage();
            response.sendRedirect(request.getContextPath() + 
                "/agent_bancaire/CreerPret.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            
        } finally {
            // Fermeture sécurisée des ressources
            try { if (rsRevenu != null) rsRevenu.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (rsClient != null) rsClient.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psGetRevenu != null) psGetRevenu.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psCheckClient != null) psCheckClient.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psInsert != null) psInsert.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Rediriger vers le formulaire
        response.sendRedirect(request.getContextPath() + "/agent_bancaire/CreerPret.jsp");
    }
}