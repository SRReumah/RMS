<?php
$conn = new mysqli("localhost", "root", "", "rms");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Customer form
if (isset($_POST['name'])) {
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $address = $_POST['address'];

    $sql = "INSERT INTO customer (name, phone, address)
            VALUES ('$name', '$phone', '$address')";

    if ($conn->query($sql) === TRUE) {
        echo "Customer added successfully";
    } else {
        echo "Error: " . $conn->error;
    }
}

// Order form
if (isset($_POST['cust_id'])) {
    $cust_id = $_POST['cust_id'];
    $item = $_POST['item'];
    $qty = $_POST['qty'];

    $sql = "INSERT INTO orders (cust_id, item, quantity)
            VALUES ('$cust_id', '$item', '$qty')";

    if ($conn->query($sql) === TRUE) {
        echo "Order placed successfully";
    } else {
        echo "Error: " . $conn->error;
    }
}

$conn->close();
?>