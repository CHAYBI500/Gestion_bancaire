<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.banque.model.PredictionRisque" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prédictions de Risque - Banque Digitale</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #1e293b;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)) !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .table thead th {
            background-color: #f8fafc;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 2px solid #e2e8f0;
        }

        .badge-risk {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-bank2 me-2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto">
            <span class="navbar-text text-white me-3">
                <i class="bi bi-person-circle me-1"></i> ${sessionScope.agentName != null ? sessionScope.agentName : "Agent"}
            </span>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container main-container fade-in">

    <div class="alert alert-info border-0 shadow-sm mb-4 d-flex align-items-center" style="background-color: #e0f2fe; color: #0369a1;">
        <i class="bi bi-shield-lock-fill fs-4 me-3"></i>
        <div>
            <strong>Mode Consultation Seul :</strong> En tant qu'agent bancaire, vous avez un accès en lecture seule à ces prédictions. La modification ou la suppression des analyses est réservée aux administrateurs.
        </div>
    </div>

    <div class="page-header">
        <div class="row align-items-center">
            <div class="col">
                <h2 class="mb-2"><i class="bi bi-robot me-2"></i>Prédictions de Risque IA</h2>
                <p class="mb-0 opacity-75">Analyse prédictive de solvabilité basée sur le modèle de Machine Learning v2.4</p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/agent_bancaire/dashboard.jsp" class="btn btn-light">
                    <i class="bi bi-arrow-left"></i> Retour Dashboard
                </a>
            </div>
        </div>
    </div>

    <%
        // Récupération des données transmises par la servlet
        List<PredictionRisque> allPredictions = (List<PredictionRisque>) request.getAttribute("predictions");
        
        // Logique de pagination
        int itemsPerPage = 10;
        int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
        int totalItems = (allPredictions != null) ? allPredictions.size() : 0;
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        List<PredictionRisque> paginatedList = new ArrayList<>();
        int risqueFaible = 0, risqueMoyen = 0, risqueEleve = 0;

        if (allPredictions != null) {
            // Calcul des stats sur la liste complète
            for (PredictionRisque p : allPredictions) {
                String r = p.getNiveauRisque().toLowerCase();
                if (r.contains("faible")) risqueFaible++;
                else if (r.contains("moyen")) risqueMoyen++;
                else risqueEleve++;
            }
            // Extraction de la sous-liste pour la page actuelle
            if (totalItems > 0) {
                paginatedList = allPredictions.subList(startIndex, endIndex);
            }
        }
    %>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card p-3 mb-3 border-start border-primary border-4">
                <small class="text-muted">Total Analyses</small>
                <h3 class="fw-bold"><%= totalItems %></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 mb-3 border-start border-success border-4">
                <small class="text-muted text-success">Risque Faible</small>
                <h3 class="fw-bold text-success"><%= risqueFaible %></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 mb-3 border-start border-warning border-4">
                <small class="text-muted text-warning">Risque Moyen</small>
                <h3 class="fw-bold text-warning"><%= risqueMoyen %></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 mb-3 border-start border-danger border-4">
                <small class="text-muted text-danger">Risque Élevé</small>
                <h3 class="fw-bold text-danger"><%= risqueEleve %></h3>
            </div>
        </div>
    </div>

    <div class="card shadow-sm overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID Prêt</th>
                        <th>Taux Endettement</th>
                        <th>Niveau Risque</th>
                        <th>Confiance IA</th>
                        <th>Date Analyse</th>
                        <th>Version Modèle</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (paginatedList.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                Aucune prédiction trouvée dans la base de données.
                            </td>
                        </tr>
                    <% } else { 
                        for (PredictionRisque pred : paginatedList) { 
                            String statusClass = "bg-secondary";
                            if(pred.getNiveauRisque().equalsIgnoreCase("Faible")) statusClass = "bg-success";
                            else if(pred.getNiveauRisque().equalsIgnoreCase("Moyen")) statusClass = "bg-warning text-dark";
                            else if(pred.getNiveauRisque().equalsIgnoreCase("Élevé") || pred.getNiveauRisque().equalsIgnoreCase("Eleve")) statusClass = "bg-danger";
                    %>
                        <tr>
                            <td><span class="fw-bold text-primary">#<%= pred.getPretId() %></span></td>
                            <td><%= String.format("%.2f", pred.getTauxEndettement()) %>%</td>
                            <td><span class="badge badge-risk <%= statusClass %>"><%= pred.getNiveauRisque() %></span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="progress flex-grow-1 me-2" style="height: 6px;">
                                        <div class="progress-bar" style="width: <%= pred.getScoreConfiance()*100 %>%"></div>
                                    </div>
                                    <small><%= (int)(pred.getScoreConfiance()*100) %>%</small>
                                </div>
                            </td>
                            <td><fmt:formatDate value="<%= pred.getDatePrediction() %>" pattern="dd MMM yyyy HH:mm"/></td>
                            <td><small class="text-muted"><%= pred.getModeleVersion() %></small></td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <% if (totalPages > 1) { %>
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                <a class="page-link" href="?page=<%= currentPage - 1 %>">Précédent</a>
            </li>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                    <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                </li>
            <% } %>
            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                <a class="page-link" href="?page=<%= currentPage + 1 %>">Suivant</a>
            </li>
        </ul>
    </nav>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>