-- Active: 1755452454828@@127.0.0.1@3306@zomato_v2
CREATE DATABASE if not exists zomato_v2;
use zomato_v2;
-- Customers Table
CREATE TABLE IF NOT EXISTS customers (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255)
);

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Items Table (Menu items)
CREATE TABLE IF NOT EXISTS items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    delivery_address VARCHAR(255) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES customers(user_id)
);

-- Order Items Table (to store multiple items per order)
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Payments Table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO customers (name, email, phone, address) VALUES
('Rahul Sharma', 'rahul@example.com', '9876543210', 'Bangalore, India'),
('Priya Menon', 'priya@example.com', '9123456780', 'Chennai, India'),
('Arjun Patel', 'arjun@example.com', '9988776655', 'Mumbai, India');

INSERT INTO categories (category_name) VALUES
('Starters'),
('Main Course'),
('Desserts'),
('Beverages');


INSERT INTO items (item_name, price, category_id) VALUES
('Paneer Tikka', 250.00, 1),
('Chicken Biryani', 350.00, 2),
('Chocolate Cake', 150.00, 3),
('Mango Lassi', 120.00, 4);

INSERT INTO orders (user_id, delivery_address) VALUES
(1, 'Bangalore, India'),
(2, 'Chennai, India'),
(3, 'Mumbai, India');

INSERT INTO order_items (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 500.00),  -- 2 Paneer Tikkas for Rahul
(1, 4, 1, 120.00),  -- 1 Mango Lassi for Rahul
(2, 2, 1, 350.00),  -- 1 Chicken Biryani for Priya
(3, 3, 3, 450.00);  -- 3 Chocolate Cakes for Arjun


INSERT INTO payments (order_id, amount, payment_status) VALUES
(1, 1120.00, 'Paid'),
(2, 350.00, 'Pending'),
(3, 1350.00, 'Paid');

=================ETL======================;

SELECT 
    cat.category_name,
    SUM(oi.price* oi.quantity) AS total_sales
FROM order_items oi
JOIN items i ON oi.item_id = i.item_id
JOIN categories cat ON i.category_id = cat.category_id
GROUP BY cat.category_name;
/*
1. Total Revenue from All Orders
2. Revenue by Item
3. Revenue by Payment Method
4. Total Revenue by Date
5. Total Orders and Revenue by User
6. Items Ordered by Category
7. Orders by Payment Status
8. Users with Most Orders
9. Revenue by Category
10. Items Purchased in Specific Order
11. Customer Details with Orders
12. Revenue by Customer */

1. Total Revenue from All Orders

select order_id, sum(quantity*price) as total_revenue
from order_items 
group by order_id;

2. Revenue by Item

SELECT i.item_name, sum(oi.quantity*oi.price) as total_revenue
from order_items as oi join items as i on oi.item_id = i.item_id
GROUP BY i.item_name;

4. Total Revenue by Date;
select payment_date, sum(amount) as total_revenue
from payments
group by payment_date;


5. Total Orders and Revenue by User;
select name, count(o.order_id) as total_orders, sum(oi.price * oi.quantity) as total_revenue
from orders as o join customers as c on o.user_id = c.user_id
join order_items as oi on o.order_id = oi.order_id
GROUP BY c.name;

6. Items Ordered by Category;

select c.category_name, i.item_name,sum(oi.quantity) as total
from items as i join categories as c on i.category_id = c.category_id
join order_items as oi on i.item_id = oi.item_id
GROUP BY c.category_name, i.item_name;

7. Orders by Payment Status;

select payment_status, count(order_id) as count_of_orders
from payments
GROUP BY payment_status;

8. Users with Most Orders;
SELECT c.name, count(o.order_id)as orders
from orders as o join customers as c on o.user_id = c.user_id
GROUP BY c.name;
