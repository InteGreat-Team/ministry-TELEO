const express = require("express");
const router = new express.Router(); // No need to use `new`
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

const admin = require("./db/firebase");
// Create a comment
router.post("/", async (req, res) => {
  const {prayerId, text} = req.body;
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json(
        {error: "Missing or invalid Authorization header"},
    );
  }

  const idToken = authHeader.split("Bearer ")[1];

  let client;

  try {
    // 👇 Verify Firebase token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    client = await pool.connect();
    await client.query(`SET TIME ZONE 'Asia/Manila'`);
    await client.query("BEGIN");

    // 👇 Get numeric user ID and name
    const userRes = await client.query(
        `SELECT id, first_name FROM users WHERE firebase_uid = $1`,
        [uid],
    );

    if (userRes.rows.length === 0) {
      throw new Error("User not found in database");
    }

    const userId = userRes.rows[0].id;
    const firstName = userRes.rows[0].first_name;

    // 👇 Insert comment using numeric user_id
    const insertRes = await client.query(
        `INSERT INTO comments (prayer_id, text, user_id)
        VALUES ($1, $2, $3)
        RETURNING id, prayer_id, text, created_at`,
        [prayerId, text, userId],
    );

    await client.query("COMMIT");

    const comment = insertRes.rows[0];
    res.status(201).json({
      ...comment,
      first_name: firstName,
    });
  } catch (err) {
    if (client) await client.query("ROLLBACK");
    console.error("DB error:", err);
    res.status(500).json({error: "Failed to insert comment"});
  } finally {
    if (client) client.release();
  }
});


module.exports = router;
