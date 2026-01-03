<?php
$servername = "127.0.0.1";
$username = "root";
$password = "";

try {
    echo "Attempting to connect to MySQL server...\n";

    mysqli_report(MYSQLI_REPORT_OFF); // Disable exceptions for connection check

    $conn = @new mysqli($servername, $username, "");
    if ($conn->connect_error) {
        echo "Empty password failed (" . $conn->connect_error . "). Trying 'root'...\n";
        $conn = @new mysqli($servername, $username, "root");
        if ($conn->connect_error) {
            echo "Password 'root' failed also (" . $conn->connect_error . ").\n";
            throw new Exception("Both empty and root passwords failed.");
        } else {
            echo "Connected successfully with password 'root'.\n";
        }
    } else {
        echo "Connected successfully with empty password.\n";
    }

    $sql = "CREATE DATABASE IF NOT EXISTS product_scan";
    if ($conn->query($sql) === TRUE) {
        echo "Database 'product_scan' created successfully or already exists.\n";
    } else {
        echo "Error creating database: " . $conn->error . "\n";
    }

    $conn->close();
} catch (Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
}
?>