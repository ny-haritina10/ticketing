<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Front-Office | Upload Success</title>
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
      --success-color: #4caf50;
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
      justify-content: center;
    }
    
    .container {
      width: 100%;
      max-width: 600px;
      margin: 0 auto;
      text-align: center;
    }
    
    .success-card {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      box-shadow: var(--shadow);
      padding: 3rem 2rem;
      margin-top: 2rem;
      position: relative;
      overflow: hidden;
    }
    
    .success-icon {
      font-size: 5rem;
      color: var(--success-color);
      margin-bottom: 1.5rem;
      animation: scaleIn 0.5s ease-out;
    }
    
    .success-title {
      font-size: 2rem;
      font-weight: 700;
      color: var(--success-color);
      margin-bottom: 1rem;
      animation: fadeIn 0.5s ease-out 0.2s both;
    }
    
    .success-message {
      color: var(--text-secondary);
      margin-bottom: 2rem;
      animation: fadeIn 0.5s ease-out 0.4s both;
    }
    
    .btn {
      display: inline-flex;
      align-items: center;
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: var(--border-radius);
      font-family: 'Poppins', sans-serif;
      font-weight: 500;
      font-size: 1rem;
      cursor: pointer;
      transition: var(--transition);
      text-decoration: none;
      margin: 0.5rem;
      animation: fadeIn 0.5s ease-out 0.6s both;
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
    
    @keyframes scaleIn {
      from {
        transform: scale(0);
        opacity: 0;
      }
      to {
        transform: scale(1);
        opacity: 1;
      }
    }
    
    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .success-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background-color: var(--success-color);
    }
    
    @media (max-width: 768px) {
      .container {
        padding: 1rem;
      }
      
      .success-title {
        font-size: 1.75rem;
      }
      
      .success-icon {
        font-size: 4rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="success-card">
      <div class="success-icon">
        <i class="fas fa-check-circle"></i>
      </div>
      <h1 class="success-title">Upload Successful!</h1>
      <p class="success-message">Your passport image has been successfully uploaded and is being processed for verification.</p>
      <div class="action-buttons">
        <a href="front_office_flights" class="btn btn-primary">
          <i class="fas fa-plane"></i> Continue to Flights
        </a>
      </div>
    </div>
  </div>
</body>
</html>