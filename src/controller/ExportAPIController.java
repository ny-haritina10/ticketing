package controller;

import java.sql.Connection;
import java.text.SimpleDateFormat;

import annotation.Url;
import annotation.Controller;
import annotation.Get;
import annotation.RequestParam;
import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.Flight;
import model.FlightPrice;
import modelview.ModelView;

@Controller(name = "export_api_controller")
public class ExportAPIController {

    @Get
    @Url("/api/export")
    public ModelView exportToPDF(@RequestParam(name = "id") Integer id) {
        try (Connection connection = new Database().getConnection()) {
            // Get flight data
            Flight flight = Flight.findById(connection, Flight.class, id);
            
            if (flight == null) {
                ModelView errorMv = new ModelView("error.jsp");
                errorMv.add("errorMessage", "Flight not found with ID: " + id);
                return errorMv;
            }
            
            // Get flight prices
            FlightPrice[] prices = FlightPrice.findByCriteria(
                connection, 
                FlightPrice.class,
                new Criterion("id_flight", "=", id)
            );
            
            // Generate simple PDF content as HTML (you can use libraries like iText for real PDF)
            String pdfContent = generatePDFContent(flight, prices);
            byte[] pdfData = pdfContent.getBytes("UTF-8");
            
            // Return PDF download view
            ModelView mv = new ModelView("pdf-download.jsp");
            mv.add("pdfData", pdfData);
            mv.add("fileName", "flight_" + id + ".pdf");
            
            return mv;
            
        } catch (Exception e) {
            e.printStackTrace();
            ModelView errorMv = new ModelView("error.jsp");
            errorMv.add("errorMessage", "Error generating PDF: " + e.getMessage());
            return errorMv;
        }
    }
    
    private String generatePDFContent(Flight flight, FlightPrice[] prices) {
        StringBuilder content = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        
        content.append("FLIGHT INFORMATION REPORT\n");
        content.append("========================\n\n");
        content.append("Flight Number: ").append(flight.getFlightNumber()).append("\n");
        content.append("Route: ").append(flight.getOriginCity().getCityName())
               .append(" to ").append(flight.getDestinationCity().getCityName()).append("\n");
        content.append("Departure: ").append(dateFormat.format(flight.getDepartureTime())).append("\n");
        content.append("Arrival: ").append(dateFormat.format(flight.getArrivalTime())).append("\n");
        content.append("Aircraft: ").append(flight.getPlane().getModelName()).append("\n\n");
        
        if (prices != null && prices.length > 0) {
            content.append("PRICING INFORMATION\n");
            content.append("===================\n");
            for (FlightPrice price : prices) {
                content.append(price.getCategory()).append(": $")
                       .append(price.getBasePrice()).append("\n");
            }
        }
        
        return content.toString();
    }
}