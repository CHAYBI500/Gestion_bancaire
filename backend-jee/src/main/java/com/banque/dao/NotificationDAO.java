package com.banque.dao;

import com.banque.model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    /* ===============================
       Récupérer les notifications non lues
       =============================== */
	/* ===============================
	   Récupérer toutes les notifications
	   =============================== */
	public List<Notification> findAll() {

	    List<Notification> notifications = new ArrayList<>();

	    String sql = """
	            SELECT *
	            FROM notification
	            ORDER BY created_at DESC
	            """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            Notification n = mapNotification(rs);
	            notifications.add(n);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return notifications;
	}

    public List<Notification> findUnread() {

        List<Notification> notifications = new ArrayList<>();

        String sql = """
                SELECT *
                FROM notification
                WHERE is_read = false
                ORDER BY created_at DESC
                LIMIT 10
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Notification n = mapNotification(rs);
                notifications.add(n);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    /* ===============================
       Marquer une notification comme lue
       =============================== */
    public boolean markAsRead(int idNotification) {

        String sql = "UPDATE notification SET is_read = true WHERE id_notification = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idNotification);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /* ===============================
       Ajouter une notification
       =============================== */
    public boolean insert(Notification n) {

        String sql = """
                INSERT INTO notification
                (type, titre, message, id_pret, niveau_risque, is_read, created_at)
                VALUES (?, ?, ?, ?, ?, false, NOW())
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, n.getType());
            ps.setString(2, n.getTitre());
            ps.setString(3, n.getMessage());
            ps.setInt(4, n.getIdPret());
            ps.setString(5, n.getNiveauRisque());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /* ===============================
       Compter les notifications non lues
       =============================== */
    public int countUnread() {

        String sql = "SELECT COUNT(*) FROM notification WHERE is_read = false";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /* ===============================
       Méthode de mapping ResultSet → Objet
       =============================== */
    private Notification mapNotification(ResultSet rs) throws SQLException {

        Notification n = new Notification();

        n.setId(rs.getInt("id_notification"));
        n.setType(rs.getString("type"));
        n.setTitre(rs.getString("titre"));
        n.setMessage(rs.getString("message"));
        n.setIdPret(rs.getInt("id_pret"));
        n.setNiveauRisque(rs.getString("niveau_risque"));
        n.setCreatedAt(rs.getTimestamp("created_at"));

        return n;
    }
}
