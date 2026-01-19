<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.banque.model.Pret, com.banque.model.Client" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
Pret pret = (Pret) request.getAttribute("pret");
Client client = (Client) request.getAttribute("client");

double montantTotal = pret.getMontantTotal();
double tauxEndettementPourcent = pret.getTauxEndettementPourcentage();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Prêt #<%= pret.getIdPret() %> - Banque Digitale</title>
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

        .btn {
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .btn-gold {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            border: none;
            font-weight: 600;
        }

        .btn-gold:hover {
            background: linear-gradient(135deg, #d97706, #b45309);
            color: white;
        }

        .info-section {
            background: linear-gradient(to right, #f8fafc, #e2e8f0);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .info-section p {
            margin-bottom: 0.75rem;
            color: #1e293b;
            font-size: 1rem;
        }

        .info-section strong {
            color: #0f172a;
            font-weight: 600;
        }

        .progress {
            border-radius: 10px;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .progress-bar {
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
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

        .badge-custom {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
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

    <!-- Header Prêt -->
    <div class="page-header">
        <div class="row align-items-center">
            <div class="col">
                <h2 class="mb-2">
                    <i class="bi bi-cash-stack"></i> Détails du Prêt #<%= pret.getIdPret() %>
                </h2>
                <p class="mb-0 opacity-90">
                    Type : <strong><%= pret.getTypePret().toUpperCase() %></strong> | Durée : <strong><%= pret.getDureeMois() %> mois</strong>
                </p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/prets" class="btn btn-light">
                    <i class="bi bi-arrow-left"></i> Retour aux Prêts
                </a>
            </div>
        </div>
    </div>

    <!-- Cartes d'informations du prêt -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-primary-gradient text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Mensualité</h6>
                            <h2 class="mb-0 fw-bold">
                                <fmt:formatNumber value="<%= pret.getMensualite() %>" pattern="#,##0"/> €
                            </h2>
                        </div>
                        <i class="bi bi-wallet2 fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-info-gradient text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Taux Annuel</h6>
                            <h2 class="mb-0 fw-bold">
                                <fmt:formatNumber value="<%= pret.getTauxAnnuel() %>" pattern="0.00"/> %
                            </h2>
                        </div>
                        <i class="bi bi-percent fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-warning-gradient text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Taux Endettement</h6>
                            <%
                                String badgeClass = "badge bg-success";
                                if (tauxEndettementPourcent > 33) badgeClass = "badge bg-danger";
                                else if (tauxEndettementPourcent > 25) badgeClass = "badge bg-warning text-dark";
                            %>
                            <h2 class="mb-0">
                                <span class="<%= badgeClass %> badge-custom">
                                    <fmt:formatNumber value="<%= tauxEndettementPourcent %>" pattern="0.00"/> %
                                </span>
                            </h2>
                        </div>
                        <i class="bi bi-speedometer fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-success-gradient text-white shadow">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-1 opacity-90">Montant Total</h6>
                            <h2 class="mb-0 fw-bold">
                                <fmt:formatNumber value="<%= montantTotal %>" pattern="#,##0"/> €
                            </h2>
                        </div>
                        <i class="bi bi-currency-euro fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Infos Client -->
    <div class="card shadow mb-4">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-person-lines-fill"></i> Informations Client</h5>
        </div>
        <div class="card-body">
            <div class="info-section">
                <div class="row">
                    <div class="col-md-6">
                        <p><i class="bi bi-hash text-primary"></i> <strong>ID Client :</strong> <%= client.getIdClient() %></p>
                        <p><i class="bi bi-person-badge text-primary"></i> <strong>Identifiant :</strong> <%= client.getIdentifiantOriginal() %></p>
                        <p><i class="bi bi-building text-primary"></i> <strong>Ville :</strong> <%= client.getVille() %></p>
                    </div>
                    <div class="col-md-6">
                        <p><i class="bi bi-mailbox text-primary"></i> <strong>Code Postal :</strong> <%= client.getCodePostal() %></p>
                        <p><i class="bi bi-currency-euro text-success"></i> <strong>Revenu Mensuel :</strong> 
                            <span class="text-success fw-bold">
                                <fmt:formatNumber value="<%= client.getRevenuMensuel() %>" pattern="#,##0.00"/> €
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Progression du prêt -->
    <div class="card shadow mb-4">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-bar-chart-line"></i> Avancement du Prêt</h5>
        </div>
        <div class="card-body">
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Progression du remboursement</span>
                    <span class="fw-bold text-primary">0 %</span>
                </div>
                <div class="progress" style="height:30px;">
                    <div class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                        <span class="fw-bold">0% complété</span>
                    </div>
                </div>
            </div>
            <div class="row text-center mt-4">
                <div class="col-md-4">
                    <div class="info-section">
                        <i class="bi bi-calendar-check text-success fs-3"></i>
                        <p class="mb-0 mt-2"><strong>Paiements effectués</strong></p>
                        <h4 class="text-success mb-0">0 / <%= pret.getDureeMois() %></h4>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-section">
                        <i class="bi bi-hourglass-split text-warning fs-3"></i>
                        <p class="mb-0 mt-2"><strong>Paiements restants</strong></p>
                        <h4 class="text-warning mb-0"><%= pret.getDureeMois() %> mois</h4>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-section">
                        <i class="bi bi-piggy-bank text-info fs-3"></i>
                        <p class="mb-0 mt-2"><strong>Total à rembourser</strong></p>
                        <h4 class="text-info mb-0">
                            <fmt:formatNumber value="<%= montantTotal %>" pattern="#,##0"/> €
                        </h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div class="mb-4">
        <h5 class="mb-3"><i class="bi bi-gear-fill"></i> Actions disponibles</h5>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/prediction?idPret=<%= pret.getIdPret() %>" class="btn btn-gold">
                <i class="bi bi-robot"></i> Prédiction IA
            </a>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/prets?action=edit&id=<%= pret.getIdPret() %>" class="btn btn-primary">
                    <i class="bi bi-pencil-square"></i> Modifier
                </a>
                <a href="${pageContext.request.contextPath}/prets?action=delete&id=<%= pret.getIdPret() %>" 
                   class="btn btn-danger" 
                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce prêt ?');">
                    <i class="bi bi-trash-fill"></i> Supprimer
                </a>
            </c:if>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>