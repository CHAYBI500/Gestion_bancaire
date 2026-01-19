<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("AGENT")){
        response.sendRedirect("../error/accessDenied.jsp");
        return;
    }
    
    // Récupération des messages depuis les attributs ET les paramètres URL
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = request.getParameter("error");
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration | Créer un Nouveau Prêt</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bank-primary: #003a8f;
            --bank-gold: #c9a23f;
            --bank-dark: #0b1f3a;
            --bank-bg: #f8fafc;
        }

        body {
            background: linear-gradient(135deg, #f0f4f8 0%, #d7e1ec 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .loan-card {
            background: #ffffff;
            border: none;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            width: 100%;
            max-width: 600px;
        }

        .card-header-bank {
            background-color: var(--bank-primary);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
        }

        .card-header-bank i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--bank-gold);
        }

        /* Alert Styles */
        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 25px;
            animation: slideIn 0.3s ease-out;
        }

        .alert-custom i {
            font-size: 1.2rem;
            margin-right: 10px;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label {
            font-weight: 700;
            color: var(--bank-dark);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }

        .input-group-text {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-right: none;
            color: var(--bank-primary);
            padding-left: 15px;
            padding-right: 15px;
        }

        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            padding: 14px;
            font-size: 1rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 4px rgba(0, 58, 143, 0.1);
            border-color: var(--bank-primary);
        }

        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545;
        }

        .btn-create {
            background: var(--bank-primary);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }

        .btn-create:hover {
            background: #002d6e;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 58, 143, 0.2);
        }

        .btn-create:disabled {
            background: #94a3b8;
            cursor: not-allowed;
            transform: none;
        }

        .btn-cancel {
            display: block;
            text-align: center;
            color: #64748b;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            margin-top: 20px;
            transition: color 0.2s;
        }

        .btn-cancel:hover { color: #1e293b; }

        .taux-display {
            background: #f1f5f9;
            border-radius: 12px;
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
            border: 1px dashed #cbd5e1;
        }

        .taux-value {
            font-weight: 800;
            color: var(--bank-primary);
            font-size: 1.2rem;
        }
    </style>
</head>
<body>

<div class="loan-card">
    <div class="card-header-bank">
        <i class="fa-solid fa-shield-halved"></i>
        <h2 class="h4 mb-1 fw-bold">Nouveau Dossier de Prêt</h2>
        <p class="text-white-50 small mb-0">Enregistrement sécurisé - Plateforme Agent</p>
    </div>

    <div class="p-4 p-md-5">
        <!-- Message d'erreur -->
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <strong>Erreur :</strong> <%= errorMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>

        <form action="../CreerPretServlet" method="post" id="loanForm">
            
            <div class="mb-4">
                <label for="idClient" class="form-label">Identifiant Client</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-fingerprint"></i></span>
                    <input type="number" class="form-control" id="idClient" name="idClient" 
                           placeholder="ID Unique" required min="1">
                </div>
                <small class="text-muted">Entrez l'ID du client pour lequel vous souhaitez créer le prêt</small>
            </div>

            <div class="mb-4">
                <label for="typePret" class="form-label">Type de Financement</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-list-check"></i></span>
                    <select class="form-select" id="typePret" name="typePret" required>
                        <option value="" disabled selected>Sélectionner...</option>
                        <option value="IMMOBILIER">🏠 Prêt Immobilier</option>
                        <option value="AUTOMOBILE">🚗 Prêt Automobile</option>
                    </select>
                </div>
            </div>

            <input type="hidden" id="taux" name="taux" value="0">
            <div class="taux-display">
                <span class="text-muted small fw-bold text-uppercase">Taux Annuel Appliqué :</span>
                <span class="taux-value" id="tauxLabel">-- %</span>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <label for="montant" class="form-label">Montant (DH)</label>
                    <input type="number" step="0.01" class="form-control" id="montant" name="montant" 
                           placeholder="Capital" required min="1000">
                    <small class="text-muted">Minimum 1 000 DH</small>
                </div>

                <div class="col-md-6 mb-4">
                    <label for="duree" class="form-label">Durée (Mois)</label>
                    <input type="number" class="form-control" id="duree" name="duree" 
                           placeholder="Ex: 120" required min="1" max="360">
                    <small class="text-muted">Maximum 360 mois</small>
                </div>
            </div>

            <div class="alert alert-info alert-custom" id="calculInfo" style="display: none;">
                <i class="fa-solid fa-calculator"></i>
                <strong>Estimation :</strong> <span id="estimationText"></span>
            </div>

            <button type="submit" class="btn btn-create" id="submitBtn">
                <i class="fa-solid fa-paper-plane me-2"></i>Soumettre la demande
            </button>
            
            <a href="dashboard.jsp" class="btn btn-cancel">
                <i class="fa-solid fa-arrow-left me-1"></i> Retour au tableau de bord
            </a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Gestion automatique du taux selon le type de prêt
    const typePretSelect = document.getElementById('typePret');
    const tauxHidden = document.getElementById('taux');
    const tauxLabel = document.getElementById('tauxLabel');
    const montantInput = document.getElementById('montant');
    const dureeInput = document.getElementById('duree');
    const calculInfo = document.getElementById('calculInfo');
    const estimationText = document.getElementById('estimationText');

    typePretSelect.addEventListener('change', function() {
        let tauxApplique = 0;

        if (this.value === 'IMMOBILIER') {
            tauxApplique = 4.50;
        } else if (this.value === 'AUTOMOBILE') {
            tauxApplique = 6.75;
        }

        tauxHidden.value = tauxApplique;
        tauxLabel.textContent = tauxApplique.toFixed(2) + " %";
        
        // Animation visuelle
        tauxLabel.style.color = "#16a34a";
        setTimeout(() => { tauxLabel.style.color = "#003a8f"; }, 500);
        
        calculateEstimation();
    });

    // Calcul en temps réel de la mensualité
   function calculateEstimation() {

    const montantValue = montantInput.value.trim();
    const dureeValue = dureeInput.value.trim();

    // Sécurité totale
    if (montantValue === "" || dureeValue === "") {
        calculInfo.style.display = "none";
        return;
    }

    const montant = parseFloat(montantValue);
    const duree = parseInt(dureeValue);

    if (isNaN(montant) || isNaN(duree) || montant <= 0 || duree <= 0) {
        calculInfo.style.display = "none";
        return;
    }

    let coefficient;

    if (duree <= 12) {
        coefficient = 0.09;
    } else if (duree <= 24) {
        coefficient = 0.047;
    } else if (duree <= 36) {
        coefficient = 0.033;
    } else if (duree <= 60) {
        coefficient = 0.021;
    } else if (duree <= 120) {
        coefficient = 0.013;
    } else {
        coefficient = 0.010;
    }

    const mensualite = montant * coefficient;

    estimationText.textContent = mensualite.toFixed(2) + "MAD";
    calculInfo.style.display = "block";
}





    montantInput.addEventListener('input', calculateEstimation);
    dureeInput.addEventListener('input', calculateEstimation);

    // Validation du formulaire
    document.getElementById('loanForm').addEventListener('submit', function(e) {
        const montant = parseFloat(montantInput.value);
        const duree = parseInt(dureeInput.value);

        if (montant < 1000) {
            e.preventDefault();
            alert('Le montant minimum est de 1 000 MAD');
            montantInput.focus();
            return false;
        }

        if (duree < 1 || duree > 360) {
            e.preventDefault();
            alert('La durée doit être comprise entre 1 et 360 mois');
            dureeInput.focus();
            return false;
        }

        // Désactiver le bouton pour éviter les doubles soumissions
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i>Traitement en cours...';
    });
</script>

</body>
</html>