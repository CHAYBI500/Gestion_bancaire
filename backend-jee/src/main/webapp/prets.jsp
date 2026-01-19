<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.banque.model.Pret" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Prêts - Banque Digitale</title>
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
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)) !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            letter-spacing: -0.5px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }

        .stats-card {
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 25px 30px -5px rgba(0, 0, 0, 0.2);
        }

        .bg-primary-gradient {
            background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
        }

        .bg-success-gradient {
            background: linear-gradient(135deg, #10b981, #059669) !important;
        }

        .bg-info-gradient {
            background: linear-gradient(135deg, #06b6d4, #0891b2) !important;
        }

        .bg-warning-gradient {
            background: linear-gradient(135deg, #f59e0b, #d97706) !important;
        }

        .table-hover tbody tr {
            transition: all 0.2s ease;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(37, 99, 235, 0.05);
            transform: scale(1.01);
        }

        .badge {
            padding: 0.5rem 1rem;
            font-weight: 600;
            border-radius: 50px;
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

        .btn-group-sm .btn {
            border-radius: 8px;
        }

        .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .table thead th {
            background: linear-gradient(135deg, #1e293b, #334155);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
            letter-spacing: 0.5px;
        }

        .card-footer {
            background: linear-gradient(to right, #f8fafc, #e2e8f0);
            border-top: 2px solid #e2e8f0;
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
    </style>
</head>
<body>
    <!-- Navigation -->
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
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- En-tête -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-2">
                        <i class="bi bi-cash-stack"></i> 
                        Liste des Prêts
                    </h2>
                    <p class="mb-0 opacity-90">
                        <c:choose>
                            <c:when test="${not empty idClient}">
                                Prêts du client ID: ${idClient}
                            </c:when>
                            <c:otherwise>
                                Tous les prêts bancaires
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-light">
                        <i class="bi bi-arrow-left"></i> Vers Dashboard
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistiques Rapides -->
        <%
        List<Pret> allPrets = (List<Pret>) request.getAttribute("prets");

        int pageSize = 10; // Nombre de prêts par page
        int currentPageNumber = 1; // renommé pour éviter conflit
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPageNumber = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) { currentPageNumber = 1; }
        }

        int totalPrets = allPrets != null ? allPrets.size() : 0;
        int totalPages = (int) Math.ceil((double) totalPrets / pageSize);
        int start = (currentPageNumber - 1) * pageSize;
        int end = Math.min(start + pageSize, totalPrets);

        List<Pret> prets = allPrets != null ? allPrets.subList(start, end) : new ArrayList<>();

        int pretsImmobilier = 0;
        int pretsAutomobile = 0;
        double totalMensualites = 0;
        double tauxEndettementMoyen = 0;

        if (allPrets != null) {
            for (Pret p : allPrets) {
                if ("immobilier".equalsIgnoreCase(p.getTypePret())) pretsImmobilier++;
                else if ("automobile".equalsIgnoreCase(p.getTypePret())) pretsAutomobile++;
                totalMensualites += p.getMensualite();
                tauxEndettementMoyen += p.getTauxEndettement();
            }
            if (totalPrets > 0) tauxEndettementMoyen = tauxEndettementMoyen / totalPrets;
        }

        request.setAttribute("totalPrets", totalPrets);
        request.setAttribute("pretsImmobilier", pretsImmobilier);
        request.setAttribute("pretsAutomobile", pretsAutomobile);
        request.setAttribute("totalMensualites", totalMensualites);
        request.setAttribute("tauxEndettementMoyen", tauxEndettementMoyen);
        request.setAttribute("currentPage", currentPageNumber);
        request.setAttribute("totalPages", totalPages);
        %>

        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card stats-card bg-primary-gradient text-white shadow">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1 opacity-90">Total Prêts</h6>
                                <h2 class="mb-0 fw-bold">${totalPrets}</h2>
                            </div>
                            <i class="bi bi-clipboard-data fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stats-card bg-success-gradient text-white shadow">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1 opacity-90">Immobiliers</h6>
                                <h2 class="mb-0 fw-bold">${pretsImmobilier}</h2>
                            </div>
                            <i class="bi bi-house-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stats-card bg-info-gradient text-white shadow">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1 opacity-90">Automobiles</h6>
                                <h2 class="mb-0 fw-bold">${pretsAutomobile}</h2>
                            </div>
                            <i class="bi bi-car-front-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stats-card bg-warning-gradient text-white shadow">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1 opacity-90">Mensualités</h6>
                                <h2 class="mb-0 fw-bold">
                                    <fmt:formatNumber value="${totalMensualites}" pattern="#,##0"/> €
                                </h2>
                            </div>
                            <i class="bi bi-wallet2 fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table des Prêts -->
        <div class="card shadow">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-table"></i> Détails des Prêts</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Client</th>
                                <th>Ville</th>
                                <th>Type</th>
                                <th>Durée</th>
                                <th>Taux</th>
                                <th>Mensualité</th>
                                <th>Revenu</th>
                                <th>Taux Endettement</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (!prets.isEmpty()) {
                                for (Pret pret : prets) {
                                    String tauxEndettementClass = "";
                                    double tauxPourcent = pret.getTauxEndettement() * 100;
                                    if (tauxPourcent > 33) tauxEndettementClass = "text-danger fw-bold";
                                    else if (tauxPourcent > 25) tauxEndettementClass = "text-warning fw-bold";
                                    else tauxEndettementClass = "text-success";
                            %>
                            <tr>
                                <td><%= pret.getIdPret() %></td>
                                <td><strong><%= pret.getClientIdentifiant() %></strong></td>
                                <td><%= pret.getClientVille() %></td>
                                <td>
                                    <% if ("immobilier".equalsIgnoreCase(pret.getTypePret())) { %>
                                        <span class="badge bg-success"><i class="bi bi-house-fill"></i> Immobilier</span>
                                    <% } else { %>
                                        <span class="badge bg-info"><i class="bi bi-car-front-fill"></i> Automobile</span>
                                    <% } %>
                                </td>
                                <td><%= pret.getDureeMois() %> mois</td>
                                <td><fmt:formatNumber value="<%= pret.getTauxAnnuel() %>" pattern="0.000"/> %</td>
                                <td class="fw-bold"><fmt:formatNumber value="<%= pret.getMensualite() %>" pattern="#,##0.00"/> €</td>
                                <td><fmt:formatNumber value="<%= pret.getClientRevenu() %>" pattern="#,##0.00"/> €</td>
                                <td class="<%= tauxEndettementClass %>"><fmt:formatNumber value="<%= tauxPourcent %>" pattern="0.00"/> %</td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="${pageContext.request.contextPath}/prets?action=detail&id=<%= pret.getIdPret() %>" class="btn btn-outline-primary" title="Détails"><i class="bi bi-eye-fill"></i></a>
                                        <a href="${pageContext.request.contextPath}/prediction?idPret=<%= pret.getIdPret() %>" class="btn btn-outline-warning" title="Prédiction IA"><i class="bi bi-robot"></i></a>
                                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/prets?action=delete&id=<%= pret.getIdPret() %>" class="btn btn-outline-danger" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce prêt ?');" title="Supprimer"><i class="bi bi-trash-fill"></i></a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1"></i>
                                    <p class="mb-0 mt-3">Aucun prêt trouvé</p>
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Pagination -->
            <div class="card-footer">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Précédent
                            </a>
                        </c:if>
                    </div>
                    <div>
                        <small class="text-muted">
                            Page <strong>${currentPage}</strong> sur <strong>${totalPages}</strong> | Total: <strong>${totalPrets}</strong> prêts
                        </small>
                    </div>
                    <div>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}" class="btn btn-primary">
                                Suivant <i class="bi bi-arrow-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>