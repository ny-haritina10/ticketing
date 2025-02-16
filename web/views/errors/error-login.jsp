<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login Error</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f8d7da;
      text-align: center;
      padding: 50px;
    }
    .container {
      max-width: 400px;
      margin: auto;
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
      color: #721c24;
    }
    .error-icon {
      font-size: 50px;
      color: #dc3545;
      margin-bottom: 10px;
    }
    h3 {
      color: #721c24;
      font-size: 18px;
    }
    a {
      display: inline-block;
      margin-top: 20px;
      padding: 10px 15px;
      background-color: #dc3545;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      transition: background 0.3s;
    }
    a:hover {
      background-color: #c82333;
    }
  </style>
</head>
<body>
  <div class="container">
    <i class="fas fa-exclamation-circle error-icon"></i>
    <h1>Login Error</h1>
    <h3>${ message }</h3>
    <a href="index.jsp"><i class="fas fa-arrow-left"></i> Go back</a>
  </div>
</body>
</html>