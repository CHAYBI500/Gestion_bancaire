package com.banque.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String role;
    private boolean isActive;
    
    // Constructeurs
    public User() {}
    
    public User(int id, String username, String role) {
        this.id = id;
        this.username = username;
        this.role = role;
    }
    
    // Getters et Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    // Méthodes utiles
    public boolean isAdmin() {
        return "ADMIN".equals(this.role);
    }
    
    public boolean isGestionnaire() {
        return "GESTIONNAIRE".equals(this.role);
    }
    
    public boolean isConsultant() {
        return "CONSULTANT".equals(this.role);
    }
}