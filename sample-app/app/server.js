const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();
app.use(express.static(path.join(__dirname, 'public')));

const pool = mysql.createPool({
  host: 'mysql',
  user: 'root',
  password: 'root',
  database: 'sample_db',
  charset: 'utf8mb4',
  waitForConnections: true,
});

// 상위 3개 품목 (재고 기준)
app.get('/api/top-items', async (req, res) => {
  const [rows] = await pool.query(`
    SELECT i.id, i.item_code, i.item_name, i.category,
           FORMAT(i.unit_price, 0) AS unit_price,
           i.stock_qty, i.unit,
           m.name AS manufacturer_name, m.code AS manufacturer_code
    FROM item i
    JOIN manufacturer m ON i.manufacturer_id = m.id
    WHERE i.is_active = 1
    ORDER BY i.stock_qty DESC
    LIMIT 3
  `);
  res.json(rows);
});

// 품목 상세 + 흐름 데이터
app.get('/api/item/:id', async (req, res) => {
  const [rows] = await pool.query(`
    SELECT i.*,
           FORMAT(i.unit_price, 0) AS unit_price_fmt,
           m.name AS manufacturer_name, m.code AS manufacturer_code,
           m.country
    FROM item i
    JOIN manufacturer m ON i.manufacturer_id = m.id
    WHERE i.id = ?
  `, [req.params.id]);

  if (!rows.length) return res.status(404).json({ error: 'Not found' });

  const item = rows[0];
  const query = `SELECT i.*, m.name AS manufacturer_name
FROM item i
JOIN manufacturer m ON i.manufacturer_id = m.id
WHERE i.id = ${item.id}`;

  res.json({ item, query });
});

app.listen(3000, () => console.log('Server running on http://localhost:3000'));
