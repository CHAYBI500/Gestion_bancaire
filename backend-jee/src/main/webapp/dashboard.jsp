<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrateur | Banque Digitale</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #234999;
            --secondary-blue: #4986BF;
            --accent-purple: #746BAA;
            --gold-accent: #D4AF37;
            --dark-blue: #1a3670;
            --light-gray: #f8f9fa;
            --danger-red: #dc3545;
            --warning-orange: #fd7e14;
            --success-green: #28a745;
        }

        body {
            background: linear-gradient(135deg, #f0f4f8 0%, #e2e8f0 100%);
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            min-height: 100vh;
        }

        /* NAVBAR AMÉLIORÉE */
        .navbar {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            letter-spacing: 0.5px;
            color: white !important;
        }

        .admin-badge {
            background: linear-gradient(135deg, var(--gold-accent), #b8941f);
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 1rem;
            box-shadow: 0 2px 8px rgba(212, 175, 55, 0.3);
        }

        /* NOTIFICATIONS BELL */
        .notification-wrapper {
            position: relative;
            display: inline-block;
        }

        .notification-bell {
            position: relative;
            background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            padding: 0.6rem 0.8rem;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1.3rem;
        }

        .notification-bell:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: scale(1.05);
        }

        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: linear-gradient(135deg, var(--danger-red), #c82333);
            color: white;
            border-radius: 50%;
            width: 26px;
            height: 26px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.4);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.15);
            }
        }

        /* DROPDOWN NOTIFICATIONS */
        .notification-dropdown {
            position: absolute;
            top: 115%;
            right: 0;
            background: white;
            border-radius: 16px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
            width: 420px;
            max-height: 550px;
            overflow: hidden;
            display: none;
            z-index: 1000;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .notification-dropdown.show {
            display: block;
        }

        .notification-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
            padding: 1.25rem 1.5rem;
            border-radius: 16px 16px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h6 {
            margin: 0;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .notification-count {
            background: rgba(255, 255, 255, 0.25);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .notification-body {
            max-height: 450px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #e9ecef;
            transition: all 0.3s ease;
            cursor: pointer;
            background: white;
        }

        .notification-item:hover {
            background: linear-gradient(135deg, rgba(35, 73, 153, 0.05), rgba(73, 134, 191, 0.05));
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-item.unread {
            background: linear-gradient(135deg, rgba(35, 73, 153, 0.08), rgba(73, 134, 191, 0.08));
            border-left: 4px solid var(--primary-blue);
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-right: 1rem;
        }

        .notification-icon.warning {
            background: linear-gradient(135deg, #fff3cd, #ffe5a1);
            color: var(--warning-orange);
        }

        .notification-icon.danger {
            background: linear-gradient(135deg, #f8d7da, #f5c2c7);
            color: var(--danger-red);
        }

        .notification-icon.info {
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--dark-blue);
            margin-bottom: 0.3rem;
        }

        .notification-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 0.4rem;
            line-height: 1.4;
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.5rem;
        }

        .notification-time {
            font-size: 0.75rem;
            color: #adb5bd;
        }

        .notification-risk {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .risk-high {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }

        .risk-medium {
            background: linear-gradient(135deg, #fd7e14, #e8590c);
            color: white;
        }

        .notification-footer {
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            border-radius: 0 0 16px 16px;
            text-align: center;
        }

        .notification-footer a {
            color: var(--primary-blue);
            font-weight: 600;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s;
        }

        .notification-footer a:hover {
            color: var(--dark-blue);
        }

        /* WELCOME SECTION */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            border-radius: 20px;
            padding: 3rem 2.5rem;
            margin-bottom: 2.5rem;
            color: white;
            box-shadow: 0 10px 30px rgba(35, 73, 153, 0.3);
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .welcome-content {
            position: relative;
            z-index: 1;
        }

        .welcome-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* STATS CARDS */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 18px;
            padding: 1.75rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .stat-icon {
            width: 65px;
            height: 65px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 1rem;
        }

        .stat-icon.blue {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
        }

        .stat-icon.gold {
            background: linear-gradient(135deg, var(--gold-accent), #b8941f);
            color: white;
        }

        .stat-icon.danger {
            background: linear-gradient(135deg, var(--danger-red), #c82333);
            color: white;
        }

        .stat-icon.success {
            background: linear-gradient(135deg, var(--success-green), #218838);
            color: white;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-blue);
            margin-bottom: 0.3rem;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .stat-trend {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            padding: 0.3rem 0.8rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 0.8rem;
        }

        .stat-trend.up {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-green);
        }

        .stat-trend.down {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-red);
        }

        /* DASHBOARD CARDS */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .dashboard-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .dashboard-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .card-icon {
            width: 80px;
            height: 80px;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: var(--gold-accent);
            box-shadow: 0 8px 20px rgba(35, 73, 153, 0.3);
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--dark-blue);
            margin-bottom: 0.8rem;
        }

        .card-description {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .btn-card {
            background: linear-gradient(135deg, var(--gold-accent), #b8941f);
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
            color: white;
        }

        /* FOOTER */
        footer {
            background: linear-gradient(135deg, var(--dark-blue), #0a1628);
            color: #cbd5e0;
            padding: 3rem 0 1.5rem;
            margin-top: 5rem;
        }

        footer h5 {
            color: var(--gold-accent);
            font-weight: 700;
            margin-bottom: 1.2rem;
        }

        footer i {
            color: var(--gold-accent);
            margin-right: 0.75rem;
        }

        footer .copyright {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 2.5rem;
            padding-top: 1.5rem;
            text-align: center;
            font-size: 0.9rem;
            color: #a0aec0;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .notification-dropdown {
                width: 90vw;
                right: -20px;
            }

            .welcome-title {
                font-size: 1.5rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="fa-solid fa-building-columns me-2"></i>
            Banque Digitale
        </a>
        
        <div class="d-flex align-items-center ms-auto">
            <!-- Notifications -->
            <div class="notification-wrapper me-4">
                <div class="notification-bell" onclick="toggleNotifications()">
                    <i class="fa-solid fa-bell"></i>
                    <span class="notification-badge" id="notifCount">5</span>
                </div>
                
                <!-- Dropdown Notifications -->
                <div class="notification-dropdown" id="notificationDropdown">
                    <div class="notification-header">
                        <h6><i class="fa-solid fa-bell me-2"></i>Notifications</h6>
                        <span class="notification-count">5 nouvelles</span>
                    </div>
                    
                    <div class="notification-body">
                        <!-- Notification 1 - Risque Élevé -->
                        <div class="notification-item unread" onclick="goToDetail(1234)">
                            <div class="d-flex">
                                <div class="notification-icon danger">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Demande de prêt à risque élevé</div>
                                    <div class="notification-text">
                                        Client: Ahmed Benali - Prêt Immobilier 250 000 MAD
                                    </div>
                                    <div class="notification-meta">
                                        <span class="notification-time">
                                            <i class="fa-regular fa-clock me-1"></i>Il y a 15 min
                                        </span>
                                        <span class="notification-risk risk-high">
                                            <i class="fa-solid fa-fire me-1"></i>RISQUE ÉLEVÉ
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Notification 2 - Risque Moyen -->
                        <div class="notification-item unread" onclick="goToDetail(1235)">
                            <div class="d-flex">
                                <div class="notification-icon warning">
                                    <i class="fa-solid fa-exclamation-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Validation requise - Risque moyen</div>
                                    <div class="notification-text">
                                        Client: Fatima Zahra - Prêt Automobile 150 000 MAD
                                    </div>
                                    <div class="notification-meta">
                                        <span class="notification-time">
                                            <i class="fa-regular fa-clock me-1"></i>Il y a 1h
                                        </span>
                                        <span class="notification-risk risk-medium">
                                            <i class="fa-solid fa-exclamation me-1"></i>RISQUE MOYEN
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Notification 3 - Agent Bancaire -->
                        <div class="notification-item unread" onclick="goToDetail(1236)">
                            <div class="d-flex">
                                <div class="notification-icon warning">
                                    <i class="fa-solid fa-user-tie"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Demande agent bancaire</div>
                                    <div class="notification-text">
                                        Agent: Karim El Fassi - Prêt Immobilier 320 000 MAD
                                    </div>
                                    <div class="notification-meta">
                                        <span class="notification-time">
                                            <i class="fa-regular fa-clock me-1"></i>Il y a 2h
                                        </span>
                                        <span class="notification-risk risk-medium">
                                            <i class="fa-solid fa-exclamation me-1"></i>RISQUE MOYEN
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Notification 4 - Risque Élevé -->
                        <div class="notification-item" onclick="goToDetail(1237)">
                            <div class="d-flex">
                                <div class="notification-icon danger">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Attention - Taux endettement élevé</div>
                                    <div class="notification-text">
                                        Client: Mohammed Alami - Prêt Automobile 180 000 MAD
                                    </div>
                                    <div class="notification-meta">
                                        <span class="notification-time">
                                            <i class="fa-regular fa-clock me-1"></i>Il y a 3h
                                        </span>
                                        <span class="notification-risk risk-high">
                                            <i class="fa-solid fa-fire me-1"></i>RISQUE ÉLEVÉ
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Notification 5 - Info -->
                        <div class="notification-item" onclick="goToDetail(1238)">
                            <div class="d-flex">
                                <div class="notification-icon info">
                                    <i class="fa-solid fa-info-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Révision de dossier nécessaire</div>
                                    <div class="notification-text">
                                        Client: Salma Bennani - Prêt Immobilier 280 000 MAD
                                    </div>
                                    <div class="notification-meta">
                                        <span class="notification-time">
                                            <i class="fa-regular fa-clock me-1"></i>Il y a 5h
                                        </span>
                                        <span class="notification-risk risk-medium">
                                            <i class="fa-solid fa-exclamation me-1"></i>RISQUE MOYEN
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="notification-footer">
    <a href="${pageContext.request.contextPath}/DecisionServlet" class="btn-card">
                            <i class="fa-solid fa-list me-2"></i>Voir toutes les demandes en attente
                        </a>
                    </div>
                </div>
            </div>

            <!-- User Info -->
            <div class="text-white me-3">
                <i class="fa-solid fa-user-shield me-2"></i>
                <strong>${sessionScope.user.username}</strong>
                <span class="admin-badge">
                    <i class="fa-solid fa-crown me-1"></i>ADMIN
                </span>
            </div>

            <!-- Logout -->
            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout.jsp">
                <i class="fa-solid fa-right-from-bracket me-1"></i>
                Déconnexion
            </a>
        </div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<div class="container mt-5">
    
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="welcome-content">
            <div class="welcome-title">
                <i class="fa-solid fa-hand-wave me-2"></i>
                Bienvenue, ${sessionScope.user.username}
            </div>
            <div class="welcome-subtitle">
                Tableau de bord administrateur - Gestion complète du système bancaire
            </div>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue">
                <i class="fa-solid fa-users"></i>
            </div>
            <div class="stat-value">1,247</div>
            <div class="stat-label">Clients Actifs</div>
            <div class="stat-trend up">
                <i class="fa-solid fa-arrow-up"></i>+12% ce mois
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon gold">
                <i class="fa-solid fa-hand-holding-dollar"></i>
            </div>
            <div class="stat-value">342</div>
            <div class="stat-label">Prêts en Cours</div>
            <div class="stat-trend up">
                <i class="fa-solid fa-arrow-up"></i>+8% ce mois
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon danger">
                <i class="fa-solid fa-clock-rotate-left"></i>
            </div>
            <div class="stat-value">5</div>
            <div class="stat-label">Demandes en Attente</div>
            <div class="stat-trend down">
                <i class="fa-solid fa-arrow-down"></i>Action requise
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon success">
                <i class="fa-solid fa-chart-line"></i>
            </div>
            <div class="stat-value">87.3%</div>
            <div class="stat-label">Taux d'Approbation</div>
            <div class="stat-trend up">
                <i class="fa-solid fa-arrow-up"></i>+3.2% ce mois
            </div>
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="dashboard-cards">
        
        <!-- Clients -->
        <div class="dashboard-card">
            <div class="card-icon">
                <i class="fa-solid fa-user-group"></i>
            </div>
            <h5 class="card-title">Gestion des Clients</h5>
            <p class="card-description">
                Consultation, ajout et suivi complet des clients bancaires avec historique détaillé
            </p>
            <a href="${pageContext.request.contextPath}/clients" class="btn-card">
                <i class="fa-solid fa-arrow-right me-2"></i>Accéder
            </a>
        </div>

        <!-- Prêts -->
        <div class="dashboard-card">
            <div class="card-icon">
                <i class="fa-solid fa-hand-holding-dollar"></i>
            </div>
            <h5 class="card-title">Gestion des Prêts</h5>
            <p class="card-description">
                Suivi intelligent des prêts immobiliers et automobiles avec système d'approbation
            </p>
            <a href="${pageContext.request.contextPath}/prets" class="btn-card">
                <i class="fa-solid fa-arrow-right me-2"></i>Voir les prêts
            </a>
        </div>

        <!-- IA & Prédiction -->
        <div class="dashboard-card">
            <div class="card-icon">
                <i class="fa-solid fa-brain"></i>
            </div>
            <h5 class="card-title">IA & Analyse de Risque</h5>
            <p class="card-description">
                Prédiction du risque de défaut basée sur Machine Learning et analyse prédictive
            </p>
            <a href="${pageContext.request.contextPath}/prediction" class="btn-card">
                <i class="fa-solid fa-arrow-right me-2"></i>Analyser
            </a>
        </div>

<div class="dashboard-card">
    <div class="card-icon">
        <i class="fa-solid fa-clipboard-check"></i>
    </div>
    <h5 class="card-title">Demandes en Attente</h5>
    <p class="card-description">
        Valider ou rejeter les demandes de prêts à risque moyen et élevé nécessitant votre approbation
    </p>
    
    <a href="${pageContext.request.contextPath}/DecisionServlet" class="btn-card">
        <i class="fa-solid fa-arrow-right me-2"></i>Traiter (5)
    </a>
</div>

        <!-- Rapports -->
        <div class="dashboard-card">
            <div class="card-icon">
                <i class="fa-solid fa-chart-pie"></i>
            </div>
            <h5 class="card-title">Rapports & Statistiques</h5>
            <p class="card-description">
                Tableaux de bord analytiques, KPIs et rapports détaillés sur l'activité bancaire
            </p>
            <a href="${pageContext.request.contextPath}/rapports" class="btn-card">
    <i class="fa-solid fa-arrow-right me-2"></i>Consulter
</a>
        </div>

    </div>
</div>

<!-- FOOTER -->
<footer>
    <div class="container">
        <div class="row">
            
            <!-- À propos -->
            <div class="col-md-4 mb-4">
                <h5><i class="fa-solid fa-building-columns me-2"></i>À propos</h5>
                <p style="line-height: 1.8;">
                    Plateforme bancaire digitale avancée basée sur JEE pour la gestion complète des clients et prêts bancaires. 
                    Intégration d'intelligence artificielle pour la prédiction de risque et l'aide à la décision.
                </p>
            </div>

            <!-- Contact -->
            <div class="col-md-4 mb-4">
                <h5><i class="fa-solid fa-headset me-2"></i>Contact</h5>
                <p><i class="fa-solid fa-envelope"></i>contact@banquedigitale.ma</p>
                <p><i class="fa-solid fa-phone"></i>+212 5 22 XX XX XX</p>
                <p><i class="fa-solid fa-fax"></i>+212 5 22 XX XX XX</p>
            </div>

            <!-- Adresse -->
            <div class="col-md-4 mb-4">
                <h5><i class="fa-solid fa-location-dot me-2"></i>Siège Social</h5>
                <p>
                    <i class="fa-solid fa-building"></i>
                    ISGA Casablanca<br>
                    Route El Jadida, Km 9.5<br>
                    Casablanca 20270, Maroc
                </p>
            </div>
        </div>

        <div class="copyright">
            <i class="fa-solid fa-shield-halved me-2"></i>
            © 2026 Banque Digitale - Tous droits réservés
            <span class="mx-3">|</span>
            Projet JEE & Machine Learning
            <span class="mx-3">|</span>
            <i class="fa-solid fa-lock me-1"></i>Plateforme Sécurisée
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle Notifications Dropdown
    function toggleNotifications() {
        const dropdown = document.getElementById('notificationDropdown');
        dropdown.classList.toggle('show');
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const notifWrapper = document.querySelector('.notification-wrapper');
        const dropdown = document.getElementById('notificationDropdown');
        
        if (!notifWrapper.contains(event.target)) {
            dropdown.classList.remove('show');
        }
    });

    // Go to detail page
    function goToDetail(idPret) {
        window.location.href = '${pageContext.request.contextPath}/prets?action=detail&id=' + idPret;
    }

    // Mark notification as read (animation)
    document.querySelectorAll('.notification-item').forEach(item => {
        item.addEventListener('click', function() {
            this.classList.remove('unread');
            
            // Update notification count
            const badge = document.getElementById('notifCount');
            let count = parseInt(badge.textContent);
            if (count > 0) {
                badge.textContent = count - 1;
                
                // Hide badge if count is 0
                if (count - 1 === 0) {
                    badge.style.display = 'none';
                }
            }
        });
    });

    // Animation on page load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.dashboard-card, .stat-card');
        cards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'all 0.5s ease';
                
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 100);
            }, index * 100);
        });
    });

    // Bell shake animation on new notification
    setInterval(() => {
        const bell = document.querySelector('.notification-bell');
        bell.style.animation = 'none';
        setTimeout(() => {
            bell.style.animation = 'shake 0.5s ease';
        }, 10);
    }, 30000); // Every 30 seconds

    // Shake animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(-10deg); }
            75% { transform: rotate(10deg); }
        }
    `;
    document.head.appendChild(style);
</script>
<script>

</body>
</html>