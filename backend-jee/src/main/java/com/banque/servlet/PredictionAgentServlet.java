package com.banque.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.banque.dao.PredictionRisqueDAO;
import com.banque.model.PredictionRisque;

@WebServlet("/Agent_prediction")
public class PredictionAgentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PredictionRisqueDAO predictionDao;

    @Override
    public void init() throws ServletException {
        super.init();
        predictionDao = new PredictionRisqueDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupérer la liste complète des prédictions depuis le DAO
        List<PredictionRisque> predictions = predictionDao.findAll();
        
        // On transmet la liste complète : la JSP s'occupe de la pagination et des stats
        request.setAttribute("predictions", predictions);
        
        // Forward vers la JSP (ajustez le chemin si nécessaire)
        request.getRequestDispatcher("/agent_bancaire/prediction.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}