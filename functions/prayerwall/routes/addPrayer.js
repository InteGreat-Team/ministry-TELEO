const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});

const admin = require("./db/firebase");
// POST /addPrayer
router.post("/", async (req, res) => {
  const {
    content,
    details,
    tags,
    postType,
    church,
    pastors,
    themeColor,
  } = req.body;
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json(
        {error: "Missing or invalid Authorization header"},
    );
  }

  const idToken = authHeader.split("Bearer ")[1];

  const client = await pool.connect();
  const churchPastors = {}; // update as needed

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // 2. Get user info from your DB
    const userResult = await client.query(
        `SELECT id, first_name FROM users WHERE firebase_uid = $1`,
        [uid],
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({error: "User not found in database"});
    }

    const userid = userResult.rows[0].id;

    await client.query(`SET TIME ZONE 'Asia/Manila'`);
    await client.query("BEGIN");

    const prayerResult = await client.query(
        `INSERT INTO prayers (
          user_id, content, details, post_type, church, theme_color
        ) 
        VALUES ($1, $2, $3, $4, $5, $6) 
        RETURNING id, created_at`,
        [
          userid,
          content,
          details || null,
          postType,
          postType === "church_community" ? church : null,
          themeColor || null,
        ],
    );

    const prayerId = prayerResult.rows[0].id;
    const createdAt = prayerResult.rows[0].created_at;

    if (tags && Array.isArray(tags)) {
      for (const tagName of tags) {
        const tagResult = await client.query(
            `INSERT INTO tags (name) 
            VALUES ($1) 
            ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name 
            RETURNING id`,
            [tagName],
        );

        const tagId = tagResult.rows[0].id;
        await client.query(
            `INSERT INTO prayer_tags (prayer_id, tag_id) 
            VALUES ($1, $2) ON CONFLICT DO NOTHING`,
            [prayerId, tagId],
        );
      }
    }

    if (postType === "church_community" && Array.isArray(pastors)) {
      for (const pastorId of pastors) {
        const pastor = Object.values(churchPastors)
            .flat()
            .find((p) => p.id.toString() === pastorId);

        if (pastor) {
          await client.query(
              `INSERT INTO prayer_pastors (prayer_id, pastor_id, pastor_name) 
              VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
              [prayerId, pastorId, pastor.name],
          );
        } else {
          throw new Error(`Invalid pastor ID: ${pastorId}`);
        }
      }
    }

    await client.query("COMMIT");
    res.status(201).json({message: "Prayer added", prayerId, createdAt});
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error adding prayer:", err);
    res.status(500).json({error: "Failed to add prayer"});
  } finally {
    client.release();
  }
});


module.exports = router;
