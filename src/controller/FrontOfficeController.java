package controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import annotation.Controller;
import annotation.Get;
import annotation.Post;
import annotation.RequestParam;
import annotation.Upload;
import annotation.Url;
import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.City;
import model.Client;
import model.Flight;
import model.Plane;
import model.Reservation;
import model.ReservationDetail;
import model.SeatPrice;
import modelview.ModelView;
import service.ClientService;
import service.FlightService;
import session.Session;
import upload.FileUpload;

@Controller(name = "front_office_controller")
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
    
    @Get
    @Url("/front_office_flights")
    public ModelView listFlight(
        @RequestParam(name = "planeId") Integer planeId,
        @RequestParam(name = "originCityId") Integer originCityId,
        @RequestParam(name = "destinationCityId") Integer destinationCityId
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

    @Get
    @Url("/form_passport")
    public ModelView formPassport() {
        ModelView mv = new ModelView("upload-form.jsp");
        return mv;
    }

    @Post
    @Url("/upload_passport")
    public ModelView uploadPassport(@Upload("passport_image") FileUpload file) {
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

    @Get
    @Url("/form_reservation")
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

    @Get
    @Url("/list_reservation")
    public ModelView listReservation() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("list-reservation.jsp");
            int idClient = (int) session.get("connected_client");
            Client client = Client.findById(connection, Client.class, idClient);
            
            // Get all reservations for the client
            Reservation[] reservations = Reservation.findByCriteria(
                connection, 
                Reservation.class, 
                new Criterion("id_client", "=", client.getId())
            );

            // For each reservation, get its details
            Map<Reservation, ReservationDetail[]> reservationDetails = new HashMap<>();
            for (Reservation reservation : reservations) {
                ReservationDetail[] details = ReservationDetail.findByCriteria(
                    connection,
                    ReservationDetail.class,
                    new Criterion("id_reservation", "=", reservation.getId())
                );
                reservationDetails.put(reservation, details);
            }

            mv.add("reservations", reservations);
            mv.add("reservationDetails", reservationDetails);
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Post
    @Url("/flight_reservation")
    public ModelView flightReservation(
        @RequestParam(name = "flight") Integer idFlight,
        @RequestParam(name = "seatCategorie") String categorie,
        @RequestParam(name = "reservation_time") Timestamp reservationTime,
        @RequestParam(name = "nbr_billet_total") Integer nbrBilletTotal,
        @RequestParam(name = "nbr_billet_enfant") Integer nbrBilletEnfant,
        @RequestParam(name = "nbr_billet_adulte") Integer nbrBilletAdulte,
        @RequestParam(name = "name_voyageur") String nameVoyageur,
        @RequestParam(name = "dtn_voyageur") Date dtnVoyageur,
        @Upload("passport_image") FileUpload passportFile
    ) {
        try (Connection connection = new Database().getConnection()) {
            int idClient = (int) session.get("connected_client");
            Client client = Client.findById(connection, Client.class, idClient);
            Flight flight = Flight.findById(connection, Flight.class, idFlight);

            // Create main reservation
            Reservation reservation = new Reservation();
            reservation.setFlight(flight);
            reservation.setClient(client);
            reservation.setReservationTime(reservationTime);
            reservation.setNbrBilletTotal(1);
            reservation.setNbrBilletEnfant(0);
            reservation.setNbrBilletAdulte(1);
            reservation.setPaymentStatus("pending");
            reservation.save(connection);

            String relativePath = "uploads/" + UUID.randomUUID().toString() + "_" + passportFile.getFileName();
            passportFile.saveToDirectory(PATH);

            boolean isPromotional = FlightService.isSeatCategoryPromotional(connection, flight, categorie, reservationTime);
            
            Map<String, SeatPrice> prices = FlightService.calculateSeatPrices(connection, flight.getId(), new String[] { categorie });
            double finalPrice = prices.get(categorie).getFinalPrice();

            ReservationDetail detail = new ReservationDetail();
            int idRes = Reservation.getLastInserted(connection, Reservation.class).getId();
            reservation.setId(idRes);
            
            detail.setReservation(reservation);
            detail.setSeatCategory(categorie);
            detail.setNameVoyageur(nameVoyageur);
            detail.setDtnVoyageur(dtnVoyageur);
            detail.setPassportImage(relativePath);
            detail.setPrice(new BigDecimal(finalPrice));
            detail.setIsPromotional(isPromotional); // Set this correctly
            detail.setIsCancel(false);
            detail.setCancellationTime(null);

            detail.save(connection);

            return listReservation();   
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Post
    @Url("/pay_reservation")
    public ModelView payReservation(@RequestParam(name = "reservationId") Integer reservationId) {
        try (Connection connection = new Database().getConnection()) {
            Reservation reservation = Reservation.findById(connection, Reservation.class, reservationId);

            if (reservation != null) {
                reservation.setPaymentStatus("paid");
                reservation.setPaymentTime(new Timestamp(System.currentTimeMillis()));
                
                reservation.update(connection);
            } else {
                System.out.println("Payment failed: Reservation with ID " + reservationId + " not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return listReservation();
    }
}


// mi annuler res non paye au deal date butoire
// leh res annulle 
    // if meme vol, meme cat le lendemain
        // cumulena any leh siege