package com.banque.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.banque.dao.PretDAO;
import com.banque.dao.ClientDAO;
import com.banque.model.Pret;

@WebServlet("/agent_bancaire/prets")
public class AgentPretServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PretDAO pretDAO = new PretDAO();
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("detail".equals(action)) {
                showDetail(request, response);
            } else if ("byClient".equals(action)) {
                listByClient(request, response);
            } else {
                listAll(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Pret> prets = pretDAO.findAll();
        // Debug console pour vérifier si la liste contient des données
        System.out.println("DEBUG: Nombre de prets = " + (prets != null ? prets.size() : "NULL"));
        
        request.setAttribute("prets", prets != null ? prets : new ArrayList<>());
        request.getRequestDispatcher("/agent_bancaire/prets.jsp").forward(request, response);
    }

    private void listByClient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idClient = Integer.parseInt(request.getParameter("idClient"));
        request.setAttribute("prets", pretDAO.findByClient(idClient));
        request.setAttribute("client", clientDAO.findById(idClient));
        request.getRequestDispatcher("/agent_bancaire/prets.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idPret = Integer.parseInt(request.getParameter("id"));
        Pret pret = pretDAO.findById(idPret);
        request.setAttribute("pret", pret);
        if (pret != null) {
            request.setAttribute("client", clientDAO.findById(pret.getClientId()));
        }
        request.getRequestDispatcher("/agent_bancaire/detailPret.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirection simple pour éviter les erreurs sur un POST non autorisé
        response.sendRedirect(request.getContextPath() + "/agent_bancaire/prets");
    }
}