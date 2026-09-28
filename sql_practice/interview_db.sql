-- Active: 1790596888286@@127.0.0.1@3306@interview_db
use interview_db;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50)
);

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
with cte as (
    SELECT *, ROW_NUMBER()over(PARTITION BY user_id ORDER BY order_date desc) as rn
    from orders
)
SELECT u.user_id, u.name
from users as u left join cte as c on u.user_id = c.user_id and rn  = 1
where c.order_date < DATE_SUB(now(), interval 6 MONTH) or order_id is null

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
FROM employees as e join employees as m on e.manager_id = m.emp_id and e.department != m.department;

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
SELECT *
from employees;
SELECT department
from employees
--  
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
use albertsons;

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
SELECT r.`RestaurantName`, count(o.order_id) as popularity, 
case when count(o.order_id) > 3 then 5 else 1 end as Rating
from restaurants as r left join Orders as o on r.`RestaurantID` = o.`RestaurantID`
GROUP BY r.`RestaurantName`

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
SELECT '2009-10-04'-interval 1 day;
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

use albertsons;
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
where rnk = 2;

use test;

show tables;
-- Create table
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
    select customer_id , min(order_date) as first_order_date
    from orders
    group by customer_id
),
customer_group as (
    SELECT f.customer_id as cust1, f.first_order_date, o.customer_id, o.`order_date`,
    case when f.first_order_date = o.order_date then 'New' else 'Existing' end as cus_type
    from orders as o join first_order as f on f.customer_id = o.customer_id
)
SELECT order_date,
sum(case when cus_type = 'New' then 1 else 0 end) as New_customers,
sum(case when cus_type = 'Existing' then 1 else 0 end) as Existing_customers
from customer_group
group by order_date;

with customer_type as (
select *,
case when X.rn =1 then 'New' else 'Old' end as cus_type 
from (
SELECT customer_id, order_date, ROW_NUMBER()over(PARTITION BY `customer_id` order by order_date) as rn
from orders) as X)
SELECT `order_date`,
sum(case when cus_type = 'New' then 1 else 0 end) as New_customers,
sum(case when cus_type = 'Old' then 1 else 0 end) as Old_customers
from customer_type
GROUP BY order_date;

CREATE TABLE Names_Source (
    celebrity_id INT PRIMARY KEY,
    celebrity_name VARCHAR(255) NOT NULL
);

-- Example INSERT statements for practice (optional)
INSERT INTO Names_Source (celebrity_id, celebrity_name) VALUES
(1, 'Virat Kohli'),
(2, 'Narendra Damodardas Modi'),
(3, 'Salman');

CREATE TABLE products (
  id INT,
  tags JSON
);

INSERT INTO products VALUES
(1, '["electronics", "computers"]'),
(2, '["education"]'),
(3, '["kitchen", "appliances", "home"]');

SELECT id, JSON_LENGTH(tags) AS tag_count FROM products;

SELECT JSON_LENGTH('["a", "b", "c"]') AS array_size;


select length('a,b,c') - length(replace('a,b,c', ',', '')) + 1 as co;


-- The difference gives the number of spaces.
-- If there are 2 spaces, it means there are 3 words.
select length('virat kohli tendulkar') - length(replace('virat kohli tendulkar', ' ', '')) as co;

CREATE TABLE users_mysql (
  id CHAR(36) DEFAULT (UUID()) PRIMARY KEY,
  name VARCHAR(100)
);
insert into users_mysql(name) values 
    ('santhosh'),
    ('madhavan'),
    ('kohli');

select *
from users_mysql

-- postgres query to find the first and last name
CREATE TABLE Names_Source (
    celebrity_id INT PRIMARY KEY,
    celebrity_name VARCHAR(255) NOT NULL
);

-- Example INSERT statements for practice (optional)
INSERT INTO Names_Source (celebrity_id, celebrity_name) VALUES
(1, 'Virat Kohli'),
(2, 'Narendra Damodardas Modi'),
(3, 'Salman');


"""select celebrity_name, 
split_part(celebrity_name,' ',1)as first_name,
case 
  when 
array_length(string_to_array(celebrity_name, ' '),1) =3 then 
split_part(celebrity_name,' ',2) else null end as middle_name,

case when array_length(string_to_array(celebrity_name,' '),1) >=2 then 
split_part(celebrity_name,' ',array_length(string_to_array(celebrity_name, ' '),1)) else null end as last_name
from names_source """


create table Boolean_v1 (
    id int AUTO_INCREMENT PRIMARY KEY,
    is_active BOOLEAN DEFAULT false
);
insert into Boolean_v1  (is_active) values
(False),
(True),
(1);

select *
from boolean_v1;

-- Regex examples

DROP TABLE IF EXISTS regex_samples;

CREATE TABLE regex_samples (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sample_text VARCHAR(100)
);


INSERT INTO regex_samples (sample_text) VALUES 
('apple'),         -- id=1
('Banana'),        -- id=2 (note the capital B)
('cherry'),        -- id=3
('date'),          -- id=4
('elderberry'),    -- id=5
('fig'),           -- id=6
('grape'),         -- id=7
('honeydew'),      -- id=8
('running'),       -- id=9 (ends with "ing")
('123abc');        -- id=10 (starts with digits)

-- Example 1: Match Strings That Start with “a”

select *
from regex_samples
where sample_text regexp '^a'


-- Example 2: Match Strings That End with “e”
SELECT * 
FROM regex_samples
WHERE sample_text REGEXP 'e$';

-- Example 3: Match Strings That Start with a Digit

SELECT * 
FROM regex_samples
WHERE sample_text REGEXP '^[0-9]';

SELECT *
from regex_samples
where sample_text regexp 'ing$';

-- Example 6: Match Strings That Contain Only Letters
SELECT * 
FROM regex_samples
WHERE sample_text REGEXP '^[A-Za-z]+$';


-- Example 7: Match Strings with Exactly 5 Characters

SELECT *
from regex_samples
where sample_text REGEXP '^[A-Za-z]{2,}$'

-- Example 8: Match Strings Containing an Uppercase Letter (Case‑Sensitive) -- this may not work in some versions
SELECT * 
FROM regex_samples
WHERE sample_text REGEXP '[A-Z]' COLLATE utf8mb4_bin;

-- only with upper case letter
SELECT * 
FROM regex_samples
WHERE sample_text REGEXP '^[A-Z]+$' COLLATE utf8mb4_bin;

-- Example 9: Match Only “apple” or “banana” Exactly
SELECT *
from regex_samples
where sample_text REGEXP '^(banana|apple)$'

--Example 10: Match Strings Starting with 3 Digits Followed by Letters

SELECT *
from regex_samples
where sample_text REGEXP '^[0-9]{3}[a-zA-Z]+$'


drop table if exists orders;
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL
);


-- 2024 data
INSERT INTO orders (order_date) VALUES
('2024-01-05'),('2024-01-07'),('2024-01-12'),('2024-01-18'),('2024-01-25'),
('2024-02-03'),('2024-02-06'),('2024-02-08'),('2024-02-15'),('2024-02-22'),('2024-02-27'),
('2024-03-02'),('2024-03-06'),('2024-03-09'),('2024-03-15'),('2024-03-20'),('2024-03-25'),
('2024-04-04'),('2024-04-10'),('2024-04-17'),
('2024-05-02'),('2024-05-06'),('2024-05-10'),('2024-05-12'),('2024-05-15'),('2024-05-18'),
('2024-06-02'),('2024-06-05'),('2024-06-09'),
('2024-07-03'),('2024-07-05'),('2024-07-07'),('2024-07-12'),('2024-07-15'),('2024-07-20'),
('2024-08-02'),('2024-08-06'),('2024-08-09'),('2024-08-11'),('2024-08-15'),
('2024-09-01'),('2024-09-03'),('2024-09-06'),('2024-09-08'),
('2024-10-04'),('2024-10-07'),('2024-10-10'),('2024-10-14'),('2024-10-17'),('2024-10-22'),
('2024-11-03'),('2024-11-06'),('2024-11-09'),('2024-11-11'),
('2024-12-03'),('2024-12-05'),('2024-12-09'),('2024-12-14'),('2024-12-17'),('2024-12-21');

-- 2025 Data
INSERT INTO orders (order_date) VALUES
('2025-01-05'),('2025-01-07'),('2025-01-10'),('2025-01-12'),
('2025-02-02'),('2025-02-04'),('2025-02-08'),('2025-02-10'),('2025-02-12'),('2025-02-15'),('2025-02-17'),('2025-02-19'),
('2025-03-03'),('2025-03-06'),('2025-03-10'),('2025-03-13'),('2025-03-18'),('2025-03-22'),('2025-03-25'),
('2025-04-02'),('2025-04-06'),('2025-04-08'),
('2025-05-03'),('2025-05-05'),('2025-05-07'),('2025-05-09'),('2025-05-12'),('2025-05-15'),
('2025-06-01'),('2025-06-04'),('2025-06-07'),('2025-06-10'),
('2025-07-02'),('2025-07-04'),('2025-07-06'),('2025-07-09'),('2025-07-12'),('2025-07-15'),('2025-07-18'),
('2025-08-03'),('2025-08-06'),('2025-08-09'),('2025-08-12'),('2025-08-15'),('2025-08-18'),('2025-08-21'),('2025-08-24'),
('2025-09-01'),('2025-09-04'),('2025-09-06'),('2025-09-09'),
('2025-10-02'),('2025-10-04'),('2025-10-06'),('2025-10-08'),('2025-10-11');

SELECT date_format(order_date, "%Y") AS year, date_format(order_date, "%m") as month, count(order_id) as total_orders
from orders
group by date_format(order_date, "%Y"), date_format(order_date, "%m")
order by 1,2;
with monthly_orders as (
SELECT date_format(order_date, "%Y") AS year, date_format(order_date, "%m") as month, count(order_id) as total_orders
from orders
group by date_format(order_date, "%Y"), date_format(order_date, "%m")),
month_calendar AS (
    SELECT year as year_cal, month as month_cal
    FROM (
        SELECT 2024 AS year, 1 AS month UNION ALL
        SELECT 2024, 2 UNION ALL
        SELECT 2024, 3 UNION ALL
        SELECT 2024, 4 UNION ALL
        SELECT 2024, 5 UNION ALL
        SELECT 2024, 6 UNION ALL
        SELECT 2024, 7 UNION ALL
        SELECT 2024, 8 UNION ALL
        SELECT 2024, 9 UNION ALL
        SELECT 2024, 10 UNION ALL
        SELECT 2024, 11 UNION ALL
        SELECT 2024, 12 UNION ALL
        SELECT 2025, 1 UNION ALL
        SELECT 2025, 2 UNION ALL
        SELECT 2025, 3 UNION ALL
        SELECT 2025, 4 UNION ALL
        SELECT 2025, 5 UNION ALL
        SELECT 2025, 6 UNION ALL
        SELECT 2025, 7 UNION ALL
        SELECT 2025, 8 UNION ALL
        SELECT 2025, 9 UNION ALL
        SELECT 2025, 10 UNION ALL
        SELECT 2025, 11 UNION ALL
        SELECT 2025, 12
    ) AS cal
)
SELECT mo.*, coalesce(lag(total_orders,1)over(PARTITION BY year order by month),0) as prev_order_count, 
case when lag(total_orders,1)over(PARTITION BY year order by month) is null then 0 
else
round((total_orders - lag(total_orders,1)over(PARTITION BY year order by month)) * 100.0 / nullif(lag(total_orders,1)over(PARTITION BY year order by month),0),2)
end as growth_perc
from month_calendar as m left join monthly_orders as mo on m.year_cal = mo.year and m.month_cal = mo.month
where year is not null
order by 1,2;

show DATABASES;

use test;

show TABLES;

-- Create the table
CREATE TABLE empdetails (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT
);

-- Insert the data
INSERT INTO empdetails (emp_id, emp_name, dept_id) VALUES
(101, 'Alice', 1),
(102, 'Bob', 1),
(103, 'Carol', 2),
(104, 'David', 2);

-- Create the table
CREATE TABLE empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert the data
INSERT INTO empsales (emp_id, client_id, sales) VALUES
(101, 201, 5000),
(101, 202, 3000),
(102, 201, 7000),
(103, 202, 6000),
(104, 203, 8000);

-- Write a SQL query to find the client_id and emp_id of the best client and the best employee for each department.

with total_sales as (
SELECT ed.dept_id, ed.emp_id, es.client_id, es.sales, sum(es.sales)over(PARTITION BY ed.dept_id, ed.emp_id) as total_emp_sales
from empdetails as ed join empsales as es on ed.emp_id = es.emp_id
order by 1)
SELECT dept_id, client_id, emp_id,sales
from (
SELECT *, ROW_NUMBER()over(PARTITION BY dept_id order by total_emp_sales desc,sales desc) as rn
from total_sales) as X
where X.rn = 1;

CREATE TABLE scores (
    Player VARCHAR(50) NOT NULL,
    score_1 INT,
    score_2 INT,
    score_3 INT
);

INSERT INTO scores (Player, score_1, score_2, score_3) VALUES
('John', 80, 65, 70),
('Jacob', 65, NULL, NULL),
('Shawn', 92, 75, NULL);

create table unpivoted as (
SELECT Player, score_1 as Score, 1 as Attempt
from scores
union ALL
SELECT Player, score_2 as Score, 2 as Attempt
from scores
union ALL
SELECT Player, score_3 as Score, 3 as Attempt
from scores);
with t1 as (
SELECT *, 
case when Attempt = max(Attempt)over(PARTITION BY Player)then "Y" else "N" end as is_active
from unpivoted
where Score is not null
order by 1)
SELECT `Player`, GROUP_CONCAT(`Score` ORDER BY `Score` SEPARATOR ", ") as scores
from t1
GROUP BY `Player`;

create DATABASE flipkart;

use indium;
drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    category VARCHAR(50),
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (order_id, customer_id, product_id, category, order_date, amount) VALUES
(1, 'C001', 'P001', 'Electronics', '2025-04-10', 12000),
(2, 'C001', 'P002', 'Fashion', '2025-05-14', 2500),
(3, 'C001', 'P003', 'Home Appliances', '2025-06-02', 4500),
(4, 'C001', 'P004', 'Grocery', '2025-07-01', 700),
(5, 'C002', 'P005', 'Electronics', '2025-05-18', 15000),
(6, 'C002', 'P006', 'Fashion', '2025-06-01', 3000),
(7, 'C003', 'P007', 'Beauty', '2025-07-10', 800),
(8, 'C003', 'P008', 'Grocery', '2025-08-12', 600),
(9, 'C003', 'P009', 'Home Appliances', '2025-09-01', 2500);


-- 1. Find Flipkart customers who purchased products in more than 3 categories

SELECT customer_id, count(distinct category) as count
from orders
GROUP BY customer_id
having count(DISTINCT category) > 3;
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

-- 2. Find Flipkart customers who returned more than 20% of orders in the last 6 months;
SELECT *
from (
SELECT customer_id,
round(count(distinct case when order_status = 'Returned' then order_id end) * 100.0 / count(order_id),2) as returned_perc
from customer_orders
where order_date >= DATE_SUB(order_date, interval 6 month)
group by customer_id) as X
where returned_perc > 20;
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

SELECT DATE_FORMAT(order_date,'%Y-%m-01'), customer_id, GROUP_CONCAT(DISTINCT category order by category) as list
from orders
where category in ('Electronics','Fashion')
group by DATE_FORMAT(order_date,'%Y-%m-01'), customer_id
having count(DISTINCT category) = 2;
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

use flipkart;
-- Identify Flipkart customers who returned more than 10% of their orders last quarter 

SELECT *
from(
SELECT customer_id, 
count(case when order_status = 'Returned' then order_id end) as returned_orders,
count(order_id) as total_orders,
round(count(case when order_status = 'Returned' then order_id end)*100.0 / count(order_id),2) as returned_perc
from customer_orders
where (QUARTER(order_date) = case when quarter(CURRENT_DATE) = 1 then 4 else QUARTER(current_date)-1 end) and 
YEAR(order_date) = case when QUARTER(CURRENT_DATE) = 1 then year(current_date) - 1 else year(current_date) end
GROUP BY customer_id) as X
where returned_perc > 10;

drop table if exists customer_orders;
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    category VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL
);
INSERT INTO customer_orders (order_id, customer_id, category, order_date) VALUES
(1, 'C005', 'Electronics', '2025-01-05'),
(2, 'C005', 'Electronics', '2025-02-10'),
(3, 'C005', 'Electronics', '2025-03-11'),
(4, 'C005', 'Electronics', '2025-04-09'),
(5, 'C005', 'Electronics', '2025-06-12'),
(6, 'C005', 'Fashion', '2025-07-01'),
(7, 'C006', 'Electronics', '2025-02-05'),
(8, 'C006', 'Electronics', '2025-03-06'),
(9, 'C006', 'Accessories', '2025-04-10'),
(10, 'C007', 'Electronics', '2025-05-01'),
(11, 'C007', 'Fashion', '2025-05-10'),
(12, 'C007', 'Electronics', '2025-06-20');
-- — Find Flipkart customers who frequently bought from Electronics but never purchased Accessories;

SELECT customer_id
from customer_orders
where category in ('Electronics')
group by customer_id
having count(order_id) >=5;

with total_orders as (
SELECT customer_id,count(distinct case when category = 'Electronics' then order_id end) as electronics_count,
count(distinct case when category = 'Accessories' then order_id end) as accessories_count ,count(distinct order_id) as total_orders,
round(count(distinct case when category = 'Electronics' then order_id end)* 100 / count(distinct order_id),2) as elect_perc
from customer_orders
group by customer_id)
SELECT *
from total_orders
where elect_perc > 50 and accessories_count = 0 and electronics_count >=3;

drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    rating INT
);
INSERT INTO orders (order_id, customer_id, order_date, restaurant_name, amount, rating) VALUES
(1, 'C001', '2025-04-10', 'Domino’s', 450, 4),
(2, 'C001', '2025-04-15', 'KFC', 350, NULL),
(3, 'C001', '2025-05-01', 'Subway', 500, NULL),
(4, 'C001', '2025-05-12', 'McDonald’s', 600, NULL),
(5, 'C001', '2025-06-10', 'Burger King', 700, NULL),
(6, 'C001', '2025-06-22', 'Biryani Blues', 550, NULL),

(7, 'C002', '2025-05-14', 'Subway', 450, 5),
(8, 'C002', '2025-06-11', 'KFC', 500, 4),
(9, 'C002', '2025-07-20', 'Pizza Hut', 600, 3),

(10, 'C003', '2025-06-02', 'Domino’s', 400, 2),
(11, 'C003', '2025-06-25', 'Burger King', 450, NULL),
(12, 'C003', '2025-07-03', 'Domino’s', 500, NULL),
(13, 'C003', '2025-07-14', 'McDonald’s', 400, NULL),
(14, 'C003', '2025-07-30', 'Subway', 650, NULL),
(15, 'C003', '2025-08-02', 'KFC', 500, NULL);

-- Find Zomato customers who ordered more than 5 times but rated only once;
SELECT customer_id, count(order_id) as order_count,  count(rating) as rating_count
from orders
group by customer_id
having count(order_id) > 5 and count(case when rating is not null then order_id end) = 1;

drop table if exists orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (order_id, customer_id, order_date, restaurant_name, amount) VALUES
(1, 'C001', '2025-07-06', 'Domino’s', 450),
(2, 'C001', '2025-07-13', 'Subway', 550),
(3, 'C001', '2025-08-03', 'KFC', 400),
(4, 'C002', '2025-07-05', 'Domino’s', 600),
(5, 'C002', '2025-07-08', 'Burger King', 500),
(6, 'C003', '2025-07-07', 'McDonald’s', 700),
(7, 'C004', '2025-08-02', 'Subway', 550),
(8, 'C004', '2025-08-09', 'Domino’s', 600),
(9, 'C004', '2025-09-07', 'Burger King', 700);

--  Find Zomato customers who ordered only on weekends in the last 3 months
SELECT customer_id, round(count(distinct case when DATE_FORMAT(order_date, '%w') in (0,6) then order_id end)*100.0 / count(distinct order_id),2) as weekend_perc
from orders
where order_date >= date_sub(current_date, interval 12 month) 
group by customer_id
order by 2 desc;
drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    rating INT
);

INSERT INTO orders (order_id, customer_id, restaurant_name, order_date, amount, rating) VALUES
(1, 'C001', 'Domino’s', '2025-05-10', 400, 2),
(2, 'C001', 'Domino’s', '2025-05-25', 450, 3),
(3, 'C001', 'Domino’s', '2025-06-10', 500, 2),
(4, 'C001', 'Domino’s', '2025-07-01', 550, 1),
(5, 'C002', 'KFC', '2025-06-15', 600, 4),
(6, 'C002', 'KFC', '2025-07-18', 550, 3),
(7, 'C002', 'KFC', '2025-08-10', 650, 4),
(8, 'C003', 'Subway', '2025-05-20', 350, 2),
(9, 'C003', 'Subway', '2025-05-25', 300, 1),
(10, 'C003', 'Subway', '2025-06-01', 400, 2),
(11, 'C003', 'Subway', '2025-06-10', 350, 3);

-- Find Zomato customers who ordered from the same restaurant more than 3 times but left low ratings
SELECT customer_id,restaurant_name, avg(rating) as avg_rating
from orders
GROUP BY customer_id,restaurant_name
having count(*)>3 and avg(rating)<3;
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
SELECT restaurant_name, DATE_FORMAT(order_date,'%Y-%m-01') as month, count(order_id) as monthly_count
from orders
GROUP BY restaurant_name, DATE_FORMAT(order_date,'%Y-%m-01'))
SELECT DISTINCT restaurant_name
from(
SELECT *, lag(monthly_count,1)over(PARTITION BY restaurant_name order by month) as lag1,
lag(monthly_count,2)over(PARTITION BY restaurant_name order by month) as lag2,
lag(monthly_count,3)over(PARTITION BY restaurant_name order by month) as lag3
from monthly_orders) as X
where monthly_count >= lag1 >= lag2 >= lag3;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    order_time DATETIME NOT NULL,
    tip_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (order_id, customer_id, order_time, tip_amount) VALUES
(1, 'C001', '2025-07-05 22:30', 10),
(2, 'C001', '2025-07-06 23:15', 5),
(3, 'C001', '2025-07-12 00:45', 0),
(4, 'C001', '2025-07-19 21:00', 20),

(5, 'C002', '2025-07-05 23:50', 2),
(6, 'C002', '2025-07-06 01:10', 1),
(7, 'C002', '2025-07-07 23:40', 0),

(8, 'C003', '2025-07-06 20:00', 10),
(9, 'C003', '2025-07-07 21:30', 15);

-- Find Zomato customers who frequently ordered  late night (10 PM – 2 AM) but have low average tip amount
with late_night as (
SELECT customer_id,count(distinct case when hour(order_time) in (22,23,0,1,2) then order_id end) as late_night_orders,
count(distinct order_id) as total_orders,
round(count(distinct case when hour(order_time) in (22,23,0,1,2) then order_id end)*100.0 / count(distinct order_id),2) as late_night_perc
from orders
group by customer_id),
late_night_customers as (
SELECT customer_id
from late_night
where late_night_orders >=3 and late_night_perc >= 30)
SELECT o.customer_id
FROM late_night_customers as ln join orders as o on ln.customer_id = o.customer_id
GROUP BY o.customer_id
having avg(case when hour(order_time) in (22,23,0,1,2) then tip_amount end) < (SELECT round(avg(tip_amount),2) from orders)




SELECT o.customer_id, round(avg(o.tip_amount),2) as avg_tip_amount
from late_night_customers as l join orders as o on l.customer_id = o.customer_id
GROUP BY o.customer_id
having avg(tip_amount)< (select avg(tip_amount) from orders);

SELECT customer_id,avg(tip_amount)
from orders
where customer_id = 'C001' and hour(order_time) in (22,23,0,1,2);

SELECT customer_id,avg(tip_amount)
from orders
where customer_id = 'C001';

select avg(tip_amount) from orders;

select avg(tip_amount) from orders where hour(order_time) in (22,23,0,1,2);

select  order_time, hour(order_time) as h
from orders;


DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO Orders (order_id, customer_id, order_date, amount) VALUES
-- Customer 101
(1,101,'2025-01-01',500),
(2,101,'2025-01-02',700),
(3,101,'2025-01-03',900),
(4,101,'2025-01-05',600),
(5,101,'2025-01-06',800),
(6,101,'2025-01-10',1000),
-- Customer 102
(7,102,'2025-01-01',450),
(8,102,'2025-01-02',550),
(9,102,'2025-01-05',650),
(10,102,'2025-01-06',750),
(11,102,'2025-01-07',850),
-- Customer 103
(12,103,'2025-01-03',400),
(13,103,'2025-01-10',900),
-- Customer 104
(14,104,'2025-01-01',500),
(15,104,'2025-01-02',550),
(16,104,'2025-01-03',600),
(17,104,'2025-01-04',650),
(18,104,'2025-01-05',700);

with cte1 as (
SELECT *, ROW_NUMBER()over(PARTITION BY customer_id ORDER BY order_date) as rn
from orders),
cte2 as (
SELECT *, order_date - INTERVAL rn day as group_date
from cte1),
cte3 as (
SELECT customer_id, group_date, min(order_date) as min_date,max(order_date) as max_date,count(*) as streak_length
from cte2
GROUP BY customer_id, group_date)
SELECT customer_id,min_date, max_date,streak_length
from(
SELECT *, row_number()over(PARTITION BY customer_id ORDER BY streak_length desc) as rnk
from cte3) as X
where X.rnk = 1;

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO Orders VALUES
(1,101,'2025-01-05',500),
(2,101,'2025-02-10',700),
(3,101,'2025-03-18',900),
(4,102,'2025-01-15',300),
(5,102,'2025-01-28',450),
(6,103,'2025-02-05',600),
(7,103,'2025-03-08',700),
(8,104,'2025-01-10',400),
(9,105,'2025-03-12',800),
(10,105,'2025-04-15',950),
(11,106,'2025-02-20',550),
(12,106,'2025-02-25',650),
(13,106,'2025-03-20',750);

with first_purchase as (
SELECT *, ROW_NUMBER()over(PARTITION BY customer_id ORDER BY order_date) as rn
from orders),
new_customers as (
SELECT DATE_FORMAT(order_date,'%Y-%m') as month, count(*) as new_customers
from first_purchase
where rn = 1
GROUP BY DATE_FORMAT(order_date,'%Y-%m')),
cte3 as (
SELECT *, min(DATE_FORMAT(order_date,'%Y-%m'))over(PARTITION BY customer_id) as min_date, DATE_FORMAT(order_date,'%Y-%m') as new_order_date
from orders),
cte4 as (
SELECT new_order_date, count(DISTINCT customer_id) as retained_customers
from cte3
where min_date != new_order_date
GROUP BY new_order_date)
SELECT month as order_date, new_customers,COALESCE(retained_customers,0) as retained_customers,
(retained_customers / lag(new_customers) over(order by order_date)) * 100
from new_customers as t1 left join cte4 as t2 on t1.month = t2.new_order_Date;

CREATE TABLE city_pairs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    city_a VARCHAR(50),
    city_b VARCHAR(50)
);
INSERT INTO city_pairs (city_a, city_b) VALUES
('Chennai', 'Mumbai'),
('Mumbai', 'Chennai'),
('Bangalore', 'Hyderabad'),
('Hyderabad', 'Bangalore'),
('Delhi', 'Pune'),
('Pune', 'Delhi'),
('Kolkata', 'Ahmedabad'),
('Ahmedabad', 'Kolkata'),
('Chennai', 'Delhi'),
('Delhi', 'Chennai'),
('Mumbai', 'Bangalore'),
('Bangalore', 'Mumbai'),
('Chennai', 'Mumbai'),
('Hyderabad', 'Pune'),
('Pune', 'Hyderabad');

select distinct least(city_a,city_b) as city_a, greatest(city_a,city_b) as city_b
from city_pairs;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    merchant_id INT,
    transaction_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO transactions VALUES
(1,101,'2025-01-01',100),
(2,101,'2025-01-01',200),
(3,101,'2025-01-03',300),
(4,101,'2025-01-06',400),
(5,102,'2025-01-01',500),
(6,102,'2025-01-02',100),
(7,102,'2025-01-05',250),
(8,102,'2025-01-06',150);

with total_amount as(
select merchant_id, transaction_date, sum(amount) as total_amount
from transactions
group by merchant_id, transaction_date);
 WITH RECURSIVE calendar AS
(
    SELECT MIN(transaction_date) AS transaction_date
    FROM transactions

    UNION ALL

    SELECT DATE_ADD(transaction_date, INTERVAL 1 DAY)
    FROM calendar
    WHERE transaction_date <
    (
        SELECT MAX(transaction_date)
        FROM transactions
    )
),
daily_transactions AS
(
    SELECT
        merchant_id,
        transaction_date,
        SUM(amount) AS daily_volume
    FROM transactions
    GROUP BY merchant_id, transaction_date
),
merchant_dates AS
(
    SELECT
        m.merchant_id,
        c.transaction_date
    FROM
    (
        SELECT DISTINCT merchant_id
        FROM transactions
    ) m
    CROSS JOIN calendar c
)
SELECT t1.*, coalesce(t2.daily_volume,0) as daily_volume,
round(avg(COALESCE(t2.daily_volume,0))over(partition by merchant_id order by t1.transaction_date rows between 6 PRECEDING and current row),2) as rolling_avg
from merchant_dates as t1 left join daily_transactions as t2 on t1.merchant_id = t2.merchant_id and t1.transaction_date = t2.transaction_date
order by 1,2;










