-- =====================================================
--   12 — Business Insights (Senior-Level Queries)
--   Covers: Cohort Analysis, RFM, Funnel, Retention
-- =====================================================
USE ecommerce_db;

-- Q1: RFM Analysis (Recency, Frequency, Monetary)
-- Most important DA/DS interview query!
WITH rfm_base AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, customer_name
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_base
)
SELECT 
    customer_name,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS total_rfm_score,
    CASE 
        WHEN (r_score + f_score + m_score) >= 12 THEN 'Champion'
        WHEN (r_score + f_score + m_score) >= 9  THEN 'Loyal Customer'
        WHEN (r_score + f_score + m_score) >= 6  THEN 'Potential Loyalist'
        WHEN r_score >= 4 AND (f_score + m_score) < 4 THEN 'New Customer'
        WHEN r_score <= 2 AND (f_score + m_score) >= 8 THEN 'At Risk'
        ELSE 'Lost Customer'
    END AS customer_segment
FROM rfm_scores
ORDER BY total_rfm_score DESC;

-- Q2: Cohort Analysis — Monthly retention
WITH first_purchase AS (
    SELECT customer_id, DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY customer_id
),
order_months AS (
    SELECT 
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        fp.cohort_month,
        PERIOD_DIFF(
            PERIOD(YEAR(o.order_date), MONTH(o.order_date)),
            PERIOD(YEAR(STR_TO_DATE(fp.cohort_month, '%Y-%m')), MONTH(STR_TO_DATE(fp.cohort_month, '%Y-%m')))
        ) AS months_since_first
    FROM orders o
    JOIN first_purchase fp ON o.customer_id = fp.customer_id
    WHERE o.status = 'Delivered'
)
SELECT 
    cohort_month,
    months_since_first,
    COUNT(DISTINCT customer_id) AS customers
FROM order_months
GROUP BY cohort_month, months_since_first
ORDER BY cohort_month, months_since_first;

-- Q3: Order cancellation and return analysis
SELECT 
    o.status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY total_orders DESC;

-- Q4: Average delivery time analysis
SELECT 
    o.shipping_state,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(DATEDIFF(o.delivery_date, o.order_date)), 1) AS avg_delivery_days,
    MIN(DATEDIFF(o.delivery_date, o.order_date)) AS min_days,
    MAX(DATEDIFF(o.delivery_date, o.order_date)) AS max_days
FROM orders o
WHERE o.status = 'Delivered' AND o.delivery_date IS NOT NULL
GROUP BY o.shipping_state
ORDER BY avg_delivery_days;

-- Q5: Cross-sell opportunity — customers who bought electronics but not accessories
SELECT DISTINCT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_name IN ('Mobile Phones', 'Laptops')
AND c.customer_id NOT IN (
    SELECT DISTINCT o2.customer_id
    FROM orders o2
    JOIN order_items oi2 ON o2.order_id = oi2.order_id
    JOIN products p2 ON oi2.product_id = p2.product_id
    JOIN categories cat2 ON p2.category_id = cat2.category_id
    WHERE cat2.category_name = 'Headphones'
);

-- Q6: Executive Summary Dashboard Query
SELECT 
    'Total Revenue' AS metric,
    CONCAT('₹', FORMAT(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 0)) AS value
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id WHERE o.status = 'Delivered'
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_id) FROM orders WHERE status = 'Delivered'
UNION ALL
SELECT 'Total Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Active Customers', COUNT(DISTINCT customer_id) FROM orders WHERE status = 'Delivered'
UNION ALL
SELECT 'Avg Order Value', CONCAT('₹', FORMAT(
    (SELECT AVG(sub.order_val) FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price * (1 - oi2.discount_pct/100)) AS order_val
        FROM orders o2 JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE o2.status = 'Delivered' GROUP BY o2.order_id
    ) sub), 0))
FROM dual
UNION ALL
SELECT 'Cancellation Rate', CONCAT(ROUND(
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%')
FROM orders;