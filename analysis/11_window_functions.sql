-- =====================================================
--   11 — Window Functions (Most Asked in Interviews!)
--   Covers: RANK, DENSE_RANK, ROW_NUMBER, LAG, LEAD,
--           NTILE, FIRST_VALUE, LAST_VALUE, Running Total
-- =====================================================
USE ecommerce_db;

-- Q1: RANK customers by total spend
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) DESC) AS spend_rank,
    DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) DESC) AS dense_rank_val
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, customer_name, c.city;

-- Q2: Top product per category using RANK
WITH product_revenue AS (
    SELECT 
        cat.category_name,
        p.product_name,
        p.brand,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue,
        RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rank_in_category
    FROM products p
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Delivered'
    GROUP BY cat.category_name, p.product_id, p.product_name, p.brand
)
SELECT category_name, product_name, brand, revenue, rank_in_category
FROM product_revenue
WHERE rank_in_category = 1;

-- Q3: Month-over-Month revenue change using LAG
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS mom_change,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / 
          LAG(revenue) OVER (ORDER BY month) * 100, 2) AS mom_growth_pct,
    LEAD(revenue) OVER (ORDER BY month) AS next_month_revenue
FROM monthly_revenue;

-- Q4: Running total of revenue
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS monthly_revenue,
    ROUND(SUM(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100))) 
          OVER (ORDER BY DATE_FORMAT(o.order_date, '%Y-%m')), 2) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- Q5: Customer quartile segmentation using NTILE
WITH customer_spend AS (
    SELECT 
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.city,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, customer_name, c.city
)
SELECT 
    customer_name,
    city,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent DESC)
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        WHEN 4 THEN 'Bronze'
    END AS customer_tier
FROM customer_spend
ORDER BY total_spent DESC;

-- Q6: ROW_NUMBER for deduplication pattern
SELECT * FROM (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        oi.product_id,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
) ranked
WHERE rn = 1;  -- Most recent order per customer

-- Q7: Moving average (3-month) of revenue
WITH monthly_rev AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    month,
    revenue,
    ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3m
FROM monthly_rev
ORDER BY month;