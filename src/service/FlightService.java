package service;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import mg.jwe.orm.criteria.Criterion;
import model.Flight;
import model.FlightPromotion;
import model.Reservation;
import model.SeatPrice;

public class FlightService {
    
    public static Map<String, SeatPrice> calculateSeatPrices(Connection connection, int flightId, String[] seatCategories) 
        throws SQLException 
    {
        Map<String, SeatPrice> seatPrices = new HashMap<>();

        String query = "SELECT fp.category, fp.base_price, COALESCE(fpr.discount_percentage, 0) AS discount_percentage " +
                       "FROM flight_prices fp " +
                       "LEFT JOIN flight_promotions fpr ON fp.id_flight = fpr.id_flight AND fp.category = fpr.category " +
                       "WHERE fp.id_flight = ? AND fp.category = ANY(?)";

        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, flightId);
            preparedStatement.setArray(2, connection.createArrayOf("varchar", seatCategories));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    String category = resultSet.getString("category");
                    double basePrice = resultSet.getDouble("base_price");
                    double discountPercentage = resultSet.getDouble("discount_percentage");

                    double finalPrice = basePrice * (1 - discountPercentage / 100);

                    SeatPrice seatPrice = new SeatPrice(category, basePrice, discountPercentage, finalPrice);
                    seatPrices.put(category, seatPrice);
                }
            }
        }

        return seatPrices;
    }

    public static boolean isSeatCategoryPromotional(Connection connection, Flight flight, String seatCategory, Timestamp reservationDateTime) 
        throws SQLException 
    {
        // Get all reservation details based on the flight and seat category
        String query = "SELECT COUNT(*) FROM reservations r " +
                    "JOIN reservations_details rd ON r.id = rd.id_reservation " +
                    "WHERE r.id_flight = ? AND rd.seat_category = ? " +
                    "AND r.reservation_time <= ? AND rd.is_cancel = false";

        int reservedSeat = 0;
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, flight.getId());
            stmt.setString(2, seatCategory);
            stmt.setTimestamp(3, reservationDateTime);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    reservedSeat = rs.getInt(1);
                }
            }
        }
        
        // Check promotions (unchanged)
        FlightPromotion[] promotions = FlightPromotion.findByCriteria(
            connection, 
            FlightPromotion.class, 
            new Criterion("id_flight", "=", flight.getId()),
            new Criterion("category", "=", seatCategory)
        );

        int result = 0;

        if (promotions.length == 0 || promotions == null) {
            result = -reservedSeat;
        } else {
            result = promotions[0].getSeatsAvailable() - reservedSeat;
        }

        return result > 0;
    }
}