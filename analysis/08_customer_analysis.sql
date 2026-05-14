-- =====================================================
--   08 — Customer Analysis
--   Covers: JOINs, Subqueries, CTEs, Aggregations
-- =====================================================
USE ecommerce_db;

-- Q1: Top 10 customers by total spend
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY total_spent DESC
LIMIT 10;

-- Q2: Customer purchase frequency (how often they order)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS days_as_customer,
    ROUND(COUNT(o.order_id) / NULLIF(DATEDIFF(MAX(o.order_date), MIN(o.order_date)) / 30, 0), 2) AS orders_per_month
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
HAVING total_orders > 1
ORDER BY orders_per_month DESC;

-- Q3: New vs Returning customers per month
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT CASE WHEN o.order_id = first_order.min_order THEN o.customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN o.order_id != first_order.min_order THEN o.customer_id END) AS returning_customers
FROM orders o
JOIN (
    SELECT customer_id, MIN(order_id) AS min_order
    FROM orders
    GROUP BY customer_id
) first_order ON o.customer_id = first_order.customer_id
GROUP BY month
ORDER BY month;

-- Q4: Customer Lifetime Value (CLV)
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.city,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, customer_name, c.city
)
SELECT 
    customer_name,
    city,
    total_orders,
    total_revenue,
    ROUND(total_revenue / total_orders, 2) AS avg_order_value,
    DATEDIFF(last_order_date, first_order_date) AS customer_lifespan_days,
    first_order_date,
    last_order_date
FROM customer_stats
ORDER BY total_revenue DESC;

-- Q5: Customers who haven't ordered in last 6 months (Churn Risk)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.email, c.city
HAVING days_since_last_order > 180
ORDER BY days_since_last_order DESC;

-- Q6: Gender-wise spending analysis
SELECT 
    c.gender,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.gender;

-- Q7: Age group analysis
SELECT 
    CASE 
        WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '45+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY age_group
ORDER BY age_group;