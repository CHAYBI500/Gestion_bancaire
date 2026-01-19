package com.banque.servlet;

import com.banque.dao.PretDAO;
import com.banque.model.Pret;
import com.banque.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/userDash")
public class UserDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 1. Sécurité : Vérifier si l'utilisateur est bien connecté
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            PretDAO dao = new PretDAO();
            
            // 2. Récupérer les prêts via l'ID user (pas client_id)
            List<Pret> mesPrets = dao.findByUserId(user.getId());
            
            // 3. Calculer les statistiques
            int nombrePrets = dao.countByUserId(user.getId());
            double totalMontant = dao.getTotalMontantByUserId(user.getId());
            int pretsEnCours = dao.countEnCoursByUserId(user.getId());
            
            // 4. Envoyer les données à la JSP
            request.setAttribute("mesPrets", mesPrets);
            request.setAttribute("nombrePrets", nombrePrets);
            request.setAttribute("totalMontant", totalMontant);
            request.setAttribute("pretsEnCours", pretsEnCours);
            
            // 5. Rediriger vers le dashboard
            request.getRequestDispatcher("/client/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des données");
            request.getRequestDispatcher("/client/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}