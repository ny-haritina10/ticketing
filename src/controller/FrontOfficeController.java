package controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
import modelview.ModelView;
import service.ClientService;
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
}