<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front-Office Login | Ticketing App</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            width: 350px;
            text-align: center;
        }
        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
        }
        .input-group {
            position: relative;
            margin-bottom: 15px;
            width: 100%;
        }
        .input-group input {
            width: calc(100% - 20px);
            padding: 10px 40px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .input-group i {
            position: absolute;
            left: 25px;
            top: 50%;
            transform: translateY(-50%);
            color: #777;
        }
        .login-btn {
            width: 100%;
            padding: 10px;
            background: #007bff;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
            box-sizing: border-box;
        }
        .login-btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2><i class="fas fa-plane-departure"></i> Front-Office </h2>
        <form action="client_login" method="post">
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="email" placeholder="User email" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="login-btn">Login</button>
        </form> <br>

        <a href="index.jsp">Back-Office</a>
    </div>
</body>
</html>