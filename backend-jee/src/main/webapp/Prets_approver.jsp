<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.banque.model.Pret" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approbations - Banque Digitale</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --admin-navy: #0f172a;
            --admin-accent: #3b82f6;
            --gold-soft: #fbbf24;
        }

        body {
            background: #f1f5f9;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        .navbar {
            background: var(--admin-navy) !important;
            border-bottom: 3px solid var(--gold-soft);
        }

        .header-section {
            background: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .card-approval {
            background: white;
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table thead {
            background: #f8fafc;
            color: #64748b;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }

        .risk-badge {
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .btn-action {
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            transition: all 0.2s;
            border: none;
        }

        .btn-approve { color: #10b981; border: 1px solid #10b981; background: transparent; }
        .btn-approve:hover { background: #10b981; color: white; }

        .btn-reject { color: #ef4444; border: 1px solid #ef4444; background: transparent; }
        .btn-reject:hover { background: #ef4444; color: white; }

        .empty-state {
            padding: 4rem;
            text-align: center;
            color: #94a3b8;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-shield-lock-fill text-warning me-2"></i> ADMINISTRATION
            </a>
            <div class="navbar-nav ms-auto">
                <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light btn-sm">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="header-section">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold mb-1">Files d'attente des Décisions</h2>
                    <p class="text-muted mb-0">Traitez les dossiers de crédit nécessitant une revue manuelle.</p>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light border">
                    <i class="bi bi-house me-2"></i>Dashboard
                </a>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        
        <%-- Affichage des messages de succès ou d'erreur --%>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success border-0 shadow-sm mb-4">
                <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.success}
                <c:remove var="success" scope="session" />
            </div>
        </c:if>

        <div class="card-approval">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">ID & Client</th>
                            <th>Détails Prêt</th>
                            <th>Montant Souhaité</th>
                            <th>Endettement</th>
                            <th>Risque</th>
                            <th class="text-end pe-4">Actions Décisives</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${demandesEnAttente}">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-bold text-dark">#${p.idPret}</div>
                                    <div class="small text-muted">${p.clientIdentifiant}</div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-primary border">${p.typePret}</span>
                                    <div class="small mt-1 text-muted">${p.dureeMois} mois</div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">
                                        <fmt:formatNumber value="${p.mensualite}" pattern="#,##0.00"/> DH
                                    </div>
                                </td>
                                <td>
                                    <%-- On suppose que tauxEndettement est déjà en % (ex: 25.5) --%>
                                    <c:set var="taux" value="${p.tauxEndettement}" />
<c:if test="${taux < 1}">
    <c:set var="taux" value="${taux * 100}" />
</c:if>
<fmt:formatNumber value="${taux}" pattern="0.00"/> %

                                    </div>
                                </td>
                                <td>
    <c:choose>
        <c:when test="${p.niveauRisque eq 'FAIBLE'}">
            <span class="risk-badge bg-success-subtle text-success border border-success">
                FAIBLE
            </span>
        </c:when>

        <c:when test="${p.niveauRisque eq 'MOYEN'}">
            <span class="risk-badge bg-warning-subtle text-warning border border-warning">
                MODÉRÉ
            </span>
        </c:when>

        <c:when test="${p.niveauRisque eq 'ELEVE'}">
            <span class="risk-badge bg-danger-subtle text-danger border border-danger">
                ÉLEVÉ
            </span>
        </c:when>

        <c:otherwise>
            <span class="risk-badge bg-secondary-subtle text-secondary border border-secondary">
                NON ÉVALUÉ
            </span>
        </c:otherwise>
    </c:choose>
</td>
                                
                                <td class="text-end pe-4">
                                    <form action="${pageContext.request.contextPath}/DecisionServlet" method="POST" class="d-inline">
                                        <%-- Input caché pour l'ID de la demande --%>
                                        <input type="hidden" name="idPret" value="${p.idPret}">
                                        
                                        <button type="submit" name="decision" value="APPROUVE" class="btn-action btn-approve" title="Approuver">
                                            <i class="fa-solid fa-check"></i>
                                        </button>
                                        
                                        <button type="submit" name="decision" value="REJETE" class="btn-action btn-reject ms-2" title="Rejeter">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty demandesEnAttente}">
                            <tr>
                                <td colspan="6" class="empty-state">
                                    <i class="bi bi-check2-circle fs-1 text-success opacity-50"></i>
                                    <h5 class="mt-3">Aucun dossier en attente</h5>
                                    <p class="mb-0">Toutes les demandes ont été traitées.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>