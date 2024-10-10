CREATE DATABASE pizza;
USE pizza;

-- total revenue
SELECT SUM(total_price) AS total_revenue FROM pizza_sales;

-- average order value
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS average_order_value FROM pizza_sales;

-- total pizzas sold
SELECT SUM(quantity) AS total_pizza_sold FROM pizza_sales;

-- total orders
SELECT COUNT(DISTINCT order_id) as total_orders FROM pizza_sales;

-- quantity per order
SELECT COUNT(quantity)/COUNT(DISTINCT order_id) AS average_quantity FROM pizza_sales;

-- hourly trend of pizzas sold
SELECT HOUR(order_time) AS hours, SUM(quantity) AS quantity_count
FROM pizza_sales GROUP BY hours ORDER BY hours;

-- weekly trend of total order
SELECT year(STR_TO_DATE(order_date, '%d-%m-%Y')) as years, WEEKOFYEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) as weeks,
COUNT(DISTINCT order_id) AS order_count FROM pizza_sales GROUP BY weeks, years ORDER BY weeks;

-- category wise revenue
WITH category_revenue AS
(SELECT pizza_category, SUM(total_price) AS category_revenue FROM pizza_sales GROUP BY pizza_category),
total_revenue AS ( SELECT SUM(category_revenue) as total_revenue FROM category_revenue)
SELECT pizza_category, ROUND((category_revenue*100)/total_revenue,2) FROM category_revenue, total_revenue;

-- size wise revenue
WITH size_revenue AS
(SELECT pizza_size, SUM(total_price) AS size_revenue FROM pizza_sales GROUP BY pizza_size ORDER BY size_revenue DESC),
total_revenue AS ( SELECT SUM(size_revenue) as total_revenue FROM size_revenue)
SELECT pizza_size, ROUND((size_revenue*100)/total_revenue,2) FROM size_revenue, total_revenue;

-- top 5 best sellers by revenue
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue DESC) AS ranking, topBy_revenue FROM
(SELECT pizza_name, SUM(total_price) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;

-- top 5 best sellers by quantity
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue DESC) AS ranking, topBy_revenue FROM
(SELECT pizza_name, SUM(quantity) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;

-- top 5 best sellers by orders
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue DESC) AS ranking, topBy_revenue FROM
(SELECT pizza_name, COUNT(Distinct order_id) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;

-- top 5 worst sellers by revenue
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue) AS ranking, topBy_revenue FROM
(SELECT pizza_name, ROUND(SUM(total_price),2) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;

-- top 5 worst sellers by quantity
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue) AS ranking, topBy_revenue FROM
(SELECT pizza_name, SUM(quantity) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;

-- top 5 worst sellers by orders
SELECT pizza_name, topBy_revenue FROM
(SELECT pizza_name, RANK() OVER(ORDER BY topBy_revenue) AS ranking, topBy_revenue FROM
(SELECT pizza_name, COUNT(DISTINCT order_id) AS topBy_revenue FROM pizza_sales GROUP BY pizza_name ORDER BY topBy_revenue DESC)
AS X)AS Y WHERE ranking <=5;


