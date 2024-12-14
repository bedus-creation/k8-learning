<?php
$servername = "mysql";
$username   = "root";
$password   = "12345678";
$database   = "jh";
$port       = 4406;

// Create connection
$conn = new mysqli($servername, $username, $password, $database, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: ".$conn->connect_error);
}
echo "Connected successfully!";
