<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Vérification de session agent
    String agentName = (session != null && session.getAttribute("agentName") != null) 
                       ? (String) session.getAttribute("agentName") 
                       : "Agent";
    String agentId = (session != null && session.getAttribute("agentId") != null) 
                     ? (String) session.getAttribute("agentId") 
                     : "";
    
    // Récupération des messages de notification
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String infoMessage = (String) request.getAttribute("infoMessage");
    
    // Récupération depuis les paramètres URL (si redirection avec paramètres)
    if (successMessage == null) successMessage = request.getParameter("success");
    if (errorMessage == null) errorMessage = request.getParameter("error");
    if (infoMessage == null) infoMessage = request.getParameter("info");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Agent | Banque Digitale</title>

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
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
            letter-spacing: 0.5px;
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

        /* Alert Notifications */
        .alert-notification {
            border: none;
            border-radius: 12px;
            padding: 18px 24px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            animation: slideInDown 0.5s ease-out;
            position: relative;
            overflow: hidden;
        }

        .alert-notification::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
        }

        .alert-notification.alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }

        .alert-notification.alert-success::before {
            background: #28a745;
        }

        .alert-notification.alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }

        .alert-notification.alert-danger::before {
            background: #dc3545;
        }

        .alert-notification.alert-info {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            color: #0c5460;
        }

        .alert-notification.alert-info::before {
            background: #17a2b8;
        }

        .alert-notification .alert-icon {
            font-size: 1.5rem;
            margin-right: 15px;
            vertical-align: middle;
        }

        .alert-notification .alert-content {
            display: inline-block;
            vertical-align: middle;
            max-width: calc(100% - 100px);
        }

        .alert-notification .alert-title {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }

        .alert-notification .alert-message {
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .alert-notification .btn-close {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            opacity: 0.6;
            transition: opacity 0.2s;
        }

        .alert-notification .btn-close:hover {
            opacity: 1;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header Section */
        .page-header {
            background: linear-gradient(135deg, rgba(0, 58, 143, 0.05), rgba(201, 162, 63, 0.05));
            padding: 40px 0;
            margin-bottom: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .page-header h3 {
            color: var(--boa-dark);
            font-weight: 700;
            margin-bottom: 10px;
        }

        .role-badge {
            display: inline-block;
            background: var(--boa-gold);
            color: white;
            padding: 6px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            box-shadow: 0 3px 10px rgba(201, 162, 63, 0.3);
        }

        .info-text {
            color: #666;
            font-size: 0.95rem;
            margin-top: 15px;
        }

        /* Cards */
        .dashboard-card {
            border-radius: 18px;
            border: none;
            transition: all 0.3s ease;
            height: 100%;
            background: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--boa-blue), var(--boa-gold));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .dashboard-card:hover::before {
            transform: scaleX(1);
        }

        .icon-box {
            width: 70px;
            height: 70px;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--boa-blue), var(--boa-dark));
            color: var(--boa-gold);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 20px;
            box-shadow: 0 6px 20px rgba(0, 58, 143, 0.25);
            transition: all 0.3s ease;
        }

        .dashboard-card:hover .icon-box {
            transform: scale(1.1) rotate(5deg);
        }

        .card-title {
            font-weight: 700;
            color: var(--boa-dark);
            margin-bottom: 12px;
            font-size: 1.1rem;
        }

        .card-description {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 20px;
            min-height: 40px;
        }

        .permission-badge {
            display: inline-block;
            font-size: 0.75rem;
            padding: 4px 12px;
            border-radius: 12px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .badge-view {
            background: rgba(23, 162, 184, 0.15);
            color: #17a2b8;
            border: 1px solid rgba(23, 162, 184, 0.3);
        }

        .badge-request {
            background: rgba(255, 193, 7, 0.15);
            color: #d39e00;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }

        .btn-gold {
            background-color: var(--boa-gold);
            color: white;
            border: none;
            border-radius: 30px;
            font-weight: 600;
            padding: 10px 28px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(201, 162, 63, 0.3);
        }

        .btn-gold:hover {
            background-color: #b18e32;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(201, 162, 63, 0.4);
            color: white;
        }

        .btn-gold i {
            margin-right: 6px;
        }

        /* Info Box */
        .info-box {
            background: linear-gradient(135deg, rgba(0, 58, 143, 0.05), rgba(201, 162, 63, 0.05));
            border-left: 4px solid var(--boa-gold);
            padding: 20px;
            border-radius: 12px;
            margin-top: 40px;
        }

        .info-box h5 {
            color: var(--boa-blue);
            font-weight: 700;
            margin-bottom: 12px;
            font-size: 1rem;
        }

        .info-box ul {
            margin: 0;
            padding-left: 20px;
            color: #555;
        }

        .info-box li {
            margin-bottom: 8px;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 20px;
            }

            .dashboard-card {
                margin-bottom: 20px;
            }

            .navbar-brand {
                font-size: 1.1rem;
            }

            .alert-notification .alert-content {
                max-width: calc(100% - 60px);
            }
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand">
            <i class="fa-solid fa-building-columns me-2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto align-items-center">
            <span class="nav-link text-white agent-badge me-3">
                <i class="fa-solid fa-user-tie me-2"></i>
                <%= agentName %>
                <% if (!agentId.isEmpty()) { %>
                    <span style="opacity: 0.7; font-size: 0.85rem;"> (ID: <%= agentId %>)</span>
                <% } %>
            </span>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout.jsp">
                <i class="fa-solid fa-right-from-bracket me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <!-- NOTIFICATIONS -->
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    <div class="alert alert-notification alert-success alert-dismissible fade show" role="alert">
        <i class="fa-solid fa-circle-check alert-icon"></i>
        <div class="alert-content">
            <div class="alert-title">Succès !</div>
            <div class="alert-message"><%= successMessage %></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert alert-notification alert-danger alert-dismissible fade show" role="alert">
        <i class="fa-solid fa-circle-exclamation alert-icon"></i>
        <div class="alert-content">
            <div class="alert-title">Erreur</div>
            <div class="alert-message"><%= errorMessage %></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% if (infoMessage != null && !infoMessage.isEmpty()) { %>
    <div class="alert alert-notification alert-info alert-dismissible fade show" role="alert">
        <i class="fa-solid fa-circle-info alert-icon"></i>
        <div class="alert-content">
            <div class="alert-title">Information</div>
            <div class="alert-message"><%= infoMessage %></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <!-- HEADER -->
    <div class="page-header text-center">
        <h3>Espace Agent Bancaire</h3>
        <span class="role-badge">
            <i class="fa-solid fa-eye me-2"></i>Consultation & Demandes
        </span>
        <p class="info-text">
            <i class="fa-solid fa-info-circle me-2"></i>
            Vous pouvez consulter les clients et prêts, et soumettre des demandes de prêt pour validation administrative
        </p>
    </div>

    <!-- DASHBOARD CARDS -->
    <div class="row g-4">

        <!-- CLIENTS -->
        <div class="col-lg-3 col-md-6">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto">
                    <i class="fa-solid fa-users"></i>
                </div>
                <span class="permission-badge badge-view">
                    <i class="fa-solid fa-eye me-1"></i>Consultation
                </span>
                <h6 class="card-title">Base Clients</h6>
                <p class="card-description">Consulter la liste des clients enregistrés et leurs informations</p>
                <a href="${pageContext.request.contextPath}/aff_clients" class="btn btn-gold">
                    <i class="fa-solid fa-list"></i>Consulter
                </a>
            </div>
        </div>

        <!-- PRÊTS -->
        <div class="col-lg-3 col-md-6">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto">
                    <i class="fa-solid fa-hand-holding-dollar"></i>
                </div>
                <span class="permission-badge badge-view">
                    <i class="fa-solid fa-eye me-1"></i>Consultation
                </span>
                <h6 class="card-title">Prêts Existants</h6>
                <p class="card-description">Consulter les prêts accordés et leur statut de remboursement</p>
                <a href="${pageContext.request.contextPath}/agent_bancaire/prets" class="btn btn-gold">
                    <i class="fa-solid fa-list"></i>Consulter
                </a>
            </div>
        </div>

        <!-- DEMANDER PRÊT -->
        <div class="col-lg-3 col-md-6">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto">
                    <i class="fa-solid fa-file-circle-plus"></i>
                </div>
                <span class="permission-badge badge-request">
                    <i class="fa-solid fa-paper-plane me-1"></i>Demande
                </span>
                <h6 class="card-title">Demander un Prêt</h6>
                <p class="card-description">Soumettre une nouvelle demande de prêt (validation admin requise)</p>
                <a href="${pageContext.request.contextPath}/agent_bancaire/CreerPret.jsp" class="btn btn-gold">
                    <i class="fa-solid fa-plus"></i>Créer une demande
                </a>
            </div>
        </div>

        <!-- ANALYSE IA -->
        <div class="col-lg-3 col-md-6">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto">
                    <i class="fa-solid fa-brain"></i>
                </div>
                <span class="permission-badge badge-view">
                    <i class="fa-solid fa-chart-line me-1"></i>Analyse
                </span>
                <h6 class="card-title">Analyse IA</h6>
                <p class="card-description">Utiliser l'IA pour prédire le risque de défaut d'un client</p>
                <a href="${pageContext.request.contextPath}/Agent_prediction" class="btn btn-gold">
                    <i class="fa-solid fa-robot"></i>Analyser
                </a>
            </div>
        </div>

    </div>

    <!-- INFO BOX -->
    <div class="info-box">
        <h5>
            <i class="fa-solid fa-shield-halved me-2"></i>
            Vos permissions en tant qu'Agent Bancaire
        </h5>
        <ul>
            <li><strong>Consultation :</strong> Accès en lecture seule à la base de données clients et prêts</li>
            <li><strong>Demandes de prêt :</strong> Création de nouvelles demandes nécessitant validation administrative</li>
            <li><strong>Analyse IA :</strong> Utilisation de l'outil d'analyse de risque pour évaluer les dossiers</li>
            <li><strong>Validation :</strong> Toute demande de prêt doit être approuvée par un administrateur avant traitement</li>
        </ul>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-fermeture des alertes après 8 secondes
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert-notification');
        
        alerts.forEach(function(alert) {
            setTimeout(function() {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 8000);
        });
    });
</script>

</body>
</html>