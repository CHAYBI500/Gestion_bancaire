package com.banque.dao;

import com.banque.model.User;
import java.sql.*;

public class UserDAO {
    
    public User login(String username, String password) {
        // Requête SQL pour MySQL (pas de guillemets doubles)
        String sql = "SELECT id_user, username, role FROM user WHERE username = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id_user"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                return user;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Méthode pour vérifier avec mot de passe hashé (recommandé)
    public User loginSecure(String username, String password) {
        String sql = "SELECT id_user, username, password, role FROM user WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                
                // Vérifier le mot de passe hashé (nécessite BCrypt)
                // if (BCrypt.checkpw(password, hashedPassword)) {
                //     User user = new User();
                //     user.setId(rs.getInt("id_user"));
                //     user.setUsername(rs.getString("username"));
                //     user.setRole(rs.getString("role"));
                //     return user;
                // }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
}