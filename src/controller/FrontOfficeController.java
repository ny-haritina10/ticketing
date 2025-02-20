package controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import annotation.AnnotationController;
import annotation.AnnotationFileUpload;
import annotation.AnnotationGetMapping;
import annotation.AnnotationPostMapping;
import annotation.AnnotationRequestParam;
import annotation.AnnotationURL;
import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.City;
import model.Client;
import model.Flight;
import model.Plane;
import model.Reservation;
import model.SeatPrice;
import modelview.ModelView;
import service.ClientService;
import service.FlightService;
import session.Session;
import upload.FileUpload;

@AnnotationController(name = "front_office_controller")
public class FrontOfficeController {

    private Session session;
    private final String PATH;
    
    public FrontOfficeController() {

        // load .env file
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(".env")) {
            props.load(input);
            PATH = props.getProperty("IMG_FILE_PATH");
            if (PATH == null) {
                throw new RuntimeException("IMG_FILE_PATH not found in .env file");
            }
        } catch (IOException e) {
            throw new RuntimeException("Error loading .env file", e);
        }
    }
    
    @AnnotationGetMapping
    @AnnotationURL("/front_office_flights")
    public ModelView listFlight(
        @AnnotationRequestParam(name = "planeId") Integer planeId,
        @AnnotationRequestParam(name = "originCityId") Integer originCityId,
        @AnnotationRequestParam(name = "destinationCityId") Integer destinationCityId
    ) {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("front_office_flights.jsp");
            
            City[] cities = City.getAll(connection, City.class);
            Plane[] planes = Plane.getAll(connection, Plane.class);
            
            mv.add("cities", cities);
            mv.add("planes", planes);
            
            List<Criterion> criteria = new ArrayList<>();
            Flight[] flights;
            
            if (planeId != null) {
                criteria.add(new Criterion("id_plane", "=", planeId));
            }
            
            if (originCityId != null) {
                criteria.add(new Criterion("id_origin_city", "=", originCityId));
            }
            
            if (destinationCityId != null ) {
                criteria.add(new Criterion("id_destination_city", "=", destinationCityId));
            }
            
            if (!criteria.isEmpty()) {
                flights = Flight.findByCriteria(connection, Flight.class, 
                                               criteria.toArray(new Criterion[criteria.size()]));
            } else {
                flights = Flight.getAll(connection, Flight.class);
            }
            
            mv.add("flights", flights);
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/form_passport")
    public ModelView formPassport() {
        ModelView mv = new ModelView("upload-form.jsp");
        return mv;
    }

    @AnnotationPostMapping
    @AnnotationURL("/upload_passport")
    public ModelView uploadPassport(@AnnotationFileUpload("passport_image") FileUpload file) {
        ModelView mv = new ModelView("result-upload.jsp");

        // file type
        if (!file.getContentType().startsWith("image/")) {
            mv.add("error", "Only image files are allowed.");
            return mv;
        }

        try (Connection connection = new Database().getConnection()) {
            String relativePath = "uploads/" + UUID.randomUUID().toString() + "_" + file.getFileName();
            String savedPath = PATH + "/" + relativePath;
            file.saveToDirectory(PATH);

            // Update database
            int id = (int) session.get("connected_client");
            Client client = Client.findById(connection, Client.class, id);
            ClientService.savePassportImage(connection, client, relativePath);

            mv.add("img_path", savedPath);
            return mv;
        } catch (Exception e) {
            mv.add("error", "An unexpected error occurred. Please try again.");
            return mv;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL("/form_reservation")
    public ModelView formReservation() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("form-reservation.jsp");

            Flight[] flights = Flight.getAll(connection, Flight.class);
            String[] seatCategories = new String[] { "Economy", "Business", "First Class" };

            mv.add("flights", flights);
            mv.add("categories", seatCategories);

            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/list_reservation")
    public ModelView listReservation() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("list-reservation.jsp");
            int idClient = (int) session.get("connected_client");
            Client client = Client.findById(connection, Client.class, idClient);
            
            Reservation[] reservations = Reservation.findByCriteria(
                connection, 
                Reservation.class, 
                new Criterion("id_client", "=", client.getId())
            );

            mv.add("reservations", reservations);
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationPostMapping
    @AnnotationURL("/flight_reservation")
    public ModelView flightReservation(
        @AnnotationRequestParam(name = "flight") Integer idFlight,
        @AnnotationRequestParam(name = "seatCategorie") String categorie,
        @AnnotationRequestParam(name = "reservation_time") Timestamp reservationTime
    ) {
        try (Connection connection = new Database().getConnection()) {
            int idClient = (int) session.get("connected_client");
            Client client = Client.findById(connection, Client.class, idClient);

            Flight flight = Flight.findById(connection, Flight.class, idFlight);

            boolean isPromotional = FlightService.isSeatCategoryPromotional(connection, flight, categorie, reservationTime);

            String[] seatCategories = new String[] { "Economy", "Business", "First Class" };

            Map<String, SeatPrice> result = FlightService.calculateSeatPrices(connection, flight.getId(), seatCategories);

            result.forEach((category, seatPrice) -> {
                System.out.println("Category: " + category + ", SeatPrice: " + seatPrice);
            });

            Reservation reservation = new Reservation();

            reservation.setFlight(flight);
            reservation.setSeatCategory(categorie);
            reservation.setClient(client);
            reservation.setReservationTime(reservationTime);
            reservation.setIsPromotional(isPromotional);
            reservation.setPricePaid(new BigDecimal(result.get(categorie).getFinalPrice()));
            reservation.setIsCancelled(false);
            reservation.setCancellationTime(null);

            reservation.save(connection);
            return listReservation();   
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}