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

    const prayers = await client.query(`
      SELECT p.*, u.first_name
      FROM prayers p
      JOIN users u ON p.user_id = u.id
      WHERE p.user_id = $1
      ORDER BY p.created_at DESC
    `, [userId]);
    const comments = await client.query(`
    SELECT 
    comments.id,
    comments.prayer_id,
    comments.text,
    comments.created_at,
    users.first_name
    FROM comments
    JOIN users ON comments.user_id = users.id
  `);
    const tagLinks = await client.query(`
      SELECT pt.prayer_id, t.name FROM prayer_tags pt
      JOIN tags t ON pt.tag_id = t.id
    `);
    const pastorLinks = await client.query(`
      SELECT pp.prayer_id, pp.pastor_id, pp.pastor_name FROM prayer_pastors pp
    `);

    const userLikes = await client.query(`
      SELECT prayer_id FROM likes WHERE user_id = $1
    `, [userId]);

    const likedPrayerIds = new Set(
        userLikes.rows.map((row) => row.prayer_id),
    );

    const likesCountResult = await client.query(`
      SELECT prayer_id, COUNT(*) as like_count
      FROM likes
      GROUP BY prayer_id
    `);
    const likeCountMap = {};
    likesCountResult.rows.forEach((row) => {
      likeCountMap[row.prayer_id] = parseInt(row.like_count);
    });

    const tagMap = {};
    for (const row of tagLinks.rows) {
      if (!tagMap[row.prayer_id]) tagMap[row.prayer_id] = [];
      tagMap[row.prayer_id].push(row.name);
    }

    const pastorMap = {};
    for (const row of pastorLinks.rows) {
      if (!pastorMap[row.prayer_id]) pastorMap[row.prayer_id] = [];
      pastorMap[row.prayer_id].push({
        id: row.pastor_id,
        name: row.pastor_name,
      });
    }

    const result = prayers.rows.map((prayer) => ({
      ...prayer,
      tags: tagMap[prayer.id] || [],
      pastors: pastorMap[prayer.id] || [],
      comments: comments.rows.filter(
          (comment) => comment.prayer_id === prayer.id,
      ),
      hasLiked: likedPrayerIds.has(prayer.id),
      likes: likeCountMap[prayer.id] || 0,
    }));

    res.json(result);
  } catch (err) {
    console.error("Error fetching prayers:", err);
    res.status(500).json({error: "Failed to fetch prayers"});
  } finally {
    client.release;
  }
});

module.exports = router;
