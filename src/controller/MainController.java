package controller;

import java.sql.Connection;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Map;

import annotation.Controller;
import annotation.Get;
import annotation.Url;
import database.Database;
import model.Flight;
import model.SeatPrice;
import modelview.ModelView;
import service.FlightService;

@Controller(name = "main_controller")
public class MainController {
    
    @Get
    @Url("/main")
    public ModelView test() {
        ModelView mv = new ModelView("test.jsp");
        try (Connection connection = new Database().getConnection()) {
            Flight[] flights = Flight.getAll(connection, Flight.class);
            String[] seatCategories = { "Economy", "Business", "First Class" };

            for(Flight flight: flights) {
                Map<String, SeatPrice> seatPrices = FlightService.calculateSeatPrices(connection, flight.getId(), seatCategories);

                seatPrices.forEach((category, seatPrice) -> {
                    System.out.println("Category: " + category + ", SeatPrice: " + seatPrice);
                });

                for(String type: seatCategories) {
                    System.out.println(FlightService.isSeatCategoryPromotional(connection, flight, type, Timestamp.valueOf(LocalDateTime.now())));                    
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return mv;
    }
}