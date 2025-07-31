const express = require("express");
const router = new express.Router(); // No need to use `new`
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});


// Create a comment
router.post("/", async (req, res) => {
  const {prayerId, text} = req.body;

  const client = await pool.connect();

  try {
    await client.query(`SET TIME ZONE 'Asia/Manila'`);
    await client.query("BEGIN");

    const result = await client.query(
        `INSERT INTO comments (prayer_id, text)
        VALUES ($1, $2)
        RETURNING id, prayer_id, text, created_at`,
        [prayerId, text],
    );

    await client.query("COMMIT");
    res.status(201).json(result.rows[0]);
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error inserting comment:", error);
    res.status(500).json({error: "Failed to insert comment"});
  } finally {
    client.release(); // FIXED: client was undefined before
  }
});

module.exports = router;
