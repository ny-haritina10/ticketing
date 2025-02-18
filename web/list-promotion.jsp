<%@ page import="model.*" %>

<%
  FlightPromotion[] promotions = (FlightPromotion[]) request.getAttribute("promotions");
%>

<h2>Flight Promotions List</h2> <br>

<% if (promotions != null && promotions.length > 0) { %>
  <table border="1" class="table">
    <thead>
      <tr>
        <th>Flight Number</th>
        <th>Route</th>
        <th>Category</th>
        <th>Discount (%)</th>
        <th>Seats Available</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% for (FlightPromotion promotion : promotions) { %>
        <tr>
          <td><%= promotion.getFlight().getFlightNumber() %></td>
          <td>
            <%= promotion.getFlight().getOriginCity().getCityName() %> - 
            <%= promotion.getFlight().getDestinationCity().getCityName() %>
          </td>
          <td><%= promotion.getCategory() %></td>
          <td><%= promotion.getDiscountPercentage() %>%</td>
          <td><%= promotion.getSeatsAvailable() %></td>
          <td>
            <a href="delete_promotion?id=<%= promotion.getId() %>" 
               onclick="return confirm('Are you sure you want to delete this promotion?')"
               style="background-color: #dc3545; color: white; padding: 0.3rem 0.6rem; border-radius: 4px; border: none; cursor: pointer; font-size: 0.9rem; text-decoration: none;"
               >
              Delete</a>
          </td>
        </tr>
      <% } %>
    </tbody>
  </table>
<% } else { %>
  <p>No promotions found.</p>
<% } %>

<br>
<div>
  <a href="form_promotion" style="background-color: var(--primary-color); color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none; transition: var(--transition);" >Add New Promotion</a>
</div>