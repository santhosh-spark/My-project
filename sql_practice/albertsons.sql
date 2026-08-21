use indium;
CREATE TABLE expenses (
    id INT PRIMARY KEY,
    dept VARCHAR(50),
    date DATE,
    amount INT
);
INSERT INTO expenses (id, dept, date, amount) VALUES
(1, 'HR', '2024-01-01', 100),
(2, 'HR', '2024-01-01', 200),  -- duplicate date (important)
(3, 'HR', '2024-01-02', 50),
(4, 'HR', '2024-01-03', 150),
(5, 'IT', '2024-01-01', 300),
(6, 'IT', '2024-01-02', 100),
(7, 'IT', '2024-01-02', 200),  -- duplicate date
(8, 'IT', '2024-01-04', 400);

--Running Total
SELECT *, sum(amount)over(PARTITION BY dept ORDER BY date rows between UNBOUNDED PRECEDING and current row) as rolling_sum
from expenses

-- Normal Total
SELECT *, sum(amount)over(PARTITION BY dept) as rolling_sum
from expenses;
use albertsons;
DROP TABLE if EXISTS Users;
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50)
);

drop table if exists Orders;
CREATE TABLE Orders (
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
INSERT INTO Orders (order_id, user_id, order_date) VALUES
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
SELECT *
from Orders;
use albertsons;
with cte as (
    SELECT *, ROW_NUMBER()over(PARTITION BY user_id order by order_date desc) as rn
    from Orders
)
SELECT *
from users as u left join cte as o on u.user_id = o.user_id and rn = 1
where o.order_date <= CURDATE() - INTERVAL 6 MONTH or o.order_id is null;

-- Create table
CREATE TABLE quarterly_sales (
    year INT,
    quarter VARCHAR(2),
    sales INT
);
-- Insert data
INSERT INTO quarterly_sales (year, quarter, sales) VALUES
(2024, 'Q1', 1000),
(2024, 'Q2', 1500),
(2024, 'Q3', 1200),
(2024, 'Q4', 1800),
(2025, 'Q1', 1100),
(2025, 'Q2', 1600);

SELECT year,
sum(case when quarter = 'Q1' then sales else 0 end) as Q1,
sum(case when quarter = 'Q2' then sales else 0 end) as Q2,
sum(case when quarter = 'Q3' then sales else 0 end) as Q3,
sum(case when quarter = 'Q4' then sales else 0 end) as Q4
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
SELECT year,"Q1" as Quarter,`Q1_Sales` as Sales from sales
union ALL
SELECT year, "Q2" as QUARTER, `Q2_Sales` as Sales from sales
union ALL
SELECT year, "Q3" as QUARTER, `Q3_Sales` as Sales from sales
union ALL
SELECT year, "Q4" as QUARTER, `Q4_Sales` as Sales from sales

select "santhosh" as name
union 
select "santhosh" as name