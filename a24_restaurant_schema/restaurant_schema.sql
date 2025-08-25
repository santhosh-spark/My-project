CREATE DATABASE mock_restaurant_a24; 
USE mock_restaurant_a24;

-- Drop existing tables if any
DROP TABLE IF EXISTS bookings, order_items, orders, menu_items, reservations, table_availability, branches, restaurants;

-- Restaurant Table
CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL
);

-- Branches Table
CREATE TABLE branches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT, 
    branch_code INT,
    branch_name VARCHAR(255),
    branch_address VARCHAR(255),
    is_main_branch BOOLEAN,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Table Availability
CREATE TABLE table_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    branch_id INT,
    table_number INT,
    is_available BOOLEAN,
    seats INT,
    date_slot DATE,
    time_slot TIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

-- Reservations
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    branch_id INT,
    table_id INT,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(20),
    reservation_time DATETIME,
    status ENUM('confirmed', 'cancelled', 'pending') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (table_id) REFERENCES table_availability(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

-- Menu Items
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    branch_id INT,
    dishname VARCHAR(100),
    description TEXT,
    price DECIMAL(6,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

-- Orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    restaurant_id INT,
    branch_id INT,
    order_time DATETIME,
    status ENUM('placed', 'completed', 'cancelled') DEFAULT 'placed',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Order Items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    restaurant_id INT,
    branch_id INT,
    menu_item_id INT,
    quantity INT,
    price DECIMAL(6,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Bookings (Alternative to reservations – optional)
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    branch_id INT,
    table_id INT,
    date_slot DATE,
    time_slot TIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (table_id) REFERENCES table_availability(id));


