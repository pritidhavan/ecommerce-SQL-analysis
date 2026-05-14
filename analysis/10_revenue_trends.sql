-- =====================================================
--   10 — Revenue Trends Analysis
--   Covers: Date Functions, YoY Growth, MoM Growth
-- =====================================================
USE ecommerce_db;

-- Q1: Monthly revenue trend (2023 vs 2024)
SELECT 
    MONTHNAME(o.order_date) AS month_name,
    MONTH(o.order_date) AS month_num,
    ROUND(SUM(CASE WHEN YEAR(o.order_date) = 2023 THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct/100) ELSE 0 END), 2) AS revenue_2023,
    ROUND(SUM(CASE WHEN YEAR(o.order_date) = 2024 THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct/100) ELSE 0 END), 2) AS revenue_2024
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY month_name, month_num
ORDER BY month_num;

-- Q2: Year-over-Year growth rate
WITH yearly_revenue AS (
    SELECT 
        YEAR(o.order_date) AS year,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY YEAR(o.order_date)
)
SELECT 
    year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY year)) / 
          LAG(total_revenue) OVER (ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM yearly_revenue;

-- Q3: Quarter-wise revenue
SELECT 
    YEAR(o.order_date) AS year,
    QUARTER(o.order_date) AS quarter,
    CONCAT('Q', QUARTER(o.order_date), ' ', YEAR(o.order_date)) AS period,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS quarterly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
ORDER BY year, quarter;

-- Q4: Day of week sales pattern
SELECT 
    DAYNAME(o.order_date) AS day_of_week,
    DAYOFWEEK(o.order_date) AS day_num,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY DAYNAME(o.order_date), DAYOFWEEK(o.order_date)
ORDER BY day_num;

-- Q5: Revenue by state (geographic heatmap data)
SELECT 
    o.shipping_state AS state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY o.shipping_state
ORDER BY total_revenue DESC;

-- Q6: Discount impact on revenue
SELECT 
    CASE 
        WHEN oi.discount_pct = 0 THEN 'No Discount'
        WHEN oi.discount_pct BETWEEN 1 AND 5 THEN '1-5%'
        WHEN oi.discount_pct BETWEEN 6 AND 10 THEN '6-10%'
        ELSE '10%+'
    END AS discount_range,
    COUNT(*) AS total_items,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS gross_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS net_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price * oi.discount_pct/100), 2) AS total_discount_given
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY discount_range
ORDER BY total_discount_given DESC;