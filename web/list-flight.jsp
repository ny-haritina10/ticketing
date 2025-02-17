<%@ page import="model.Flight" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.Timestamp" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
%>

<h2>List of Flights</h2>
<table border="1">
  <thead>
    <tr>
      <th>ID</th> 
      <th>Flight Number</th>
      <th>Plane</th>
      <th>Origin City</th>
      <th>Destination City</th>
      <th>Departure Time</th>
      <th>Arrival Time</th>
      <th>Reservation Deadline (Hours)</th>
      <th>Cancellation Deadline (Hours)</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <% if (flights != null && flights.length > 0) { %>
      <% for (Flight flight : flights) { %>
        <tr>
          <td><%= flight.getId() %></td>
          <td><%= flight.getFlightNumber() %></td>
          <td><%= flight.getPlane().getModelName() %></td>
          <td><%= flight.getOriginCity().getCityName() %></td>
          <td><%= flight.getDestinationCity().getCityName() %></td>
          <td><%= flight.getDepartureTime() %></td>
          <td><%= flight.getArrivalTime() %></td>
          <td><%= flight.getReservationDeadlineHours() %></td>
          <td><%= flight.getCancellationDeadlineHours() %></td>
          <td>
            <a href="edit?id=<%= flight.getId() %>">Edit</a>
            <a href="delete?id=<%= flight.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
          </td>
        </tr>
      <% } %>
    <% } else { %>
      <tr>
        <td colspan="10">No flights available</td>
      </tr>
    <% } %>
  </tbody>        
</table>