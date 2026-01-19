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
            --info-color: #06b6d4;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)) !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
        }

        .container {
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
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: linear-gradient(135deg, #1e293b, #334155);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
            letter-spacing: 0.5px;
            border: none;
            padding: 1rem;
        }

        .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody tr:hover {
            background: linear-gradient(to right, rgba(37, 99, 235, 0.05), rgba(59, 130, 246, 0.05));
            transform: scale(1.01);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
        }

        .stats-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.3);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .pagination {
            margin-top: 2rem;
        }

        .pagination .page-link {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border: none;
            border-radius: 8px;
            margin: 0 4px;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
        }

        .pagination .page-link:hover {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.4);
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            box-shadow: 0 4px 6px -1px rgba(245, 158, 11, 0.5);
        }

        .pagination .page-item.disabled .page-link {
            background: #e2e8f0;
            color: #94a3b8;
            pointer-events: none;
            opacity: 0.6;
        }

        .pagination-info {
            color: #64748b;
            font-size: 0.95rem;
            font-weight: 500;
            background: linear-gradient(to right, #f8fafc, #e2e8f0);
            padding: 0.75rem 1.25rem;
            border-radius: 10px;
            display: inline-block;
            margin-bottom: 1rem;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 4rem;
            opacity: 0.5;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-bank2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto">
            <span class="navbar-text text-white me-3">
                <i class="bi bi-person-circle"></i> ${sessionScope.user.username}
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4 fade-in">

    <!-- Header -->
    <div class="page-header">
        <div class="row align-items-center">
            <div class="col">
                <h2 class="mb-2">
                    <i class="bi bi-robot"></i> Prédictions de Risque IA
                </h2>
                <p class="mb-0 opacity-90">
                    Analyse prédictive pour tous les prêts bancaires
                </p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light">
                    <i class="bi bi-house"></i> Dashboard
                </a>
            </div>
        </div>
    </div>

    <%
    List<PredictionRisque> allPredictions = (List<PredictionRisque>) request.getAttribute("predictions");
    
    // Configuration de la pagination
    int itemsPerPage = 10;
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int totalItems = allPredictions != null ? allPredictions.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
    
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
    
    List<PredictionRisque> predictions = allPredictions != null ? allPredictions.subList(startIndex, endIndex) : new ArrayList<>();
    
    // Calcul des statistiques sur TOUTES les prédictions
    int totalPredictions = totalItems;
    int risqueFaible = 0;
    int risqueMoyen = 0;
    int risqueEleve = 0;
    
    if (allPredictions != null) {
        for (PredictionRisque p : allPredictions) {
            String niveau = p.getNiveauRisque();
            if ("Faible".equalsIgnoreCase(niveau)) risqueFaible++;
            else if ("Moyen".equalsIgnoreCase(niveau)) risqueMoyen++;
            else if ("Élevé".equalsIgnoreCase(niveau) || "Eleve".equalsIgnoreCase(niveau)) risqueEleve++;
        }
    }
    %>

    <!-- Statistiques -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card bg-primary text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Total Prédictions</h6>
                            <h2 class="mb-0 fw-bold"><%= totalPredictions %></h2>
                        </div>
                        <i class="bi bi-clipboard-data fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card bg-success text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Risque Faible</h6>
                            <h2 class="mb-0 fw-bold"><%= risqueFaible %></h2>
                        </div>
                        <i class="bi bi-shield-check fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card bg-warning text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Risque Moyen</h6>
                            <h2 class="mb-0 fw-bold"><%= risqueMoyen %></h2>
                        </div>
                        <i class="bi bi-shield-exclamation fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card bg-danger text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Risque Élevé</h6>
                            <h2 class="mb-0 fw-bold"><%= risqueEleve %></h2>
                        </div>
                        <i class="bi bi-shield-x fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Table des Prédictions -->
    <div class="card shadow">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-table"></i> Liste des Prédictions
                </h5>
                <span class="stats-badge">
                    <i class="bi bi-file-text"></i> <%= totalItems %> prédictions
                </span>
            </div>
        </div>
        <div class="card-body p-0">
            
            <!-- Info pagination -->
            <div class="p-4 pb-0">
                <div class="pagination-info">
                    <i class="bi bi-info-circle"></i>
                    Affichage de <strong><%= totalItems == 0 ? 0 : startIndex + 1 %></strong> à 
                    <strong><%= endIndex %></strong> sur <strong><%= totalItems %></strong> prédictions
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th><i class="bi bi-hash"></i> ID Prédiction</th>
                            <th><i class="bi bi-cash"></i> ID Prêt</th>
                            <th><i class="bi bi-speedometer"></i> Taux Endettement</th>
                            <th><i class="bi bi-shield"></i> Niveau Risque</th>
                            <th><i class="bi bi-graph-up"></i> Score Confiance</th>
                            <th><i class="bi bi-calendar"></i> Date Prédiction</th>
                            <th><i class="bi bi-cpu"></i> Modèle</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        if (predictions != null && !predictions.isEmpty()) {
                            for (PredictionRisque pred : predictions) {
                                String badgeClass = "";
                                String iconClass = "";
                                String niveau = pred.getNiveauRisque();
                                
                                if ("Faible".equalsIgnoreCase(niveau)) {
                                    badgeClass = "bg-success";
                                    iconClass = "bi-shield-check";
                                } else if ("Moyen".equalsIgnoreCase(niveau)) {
                                    badgeClass = "bg-warning";
                                    iconClass = "bi-shield-exclamation";
                                } else {
                                    badgeClass = "bg-danger";
                                    iconClass = "bi-shield-x";
                                }
                        %>
                        <tr>
                            <td><strong>#<%= pred.getIdPrediction() %></strong></td>
                            <td>
                                <span class="badge bg-primary">
                                    <i class="bi bi-file-text"></i> Prêt #<%= pred.getPretId() %>
                                </span>
                            </td>
                            <td>
                                <strong><fmt:formatNumber value="<%= pred.getTauxEndettement() %>" pattern="0.00"/> %</strong>
                            </td>
                            <td>
                                <span class="badge <%= badgeClass %>">
                                    <i class="bi <%= iconClass %>"></i> <%= pred.getNiveauRisque() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="progress me-2" style="width: 100px; height: 8px;">
                                        <div class="progress-bar bg-primary" role="progressbar" 
                                             style="width: <%= pred.getScoreConfiance() * 100 %>%"></div>
                                    </div>
                                    <span class="text-muted small">
                                        <fmt:formatNumber value="<%= pred.getScoreConfiance() * 100 %>" pattern="0.0"/>%
                                    </span>
                                </div>
                            </td>
                            <td>
                                <i class="bi bi-clock text-muted"></i>
                                <fmt:formatDate value="<%= pred.getDatePrediction() %>" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <code class="text-muted"><%= pred.getModeleVersion() %></code>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7">
                                <div class="empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <p class="mb-0 fs-5">Aucune prédiction disponible</p>
                                    <small>Les prédictions s'afficheront ici une fois générées</small>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <div class="p-4">
                <nav>
                    <ul class="pagination justify-content-center mb-0">

                        <!-- Bouton Précédent -->
                        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= currentPage - 1 %>">
                                <i class="bi bi-chevron-left"></i> Précédent
                            </a>
                        </li>

                        <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        // Afficher la première page si nécessaire
                        if (startPage > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="?page=1">1</a>
                            </li>
                            <% if (startPage > 2) { %>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            <% } %>
                        <% } %>

                        <!-- Pages numérotées -->
                        <% for (int i = startPage; i <= endPage; i++) { %>
                            <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                <a class="page-link" href="?page=<%= i %>">
                                    <%= i %>
                                </a>
                            </li>
                        <% } %>

                        <!-- Afficher la dernière page si nécessaire -->
                        <% if (endPage < totalPages) { 
                            if (endPage < totalPages - 1) { %>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            <% } %>
                            <li class="page-item">
                                <a class="page-link" href="?page=<%= totalPages %>"><%= totalPages %></a>
                            </li>
                        <% } %>

                        <!-- Bouton Suivant -->
                        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= currentPage + 1 %>">
                                Suivant <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>

                    </ul>
                </nav>
            </div>
            <% } %>

        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>