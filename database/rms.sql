-- =============================================
-- The Hungry Fork - Restaurant Management System
-- Database: rms
-- =============================================

-- Drop database if exists (use with caution!)
-- DROP DATABASE IF EXISTS rms;

-- Create database
CREATE DATABASE IF NOT EXISTS rms;
USE rms;

-- =============================================
-- Table: customer
-- Stores customer information
-- =============================================
CREATE TABLE IF NOT EXISTS customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_name (customer_name),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: staff
-- Stores staff/employee information
-- =============================================
CREATE TABLE IF NOT EXISTS staff (
    staff_id VARCHAR(50) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) DEFAULT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    salary DECIMAL(10, 2) DEFAULT NULL,
    hire_date DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_staff_name (staff_name),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: menu
-- Stores menu items
-- =============================================
CREATE TABLE IF NOT EXISTS menu (
    menu_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) DEFAULT NULL,
    description TEXT DEFAULT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_item_name (item_name),
    INDEX idx_category (category),
    INDEX idx_price (price)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: orders
-- Stores order information
-- =============================================
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    staff_id VARCHAR(50),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    status ENUM('Pending', 'Processing', 'Completed', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    INDEX idx_order_date (order_date),
    INDEX idx_status (status),
    INDEX idx_customer (customer_id),
    INDEX idx_staff (staff_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: order_items
-- Stores items within each order (for future enhancement)
-- =============================================
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    menu_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_menu (menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: payment
-- Stores payment transactions
-- =============================================
CREATE TABLE IF NOT EXISTS payment (
    payment_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    payment_mode VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Completed',
    transaction_id VARCHAR(100) DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: reservations (for future enhancement)
-- =============================================
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    party_size INT NOT NULL,
    status ENUM('Confirmed', 'Checked-in', 'Cancelled', 'No-show') DEFAULT 'Confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    INDEX idx_reservation_date (reservation_date),
    INDEX idx_customer (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Sample Customers
INSERT INTO customer (customer_id, customer_name, phone, email) VALUES
('C001', 'John Doe', '9876543210', 'john.doe@email.com'),
('C002', 'Jane Smith', '9876543211', 'jane.smith@email.com'),
('C003', 'Mike Johnson', '9876543212', 'mike.johnson@email.com'),
('C004', 'Sarah Williams', '9876543213', 'sarah.w@email.com'),
('C005', 'David Brown', '9876543214', 'david.b@email.com');

-- Sample Staff
INSERT INTO staff (staff_id, staff_name, role, email, phone, salary, hire_date) VALUES
('S001', 'Alice Brown', 'Manager', 'alice@hungryfork.com', '9988776655', 45000.00, '2023-01-15'),
('S002', 'Bob Wilson', 'Chef', 'bob@hungryfork.com', '9988776654', 38000.00, '2023-02-01'),
('S003', 'Charlie Davis', 'Waiter', 'charlie@hungryfork.com', '9988776653', 25000.00, '2023-03-10'),
('S004', 'Diana Prince', 'Chef', 'diana@hungryfork.com', '9988776652', 40000.00, '2023-04-05'),
('S005', 'Ethan Hunt', 'Waiter', 'ethan@hungryfork.com', '9988776651', 24000.00, '2023-05-20');

-- Sample Menu Items
INSERT INTO menu (menu_id, item_name, price, category, description) VALUES
('M001', 'Margherita Pizza', 299.99, 'Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil'),
('M002', 'Chicken Burger', 199.99, 'Burger', 'Grilled chicken patty with lettuce and mayo'),
('M003', 'Caesar Salad', 149.99, 'Salad', 'Fresh romaine lettuce with Caesar dressing and croutons'),
('M004', 'Pasta Alfredo', 249.99, 'Pasta', 'Creamy Alfredo sauce with fettuccine pasta'),
('M005', 'Cold Coffee', 99.99, 'Beverage', 'Chilled coffee with ice cream'),
('M006', 'Paneer Tikka', 279.99, 'Appetizer', 'Grilled cottage cheese with Indian spices'),
('M007', 'Garlic Bread', 89.99, 'Appetizer', 'Toasted bread with garlic butter'),
('M008', 'Tiramisu', 179.99, 'Dessert', 'Italian coffee-flavored dessert'),
('M009', 'Pepperoni Pizza', 349.99, 'Pizza', 'Pizza with spicy pepperoni and cheese'),
('M010', 'Fresh Lime Soda', 69.99, 'Beverage', 'Refreshing lime soda');

-- Sample Orders
INSERT INTO orders (order_id, customer_id, staff_id, order_date, total_amount, status) VALUES
('ORD001', 'C001', 'S003', '2024-01-15', 299.99, 'Completed'),
('ORD002', 'C002', 'S003', '2024-01-16', 199.99, 'Completed'),
('ORD003', 'C003', 'S005', '2024-01-17', 399.98, 'Completed'),
('ORD004', 'C001', 'S003', '2024-02-10', 549.98, 'Processing'),
('ORD005', 'C004', 'S005', '2024-02-11', 279.99, 'Pending'),
('ORD006', 'C005', 'S003', '2024-02-12', 449.97, 'Completed');

-- Sample Order Items
INSERT INTO order_items (order_id, menu_id, quantity, unit_price, subtotal) VALUES
('ORD001', 'M001', 1, 299.99, 299.99),
('ORD002', 'M002', 1, 199.99, 199.99),
('ORD003', 'M003', 1, 149.99, 149.99),
('ORD003', 'M005', 1, 99.99, 99.99),
('ORD003', 'M007', 1, 89.99, 89.99),
('ORD004', 'M004', 1, 249.99, 249.99),
('ORD004', 'M008', 1, 179.99, 179.99),
('ORD005', 'M006', 1, 279.99, 279.99),
('ORD006', 'M001', 1, 299.99, 299.99),
('ORD006', 'M005', 1, 99.99, 99.99),
('ORD006', 'M010', 1, 69.99, 69.99);

-- Update order totals based on order_items
UPDATE orders o 
SET total_amount = (
    SELECT COALESCE(SUM(subtotal), 0) 
    FROM order_items oi 
    WHERE oi.order_id = o.order_id
);

-- Sample Payments
INSERT INTO payment (payment_id, order_id, amount, payment_mode, status) VALUES
('PAY001', 'ORD001', 299.99, 'Credit Card', 'Completed'),
('PAY002', 'ORD002', 199.99, 'Cash', 'Completed'),
('PAY003', 'ORD003', 399.98, 'UPI', 'Completed'),
('PAY004', 'ORD004', 549.98, 'Debit Card', 'Completed'),
('PAY005', 'ORD006', 449.97, 'Cash', 'Completed');

-- Sample Reservations
INSERT INTO reservations (customer_id, reservation_date, reservation_time, party_size, status) VALUES
('C001', '2024-02-15', '19:00:00', 4, 'Confirmed'),
('C002', '2024-02-15', '20:30:00', 2, 'Confirmed'),
('C003', '2024-02-16', '18:00:00', 6, 'Confirmed');

-- =============================================
-- USEFUL VIEWS
-- =============================================

-- View: Order details with customer and staff info
CREATE OR REPLACE VIEW order_details_view AS
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status,
    c.customer_id,
    c.customer_name,
    c.phone as customer_phone,
    s.staff_id,
    s.staff_name,
    s.role as staff_role
FROM orders o
LEFT JOIN customer c ON o.customer_id = c.customer_id
LEFT JOIN staff s ON o.staff_id = s.staff_id;

-- View: Payment summary
CREATE OR REPLACE VIEW payment_summary_view AS
SELECT 
    p.payment_id,
    p.order_id,
    p.amount,
    p.payment_mode,
    p.payment_date,
    p.status,
    o.customer_id,
    o.order_date,
    o.total_amount as order_total
FROM payment p
JOIN orders o ON p.order_id = o.order_id;

-- =============================================
-- END OF DATABASE SETUP
-- =============================================