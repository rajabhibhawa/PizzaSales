create database pizzadb; #membuat database
use  pizzadb; #menggunakan database
#import data csv
select *
from pizza_sales_proper;

-- Formating the correct data types
CREATE TABLE pizza_sales_proper (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(255),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(255)
);

-- Import data with text types, then convert
INSERT INTO pizza_sales_proper
SELECT 
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    STR_TO_DATE(order_date, '%d-%m-%Y') as order_date,  
    CAST(order_time AS TIME) as order_time,              
    CAST(unit_price AS DECIMAL(10,2)) as unit_price,
    CAST(total_price AS DECIMAL(10,2)) as total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
FROM pizza_sales;

#Answering KPI 
#Total revenue 
select sum(total_price) as Total_Revenue
from pizza_sales;

#Average Order Value -- #distinct = no duplicate
select sum(total_price) / COUNT(distinct(order_id)) as Average_Order_Value
from pizza_sales;

#Total pizza sold
select sum(quantity) as Total_Pizza_Sold
from pizza_sales_proper;

#Total number of order
select count(distinct order_id) as Total_Order
from pizza_sales_proper;

#Average pizza per order -- #cast = merubah variable - desimal(10,2) 8 didepan koma , 2 angka di belakang koma
select cast(cast(sum(quantity) as decimal (10,2))  / cast(count(distinct order_id) as decimal(10,2)) as decimal (10,2)) as Average_Pizza_per_Order
from pizza_sales_proper;

#Daily Trend for Total Orders -- #dayname - namahari 
SELECT dayname(ORDER_DATE) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales_proper
GROUP BY dayname(order_date)
order by total_orders desc;


#Monthly Trend for Total Orders -- #monthname -- namabulan
select monthname(order_date) as Order_month, count(distinct order_id) as total_orders
from pizza_sales_proper
group by monthname(order_date)
order by total_orders desc;

#Percentage of Sales by Pizza Category
select pizza_category, sum(total_price) as total_sales, cast((sum(total_price)) * 100 / (select sum(total_price) from pizza_sales_proper) as decimal (10,2)) as percentage_of_sales
from pizza_sales_proper
group by pizza_category
order by percentage_of_sales desc;

#Percentage of Sales by Pizza Category / month
select pizza_category, sum(total_price) as total_sales, cast((sum(total_price)) * 100 / (select sum(total_price) from pizza_sales_proper where month(order_date) = 1) as decimal (10,2)) as percentage_of_sales
from pizza_sales_proper
where month(order_date) = 1  -- Change the month(value)
group by pizza_category
order by percentage_of_sales desc;

#Percentage of Sales by Pizza Size 
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_revenue, cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales_proper) as decimal (10,2)) as percentage_of_sales
from pizza_sales_proper
group by pizza_size
order by percentage_of_sales desc; 

#Percentage of Sales by Pizza Size / size
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_revenue, cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales_proper) as decimal (10,2)) as percentage_of_sales
from pizza_sales_proper
where pizza_size ='L'
group by pizza_size
order by percentage_of_sales desc; 

#Total Pizzas sold by categori
select pizza_category, sum(quantity) as Total_Pizza_sold
from pizza_sales_proper
group by pizza_category;

#Total Pizzas sold by categori / Categori
select pizza_category, sum(quantity) as Total_Pizza_sold
from pizza_sales_proper
where pizza_category = 'Classic'
group by pizza_category;


#Top 5 Best Sellers by Total Pizzas Sold:
select pizza_name, sum(quantity) as Total_sold
from pizza_sales_proper
group by pizza_name
order by total_sold desc
LIMIT 5;

#Total Pizzas sold
select pizza_name, sum(quantity) as Total_sold
from pizza_sales_proper
group by pizza_name
order by Total_sold desc;

#Bottom 5 Worst Sellers by Total Pizzas Sold:
select pizza_name, sum(quantity) as Total_sold
from pizza_sales_proper
group by pizza_name
order by total_sold asc
LIMIT 5;

#Pizza's by Revenue
select pizza_name, sum(total_price) as revenue
from pizza_sales_proper
group by pizza_name
order by revenue desc;

#Top 5 Best Pizza's by Revenue
select pizza_name, sum(total_price) as revenue
from pizza_sales_proper
group by pizza_name
order by revenue desc
limit 5;

#Bottom 5 Pizza's by revenue
select pizza_name, sum(total_price) as revenue
from pizza_sales_proper
group by pizza_name
order by revenue asc
limit 5;

select *
from pizza_sales_proper;

#Pizzas by Total Orders
select pizza_name, count(distinct(order_id)) as total_order
from pizza_sales_proper
group by pizza_name
order by total_order desc;

#Top 5 Pizzas by Total Orders
select pizza_name, count(distinct(order_id)) as total_order
from pizza_sales_proper
group by pizza_name
order by total_order desc
limit 5;

#Bottom 5 Pizzas by Total Orders
select pizza_name, count(distinct(order_id)) as total_order
from pizza_sales_proper
group by pizza_name
order by total_order asc
limit 5;