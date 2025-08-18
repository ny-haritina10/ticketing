package service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PromotionalSeatsService {

    public static void gererSiege(Connection connection, Date targetDate) throws Exception {
        try {
            connection.setAutoCommit(false);
            annulerImpaye(connection, targetDate);
            Map<String, Integer> unbookedSeats = calculerResteSiege(connection, targetDate);
            ajouterProchainPromotion(connection, unbookedSeats, targetDate);
            connection.commit();            
        } catch (Exception e) {
            connection.rollback();
            throw new Exception("Error managing unbooked seats: " + e.getMessage(), e);
        } finally {
            connection.setAutoCommit(true);
        }
    }


    private static void annulerImpaye(Connection connection, Date targetDate) throws SQLException {
        String query = """
            UPDATE reservations_details rd
            SET is_cancel = true, 
                cancellation_time = CURRENT_TIMESTAMP,
                cancellation_reason = 'Unpaid reservation - promotion expired'
            WHERE rd.is_promotional = true 
            AND rd.is_cancel = false
            AND rd.id_reservation IN (
                SELECT r.id FROM reservations r 
                WHERE r.payment_status = 'pending'
                AND r.id_flight IN (
                    SELECT fp.id_flight FROM flight_promotions fp 
                    WHERE fp.date_promotion <= ?
                )
            )
        """;
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDate(1, targetDate);
            int cancelledReservations = stmt.executeUpdate();
            System.out.println("Cancelled " + cancelledReservations + " unpaid promotional reservations");
        }
    }


    private static Map<String, Integer> calculerResteSiege(Connection connection, Date targetDate) throws SQLException {
        Map<String, Integer> unbookedSeats = new HashMap<>();
        
        String query = """
            SELECT 
                fp.id_flight,
                fp.category,
                fp.seats_available,
                COALESCE(booked_seats.total_booked, 0) AS total_booked,
                COALESCE(booked_seats.total_cancelled, 0) AS total_cancelled,
                (fp.seats_available - COALESCE(booked_seats.total_booked, 0)) AS unbooked
            FROM flight_promotions fp
            LEFT JOIN (
                SELECT 
                    r.id_flight,
                    rd.seat_category,
                    COUNT(*) FILTER (WHERE rd.is_promotional = true AND rd.is_cancel = false) AS total_booked,
                    COUNT(*) FILTER (WHERE rd.is_promotional = true AND rd.is_cancel = true) AS total_cancelled
                FROM reservations r
                JOIN reservations_details rd ON r.id = rd.id_reservation
                GROUP BY r.id_flight, rd.seat_category
            ) booked_seats 
            ON fp.id_flight = booked_seats.id_flight 
            AND fp.category = booked_seats.seat_category
            WHERE fp.date_promotion <= ?
            AND (fp.seats_available - COALESCE(booked_seats.total_booked, 0)) > 0
        """;

        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDate(1, targetDate);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int flightId = rs.getInt("id_flight");
                    String category = rs.getString("category");
                    int unbooked = rs.getInt("unbooked");
                    int total_cancelled = rs.getInt("total_cancelled");

                    int totalTenaIzy = total_cancelled + unbooked;
                    
                    String key = flightId + "-" + category;
                    unbookedSeats.put(key, unbookedSeats.getOrDefault(key, 0) + totalTenaIzy);
                }
            }
        }

        
        return unbookedSeats;
    }


    private static void ajouterProchainPromotion(Connection connection, Map<String, Integer> unbookedSeats, Date targetDate) throws SQLException {
        for (Map.Entry<String, Integer> entry : unbookedSeats.entrySet()) {
            String[] keyParts = entry.getKey().split("-");
            int flightId = Integer.parseInt(keyParts[0]);
            String category = keyParts[1];
            int unbookedCount = entry.getValue();
            
            String findNextPromotionQuery = """
                SELECT id, seats_available 
                FROM flight_promotions 
                WHERE id_flight = ? 
                AND category = ? 
                AND date_promotion > ?
                ORDER BY date_promotion ASC
                LIMIT 1
            """;
            
            try (PreparedStatement stmt = connection.prepareStatement(findNextPromotionQuery)) {
                stmt.setInt(1, flightId);
                stmt.setString(2, category);
                stmt.setDate(3, targetDate);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int promotionId = rs.getInt("id");
                        int currentSeats = rs.getInt("seats_available");
                        
                        String updateQuery = "UPDATE flight_promotions SET seats_available = ? WHERE id = ?";
                        try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                            updateStmt.setInt(1, currentSeats + unbookedCount);
                            updateStmt.setInt(2, promotionId);
                            updateStmt.executeUpdate();
                            
                            System.out.println("Carried over " + unbookedCount + " seats from flight " + flightId + 
                                             " category " + category + " to future promotion");
                        }
                    } else {
                        insererNonReserver(connection, flightId, category, unbookedCount, targetDate);
                    }
                }
            }
        }
    }

    private static void insererNonReserver(Connection connection, int flightId, String category, 
                                         int unbookedCount, Date originalPromotionDate) throws SQLException {
        String insertQuery = """
            INSERT INTO unbooked_promotional_seats (id_flight, category, seats_count, original_promotion_date)
            VALUES (?, ?, ?, ?)
            ON CONFLICT (id_flight, category, original_promotion_date)
            DO UPDATE SET seats_count = unbooked_promotional_seats.seats_count + EXCLUDED.seats_count
        """;
        
        try (PreparedStatement stmt = connection.prepareStatement(insertQuery)) {
            stmt.setInt(1, flightId);
            stmt.setString(2, category);
            stmt.setInt(3, unbookedCount);
            stmt.setDate(4, originalPromotionDate);
            stmt.executeUpdate();
            
            System.out.println("Stored " + unbookedCount + " unbooked seats for flight " + flightId + 
                             " category " + category);
        }
    }

    public static void ajouterToNewProm(Connection connection, int flightId, 
                                                     String category, int promotionId) throws SQLException {
        String findUnbookedQuery = """
            SELECT SUM(seats_count) as total_unbooked
            FROM unbooked_promotional_seats 
            WHERE id_flight = ? AND category = ?
        """;
        
        try (PreparedStatement stmt = connection.prepareStatement(findUnbookedQuery)) {
            stmt.setInt(1, flightId);
            stmt.setString(2, category);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int totalUnbooked = rs.getInt("total_unbooked");
                    if (totalUnbooked > 0) {
                        String updatePromotionQuery = """
                            UPDATE flight_promotions 
                            SET seats_available = seats_available + ? 
                            WHERE id = ?
                        """;
                        
                        try (PreparedStatement updateStmt = connection.prepareStatement(updatePromotionQuery)) {
                            updateStmt.setInt(1, totalUnbooked);
                            updateStmt.setInt(2, promotionId);
                            updateStmt.executeUpdate();
                        }
                        
                        String deleteUnbookedQuery = """
                            DELETE FROM unbooked_promotional_seats 
                            WHERE id_flight = ? AND category = ?
                        """;
                        
                        try (PreparedStatement deleteStmt = connection.prepareStatement(deleteUnbookedQuery)) {
                            deleteStmt.setInt(1, flightId);
                            deleteStmt.setString(2, category);
                            deleteStmt.executeUpdate();
                        }
                        
                        System.out.println("Added " + totalUnbooked + " unbooked seats to new promotion for flight " + 
                                         flightId + " category " + category);
                    }
                }
            }
        }
    }

    public static List<Map<String, Object>> getUnbookedSeatsSummary(Connection connection) throws SQLException {
        List<Map<String, Object>> summary = new ArrayList<>();
        
        String query = """
            SELECT 
                f.flight_number,
                f.id as flight_id,
                oc.city_name as origin_city,
                dc.city_name as destination_city,
                ups.category,
                ups.seats_count,
                ups.original_promotion_date
            FROM unbooked_promotional_seats ups
            JOIN flights f ON ups.id_flight = f.id
            JOIN cities oc ON f.id_origin_city = oc.id
            JOIN cities dc ON f.id_destination_city = dc.id
            ORDER BY f.flight_number, ups.category, ups.original_promotion_date
        """;
        
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("flightNumber", rs.getString("flight_number"));
                row.put("flightId", rs.getInt("flight_id"));
                row.put("originCity", rs.getString("origin_city"));
                row.put("destinationCity", rs.getString("destination_city"));
                row.put("category", rs.getString("category"));
                row.put("seatsCount", rs.getInt("seats_count"));
                row.put("originalPromotionDate", rs.getDate("original_promotion_date"));
                summary.add(row);
            }
        }
        
        return summary;
    }
}