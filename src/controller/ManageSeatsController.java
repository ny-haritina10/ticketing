package controller;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import annotation.Controller;
import annotation.Get;
import annotation.Post;
import annotation.RequestParam;
import annotation.Url;
import database.Database;
import modelview.ModelView;
import service.PromotionalSeatsService;

@Controller(name = "manage_seats_controller")
public class ManageSeatsController {

    private static final String MAIN_TEMPLATE = "main.jsp";
    @Get
    @Url("/manage_seat_form")
    public ModelView showManageSeatsForm() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            List<Map<String, Object>> unbookedSeatsSummary = PromotionalSeatsService.getUnbookedSeatsSummary(connection);
            
            mv.add("unbookedSeatsSummary", unbookedSeatsSummary);
            mv.add("activePage", "manage_seats");
            mv.add("contentPage", "manage-unbooked-seats.jsp");
            mv.add("pageTitle", "Manage Unbooked Seats");
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            return createErrorView("Error loading manage seats form: " + e.getMessage());
        }
    }

    @Post
    @Url("/process")
    public ModelView processUnbookedSeats(
            @RequestParam(name = "targetDate") String targetDateStr) {
        
        try (Connection connection = new Database().getConnection()) {
            
            if (targetDateStr == null || targetDateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Target date is required");
            }
            
            LocalDate localDate = LocalDate.parse(targetDateStr);
            Date targetDate = Date.valueOf(localDate);
            
            
            PromotionalSeatsService.gererSiege(connection, targetDate);
            
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            List<Map<String, Object>> unbookedSeatsSummary = PromotionalSeatsService.getUnbookedSeatsSummary(connection);
            
            mv.add("unbookedSeatsSummary", unbookedSeatsSummary);
            mv.add("successMessage", "Successfully processed unbooked seats for date: " + targetDate);
            mv.add("activePage", "manage_seats");
            mv.add("contentPage", "manage-unbooked-seats.jsp");
            mv.add("pageTitle", "Manage Unbooked Seats");
            
            return mv;
            
        } catch (IllegalArgumentException e) {
            return createErrorView("Invalid input: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return createErrorView("Error processing unbooked seats: " + e.getMessage());
        }
    }

    /**
     * Get statistics about unbooked seats
     */
    @Get
    @Url("/stats_seat")
    public ModelView getUnbookedSeatsStats() {
        try (Connection connection = new Database().getConnection()) {
            ModelView mv = new ModelView(MAIN_TEMPLATE);
            
            // Get detailed statistics
            String statsQuery = """
                SELECT 
                    COUNT(*) as total_entries,
                    SUM(seats_count) as total_unbooked_seats,
                    COUNT(DISTINCT id_flight) as affected_flights,
                    COUNT(DISTINCT category) as affected_categories
                FROM unbooked_promotional_seats
            """;
            
            try (var stmt = connection.prepareStatement(statsQuery);
                 var rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    mv.add("totalEntries", rs.getInt("total_entries"));
                    mv.add("totalUnbookedSeats", rs.getInt("total_unbooked_seats"));
                    mv.add("affectedFlights", rs.getInt("affected_flights"));
                    mv.add("affectedCategories", rs.getInt("affected_categories"));
                }
            }
            
            List<Map<String, Object>> unbookedSeatsSummary = PromotionalSeatsService.getUnbookedSeatsSummary(connection);
            mv.add("unbookedSeatsSummary", unbookedSeatsSummary);
            
            mv.add("activePage", "manage_seats");
            mv.add("contentPage", "unbooked-seats-stats.jsp");
            mv.add("pageTitle", "Unbooked Seats Statistics");
            
            return mv;
            
        } catch (Exception e) {
            e.printStackTrace();
            return createErrorView("Error loading unbooked seats statistics: " + e.getMessage());
        }
    }

    /**
     * Helper method to create error views
     */
    private ModelView createErrorView(String errorMessage) {
        ModelView mv = new ModelView(MAIN_TEMPLATE);
        mv.add("errorMessage", errorMessage);
        mv.add("activePage", "manage_seats");
        mv.add("contentPage", "error.jsp");
        mv.add("pageTitle", "Error");
        return mv;
    }
}