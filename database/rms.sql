CREATE DATABASE rms;
USE rms;

-- Customer Table
CREATE TABLE customer (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
customer_name VARCHAR(50),
phone VARCHAR(15)
);

-- Staff Table
CREATE TABLE staff (
staff_id INT PRIMARY KEY AUTO_INCREMENT,
staff_name VARCHAR(50),
role VARCHAR(50)
);

-- Menu Table
CREATE TABLE menu (
menu_id INT PRIMARY KEY AUTO_INCREMENT,
item_name VARCHAR(50),
price INT
);

-- Orders Table
CREATE TABLE orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
staff_id INT,
order_date DATE,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Payment Table
CREATE TABLE payment (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
amount INT,
payment_mode VARCHAR(20),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
