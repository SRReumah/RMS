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
if(isset($_POST['order_id']) && isset($_POST['customer_id'])){

    $order_id = $_POST['order_id'];
    $customer_id = $_POST['customer_id'];
    $staff_id = $_POST['staff_id'];
    $order_date = $_POST['order_date'];

    $sql = "INSERT INTO orders (order_id, customer_id, staff_id, order_date)
            VALUES ('$order_id','$customer_id','$staff_id','$order_date')";

    if($conn->query($sql)){
        echo "<script>alert('Order Added');window.location.href='../frontend/index.html';</script>";
    } else {
        echo "<script>alert('Error: Check Customer ID / Staff ID exists');history.back();</script>";
    }
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
if(isset($_POST['payment_id']) && isset($_POST['order_id'])){

    $payment_id = $_POST['payment_id'];
    $order_id = $_POST['order_id'];
    $amount = $_POST['amount'];
    $mode = $_POST['payment_mode'];

    $sql = "INSERT INTO payment (payment_id, order_id, amount, payment_mode)
            VALUES ('$payment_id','$order_id','$amount','$mode')";

    if($conn->query($sql)){
        echo "<script>alert('Payment Done');window.location.href='../frontend/index.html';</script>";
    } else {
        echo "<script>alert('Error: Order ID not found');history.back();</script>";
    }
}
$conn->close();
?>
