<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String dateActuelle = sdf.format(new Date());
    request.setAttribute("dateActuelle", dateActuelle);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Client | Banque Digitale</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --boa-blue: #003a8f;
            --boa-gold: #c9a23f;
            --boa-dark: #0b1f3a;
            --boa-light: #f4f6f9;
        }

        body {
            background-color: var(--boa-light);
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--boa-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: linear-gradient(90deg, var(--boa-blue), var(--boa-dark));
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 700;
            letter-spacing: 1px;
            color: white !important;
        }

        .welcome-section {
            background: white;
            padding: 30px;
            border-radius: 18px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border-left: 5px solid var(--boa-gold);
        }

        .dashboard-card {
            background: white;
            border-radius: 18px;
            border: none;
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .dashboard-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .icon-box {
            width: 70px;
            height: 70px;
            border-radius: 18px;
            background: rgba(0, 58, 143, 0.1);
            color: var(--boa-blue);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 20px;
        }

        .btn-gold {
            background-color: var(--boa-gold);
            color: #000;
            border-radius: 30px;
            font-weight: 600;
            padding: 10px 25px;
            border: none;
            transition: 0.3s;
        }

        .btn-gold:hover { background-color: #b18e32; color: #000; }

        .activity-card {
            background: white;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .badge-ai-waiting {
            background-color: #e9ecef;
            color: #495057;
            border: 1px dashed #adb5bd;
        }

        .profile-header {
            background: var(--boa-blue);
            color: white;
            padding: 30px;
            text-align: center;
            border-radius: 0 0 20px 20px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--boa-blue);
        }

        @media print {
            .no-print { display: none !important; }
            body { background: white; }
            .activity-card { box-shadow: none; border: 1px solid #ddd; }
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow no-print">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fa-solid fa-building-columns me-2"></i> BANQUE DIGITALE
        </a>
        <div class="navbar-nav ms-auto align-items-center">
            <button class="btn btn-link text-white text-decoration-none me-3" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasProfile">
                <i class="fa-solid fa-circle-user me-1"></i> 
                <strong>Mon Profil</strong>
            </button>
            <a class="btn btn-outline-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/logout.jsp">
                <i class="fa-solid fa-power-off me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="offcanvas offcanvas-end no-print" tabindex="-1" id="offcanvasProfile">
    <div class="offcanvas-header bg-light">
        <h5 class="offcanvas-title fw-bold text-primary">Informations Personnelles</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="profile-header">
            <div class="mb-3"><i class="fa-solid fa-user-tie fa-4x"></i></div>
            <h4 class="mb-0">${sessionScope.user.username}</h4>
            <span class="badge bg-warning text-dark mt-2">Client Privilège</span>
        </div>
        <div class="p-4">
            <div class="mb-4 text-center">
                <p class="text-muted small fw-bold mb-0 text-uppercase">ID Client</p>
                <p class="fw-bold text-primary mb-3">ID-${sessionScope.user.id}992834</p>
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=ID-${sessionScope.user.id}" alt="QR Code Client">
            </div>
            
            <hr>
            
            <div class="mb-3">
                <small class="text-muted">Nombre de prêts</small>
                <p class="mb-0 fw-bold">${nombrePrets}</p>
            </div>
            
            <div class="mb-3">
                <small class="text-muted">Montant total emprunté</small>
                <p class="mb-0 fw-bold"><fmt:formatNumber value="${totalMontant}" pattern="#,##0.00"/> €</p>
            </div>
        </div>
    </div>
</div>

<div class="container mt-5 flex-grow-1">
    
    <c:if test="${param.success == 'demandeEnvoyee'}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4 no-print" role="alert" style="border-left: 5px solid #28a745 !important; border-radius: 15px;">
            <div class="d-flex align-items-center">
                <i class="fa-solid fa-circle-check fs-3 me-3 text-success"></i>
                <div>
                    <h6 class="mb-0 fw-bold">Demande enregistrée !</h6>
                    <small>Votre dossier est maintenant visible dans le tableau de suivi ci-dessous.</small>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="welcome-section">
        <h2 class="fw-bold mb-1">Espace Personnel</h2>
        <p class="text-muted mb-0">Ravi de vous revoir, <strong>${sessionScope.user.username}</strong> ! Gérez vos documents et vos analyses de solvabilité.</p>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto"><i class="fa-solid fa-file-pdf"></i></div>
                <h5 class="fw-bold">Relevés Bancaires</h5>
                <a href="${pageContext.request.contextPath}/client/telechargements.jsp" class="btn btn-gold mt-2 w-100">Mes Documents</a>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card dashboard-card p-4 text-center border-bottom border-primary border-4">
                <div class="icon-box mx-auto"><i class="fa-solid fa-brain"></i></div>
                <h5 class="fw-bold">Demander un Prêt</h5>
                <a href="${pageContext.request.contextPath}/client/services.jsp" class="btn btn-gold mt-2 w-100">Faire une demande</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card dashboard-card p-4 text-center">
                <div class="icon-box mx-auto"><i class="fa-solid fa-gears"></i></div>
                <h5 class="fw-bold">Autres Services</h5>
                <a href="${pageContext.request.contextPath}/client/autresServices.jsp" class="btn btn-gold mt-2 w-100">Explorer</a>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card dashboard-card p-4">
                <small class="text-muted mb-2">Total Emprunté</small>
                <div class="stat-value"><fmt:formatNumber value="${totalMontant}" pattern="#,##0"/> €</div>
                <small class="text-success"><i class="fa-solid fa-chart-line"></i> Actif</small>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card dashboard-card p-4">
                <small class="text-muted mb-2">Mes Prêts</small>
                <div class="stat-value">${nombrePrets}</div>
                <small class="text-info">${pretsEnCours} en cours</small>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card dashboard-card p-4">
                <small class="text-muted mb-2">Score de Crédit</small>
                <div class="stat-value text-success">A+</div>
                <small class="text-muted">Excellent</small>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="card dashboard-card p-4 text-center">
                <button onclick="imprimerPrets()" class="btn btn-outline-primary btn-sm w-100 mb-2">
                    <i class="fa-solid fa-print me-1"></i> Imprimer
                </button>
                <button onclick="window.print()" class="btn btn-outline-secondary btn-sm w-100">
                    <i class="fa-solid fa-file-pdf me-1"></i> Exporter PDF
                </button>
            </div>
        </div>
    </div>

    <div class="activity-card mb-5" id="tableauPrets">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0">
                <i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>
                Suivi de mes demandes de prêt
            </h5>
        </div>

        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Référence</th>
                        <th>Date</th>
                        <th>Type de Prêt</th>
                        <th>Montant Total</th>
                        <th>Mensualité</th>
                        <th>Durée</th>
                        <th>Analyse Risque (IA)</th>
                        <th class="no-print">Statut</th>
                        <th class="no-print">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${mesPrets}">
                        <tr>
                            <td><small class="text-muted">#${p.id}</small></td>
                            <td><small class="text-muted">${p.dateDemande}</small></td>
                            <td class="fw-bold text-uppercase">${p.typePret}</td>
                            <td><strong><fmt:formatNumber value="${p.mensualite * p.dureeMois}" pattern="#,##0.00"/> €</strong></td>
                            <td><fmt:formatNumber value="${p.mensualite}" pattern="#,##0.00"/> €</td>
                            <td>${p.dureeMois} mois</td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty p.niveauRisque || p.niveauRisque == ''}">
                                        <span class="badge badge-ai-waiting">
                                            <i class="fa-solid fa-robot fa-spin me-1"></i> Calcul en cours...
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="badgeColor" value="${p.niveauRisque == 'FAIBLE' ? 'success' : (p.niveauRisque == 'MOYEN' ? 'warning' : 'danger')}" />
                                        <span class="badge bg-${badgeColor}-subtle text-${badgeColor} border border-${badgeColor}">
                                            <i class="fa-solid fa-microchip me-1"></i> ${p.niveauRisque}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="no-print">
                                <c:choose>
                                    <c:when test="${p.statut == 'EN_ATTENTE'}">
                                        <span class="badge rounded-pill bg-info text-dark">En cours</span>
                                    </c:when>
                                    <c:when test="${p.statut == 'APPROUVE'}">
                                        <span class="badge rounded-pill bg-success">Approuvé</span>
                                    </c:when>
                                    <c:when test="${p.statut == 'REJETE'}">
                                        <span class="badge rounded-pill bg-danger">Rejeté</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-secondary">${p.statut}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="no-print">
                                <button onclick="afficherDetail(${p.id}, '${p.typePret}', '${p.dateDemande}', ${p.mensualite}, ${p.dureeMois}, '${p.niveauRisque}', '${p.statut}')" class="btn btn-sm btn-outline-primary">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty mesPrets}">
                        <tr>
                            <td colspan="9" class="text-center py-5 text-muted">
                                <i class="fa-solid fa-inbox fa-3x mb-3 d-block opacity-50"></i>
                                <h5>Aucune demande de prêt enregistrée</h5>
                                <p class="mb-3">Commencez dès maintenant votre demande de financement</p>
                                <a href="${pageContext.request.contextPath}/client/services.jsp" class="btn btn-gold">
                                    <i class="fa-solid fa-plus me-2"></i>Faire une demande
                                </a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${not empty mesPrets}">
            <div class="mt-4 p-3 bg-light rounded">
                <div class="row text-center">
                    <div class="col-md-4">
                        <strong>Total des prêts:</strong> ${nombrePrets}
                    </div>
                    <div class="col-md-4">
                        <strong>Montant total:</strong> <fmt:formatNumber value="${totalMontant}" pattern="#,##0.00"/> €
                    </div>
                    <div class="col-md-4">
                        <strong>En attente:</strong> ${pretsEnCours}
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<footer class="text-center py-4 text-muted border-top bg-white">
    <small>&copy; 2026 Banque Digitale - Excellence et Innovation.</small>
</footer>

<!-- Modal Détail Prêt -->
<div class="modal fade" id="modalDetail" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa-solid fa-file-invoice me-2"></i>Détail du Prêt</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="detailContent">
                <!-- Le contenu sera inséré dynamiquement -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                <button type="button" class="btn btn-primary" onclick="imprimerDetail()">
                    <i class="fa-solid fa-print me-1"></i> Imprimer
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function imprimerPrets() {
    window.print();
}

function afficherDetail(id, type, date, mensualite, duree, risque, statut) {
    const montantTotal = mensualite * duree;
    const statutBadge = statut === 'EN_ATTENTE' ? 'bg-info text-dark' : statut === 'APPROUVE' ? 'bg-success' : 'bg-danger';
    const risqueBadge = risque === 'FAIBLE' ? 'bg-success' : risque === 'MOYEN' ? 'bg-warning' : 'bg-danger';
    
    document.getElementById('detailContent').innerHTML = `
        <div class="row">
            <div class="col-12 mb-3 text-center">
                <h4 class="text-primary">Prêt #${id}</h4>
                <span class="badge ${statutBadge} px-3 py-2">${statut}</span>
            </div>
            <div class="col-12"><hr></div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-user me-2 text-primary"></i>Client:</strong>
                <p class="mb-0">${sessionScope.user.username}</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-id-card me-2 text-primary"></i>ID Client:</strong>
                <p class="mb-0">ID-${sessionScope.user.id}992834</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-calendar me-2 text-primary"></i>Date de demande:</strong>
                <p class="mb-0">${date}</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-tag me-2 text-primary"></i>Type de prêt:</strong>
                <p class="mb-0 text-uppercase">${type}</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-euro-sign me-2 text-primary"></i>Montant total:</strong>
                <p class="mb-0 fs-5 text-primary fw-bold">${montantTotal.toFixed(2)} €</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-coins me-2 text-primary"></i>Mensualité:</strong>
                <p class="mb-0">${mensualite.toFixed(2)} €</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-clock me-2 text-primary"></i>Durée:</strong>
                <p class="mb-0">${duree} mois</p>
            </div>
            <div class="col-md-6 mb-3">
                <strong><i class="fa-solid fa-brain me-2 text-primary"></i>Niveau de risque:</strong>
                <p class="mb-0"><span class="badge ${risqueBadge}">${risque || 'En cours d\'analyse'}</span></p>
            </div>
            <div class="col-12 mt-3">
                <div class="alert alert-info">
                    <i class="fa-solid fa-info-circle me-2"></i>
                    Pour plus de détails ou toute question, contactez votre conseiller bancaire au <strong>05 22 XX XX XX</strong>
                </div>
            </div>
        </div>
    `;
    
    const modal = new bootstrap.Modal(document.getElementById('modalDetail'));
    modal.show();
}

function imprimerDetail() {
    const content = document.getElementById('detailContent').innerHTML;
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <html>
        <head>
            <title>Détail du Prêt - Banque Digitale</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
            <style>
                body { padding: 30px; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; }
                .header { text-align: center; margin-bottom: 30px; border-bottom: 3px solid #003a8f; padding-bottom: 20px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h2 class="text-primary"><i class="fa-solid fa-building-columns me-2"></i>BANQUE DIGITALE</h2>
                <p class="text-muted mb-0">Détail de votre demande de prêt</p>
            </div>
            ${content}
            <div class="mt-5 text-center">
                <small class="text-muted">&copy; 2026 Banque Digitale - Document généré le ${dateActuelle}</small>
            </div>
        </body>
        </html>
    `);
    printWindow.document.close();
    setTimeout(() => {
        printWindow.print();
    }, 250);
}
</script>
</body>
</html>