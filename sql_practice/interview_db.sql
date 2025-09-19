-- Active: 1755452454828@@127.0.0.1@3306@interview_db
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT,
    join_date DATE,
    salary DECIMAL(10,2),
    department VARCHAR(50),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO employees (emp_id, emp_name, manager_id, join_date, salary, department) VALUES
(1, 'Alice',   NULL, '2015-01-10', 90000, 'HR'),
(2, 'Bob',      1,   '2016-03-15', 75000, 'HR'),
(3, 'Charlie',  1,   '2014-11-12', 80000, 'Finance'),
(4, 'David',    2,   '2017-05-22', 60000, 'Finance'),
(5, 'Eve',      2,   '2018-07-19', 62000, 'Finance'),
(6, 'Frank',    3,   '2013-08-01', 95000, 'IT'),
(7, 'Grace',    3,   '2016-09-14', 70000, 'IT'),
(8, 'Heidi',    6,   '2019-10-05', 50000, 'IT'),
(9, 'Ivan',     6,   '2020-12-20', 52000, 'Finance'),
(10,'Judy',     7,   '2021-01-25', 48000, 'HR');


select *
from employees;

#Find employees who joined before their managers.
select e.emp_name
FROM employees as e join employees as m on e.manager_id = m.emp_id and e.join_date < m.join_date;

# List managers who have at least one report that joined earlier.

select DISTINCT m.emp_name
FROM employees as e join employees as m on e.manager_id = m.emp_id and e.join_date < m.join_date;

# Find employees who have the same manager.

SELECT e1.emp_name, e2.emp_name, m.emp_name as manager_name
from employees as e1 join employees as e2 on e1.manager_id = e2.manager_id and e1.emp_id < e2.emp_id 
join employees as m on e1.manager_id = m.emp_id;

# Find pairs of employees where one earns more than the other but both are in the same department.
select e1.emp_name as high_emp_salary, e1.salary,e2.emp_name as lower_emp_salary,e2.salary, e1.department
from employees as e1 join employees as e2 on e1.department = e2.department and e1.salary > e2.salary

#Find employees whose manager is in a different department.
SELECT e.emp_name as employee_name, e.department as emp_department, m.emp_name as mananger_name, m.department as manager_department
FROM employees as e join employees as m on e.manager_id = m.emp_id and e.department != m.department

======================section B===============================================;

#Find the average salary per department.
select department, round(avg(salary),2) as avg_salary
from employees
GROUP BY department;

#Find departments with more than 2 employees.
select department, count(*)
from employees
GROUP BY department
having count(*)> 2

#Find the highest-paid employee in each department.
SELECT x.emp_name, x.department
from (
select *, DENSE_RANK()over(PARTITION BY department ORDER BY salary desc) as rnk
from employees) as x
where x.rnk = 1;

# Find managers who manage more than 2 employees.

SELECT m.emp_name, count(*)
from employees as e join employees as m on e.manager_id = m.emp_id
GROUP BY m.emp_name
having count(e.emp_id)>2

#Find the department with the earliest joiner.

select x.department, x.emp_name, x.join_date
from (
SELECT *, DENSE_RANK()over(PARTITION BY department ORDER BY join_date) as rnk
FROM employees) as x
where x.rnk = 1;

#11. Find employees who earn **more than the average salary** of their department.
SELECT x.emp_name
FROM(
SELECT *, avg(salary)over(PARTITION BY department) as dept_avg_salary
FROM employees) as x
where x.salary > x.dept_avg_salary;

#12. Find employees who joined **before the earliest join date of their manager’s department**.
SELECT x.employee_name
from (
SELECT e.emp_name as employee_name,e.join_date as employee_join_date, m.department as manager_dept,min(m.join_date)over(PARTITION BY m.department) as min_manag_dept_join_date
FROM employees as e join employees as m on e.manager_id = m.emp_id) as x
where x.employee_join_date < x.min_manag_dept_join_date;

# 13. Find employees with salary **greater than their manager’s salary**.

SELECT e.emp_name, e.salary as emp_salary
FROM employees e join employees as m on e.manager_id = m.emp_id
where e.salary > m.salary;

# 14. Find the **second highest salary** in the company.
SELECT x.salary
FROM(
SELECT *, DENSE_RANK()over(order by salary desc) as rnk
FROM employees) as x
where x.rnk = 2

# 15. Find employees who do **not manage anyone**.
SELECT m.emp_name
from employees as e left join employees as m on e.manager_id = m.emp_id
GROUP BY m.emp_name
having count(e.emp_id) = 0;

======================section D=============================

# 16. Find all **managers and their direct reports** (manager name + employee name).
SELECT m.emp_name as manager_name, e.emp_name as emp_name
from employees as e left join employees as m on e.manager_id = m.emp_id

#17. Find employees who **joined in the same year** as their manager.
SELECT e.emp_name
from employees as e left join employees as m on e.manager_id = m.emp_id
where year(e.join_date) = year(m.join_date);

#18. Find employees whose **salary is within 10% of their manager’s salary**.
SELECT e.emp_name
from employees as e left join employees as m on e.manager_id = m.emp_id
where e.salary <= 0.10 * m.salary

#19. Find employees in **departments where average salary > 70k**.
SELECT x.emp_name
FROM(
SELECT *, avg(salary)over(PARTITION BY department) as dept_avg_salary
FROM employees) as x
where x.dept_avg_salary > 70000;

# 20. Find managers who manage employees **from more than one department**.
SELECT m.emp_name
FROM employees as e join employees as m on e.manager_id = m.emp_id
GROUP BY m.emp_name
having count(DISTINCT e.department)>1;

=========== optional ======================
🔥 Rapid Fire SQL Practice

# Q1. Find the second highest salary from the employees table.
SELECT salary
from (
SELECT salary, DENSE_RANK() over(order by salary desc) as rnk
FROM employees) as x
where x.rnk = 2

# From the orders table (columns: order_id, customer_id, order_date, amount),
#find the top 3 customers by total order value.
SELECT customer_id, sum(amount) as total_order_value
from orders
GROUP BY customer_id
order by total_order_value DESC
limit 3

# From the employees table, find departments where every employee earns more than 50,000.

SELECT department
from employees
GROUP BY department
having min(salary)> 50000

# Find customers who have placed orders in at least 2 different months.

SELECT customer_id
from orders
GROUP BY customer_id
having count(distinct date_format(order_date,'%m'))>2;

products(product_id, category, price)
sales(sale_id, product_id, quantity, sale_date)

Find the category with the highest total sales value (price * quantity).

SELECT category, total_sales , dense_rank()over(order by total_sales desc) as rnk
from (
SELECT category, sum(price * quantity) as total_sales
from products as p join sales as s on p.product_id = s.product_id
group by category)
qualify rnk = 1

-- Problem - Write a solution to report the movies with an odd-numbered ID and a description that is not "boring". Return the result table ordered by rating in descending order.
  
CREATE TABLE Cinema (
    id INT PRIMARY KEY,
    movie VARCHAR(255),
    description VARCHAR(255),
    rating FLOAT
);

INSERT INTO Cinema (id, movie, description, rating) VALUES
(1, 'The Dark Knight', 'thrilling', 9.0),
(2, 'The Hangover', 'boring', 7.7),  
(3, 'Inception', 'mind-bending', 8.8),
(4, 'Titanic', 'romantic', 7.8),
(5, 'Avengers: Endgame', 'epic action', 8.4),
(6, 'The Matrix', 'sci-fi action', 8.7),
(7, 'The Godfather', 'classic crime drama', 9.2),
(8, 'Cars', 'animated comedy', 6.8),
(9, 'The Lion King', 'boring', 8.5),  -- Boring movie
(10, 'Interstellar', 'epic space drama', 8.6);

select *
from Cinema
where description != 'boring' and MOD(id,2) = 1
order by rating desc

--You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

-- Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.


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

with salary_mapping as (
select f1.`ID` as `Student_ID`, p1.`Salary` as student_salary, f1.`Friend_ID`, p2.`Salary` as friend_salary, s.`Name` as student_name
from friends as f1  join Packages as p1 on f1.`ID` = p1.`Student_ID`
join packages as p2 on f1.`Friend_ID` = p2.`Student_ID`
join Students as s on s.`ID` = f1.`ID`)
SELECT student_name
from salary_mapping
where friend_salary > student_salary
order by friend_salary desc;

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(255)
);

-- Videos Table
CREATE TABLE videos (
    video_id INT PRIMARY KEY,
    user_id INT,
    upload_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Interactions Table
CREATE TABLE interactions (
    interaction_id INT PRIMARY KEY,
    video_id INT,
    likes INT,
    comments INT,
    FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

-- Sample Data for Users
INSERT INTO users (user_id, username)
VALUES
(1, 'user_one'),
(2, 'user_two'),
(3, 'user_three');

-- Sample Data for Videos
INSERT INTO videos (video_id, user_id, upload_date)
VALUES
(101, 1, '2024-01-01'),
(102, 1, '2024-01-02'),
(103, 1, '2024-01-03'),
(104, 1, '2024-01-04'),
(105, 1, '2024-01-05'),
(201, 2, '2024-01-01'),
(202, 2, '2024-01-02'),
(203, 2, '2024-01-03'),
(301, 3, '2024-01-01');

-- Sample Data for Interactions
INSERT INTO interactions (interaction_id, video_id, likes, comments)
VALUES
(1001, 101, 150, 30),
(1002, 102, 80, 20),
(1003, 103, 200, 50),
(1004, 104, 120, 40),
(1005, 105, 50, 10),
(2001, 201, 300, 90),
(2002, 202, 100, 20),
(2003, 203, 20, 5),
(3001, 301, 10, 5);


--An "interactive video" is defined as a video where the total number of interactions (likes + comments) exceeds 100.

--👉 Write an SQL query to find users who have uploaded at least 5 videos in total AND at least 3 of their videos are interactive videos.

--step:1 To find the interactive video
with interactive_video as (
    SELECT v.video_id, u.user_id,sum(likes + comments) as total_interactions
    FROM users as u join videos as v on u.user_id = v.user_id
    join interactions as i on i.video_id = v.video_id
    GROUP BY video_id, u.user_id
    having sum(likes + comments) > 100
),
-- step:2 user uploaded atleast five videos
atleast_five_videos as (
    SELECT user_id, count(video_id) as min_five_videos
    FROM videos
    GROUP BY user_id
    having count(video_id) >=5
)
SELECT iv.user_id ,count(*) as interactive_video_count
from interactive_video as iv join atleast_five_videos as afv on iv.user_id = afv.user_id
GROUP BY iv.user_id
having count(*)>=3 
order by 2 desc;

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

create table report as (
select `RestaurantName`, count(`OrderID`) as popularity, 
case when count(`OrderID`) > 3 then 5 else 1 end as rating
from Restaurants as R join Orders as O on R.`RestaurantID` = O.`RestaurantID`
GROUP BY `RestaurantName`);
select *
from report;


DROP TABLE if EXISTS orders;
CREATE TABLE orders (
    order_id   INT AUTO_INCREMENT PRIMARY KEY ,
    order_date DATE NOT NULL, 
    customer_name VARCHAR(50),
    amount     DECIMAL(10,2),
    created_at DATETIME default CURRENT_TIMESTAMP
);
INSERT INTO orders (order_date, customer_name, amount)
VALUES
('2019-05-10', 'Alice', 100.00),
('2020-01-15', 'Bob', 200.50),
('2020-12-01', 'Charlie', 300.00),
('2021-07-20', 'Diana', 150.75),
('2022-03-02', 'Edward', 500.00),
('2025-06-18', 'FutureMan', 9999.99);
INSERT INTO orders (order_date, customer_name, amount)
VALUES('2024-04-01','santhosh',1000);
select *
from orders

explain SELECT * FROM orders ORDER BY created_at  ;
explain SELECT order_id FROM orders ORDER BY created_at;
explain SELECT order_id FROM orders where created_at='2025-08-24 22:52:38' ;
create index idx_order_time on orders(created_at);
--after creating index
explain SELECT * FROM orders ORDER BY created_at;
explain SELECT order_id FROM orders ORDER BY created_at;
explain SELECT order_id FROM orders where created_at='2025-08-24 22:52:38' ;
explain SELECT * FROM orders where created_at='2025-06-08 09:10:37' ORDER BY created_at;
select *
from orders
where order_id = 1 or 1=1;

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

with total_sales_avg as (
select *, sum(total_sales)over(PARTITION BY store_name) as sum_total_sales,
avg(total_sales) over() as avg_total_sales
from store_sales)
select DISTINCT store_name
from total_sales_avg
where sum_total_sales > avg_total_sales;

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
with days_diff as (
select *, lag(`OrderDate`,1)over(PARTITION BY `CustomerID` order by `OrderDate`) as prev_order_date,
datediff(`OrderDate`, lag(`OrderDate`,1)over(PARTITION BY `CustomerID` order by `OrderDate`)) as diff
from Orders)
select DISTINCT `CustomerID`
from days_diff
where diff = 1;

-- solution 2
SELECT DISTINCT o1.`CustomerID`
from Orders as o1 join orders as o2 on o1.`CustomerID` = o2.`CustomerID`
where o1.`CustomerID` = o2.`CustomerID` and o1.`OrderDate` = DATE_ADD(o2.`OrderDate`,interval 1 day)

 SELECT DATE_FORMAT('2009-10-04 22:23:00',
 '%W %M %Y');

  SELECT DATE_ADD('2009-10-04 22:23:00', interval -1 day)

SELECT DATEDIFF('2007-12-31 23:59:59','2007-12-30');

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
with days_diff as (
select *, lag(`OrderDate`,1)over(PARTITION BY `CustomerID` order by `OrderDate`) as lag1,
lag(`OrderDate`,2)over(PARTITION BY `CustomerID` order by `OrderDate`) as lag2,
DATEDIFF(`OrderDate`,lag(`OrderDate`,1)over(PARTITION BY `CustomerID` order by `OrderDate`)) as diff1,
DATEDIFF(lag(`OrderDate`,1)over(PARTITION BY `CustomerID` order by `OrderDate`), lag(`OrderDate`,2)over(PARTITION BY `CustomerID` order by `OrderDate`)) as diff2
from orders_new)
select DISTINCT `CustomerID`
from days_diff
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
case when p is null then 'root'
     when n not in (select distinct p from nodes where p is not null) then 'leaf'
     else "inner"
end as nodes
from nodes;

CREATE TABLE test_vals (x INT);

INSERT INTO test_vals VALUES
(1), (2), (NULL);

select 
case when 3 not in (select x from test_vals where x is not null) then "TRUE" else "FALSE" end as result
from test_vals;

-- Correct: single evaluation
SELECT 3 NOT IN (SELECT x FROM test_vals where x is not null) AS result;

USE interview_prep;
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

SELECT *
from sales_v2
order by `CustomerNumber`, OrderDate;
-- How to Identify Customers Whose Gap Since the Last Order is Greater Than Their Largest Historical Gap Between Orders
with purchase_orders as (
select *, lag(`OrderDate`,1)over(PARTITION BY `CustomerNumber` order by `OrderDate`) as prev_purchase_date,
DATEDIFF(`OrderDate`,lag(`OrderDate`,1)over(PARTITION BY `CustomerNumber` order by `OrderDate`)) as prev_order_diff,
LAST_VALUE(`OrderDate`)over(PARTITION BY `CustomerNumber` order by `OrderDate`rows between unbounded preceding and unbounded following ) as latest_purchase_date,
DATEDIFF(CURRENT_DATE,LAST_VALUE(`OrderDate`)over(PARTITION BY `CustomerNumber` order by `OrderDate`rows between unbounded preceding and unbounded following )) as last_purchase_diff
from sales_v2),
t2 as (
SELECT *, max(prev_order_diff)over(PARTITION BY `CustomerNumber`) as max_purchase_diff
FROM purchase_orders)
select DISTINCT `CustomerNumber`
from t2
where last_purchase_diff > max_purchase_diff;


-- Create Table Query
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


SELECT *
from bakery_sales;

select `Day_of_Week`,
sum(case when `Type` = 'Pastry' then `Quantity` else 0 end) as 'Pastry',
sum(case when `Type` = 'Bread' then `Quantity` else 0 end) as 'Bread',
sum(case when `Type` = 'Dessert' then `Quantity` else 0 end) as 'Dessert'
from bakery_sales
GROUP BY `Day_of_Week`

show DATABASES;
use  interview_db;
CREATE TABLE Employees_v1 (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    ManagerID INT
);
INSERT INTO Employees_v1 (EmpID, EmpName, ManagerID) VALUES
(1, 'Chris', 101),
(101, 'Duyen', 1001),
(103, 'Catherine', 1001),
(1001, 'Rick', 1008),
(1008, 'Kane', NULL);

SELECT *
from employees_v1;
SELECT m.`EmpID`, count(e.`EmpID`) as employees_count
from employees_v1 as e join employees_v1 as m on e.`ManagerID` = m.`EmpID`
GROUP BY m.`EmpID`;

SELECT *
from employees_v1 as e join employees_v1 as m on e.`ManagerID` = m.`EmpID` join employees_v1 as gm on m.`ManagerID` = gm.`EmpID`



SELECT gm.`EmpName`, count(DISTINCT m.`EmpID`) as co
from employees_v1 as e join employees_v1 as m on e.`ManagerID` = m.`EmpID` join employees_v1 as gm on m.`ManagerID` = gm.`EmpID`
GROUP BY gm.`EmpName`;

SELECT gm.`EmpName`, count(distinct m.`EmpID`) as count
from employees_v1 as e join employees_v1 as m on e.`ManagerID` = m.`EmpID` join employees_v1 as gm on m.`ManagerID` = gm.`EmpID`
where gm.`ManagerID` is not NULL
GROUP BY gm.`EmpName`;

CREATE TABLE orders_v1 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10, 2)
);
INSERT INTO orders_v1 (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2024-01-10', 150.00),
(2, 101, '2024-02-15', 200.00),
(3, 101, '2024-03-20', 180.00),
(4, 102, '2024-01-12', 200.00),
(5, 102, '2024-02-25', 250.00),
(6, 102, '2024-03-10', 320.00),
(7, 103, '2024-01-25', 400.00),
(8, 103, '2024-02-15', 420.00);

with customer_spend as (
SELECT *, FIRST_VALUE(order_amount)over(PARTITION BY customer_id order by order_date desc) as latest_order_amount,
DENSE_RANK()over(PARTITION BY customer_id order by order_date desc) as rnk
FROM orders_v1)
SELECT customer_id, order_amount as second_highest_order_amount, latest_order_amount
FROM customer_spend
where rnk = 2

