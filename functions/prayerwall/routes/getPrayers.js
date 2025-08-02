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
    const userId = userResult.rows[0].id;

    const query = `
      WITH
        user_likes AS (
          SELECT prayer_id
          FROM likes
          WHERE user_id = $1
        ),
        like_counts AS (
          SELECT prayer_id, COUNT(*) AS like_count
          FROM likes
          GROUP BY prayer_id
        ),
        prayer_tags_agg AS (
          SELECT pt.prayer_id, json_agg(t.name) AS tags
          FROM prayer_tags pt
          JOIN tags t ON pt.tag_id = t.id
          GROUP BY pt.prayer_id
        ),
        prayer_pastors_agg AS (
          SELECT pp.prayer_id,
                 json_agg(json_build_object(
                 'id', pp.pastor_id, 'name', pp.pastor_name)
                 ) AS pastors
          FROM prayer_pastors pp
          GROUP BY pp.prayer_id
        ),
        prayer_comments_agg AS (
          SELECT c.prayer_id,
                 json_agg(
                   json_build_object(
                     'id', c.id,
                     'text', c.text,
                     'created_at', c.created_at,
                     'first_name', u.first_name
                   )
                   ORDER BY c.created_at DESC
                 ) AS comments
          FROM comments c
          JOIN users u ON c.user_id = u.id
          GROUP BY c.prayer_id
        )

      SELECT
        p.*,
        u.first_name,
        COALESCE(pt.tags, '[]') AS tags,
        COALESCE(pp.pastors, '[]') AS pastors,
        COALESCE(pc.comments, '[]') AS comments,
        COALESCE(lc.like_count, 0)::int AS likes,
        CASE WHEN ul.prayer_id IS NOT NULL 
        THEN true ELSE false END AS "hasLiked"
      FROM prayers p
      JOIN users u ON p.user_id = u.id
      LEFT JOIN prayer_tags_agg pt ON p.id = pt.prayer_id
      LEFT JOIN prayer_pastors_agg pp ON p.id = pp.prayer_id
      LEFT JOIN prayer_comments_agg pc ON p.id = pc.prayer_id
      LEFT JOIN like_counts lc ON p.id = lc.prayer_id
      LEFT JOIN user_likes ul ON p.id = ul.prayer_id
      WHERE p.post_type = 'public'
      ORDER BY p.created_at DESC
      LIMIT 50
    `;
    const {rows} = await client.query(query, [userId]);

    res.json(rows);
  } catch (err) {
    console.error("Error fetching prayers:", err);
    res.status(500).json({error: "Failed to fetch prayers"});
  } finally {
    client.release;
  }
});

module.exports = router;
