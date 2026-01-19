package com.banque.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.banque.dao.PretDAO;
import com.banque.dao.ClientDAO;
import com.banque.model.Pret;
import com.banque.model.Client;

@WebServlet("/prets")
public class PretServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PretDAO pretDAO;
    private ClientDAO clientDAO;

    public PretServlet() {
        super();
        this.pretDAO = new PretDAO();
        this.clientDAO = new ClientDAO(); // Assure-toi que ClientDAO existe
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listPrets(request, response);
                break;
            case "detail":
                showPretDetail(request, response);
                break;
            case "byClient":
                listPretsByClient(request, response);
                break;
            case "delete":
                deletePret(request, response);
                break;
            default:
                listPrets(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPret(request, response);
        } else if ("update".equals(action)) {
            updatePret(request, response);
        } else {
            doGet(request, response);
        }
    }

    // ------------------- LIST PRETS -------------------
    private void listPrets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Pret> prets = pretDAO.findAll();
        request.setAttribute("prets", prets);
        request.getRequestDispatcher("/prets.jsp").forward(request, response);
    }

    // ------------------- LIST PRETS BY CLIENT -------------------
    private void listPretsByClient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idClient = Integer.parseInt(request.getParameter("idClient"));
            List<Pret> prets = pretDAO.findByClient(idClient);
            request.setAttribute("prets", prets);
            request.setAttribute("idClient", idClient);
            request.getRequestDispatcher("/prets.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID client invalide");
            listPrets(request, response);
        }
    }

    // ------------------- DETAIL PRET -------------------
    private void showPretDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPret = Integer.parseInt(request.getParameter("id"));
            Pret pret = pretDAO.findById(idPret);

            if (pret != null) {
                // Récupérer le client lié
                Client client = clientDAO.findById(pret.getClientId());

                request.setAttribute("pret", pret);
                request.setAttribute("client", client); // <- essentiel pour la JSP
                request.getRequestDispatcher("/detailPret.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Prêt introuvable");
                listPrets(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID prêt invalide");
            listPrets(request, response);
        }
    }

    // ------------------- CREATE PRET -------------------
    private void createPret(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Pret pret = new Pret();
            pret.setClientId(Integer.parseInt(request.getParameter("clientId")));
            pret.setTypePret(request.getParameter("typePret"));
            pret.setDureeMois(Integer.parseInt(request.getParameter("dureeMois")));
            pret.setTauxAnnuel(Double.parseDouble(request.getParameter("tauxAnnuel")));
            pret.setMensualite(Double.parseDouble(request.getParameter("mensualite")));

            pretDAO.save(pret);
            request.setAttribute("success", "Prêt créé avec succès");
            listPrets(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création: " + e.getMessage());
            listPrets(request, response);
        }
    }

    // ------------------- UPDATE PRET -------------------
    private void updatePret(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Pret pret = new Pret();
            pret.setIdPret(Integer.parseInt(request.getParameter("idPret")));
            pret.setClientId(Integer.parseInt(request.getParameter("clientId")));
            pret.setTypePret(request.getParameter("typePret"));
            pret.setDureeMois(Integer.parseInt(request.getParameter("dureeMois")));
            pret.setTauxAnnuel(Double.parseDouble(request.getParameter("tauxAnnuel")));
            pret.setMensualite(Double.parseDouble(request.getParameter("mensualite")));

            pretDAO.update(pret);
            request.setAttribute("success", "Prêt modifié avec succès");
            listPrets(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            listPrets(request, response);
        }
    }

    // ------------------- DELETE PRET -------------------
    private void deletePret(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPret = Integer.parseInt(request.getParameter("id"));
            pretDAO.delete(idPret);
            request.setAttribute("success", "Prêt supprimé avec succès");
            listPrets(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
            listPrets(request, response);
        }
    }
    
}
