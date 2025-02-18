package controller;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationRequestParam;
import annotation.AnnotationURL;
import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.City;
import model.Flight;
import model.Plane;
import modelview.ModelView;

@AnnotationController(name = "front_office_controller")
public class FrontOfficeController {
    
    @AnnotationGetMapping
    @AnnotationURL("/front_office_flights")
    public ModelView listFlight(
        @AnnotationRequestParam(name = "planeId") Integer planeId,
        @AnnotationRequestParam(name = "originCityId") Integer originCityId,
        @AnnotationRequestParam(name = "destinationCityId") Integer destinationCityId
    ) {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("front_office_flights.jsp");
            
            // Get all cities and planes for the dropdowns
            City[] cities = City.getAll(connection, City.class);
            Plane[] planes = Plane.getAll(connection, Plane.class);
            
            mv.add("cities", cities);
            mv.add("planes", planes);
            
            // Process search criteria
            List<Criterion> criteria = new ArrayList<>();
            Flight[] flights;
            
            // 1. Plane filter
            if (planeId != null) {
                criteria.add(new Criterion("id_plane", "=", planeId));
            }
            
            // 2. Origin City filter
            if (originCityId != null) {
                criteria.add(new Criterion("id_origin_city", "=", originCityId));
            }
            
            // 3. Destination City filter
            if (destinationCityId != null ) {
                criteria.add(new Criterion("id_destination_city", "=", destinationCityId));
            }
            
            // Execute search if criteria exist, otherwise get all flights
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
}