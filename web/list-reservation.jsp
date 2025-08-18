<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  Reservation[] reservations = (Reservation[]) request.getAttribute("reservations");
  Map<Reservation, ReservationDetail[]> reservationDetails = (Map<Reservation, ReservationDetail[]>) request.getAttribute("reservationDetails");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Front-Office | Your Reservations</title>
  <!-- Font Awesome CDN -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Google Fonts - Poppins -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
      :root {
        --primary-color: #3f51b5;
        --primary-light: #757de8;
        --primary-dark: #002984;
        --secondary-color: #f50057;
        --background-color: #f5f7fa;
        --card-color: #ffffff;
        --text-primary: #212121;
        --text-secondary: #757575;
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
        min-height: 100vh;
      }
  
      .container {
        max-width: 800px;
        margin: 0 auto;
        background-color: var(--card-color);
        padding: 2rem;
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
      }
  
      h1 {
        color: var(--primary-color);
        text-align: center;
        margin-bottom: 2rem;
        font-size: 2rem;
        position: relative;
        padding-bottom: 1rem;
      }
  
      h1::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 100px;
        height: 4px;
        background-color: var(--secondary-color);
        border-radius: 2px;
      }
  
      form {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
      }
  
      select, input[type="datetime-local"] {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid var(--border-color);
        border-radius: var(--border-radius);
        font-family: 'Poppins', sans-serif;
        font-size: 1rem;
        color: var(--text-primary);
        transition: var(--transition);
      }
  
      select:focus, input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px var(--primary-light);
      }
  
      input[type="submit"] {
        background-color: var(--primary-color);
        color: white;
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: var(--border-radius);
        font-family: 'Poppins', sans-serif;
        font-weight: 500;
        font-size: 1rem;
        cursor: pointer;
        transition: var(--transition);
        align-self: center;
      }
  
      input[type="submit"]:hover {
        background-color: var(--primary-dark);
      }
  
      /* Table Styles */
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 2rem;
        background-color: var(--card-color);
        border-radius: var(--border-radius);
        overflow: hidden;
        box-shadow: var(--shadow);
      }
  
      th, td {
        padding: 1rem;
        text-align: left;
        border-bottom: 1px solid var(--border-color);
      }
  
      th {
        background-color: var(--primary-color);
        color: white;
        font-weight: 600;
      }
  
      tr:last-child td {
        border-bottom: none;
      }
  
      tr:hover {
        background-color: var(--background-color);
      }
  
      @media (max-width: 768px) {
        .container {
          padding: 1rem;
        }
  
        table {
          display: block;
          overflow-x: auto;
        }
      }

      .reservation-card {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      padding: 2rem;
      margin-bottom: 2rem;
      box-shadow: var(--shadow);
    }

    .reservation-card h2 {
      color: var(--primary-color);
      margin-bottom: 1rem;
    }

    .reservation-card h3 {
      color: var(--secondary-color);
      margin: 1.5rem 0 1rem;
    }

    .reservation-card p {
      margin-bottom: 0.5rem;
      color: var(--text-secondary);
    }
    </style>
</head>
<body>
  <h1>Your Reservations</h1>

  <% for (Reservation reservation : reservations) { %>
    <div class="reservation-card">
      <h2>Flight: <%= reservation.getFlight().getFlightNumber() %></h2>
      <p>Reservation Time: <%= dateFormat.format(reservation.getReservationTime()) %></p>
      
      <!-- ==================== NEW SECTION: PAYMENT STATUS & ACTION ==================== -->
      <div>
        <strong>Payment Status:</strong>
        <% if ("paid".equalsIgnoreCase(reservation.getPaymentStatus())) { %>
          <span style="color: green; font-weight: bold;">
            Paid on <%= dateFormat.format(reservation.getPaymentTime()) %>
          </span>
        <% } else { %>
          <span style="color: orange; font-weight: bold; text-transform: capitalize;">
            <%= reservation.getPaymentStatus() %>
          </span>
          <!-- "Pay" Button Form -->
          <form action="pay_reservation" method="post" style="display: inline; margin-left: 20px;">
            <input type="hidden" name="reservationId" value="<%= reservation.getId() %>">
            <button type="submit">Pay</button>
          </form>
        <% } %>
      </div>
      <!-- ================================= END NEW SECTION ================================= -->
      
      <p>Total Tickets: <%= reservation.getNbrBilletTotal() %></p>
      <p>Adult Tickets: <%= reservation.getNbrBilletAdulte() %></p>
      <p>Child Tickets: <%= reservation.getNbrBilletEnfant() %></p>

      <h3>Passenger Details:</h3>
      <table>
        <thead>
          <tr>
            <th>Passenger Name</th>
            <th>Date of Birth</th>
            <th>Seat Category</th>
            <th>Price Paid</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% for (ReservationDetail detail : reservationDetails.get(reservation)) { %>
            <tr>
              <td><%= detail.getNameVoyageur() %></td>
              <td><%= detail.getDtnVoyageur() %></td>
              <td><%= detail.getSeatCategory() %></td>
              <td>$<%= detail.getPrice() %></td>
              <td>
                <% if (detail.getIsCancel()) { %>
                  Cancelled (<%= dateFormat.format(detail.getCancellationTime()) %>)
                <% } else { %>
                  Active
                <% } %>
              </td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  <% } %>
</body>
</html>