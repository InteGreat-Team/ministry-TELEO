const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

const admin = require("./db/firebase");
// GET /getPrayers
router.get("/", async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      error: "Missing or invalid Authorization header"},
    );
  }
  const idToken = authHeader.split("Bearer ")[1];
  let decodedToken;
  try {
    decodedToken = await admin.auth().verifyIdToken(idToken);
  } catch (err) {
    console.error("Firebase auth error:", err);
    return res.status(401).json({error: "Invalid or expired token"});
  }

  const uid = decodedToken.uid;

  try {
    const userResult = await pool.query(
        `SELECT id FROM users WHERE firebase_uid = $1`,
        [uid],
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({error: "User not found in database"});
    }
    const userId = userResult.rows[0].id;

    // Pagination params with safe defaults and max limits
    const limit = Math.min(parseInt(req.query.limit) || 20, 50);
    const offset = Math.max(parseInt(req.query.offset) || 0, 0);

    // Single query aggregating prayers, comments, and likes count
    const query = `
      SELECT 
        p.*,
        u.first_name,
        COALESCE(likes.like_count, 0) AS likes,
        COALESCE(comments.comments, '[]') AS comments
      FROM prayers p
      JOIN users u ON p.user_id = u.id
      LEFT JOIN (
        SELECT prayer_id, COUNT(*) AS like_count
        FROM likes
        GROUP BY prayer_id
      ) likes ON likes.prayer_id = p.id
      LEFT JOIN (
        SELECT c.prayer_id, json_agg(json_build_object(
          'id', c.id,
          'text', c.text,
          'created_at', c.created_at,
          'first_name', cu.first_name
        )) AS comments
        FROM comments c
        JOIN users cu ON cu.id = c.user_id
        GROUP BY c.prayer_id
      ) comments ON comments.prayer_id = p.id
      WHERE p.user_id = $1
      ORDER BY p.created_at DESC
      LIMIT $2 OFFSET $3
    `;

    const prayersResult = await pool.query(query, [userId, limit, offset]);
    res.json(prayersResult.rows);
  } catch (err) {
    console.error("Error fetching prayers:", err);
    res.status(500).json({error: "Failed to fetch prayers"});
  }
});

module.exports = router;
