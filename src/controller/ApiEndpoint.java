package controller;

import java.sql.Connection;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationRestAPI;
import annotation.AnnotationURL;
import database.Database;
import model.Flight;
import modelview.ModelView;

@AnnotationController(name = "api_endpoint")
public class ApiEndpoint {
    
    @AnnotationGetMapping
    @AnnotationURL("/api")
    @AnnotationRestAPI
    public ModelView api() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView("test.jsp");
            Flight[] flights = Flight.getAll(connection, Flight.class);

            mv.add("flights", flights);
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}