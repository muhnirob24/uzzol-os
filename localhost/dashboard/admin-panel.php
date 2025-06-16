<?php
session_start();
$default_user = "admin";
$default_pass = "admin";

if(isset($_POST['username']) && isset($_POST['password'])){
  if($_POST['username'] === $default_user && $_POST['password'] === $default_pass){
    $_SESSION['loggedin'] = true;
  } else {
    $error = "Invalid Credentials";
  }
}
if(!isset($_SESSION['loggedin'])){
?>
<html>
<head><title>Login - Uzzol OS Admin Panel</title></head>
<body>
<h2>Admin Login</h2>
<form method="post">
  Username: <input type="text" name="username" required><br/>
  Password: <input type="password" name="password" required><br/>
  <input type="submit" value="Login">
</form>
<?php if(isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
</body>
</html>
<?php
exit();
}
// Logged in user sees this:
?>
<html>
<head><title>Uzzol OS Admin Panel</title></head>
<body>
<h1>Welcome to Admin Panel</h1>
<p><a href="index.html">Back to Dashboard</a></p>
<!-- Add your admin controls here -->
</body>
</html>
