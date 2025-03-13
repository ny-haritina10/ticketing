package controller;

import java.math.BigDecimal;
import java.sql.Connection;
import java.util.UUID;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationRequestParam;
import annotation.AnnotationURL;

import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.Admin;
import model.City;
import model.Flight;
import model.FlightPrice;
import model.FlightPromotion;
import model.FlightReservation;
import model.Plane;

import modelview.ModelView;
import validation.Valid;
import annotation.AuthController;

@AuthController(roles = { Admin.class })  
@AnnotationController(name = "flight_controller")
public class FlightController {

    private static final String MAIN_TEMPLATE = "main.jsp";

    @AnnotationGetMapping
    @AnnotationURL("/form")
    public ModelView redirectToForm() {
        try (Connection connection = new Database().getConnection()){
            // Create ModelView with main template instead of direct view
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            City[] cities = City.getAll(connection, City.class);
            Plane[] planes = Plane.getAll(connection, Plane.class);

            // Add data for the form
            mv.add("cities", cities);
            mv.add("planes", planes);
            
            // Add template parameters
            mv.add("activePage", "insert_flight");
            mv.add("contentPage", "form-flight.jsp");
            mv.add("pageTitle", "Insert Flight");

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/insert")
    public ModelView insert(@Valid @AnnotationModelAttribute("flight") Flight flight) {
        try (Connection connection = new Database().getConnection()) {
            flight.setFlightNumber(UUID.randomUUID().toString().substring(1, 20));
            flight.save(connection);
            return list(); 
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/list")
    public ModelView list() {
        try (Connection connection = new Database().getConnection()) {
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            Flight[] flights = Flight.getAll(connection, Flight.class);
            mv.add("flights", flights);
            
            // Add template parameters
            mv.add("activePage", "list_flight");
            mv.add("contentPage", "list-flight.jsp");
            mv.add("pageTitle", "Flight List");
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Load update form
    @AnnotationGetMapping
    @AnnotationURL("/edit")
    public ModelView updateForm(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            Flight flight = Flight.findById(connection, Flight.class, id);
            City[] cities = City.getAll(connection, City.class);
            Plane[] planes = Plane.getAll(connection, Plane.class);

            mv.add("flight", flight);
            mv.add("cities", cities);
            mv.add("planes", planes);
            
            // Add template parameters
            mv.add("activePage", "list_flight"); // Keep list active since edit is part of the list flow
            mv.add("contentPage", "edit-flight.jsp");
            mv.add("pageTitle", "Edit Flight");

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Update flight
    @AnnotationPostMapping
    @AnnotationURL("/update")
    public ModelView update(@AnnotationModelAttribute("flight") Flight flight) {
        try (Connection connection = new Database().getConnection()) {
            flight.update(connection);
            return list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Delete flight
    @AnnotationGetMapping
    @AnnotationURL("/delete")
    public ModelView delete(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            Flight flight = Flight.findById(connection, Flight.class, id);
            if (flight != null) {
                flight.delete(connection);
            }
            return list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/configure")
    public ModelView configureFlightPrices(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            Flight flight = Flight.findById(connection, Flight.class, id);

            mv.add("flight", flight);

            // Set view parameters
            mv.add("activePage", "configure_flight");
            mv.add("contentPage", "flight-price.jsp");
            mv.add("pageTitle", "Configure Flight Prices");

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/configure_flight_price")
    public ModelView configure(
        @AnnotationRequestParam(name = "Economy_price") Double economicPrice,
        @AnnotationRequestParam(name = "Business_price") Double businessPrice,
        @AnnotationRequestParam(name = "FirstClass_price") Double firstClassPrice,
        @AnnotationRequestParam(name = "id") Integer id
    ) {
        try (Connection connection = new Database().getConnection()){
            Flight flight = Flight.findById(connection, Flight.class, id);
            ModelView mv = new ModelView(MAIN_TEMPLATE);

            FlightPrice eco = new FlightPrice();
            eco.setFlight(flight);
            eco.setCategory("Economy");
            eco.setBasePrice(new BigDecimal(economicPrice.doubleValue()));

            FlightPrice business = new FlightPrice();
            business.setFlight(flight);
            business.setCategory("Business");
            business.setBasePrice(new BigDecimal(businessPrice.doubleValue()));

            FlightPrice firstClass = new FlightPrice();
            firstClass.setFlight(flight);
            firstClass.setCategory("First Class");
            firstClass.setBasePrice(new BigDecimal(firstClassPrice.doubleValue()));

            eco.save(connection);
            business.save(connection);
            firstClass.save(connection);

            mv.add("activePage", "dashboard");
            mv.add("contentPage", "dashboard.jsp");
            mv.add("pageTitle", "Dashboard");

            return mv;   
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/details")
    public ModelView details(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            Flight flight = Flight.findById(connection, Flight.class, id);
            
            // Get flight prices if available
            FlightPrice[] prices = null;
            if (flight != null) {
                // Assuming you have a method to get prices by flight
                prices = FlightPrice.findByCriteria(
                    connection, 
                    FlightPrice.class,
                    new Criterion("id_flight", "=", id)
                );
            }
            
            mv.add("flight", flight);
            mv.add("prices", prices);
            
            // Add template parameters
            mv.add("activePage", "list_flight");
            mv.add("contentPage", "flight-details.jsp");
            mv.add("pageTitle", "Flight Details");
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/form_promotion")
    public ModelView redirectToPromotionForm() {
        try (Connection connection = new Database().getConnection()){
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            Flight[] flights = Flight.getAll(connection, Flight.class);

            // Add data for the form
            mv.add("flights", flights);
            
            // Add template parameters
            mv.add("activePage", "insert_promotion");
            mv.add("contentPage", "form-promotion.jsp");
            mv.add("pageTitle", "Insert Flight Promotion");

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/insert_promotion")
    public ModelView insertPromotion(
        @AnnotationRequestParam(name = "flight") Integer flightId,
        @AnnotationRequestParam(name = "category") String category,
        @AnnotationRequestParam(name = "discountPercentage") double discountPercentage,
        @AnnotationRequestParam(name = "seatsAvailable") Integer seatsAvailable
    ) {
        try (Connection connection = new Database().getConnection()) {
            Flight flight = Flight.findById(connection, Flight.class, flightId);
            
            FlightPromotion promotion = new FlightPromotion();

            promotion.setFlight(flight);
            promotion.setCategory(category);
            promotion.setDiscountPercentage(new BigDecimal(discountPercentage));
            promotion.setSeatsAvailable(seatsAvailable);
            
            promotion.save(connection);
            
            return listPromotions(); 
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }   

    @AnnotationGetMapping
    @AnnotationURL("/list_promotions")
    public ModelView listPromotions() {
        try (Connection connection = new Database().getConnection()) {
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            FlightPromotion[] promotions = FlightPromotion.getAll(connection, FlightPromotion.class);
            mv.add("promotions", promotions);
            
            // Add template parameters
            mv.add("activePage", "list_promotions");
            mv.add("contentPage", "list-promotion.jsp");
            mv.add("pageTitle", "Flight Promotions List");
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/delete_promotion")
    public ModelView deletePromotion(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            FlightPromotion promotion = FlightPromotion.findById(connection, FlightPromotion.class, id);
            if (promotion != null) {
                promotion.delete(connection);
            }
            return listPromotions();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/form_reservation_setting")
    public ModelView redirectToReservationForm() {
        try (Connection connection = new Database().getConnection()){
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            Flight[] flights = Flight.getAll(connection, Flight.class);

            // Add data for the form
            mv.add("flights", flights);
            
            // Add template parameters
            mv.add("activePage", "insert_reservation");
            mv.add("contentPage", "form-reservation-setting.jsp");
            mv.add("pageTitle", "Insert Flight Reservation Setting");

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/insert_reservation_setting")
    public ModelView insertReservation(
        @AnnotationModelAttribute(value = "flight_reservation") FlightReservation reservation
    ) {
        try (Connection connection = new Database().getConnection()) {
            reservation.save(connection);
            return listReservations(); 
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/list_reservations_setting")
    public ModelView listReservations() {
        try (Connection connection = new Database().getConnection()) {
            // Create ModelView with main template
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            FlightReservation[] reservations = FlightReservation.getAll(connection, FlightReservation.class);
            mv.add("reservations", reservations);
            
            // Add template parameters
            mv.add("activePage", "list_reservations");
            mv.add("contentPage", "list-reservation-setting.jsp");
            mv.add("pageTitle", "Flight Reservation Settings List");
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/delete_reservation_setting")
    public ModelView deleteReservation(@AnnotationRequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            FlightReservation reservation = FlightReservation.findById(connection, FlightReservation.class, id);
            if (reservation != null) {
                reservation.delete(connection);
            }
            return listReservations();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}