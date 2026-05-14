const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// Top 5
router.get('/top', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        CONCAT(c.first_name,' ',c.last_name) AS name,
        c.city,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_spent
      FROM customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY c.customer_id, name, c.city
      ORDER BY total_spent DESC
      LIMIT 5
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Gender
router.get('/gender', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT c.gender,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY c.gender
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Age groups
router.get('/age', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        CASE
          WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
          WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
          WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
          ELSE '45+'
        END AS age_group,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_items oi ON o.order_id = oi.order_id
      WHERE o.status = 'Delivered'
      GROUP BY age_group
      ORDER BY age_group
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;