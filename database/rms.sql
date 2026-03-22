-- Create database
CREATE DATABASE IF NOT EXISTS rms;
USE rms;

-- Table: customer
CREATE TABLE IF NOT EXISTS customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Table: staff
CREATE TABLE IF NOT EXISTS staff (
    staff_id VARCHAR(50) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Table: orders
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    staff_id VARCHAR(50),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- Table: menu
CREATE TABLE IF NOT EXISTS menu (
    menu_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Table: payment
CREATE TABLE IF NOT EXISTS payment (
    payment_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    payment_mode VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Optional: Insert some sample data
-- Sample Customers
INSERT INTO customer (customer_id, customer_name, phone) VALUES
('C001', 'John Doe', '9876543210'),
('C002', 'Jane Smith', '9876543211'),
('C003', 'Mike Johnson', '9876543212');

-- Sample Staff
INSERT INTO staff (staff_id, staff_name, role) VALUES
('S001', 'Alice Brown', 'Manager'),
('S002', 'Bob Wilson', 'Chef'),
('S003', 'Charlie Davis', 'Waiter');

-- Sample Menu Items
INSERT INTO menu (menu_id, item_name, price) VALUES
('M001', 'Margherita Pizza', 299.99),
('M002', 'Chicken Burger', 199.99),
('M003', 'Caesar Salad', 149.99),
('M004', 'Pasta Alfredo', 249.99),
('M005', 'Cold Coffee', 99.99);

-- Sample Orders
INSERT INTO orders (order_id, customer_id, staff_id, order_date) VALUES
('ORD001', 'C001', 'S003', '2024-01-15'),
('ORD002', 'C002', 'S003', '2024-01-16'),
('ORD003', 'C003', 'S003', '2024-01-17');

-- Sample Payments
INSERT INTO payment (payment_id, order_id, amount, payment_mode) VALUES
('PAY001', 'ORD001', 299.99, 'Credit Card'),
('PAY002', 'ORD002', 199.99, 'Cash'),
('PAY003', 'ORD003', 399.98, 'UPI');
