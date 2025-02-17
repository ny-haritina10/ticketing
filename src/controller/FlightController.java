package controller;

import java.sql.Connection;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationURL;
import database.Database;
import model.City;
import model.Flight;
import model.Plane;
import modelview.ModelView;

import java.util.UUID;

@AnnotationController(name = "flight_controller")
public class FlightController {

    private static final String URL_PREFIX = "/admin/flights/";
    private static final String VIEW_PATH = "/views/back-office/flight/";

    @AnnotationGetMapping
    @AnnotationURL(URL_PREFIX + "form")
    public ModelView redirectToForm() {
        try (Connection connection = new Database().getConnection()){
            String viewPath = VIEW_PATH + "form.jsp";            
            ModelView mv = new ModelView(viewPath);
            
            City[] cities = City.getAll(connection, City.class);
            Plane[] planes = Plane.getAll(connection, Plane.class);

            mv.add("cities", cities);
            mv.add("planes", planes);

            return mv;
        } 
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
            return null;
        }
    }


    @AnnotationPostMapping
    @AnnotationURL(URL_PREFIX + "insert")
    public ModelView insert(@AnnotationModelAttribute("flight") Flight flight) {
        try (Connection connection = new Database().getConnection()){
            ModelView mv = new ModelView(VIEW_PATH + "list.jsp");

            String uuid = UUID.randomUUID().toString().replace("-", "");
            flight.setFlightNumber(uuid.substring(1, uuid.length() - 20));
            flight.save(connection);

            Flight[] flights = Flight.getAll(connection, Flight.class);
            mv.add("flights", flights);

            return mv;    
        } 
        
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
            return null;
        }
    }

    @AnnotationGetMapping
    @AnnotationURL(URL_PREFIX + "list")
    public ModelView list() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView(VIEW_PATH + "list.jsp");
            Flight[] flights = Flight.getAll(connection, Flight.class);

            mv.add("flights", flights);
            return mv;
        } 
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
            return null;
        }
    }
}