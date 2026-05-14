const express = require('express');
const router  = express.Router();
const pool    = require('../db');

router.get('/', async (req, res) => {
  try {
    const [[revenue]] = await pool.query(`
      SELECT ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue
      FROM order_items oi
      JOIN orders o ON oi.order_id = o.order_id
      WHERE o.status = 'Delivered'
    `);

    const [[orders]] = await pool.query(`
      SELECT COUNT(*) AS total_orders FROM orders WHERE status = 'Delivered'
    `);

    const [[customers]] = await pool.query(`
      SELECT COUNT(DISTINCT customer_id) AS active_customers
      FROM orders WHERE status = 'Delivered'
    `);

    const [[aov]] = await pool.query(`
      SELECT ROUND(AVG(order_total), 2) AS avg_order_value FROM (
        SELECT o.order_id,
          SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) AS order_total
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.status = 'Delivered'
        GROUP BY o.order_id
      ) t
    `);

    const [[cancel]] = await pool.query(`
      SELECT ROUND(
        SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
      ) AS cancellation_rate FROM orders
    `);

    res.json({
      total_revenue:     revenue.total_revenue,
      total_orders:      orders.total_orders,
      active_customers:  customers.active_customers,
      avg_order_value:   aov.avg_order_value,
      cancellation_rate: cancel.cancellation_rate,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;