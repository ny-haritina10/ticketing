<%@ page import="model.*" %>
<%@ page import="java.util.Map, java.util.List, engine.ValidationResult" %>


<%
  Plane[] planes = (Plane[]) request.getAttribute("planes");
  City[] cities = (City[]) request.getAttribute("cities");

  ValidationResult errors = (ValidationResult) request.getAttribute("validationErrors");
%>

<h2>Flight Insertion</h2>

<form action="insert" method="post">
  <p>Plane: </p>
  <select name="plane" id="plane">
    <% for (Plane plane : planes) { %>
      <option value="<%= plane.getId() %>"><%= plane.getModelName() %></option>
    <% } %>
  </select>
  <br>

  <p>Origin City</p>
  <select name="originCity" id="originCity">
    <% for (City city : cities) { %>
      <option value="<%= city.getId() %>"><%= city.getCityName() %> - <%= city.getCountry() %></option>
    <% } %>
  </select>
  <br>

  <p>Destination City</p>
  <select name="destinationCity" id="destinationCity">
    <% for (City city : cities) { %>
      <option value="<%= city.getId() %>"><%= city.getCityName() %> - <%= city.getCountry() %></option>
    <% } %>
  </select>
  <br>

  <p>Departure Time</p>
  <input type="datetime-local" name="departureTime">
  <% if (errors != null && errors.getErrors().get("departureTime") != null) { %>
    <p style="color: red;">
        <%= errors.getErrors().get("departureTime") %>
    </p>
  <% } %>

  <p>Arrival Time</p>
  <input type="datetime-local" name="arrivalTime">

  <p>Reservation dead line hours</p>
  <input type="number" value="3" name="reservationDeadlineHours">
  
  <p>Cancellation Deadline Hours</p>
  <input type="number" value="24" name="cancellationDeadlineHours">

  <input type="submit" value="Create">
</form>