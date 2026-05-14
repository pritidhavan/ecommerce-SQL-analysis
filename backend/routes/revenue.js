const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// Monthly — 2023 vs 2024
router.get('/monthly', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        MONTH(o.order_date) AS month_num,
        MONTHNAME(o.order_date) AS month_name,
        ROUND(SUM(CASE WHEN YEAR(o.order_date)=2023
          THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct/100) ELSE 0 END),2) AS rev_2023,
        ROUND(SUM(CASE WHEN YEAR(o.order_date)=2024
          THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct/100) ELSE 0 END),2) AS rev_2024
      FROM orders o
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
      ORDER BY month_num
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Payment methods
router.get('/payments', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT payment_method,
        COUNT(*) AS count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
      FROM orders
      GROUP BY payment_method
      ORDER BY count DESC
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Quarterly
router.get('/quarterly', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        YEAR(o.order_date) AS year,
        QUARTER(o.order_date) AS quarter,
        CONCAT('Q', QUARTER(o.order_date), ' ', YEAR(o.order_date)) AS label,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM orders o
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
      ORDER BY year, quarter
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// States
router.get('/states', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT o.shipping_state AS state,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM orders o
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY o.shipping_state
      ORDER BY revenue DESC
      LIMIT 6
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;