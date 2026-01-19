package com.banque.dao;

import com.banque.model.Client;
import java.sql.*;
import java.util.*;

public class ClientDAO {
    
    // Méthode pour récupérer un client par son ID
    public Client findById(int idClient) {
        Client client = null;
        String sql = "SELECT * FROM client WHERE id_client = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idClient);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                client = new Client();
                client.setIdClient(rs.getInt("id_client"));
                client.setIdentifiantOriginal(rs.getInt("identifiant_original"));
                client.setVille(rs.getString("ville"));
                client.setCodePostal(rs.getString("code_postal"));
                client.setRevenuMensuel(rs.getDouble("revenu_mensuel"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return client;
    }
    
    // Méthode pour ajouter un nouveau client
    public boolean add(Client client) {
        String sql = "INSERT INTO client (identifiant_original, ville, code_postal, revenu_mensuel) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, client.getIdentifiantOriginal());
            ps.setString(2, client.getVille());
            ps.setString(3, client.getCodePostal());
            ps.setDouble(4, client.getRevenuMensuel());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Méthode pour modifier un client existant
    public boolean update(Client client) {
        String sql = "UPDATE client SET identifiant_original = ?, ville = ?, code_postal = ?, revenu_mensuel = ? WHERE id_client = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, client.getIdentifiantOriginal());
            ps.setString(2, client.getVille());
            ps.setString(3, client.getCodePostal());
            ps.setDouble(4, client.getRevenuMensuel());
            ps.setInt(5, client.getIdClient());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Méthode pour supprimer un client
    public boolean delete(int idClient) {
        String sql = "DELETE FROM client WHERE id_client = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idClient);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Méthode de recherche
    public List<Client> search(String field, String value) {
        List<Client> clients = new ArrayList<>();
        String sql = "SELECT * FROM client WHERE ";
        
        switch (field) {
            case "identifiantOriginal":
                sql += "identifiant_original = ?";
                break;
            case "ville":
                sql += "ville LIKE ?";
                value = "%" + value + "%";
                break;
            case "codePostal":
                sql += "code_postal LIKE ?";
                value = "%" + value + "%";
                break;
            case "revenuMensuel":
                sql += "revenu_mensuel >= ?";
                break;
            default:
                return findAll();
        }
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if ("identifiantOriginal".equals(field)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("revenuMensuel".equals(field)) {
                ps.setDouble(1, Double.parseDouble(value));
            } else {
                ps.setString(1, value);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Client c = new Client();
                c.setIdClient(rs.getInt("id_client"));
                c.setIdentifiantOriginal(rs.getInt("identifiant_original"));
                c.setVille(rs.getString("ville"));
                c.setCodePostal(rs.getString("code_postal"));
                c.setRevenuMensuel(rs.getDouble("revenu_mensuel"));
                clients.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clients;
    }
    
    // Méthode pour récupérer tous les clients
    public List<Client> findAll() {
        List<Client> clients = new ArrayList<>();
        String sql = "SELECT * FROM client ORDER BY id_client DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Client cl = new Client();
                cl.setIdClient(rs.getInt("id_client"));
                cl.setIdentifiantOriginal(rs.getInt("identifiant_original"));
                cl.setVille(rs.getString("ville"));
                cl.setCodePostal(rs.getString("code_postal"));
                cl.setRevenuMensuel(rs.getDouble("revenu_mensuel"));
                clients.add(cl);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clients;
    }
}