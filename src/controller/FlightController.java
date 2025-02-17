package controller;

import java.sql.Connection;
import java.util.UUID;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationRequestParam;
import annotation.AnnotationURL;

import database.Database;

import model.City;
import model.Flight;
import model.Plane;

import modelview.ModelView;

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
    public ModelView insert(@AnnotationModelAttribute("flight") Flight flight) {
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
}