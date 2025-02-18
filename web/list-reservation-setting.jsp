<%@ page import="model.*" %>

<%
  FlightReservation[] reservations = (FlightReservation[]) request.getAttribute("reservations");
%>

<h2>Reservation settings</h2> <br>

<% if (reservations != null && reservations.length > 0) { %>
  <table border="1" class="table">
    <thead>
      <tr>
        <th>Flight Number</th>
        <th>Route</th>
        <th>Reservation Hours Allowed</th>
        <th>Annulation Hours Allowed</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% for (FlightReservation reservation : reservations) { %>
        <tr>
          <td><%= reservation.getFlight().getFlightNumber() %></td>
          <td>
            <%= reservation.getFlight().getOriginCity().getCityName() %> - 
            <%= reservation.getFlight().getDestinationCity().getCityName() %>
          </td>
          <td><%= reservation.getReservationHourAllowed() %> hours</td>
          <td><%= reservation.getAnnulationHourAllowed() %> hours</td>
          <td>
            <a href="delete_reservation_setting?id=<%= reservation.getId() %>" 
               onclick="return confirm('Are you sure you want to delete this reservation setting?')"
               style="background-color: #dc3545; color: white; padding: 0.3rem 0.6rem; border-radius: 4px; border: none; cursor: pointer; font-size: 0.9rem; text-decoration: none;">
               Delete</a>
          </td>
        </tr>
      <% } %>
    </tbody>
  </table>
<% } else { %>
  <p>No reservation settings found.</p>
<% } %>

<br>
<div>
  <a href="form_reservation_setting" style="background-color: var(--primary-color); color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none; transition: var(--transition);">Add New Reservation Setting</a>
</div>