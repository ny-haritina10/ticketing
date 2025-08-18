<%@ page import="model.*" %>

<%
  Flight[] flights = (Flight[]) request.getAttribute("flights");
  String[] seatCategories = (String[]) request.getAttribute("categories");
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

    .form-group {
    margin-bottom: 1rem;
  }
  
  .form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: var(--text-primary);
    font-weight: 500;
  }
  
  .form-group input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid var(--border-color);
    border-radius: var(--border-radius);
    font-family: 'Poppins', sans-serif;
    font-size: 1rem;
    color: var(--text-primary);
    transition: var(--transition);
  }
  
  .form-group input:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px var(--primary-light);
  }
  </style>
</head>
<body>
  <div class="container">
    <h1>Flight Reservation</h1>

    <form action="flight_reservation" method="post" enctype="multipart/form-data">
      <p>Vol: </p>
      <select name="flight" id="flight" required>
        <% for(Flight flight : flights) { %>
          <option value="<%= flight.getId() %>">
            <%= flight.getFlightNumber()%> - <%= flight.getOriginCity().getCityName() %> to <%= flight.getDestinationCity().getCityName() %> 
          </option>
        <% } %>
      </select>

      <p>Siege categorie: </p>
      <select name="seatCategorie" id="seatCategorie" required>
        <% for(String categorie : seatCategories) { %>
          <option value="<%= categorie %>"><%= categorie %></option>
        <% } %>
      </select>

      <div class="form-group">
        <label for="name_voyageur">Passenger Name:</label>
        <input type="text" name="name_voyageur" id="name_voyageur" required>
      </div>

      <div class="form-group">
        <label for="dtn_voyageur">Date of Birth:</label>
        <input type="date" name="dtn_voyageur" id="dtn_voyageur" required>
      </div>

      <div class="form-group">
        <label for="passport_image">Passport Image:</label>
        <input type="file" name="passport_image" id="passport_image" accept="image/*" required>
      </div>

      <p>Date reservation: </p>
      <input type="datetime-local" name="reservation_time" required>
        
      <input type="submit" value="Make Reservation">
    </form>
  </div>
</body>
</html>