package service;

import java.sql.Timestamp;
import java.time.ZonedDateTime;
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

    public static boolean isSeatCategoryPromotional(Connection connection, 
                                           Flight flight, 
                                           String seatCategory,
                                           Timestamp reservationDateTime) 
        throws SQLException 
    {
        Reservation[] reservations = Reservation.findByCriteria(
            connection, 
            Reservation.class, 
            new Criterion("id_flight", "=", flight.getId()),
            new Criterion("seat_category", "=", seatCategory),
            new Criterion("reservation_time", "<=", reservationDateTime)
        );
        
        // only one promotion for a flight and seat type
        FlightPromotion[] promotions = FlightPromotion.findByCriteria(
            connection, 
            FlightPromotion.class, 
            new Criterion("id_flight", "=", flight.getId()),
            new Criterion("category", "=", seatCategory)
        );

        int reservedSeat = reservations.length;
        int result = 0;

        if (promotions.length == 0 || promotions == null) {
            result += (0 - reservedSeat);
        }
        
        else  
        { result += (promotions[0].getSeatsAvailable()) - reservedSeat; }

        // System.out.println("in promotion: " + promotions[0].getSeatsAvailable());
        System.out.println("reserved seat: " + reservedSeat);
        System.out.println("result: " + result);

        if (result <= 0) return true;
        else return false;
    }
}