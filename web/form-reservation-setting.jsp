<%@ page import="model.*" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
%>

<form action="insert_reservation_setting" method="post">
  <p>Flight: </p>
  <select name="flight.id" id="flight" required>
    <% for (Flight flight : flights) { %>
      <option value="<%= flight.getId() %>">
        <%= flight.getFlightNumber() %> 
        (<%= flight.getOriginCity().getCityName() %> - <%= flight.getDestinationCity().getCityName() %>)
      </option>
    <% } %>
  </select>
  <br>

  <p>Reservation Hours Allowed:</p>
  <input type="number" name="reservationHourAllowed" id="reservationHourAllowed" min="1" required>
  <p class="helper-text">Number of hours before departure that reservations are allowed</p>
  <br>

  <p>Annulation Hours Allowed:</p>
  <input type="number" name="annulationHourAllowed" id="annulationHourAllowed" min="1" required>
  <p class="helper-text">Number of hours allowed to cancel that reservation</p>
  <br>

  <input type="submit" value="Create Reservation Setting">
</form>