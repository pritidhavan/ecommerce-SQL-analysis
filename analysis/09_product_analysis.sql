-- =====================================================
--   09 — Product Analysis
--   Covers: Multi-table JOINs, Profit Analysis, CTEs
-- =====================================================
USE ecommerce_db;

-- Q1: Top 10 best-selling products by quantity
SELECT 
    p.product_name,
    p.brand,
    cat.category_name,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.brand, cat.category_name
ORDER BY total_units_sold DESC
LIMIT 10;

-- Q2: Product profitability analysis
SELECT 
    p.product_name,
    p.brand,
    p.price AS selling_price,
    p.cost_price,
    ROUND(p.price - p.cost_price, 2) AS profit_per_unit,
    ROUND((p.price - p.cost_price) / p.price * 100, 2) AS profit_margin_pct,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * (p.price - p.cost_price)), 2) AS total_profit
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.brand, p.price, p.cost_price
ORDER BY total_profit DESC;

-- Q3: Category-wise revenue breakdown
SELECT 
    cat.category_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) * 100.0 /
        SUM(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100))) OVER(), 2) AS revenue_share_pct
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY cat.category_id, cat.category_name
ORDER BY revenue DESC;

-- Q4: Products never ordered (dead inventory)
SELECT 
    p.product_name,
    p.brand,
    cat.category_name,
    p.stock_quantity,
    p.price
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Q5: Brand performance comparison
SELECT 
    p.brand,
    COUNT(DISTINCT p.product_id) AS products_listed,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue,
    ROUND(AVG(p.rating), 2) AS avg_rating
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.brand
ORDER BY total_revenue DESC
LIMIT 10;

-- Q6: Frequently bought together (product pairs)
SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY p1.product_id, p2.product_id, p1.product_name, p2.product_name
ORDER BY times_bought_together DESC
LIMIT 10;