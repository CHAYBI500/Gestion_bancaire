package com.banque.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.banque.dao.PretDAO;
import com.banque.model.Pret;

@WebServlet("/DecisionServlet")
public class DecisionServlet extends HttpServlet {
    private PretDAO pretDAO = new PretDAO();

    // Affiche la page des demandes en attente
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Pret> demandes = pretDAO.findPending();
        request.setAttribute("demandesEnAttente", demandes);
        request.getRequestDispatcher("/Prets_approver.jsp").forward(request, response);
    }

    // Traite le bouton Approuver/Rejeter
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idPretStr = request.getParameter("idPret");
        String action = request.getParameter("decision"); 
        HttpSession session = request.getSession();

        if (idPretStr != null && action != null) {
            int idPret = Integer.parseInt(idPretStr);
            String nouveauStatut = action.equals("APPROUVE") ? "APPROUVE" : "REJETE";

            if (pretDAO.updateStatus(idPret, nouveauStatut)) {
                session.setAttribute("success", "Demande #" + idPret + " " + nouveauStatut);
            } else {
                session.setAttribute("error", "Échec de la mise à jour.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/DecisionServlet");
    }
}