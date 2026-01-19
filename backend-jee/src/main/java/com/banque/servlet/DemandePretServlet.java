package com.banque.servlet;

import com.banque.dao.ClientDAO;
import com.banque.dao.PretDAO;
import com.banque.dao.DemandeDAO;
import com.banque.model.Client;
import com.banque.model.Pret;
import com.banque.model.DemandePret;
import com.banque.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DemandePretServlet")
public class DemandePretServlet extends HttpServlet {
    
    private PretDAO pretDAO = new PretDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private DemandeDAO demandeDAO = new DemandeDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Vérification de la session
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // =============================================
            // 1. RÉCUPÉRATION DES PARAMÈTRES
            // =============================================
            String typePret = request.getParameter("typePret");
            double montantSouhaite = Double.parseDouble(request.getParameter("montant"));
            int dureeMois = Integer.parseInt(request.getParameter("duree"));
            
            // Nouveaux paramètres du simulateur (option choisie)
            String tauxAnnuelStr = request.getParameter("tauxAnnuel");
            String mensualiteStr = request.getParameter("mensualite");
            
            // =============================================
            // 2. RÉCUPÉRATION DU REVENU CLIENT
            // =============================================
            Double revenu = (Double) session.getAttribute("clientRevenu");
            if (revenu == null) {
                Client client = clientDAO.findById(user.getId());
                if (client != null) {
                    revenu = client.getRevenuMensuel();
                    session.setAttribute("clientRevenu", revenu);
                } else {
                    revenu = 0.0;
                }
            }
            
            // =============================================
            // 3. CALCULS FINANCIERS
            // =============================================
            double tauxAnnuel = 0.0;
            double mensualite = 0.0;
            
            // Si le client a utilisé le simulateur (tauxAnnuel et mensualite fournis)
            if (tauxAnnuelStr != null && mensualiteStr != null && 
                !tauxAnnuelStr.isEmpty() && !mensualiteStr.isEmpty()) {
                
                // Utiliser les valeurs du simulateur
                tauxAnnuel = Double.parseDouble(tauxAnnuelStr);
                mensualite = Double.parseDouble(mensualiteStr);
                
            } else {
                // Calcul par défaut si pas de simulateur
                tauxAnnuel = (typePret.equals("IMMOBILIER")) ? 4.5 : 6.0;
                
                // Formule d'amortissement correcte
                double tauxMensuel = tauxAnnuel / 100 / 12;
                if (tauxMensuel > 0) {
                    mensualite = (montantSouhaite * tauxMensuel * Math.pow(1 + tauxMensuel, dureeMois)) / 
                                 (Math.pow(1 + tauxMensuel, dureeMois) - 1);
                } else {
                    mensualite = montantSouhaite / dureeMois;
                }
            }
            
            // Calcul du taux d'endettement (en décimal, ex: 0.25 = 25%)
            double tauxEndettement = 0.0;
            if (revenu > 0) {
                tauxEndettement = mensualite / revenu;
            }
            
            // =============================================
            // 4. CRÉATION DE LA DEMANDE
            // =============================================
            DemandePret demande = new DemandePret();
            demande.setClientId(user.getId());
            demande.setTypePret(typePret);
            demande.setMontantSouhaite(montantSouhaite);
            demande.setDureeMois(dureeMois);
            demande.setTauxEndettementCalcule(tauxEndettement);
            demande.setStatut("EN_ATTENTE");
            // Le niveau_risque sera calculé par l'IA Python automatiquement
            
            // =============================================
            // 5. ENREGISTREMENT DANS LA BASE
            // =============================================
            boolean success = demandeDAO.insererDemande(demande);
            
            if (success) {
                // Message de succès
                session.setAttribute("success", 
                    "✅ Votre demande de prêt a été soumise avec succès ! " +
                    "Notre système IA l'analysera automatiquement dans les prochaines minutes.");
                
                // Recharger les prêts pour le dashboard
                List<Pret> mesPrets = pretDAO.findByClient(user.getId());
                request.setAttribute("mesPrets", mesPrets);
                
                // Forward vers le dashboard avec le message de succès
                request.getRequestDispatcher("/client/dashboard.jsp").forward(request, response);
                
            } else {
                // Erreur d'enregistrement
                session.setAttribute("error", "❌ Erreur lors de l'enregistrement de votre demande.");
                response.sendRedirect(request.getContextPath() + "/client/services.jsp");
            }
            
        } catch (NumberFormatException e) {
            // Erreur de format des nombres
            e.printStackTrace();
            session.setAttribute("error", "⚠️ Erreur : Veuillez vérifier les montants saisis.");
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/client/services.jsp");
            }
            
        } catch (Exception e) {
            // Erreur générale
            e.printStackTrace();
            session.setAttribute("error", "❌ Erreur technique : " + e.getMessage());
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/client/services.jsp");
            }
        }
    }
}
