<%@ page import="model.Flight" %>
<%@ page import="model.FlightPrice" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  Flight flight = (Flight) request.getAttribute("flight");
  FlightPrice[] prices = (FlightPrice[]) request.getAttribute("prices");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<div class="header">
  <h1>Flight Details</h1>
  <a href="list" style="background-color: #6c757d; color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none; transition: var(--transition);">Back to Flight List</a>
</div>

<% if (flight != null) { %>
<div class="content-body">
  <!-- Flight Header -->
  <div style="background-color: var(--primary-color); color: white; padding: 1rem; border-radius: 8px 8px 0 0; margin-bottom: 1.5rem;">
    <h2 style="margin: 0;">Flight <%= flight.getFlightNumber() %></h2>
  </div>

  <!-- Combined Information Table -->
  <div class="table-container" style="margin-bottom: 1.5rem;">
    <table style="width: 100%; table-layout: fixed;">
      <tr>
        <th style="width: 200px;">ID</th>
        <td><%= flight.getId() %></td>
      </tr>
      <tr>
        <th>Flight Number</th>
        <td><%= flight.getFlightNumber() %></td>
      </tr>
      <tr>
        <th>Plane</th>
        <td><%= flight.getPlane().getModelName() %></td>
      </tr>
      <tr>
        <th>Route</th>
        <td><%= flight.getOriginCity().getCityName() %> to <%= flight.getDestinationCity().getCityName() %></td>
      </tr>
      <tr>
        <th>Departure Time</th>
        <td><%= dateFormat.format(flight.getDepartureTime()) %></td>
      </tr>
      <tr>
        <th>Arrival Time</th>
        <td><%= dateFormat.format(flight.getArrivalTime()) %></td>
      </tr>
      <tr>
        <th>Flight Duration</th>
        <td>
          <% 
            long durationMillis = flight.getArrivalTime().getTime() - flight.getDepartureTime().getTime();
            long hours = durationMillis / (60 * 60 * 1000);
            long minutes = (durationMillis % (60 * 60 * 1000)) / (60 * 1000);
          %>
          <%= hours %>h <%= minutes %>m
        </td>
      </tr>
      <tr>
        <th>Reservation Deadline</th>
        <td><%= flight.getReservationDeadlineHours() %> hours before departure</td>
      </tr>
      <tr>
        <th>Cancellation Deadline</th>
        <td><%= flight.getCancellationDeadlineHours() %> hours before departure</td>
      </tr>

      <% if (prices != null && prices.length > 0) { %>
        <tr>
          <th colspan="2" style="text-align: center; background-color: rgba(0,0,0,0.03); padding: 0.5rem 0;">Price Information</th>
        </tr>
        <% for (FlightPrice price : prices) { %>
        <tr>
          <th><%= price.getCategory() %> Price</th>
          <td><%= price.getBasePrice() %></td>
        </tr>
        <% } %>
      <% } %>
    </table>
  </div>

  <!-- Actions -->
  <div style="padding: 1rem; border-top: 1px solid rgba(0,0,0,0.1); display: flex; justify-content: flex-end; gap: 0.5rem;">
    <a href="edit?id=<%= flight.getId() %>" style="background-color: #ffc107; color: #212529; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none;">Edit Flight</a>
    <a href="configure?id=<%= flight.getId() %>" style="background-color: var(--primary-color); color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none;">Configure Prices</a>
    <button onclick="confirmDelete('<%= flight.getId() %>', '<%= flight.getFlightNumber() %>')" style="background-color: #dc3545; color: white; padding: 0.5rem 1rem; border-radius: 4px; border: none; cursor: pointer;">Delete Flight</button>
  </div>
</div>
<% } else { %>
<div class="content-body">
  <div style="background-color: #f8d7da; color: #721c24; padding: 1rem; border-radius: 4px; border: 1px solid #f5c6cb;">
    Flight not found.
  </div>
</div>
<% } %>

<!-- Delete Confirmation Modal (same as in list-flight.jsp) -->
<div id="deleteModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
  <div style="background-color: white; width: 400px; max-width: 90%; border-radius: 8px; box-shadow: var(--shadow); padding: 1.5rem;">
    <h3 style="margin-bottom: 1rem;">Confirm Deletion</h3>
    <p style="margin-bottom: 1.5rem;">Are you sure you want to delete flight <span id="flightNumberToDelete"></span>?</p>
    <div style="display: flex; justify-content: flex-end;">
      <button onclick="hideDeleteModal()" style="background-color: #6c757d; color: white; padding: 0.5rem 1rem; border-radius: 4px; border: none; cursor: pointer; margin-right: 0.5rem;">Cancel</button>
      <a id="confirmDeleteBtn" href="#" style="background-color: #dc3545; color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none;">Delete</a>
    </div>
  </div>
</div>

<script>
  function confirmDelete(id, flightNumber) {
    document.getElementById('flightNumberToDelete').textContent = flightNumber;
    document.getElementById('confirmDeleteBtn').href = 'delete?id=' + id;
    document.getElementById('deleteModal').style.display = 'flex';
  }
  
  function hideDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
  }
  
  // Close modal when clicking outside
  window.onclick = function(event) {
    var modal = document.getElementById('deleteModal');
    if (event.target == modal) {
      modal.style.display = 'none';
    }
  }
</script>