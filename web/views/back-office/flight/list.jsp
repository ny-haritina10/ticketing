<%@ page import="model.Flight" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.Timestamp" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Flight List</title>
</head>
<body>
    <h2>List of Flights</h2>
    <table border="2">
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
          </tr>
        </thead>
        <tbody>
          <% if (flights != null && flights.length > 0) { %>
            <% for (Flight flight : flights) { %>
              <tr>
                <td><%= flight.getId() %></td>
                <td><%= flight.getFlightNumber() %></td>
                <td><%= flight.getPlane() != null ? flight.getPlane().getModelName() : "N/A" %></td>
                <td><%= flight.getOriginCity() != null ? flight.getOriginCity().getCityName() : "N/A" %></td>
                <td><%= flight.getDestinationCity() != null ? flight.getDestinationCity().getCityName() : "N/A" %></td>
                <td><%= flight.getDepartureTime() != null ? flight.getDepartureTime().toString() : "N/A" %></td>
                <td><%= flight.getArrivalTime() != null ? flight.getArrivalTime().toString() : "N/A" %></td>
                <td><%= flight.getReservationDeadlineHours() != null ? flight.getReservationDeadlineHours() : "N/A" %></td>
                <td><%= flight.getCancellationDeadlineHours() != null ? flight.getCancellationDeadlineHours() : "N/A" %></td>
              </tr>
            <% } %>
          <% } else { %>
            <tr>
                <td colspan="9">No flights available</td>
            </tr>
          <% } %>
        </tbody>
    </table>
  </body>
</html>