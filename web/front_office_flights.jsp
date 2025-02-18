<%@ page import="model.Flight" %>
<%@ page import="model.City" %>
<%@ page import="model.Plane" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
  City[] cities = (City[]) request.getAttribute("cities");
  Plane[] planes = (Plane[]) request.getAttribute("planes");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
  SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Front-Office | Ticketing App</title>
  <!-- Font Awesome CDN -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Google Fonts - Poppins -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #3f51b5;
      --primary-light: #757de8;
      --primary-dark: #002984;
      --secondary-color: #f50057;
      --accent-color: #ff4081;
      --background-color: #f5f7fa;
      --card-color: #ffffff;
      --text-primary: #212121;
      --text-secondary: #757575;
      --text-light: #9e9e9e;
      --border-color: #e0e0e0;
      --border-radius: 10px;
      --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      --transition: all 0.3s ease;
    }
    
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background-color: var(--background-color);
      color: var(--text-primary);
      line-height: 1.6;
      padding: 2rem;
    }
    
    .container {
      max-width: 1200px;
      margin: 0 auto;
    }
    
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
    }
    
    .title {
      font-size: 2.5rem;
      font-weight: 700;
      color: var(--primary-color);
      position: relative;
    }
    
    .title::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 0;
      width: 50%;
      height: 4px;
      background-color: var(--accent-color);
      border-radius: 2px;
    }

    /* Search Form Styling */
    .search-container {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      box-shadow: var(--shadow);
      padding: 1.5rem;
      margin-bottom: 2rem;
    }

    .search-title {
      font-size: 1.5rem;
      font-weight: 600;
      color: var(--primary-color);
      margin-bottom: 1.5rem;
      display: flex;
      align-items: center;
    }

    .search-title i {
      margin-right: 0.5rem;
    }

    .search-form {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1.5rem;
    }

    .form-group {
      display: flex;
      flex-direction: column;
    }

    .form-label {
      font-weight: 500;
      margin-bottom: 0.5rem;
      color: var(--text-secondary);
    }

    .form-control {
      padding: 0.75rem;
      border: 1px solid var(--border-color);
      border-radius: var(--border-radius);
      font-family: 'Poppins', sans-serif;
      font-size: 1rem;
      color: var(--text-primary);
      transition: var(--transition);
    }

    .form-control:focus {
      border-color: var(--primary-color);
      outline: none;
      box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.2);
    }

    .search-actions {
      display: flex;
      justify-content: flex-end;
      margin-top: 1.5rem;
      gap: 1rem;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: var(--border-radius);
      font-family: 'Poppins', sans-serif;
      font-weight: 500;
      font-size: 1rem;
      cursor: pointer;
      transition: var(--transition);
      display: flex;
      align-items: center;
    }

    .btn i {
      margin-right: 0.5rem;
    }

    .btn-primary {
      background-color: var(--primary-color);
      color: white;
    }

    .btn-primary:hover {
      background-color: var(--primary-dark);
    }

    .btn-secondary {
      background-color: var(--text-light);
      color: white;
    }

    .btn-secondary:hover {
      background-color: var(--text-secondary);
    }

    /* Results/Flight Cards Styling */
    .results-info {
      margin-bottom: 1.5rem;
      font-size: 1.1rem;
      color: var(--text-secondary);
    }

    .results-count {
      font-weight: 600;
      color: var(--primary-color);
    }
    
    .flights-container {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 2rem;
    }
    
    .flight-card {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      overflow: hidden;
      box-shadow: var(--shadow);
      transition: var(--transition);
    }
    
    .flight-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }
    
    .flight-header {
      background-color: var(--primary-color);
      color: white;
      padding: 1rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .flight-number {
      font-size: 1.2rem;
      font-weight: 600;
    }
    
    .flight-body {
      padding: 1.5rem;
    }
    
    .flight-route {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.5rem;
    }
    
    .city {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    
    .city-name {
      font-weight: 600;
      margin-top: 0.5rem;
    }
    
    .flight-path {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text-light);
      position: relative;
      margin: 0 1rem;
    }
    
    .flight-path::before {
      content: '';
      position: absolute;
      width: 100%;
      height: 2px;
      background-color: var(--border-color);
    }
    
    .flight-icon {
      position: relative;
      background-color: var(--card-color);
      padding: 0 0.5rem;
      z-index: 1;
      transform: rotate(45deg);
    }
    
    .flight-details {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
    }
    
    .detail {
      display: flex;
      flex-direction: column;
    }
    
    .detail-label {
      font-size: 0.8rem;
      text-transform: uppercase;
      color: var(--text-light);
      letter-spacing: 0.5px;
    }
    
    .detail-value {
      font-weight: 500;
    }
    
    .plane-info {
      margin-top: 1.5rem;
      padding-top: 1.5rem;
      border-top: 1px solid var(--border-color);
      display: flex;
      align-items: center;
    }
    
    .plane-icon {
      margin-right: 1rem;
      color: var(--primary-color);
    }
    
    .plane-model {
      font-weight: 500;
    }
    
    .deadline-info {
      margin-top: 1.5rem;
      padding: 1rem;
      background-color: #f0f4ff;
      border-radius: var(--border-radius);
    }
    
    .deadline-title {
      font-weight: 600;
      margin-bottom: 0.5rem;
    }
    
    .deadline-details {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
    }
    
    .deadline-item {
      display: flex;
      align-items: center;
    }
    
    .deadline-icon {
      margin-right: 0.5rem;
      color: var(--primary-color);
    }
    
    .no-flights {
      text-align: center;
      padding: 3rem;
      font-size: 1.5rem;
      color: var(--text-secondary);
      grid-column: 1 / -1;
    }

    /* Collapsible Search Panel */
    .search-toggle {
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
    }

    .search-toggle i {
      transition: var(--transition);
    }

    .search-form-wrapper {
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.5s ease;
    }

    .search-form-wrapper.expanded {
      max-height: 1000px;
    }

    .toggle-icon.rotated {
      transform: rotate(180deg);
    }
    
    @media (max-width: 768px) {
      .flights-container {
        grid-template-columns: 1fr;
      }
      
      .flight-route {
        flex-direction: column;
        gap: 1rem;
      }
      
      .flight-path {
        transform: rotate(90deg);
        margin: 1rem 0;
      }

      .search-form {
        grid-template-columns: 1fr;
      }

      .search-actions {
        flex-direction: column;
        align-items: stretch;
      }

      .title {
        font-size: 2rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 class="title">Available Flights</h1>
    </div>
    
    <!-- Search Container -->
    <div class="search-container">
      <div class="search-toggle" onclick="toggleSearch()">
        <div class="search-title">
          <i class="fas fa-search"></i> Recherche Multi-Critere
        </div>
        <i class="fas fa-chevron-down toggle-icon"></i>
      </div>
      
      <div class="search-form-wrapper">
        <form action="front_office_flights" method="get" class="search-form">
          <div class="form-group">
            <label for="plane" class="form-label">Plane</label>
            <select name="planeId" id="plane" class="form-control">
              <option value="">Any plane</option>
              <% if (planes != null) { 
                  for (Plane plane : planes) { 
                    String selected = request.getParameter("planeId") != null && 
                                     request.getParameter("planeId").equals(plane.getId().toString()) ? "selected" : "";
              %>
                    <option value="<%= plane.getId() %>" <%= selected %>><%= plane.getModelName() %></option>
              <% } 
                 } 
              %>
            </select>
          </div>
          
          <div class="form-group">
            <label for="originCity" class="form-label">Departure City</label>
            <select name="originCityId" id="originCity" class="form-control">
              <option value="">Any origin</option>
              <% if (cities != null) { 
                  for (City city : cities) { 
                    String selected = request.getParameter("originCityId") != null && 
                                     request.getParameter("originCityId").equals(city.getId().toString()) ? "selected" : "";
              %>
                    <option value="<%= city.getId() %>" <%= selected %>><%= city.getCityName() %></option>
              <% } 
                 } 
              %>
            </select>
          </div>
          
          <div class="form-group">
            <label for="destinationCity" class="form-label">Arrival City</label>
            <select name="destinationCityId" id="destinationCity" class="form-control">
              <option value="">Any destination</option>
              <% if (cities != null) { 
                  for (City city : cities) { 
                    String selected = request.getParameter("destinationCityId") != null && 
                                     request.getParameter("destinationCityId").equals(city.getId().toString()) ? "selected" : "";
              %>
                    <option value="<%= city.getId() %>" <%= selected %>><%= city.getCityName() %></option>
              <% } 
                 } 
              %>
            </select>
          </div>

          <br><br>
          
          <div class="search-actions">
            <button type="reset" class="btn btn-secondary">
              <i class="fas fa-undo"></i> Reset
            </button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-search"></i> Search
            </button>
          </div>
        </form>
      </div>
    </div>
    
    <!-- Results Info -->
    <div class="results-info">
      Found <span class="results-count"><%= flights != null ? flights.length : 0 %></span> flight(s)
      <% if (request.getQueryString() != null && !request.getQueryString().isEmpty()) { %>
        matching your criteria
      <% } %>
    </div>
    
    <!-- Flights Container -->
    <div class="flights-container">
      <% 
      if (flights != null && flights.length > 0) {
        for (Flight flight : flights) {
      %>
      <div class="flight-card">
        <div class="flight-header">
          <div class="flight-number">
            <i class="fas fa-plane-departure"></i> <%= flight.getFlightNumber() %>
          </div>
        </div>
        
        <div class="flight-body">
          <div class="flight-route">
            <div class="city">
              <i class="fas fa-map-marker-alt fa-lg"></i>
              <div class="city-name"><%= flight.getOriginCity().getCityName() %></div>
            </div>
            
            <div class="flight-path">
              <div class="flight-icon"><i class="fas fa-plane"></i></div>
            </div>
            
            <div class="city">
              <i class="fas fa-map-marker-alt fa-lg"></i>
              <div class="city-name"><%= flight.getDestinationCity().getCityName() %></div>
            </div>
          </div>
          
          <div class="flight-details">
            <div class="detail">
              <div class="detail-label">Departure</div>
              <div class="detail-value">
                <i class="far fa-clock"></i> <%= dateFormat.format(flight.getDepartureTime()) %>
              </div>
            </div>

            <br><br>
            
            <div class="detail">
              <div class="detail-label">Arrival</div>
              <div class="detail-value">
                <i class="far fa-clock"></i> <%= dateFormat.format(flight.getArrivalTime()) %>
              </div>
            </div>
          </div>
          
          <div class="plane-info">
            <div class="plane-icon">
              <i class="fas fa-plane fa-lg"></i>
            </div>
            <div class="plane-model">
              <%= flight.getPlane().getModelName() %>
            </div>
          </div>
          
          <div class="deadline-info">
            <div class="deadline-title">Important Deadlines</div>
            <div class="deadline-details">
              <div class="deadline-item">
                <div class="deadline-icon">
                  <i class="fas fa-ticket-alt"></i>
                </div>
                <div>Reservation: <%= flight.getReservationDeadlineHours() %> hours before</div>
              </div>
              
              <div class="deadline-item">
                <div class="deadline-icon">
                  <i class="fas fa-ban"></i>
                </div>
                <div>Cancellation: <%= flight.getCancellationDeadlineHours() %> hours before</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <% 
        } 
      } else { 
      %>
      <div class="no-flights">
        <i class="fas fa-exclamation-triangle fa-lg"></i>
        <p>No flights found matching your criteria.</p>
      </div>
      <% } %>
    </div>
  </div>

  <script>
    // Toggle search panel expansion
    function toggleSearch() {
      const searchForm = document.querySelector('.search-form-wrapper');
      const toggleIcon = document.querySelector('.toggle-icon');
      
      searchForm.classList.toggle('expanded');
      toggleIcon.classList.toggle('rotated');
      
      // Auto-expand if there are search parameters
      window.onload = function() {
        const queryString = '<%= request.getQueryString() %>';
        if (queryString && queryString !== 'null' && queryString !== '') {
          searchForm.classList.add('expanded');
          toggleIcon.classList.add('rotated');
        }
      }
    }
    
    // Run onload function
    window.onload = function() {
      const queryString = '<%= request.getQueryString() %>';
      if (queryString && queryString !== 'null' && queryString !== '') {
        const searchForm = document.querySelector('.search-form-wrapper');
        const toggleIcon = document.querySelector('.toggle-icon');
        searchForm.classList.add('expanded');
        toggleIcon.classList.add('rotated');
      }
    }
  </script>
</body>
</html>