package com.banque.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.banque.dao.PredictionRisqueDAO;
import com.banque.model.PredictionRisque;

@WebServlet("/prediction")
public class PredictionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PredictionRisqueDAO predictionDao;

    @Override
    public void init() throws ServletException {
        super.init();
        predictionDao = new PredictionRisqueDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("=== DEBUG: PredictionServlet.doGet() appelé ===");
        
        // Récupérer TOUTES les prédictions
        List<PredictionRisque> predictions = predictionDao.findAll();
        System.out.println("DEBUG: Nombre de prédictions récupérées: " + 
                          (predictions != null ? predictions.size() : "null"));
        
        // Passer la liste à la JSP avec le bon nom d'attribut (pluriel)
        request.setAttribute("predictions", predictions);
        
        // Forward vers la page de liste des prédictions
        request.getRequestDispatcher("prediction.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}