const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

// POST /prayers/markAsRead
router.post("/", async (req, res) => {
  const {prayerId, readStatus} = req.body;

  if (!prayerId || !readStatus) {
    return res.status(400).json({error: "Missing prayerId or read_status"});
  }

  try {
    await pool.query(
        `UPDATE prayers SET read_status = $1 WHERE id = $2`,
        [readStatus, prayerId],
    );

    return res.status(200).json({message: "Prayer marked as read"});
  } catch (err) {
    console.error("Error updating prayer:", err);
    return res.status(500).json({error: "Internal server error"});
  }
});


module.exports = router;
