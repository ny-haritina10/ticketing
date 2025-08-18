<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Map<String, Object>> unbookedSeatsSummary = (List<Map<String, Object>>) request.getAttribute("unbookedSeatsSummary");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String todayDate = dateFormat.format(new java.util.Date());
%>

<h2>Gestion des reservations impayer</h2>

    <form action="process" method="post">
        <div class="form-group">
            <label for="targetDate">Process promotions up to date:</label>
            <input type="date" 
                    name="targetDate" 
                    id="targetDate" 
                    required>
        </div>
        
        <button type="submit" class="btn btn-primary">
            Valider
        </button>
    </form>

<br>
<br>
<!-- Current Unbooked Seats Summary -->
<h3>Reservation impayer</h3>

<% if (unbookedSeatsSummary != null && !unbookedSeatsSummary.isEmpty()) { %>
    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Flight Number</th>
                    <th>Route</th>
                    <th>Category</th>
                    <th>Unbooked Seats</th>
                    <th>Original Promotion Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> seat : unbookedSeatsSummary) { %>
                    <tr>
                        <td><%= seat.get("flightNumber") %></td>
                        <td><%= seat.get("originCity") %> → <%= seat.get("destinationCity") %></td>
                        <td><%= seat.get("category") %></td>
                        <td><%= seat.get("seatsCount") %></td>
                        <td><%= seat.get("originalPromotionDate") %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
<% } else { %>
    <div class="no-data">
        <p>Pas de reservation impayer</p>
    </div>
<% } %>