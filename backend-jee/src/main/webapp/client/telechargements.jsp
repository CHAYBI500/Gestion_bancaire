<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Relevés | Banque Digitale</title>
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
            font-family: "Segoe UI", sans-serif;
            color: var(--boa-dark);
        }

        .header-banner {
            background: linear-gradient(90deg, var(--boa-blue), var(--boa-dark));
            color: white;
            padding: 40px 0;
            border-bottom: 5px solid var(--boa-gold);
            margin-bottom: 30px;
        }

        .card-document {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: transform 0.2s;
        }

        .card-document:hover {
            transform: scale(1.01);
        }

        .file-icon {
            font-size: 2.5rem;
            color: #dc3545; /* Rouge PDF */
            margin-right: 20px;
        }

        .btn-download {
            background-color: white;
            border: 2px solid var(--boa-blue);
            color: var(--boa-blue);
            font-weight: 600;
            border-radius: 30px;
            transition: 0.3s;
        }

        .btn-download:hover {
            background-color: var(--boa-blue);
            color: white;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .info-badge {
            font-size: 0.75rem;
            background: #e9ecef;
            padding: 4px 10px;
            border-radius: 5px;
            color: #6c757d;
        }
    </style>
</head>
<body>

<div class="header-banner">
    <div class="container text-center">
        <h1 class="fw-bold"><i class="fa-solid fa-file-pdf me-3"></i>Mes Relevés & Documents</h1>
        <p class="lead opacity-75">Consultez et téléchargez vos archives bancaires des 12 derniers mois.</p>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col-lg-3">
            <div class="filter-section shadow-sm">
                <h6 class="fw-bold mb-3">Filtrer par période</h6>
                <select class="form-select mb-3">
                    <option>Année 2025</option>
                    <option>Année 2024</option>
                </select>
                <select class="form-select mb-4">
                    <option>Tous les comptes</option>
                    <option>Compte Courant (*4402)</option>
                    <option>Compte Épargne (*8819)</option>
                </select>
                <a href="dashboard.jsp" class="btn btn-outline-secondary w-100 rounded-pill">
                    <i class="fa-solid fa-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>

        <div class="col-lg-9">
            
            <h5 class="fw-bold mb-4">Relevés de compte (PDF)</h5>

            <div class="card card-document p-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="file-icon">
                            <i class="fa-solid fa-file-lines"></i>
                        </div>
                        <div>
                            <h6 class="mb-1 fw-bold">Relevé de compte - Décembre 2025</h6>
                            <span class="info-badge">Réf: BD-2025-12-0045</span>
                            <span class="info-badge">Taille: 1.4 Mo</span>
                        </div>
                    </div>
                    <button class="btn btn-download px-4">
                        <i class="fa-solid fa-cloud-arrow-down me-2"></i>Télécharger
                    </button>
                </div>
            </div>

            <div class="card card-document p-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="file-icon">
                            <i class="fa-solid fa-file-lines"></i>
                        </div>
                        <div>
                            <h6 class="mb-1 fw-bold">Relevé de compte - Novembre 2025</h6>
                            <span class="info-badge">Réf: BD-2025-11-0021</span>
                            <span class="info-badge">Taille: 1.2 Mo</span>
                        </div>
                    </div>
                    <button class="btn btn-download px-4">
                        <i class="fa-solid fa-cloud-arrow-down me-2"></i>Télécharger
                    </button>
                </div>
            </div>

            <div class="card card-document p-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="file-icon">
                            <i class="fa-solid fa-file-lines"></i>
                        </div>
                        <div>
                            <h6 class="mb-1 fw-bold">Relevé de compte - Octobre 2025</h6>
                            <span class="info-badge">Réf: BD-2025-10-0089</span>
                            <span class="info-badge">Taille: 1.3 Mo</span>
                        </div>
                    </div>
                    <button class="btn btn-download px-4">
                        <i class="fa-solid fa-cloud-arrow-down me-2"></i>Télécharger
                    </button>
                </div>
            </div>

            <hr class="my-5">
            
            <h5 class="fw-bold mb-4">Autres documents fiscaux</h5>
            
            <div class="card card-document p-3 border-start border-warning border-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="file-icon text-warning">
                            <i class="fa-solid fa-file-invoice"></i>
                        </div>
                        <div>
                            <h6 class="mb-1 fw-bold">Imprimé Fiscal Unique (IFU) - 2024</h6>
                            <p class="small text-muted mb-0">Déclaration de revenus et capitaux mobiliers.</p>
                        </div>
                    </div>
                    <button class="btn btn-download px-4">
                        <i class="fa-solid fa-file-pdf me-2"></i>Ouvrir
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>

<footer class="text-center py-5 text-muted">
    <div class="container">
        <p class="small mb-0">Banque Digitale - Établissement de crédit agréé.</p>
        <p class="small">Les relevés sont conservés 10 ans dans votre coffre-fort numérique.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>