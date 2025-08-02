const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

const admin = require("./db/firebase");

router.get("/", async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json(
        {error: "Missing or invalid Authorization header"},
    );
  }


  const idToken = authHeader.split("Bearer ")[1];
  const client = await pool.connect();

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    const userResult = await client.query(
        `SELECT id FROM users WHERE firebase_uid = $1`,
        [uid],
    );
    if (userResult.rows.length === 0) {
      return res.status(404).json({error: "User not found in database"});
    }

    const limit = parseInt(req.query.limit) || 20;
    const offset = parseInt(req.query.offset) || 0;

    // --- Optimized with JOINs and subqueries ---
    const prayersQuery = `
      SELECT 
        p.*,
        u.first_name,
        COALESCE(l.like_count, 0) AS likes,
        json_agg(
          json_build_object(
            'id', c.id,
            'text', c.text,
            'created_at', c.created_at,
            'first_name', cu.first_name
          )
        ) FILTER (WHERE c.id IS NOT NULL) AS comments
      FROM prayers p
      JOIN users u ON p.user_id = u.id
      LEFT JOIN (
        SELECT prayer_id, COUNT(*) AS like_count
        FROM likes
        GROUP BY prayer_id
      ) l ON l.prayer_id = p.id
      LEFT JOIN comments c ON c.prayer_id = p.id
      LEFT JOIN users cu ON cu.id = c.user_id
      WHERE p.post_type = 'public'
      GROUP BY p.id, u.first_name, l.like_count
      ORDER BY p.created_at DESC
      LIMIT $1 OFFSET $2
    `;

    const result = await client.query(prayersQuery, [limit, offset]);
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching prayers:", err);
    res.status(500).json({error: "Failed to fetch prayers"});
  } finally {
    client.release;
  }
});

module.exports = router;
