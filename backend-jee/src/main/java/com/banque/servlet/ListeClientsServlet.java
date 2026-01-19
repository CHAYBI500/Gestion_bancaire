package com.banque.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.banque.dao.ClientDAO;
import com.banque.model.Client;

@WebServlet("/ListeClientsServlet")
public class ListeClientsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || !"AGENT".equals(session.getAttribute("role"))){
            response.sendRedirect("error/accessDenied.jsp");
            return;
        }

        ClientDAO clientDAO = new ClientDAO();
        List<Client> clients = clientDAO.findAll();

        request.setAttribute("clients", clients);
        request.getRequestDispatcher("agent/consulterClients.jsp")
               .forward(request, response);
    }
}
