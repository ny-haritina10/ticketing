package controller;

import java.sql.Connection;

import annotation.Controller;
import annotation.Get;
import annotation.RestAPI;
import annotation.Url;
import database.Database;
import model.Flight;
import modelview.ModelView;

@Controller(name = "api_endpoint")
public class ApiEndpoint {
    
    @Get
    @Url("/api")
    @RestAPI
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