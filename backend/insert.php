<?php
// Database connection
$conn = new mysqli("localhost", "root", "", "rms");

if ($conn->connect_error) {
    die("<script>alert('Database connection failed: " . $conn->connect_error . "'); window.history.back();</script>");
}

// Set charset to handle special characters
$conn->set_charset("utf8mb4");

// Helper function for safe redirection
function redirectWithMessage($message, $isError = false) {
    echo "<script>
            alert('" . addslashes($message) . "');
            window.location.href = '../frontend/index.html';
          </script>";
    exit();
}

// ========== CUSTOMER INSERT ==========
if (isset($_POST['customer_name']) && !isset($_POST['order_id']) && !isset($_POST['item_name']) && !isset($_POST['staff_name'])) {
    $customer_id = !empty($_POST['customer_id']) ? trim($_POST['customer_id']) : null;
    $customer_name = trim($_POST['customer_name']);
    $phone = trim($_POST['phone']);
    
    // Validation
    if (empty($customer_name) || empty($phone)) {
        redirectWithMessage("Customer Name and Phone are required fields!", true);
    }
    
    // If customer_id is empty, generate one
    if (empty($customer_id)) {
        $result = $conn->query("SELECT MAX(CAST(SUBSTRING(customer_id, 2) AS UNSIGNED)) as max_id FROM customer");
        $row = $result->fetch_assoc();
        $next_id = ($row['max_id'] ?? 0) + 1;
        $customer_id = "C" . str_pad($next_id, 3, "0", STR_PAD_LEFT);
    }
    
    // Check if customer ID already exists
    $check = $conn->prepare("SELECT customer_id FROM customer WHERE customer_id = ?");
    $check->bind_param("s", $customer_id);
    $check->execute();
    $check->store_result();
    
    if ($check->num_rows > 0) {
        redirectWithMessage("Customer ID '$customer_id' already exists! Please use a different ID.", true);
    }
    $check->close();
    
    // Insert customer
    $stmt = $conn->prepare("INSERT INTO customer (customer_id, customer_name, phone) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $customer_id, $customer_name, $phone);
    
    if ($stmt->execute()) {
        redirectWithMessage("✓ Customer '$customer_name' added successfully! ID: $customer_id");
    } else {
        redirectWithMessage("Error adding customer: " . $stmt->error, true);
    }
    $stmt->close();
}

// ========== ORDERS INSERT ==========
elseif (isset($_POST['order_id']) && isset($_POST['customer_id']) && isset($_POST['staff_id'])) {
    $order_id = trim($_POST['order_id']);
    $customer_id = trim($_POST['customer_id']);
    $staff_id = trim($_POST['staff_id']);
    $order_date = trim($_POST['order_date']);
    
    // Validation
    if (empty($order_id) || empty($customer_id) || empty($staff_id) || empty($order_date)) {
        redirectWithMessage("All fields are required for creating an order!", true);
    }
    
    // Check if order ID already exists
    $check_order = $conn->prepare("SELECT order_id FROM orders WHERE order_id = ?");
    $check_order->bind_param("s", $order_id);
    $check_order->execute();
    $check_order->store_result();
    
    if ($check_order->num_rows > 0) {
        redirectWithMessage("Order ID '$order_id' already exists! Please use a different ID.", true);
    }
    $check_order->close();
    
    // Verify customer exists
    $check_customer = $conn->prepare("SELECT customer_id FROM customer WHERE customer_id = ?");
    $check_customer->bind_param("s", $customer_id);
    $check_customer->execute();
    $check_customer->store_result();
    
    if ($check_customer->num_rows == 0) {
        redirectWithMessage("Error: Customer ID '$customer_id' does not exist. Please add customer first.", true);
    }
    $check_customer->close();
    
    // Verify staff exists
    $check_staff = $conn->prepare("SELECT staff_id FROM staff WHERE staff_id = ?");
    $check_staff->bind_param("s", $staff_id);
    $check_staff->execute();
    $check_staff->store_result();
    
    if ($check_staff->num_rows == 0) {
        redirectWithMessage("Error: Staff ID '$staff_id' does not exist. Please add staff first.", true);
    }
    $check_staff->close();
    
    // Insert order
    $stmt = $conn->prepare("INSERT INTO orders (order_id, customer_id, staff_id, order_date) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $order_id, $customer_id, $staff_id, $order_date);
    
    if ($stmt->execute()) {
        redirectWithMessage("✓ Order '$order_id' created successfully for customer '$customer_id'!");
    } else {
        redirectWithMessage("Error creating order: " . $stmt->error, true);
    }
    $stmt->close();
}

// ========== MENU INSERT ==========
elseif (isset($_POST['item_name'])) {
    $menu_id = !empty($_POST['menu_id']) ? trim($_POST['menu_id']) : null;
    $item_name = trim($_POST['item_name']);
    $price = floatval($_POST['price']);
    
    // Validation
    if (empty($item_name) || $price <= 0) {
        redirectWithMessage("Item Name and valid Price (greater than 0) are required!", true);
    }
    
    // If menu_id is empty, generate one
    if (empty($menu_id)) {
        $result = $conn->query("SELECT MAX(CAST(SUBSTRING(menu_id, 2) AS UNSIGNED)) as max_id FROM menu");
        $row = $result->fetch_assoc();
        $next_id = ($row['max_id'] ?? 0) + 1;
        $menu_id = "M" . str_pad($next_id, 3, "0", STR_PAD_LEFT);
    }
    
    // Check if menu ID already exists
    $check = $conn->prepare("SELECT menu_id FROM menu WHERE menu_id = ?");
    $check->bind_param("s", $menu_id);
    $check->execute();
    $check->store_result();
    
    if ($check->num_rows > 0) {
        redirectWithMessage("Menu ID '$menu_id' already exists! Please use a different ID.", true);
    }
    $check->close();
    
    // Insert menu item
    $stmt = $conn->prepare("INSERT INTO menu (menu_id, item_name, price) VALUES (?, ?, ?)");
    $stmt->bind_param("ssd", $menu_id, $item_name, $price);
    
    if ($stmt->execute()) {
        redirectWithMessage("✓ Menu item '$item_name' added successfully! Price: ₹" . number_format($price, 2));
    } else {
        redirectWithMessage("Error adding menu item: " . $stmt->error, true);
    }
    $stmt->close();
}

// ========== STAFF INSERT ==========
elseif (isset($_POST['staff_name'])) {
    $staff_id = !empty($_POST['staff_id']) ? trim($_POST['staff_id']) : null;
    $staff_name = trim($_POST['staff_name']);
    $role = trim($_POST['role']);
    
    // Validation
    if (empty($staff_name) || empty($role)) {
        redirectWithMessage("Staff Name and Role are required fields!", true);
    }
    
    // If staff_id is empty, generate one
    if (empty($staff_id)) {
        $result = $conn->query("SELECT MAX(CAST(SUBSTRING(staff_id, 2) AS UNSIGNED)) as max_id FROM staff");
        $row = $result->fetch_assoc();
        $next_id = ($row['max_id'] ?? 0) + 1;
        $staff_id = "S" . str_pad($next_id, 3, "0", STR_PAD_LEFT);
    }
    
    // Check if staff ID already exists
    $check = $conn->prepare("SELECT staff_id FROM staff WHERE staff_id = ?");
    $check->bind_param("s", $staff_id);
    $check->execute();
    $check->store_result();
    
    if ($check->num_rows > 0) {
        redirectWithMessage("Staff ID '$staff_id' already exists! Please use a different ID.", true);
    }
    $check->close();
    
    // Insert staff
    $stmt = $conn->prepare("INSERT INTO staff (staff_id, staff_name, role) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $staff_id, $staff_name, $role);
    
    if ($stmt->execute()) {
        redirectWithMessage("✓ Staff member '$staff_name' added successfully! Role: $role");
    } else {
        redirectWithMessage("Error adding staff: " . $stmt->error, true);
    }
    $stmt->close();
}

// ========== PAYMENT INSERT ==========
elseif (isset($_POST['payment_id']) && isset($_POST['order_id']) && isset($_POST['amount'])) {
    $payment_id = !empty($_POST['payment_id']) ? trim($_POST['payment_id']) : null;
    $order_id = trim($_POST['order_id']);
    $amount = floatval($_POST['amount']);
    $payment_mode = trim($_POST['payment_mode']);
    
    // Validation
    if (empty($order_id) || $amount <= 0 || empty($payment_mode)) {
        redirectWithMessage("Order ID, valid Amount (greater than 0), and Payment Mode are required!", true);
    }
    
    // If payment_id is empty, generate one
    if (empty($payment_id)) {
        $result = $conn->query("SELECT MAX(CAST(SUBSTRING(payment_id, 4) AS UNSIGNED)) as max_id FROM payment");
        $row = $result->fetch_assoc();
        $next_id = ($row['max_id'] ?? 0) + 1;
        $payment_id = "PAY" . str_pad($next_id, 3, "0", STR_PAD_LEFT);
    }
    
    // Check if payment ID already exists
    $check_payment = $conn->prepare("SELECT payment_id FROM payment WHERE payment_id = ?");
    $check_payment->bind_param("s", $payment_id);
    $check_payment->execute();
    $check_payment->store_result();
    
    if ($check_payment->num_rows > 0) {
        redirectWithMessage("Payment ID '$payment_id' already exists! Please use a different ID.", true);
    }
    $check_payment->close();
    
    // Verify order exists
    $check_order = $conn->prepare("SELECT order_id FROM orders WHERE order_id = ?");
    $check_order->bind_param("s", $order_id);
    $check_order->execute();
    $check_order->store_result();
    
    if ($check_order->num_rows == 0) {
        redirectWithMessage("Error: Order ID '$order_id' does not exist. Please create order first.", true);
    }
    $check_order->close();
    
    // Insert payment
    $stmt = $conn->prepare("INSERT INTO payment (payment_id, order_id, amount, payment_mode) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssds", $payment_id, $order_id, $amount, $payment_mode);
    
    if ($stmt->execute()) {
        redirectWithMessage("✓ Payment of ₹" . number_format($amount, 2) . " recorded successfully!\nOrder: $order_id\nMode: $payment_mode");
    } else {
        redirectWithMessage("Error processing payment: " . $stmt->error, true);
    }
    $stmt->close();
}

// If no matching condition
else {
    redirectWithMessage("Invalid request. Please use the proper form.", true);
}

$conn->close();
?>