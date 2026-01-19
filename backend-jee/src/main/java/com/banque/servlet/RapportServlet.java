package com.banque.servlet;

import java.util.List;
import com.banque.model.Pret;
import com.banque.dao.PretDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.banque.service.FlaskReportService;

@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {

    private PretDAO pretDAO = new PretDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Pret> listePrets = pretDAO.findAll();
        request.setAttribute("prets", listePrets);

        // 🔹 NOUVEAU : Rapport IA Flask
        JSONObject flaskReport = FlaskReportService.getReport();
        request.setAttribute("flaskReport", flaskReport);

        request.getRequestDispatcher("/rapports.jsp").forward(request, response);
    }
}
