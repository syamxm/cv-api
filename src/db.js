const { Pool } = require("pg");

const pool = new Pool({
  host:     process.env.DB_HOST,
  port:     process.env.DB_PORT,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

pool.connect((err, client, release) => {
  if (err) {
    console.error("Failed to connect to PostgreSQL:", err.message);
    process.exit(1);
  }
  console.log("PostgreSQL connected successfully");
  release();
});

module.exports = pool;
