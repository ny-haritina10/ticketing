<%@ page import="model.*" %>

<%
  Flight flight = (Flight) request.getAttribute("flight");
  String[] seatCategories = new String[] { "Economy", "Business", "FirstClass" };
%>

<h3>Flight number: <%= flight.getFlightNumber() %></h3>

<form action="configure_flight_price" method="post">
  <input type="hidden" name="id" value="<%= flight.getId() %>">

  <%for (String category : seatCategories) {%>
    <p><%= category %> Price</p>
    <input type="text" name="<%= category %>_price"> <br>
  <%}%>

  <input type="submit" value="Submit">
</form>