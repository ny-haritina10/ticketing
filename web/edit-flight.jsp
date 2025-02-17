<%@ page import="model.Flight" %>
<%@ page import="model.City" %>
<%@ page import="model.Plane" %>
<%
  Flight flight = (Flight) request.getAttribute("flight");
  City[] cities = (City[]) request.getAttribute("cities");
  Plane[] planes = (Plane[]) request.getAttribute("planes");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Flight</title>
</head>
<body>
  <h1>Edit Flight</h1>

  <form action="update" method="post">
    <input type="hidden" name="id" value="<%= flight.getId() %>">

    <p>Flight Number:</p>
    <input type="text" name="flightNumber" value="<%= flight.getFlightNumber() %>" readonly>

    <p>Plane: </p>
    <select name="plane">
      <% for (Plane plane : planes) { %>
        <option value="<%= plane.getId() %>" <%= plane.getId().equals(flight.getPlane().getId()) ? "selected" : "" %>><%= plane.getModelName() %></option>
      <% } %>
    </select>

    <p>Origin City</p>
    <select name="originCity">
      <% for (City city : cities) { %>
        <option value="<%= city.getId() %>" <%= city.getId().equals(flight.getOriginCity().getId()) ? "selected" : "" %>><%= city.getCityName() %></option>
      <% } %>
    </select>

    <p>Destination City</p>
    <select name="destinationCity">
      <% for (City city : cities) { %>
        <option value="<%= city.getId() %>" <%= city.getId().equals(flight.getDestinationCity().getId()) ? "selected" : "" %>><%= city.getCityName() %></option>
      <% } %>
    </select>

    <p>Departure Time</p>
    <input type="datetime-local" name="departureTime" value="<%= flight.getDepartureTime() %>">

    <p>Arrival Time</p>
    <input type="datetime-local" name="arrivalTime" value="<%= flight.getArrivalTime() %>">

    <p>Reservation Deadline Hours</p>
    <input type="number" name="reservationDeadlineHours" value="<%= flight.getReservationDeadlineHours() %>">

    <p>Cancellation Deadline Hours</p>
    <input type="number" name="cancellationDeadlineHours" value="<%= flight.getCancellationDeadlineHours() %>">

    <input type="submit" value="Update">
  </form>
</body>
</html>