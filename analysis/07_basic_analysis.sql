-- =====================================================
--   07 — Basic Analysis
--   Covers: SELECT, WHERE, GROUP BY, ORDER BY, HAVING
-- =====================================================
USE ecommerce_db;

-- Q1: Total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Q2: Total orders by status
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- Q3: Total revenue generated
SELECT 
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered';

-- Q4: Top 5 most expensive products
SELECT product_name, brand, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- Q5: Customers from Maharashtra
SELECT first_name, last_name, city
FROM customers
WHERE state = 'Maharashtra'
ORDER BY city;

-- Q6: Orders placed in 2024
SELECT COUNT(*) AS orders_2024
FROM orders
WHERE YEAR(order_date) = 2024;

-- Q7: Payment method distribution
SELECT 
    payment_method,
    COUNT(*) AS usage_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY payment_method
ORDER BY usage_count DESC;

-- Q8: Average order value by state
SELECT 
    o.shipping_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY o.shipping_state
HAVING total_orders > 3
ORDER BY avg_order_value DESC;

-- Q9: Products with low stock (less than 50 units)
SELECT product_name, brand, stock_quantity
FROM products
WHERE stock_quantity < 50
ORDER BY stock_quantity ASC;

-- Q10: Monthly order count for 2023
SELECT 
    MONTH(order_date) AS month_num,
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS total_orders
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_num;