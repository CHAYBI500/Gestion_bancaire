package com.banque.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.banque.dao.ClientDAO;
import com.banque.dao.PretDAO;
import com.banque.model.Client;
import com.banque.model.Pret;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        ClientDAO dao = new ClientDAO();
        
        // Action: Voir détail prêt
        if ("detailPret".equals(action)) {
            String clientIdParam = request.getParameter("idClient");
            if (clientIdParam != null) {
                int clientId = Integer.parseInt(clientIdParam);
                PretDAO pretDAO = new PretDAO();
                
                List<Pret> pretsClient = pretDAO.findByClient(clientId);
                if (pretsClient != null && !pretsClient.isEmpty()) {
                    Pret premierPret = pretsClient.get(0);
                    request.setAttribute("pret", premierPret);
                    
                    Client client = dao.findById(clientId);
                    request.setAttribute("client", client);
                    
                    request.getRequestDispatcher("detailsprets.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Ce client n'a aucun prêt enregistré.");
                }
            }
        }
        
        // Action: Afficher formulaire d'ajout
        else if ("add".equals(action)) {
            request.getRequestDispatcher("clientForm.jsp").forward(request, response);
            return;
        }
        
        // Action: Afficher formulaire de modification
        else if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                Client client = dao.findById(id);
                request.setAttribute("client", client);
                request.getRequestDispatcher("clientForm.jsp").forward(request, response);
                return;
            }
        }
        
        // Action: Supprimer un client
        else if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                if (dao.delete(id)) {
                    request.setAttribute("successMessage", "Client supprimé avec succès !");
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de la suppression du client.");
                }
            }
        }
        
        // Affichage liste avec recherche
        String searchField = request.getParameter("searchField");
        String searchValue = request.getParameter("searchValue");
        
        if (searchField != null && searchValue != null && !searchValue.trim().isEmpty()) {
            request.setAttribute("clients", dao.search(searchField, searchValue));
        } else {
            request.setAttribute("clients", dao.findAll());
        }
        
        request.getRequestDispatcher("clients.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ClientDAO dao = new ClientDAO();
        
        // Action: Sauvegarder (ajout ou modification)
        if ("save".equals(action)) {
            try {
                Client client = new Client();
                
                String idParam = request.getParameter("idClient");
                if (idParam != null && !idParam.isEmpty()) {
                    client.setIdClient(Integer.parseInt(idParam));
                }
                
                client.setIdentifiantOriginal(Integer.parseInt(request.getParameter("identifiantOriginal")));
                client.setVille(request.getParameter("ville"));
                client.setCodePostal(request.getParameter("codePostal"));
                client.setRevenuMensuel(Double.parseDouble(request.getParameter("revenuMensuel")));
                
                boolean success;
                if (idParam != null && !idParam.isEmpty()) {
                    // Modification
                    success = dao.update(client);
                    if (success) {
                        request.setAttribute("successMessage", "Client modifié avec succès !");
                    } else {
                        request.setAttribute("errorMessage", "Erreur lors de la modification du client.");
                    }
                } else {
                    // Ajout
                    success = dao.add(client);
                    if (success) {
                        request.setAttribute("successMessage", "Client ajouté avec succès !");
                    } else {
                        request.setAttribute("errorMessage", "Erreur lors de l'ajout du client.");
                    }
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Erreur : " + e.getMessage());
            }
        }
        
        // Rediriger vers la liste
        request.setAttribute("clients", dao.findAll());
        request.getRequestDispatcher("clients.jsp").forward(request, response);
    }
}