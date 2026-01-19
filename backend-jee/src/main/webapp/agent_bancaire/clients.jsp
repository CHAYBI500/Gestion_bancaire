<%@ page import="java.util.*, com.banque.model.Client" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Session agent
    String agentName = (session != null && session.getAttribute("agentName") != null) 
                       ? (String) session.getAttribute("agentName") 
                       : "Agent";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clients | Agent Bancaire</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --boa-blue: #003a8f;
            --boa-gold: #c9a23f;
            --boa-dark: #0b1f3a;
        }

        body {
            background-color: #f4f6f9;
            font-family: "Segoe UI", sans-serif;
        }

        .navbar {
            background: linear-gradient(90deg, var(--boa-blue), var(--boa-dark));
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
        }

        .agent-badge {
            background: rgba(201, 162, 63, 0.2);
            padding: 8px 20px;
            border-radius: 25px;
            border: 1px solid var(--boa-gold);
        }

        .agent-badge i {
            color: var(--boa-gold);
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--boa-blue), var(--boa-dark));
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .page-header h2 {
            font-weight: 700;
            margin-bottom: 10px;
        }

        .page-header .breadcrumb {
            background: transparent;
            margin: 0;
            padding: 0;
        }

        .page-header .breadcrumb-item {
            color: rgba(255, 255, 255, 0.7);
        }

        .page-header .breadcrumb-item.active {
            color: var(--boa-gold);
        }

        .page-header .breadcrumb-item a {
            color: white;
            text-decoration: none;
        }

        .page-header .breadcrumb-item + .breadcrumb-item::before {
            color: rgba(255, 255, 255, 0.5);
        }

        .permission-badge {
            background: rgba(255, 255, 255, 0.15);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            display: inline-block;
            margin-top: 10px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        /* Search Card */
        .search-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }

        .search-card h5 {
            color: var(--boa-dark);
            font-weight: 700;
            margin-bottom: 20px;
        }

        .search-card h5 i {
            color: var(--boa-gold);
            margin-right: 10px;
        }

        /* Buttons */
        .btn-gold {
            background-color: var(--boa-gold);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            padding: 10px 24px;
            transition: all 0.3s ease;
        }

        .btn-gold:hover {
            background-color: #b18e32;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 162, 63, 0.3);
            color: white;
        }

        .btn-outline-gold {
            border: 2px solid var(--boa-gold);
            color: var(--boa-gold);
            background: transparent;
            border-radius: 8px;
            font-weight: 600;
            padding: 10px 24px;
            transition: all 0.3s ease;
        }

        .btn-outline-gold:hover {
            background-color: var(--boa-gold);
            color: white;
            transform: translateY(-2px);
        }

        /* Table */
        .table-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .table-card h5 {
            color: var(--boa-dark);
            font-weight: 700;
            margin-bottom: 20px;
        }

        .table {
            margin: 0;
        }

        .table thead {
            background: linear-gradient(135deg, rgba(0, 58, 143, 0.1), rgba(201, 162, 63, 0.1));
        }

        .table thead th {
            color: var(--boa-dark);
            font-weight: 700;
            border: none;
            padding: 15px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .table tbody tr:hover {
            background-color: rgba(201, 162, 63, 0.05);
            transform: scale(1.01);
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            color: #555;
        }

        .client-id {
            font-weight: 600;
            color: var(--boa-blue);
        }

        .revenue-badge {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1), rgba(40, 167, 69, 0.2));
            color: #28a745;
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            display: inline-block;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: #666;
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* Stats */
        .stats-row {
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--boa-gold);
        }

        .stat-card h3 {
            color: var(--boa-blue);
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #666;
            font-size: 0.9rem;
            margin: 0;
        }

        /* Pagination */
        .pagination-gold {
            gap: 8px;
        }

        .pagination-gold .page-link {
            border: 2px solid #e0e0e0;
            color: var(--boa-blue);
            border-radius: 8px;
            padding: 10px 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination-gold .page-link:hover {
            background-color: var(--boa-gold);
            border-color: var(--boa-gold);
            color: white;
            transform: translateY(-2px);
        }

        .pagination-gold .page-item.active .page-link {
            background-color: var(--boa-blue);
            border-color: var(--boa-blue);
            color: var(--boa-gold);
            box-shadow: 0 4px 12px rgba(0, 58, 143, 0.3);
        }

        .pagination-gold .page-item.disabled .page-link {
            background-color: #f8f9fa;
            border-color: #e0e0e0;
            color: #999;
        }

        /* Form Inputs */
        .form-select, .form-control {
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }

        .form-select:focus, .form-control:focus {
            border-color: var(--boa-gold);
            box-shadow: 0 0 0 0.2rem rgba(201, 162, 63, 0.15);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 0;
            }

            .search-card, .table-card {
                padding: 20px;
            }

            .table {
                font-size: 0.85rem;
            }
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a href="${pageContext.request.contextPath}/agent_bancaire/dashboard.jsp" class="navbar-brand">
            <i class="fa-solid fa-building-columns me-2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto align-items-center">
            <span class="nav-link text-white agent-badge me-3">
                <i class="fa-solid fa-user-tie me-2"></i><%= agentName %>
            </span>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout.jsp">
                <i class="fa-solid fa-right-from-bracket me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/agent_bancaire/dashboard.jsp">
                        <i class="fa-solid fa-home me-1"></i>Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item active">Base Clients</li>
            </ol>
        </nav>
        <h2>
            <i class="fa-solid fa-users me-2"></i>Base Clients
        </h2>
        <span class="permission-badge">
            <i class="fa-solid fa-eye me-2"></i>Mode Consultation
        </span>
    </div>
</div>
<div class="page-header">
    <div class="container">
        <div class="alert alert-info border-0 shadow-sm mb-4" style="background: rgba(255, 255, 255, 0.1); color: white;">
            <i class="fa-solid fa-circle-info me-2"></i>
            <strong>Note :</strong> Votre profil d'agent vous permet uniquement de <strong>consulter</strong> la liste des clients. Vous ne disposez d'aucun privilège pour modifier ou supprimer des données.
        </div>

        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/agent_bancaire/dashboard.jsp">
                                           </a>
</div>
<div class="container">
    <!-- STATS -->
    <%
        List<Client> clients = (List<Client>) request.getAttribute("clients");
        int totalClients = (clients != null) ? clients.size() : 0;
        
        // Pagination
        int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10; // Nombre de clients par page
        int totalPages = (int) Math.ceil((double) totalClients / pageSize);
        
        // Liste paginée
        List<Client> paginatedClients = new ArrayList<>();
        if (clients != null && !clients.isEmpty()) {
            int start = (currentPage - 1) * pageSize;
            int end = Math.min(start + pageSize, totalClients);
            paginatedClients = clients.subList(start, end);
        }
        
        // Paramètres de recherche pour pagination
        String searchField = request.getParameter("searchField");
        String searchValue = request.getParameter("searchValue");
        String searchParams = "";
        if (searchField != null && searchValue != null) {
            searchParams = "&searchField=" + searchField + "&searchValue=" + searchValue;
        }
    %>
    <div class="row stats-row">
        <div class="col-md-3">
            <div class="stat-card">
                <h3><%= totalClients %></h3>
                <p><i class="fa-solid fa-users me-2"></i>Clients trouvés</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <h3><%= currentPage %> / <%= totalPages %></h3>
                <p><i class="fa-solid fa-file me-2"></i>Page actuelle</p>
            </div>
        </div>
        <div class="col-md-6 text-end">
            <a href="${pageContext.request.contextPath}/agent_bancaire/dashboard.jsp" class="btn btn-outline-gold btn-lg">
                <i class="fa-solid fa-arrow-left me-2"></i>Retour au Dashboard
            </a>
        </div>
    </div>

    <!-- SEARCH CARD -->
    <div class="search-card">
        <h5>
            <i class="fa-solid fa-magnifying-glass"></i>Rechercher un client
        </h5>
        <form method="GET" action="aff_clients" class="row g-3">
            <div class="col-md-3">
                <label class="form-label">Critère</label>
                <select class="form-select" name="searchField">
                    <option value="identifiantOriginal">Identifiant</option>
                    <option value="ville">Ville</option>
                    <option value="codePostal">Code Postal</option>
                    <option value="revenuMensuel">Revenu minimum</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Valeur</label>
                <input type="text" class="form-control" name="searchValue" 
                       placeholder="Entrer la valeur de recherche" required>
            </div>
            <div class="col-md-3">
                <label class="form-label d-block">&nbsp;</label>
                <button type="submit" class="btn btn-gold me-2">
                    <i class="fa-solid fa-search me-2"></i>Rechercher
                </button>
                <a href="aff_clients" class="btn btn-outline-gold">
                    <i class="fa-solid fa-rotate-right me-2"></i>Effacer
                </a>
            </div>
        </form>
    </div>

    <!-- TABLE CARD -->
    <div class="table-card">
        <h5>
            <i class="fa-solid fa-table me-2"></i>Liste des clients
        </h5>
        
        <% if (clients == null || clients.isEmpty()) { %>
            <div class="empty-state">
                <i class="fa-solid fa-users-slash"></i>
                <h4>Aucun client trouvé</h4>
                <p>Essayez de modifier vos critères de recherche</p>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><i class="fa-solid fa-id-card me-2"></i>Identifiant</th>
                            <th><i class="fa-solid fa-city me-2"></i>Ville</th>
                            <th><i class="fa-solid fa-location-dot me-2"></i>Code Postal</th>
                            <th><i class="fa-solid fa-coins me-2"></i>Revenu Mensuel</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (Client c : paginatedClients) { %>
                        <tr>
                            <td class="client-id"><%= c.getIdentifiantOriginal() %></td>
                            <td><%= c.getVille() %></td>
                            <td><%= c.getCodePostal() %></td>
                            <td>
                                <span class="revenue-badge">
                                    <%= String.format("%,.2f", c.getRevenuMensuel()) %> €
                                </span>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- PAGINATION -->
            <% if (totalPages > 1) { %>
            <nav aria-label="Navigation des pages" class="mt-4">
                <ul class="pagination pagination-gold justify-content-center">
                    <!-- Bouton Précédent -->
                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %><%= searchParams %>" aria-label="Précédent">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </li>
                    
                    <%
                        // Afficher les numéros de page
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        // Première page
                        if (startPage > 1) {
                    %>
                        <li class="page-item">
                            <a class="page-link" href="?page=1<%= searchParams %>">1</a>
                        </li>
                        <% if (startPage > 2) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                    <% } %>
                    
                    <!-- Pages numérotées -->
                    <% for (int i = startPage; i <= endPage; i++) { %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %><%= searchParams %>"><%= i %></a>
                        </li>
                    <% } %>
                    
                    <!-- Dernière page -->
                    <% if (endPage < totalPages) { %>
                        <% if (endPage < totalPages - 1) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item">
                            <a class="page-link" href="?page=<%= totalPages %><%= searchParams %>"><%= totalPages %></a>
                        </li>
                    <% } %>
                    
                    <!-- Bouton Suivant -->
                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %><%= searchParams %>" aria-label="Suivant">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
            <% } %>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>