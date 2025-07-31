const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});


// GET /api/tags - Get all tags
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM tags ORDER BY name ASC");
    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Error fetching tags:", error);
    res.status(500).json("Failed to fetch tags");
  } finally {
    pool.release();
  }
});


// POST /api/tags - Add a new tag
router.post("/", async (req, res) => {
  const {name} = req.body;


  try {
    const result = await pool.query(
        "INSERT INTO tags (name) VALUES ($1) RETURNING *",
        [name],
    );
    res.status(201).json({success: true, data: result.rows[0]});
  } catch (error) {
    console.error("Error adding tag:", error);
    res.status(500).json({success: false, message: "Failed to add tag"});
  } finally {
    pool.release();
  }
});


module.exports = router;
