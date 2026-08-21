-- Active: 1755452454828@@127.0.0.1@3306@indium
use indium;
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    driver_id INT NOT NULL,
    rider_id INT NOT NULL,
    pickup_location VARCHAR(100) NOT NULL,
    dropoff_location VARCHAR(100) NOT NULL,
    ride_date DATETIME NOT NULL,
    fare DECIMAL(10, 2) NOT NULL
);
INSERT INTO rides (ride_id, driver_id, rider_id, pickup_location, dropoff_location, ride_date, fare)
VALUES
(1, 101, 201, 'Chennai', 'Coimbatore', '2024-12-29 08:00:00', 500.00);
SELECT *
from rides;
INSERT INTO rides (ride_id, driver_id, rider_id, pickup_location, dropoff_location, ride_date, fare)
VALUES
(1, 102, 202, 'Bangalore', 'Hyderabad', '2024-12-29 10:00:00', 800.00);
drop TABLE if EXISTS rides;
create table rides(
    ride_id int PRIMARY KEY,
    driver_id int not null,
    rider_id int not null,
    pickup_location VARCHAR(50) not null,
    drop_location VARCHAR(50) not null,
    ride_date DATETIME not null,
    fare DECIMAL(8,2)
);
INSERT INTO rides (ride_id, driver_id, rider_id, pickup_location, drop_location, ride_date, fare)
VALUES
(1, 101, 201, 'Chennai', 'Coimbatore', '2024-12-29 08:00:00', 500.00);

drop TABLE if EXISTS users;
create table users(
    user_id int PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) UNIQUE
);
INSERT into users(email) VALUES
('email1@gmail.com'),
('email2@gmail.com');
SELECT *
from users;
drop table if EXISTS drivers;
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY,
    driver_name VARCHAR(100),
    license_number VARCHAR(50) UNIQUE
);
drop table if EXISTS rides;
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    pickup_location VARCHAR(100),
    dropoff_location VARCHAR(100),
    ride_date DATETIME,
    fare DECIMAL(10, 2),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);
-- Inserting drivers
INSERT INTO drivers (driver_id, driver_name, license_number)
VALUES (101, 'John Doe', 'XYZ12345'), (102, 'Jane Smith', 'ABC67890');
INSERT INTO rides (ride_id, driver_id, pickup_location, dropoff_location, ride_date, fare)
VALUES
(301, 101, 'Chennai', 'Coimbatore', '2024-12-01 08:00:00', 500.00),
(302, 101, 'Chennai', 'Madurai', '2024-12-01 09:30:00', 600.00),
(303, 102, 'Bangalore', 'Hyderabad', '2024-12-02 10:00:00', 700.00);


SELECT r.ride_id, r.pickup_location, r.dropoff_location, r.ride_date, r.fare, d.driver_name
FROM rides r
INNER JOIN drivers d ON r.driver_id = d.driver_id;

INSERT INTO rides (ride_id, driver_id, pickup_location, dropoff_location, ride_date, fare)
VALUES (304, 999, 'Coimbatore', 'Chennai', '2024-12-03 10:00:00', 800.00);

DELETE FROM drivers WHERE driver_id = 101;

drop table if EXISTS rides;
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    pickup_location VARCHAR(100),
    dropoff_location VARCHAR(100),
    ride_date DATETIME,
    fare DECIMAL(10, 2),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DELETE FROM drivers WHERE driver_id = 101;

SELECT *
from drivers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    country VARCHAR(50) DEFAULT 'India'
);


INSERT INTO customers (customer_id, customer_name, country)
VALUES (1, 'John Doe', 'USA');

INSERT INTO customers (customer_id, customer_name)
VALUES (2, 'Jane Smith');

SELECT *
from customers;

CREATE TABLE CustomerData (
    id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(200),
    amount DECIMAL(10, 2)
);

INSERT INTO CustomerData VALUES
(1, 'Ravi', 'ravi@example.com', '98765', 'Chennai', 5000.00),
(2, 'Priya', NULL, '98765', 'Bangalore', NULL),
(3, 'Arjun', 'arjun@example.com', NULL, 'Hyderabad', 1500.00),
(4, 'Meena', NULL, NULL, 'Mumbai', 2500.00),
(5, 'Karthik', 'karthik@example.com', '98765', NULL, 3000.00);

SELECT *,
case 
    when amount > 5000 then 'High Spender'
    when amount between 2000 and 5000 then 'Medium Spender'
    when amount < 2000 then 'Low Spender'
    else 'No Data'
end as Spending_Category,
case 
when email is null and phone_number is null then '93939'
when email is null then phone_number
else email
end as Contact_Details
from customerdata;
CREATE TABLE CustomerTransactions (
    id INT PRIMARY KEY,
    login_device VARCHAR(50),
    customer_name VARCHAR(100),
    ip_address VARCHAR(20),
    product VARCHAR(100),
    amount DECIMAL(10, 2),
    is_placed BOOLEAN,
    is_viewed BOOLEAN,
    transaction_status VARCHAR(20)
);

INSERT INTO CustomerTransactions VALUES
(1, 'Mobile', 'Ravi', '192.168.1.1', 'Laptop', 50000.00, TRUE, FALSE, 'Completed'),
(2, 'Desktop', 'Priya', '192.168.1.2', 'Smartphone', 20000.00, TRUE, TRUE, 'Completed'),
(3, 'Tablet', 'Arjun', '192.168.1.3', 'Headphones', 1500.00, FALSE, TRUE, 'Failed'),
(4, 'Mobile', 'Meena', '192.168.1.4', 'Shoes', 2500.00, TRUE, FALSE, 'Completed'),
(5, 'Desktop', 'Karthik', '192.168.1.5', 'Watch', 5000.00, TRUE, TRUE, 'Completed'),
(6, 'Mobile', 'Sowmya', '192.168.1.6', 'Tablet', 15000.00, TRUE, TRUE, 'Completed'),
(7, 'Tablet', 'Ramesh', '192.168.1.7', 'Smartphone', 25000.00, FALSE, TRUE, 'Failed'),
(8, 'Desktop', 'Divya', '192.168.1.8', 'Laptop', 60000.00, TRUE, FALSE, 'Completed'),
(9, 'Mobile', 'Arun', '192.168.1.9', 'Smartwatch', 12000.00, TRUE, TRUE, 'Completed'),
(10, 'Tablet', 'Deepa', '192.168.1.10', 'Laptop', 55000.00, FALSE, FALSE, 'Pending');

INSERT INTO CustomerTransactions VALUES
(11, 'Tablet', 'Deepa', '192.168.1.10', 'Laptop',null, FALSE, FALSE, 'Pending');
SELECT count(*)
from customertransactions
where lower(transaction_status) not in ('failed', 'pending');

SELECT login_device, round(avg(amount),2) as avg_amount
from customertransactions
GROUP BY login_device;

SELECT COALESCE(amount,0) as amount, CONCAT(transaction_status,' - ', COALESCE(amount,0)) as dummy
from customertransactions;

CREATE TABLE Sales (
    TransactionID INT,
    Store VARCHAR(50),
    SalesAmount DECIMAL(10, 2)
);

INSERT INTO Sales (TransactionID, Store, SalesAmount)
VALUES
    (1, 'A', 100.00),
    (2, 'A', 200.00),
    (3, 'A', 150.00),
    (4, 'B', 250.00),
    (5, 'B', 300.00);
SELECT *, sum(SalesAmount)over(PARTITION BY Store) as total_amount
from sales;
drop table if exists students;
CREATE TABLE Students (
    StudentID INT,
    StudentName VARCHAR(100),
    ExamScore INT
);

INSERT INTO Students (StudentID, StudentName, ExamScore)
VALUES
    (1, 'Alice', 95),
    (2, 'Bob', 90),
    (3, 'Charlie', 95),
    (4, 'David', 85),
    (5, 'Eva', 90);
SELECT *, DENSE_RANK()over(order by ExamScore Desc) as rnk
from Students;

SELECT *, RANK()over(order by ExamScore Desc) as rnk
from Students;

SELECT *, ROW_NUMBER()over(order by ExamScore Desc) as rnk
from Students;

CREATE TABLE EmployeeSales (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    SalesAmount DECIMAL(10, 2)
);


INSERT INTO EmployeeSales (EmployeeID, EmployeeName, SalesAmount) VALUES
(1, 'Alice', 10000),
(2, 'Bob', 8500),
(3, 'Charlie', 7500),
(4, 'David', 6000),
(5, 'Eva', 11000),
(6, 'Frank', 4500),
(7, 'Grace', 3000),
(8, 'Hank', 4000),
(9, 'Ivy', 8000),
(10, 'Jack', 9500);

SELECT *, NTILE(3) over(ORDER by SalesAmount desc) as tile
from EmployeeSales;
PERCENT_RANK
----------------

CREATE TABLE ProductSales (
    ProductID INT,
    ProductName VARCHAR(100),
    SalesAmount INT
);


INSERT INTO ProductSales (ProductID, ProductName, SalesAmount) VALUES
(1, 'Product 1', 500),
(2, 'Product 2', 600),
(3, 'Product 3', 550),
(4, 'Product 4', 700),
(5, 'Product 5', 750),
(6, 'Product 6', 800),
(7, 'Product 7', 850),
(8, 'Product 8', 900),
(9, 'Product 9', 950),
(10, 'Product 10', 1000),
(11, 'Product 11', 600),
(12, 'Product 12', 650),
(13, 'Product 13', 700),
(14, 'Product 14', 750),
(15, 'Product 15', 800),
(16, 'Product 16', 850),
(17, 'Product 17', 900),
(18, 'Product 18', 950),
(19, 'Product 19', 1000),
(20, 'Product 20', 100),
(21, 'Product 21', 200),
(22, 'Product 22', 250),
(23, 'Product 23', 300),
(24, 'Product 24', 350),
(25, 'Product 25', 400),
(26, 'Product 26', 450),
(27, 'Product 27', 500),
(28, 'Product 28', 550),
(29, 'Product 29', 600),
(30, 'Product 30', 650),
(31, 'Product 31', 700),
(32, 'Product 32', 750),
(33, 'Product 33', 800),
(34, 'Product 34', 850),
(35, 'Product 35', 900),
(36, 'Product 36', 950),
(37, 'Product 37', 1000),
(38, 'Product 38', 550),
(39, 'Product 39', 600),
(40, 'Product 40', 650),
(41, 'Product 41', 700),
(42, 'Product 42', 750),
(43, 'Product 43', 800),
(44, 'Product 44', 850),
(45, 'Product 45', 900),
(46, 'Product 46', 950),
(47, 'Product 47', 1000),
(48, 'Product 48', 550),
(49, 'Product 49', 600),
(50, 'Product 50', 650);

SELECT ProductID, ProductName, SalesAmount,
       PERCENT_RANK() OVER (ORDER BY SalesAmount DESC) AS PercentRank,
       RANK() OVER (ORDER BY SalesAmount DESC) AS Rank_s
FROM ProductSales;
LAG
----------------
drop table if exists EmployeeSalaries;
CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2),
    Year INT
);
INSERT INTO EmployeeSalaries (EmployeeID, EmployeeName, Salary, Year) VALUES
(1, 'Alice', 5000, 2023),
(1, 'Alice', 5500, 2024),
(2, 'Bob', 4500, 2023),
(2, 'Bob', 4800, 2024),
(3, 'Charlie', 4000, 2023),
(3, 'Charlie', 4200, 2024),
(4, 'David', 4600, 2023),
(4, 'David', 4700, 2024),
(5, 'Eva', 5200, 2023),
(5, 'Eva', 5400, 2024);
with cte as (
SELECT *, lag(`Salary`,1)over(PARTITION BY `EmployeeName` ORDER BY `Year`) as prev_year_salary
from EmployeeSalaries)
SELECT `EmployeeName`,Salary -  prev_year_salary as diff
from cte
where Salary > prev_year_salary;
CREATE TABLE SalesData (
    SaleID INT,
    EmployeeName VARCHAR(100),
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO SalesData (SaleID, EmployeeName, SaleAmount, SaleDate) VALUES
(1, 'Alice', 5000, '2025-01-01'),
(2, 'Bob', 3000, '2025-01-02'),
(3, 'Charlie', 4000, '2025-01-03'),
(4, 'David', 4500, '2025-01-04'),
(5, 'Eva', 5500, '2025-01-05');
SELECT *,lead(`SaleAmount`,1)over(order by `SaleDate`) as next_day_amount
from salesdata;

drop table if exists EmployeeSalaries;
CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2),
    Year INT
);
INSERT INTO EmployeeSalaries (EmployeeID, EmployeeName, Salary, Year) VALUES
(1, 'Alice', 5000, 2021),
(1, 'Alice', 5500, 2022),
(1, 'Alice', 6000, 2023),
(1, 'Alice', 6500, 2024),
(1, 'Alice', 7000, 2025),
(2, 'Bob', 4500, 2023),
(2, 'Bob', 4800, 2024),
(3, 'Charlie', 4000, 2023),
(3, 'Charlie', 4200, 2024),
(4, 'David', 4600, 2023),
(4, 'David', 4700, 2024),
(5, 'Eva', 5200, 2023),
(5, 'Eva', 5400, 2024);
SELECT *, FIRST_VALUE(`Salary`)over(PARTITION BY `EmployeeName` ORDER BY Year) as first_salary
from EmployeeSalaries;

SELECT EmployeeID, EmployeeName, Salary,
       NTH_VALUE(Salary, 2) OVER (PARTITION BY EmployeeID ORDER BY year) AS ThirdSalary
FROM EmployeeSalaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS contractors;
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    position    VARCHAR(50),
    salary      DECIMAL(10,2)
);

CREATE TABLE contractors (
    contractor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    position      VARCHAR(50),
    hourly_rate   DECIMAL(10,2)
);

INSERT INTO employees (first_name, last_name, position, salary)
VALUES
('Alice', 'Smith', 'Developer', 70000.00),
('Bob', 'Johnson', 'Developer', 75000.00),
('Charlie', 'Lee', 'Manager', 90000.00);

INSERT INTO contractors (first_name, last_name, position, hourly_rate)
VALUES
('Dave', 'Williams', 'Developer', 40.00),
('Eve', 'Brown', 'Tester', 35.00),
('Bob', 'Johnson', 'Developer', 45.00);

SELECT first_name
from employees
union 
SELECT first_name
from contractors;


DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL
);

CREATE INDEX idx_email ON customers (email);


INSERT INTO customers (first_name, last_name, email, city)
VALUES
('John', 'Doe', 'john@example.com', 'New York'),
('Jane', 'Smith', 'jane.smith@example.com', 'Los Angeles'),
('Michael', 'Brown', 'michael.brown@example.com', 'Chicago'),
('Emily', 'Johnson', 'emily.johnson@example.com', 'Houston'),
('Robert', 'Green', 'robert.green@example.com', 'Phoenix');

select * from customers where email='john@example.com' ;


EXPLAIN
SELECT *
FROM customers
WHERE email = 'john@example.com';


EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE email = 'john@example.com';
DROP TABLE IF EXISTS orders;


CREATE TABLE orders (
    order_id   INT AUTO_INCREMENT ,
    order_date DATE NOT NULL, 
    customer_name VARCHAR(50),
    amount     DECIMAL(10,2),
PRIMARY KEY(order_id, order_date)
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p_before_2020 VALUES LESS THAN (2020),
    PARTITION p_2020       VALUES LESS THAN (2021),
    PARTITION p_2021       VALUES LESS THAN (2022),
    PARTITION p_2022       VALUES LESS THAN (2023),
    PARTITION p_future     VALUES LESS THAN MAXVALUE
);

INSERT INTO orders (order_date, customer_name, amount)
VALUES
('2019-05-10', 'Alice', 100.00),
('2020-01-15', 'Bob', 200.50),
('2020-12-01', 'Charlie', 300.00),
('2021-07-20', 'Diana', 150.75),
('2022-03-02', 'Edward', 500.00),
('2025-06-18', 'FutureMan', 9999.99);
SELECT 
    PARTITION_NAME,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    SUBPARTITION_METHOD,
    SUBPARTITION_EXPRESSION
FROM information_schema.PARTITIONS
WHERE TABLE_SCHEMA = 'indium'
  AND TABLE_NAME   = 'orders';

drop table if exists quarterly_sales;
CREATE TABLE quarterly_sales (
    year INT,
    quarter VARCHAR(2),
    sales INT
);
-- Insert data
INSERT INTO quarterly_sales (year, quarter, sales) VALUES
(2024, 'Q1', 1000),
(2024, 'Q1', 5000),
(2024, 'Q2', 1500),
(2024, 'Q3', 1200),
(2024, 'Q3', 1800),
(2024, 'Q4', 1800),
(2025, 'Q1', 1100),
(2025, 'Q2', 1400),
(2025, 'Q2', 1600);

SELECT year,
sum(case when quarter= 'Q1' then sales else 0 end) as Q1_Sales,
sum(case when quarter= 'Q2' then sales else 0 end) as Q2_Sales,
sum(case when quarter= 'Q3' then sales else 0 end) as Q3_Sales,
sum(case when quarter= 'Q4' then sales else 0 end) as Q4_Sales
from quarterly_sales
GROUP BY year;

drop table if EXISTS sales;
create table sales (
    year int,
    Q1_Sales int,
    Q2_Sales int,
    Q3_Sales int,
    Q4_Sales int
);
insert into sales values
(2024,2000,3000,2400,3600),
(2025,2200,3200,0,0);

SELECT year, "Q1" as Quarter, Q1_sales as sales from sales
union ALL
SELECT year, "Q2" as Quarter, Q2_sales as sales from sales;


use indium;
drop table if exists users;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50)
);
drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
-- Users
INSERT INTO users (user_id, name) VALUES
(1, 'Santhosh'),
(2, 'Rahul'),
(3, 'Priya'),
(4, 'Ankit'),
(5, 'Neha'),
(6, 'Kiran');

SELECT *
from orders;
-- Orders
INSERT INTO orders (order_id, user_id, order_date) VALUES
-- User 1 → ONLY old orders (inactive)
(101, 1, '2023-01-10'),
-- User 2 → recent order (active)
(102, 2, CURDATE() - INTERVAL 2 MONTH),
-- User 3 → multiple orders (old + recent → active)
(103, 3, '2023-02-15'),
(104, 3, CURDATE() - INTERVAL 1 MONTH),
-- User 4 → NO orders (inactive)
-- User 5 → exactly borderline (6 months ago)
(105, 5, CURDATE() - INTERVAL 6 MONTH),
-- User 6 → multiple old orders (inactive)
(106, 6, '2022-05-01'),
(107, 6, '2023-03-01');
-- Find the users who did not order in the past 6 months
with cte as(
SELECT u.user_id,o.order_date, row_number()over(partition by u.user_id order by order_date desc) as rn
from users as u left join orders as o on u.user_id = o.user_id)
SELECT *
from cte
where (rn = 1) and (order_date <= now() - interval 6 month or order_date is null);
--You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

-- Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.

use indium;
DROP TABLE IF EXISTS Students;
CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
);

DROP TABLE IF EXISTS friends;
CREATE TABLE Friends (
    ID INT,
    Friend_ID INT,
    FOREIGN KEY (ID) REFERENCES Students(ID),
    FOREIGN KEY (Friend_ID) REFERENCES Students(ID)
);

drop table if exists Packages;
CREATE TABLE Packages (
    Student_ID INT PRIMARY KEY,
    Salary INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(ID)
);



INSERT INTO Students (ID, Name)
VALUES
(1, 'gowtham'),
(2, 'rahul'),
(3, 'saravana'),
(4, 'nandini'),
(5, 'jaya');

INSERT INTO Friends (ID, Friend_ID)
VALUES
(1, 2),  
(2, 1),  
(3, 4), 
(4, 3),  
(5, 3); 

INSERT INTO Packages (Student_ID, Salary)
VALUES
(1, 40),  
(2, 50),  
(3, 60), 
(4, 70),  
(5, 55);  

SELECT *
from (
SELECT s.`Name`,f.`ID` as friend_1, f.`Friend_ID`as friend_2, p.`Salary` as friend1_salary, p2.`Salary` as Friend2_salary
from Friends as f join packages as p on f.`ID` = p.`Student_ID`
join packages as p2 on f.`Friend_ID` = p2.`Student_ID`
join Students as s on s.`ID` = p.`Student_ID` ) as X
where X.friend2_salary > X.friend1_salary;

drop table if exists orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    RestaurantID INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2),
    Foreign Key (CustomerID) REFERENCES Customers(CustomerID),
    foreign key (RestaurantID) references Restaurants(RestaurantID)
);

CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY,
    RestaurantName VARCHAR(255),
    Location VARCHAR(255)
);
drop table if exists customers;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    Location VARCHAR(255)
);

INSERT INTO Restaurants (RestaurantID, RestaurantName, Location) VALUES
(1, 'Spicy Delight', 'Downtown'),
(2, 'Green Veggies', 'Uptown'),
(3, 'Burger Bonanza', 'Midtown');

INSERT INTO Customers (CustomerID, CustomerName, Location) VALUES
(1, 'John Doe', 'Downtown'),
(2, 'Jane Smith', 'Midtown'),
(3, 'Alice Green', 'Uptown');

INSERT INTO Orders (OrderID, CustomerID, RestaurantID, OrderDate, Amount) VALUES
(1, 1, 1, '2024-09-01', 25.50),
(2, 2, 3, '2024-09-02', 15.00),
(3, 1, 2, '2024-09-03', 12.75),
(4, 3, 2, '2024-09-04', 22.00),
(5, 1, 1, '2024-09-05', 30.00);

/*Write an SQL query to create a report that shows:

Each restaurant's name.
The popularity of the restaurant, defined as the total number of orders it received.
A rating for each restaurant such that:
If the restaurant has more than 3 orders, assign a rating of 5.
Otherwise, assign a rating of 1.
Create this result as a new table called report.
*/
with cte as (
SELECT `RestaurantName`, count(o.`OrderID`) as orders
from restaurants as r left join orders as o on r.`RestaurantID` = o.`RestaurantID`
GROUP BY `RestaurantName`)
SELECT *, 
case when orders >= 2 then 5 else 1 end as Ratings
from cte;

CREATE TABLE store_sales (
    id int AUTO_INCREMENT PRIMARY key,
    store_name VARCHAR(50),
    total_sales INT
);

INSERT INTO store_sales (store_name, total_sales) VALUES
('BigMart',     1200),
('FreshMart',    850),
('DailyNeeds',   950),
('SuperStore',  1300),
('QuickBuy',     700),
('FreshMart',    900),
('BigMart',     1100),
('DailyNeeds',  1050),
('SuperStore',  1250),
('QuickBuy',     750);

-- Find stores whose sales where better than the average sales across all the stores.
SELECT DISTINCT store_name
from(
SELECT *, sum(total_sales)over(PARTITION BY store_name) as total_store_sales,avg(total_sales)over() as avg_sales
from store_sales) as X
where X.total_store_sales > X.avg_sales;
drop table if EXISTS Orders;
CREATE TABLE Orders (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT
);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES
(1, '2024-01-01', 1),
(2, '2024-01-02', 1),
(3, '2024-02-04', 2),
(4, '2024-02-06', 2),
(5, '2024-02-07', 3),
(6, '2024-02-08', 3);

--Write a SQL query to find the customers who have placed orders on consecutive days.
SELECT DISTINCT `CustomerID`
from(
SELECT *, datediff(`OrderDate`,lag(`OrderDate`,1) over(PARTITION BY `CustomerID` ORDER BY `OrderDate`)) as diff
from orders) as X
where X.diff = 1;

CREATE TABLE orders_new (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT
);
-- Customer 101: 4-day streak (2025-08-01 to 2025-08-04)
INSERT INTO orders_new (OrderID, OrderDate, CustomerID) VALUES
(1001, '2025-08-01', 101),
(1002, '2025-08-02', 101),
(1003, '2025-08-03', 101),
(1004, '2025-08-04', 101);

-- Customer 102: 3-day streak (2025-07-10 to 2025-07-12)
INSERT INTO orders_new (OrderID, OrderDate, CustomerID) VALUES
(1005, '2025-07-10', 102),
(1006, '2025-07-11', 102),
(1007, '2025-07-12', 102);

-- Customer 103: Non-streak orders_new (spaced out)
INSERT INTO orders_new (OrderID, OrderDate, CustomerID) VALUES
(1008, '2025-06-01', 103),
(1009, '2025-06-03', 103),
(1010, '2025-06-05', 103);

-- Customer 104: 5-day streak (2025-09-01 to 2025-09-05)
INSERT INTO orders_new (OrderID, OrderDate, CustomerID) VALUES
(1011, '2025-09-01', 104),
(1012, '2025-09-02', 104),
(1013, '2025-09-03', 104),
(1014, '2025-09-04', 104),
(1015, '2025-09-05', 104);



#### Write a SQL query to find the customers who have placed orders on 3 consecutive days.
with cte as (
SELECT *, DATEDIFF(`OrderDate`,prev_order_date) as diff1, datediff(prev_order_date, prev_prev_order_date) as diff2
from(
SELECT *, lag(`OrderDate`,1)over(PARTITION BY `CustomerID` ORDER BY `OrderDate`) as prev_order_date,
lag(`OrderDate`,2)over(PARTITION BY `CustomerID` ORDER BY `OrderDate`) as prev_prev_order_date
from orders_new) as X)
SELECT DISTINCT `CustomerID`
from cte
where diff1 = 1 and diff2 = 1;
CREATE TABLE nodes (
    n INT PRIMARY KEY,
    p INT
);

-- Insert sample data to demonstrate all three node types:
-- 1. Root node (n=1) has a NULL parent.
-- 2. Inner nodes (n=2, n=3) have a parent and children.
-- 3. Leaf nodes (n=4, n=5, n=6) have a parent but no children.
INSERT INTO nodes (n, p) VALUES
(1, NULL),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 3);

SELECT n,
case 
    when p is null then 'root' 
     when n not in (select distinct p from nodes where p is not null) then 'leaf'
    else 'child' 
    end as nodes
from nodes;
drop table if exists sales_v2;
CREATE TABLE sales_v2 (
    CustomerNumber INT,
    ProductNumber INT,
    PartNumber VARCHAR(255),
    OrderDate DATE,
    OrderNumber FLOAT,
    ShippedQuantity INT
);
INSERT INTO sales_v2 (CustomerNumber, ProductNumber, PartNumber, OrderDate, OrderNumber, ShippedQuantity)
VALUES
(101, 201, 'A123', '2024-01-15', 301.0, 5),
(101, 202, 'B456', '2024-02-20', 302.0, 3),
(102, 203, 'C789', '2024-03-10', 303.0, 10),
(101, 201, 'A123', '2024-03-15', 304.0, 2),
(103, 204, 'D012', '2024-04-05', 305.0, 7),
(102, 203, 'C789', '2024-05-01', 306.0, 8),
(101, 205, 'E345', '2024-06-30', 307.0, 1),
(104, 206, 'F678', '2024-07-15', 308.0, 4),
(101, 201, 'A123', '2025-09-01', 309.0, 6);
-- How to Identify Customers Whose Gap Since the Last Order is Greater Than Their Largest Historical Gap Between Orders

with cte1 as (
SELECT *, max(diff)over(PARTITION BY `CustomerNumber`) as max_diff
from (
SELECT  `CustomerNumber`, OrderDate, DATEDIFF(`OrderDate`,lag(`OrderDate`,1)over(PARTITION BY `CustomerNumber` ORDER BY `OrderDate`)) as diff
from sales_v2
order by `CustomerNumber`, OrderDate) as X),
cte2 as (
SELECT *, FIRST_VALUE(`OrderDate`)over(PARTITION BY `CustomerNumber` order by `OrderDate` desc) as last_order,
DATEDIFF(CURRENT_DATE(),FIRST_VALUE(`OrderDate`)over(PARTITION BY `CustomerNumber` order by `OrderDate` desc)) as latest_diff
from cte1)
SELECT DISTINCT `CustomerNumber`
from cte2
where latest_diff > max_diff;
CREATE TABLE bakery_sales (
    Day_of_Week VARCHAR(10),
    Product VARCHAR(50),
    Type VARCHAR(20),
    Quantity INT,
    Price DECIMAL(5, 2)
);

-- Insert Queries
INSERT INTO bakery_sales (Day_of_Week, Product, Type, Quantity, Price) VALUES
('Monday', 'Croissant', 'Pastry', 20, 2.5),
('Monday', 'Baguette', 'Bread', 15, 3),
('Monday', 'Muffin', 'Pastry', 18, 2),
('Tuesday', 'Donut', 'Pastry', 25, 1.5),
('Tuesday', 'Brownie', 'Dessert', 10, 2.8),
('Tuesday', 'Cupcake', 'Dessert', 12, 3.2),
('Wednesday', 'Croissant', 'Pastry', 22, 2.5),
('Wednesday', 'Baguette', 'Bread', 14, 3),
('Wednesday', 'Muffin', 'Pastry', 19, 2),
('Thursday', 'Donut', 'Pastry', 30, 1.5),
('Thursday', 'Brownie', 'Dessert', 15, 2.8),
('Thursday', 'Cupcake', 'Dessert', 18, 3.2),
('Friday', 'Croissant', 'Pastry', 25, 2.5),
('Friday', 'Baguette', 'Bread', 18, 3),
('Friday', 'Muffin', 'Pastry', 21, 2),
('Saturday', 'Donut', 'Pastry', 27, 1.5),
('Saturday', 'Brownie', 'Dessert', 12, 2.8),
('Saturday', 'Cupcake', 'Dessert', 14, 3.2),
('Sunday', 'Croissant', 'Pastry', 28, 2.5),
('Sunday', 'Baguette', 'Bread', 16, 3),
('Sunday', 'Muffin', 'Pastry', 20, 2);

SELECT `Day_of_Week`,
sum(case when `Type` = 'Pastry' then (`Quantity` * `Price`) else 0 end) as Pastry,
sum(case when `Type` = 'Bread' then (`Quantity` * `Price`) else 0 end) as Bread,
sum(case when `Type` = 'Dessert' then (`Quantity` * `Price`) else 0 end) as Dessert
from bakery_sales
GROUP BY `Day_of_Week`;
drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount INT
);

-- Insert values
INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 100, '2022-01-01', 2000),
(2, 200, '2022-01-01', 2500),
(3, 300, '2022-01-01', 2100),
(4, 100, '2022-01-02', 2000),
(5, 400, '2022-01-02', 2200),
(6, 500, '2022-01-02', 2700),
(7, 100, '2022-01-03', 3000),
(8, 400, '2022-01-03', 1000),
(9, 600, '2022-01-03', 3000);

--find the number of new customers and existing customers for each order date.
with first_order as (
SELECT customer_id, min(order_date) as first_order_date
from orders
GROUP BY customer_id)
SELECT order_date,
count(distinct case when type = 'new' then customer_id end) as new_type,
count(distinct case when type = 'old' then customer_id end) as old_type
from(
SELECT f.customer_id, f.first_order_date,o.order_date,
case when f.first_order_date = o.order_date then 'new' else 'old' end as type
from first_order as f join orders as o on f.customer_id = o.customer_id) as X
GROUP BY order_date;
SELECT *
from orders;

with cte as (
SELECT *, 
case when x.rn = 1 then 'New' else 'Old' end as type
from(
SELECT *, ROW_NUMBER()over(PARTITION BY customer_id ORDER BY order_date) as rn
FROM orders) as x
ORDER BY customer_id)
SELECT DATE_FORMAT(order_date,'%M-%Y') as order_date,
sum(case when type = 'New' then order_amount else 0 end) new_customer_revenue,
sum(case when type = 'Old' then order_amount else 0 end) as old_customer_revenue
from cte
GROUP BY DATE_FORMAT(order_date,'%M-%Y');

CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) CHECK (order_status IN ('Delivered', 'Returned')),
    amount DECIMAL(10,2) NOT NULL
);
INSERT INTO customer_orders (order_id, customer_id, order_date, order_status, amount) VALUES
(1, 'C001', '2025-04-05', 'Delivered', 1200),
(2, 'C001', '2025-05-10', 'Returned', 800),
(3, 'C001', '2025-06-12', 'Delivered', 1500),
(4, 'C001', '2025-07-20', 'Returned', 900),
(5, 'C001', '2025-08-25', 'Delivered', 1000),
(6, 'C002', '2025-05-14', 'Delivered', 2000),
(7, 'C002', '2025-06-11', 'Delivered', 1800),
(8, 'C002', '2025-07-10', 'Returned', 900),
(9, 'C003', '2025-08-05', 'Delivered', 1700);

-- 2. Find Flipkart customers who returned more than 20% of orders in the last 12 months;
SELECT customer_id,
round(count(case when order_status = 'Returned' then order_id end)*100 / count(order_id) ,2) as return_perc
from customer_orders
where order_date >= CURRENT_DATE() - interval 12 month
GROUP BY customer_id;
drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    category VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);
INSERT INTO orders (order_id, customer_id, product_id, category, order_date, amount) VALUES
(1, 'C001', 'P001', 'Electronics', '2025-07-05', 12000),
(2, 'C001', 'P002', 'Fashion', '2025-07-15', 2500),
(3, 'C002', 'P003', 'Electronics', '2025-08-01', 8000),
(4, 'C002', 'P004', 'Electronics', '2025-08-10', 2000),
(5, 'C002', 'P005', 'Fashion', '2025-09-05', 1500),
(6, 'C003', 'P006', 'Fashion', '2025-06-15', 600),
(7, 'C003', 'P007', 'Electronics', '2025-06-18', 1000),
(8, 'C004', 'P008', 'Electronics', '2025-07-01', 2000),
(9, 'C004', 'P009', 'Fashion', '2025-08-02', 1800);

-- Identify Flipkart customers who purchased Electronics and Fashion items in the same month ;
SELECT DATE_FORMAT(order_date, '%m-%Y'), customer_id
from orders
where category in ('Fashion','Electronics')
GROUP BY DATE_FORMAT(order_date, '%m-%Y'), customer_id
HAVING count(*) = 2;

drop table if exists customer_orders;

CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) CHECK (order_status IN ('Delivered', 'Returned'))
);

INSERT INTO customer_orders (order_id, customer_id, order_date, order_status) VALUES
(1, 'C001', '2025-07-05', 'Delivered'),
(2, 'C001', '2025-07-12', 'Returned'),
(3, 'C001', '2025-08-20', 'Returned'),
(4, 'C001', '2025-09-01', 'Delivered'),
(5, 'C001', '2025-09-15', 'Delivered'),
(6, 'C002', '2025-07-10', 'Delivered'),
(7, 'C002', '2025-08-15', 'Delivered'),
(8, 'C002', '2025-09-20', 'Delivered'),
(9, 'C003', '2025-07-02', 'Returned'),
(10, 'C003', '2025-08-05', 'Returned'),
(11, 'C003', '2025-09-10', 'Returned'),
(12, 'C004', '2025-09-28', 'Delivered'),
(13, 'C004', '2025-09-30', 'Returned');
drop table if EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL
);

INSERT INTO orders (order_id, restaurant_name, order_date) VALUES
(1, 'Domino’s', '2025-05-01'),
(2, 'Domino’s', '2025-05-10'),
(3, 'Domino’s', '2025-06-05'),
(4, 'Domino’s', '2025-06-20'),
(5, 'Domino’s', '2025-07-12'),
(6, 'Domino’s', '2025-08-03'),
(7, 'Domino’s', '2025-08-10'),

(8, 'KFC', '2025-05-15'),
(9, 'KFC', '2025-06-20'),
(10, 'KFC', '2025-07-25'),
(11, 'KFC', '2025-08-05'),

(12, 'Subway', '2025-05-05'),
(13, 'Subway', '2025-06-05'),
(14, 'Subway', '2025-07-05'),
(15, 'Subway', '2025-08-05');

-- Find Zomato restaurants with increasing monthly order counts for 4 consecutive months
with monthly_orders as (
SELECT restaurant_name, date_format(order_date,'%m-%Y') as order_month,count(order_id) as monthly_orders_count
from orders
group by restaurant_name, date_format(order_date,'%m-%Y')),
count as (
SELECT *, lead(monthly_orders_count,1)over(PARTITION BY restaurant_name order by order_month) as lead_1,
lead(monthly_orders_count,2)over(PARTITION BY restaurant_name order by order_month) as lead_2,
lead(monthly_orders_count,3)over(PARTITION BY restaurant_name order by order_month) as lead_3
from monthly_orders)
SELECT distinct restaurant_name
from count
WHERE monthly_orders_count <=  lead_1 <= lead_2 <= lead_3




