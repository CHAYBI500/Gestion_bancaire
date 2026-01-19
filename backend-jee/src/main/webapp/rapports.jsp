<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.banque.model.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Récupération du rapport Flask IA
    org.json.JSONObject flaskReport = (org.json.JSONObject) request.getAttribute("flaskReport");
    
    // Récupération et traitement des prêts
    List<Pret> prets = (List<Pret>) request.getAttribute("prets");
    if (prets == null) prets = new ArrayList<>();
    
    // Calculs KPI
    double totalEncours = prets.stream().mapToDouble(Pret::getMensualite).sum();
    double moyenneEndettement = prets.isEmpty() ? 0 : prets.stream().mapToDouble(Pret::getTauxEndettementPourcentage).average().orElse(0.0);
    double volumeTotalFinance = prets.stream().mapToDouble(Pret::getMontantTotal).sum();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Risk & Analytics | Dashboard Premium</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

    <style>
        :root {
            --primary-blue: #1e3a8a;
            --dark-blue: #1a3670;
            --gold-accent: #D4AF37;
            --deep-navy: #0a1628;
            --danger-soft: #fff5f5;
        }

        body {
            background-color: #f4f7f9;
            font-family: 'Inter', -apple-system, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-wrapper { flex: 1; }

        .premium-header {
            background: linear-gradient(135deg, var(--deep-navy) 0%, var(--primary-blue) 100%);
            color: white;
            padding: 50px 0 80px;
            border-bottom: 3px solid var(--gold-accent);
        }

        .kpi-card {
            background: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            margin-top: -40px;
            transition: 0.3s;
        }
        .kpi-card:hover { transform: translateY(-5px); }
        
        .icon-circle {
            width: 45px; height: 45px;
            background: rgba(30, 58, 138, 0.1);
            color: var(--primary-blue);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }

        .glass-panel {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid #edf2f7;
        }

        .table-premium thead {
            background-color: #f8fafc;
            color: var(--primary-blue);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
        }

        .badge-risk {
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .page-item.active .page-link {
            background-color: var(--primary-blue);
            border-color: var(--primary-blue);
        }
        .dataTables_wrapper .dataTables_filter input {
            border-radius: 20px;
            border: 1px solid #ddd;
            padding: 5px 15px;
        }

        /* Styles pour les graphiques générés */
        .graph-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #edf2f7;
            overflow: hidden;
        }

        .graph-container img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            transition: transform 0.3s ease;
        }

        .graph-container:hover img {
            transform: scale(1.02);
        }

        .graph-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #edf2f7;
            display: flex;
            align-items: center;
        }

        .graph-title i {
            margin-right: 10px;
            color: var(--gold-accent);
        }

        footer {
            background: var(--deep-navy);
            color: #8a99af;
            padding: 40px 0 20px;
            margin-top: 60px;
        }

        /* Styles d'impression pour PDF */
        @media print {
            body {
                background: white;
                margin: 0;
                padding: 0;
            }

            .premium-header {
                background: var(--primary-blue) !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
                page-break-after: avoid;
            }

            .btn, .dataTables_wrapper .dataTables_filter,
            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_info,
            .dataTables_wrapper .dataTables_paginate {
                display: none !important;
            }

            .kpi-card, .glass-panel, .graph-container {
                box-shadow: none !important;
                border: 1px solid #ddd !important;
                page-break-inside: avoid;
            }

            .kpi-card {
                margin-top: 20px !important;
            }

            .table-premium {
                font-size: 0.85rem;
            }

            .graph-container {
                page-break-inside: avoid;
                margin-bottom: 20px;
            }

            .row {
                page-break-inside: avoid;
            }

            h5, h6 {
                page-break-after: avoid;
            }

            footer {
                page-break-before: always;
                background: var(--deep-navy) !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            /* Afficher toutes les lignes du tableau */
            #riskTable tbody tr {
                display: table-row !important;
            }

            /* Forcer les couleurs */
            .badge-risk, .badge {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .icon-circle {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }
        <style>
    /* --- Styles écran --- */
    .kpi-card { 
        background: white; 
        border-radius: 12px; 
        box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        transition: 0.3s;
    }

    .graph-container img {
        width: 100%;
        border-radius: 8px;
    }

    /* --- Styles PDF / impression --- */
    @media print {
        body {
            background: white !important;
            margin: 0; padding: 0;
        }

        .kpi-card, .glass-panel, .graph-container {
            box-shadow: none !important; /* Supprimer les ombres pour le PDF */
            border: 1px solid #ddd !important;
            page-break-inside: avoid;    /* Évite que la carte ou graphique soit coupé */
        }

        /* Masquer tout ce qui n’a pas besoin d’être imprimé */
        .btn, .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            display: none !important;
        }

        /* Tableau synthétique PDF */
        .table-premium {
            font-size: 0.85rem;
            border-collapse: collapse !important;
        }
        .table-premium th, .table-premium td {
            border: 1px solid #ddd !important;
            padding: 10px !important;
        }

        footer {
            page-break-before: always;
            background-color: #0a1628 !important;
            color: #fff !important;
        }

        /* Forcer les couleurs des badges et icônes */
        .badge-risk, .icon-circle {
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }
    }
</style>
        
    </style>
</head>
<body>

<div class="main-wrapper">
    <!-- Header -->
    <div class="premium-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-bold m-0"><i class="fa-solid fa-chart-line me-3" style="color: var(--gold-accent);"></i>Rapport Décisionnel</h1>
                <p class="opacity-75 mb-0">Analyse de risque et performance du portefeuille clients</p>
            </div>
            <div class="d-flex gap-2">
                <button onclick="printReport()" class="btn btn-outline-light btn-sm px-4 rounded-pill">
                    <i class="fa-solid fa-file-pdf me-2"></i>Exporter PDF
                </button>
                <a href="dashboard" class="btn btn-outline-light btn-sm px-4 rounded-pill">
                    <i class="fa-solid fa-arrow-left me-2"></i>Dashboard
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- KPI Cards -->
        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card kpi-card p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Encours Global</small>
                            <h3 class="fw-bold mb-0 text-primary"><fmt:formatNumber value="<%= totalEncours %>" pattern="#,##0"/> €</h3>
                        </div>
                        <div class="icon-circle"><i class="fa-solid fa-euro-sign"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card kpi-card p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Prêts Actifs</small>
                            <h3 class="fw-bold mb-0"><%= prets.size() %></h3>
                        </div>
                        <div class="icon-circle"><i class="fa-solid fa-file-invoice"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card kpi-card p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Endettement Moyen</small>
                            <h3 class="fw-bold mb-0 text-warning"><fmt:formatNumber value="<%= moyenneEndettement %>" pattern="#0.0"/>%</h3>
                        </div>
                        <div class="icon-circle"><i class="fa-solid fa-percent"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card kpi-card p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Volume Financé</small>
                            <h3 class="fw-bold mb-0 text-success"><fmt:formatNumber value="<%= volumeTotalFinance %>" pattern="#,##0"/> €</h3>
                        </div>
                        <div class="icon-circle"><i class="fa-solid fa-vault"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="glass-panel h-100">
                    <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-city me-2 text-primary"></i>Concentration par Ville</h5>
                    <div style="height: 350px;">
                        <canvas id="villeChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="glass-panel h-100">
                    <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-layer-group me-2 text-primary"></i>Mix Produits</h5>
                    <div style="height: 350px;">
                        <canvas id="typeChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Risk Analysis Table -->
            <div class="col-12 mt-4">
                <div class="glass-panel">
                    <h5 class="fw-bold mb-4 d-flex align-items-center">
                        <i class="fa-solid fa-shield-halved me-2 text-danger"></i> 
                        Analyse de Risque (Top Endettement)
                    </h5>
<div class="col-12 mt-4">
    <div class="glass-panel">
        <h5 class="fw-bold mb-4 d-flex align-items-center">
            <i class="fa-solid fa-shield-halved me-2 text-danger"></i>
            Analyse de Risque - Synthèse Globale
        </h5>

        <table class="table table-bordered text-center align-middle">
            <thead class="table-light">
                <tr>
                    <th>Total Clients</th>
                    <th>Total Prêts</th>
                    <th>Montant Total (€)</th>
                    <th>Endettement Moyen (%)</th>
                    <th>Prêts à Risque Élevé</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="fw-bold"><%= prets.stream().map(Pret::getClientId).distinct().count() %></td>
                    <td class="fw-bold"><%= prets.size() %></td>
                    <td class="fw-bold text-success"><fmt:formatNumber value="<%= volumeTotalFinance %>" pattern="#,##0"/></td>
                    <td class="fw-bold text-warning"><fmt:formatNumber value="<%= moyenneEndettement %>" pattern="#0.0"/></td>
                    <td class="fw-bold text-danger"><%= prets.stream().filter(p -> "ELEVE".equalsIgnoreCase(p.getNiveauRisque())).count() %></td>
                </tr>
            </tbody>
        </table>

        <div class="alert alert-info mt-3">
            <i class="fa-solid fa-circle-info me-2"></i>
            Tableau synthétique généré automatiquement à partir de l'analyse des prêts.
        </div>
    </div>
</div>

                </div>
            </div>
        </div>

        <!-- ===== RAPPORT IA GLOBAL ===== -->
        <% if (flaskReport != null) { %>
        <div class="row mt-5">
            <div class="col-lg-8">
                <div class="glass-panel border-start border-4 border-primary">
                    <h5 class="fw-bold mb-4">
                        <i class="fa-solid fa-brain me-2 text-primary"></i>
                        Rapport IA Global
                    </h5>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center p-3 bg-light rounded">
                                <i class="fa-solid fa-calculator fa-2x text-primary me-3"></i>
                                <div>
                                    <small class="text-muted d-block">Total Prêts Analysés</small>
                                    <h4 class="mb-0 fw-bold"><%= flaskReport.getInt("total_prets") %></h4>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center p-3 bg-light rounded">
                                <i class="fa-solid fa-chart-pie fa-2x text-warning me-3"></i>
                                <div>
                                    <small class="text-muted d-block">Catégories de Risque</small>
                                    <h4 class="mb-0 fw-bold"><%= flaskReport.getJSONArray("repartition_risque").length() %></h4>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h6 class="fw-bold mb-3">
                        <i class="fa-solid fa-layer-group me-2 text-secondary"></i>
                        Répartition du Risque
                    </h6>
                    <div class="list-group list-group-flush">
                        <%
                            org.json.JSONArray risques = flaskReport.getJSONArray("repartition_risque");
                            for (int i = 0; i < risques.length(); i++) {
                                org.json.JSONObject r = risques.getJSONObject(i);
                                String niveau = r.getString("niveau_risque");
                                int total = r.getInt("total");
                                
                                String badgeClass = niveau.equals("Faible") ? "success" : 
                                                  niveau.equals("Moyen") ? "warning" : "danger";
                                String iconClass = niveau.equals("Faible") ? "fa-shield-halved" : 
                                                 niveau.equals("Moyen") ? "fa-exclamation-triangle" : "fa-skull-crossbones";
                        %>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 py-3">
                                <div class="d-flex align-items-center">
                                    <i class="fa-solid <%= iconClass %> text-<%= badgeClass %> me-3"></i>
                                    <span class="fw-semibold"><%= niveau %></span>
                                </div>
                                <span class="badge bg-<%= badgeClass %> rounded-pill px-3 py-2">
                                    <%= total %> prêts
                                </span>
                            </div>
                        <% } %>
                    </div>

                    <div class="alert alert-info border-0 mt-4 shadow-sm">
                        <i class="fa-solid fa-circle-info me-2"></i>
                        <strong>Source :</strong> Analyse générée automatiquement par le moteur IA (Flask/Python)
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="glass-panel h-100">
                    <h6 class="fw-bold mb-3 text-center">Distribution Visuelle</h6>
                    <div style="height: 300px; position: relative;">
                        <canvas id="riskIaChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <!-- ===== GRAPHIQUES ANALYTIQUES OPTIMISÉS ===== -->
        <div class="row mt-5">
            <div class="col-12">
                <h5 class="fw-bold mb-4">
                    <i class="fa-solid fa-chart-area me-2 text-primary"></i>
                    Analyses Visuelles Avancées
                </h5>
            </div>
        </div>

        <div class="row g-4">
            <!-- Graphique 1 -->
            <div class="col-lg-6">
                <div class="graph-container">
                    <div class="graph-title">
                        <i class="fa-solid fa-pie-chart"></i>
                        Répartition des Risques
                    </div>
                    <img src="static/graphs/repartition_risques.png" alt="Répartition Risques"/>
                </div>
            </div>

            <!-- Graphique 2 -->
            <div class="col-lg-6">
                <div class="graph-container">
                    <div class="graph-title">
                        <i class="fa-solid fa-chart-bar"></i>
                        Distribution de l'Endettement
                    </div>
                    <img src="static/graphs/distribution_endettement.png" alt="Distribution Endettement"/>
                </div>
            </div>

            <!-- Graphique 3 -->
            <div class="col-lg-6">
                <div class="graph-container">
                    <div class="graph-title">
                        <i class="fa-solid fa-chart-line"></i>
                        Évolution des Risques
                    </div>
                    <img src="static/graphs/evolution_risques.png" alt="Evolution Risques"/>
                </div>
            </div>

            <!-- Graphique 4 -->
            <div class="col-lg-6">
                <div class="graph-container">
                    <div class="graph-title">
                        <i class="fa-solid fa-table-cells"></i>
                        Matrice de Corrélation
                    </div>
                    <img src="static/graphs/correlation_matrix.png" alt="Matrice Corrélation"/>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    <div class="container text-center">
        <p class="mb-1"><strong>BANQUE DIGITALE PRESTIGE</strong></p>
        <p class="small opacity-50">Système de Monitoring Temps Réel v2.4 - © 2026</p>
    </div>
</footer>

<!-- Scripts -->
<script>
    // Fonction d'impression / export PDF
    function printReport() {
    // Affiche toutes les lignes
    const table = document.querySelector('#riskTable');
    if (table) {
        table.querySelectorAll('tbody tr').forEach(tr => tr.style.display = 'table-row');
    }

    // Change le titre du document
    const originalTitle = document.title;
    document.title = 'Rapport_Risk_Analytics_' + new Date().toISOString().split('T')[0];

    // Imprime
    window.print();

    // Restaure le titre
    document.title = originalTitle;
}


    // Initialisation DataTables
    $(document).ready(function() {
        $('#riskTable').DataTable({
            "pageLength": 10,
            "lengthMenu": [[10, 15, 25, -1], [10, 15, 25, "Tous"]],
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/fr-FR.json"
            },
            "order": [],
            "dom": '<"d-flex justify-content-between align-items-center mb-4"lf>rt<"d-flex justify-content-between align-items-center mt-4"ip>'
        });
    });

    <%
        Map<String, Integer> types = new HashMap<>();
        Map<String, Integer> villes = new HashMap<>();
        for(Pret p : prets) {
            String typeNormalise = p.getTypePret();
            if (typeNormalise != null && !typeNormalise.isEmpty()) {
                typeNormalise = typeNormalise.substring(0, 1).toUpperCase() + typeNormalise.substring(1).toLowerCase();
            }
            types.put(typeNormalise, types.getOrDefault(typeNormalise, 0) + 1);
            
            String villeNormalisee = p.getClientVille();
            if (villeNormalisee != null && !villeNormalisee.isEmpty()) {
                villeNormalisee = villeNormalisee.substring(0, 1).toUpperCase() + villeNormalisee.substring(1).toLowerCase();
            } else {
                villeNormalisee = "Non définie";
            }
            villes.put(villeNormalisee, villes.getOrDefault(villeNormalisee, 0) + 1);
        }
    %>
    const commonOptions = { 
        responsive: true, 
        maintainAspectRatio: false,
        plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } } }
    };

    new Chart(document.getElementById('typeChart'), {
        type: 'doughnut',
        data: {
            labels: [<% for(String s : types.keySet()) { %> '<%=s%>', <% } %>],
            datasets: [{ 
                data: [<% for(Integer i : types.values()) { %> <%=i%>, <% } %>], 
                backgroundColor: ['#1e3a8a', '#D4AF37', '#3b82f6', '#10b981'],
                hoverOffset: 15,
                borderWidth: 0
            }]
        },
        options: commonOptions
    });

    new Chart(document.getElementById('villeChart'), {
        type: 'bar',
        data: {
            labels: [<% for(String s : villes.keySet()) { %> '<%=s%>', <% } %>],
            datasets: [{ 
                label: 'Volume de prêts', 
                data: [<% for(Integer i : villes.values()) { %> <%=i%>, <% } %>], 
                backgroundColor: 'rgba(30, 58, 138, 0.8)',
                borderRadius: 5,
                barThickness: 40
            }]
        },
        options: {
            ...commonOptions,
            scales: { y: { beginAtZero: true, grid: { display: false } }, x: { grid: { display: false } } }
        }
    });

    <% if (flaskReport != null) { 
        org.json.JSONArray riskData = flaskReport.getJSONArray("repartition_risque");
    %>
    new Chart(document.getElementById('riskIaChart'), {
        type: 'doughnut',
        data: {
            labels: [
                <% for(int i = 0; i < riskData.length(); i++) { %>
                    "<%= riskData.getJSONObject(i).getString("niveau_risque") %>",
                <% } %>
            ],
            datasets: [{
                data: [
                    <% for(int i = 0; i < riskData.length(); i++) { %>
                        <%= riskData.getJSONObject(i).getInt("total") %>,
                    <% } %>
                ],
                backgroundColor: ['#16a34a', '#facc15', '#dc2626'],
                borderWidth: 0,
                hoverOffset: 15
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { 
                        usePointStyle: true, 
                        padding: 15,
                        font: { weight: '600' }
                    }
                }
            }
        }
    });
    <% } %>
</script>
</body>
</html>