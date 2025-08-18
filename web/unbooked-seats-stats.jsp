<%@ page import="java.util.*" %>

<%
    List<Map<String, Object>> unbookedSeatsSummary = (List<Map<String, Object>>) request.getAttribute("unbookedSeatsSummary");
    Integer totalEntries = (Integer) request.getAttribute("totalEntries");
    Integer totalUnbookedSeats = (Integer) request.getAttribute("totalUnbookedSeats");
    Integer affectedFlights = (Integer) request.getAttribute("affectedFlights");
    Integer affectedCategories = (Integer) request.getAttribute("affectedCategories");
%>

    <h2>Unbooked Seats Statistics</h2>
    
    
    <h3><%= totalEntries != null ? totalEntries : 0 %></h3>
    <p>Total Entries</p>
    <h3><%= totalUnbookedSeats != null ? totalUnbookedSeats : 0 %></h3>
    <h3><%= affectedFlights != null ? affectedFlights : 0 %></h3>
    <p>Affected Flights</p>
    <h3><%= affectedCategories != null ? affectedCategories : 0 %></h3>
    <p>Seat Categories</p>
    
    <!-- Detailed Breakdown -->
        <h3>Detailed Breakdown</h3>
        
        <% if (unbookedSeatsSummary != null && !unbookedSeatsSummary.isEmpty()) { %>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Flight Number</th>
                        <th>Route</th>
                        <th>Category</th>
                        <th>Unbooked Seats</th>
                        <th>Original Promotion Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> seat : unbookedSeatsSummary) { %>
                        <tr>
                            <td><%= seat.get("flightNumber") %></td>
                            <td>
                                <span class="route">
                                    <%= seat.get("originCity") %> 
                                    <span class="arrow">→</span> 
                                    <%= seat.get("destinationCity") %>
                                </span>
                            </td>
                            <td>
                                <span class="category-badge category-<%= seat.get("category").toString().toLowerCase().replace(" ", "-") %>">
                                    <%= seat.get("category") %>
                                </span>
                            </td>
                            <td>
                                <span class="seats-count"><%= seat.get("seatsCount") %></span>
                            </td>
                            <td><%= seat.get("originalPromotionDate") %></td>
                            <td>
                                <span class="status-badge status-pending">Awaiting Future Promotion</span>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="no-data">
                <div class="no-data-icon">✅</div>
                <h4>No Unbooked Seats</h4>
                <p>All promotional seats have been successfully booked or processed!</p>
            </div>
        <% } %>
</div>