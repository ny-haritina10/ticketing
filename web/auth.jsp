<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Auth</title>
</head>
<body>
  <h1>Auth</h1>

  <h3>Admin login</h3>
  <form action="admin_login" method="post">
    <p>
      Email:
      <input type="email" name="email">
    </p>

    <p>
      Password: 
      <input type="password" name="password">
    </p>

    <p>
      <input type="submit" value="Login">
    </p>
  </form>

  <h3>Owner login</h3>
  <form action="owner_login" method="post">
    <p>
      Email:
      <input type="email" name="email">
    </p>

    <p>
      Password: 
      <input type="password" name="password">
    </p>

    <p>
      <input type="submit" value="Login">
    </p>
  </form>
</body>
</html>