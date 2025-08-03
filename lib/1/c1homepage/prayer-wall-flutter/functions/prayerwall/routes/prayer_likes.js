const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

const admin = require("firebase-admin");

/**
 * Extracts and verifies the user ID from the Bearer token in
 * the Authorization header.
 * @param {Object} req - The Express request object.
 * @return {Promise<number>} The user ID extracted from the token.
 * @throws {Error} If the Authorization header is missing or invalid.
 */
async function getUserIdFromToken(req) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    throw new Error("Missing or invalid Authorization header");
  }

  const idToken = authHeader.split("Bearer ")[1];
  const decodedToken = await admin.auth().verifyIdToken(idToken);
  const uid = decodedToken.uid;

  const userRes = await pool.query(
      `SELECT id FROM users WHERE firebase_uid = $1`, [uid],
  );
  if (userRes.rows.length === 0) throw new Error("User not found");
  return userRes.rows[0].id;
}

// ✅ LIKE PRAYER
router.post("/:id/likePrayer", async (req, res) => {
  const {id: prayerId} = req.params;

  try {
    const userId = await getUserIdFromToken(req);

    const client = await pool.connect();
    try {
      await client.query("BEGIN");

      await client.query(
          `INSERT INTO likes (prayer_id, user_id)
          VALUES ($1, $2)
          ON CONFLICT DO NOTHING`,
          [prayerId, userId],
      );

      await client.query("COMMIT");
      res.status(200).json({success: true, message: "Prayer liked"});
    } catch (err) {
      await client.query("ROLLBACK");
      console.error("Error during like transaction:", err);
      res.status(500).json({error: "Failed to like prayer"});
    } finally {
      client.release();
    }
  } catch (err) {
    console.error("Like error:", err);
    res.status(401).json({error: err.message});
  }
});

// ✅ UNLIKE PRAYER
router.post("/:id/unlikePrayer", async (req, res) => {
  const {id: prayerId} = req.params;

  try {
    const userId = await getUserIdFromToken(req);

    const client = await pool.connect();
    try {
      await client.query("BEGIN");

      await client.query(
          `DELETE FROM likes WHERE prayer_id = $1 AND user_id = $2`,
          [prayerId, userId],
      );

      await client.query("COMMIT");
      res.status(200).json({success: true, message: "Prayer unliked"});
    } catch (err) {
      await client.query("ROLLBACK");
      console.error("Error during unlike transaction:", err);
      res.status(500).json({error: "Failed to unlike prayer"});
    } finally {
      client.release();
    }
  } catch (err) {
    console.error("Unlike error:", err);
    res.status(401).json({error: err.message});
  }
});


module.exports = router;
