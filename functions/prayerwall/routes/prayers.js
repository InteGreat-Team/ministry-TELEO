const express = require("express");
const router = new express.Router();
const {Pool} = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {rejectUnauthorized: false},
});


router.get("/", (req, res) => {
  res.send("✅ Prayer API is running.");
});

// GET /getPrayers
router.get("/getPrayers", async (req, res) => {
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

const admin = require("./db/firebase");
// POST /addPrayer
router.post("/addPrayer", async (req, res) => {
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

// GET /getPrayers
router.get("/getMyPrayers", async (req, res) => {
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
