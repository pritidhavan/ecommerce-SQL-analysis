const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/kpis',      require('./routes/kpis'));
app.use('/api/revenue',   require('./routes/revenue'));
app.use('/api/customers', require('./routes/customers'));
app.use('/api/products',  require('./routes/products'));

app.get('/', (req, res) => {
  res.json({ status: '✅ E-Commerce Analytics API running!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});