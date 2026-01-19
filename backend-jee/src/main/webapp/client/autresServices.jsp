<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nos Services | Banque Digitale</title>

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

        .page-header {
            background: linear-gradient(135deg, var(--boa-blue), var(--boa-dark));
            color: white;
            padding: 60px 0;
            margin-bottom: 50px;
            border-radius: 0 0 30px 30px;
        }

        .service-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            height: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: 2px solid transparent;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            border-color: var(--boa-gold);
        }

        .service-icon {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--boa-blue), #0055cc);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 20px;
        }

        .service-icon.gold {
            background: linear-gradient(135deg, var(--boa-gold), #d4a847);
        }

        .service-icon.green {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .service-icon.purple {
            background: linear-gradient(135deg, #6f42c1, #8b5cf6);
        }

        .service-icon.orange {
            background: linear-gradient(135deg, #fd7e14, #ff922b);
        }

        .service-icon.red {
            background: linear-gradient(135deg, #dc3545, #e85d6c);
        }

        .btn-gold {
            background-color: var(--boa-gold);
            color: #000;
            border-radius: 30px;
            font-weight: 600;
            padding: 12px 30px;
            border: none;
            transition: 0.3s;
        }

        .btn-gold:hover {
            background-color: #b18e32;
            color: #000;
            transform: scale(1.05);
        }

        .btn-outline-gold {
            border: 2px solid var(--boa-gold);
            color: var(--boa-gold);
            border-radius: 30px;
            font-weight: 600;
            padding: 10px 25px;
            background: transparent;
            transition: 0.3s;
        }

        .btn-outline-gold:hover {
            background-color: var(--boa-gold);
            color: #000;
        }

        .category-badge {
            background: var(--boa-light);
            color: var(--boa-blue);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .advantage-item {
            background: var(--boa-light);
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 10px;
            border-left: 4px solid var(--boa-gold);
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/userDash">
            <i class="fa-solid fa-building-columns me-2"></i> BANQUE DIGITALE
        </a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="btn btn-link text-white text-decoration-none me-3" href="${pageContext.request.contextPath}/userDash">
                <i class="fa-solid fa-home me-1"></i> Tableau de bord
            </a>
            <a class="btn btn-outline-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-power-off me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="page-header text-center">
    <div class="container">
        <h1 class="display-4 fw-bold mb-3">Nos Services Bancaires</h1>
        <p class="lead mb-0">Des solutions adaptées à tous vos besoins financiers</p>
    </div>
</div>

<div class="container mb-5">
    
    <!-- Section Épargne & Placements -->
    <div class="mb-5">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-piggy-bank me-2 text-primary"></i>Épargne & Placements</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon">
                        <i class="fa-solid fa-building-columns"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Compte Épargne</span>
                    <h4 class="fw-bold mb-3">Livret A+</h4>
                    <p class="text-muted mb-3">Épargnez en toute sécurité avec un taux attractif de 3% par an. Disponibilité immédiate de vos fonds.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Taux d'intérêt: <strong>3.00%</strong>
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Plafond: <strong>100 000 €</strong>
                    </div>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('Livret A+')">
                        Ouvrir un compte
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon gold">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Placement</span>
                    <h4 class="fw-bold mb-3">Plan Épargne Actions</h4>
                    <p class="text-muted mb-3">Investissez dans des actions françaises et européennes avec des avantages fiscaux.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Exonération fiscale après 5 ans
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Versements libres
                    </div>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('PEA')">
                        Découvrir l'offre
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon green">
                        <i class="fa-solid fa-seedling"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Épargne Verte</span>
                    <h4 class="fw-bold mb-3">Livret Développement Durable</h4>
                    <p class="text-muted mb-3">Soutenez des projets écologiques tout en épargnant avec un taux de 2.5%.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Taux: <strong>2.50%</strong>
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Impact environnemental positif
                    </div>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('LDD')">
                        Souscrire
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Assurances -->
    <div class="mb-5">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-shield-halved me-2 text-primary"></i>Assurances & Protection</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon purple">
                        <i class="fa-solid fa-heart-pulse"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Santé</span>
                    <h4 class="fw-bold mb-3">Assurance Santé Premium</h4>
                    <p class="text-muted mb-3">Couverture complète pour vous et votre famille avec remboursement jusqu'à 200%.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Hospitalisation: 100%
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Optique & Dentaire inclus
                    </div>
                    <button class="btn btn-outline-gold w-100 mt-3" onclick="demanderService('Assurance Santé')">
                        Obtenir un devis
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon orange">
                        <i class="fa-solid fa-house-chimney"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Habitation</span>
                    <h4 class="fw-bold mb-3">Assurance Habitation</h4>
                    <p class="text-muted mb-3">Protégez votre logement et vos biens contre tous les risques. Assistance 24h/24.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Dégâts des eaux & incendie
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Vol et vandalisme
                    </div>
                    <button class="btn btn-outline-gold w-100 mt-3" onclick="demanderService('Assurance Habitation')">
                        Obtenir un devis
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon red">
                        <i class="fa-solid fa-car"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Auto</span>
                    <h4 class="fw-bold mb-3">Assurance Auto</h4>
                    <p class="text-muted mb-3">Formules tous risques ou au tiers. Bonus pour conduite responsable.</p>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Assistance 0 km
                    </div>
                    <div class="advantage-item">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>Véhicule de remplacement
                    </div>
                    <button class="btn btn-outline-gold w-100 mt-3" onclick="demanderService('Assurance Auto')">
                        Obtenir un devis
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Services Premium -->
    <div class="mb-5">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-crown me-2 text-primary"></i>Services Premium</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon gold">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Conseiller Dédié</span>
                    <h4 class="fw-bold mb-3">Gestion Patrimoniale</h4>
                    <p class="text-muted mb-3">Un conseiller personnel pour optimiser votre patrimoine et vos investissements.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Conseiller personnel</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Analyse patrimoniale</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Stratégie fiscale</li>
                    </ul>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('Gestion Patrimoniale')">
                        Prendre RDV
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">Carte Premium</span>
                    <h4 class="fw-bold mb-3">Carte Gold Infinite</h4>
                    <p class="text-muted mb-3">Carte bancaire haut de gamme avec assurances voyage et conciergerie.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Plafond: 15 000 €/mois</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Cashback 2%</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Accès salons aéroport</li>
                    </ul>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('Carte Gold')">
                        Commander
                    </button>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <div class="service-icon green">
                        <i class="fa-solid fa-globe"></i>
                    </div>
                    <span class="category-badge mb-3 d-inline-block">International</span>
                    <h4 class="fw-bold mb-3">Virements Internationaux</h4>
                    <p class="text-muted mb-3">Transférez de l'argent à l'étranger rapidement et en toute sécurité.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>180+ pays</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Taux compétitifs</li>
                        <li class="mb-2"><i class="fa-solid fa-star text-warning me-2"></i>Transfert en 24h</li>
                    </ul>
                    <button class="btn btn-gold w-100 mt-3" onclick="demanderService('Virement International')">
                        Effectuer un virement
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Cartes Bancaires -->
    <div class="mb-5">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-wallet me-2 text-primary"></i>Cartes Bancaires</h2>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="service-card text-center">
                    <div class="service-icon mx-auto" style="background: linear-gradient(135deg, #6c757d, #8b919b);">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Carte Classique</h5>
                    <p class="text-muted small mb-3">Paiements et retraits</p>
                    <p class="h4 text-primary mb-3">Gratuite</p>
                    <button class="btn btn-outline-gold btn-sm w-100" onclick="demanderService('Carte Classique')">
                        Commander
                    </button>
                </div>
            </div>

            <div class="col-md-3">
                <div class="service-card text-center">
                    <div class="service-icon mx-auto gold">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Carte Gold</h5>
                    <p class="text-muted small mb-3">Assurances incluses</p>
                    <p class="h4 text-primary mb-3">5€/mois</p>
                    <button class="btn btn-outline-gold btn-sm w-100" onclick="demanderService('Carte Gold')">
                        Commander
                    </button>
                </div>
            </div>

            <div class="col-md-3">
                <div class="service-card text-center">
                    <div class="service-icon mx-auto" style="background: linear-gradient(135deg, #212529, #495057);">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Carte Platinum</h5>
                    <p class="text-muted small mb-3">Services Premium</p>
                    <p class="h4 text-primary mb-3">15€/mois</p>
                    <button class="btn btn-outline-gold btn-sm w-100" onclick="demanderService('Carte Platinum')">
                        Commander
                    </button>
                </div>
            </div>

            <div class="col-md-3">
                <div class="service-card text-center">
                    <div class="service-icon mx-auto green">
                        <i class="fa-solid fa-seedling"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Carte Écologique</h5>
                    <p class="text-muted small mb-3">Matériaux recyclés</p>
                    <p class="h4 text-primary mb-3">3€/mois</p>
                    <button class="btn btn-outline-gold btn-sm w-100" onclick="demanderService('Carte Écologique')">
                        Commander
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Besoin d'aide -->
    <div class="row mb-5">
        <div class="col-12">
            <div class="service-card text-center p-5" style="background: linear-gradient(135deg, var(--boa-blue), var(--boa-dark)); color: white;">
                <i class="fa-solid fa-headset fa-4x mb-4"></i>
                <h3 class="fw-bold mb-3">Besoin d'aide pour choisir ?</h3>
                <p class="lead mb-4">Nos conseillers sont à votre écoute pour vous guider vers les meilleures solutions</p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <button class="btn btn-gold btn-lg" onclick="contactConseil()">
                        <i class="fa-solid fa-phone me-2"></i>Appeler un conseiller
                    </button>
                    <button class="btn btn-outline-light btn-lg">
                        <i class="fa-solid fa-calendar me-2"></i>Prendre RDV
                    </button>
                </div>
            </div>
        </div>
    </div>

</div>

<footer class="text-center py-4 text-muted border-top bg-white">
    <small>&copy; 2026 Banque Digitale - Excellence et Innovation.</small>
</footer>

<!-- Modal Demande de Service -->
<div class="modal fade" id="modalDemande" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa-solid fa-file-contract me-2"></i>Demande de Service</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info">
                    <i class="fa-solid fa-info-circle me-2"></i>
                    Vous êtes sur le point de demander: <strong id="serviceNom"></strong>
                </div>
                <form>
                    <div class="mb-3">
                        <label class="form-label">Votre nom complet</label>
                        <input type="text" class="form-control" value="${sessionScope.user.username}" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Téléphone</label>
                        <input type="tel" class="form-control" placeholder="Votre numéro de téléphone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Message (optionnel)</label>
                        <textarea class="form-control" rows="3" placeholder="Des précisions sur votre demande..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-gold" onclick="confirmerDemande()">
                    <i class="fa-solid fa-paper-plane me-2"></i>Envoyer la demande
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
let modalDemande;

document.addEventListener('DOMContentLoaded', function() {
    modalDemande = new bootstrap.Modal(document.getElementById('modalDemande'));
});

function demanderService(nomService) {
    document.getElementById('serviceNom').textContent = nomService;
    modalDemande.show();
}

function confirmerDemande() {
    // Simuler l'envoi de la demande
    modalDemande.hide();
    
    // Afficher une notification de succès
    const toast = document.createElement('div');
    toast.className = 'position-fixed top-0 end-0 p-3';
    toast.style.zIndex = '9999';
    toast.innerHTML = `
        <div class="toast show" role="alert">
            <div class="toast-header bg-success text-white">
                <i class="fa-solid fa-check-circle me-2"></i>
                <strong class="me-auto">Demande envoyée</strong>
                <button type="button" class="btn-close btn-close-white" onclick="this.parentElement.parentElement.parentElement.remove()"></button>
            </div>
            <div class="toast-body">
                Votre demande a été transmise. Un conseiller vous contactera sous 24h.
            </div>
        </div>
    `;
    document.body.appendChild(toast);
    
    setTimeout(() => toast.remove(), 5000);
}

function contactConseil() {
    alert("Service disponible de 8h à 18h au:\n\n📞 05 22 XX XX XX\n📧 contact@banquedigitale.ma");
}
</script>

</body>
</html>