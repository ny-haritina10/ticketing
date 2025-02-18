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
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    
    .container {
      width: 100%;
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    
    .header {
      width: 100%;
      text-align: center;
      margin-bottom: 3rem;
    }
    
    .title {
      font-size: 2.5rem;
      font-weight: 700;
      color: var(--primary-color);
      position: relative;
      display: inline-block;
      padding-bottom: 1rem;
    }
    
    .title::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 70%;
      height: 4px;
      background-color: var(--accent-color);
      border-radius: 2px;
    }

    .subtitle {
      font-size: 1.2rem;
      color: var(--text-secondary);
      margin-top: 0.5rem;
    }
    
    .card-container {
      width: 100%;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }
    
    .card {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      overflow: hidden;
      box-shadow: var(--shadow);
      transition: var(--transition);
      height: 100%;
      display: flex;
      flex-direction: column;
    }
    
    .card:hover {
      transform: translateY(-10px);
      box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
    }
    
    .card-header {
      background-color: var(--primary-color);
      color: white;
      padding: 1.5rem;
      position: relative;
      text-align: center;
    }
    
    .card-icon {
      font-size: 3rem;
      margin-bottom: 1rem;
    }
    
    .card-title {
      font-size: 1.5rem;
      font-weight: 600;
    }
    
    .card-body {
      padding: 1.5rem;
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    
    .card-text {
      color: var(--text-secondary);
      margin-bottom: 1.5rem;
    }
    
    .card-action {
      display: flex;
      justify-content: center;
      margin-top: auto;
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
      text-decoration: none;
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
    
    .footer {
      margin-top: 4rem;
      text-align: center;
      color: var(--text-light);
      font-size: 0.9rem;
    }
    
    @media (max-width: 768px) {
      .card-container {
        grid-template-columns: 1fr;
      }
      
      .title {
        font-size: 2rem;
      }
      
      .subtitle {
        font-size: 1rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 class="title">Front-Office Ticketing</h1>
      <p class="subtitle">Welcome to our streamlined ticketing platform</p>
    </div>
    
    <div class="card-container">
      <div class="card">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-plane"></i>
          </div>
          <h2 class="card-title">Flight Reservations</h2>
        </div>
        <div class="card-body">
          <p class="card-text">Browse available flights, search by multiple criteria, and make reservations online. Access all your travel details in one convenient location.</p>
          <div class="card-action">
            <a href="front_office_flights" class="btn btn-primary">
              <i class="fas fa-ticket-alt"></i> Find Flights
            </a>
          </div>
        </div>
      </div>
      
      <div class="card">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-user-circle"></i>
          </div>
          <h2 class="card-title">My Bookings</h2>
        </div>
        <div class="card-body">
          <p class="card-text">View your current reservations, check booking status, and manage your travel plans. Get real-time updates on any changes to your itinerary.</p>
          <div class="card-action">
            <a href="#" class="btn btn-primary">
              <i class="fas fa-calendar-check"></i> View Bookings
            </a>
          </div>
        </div>
      </div>
      
      <div class="card">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-headset"></i>
          </div>
          <h2 class="card-title">Customer Support</h2>
        </div>
        <div class="card-body">
          <p class="card-text">Need assistance with your booking? Our customer support team is ready to help you with any questions or concerns about your travel arrangements.</p>
          <div class="card-action">
            <a href="#" class="btn btn-primary">
              <i class="fas fa-comment-dots"></i> Get Help
            </a>
          </div>
        </div>
      </div>
    </div>
    
    <div class="footer">
      <p>&copy; 2025 Ticketing App. All rights reserved.</p>
    </div>
  </div>
</body>
</html>