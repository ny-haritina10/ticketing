<%@ page import="model.*" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
%>

<h2>Flight Promotion Insertion</h2>

<form action="insert_promotion" method="post">
  <p>Flight: </p>
  <select name="flight" id="flight" required>
    <% for (Flight flight : flights) { %>
      <option value="<%= flight.getId() %>">
        <%= flight.getFlightNumber() %> 
        (<%= flight.getOriginCity().getCityName() %> - <%= flight.getDestinationCity().getCityName() %>)
      </option>
    <% } %>
  </select>
  <br>

  <p>Category:</p>
  <select name="category" id="category" required>
    <option value="Economy">Economy</option>
    <option value="Business">Business</option>
    <option value="First Class">First Class</option>
  </select>
  <br>

  <p>Discount Percentage (%):</p>
  <input type="number" name="discountPercentage" id="discountPercentage" required>
  <br>

  <p>Seats Available:</p>
  <input type="number" name="seatsAvailable" id="seatsAvailable" required>
  <br>

  <input type="submit" value="Create Promotion">
</form>