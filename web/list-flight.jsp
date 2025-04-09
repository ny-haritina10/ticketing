<%@ page import="model.Flight" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<div class="header">
  <h1>Flight Management</h1>
  <a href="form" style="background-color: var(--primary-color); color: white; padding: 0.5rem 1rem; border-radius: 4px; text-decoration: none; transition: var(--transition);">Add New Flight</a>
</div>

<div class="content-body">
  <div class="table-container">
    <table class="sticky-last">
      <thead>
        <tr>
          <th>Flight Number</th>
          <th>Route</th>
          <th>Departure</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% if (flights != null && flights.length > 0) { %>
          <% for (Flight flight : flights) { %>
            <tr>
              <td><%= flight.getFlightNumber() %></td>
              <td><%= flight.getOriginCity().getCityName() %> to <%= flight.getDestinationCity().getCityName() %></td>
              <td><%= dateFormat.format(flight.getDepartureTime()) %></td>
              <td style="white-space: nowrap;">
                <a href="details?id=<%= flight.getId() %>" style="background-color: #17a2b8; color: white; padding: 0.3rem 0.6rem; border-radius: 4px; text-decoration: none; margin-right: 0.5rem; font-size: 0.9rem;">Details</a>
                <a href="edit?id=<%= flight.getId() %>" style="background-color: #ffc107; color: #212529; padding: 0.3rem 0.6rem; border-radius: 4px; text-decoration: none; margin-right: 0.5rem; font-size: 0.9rem;">Edit</a>
                <a href="configure?id=<%= flight.getId() %>" style="background-color: var(--primary-color); color: white; padding: 0.3rem 0.6rem; border-radius: 4px; text-decoration: none; margin-right: 0.5rem; font-size: 0.9rem;">Prices</a>
                <a href="api/export?id=<%= flight.getId() %>" style="background-color: #28a745; color: white; padding: 0.3rem 0.6rem; border-radius: 4px; text-decoration: none; margin-right: 0.5rem; font-size: 0.9rem;">Export PDF</a>
                <button onclick="confirmDelete('<%= flight.getId() %>', '<%= flight.getFlightNumber() %>')" style="background-color: #dc3545; color: white; padding: 0.3rem 0.6rem; border-radius: 4px; border: none; cursor: pointer; font-size: 0.9rem;">Delete</button>
              </td>
            </tr>
          <% } %>
        <% } else { %>
          <tr>
            <td colspan="4" style="text-align: center;">No flights available</td>
          </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<!-- Modal for delete confirmation -->
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