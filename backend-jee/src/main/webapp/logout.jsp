<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat" %>
<%
    // Récupération des informations de session avant destruction
    String agentName = (session != null && session.getAttribute("agentName") != null) 
                       ? (String) session.getAttribute("agentName") 
                       : "Agent bancaire";
    String agentId = (session != null && session.getAttribute("agentId") != null) 
                     ? (String) session.getAttribute("agentId") 
                     : "";
    
    // Logging de la déconnexion pour audit
    if (session != null && agentId != null && !agentId.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        System.out.println("[AUDIT BOA] Agent " + agentId + " - " + agentName + " déconnecté le " + sdf.format(new Date()));
    }
    
    // Destruction de la session
    if (session != null) {
        session.invalidate();
    }
    
    // Prévention du cache pour sécurité
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Déconnexion | Banque Digitale</title>
    
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
            background: linear-gradient(135deg, var(--boa-blue) 0%, var(--boa-dark) 100%);
            font-family: "Segoe UI", sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        /* Pattern de fond luxueux */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                repeating-linear-gradient(45deg, transparent, transparent 60px, rgba(201,162,63,0.05) 60px, rgba(201,162,63,0.05) 120px);
            pointer-events: none;
        }
        
        /* Cercles décoratifs animés */
        .decoration-circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(201, 162, 63, 0.1);
            animation: float 20s infinite ease-in-out;
        }
        
        .circle-1 {
            width: 300px;
            height: 300px;
            top: -100px;
            right: -100px;
        }
        
        .circle-2 {
            width: 200px;
            height: 200px;
            bottom: -50px;
            left: -50px;
            animation-delay: 5s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-30px) scale(1.1); }
        }
        
        .logout-container {
            background: white;
            padding: 50px 60px;
            border-radius: 24px;
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4);
            text-align: center;
            max-width: 520px;
            width: 90%;
            position: relative;
            z-index: 10;
            animation: slideUp 0.8s ease-out;
            border-top: 5px solid var(--boa-gold);
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .logo-section {
            margin-bottom: 30px;
        }
        
        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(90deg, var(--boa-blue), var(--boa-dark));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 20px rgba(0, 58, 143, 0.3);
        }
        
        .logo-icon i {
            font-size: 2.5rem;
            color: var(--boa-gold);
        }
        
        .bank-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--boa-blue);
            margin-bottom: 5px;
        }
        
        .bank-subtitle {
            font-size: 0.9rem;
            color: var(--boa-gold);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }
        
        .divider {
            width: 60px;
            height: 3px;
            background: var(--boa-gold);
            margin: 25px auto;
            border-radius: 2px;
        }
        
        .success-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            animation: checkmark 0.6s ease-in-out 0.3s both;
        }
        
        .success-icon i {
            font-size: 2rem;
            color: white;
        }
        
        @keyframes checkmark {
            0% {
                transform: scale(0) rotate(-45deg);
                opacity: 0;
            }
            50% {
                transform: scale(1.1) rotate(10deg);
            }
            100% {
                transform: scale(1) rotate(0deg);
                opacity: 1;
            }
        }
        
        .logout-title {
            color: var(--boa-dark);
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .agent-card {
            background: linear-gradient(135deg, rgba(0, 58, 143, 0.05), rgba(201, 162, 63, 0.05));
            padding: 20px;
            border-radius: 16px;
            margin: 25px 0;
            border-left: 4px solid var(--boa-gold);
        }
        
        .agent-card p {
            margin: 8px 0;
            color: var(--boa-dark);
            font-size: 0.95rem;
        }
        
        .agent-card strong {
            color: var(--boa-blue);
            font-weight: 600;
        }
        
        .security-box {
            background: rgba(0, 58, 143, 0.05);
            padding: 15px;
            border-radius: 12px;
            margin: 20px 0;
            border: 1px solid rgba(0, 58, 143, 0.1);
        }
        
        .security-box p {
            font-size: 0.9rem;
            color: #555;
            margin: 0;
            line-height: 1.6;
        }
        
        .security-box i {
            color: var(--boa-gold);
            margin-right: 8px;
        }
        
        .redirect-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin: 25px 0;
            color: #666;
            font-size: 0.9rem;
        }
        
        .spinner {
            width: 20px;
            height: 20px;
            border: 3px solid rgba(201, 162, 63, 0.3);
            border-top-color: var(--boa-gold);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .btn-gold {
            background-color: var(--boa-gold);
            color: white;
            border: none;
            border-radius: 30px;
            font-weight: 600;
            padding: 12px 35px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 6px 20px rgba(201, 162, 63, 0.3);
        }
        
        .btn-gold:hover {
            background-color: #b18e32;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(201, 162, 63, 0.4);
            color: white;
        }
        
        .btn-gold i {
            margin-right: 8px;
        }
        
        .footer-text {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(0, 58, 143, 0.1);
            font-size: 0.85rem;
            color: #888;
        }
        
        @media (max-width: 576px) {
            .logout-container {
                padding: 40px 30px;
            }
            
            .bank-title {
                font-size: 1.3rem;
            }
            
            .logout-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body>
    <div class="decoration-circle circle-1"></div>
    <div class="decoration-circle circle-2"></div>
    
    <div class="logout-container">
        <!-- Logo -->
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fa-solid fa-building-columns"></i>
            </div>
            <h1 class="bank-title">Banque Digitale</h1>
            <p class="bank-subtitle">Espace Agent Bancaire</p>
        </div>
        
        <div class="divider"></div>
        
        <!-- Icône succès -->
        <div class="success-icon">
            <i class="fa-solid fa-check"></i>
        </div>
        
        <!-- Message -->
        <h2 class="logout-title">Déconnexion réussie</h2>
        
        <!-- Informations agent -->
        <% if (agentName != null && !agentName.equals("Agent bancaire")) { %>
        <div class="agent-card">
            <p><i class="fa-solid fa-user-tie"></i> <strong>Agent :</strong> <%= agentName %></p>
            <% if (agentId != null && !agentId.isEmpty()) { %>
            <p><i class="fa-solid fa-id-card"></i> <strong>ID :</strong> <%= agentId %></p>
            <% } %>
            <p><i class="fa-solid fa-clock"></i> <strong>Heure :</strong> 
                <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()) %>
            </p>
        </div>
        <% } %>
        
        <!-- Sécurité -->
        <div class="security-box">
            <p>
                <i class="fa-solid fa-shield-halved"></i>
                Votre session a été fermée en toute sécurité. Pensez à fermer votre navigateur si vous utilisez un poste partagé.
            </p>
        </div>
        
        <!-- Redirection -->
        <div class="redirect-info">
            <div class="spinner"></div>
            <span>Redirection automatique dans quelques instants...</span>
        </div>
        
        <!-- Bouton -->
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-gold">
            <i class="fa-solid fa-right-to-bracket"></i>
            Retour à la connexion
        </a>
        
        <!-- Footer -->
        <div class="footer-text">
            <p>
                <i class="fa-solid fa-lock"></i>
                Connexion sécurisée SSL · Banque Digitale © 2026
            </p>
        </div>
    </div>
    
    <script>
        // Redirection auto après 5 secondes
        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/login.jsp';
        }, 5000);
        
        // Empêcher retour arrière
        history.pushState(null, null, location.href);
        window.onpopstate = function() {
            history.go(1);
        };
    </script>
</body>
</html>