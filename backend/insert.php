<?php
$conn = new mysqli("localhost","root","","rms");

if($conn->connect_error){
    die("Connection failed");
}
//CUSTOMERS
if(isset($_POST['customer_name'])){
    $stmt = $conn->prepare("INSERT INTO customer VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $_POST['customer_id'], $_POST['customer_name'], $_POST['phone']);
    $stmt->execute();
    $stmt->close();
    
    echo "<script>alert('Customer Added');window.location.href='../frontend/index.html';</script>";
}

// ORDERS
if(isset($_POST['order_id'])){
    $sql = "INSERT INTO orders VALUES ('$_POST[order_id]','$_POST[customer_id]','$_POST[staff_id]','$_POST[order_date]')";
    $conn->query($sql);

    echo "<script>alert('Order Added');window.location.href='../frontend/index.html';</script>";
}

// MENU
if(isset($_POST['item_name'])){
    $sql = "INSERT INTO menu VALUES ('$_POST[menu_id]','$_POST[item_name]','$_POST[price]')";
    $conn->query($sql);

    echo "<script>alert('Menu Item Added');window.location.href='../frontend/index.html';</script>";
}

// STAFF
if(isset($_POST['staff_name'])){
    $sql = "INSERT INTO staff VALUES ('$_POST[staff_id]','$_POST[staff_name]','$_POST[role]')";
    $conn->query($sql);

    echo "<script>alert('Staff Added');window.location.href='../frontend/index.html';</script>";
}

// PAYMENT
if(isset($_POST['payment_id'])){
    $sql = "INSERT INTO payment VALUES ('$_POST[payment_id]','$_POST[order_id]','$_POST[amount]','$_POST[payment_mode]')";
    $conn->query($sql);

    echo "<script>alert('Payment Done');window.location.href='../frontend/index.html';</script>";
}

$conn->close();
?>
