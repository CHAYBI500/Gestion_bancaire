package com.banque.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.banque.dao.ClientDAO;
import com.banque.model.Client;
import com.banque.model.Pret;

@WebServlet("/aff_clients")
public class ClientAgentSer extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClientDAO dao = new ClientDAO();

        String searchField = request.getParameter("searchField");
        String searchValue = request.getParameter("searchValue");

        List<Client> clients;
        if (searchField != null && searchValue != null && !searchValue.trim().isEmpty()) {
            clients = dao.search(searchField, searchValue);
        } else {
            clients = dao.findAll();
        }

        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/agent_bancaire/clients.jsp").forward(request, response);
    }
}
