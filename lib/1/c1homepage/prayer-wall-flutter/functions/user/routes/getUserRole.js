const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

router.get("/", async (req, res) => {
  const email = req.query.email;

  if (!email) {
    return res.status(400).json({error: "Missing email in query"});
  }

  try {
    const result = await pool.query(
        "SELECT role FROM teleo_users WHERE email_address = $1",
        [email],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({error: "User not found"});
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Error fetching role by email:", error);
    res.status(500).json({error: "Failed to fetch role"});
  }
});

module.exports = router;
