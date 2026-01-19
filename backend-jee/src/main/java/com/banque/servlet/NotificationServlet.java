package com.banque.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.banque.dao.NotificationDAO;
import com.banque.model.Notification;
import com.google.gson.Gson;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        List<Notification> notifications = notificationDAO.findUnread();
        
        Map<String, Object> result = new HashMap<>();
        result.put("count", notifications.size());
        result.put("notifications", notifications);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // CORRECTION : Convertir le Map en JSON et l'écrire dans la réponse
        String json = gson.toJson(result);
        response.getWriter().write(json);
    }
}