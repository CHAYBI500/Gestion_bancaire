package com.banque.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Configuration MySQL pour WampServer
    private static final String URL = "jdbc:mysql://localhost:3306/pret_bancaires?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";  // Vide par défaut sur WampServer
    
    public static Connection getConnection() {
        try {
            // Charger le driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}