const Pool = require("pg").Pool;

const pool = new Pool({
  user:"postgres",
  password: "yourpassword",
  host: "localhost",
  port: 5432,
  database: "yourdatabase"
});

module.exports = pool;