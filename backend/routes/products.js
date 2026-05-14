const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// Top 6 products
router.get('/top', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT p.product_name, p.brand,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM products p
      JOIN order_items oi ON p.product_id = oi.product_id
      JOIN orders o ON oi.order_id = o.order_id
      WHERE o.status = 'Delivered'
      GROUP BY p.product_id, p.product_name, p.brand
      ORDER BY revenue DESC
      LIMIT 6
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Categories
router.get('/categories', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT cat.category_name,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
      FROM categories cat
      JOIN products p ON cat.category_id = p.category_id
      JOIN order_items oi ON p.product_id = oi.product_id
      JOIN orders o ON oi.order_id = o.order_id
      WHERE o.status = 'Delivered'
      GROUP BY cat.category_id, cat.category_name
      ORDER BY revenue DESC
      LIMIT 6
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;