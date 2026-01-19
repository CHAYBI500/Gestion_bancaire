<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion | Banque Digitale</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --gold-color: #f59e0b;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 25px;
            padding: 3rem 2.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            border: none;
            backdrop-filter: blur(10px);
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .bank-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.3);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .bank-icon i {
            color: white;
            font-size: 2.5rem;
        }

        .login-title {
            font-size: 1.75rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .login-subtitle {
            color: #64748b;
            font-size: 0.95rem;
        }

        .form-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            z-index: 10;
            pointer-events: none;
        }

        .form-control.with-icon {
            padding-left: 2.75rem;
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border: none;
            border-radius: 12px;
            padding: 0.875rem;
            font-weight: 600;
            font-size: 1rem;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 1rem 1.25rem;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .alert-danger {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            font-weight: 500;
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }

        .divider span {
            padding: 0 1rem;
            color: #94a3b8;
            font-size: 0.85rem;
        }

        .features {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
            color: #64748b;
            font-size: 0.9rem;
        }

        .feature-item i {
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .footer-text {
            text-align: center;
            margin-top: 2rem;
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #94a3b8;
            z-index: 10;
            transition: color 0.3s;
        }

        .password-toggle:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="bank-icon">
                    <i class="bi bi-bank2"></i>
                </div>
                <h1 class="login-title">Banque Digitale</h1>
                <p class="login-subtitle">Connectez-vous à votre espace</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger mb-3">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success mb-3">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form method="post" action="login">
                <div class="mb-3">
                    <label class="form-label">
                        <i class="bi bi-person-fill me-1"></i>
                        Nom d'utilisateur
                    </label>
                    <div class="input-group">
                        <i class="bi bi-person input-icon"></i>
                        <input type="text" 
                               name="username" 
                               class="form-control with-icon" 
                               placeholder="Entrez votre nom d'utilisateur"
                               required 
                               autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">
                        <i class="bi bi-lock-fill me-1"></i>
                        Mot de passe
                    </label>
                    <div class="input-group">
                        <i class="bi bi-lock input-icon"></i>
                        <input type="password" 
                               name="password" 
                               id="password"
                               class="form-control with-icon" 
                               placeholder="Entrez votre mot de passe"
                               required>
                        <i class="bi bi-eye password-toggle" 
                           id="togglePassword"
                           onclick="togglePasswordVisibility()"></i>
                    </div>
                </div>

                <button type="submit" class="btn btn-login w-100">
                    <i class="bi bi-box-arrow-in-right me-2"></i>
                    Se connecter
                </button>
            </form>

            <div class="features">
                <div class="feature-item">
                    <i class="bi bi-shield-check"></i>
                    <span>Connexion sécurisée et cryptée</span>
                </div>
                <div class="feature-item">
                    <i class="bi bi-clock-history"></i>
                    <span>Accès 24/7 à vos services bancaires</span>
                </div>
                <div class="feature-item">
                    <i class="bi bi-phone"></i>
                    <span>Compatible mobile et desktop</span>
                </div>
            </div>
        </div>

        <p class="footer-text">
            <i class="bi bi-shield-lock me-1"></i>
            Vos données sont protégées | © 2026 Banque Digitale
        </p>
    </div>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('togglePassword');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('bi-eye');
                toggleIcon.classList.add('bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('bi-eye-slash');
                toggleIcon.classList.add('bi-eye');
            }
        }

        // Animation au focus des inputs
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>