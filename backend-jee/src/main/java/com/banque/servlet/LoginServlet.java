package com.banque.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.banque.dao.UserDAO;
import com.banque.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            String role = user.getRole();

            // 🔐 Redirection vers les SERVLETS de Dashboard (pas les JSP directes)
            if ("ADMIN".equals(role)) {
                // Si tu as une servlet AdminDashServlet, mets son URL ici
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else if ("AGENT".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/agent_bancaire/dashboard.jsp");
            } else if ("user".equals(role)) {
                // ✅ On pointe vers l'URL de ta servlet UserDashboardServlet
                response.sendRedirect(request.getContextPath() + "/client/dashboard.jsp");
            }
        } else {
            // Cas d'échec de connexion
            request.setAttribute("error", "Login ou mot de passe incorrect");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}