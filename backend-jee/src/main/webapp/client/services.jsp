<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simulateur de Prêt | Banque Digitale</title>
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
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: "Inter", "Segoe UI", sans-serif;
            min-height: 100vh;
        }

        .navbar { background: linear-gradient(90deg, var(--boa-blue), var(--boa-dark)); }

        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3rem;
            position: relative;
        }

        .step-indicator::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 3px;
            background: #e0e0e0;
            z-index: 0;
        }

        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 3px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }

        .step.active {
            background: var(--boa-blue);
            color: white;
            border-color: var(--boa-blue);
            transform: scale(1.2);
        }

        .step.completed {
            background: var(--boa-gold);
            border-color: var(--boa-gold);
            color: white;
        }

        .form-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            padding: 3rem;
        }

        .option-card {
            background: white;
            border-radius: 16px;
            border: 2px solid #e0e0e0;
            padding: 2rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .option-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .option-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
            border-color: var(--boa-blue);
        }

        .option-card:hover::before {
            transform: scaleX(1);
        }

        .option-card.selected {
            border-color: var(--boa-blue);
            background: linear-gradient(135deg, #f8f9ff 0%, #e8f0ff 100%);
            box-shadow: 0 8px 30px rgba(0, 58, 143, 0.2);
        }

        .option-card.selected::before {
            transform: scaleX(1);
        }

        .option-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--boa-gold);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .option-badge.recommended {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .monthly-payment {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--boa-blue);
            line-height: 1;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .btn-submit {
            background: var(--boa-blue);
            color: white;
            border: none;
            padding: 15px 50px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(0, 58, 143, 0.3);
        }

        .btn-submit:hover {
            background: var(--boa-dark);
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(0, 58, 143, 0.4);
            color: white;
        }

        .rate-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: #f0f9ff;
            border-radius: 20px;
            color: var(--boa-blue);
            font-weight: 600;
        }

        .step-content {
            display: none;
        }

        .step-content.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .feature-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow mb-5">
    <div class="container">
        <a class="navbar-brand" href="dashboard.jsp">
            <i class="fa-solid fa-arrow-left me-2"></i> Retour au Dashboard
        </a>
    </div>
</nav>

<div class="container py-5">
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold mb-3">Simulateur de Prêt Intelligent</h1>
        <p class="text-muted">Découvrez les meilleures options adaptées à votre profil</p>
    </div>

    <div class="row justify-content-center mb-5">
        <div class="col-md-6">
            <div class="step-indicator">
                <div class="step active" id="step1">1</div>
                <div class="step" id="step2">2</div>
                <div class="step" id="step3">3</div>
            </div>
        </div>
    </div>

    <!-- ÉTAPE 1: Formulaire de saisie -->
    <div class="step-content active" id="content-step1">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-card">
                    <h3 class="fw-bold mb-4">Parlez-nous de votre projet</h3>
                    <form id="loanForm">
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Type de Prêt</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="typePret" id="immobilier" value="IMMOBILIER" checked>
                                    <label class="btn btn-outline-primary w-100 py-3" for="immobilier">
                                        <i class="fa-solid fa-house-chimney fa-2x d-block mb-2"></i>
                                        <strong>Immobilier</strong>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="typePret" id="automobile" value="AUTOMOBILE">
                                    <label class="btn btn-outline-primary w-100 py-3" for="automobile">
                                        <i class="fa-solid fa-car fa-2x d-block mb-2"></i>
                                        <strong>Automobile</strong>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Montant souhaité (MAD)</label>
                            <input type="number" class="form-control form-control-lg" id="montant" 
                                   placeholder="Ex: 500 000" min="10000" step="1000" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Durée souhaitée</label>
                            <input type="range" class="form-range" id="duree" min="12" max="300" step="12" value="120">
                            <div class="d-flex justify-content-between mt-2">
                                <span class="text-muted">1 an</span>
                                <span class="fw-bold text-primary fs-5"><span id="dureeValue">10</span> ans</span>
                                <span class="text-muted">25 ans</span>
                            </div>
                        </div>

                        <div class="text-center mt-5">
                            <button type="button" class="btn btn-submit" onclick="calculateOptions()">
                                Voir mes options <i class="fa-solid fa-arrow-right ms-2"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ÉTAPE 2: Affichage des options -->
    <div class="step-content" id="content-step2">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Voici vos options personnalisées</h3>
            <p class="text-muted">Sélectionnez l'offre qui correspond le mieux à vos besoins</p>
        </div>

        <div class="row g-4" id="optionsContainer"></div>

        <div class="text-center mt-5">
            <button class="btn btn-light btn-lg me-3" onclick="goToStep(1)">
                <i class="fa-solid fa-arrow-left me-2"></i> Modifier ma demande
            </button>
            <button class="btn btn-submit" onclick="goToStep(3)" id="btnContinue" disabled>
                Continuer <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </div>
    </div>

    <!-- ÉTAPE 3: Confirmation -->
    <div class="step-content" id="content-step3">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-card text-center">
                    <div class="feature-icon mx-auto">
                        <i class="fa-solid fa-check"></i>
                    </div>
                    <h3 class="fw-bold mb-3">Récapitulatif de votre demande</h3>
                    <div id="summaryContainer" class="text-start my-4"></div>
                    
                    <form action="${pageContext.request.contextPath}/DemandePretServlet" method="POST" id="finalForm">
                        <input type="hidden" name="typePret" id="finalTypePret">
                        <input type="hidden" name="montant" id="finalMontant">
                        <input type="hidden" name="duree" id="finalDuree">
                        <input type="hidden" name="tauxAnnuel" id="finalTaux">
                        <input type="hidden" name="mensualite" id="finalMensualite">
                        
                        <div class="d-flex gap-3 justify-content-center mt-5">
                            <button type="button" class="btn btn-light btn-lg" onclick="goToStep(2)">
                                <i class="fa-solid fa-arrow-left me-2"></i> Retour
                            </button>
                            <button type="submit" class="btn btn-submit">
                                <i class="fa-solid fa-paper-plane me-2"></i> Confirmer ma demande
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let selectedOption = null;
    let loanData = {};

    // Mise à jour du slider
    document.getElementById('duree').addEventListener('input', function(e) {
        const years = Math.floor(e.target.value / 12);
        document.getElementById('dureeValue').textContent = years;
    });

    function calculateOptions() {
        const typePret = document.querySelector('input[name="typePret"]:checked').value;
        const montant = parseFloat(document.getElementById('montant').value);
        const dureeMois = parseInt(document.getElementById('duree').value);

        if (!montant || montant < 10000) {
            alert('Veuillez saisir un montant valide (minimum 10 000 MAD)');
            return;
        }

        loanData = { typePret, montant, dureeMois };

        const options = [
            {
                name: "Classique",
                taux: typePret === 'IMMOBILIER' ? 4.5 : 6.0,
                badge: null,
                features: ["Remboursement standard", "Sans frais de dossier"]
            },
            {
                name: "Confort",
                taux: typePret === 'IMMOBILIER' ? 4.2 : 5.5,
                badge: "Recommandé",
                badgeClass: "recommended",
                features: ["Modulation possible", "Assurance incluse", "Report d'échéance 1x/an"]
            },
            {
                name: "Premium",
                taux: typePret === 'IMMOBILIER' ? 3.9 : 5.0,
                badge: "Meilleur taux",
                badgeClass: "",
                features: ["Remboursement anticipé gratuit", "Assurance premium", "Accompagnement dédié"]
            },
            {
                name: "Express",
                taux: typePret === 'IMMOBILIER' ? 4.8 : 6.5,
                badge: "Réponse rapide",
                badgeClass: "",
                features: ["Décision sous 48h", "Déblocage rapide"]
            }
        ];

        renderOptions(options);
        goToStep(2);
    }

    function renderOptions(options) {
        const container = document.getElementById('optionsContainer');
        container.innerHTML = '';

        options.forEach(function(option, index) {
            const tauxMensuel = option.taux / 100 / 12;
            const mensualite = (loanData.montant * tauxMensuel * Math.pow(1 + tauxMensuel, loanData.dureeMois)) / 
                               (Math.pow(1 + tauxMensuel, loanData.dureeMois) - 1);
            const coutTotal = mensualite * loanData.dureeMois;
            const interets = coutTotal - loanData.montant;

            let badgeHtml = '';
            if (option.badge) {
                const badgeClass = option.badgeClass || '';
                badgeHtml = '<div class="option-badge ' + badgeClass + '">' + option.badge + '</div>';
            }

            let featuresHtml = '';
            option.features.forEach(function(f) {
                featuresHtml += '<div class="mb-2"><i class="fa-solid fa-check-circle text-success me-2"></i><small>' + f + '</small></div>';
            });

            const cardHtml = 
                '<div class="col-lg-6">' +
                    '<div class="option-card" onclick="selectOption(' + index + ',' + mensualite.toFixed(2) + ',' + option.taux + ')">' +
                        badgeHtml +
                        '<h4 class="fw-bold mb-3">' + option.name + '</h4>' +
                        '<div class="mb-3">' +
                            '<div class="rate-indicator">' +
                                '<i class="fa-solid fa-percent"></i> Taux ' + option.taux + '%' +
                            '</div>' +
                        '</div>' +
                        '<div class="monthly-payment mb-2">' + Math.round(mensualite) + ' <small class="fs-6 text-muted">MAD/mois</small></div>' +
                        '<p class="text-muted small mb-4">Pendant ' + Math.floor(loanData.dureeMois/12) + ' ans</p>' +
                        '<div class="mt-4">' +
                            '<div class="detail-row"><span class="text-muted">Montant emprunté</span><strong>' + loanData.montant.toLocaleString() + ' MAD</strong></div>' +
                            '<div class="detail-row"><span class="text-muted">Intérêts totaux</span><strong class="text-warning">' + Math.round(interets).toLocaleString() + ' MAD</strong></div>' +
                            '<div class="detail-row"><span class="text-muted">Coût total</span><strong class="text-primary">' + Math.round(coutTotal).toLocaleString() + ' MAD</strong></div>' +
                        '</div>' +
                        '<div class="mt-4 pt-3 border-top">' + featuresHtml + '</div>' +
                    '</div>' +
                '</div>';
            
            container.innerHTML += cardHtml;
        });
    }

    function selectOption(index, mensualite, taux) {
        document.querySelectorAll('.option-card').forEach(function(card) {
            card.classList.remove('selected');
        });
        document.querySelectorAll('.option-card')[index].classList.add('selected');
        selectedOption = { index: index, mensualite: mensualite, taux: taux };
        document.getElementById('btnContinue').disabled = false;
    }

    function goToStep(stepNumber) {
        document.querySelectorAll('.step-content').forEach(function(content) {
            content.classList.remove('active');
        });
        document.querySelectorAll('.step').forEach(function(step) {
            step.classList.remove('active', 'completed');
        });

        document.getElementById('content-step' + stepNumber).classList.add('active');

        for (let i = 1; i < stepNumber; i++) {
            document.getElementById('step' + i).classList.add('completed');
        }
        document.getElementById('step' + stepNumber).classList.add('active');

        if (stepNumber === 3 && selectedOption) {
            showSummary();
        }
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function showSummary() {
        const summary = 
            '<div class="bg-light p-4 rounded">' +
                '<div class="row g-4">' +
                    '<div class="col-md-6"><h6 class="text-muted mb-2">Type de prêt</h6><p class="fw-bold fs-5">' + loanData.typePret + '</p></div>' +
                    '<div class="col-md-6"><h6 class="text-muted mb-2">Montant</h6><p class="fw-bold fs-5">' + loanData.montant.toLocaleString() + ' MAD</p></div>' +
                    '<div class="col-md-6"><h6 class="text-muted mb-2">Durée</h6><p class="fw-bold fs-5">' + Math.floor(loanData.dureeMois/12) + ' ans (' + loanData.dureeMois + ' mois)</p></div>' +
                    '<div class="col-md-6"><h6 class="text-muted mb-2">Taux annuel</h6><p class="fw-bold fs-5">' + selectedOption.taux + '%</p></div>' +
                '</div>' +
                '<div class="alert alert-info mt-4 mb-0"><strong><i class="fa-solid fa-calendar me-2"></i>Mensualité : ' + selectedOption.mensualite.toFixed(2) + ' MAD</strong></div>' +
            '</div>';
        
        document.getElementById('summaryContainer').innerHTML = summary;
        document.getElementById('finalTypePret').value = loanData.typePret;
        document.getElementById('finalMontant').value = loanData.montant;
        document.getElementById('finalDuree').value = loanData.dureeMois;
        document.getElementById('finalTaux').value = selectedOption.taux;
        document.getElementById('finalMensualite').value = selectedOption.mensualite;
    }
</script>

</body>
</html>