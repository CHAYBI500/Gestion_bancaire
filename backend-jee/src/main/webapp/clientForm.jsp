<%@ page import="com.banque.model.Client" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("client") != null ? "Modifier" : "Ajouter" %> Client - Banque Digitale</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --success-color: #10b981;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)) !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            max-width: 800px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            font-weight: 600;
            padding: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .form-control {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            padding: 0.75rem 2rem;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border: none;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #059669);
            border: none;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            border: none;
        }

        .required {
            color: #ef4444;
            font-weight: bold;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="dashboard">
            <i class="bi bi-bank2"></i> Banque Digitale
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a class="nav-link" href="clients">
                <i class="bi bi-people"></i> Clients
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4 fade-in">

<%
Client client = (Client) request.getAttribute("client");
boolean isEdit = (client != null);
%>

<!-- En-tête de page -->
<div class="page-header">
    <div class="row align-items-center">
        <div class="col">
            <h2 class="mb-2">
                <i class="bi bi-<%= isEdit ? "pencil-square" : "plus-circle" %>"></i> 
                <%= isEdit ? "Modifier" : "Ajouter" %> un Client
            </h2>
            <p class="mb-0 opacity-90">
                Remplissez tous les champs obligatoires
            </p>
        </div>
        <div class="col-auto">
            <a href="clients" class="btn btn-light">
                <i class="bi bi-arrow-left"></i> Retour
            </a>
        </div>
    </div>
</div>

<!-- Formulaire -->
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">
            <i class="bi bi-clipboard-data"></i> Informations du Client
        </h5>
    </div>
    <div class="card-body p-4">
        <form method="POST" action="clients" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="save">
            
            <% if (isEdit) { %>
            <input type="hidden" name="idClient" value="<%= client.getIdClient() %>">
            <% } %>

            <div class="row g-4">
                <!-- Identifiant Original -->
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="bi bi-fingerprint"></i> Identifiant Original <span class="required">*</span>
                    </label>
                    <input type="number" 
                           class="form-control" 
                           name="identifiantOriginal" 
                           value="<%= isEdit ? client.getIdentifiantOriginal() : "" %>"
                           required
                           min="1"
                           placeholder="Ex: 12345">
                </div>

                <!-- Ville -->
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="bi bi-geo-alt"></i> Ville <span class="required">*</span>
                    </label>
                    <input type="text" 
                           class="form-control" 
                           name="ville" 
                           value="<%= isEdit ? client.getVille() : "" %>"
                           required
                           maxlength="100"
                           placeholder="Ex: Paris">
                </div>

                <!-- Code Postal -->
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="bi bi-mailbox"></i> Code Postal <span class="required">*</span>
                    </label>
                    <input type="text" 
                           class="form-control" 
                           name="codePostal" 
                           value="<%= isEdit ? client.getCodePostal() : "" %>"
                           required
                           maxlength="10"
                           pattern="[0-9]{5}"
                           title="Le code postal doit contenir 5 chiffres"
                           placeholder="Ex: 75001">
                </div>

                <!-- Revenu Mensuel -->
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="bi bi-currency-euro"></i> Revenu Mensuel (€) <span class="required">*</span>
                    </label>
                    <input type="number" 
                           class="form-control" 
                           name="revenuMensuel" 
                           value="<%= isEdit ? client.getRevenuMensuel() : "" %>"
                           required
                           step="0.01"
                           min="0"
                           placeholder="Ex: 2500.00">
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="mt-5 d-flex justify-content-between">
                <a href="clients" class="btn btn-secondary btn-lg">
                    <i class="bi bi-x-circle"></i> Annuler
                </a>
                <button type="submit" class="btn <%= isEdit ? "btn-primary" : "btn-success" %> btn-lg">
                    <i class="bi bi-<%= isEdit ? "check-circle" : "plus-circle" %>"></i> 
                    <%= isEdit ? "Mettre à jour" : "Créer le client" %>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Note d'information -->
<div class="alert alert-info mt-4" style="border-radius: 15px; border: none;">
    <i class="bi bi-info-circle-fill"></i>
    <strong>Note :</strong> Tous les champs marqués d'un <span class="required">*</span> sont obligatoires.
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function validateForm() {
    const identifiant = document.querySelector('[name="identifiantOriginal"]').value;
    const ville = document.querySelector('[name="ville"]').value.trim();
    const codePostal = document.querySelector('[name="codePostal"]').value.trim();
    const revenu = document.querySelector('[name="revenuMensuel"]').value;

    if (!identifiant || identifiant <= 0) {
        alert('L\'identifiant original doit être un nombre positif.');
        return false;
    }

    if (!ville || ville.length < 2) {
        alert('La ville doit contenir au moins 2 caractères.');
        return false;
    }

    if (!codePostal || !/^[0-9]{5}$/.test(codePostal)) {
        alert('Le code postal doit contenir exactement 5 chiffres.');
        return false;
    }

    if (!revenu || revenu < 0) {
        alert('Le revenu mensuel doit être un nombre positif ou zéro.');
        return false;
    }

    return true;
}
</script>
</body>
</html>