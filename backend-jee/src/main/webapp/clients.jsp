<%@ page import="java.util.*, com.banque.model.Client" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Clients - Banque Digitale</title>
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

        .search-section {
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: 2px solid #e2e8f0;
        }

        .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
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

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border: none;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            border: none;
        }

        .btn-gold {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            border: none;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #059669);
            border: none;
        }

        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
            border: none;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            border: none;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
        }

        .form-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
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

        .stats-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.3);
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

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="dashboard">
            <i class="bi bi-bank2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4 fade-in">

<%
String userRole = (String) session.getAttribute("role");
boolean isAdmin = "admin".equalsIgnoreCase(userRole);

String successMessage = (String) request.getAttribute("successMessage");
String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!-- Messages de succès/erreur -->
<% if (successMessage != null) { %>
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="bi bi-check-circle-fill"></i> <%= successMessage %>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>

<% if (errorMessage != null) { %>
<div class="alert alert-danger alert-dismissible fade show" role="alert">
    <i class="bi bi-exclamation-triangle-fill"></i> <%= errorMessage %>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>

<!-- En-tête de page -->
<div class="page-header">
    <div class="row align-items-center">
        <div class="col">
            <h2 class="mb-2">
                <i class="bi bi-people-fill"></i> Gestion des Clients
            </h2>
            <p class="mb-0 opacity-90">
                Centralisation, suivi et historique des clients bancaires
            </p>
        </div>
        <% if (isAdmin) { %>
        <div class="col-auto">
            <a href="clients?action=add" class="btn btn-success btn-lg">
                <i class="bi bi-plus-circle"></i> Nouveau Client
            </a>
        </div>
        <% } %>
    </div>
</div>

<!-- Section Recherche -->
<div class="search-section">
    <h5 class="mb-4">
        <i class="bi bi-search"></i> Recherche Avancée
    </h5>
    <form method="GET" action="clients">
        <div class="row g-3">
            <div class="col-md-3">
                <label class="form-label">
                    <i class="bi bi-funnel"></i> Rechercher par
                </label>
                <select class="form-select" name="searchField">
                    <option value="identifiantOriginal"
                        <%= "identifiantOriginal".equals(request.getParameter("searchField")) ? "selected" : "" %>>
                        Identifiant
                    </option>
                    <option value="ville"
                        <%= "ville".equals(request.getParameter("searchField")) ? "selected" : "" %>>
                        Ville
                    </option>
                    <option value="codePostal"
                        <%= "codePostal".equals(request.getParameter("searchField")) ? "selected" : "" %>>
                        Code Postal
                    </option>
                    <option value="revenuMensuel"
                        <%= "revenuMensuel".equals(request.getParameter("searchField")) ? "selected" : "" %>>
                        Revenu minimum
                    </option>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">
                    <i class="bi bi-pencil"></i> Valeur de recherche
                </label>
                <input type="text" class="form-control" name="searchValue"
                       value="<%= request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" %>"
                       placeholder="Entrer la valeur de recherche">
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary me-2">
                    <i class="bi bi-search"></i> Rechercher
                </button>
                <a href="clients" class="btn btn-secondary">
                    <i class="bi bi-x-circle"></i> Effacer
                </a>
            </div>
        </div>
    </form>
</div>

<!-- Liste des Clients -->
<div class="card">
    <div class="card-body p-0">

<%
List<Client> allClients = (List<Client>) request.getAttribute("clients");

int itemsPerPage = 10;
int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
int totalItems = allClients != null ? allClients.size() : 0;
int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

int startIndex = (currentPage - 1) * itemsPerPage;
int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

List<Client> clients = allClients != null ? allClients.subList(startIndex, endIndex) : new ArrayList<>();
%>

<div class="p-4 pb-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0">
            <i class="bi bi-table"></i> Liste des Clients
        </h4>
        <span class="stats-badge">
            <i class="bi bi-people"></i> <%= totalItems %> clients
        </span>
    </div>

    <div class="pagination-info">
        <i class="bi bi-info-circle"></i>
        Affichage de <strong><%= totalItems == 0 ? 0 : startIndex + 1 %></strong> à 
        <strong><%= endIndex %></strong> sur <strong><%= totalItems %></strong> clients
    </div>
</div>

<div class="table-responsive">
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th><i class="bi bi-fingerprint"></i> Identifiant</th>
                <th><i class="bi bi-geo-alt"></i> Ville</th>
                <th><i class="bi bi-mailbox"></i> Code Postal</th>
                <th><i class="bi bi-currency-euro"></i> Revenu Mensuel</th>
                <th><i class="bi bi-gear"></i> Actions</th>
            </tr>
        </thead>
        <tbody>

<% if (clients.isEmpty()) { %>
    <tr>
        <td colspan="5">
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <p class="mb-0 fs-5">Aucun client trouvé</p>
                <small>Essayez de modifier vos critères de recherche</small>
            </div>
        </td>
    </tr>
<% } else {
   for (Client c : clients) { %>

    <tr>
        <td>
            <strong><i class="bi bi-person-badge"></i> <%= c.getIdentifiantOriginal() %></strong>
        </td>
        <td>
            <i class="bi bi-building"></i> <%= c.getVille() %>
        </td>
        <td>
            <span class="badge bg-secondary"><%= c.getCodePostal() %></span>
        </td>
        <td>
            <strong style="color: var(--success-color);">
                <%= String.format("%,.2f", c.getRevenuMensuel()) %> €
            </strong>
        </td>
        <td>
            <div class="btn-group" role="group">
                <a href="${pageContext.request.contextPath}/clients?action=detailPret&idClient=<%= c.getIdClient() %>" 
                   class="btn btn-sm btn-gold" title="Voir les prêts">
                    <i class="bi bi-cash-stack"></i>
                </a>
                
                <% if (isAdmin) { %>
                <a href="clients?action=edit&id=<%= c.getIdClient() %>" 
                   class="btn btn-sm btn-warning" title="Modifier">
                    <i class="bi bi-pencil-square"></i>
                </a>
                
                <a href="clients?action=delete&id=<%= c.getIdClient() %>" 
                   class="btn btn-sm btn-danger" 
                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce client ?');"
                   title="Supprimer">
                    <i class="bi bi-trash"></i>
                </a>
                <% } %>
            </div>
        </td>
    </tr>

<% }} %>

        </tbody>
    </table>
</div>

    </div>
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>