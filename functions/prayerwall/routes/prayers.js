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
  try {
    const prayers = await pool.query(`
      SELECT * FROM prayers WHERE post_type = 'public' ORDER BY created_at DESC
    `);
    const comments = await pool.query(`SELECT * FROM comments`);
    const tagLinks = await pool.query(`
      SELECT pt.prayer_id, t.name FROM prayer_tags pt
      JOIN tags t ON pt.tag_id = t.id
    `);
    const pastorLinks = await pool.query(`
      SELECT pp.prayer_id, pp.pastor_id, pp.pastor_name FROM prayer_pastors pp
    `);

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
    }));

    res.json(result);
  } catch (err) {
    console.error("Error fetching prayers:", err);
    res.status(500).json({error: "Failed to fetch prayers"});
  }
});

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

  const client = await pool.connect();
  const churchPastors = {}; // update as needed

  try {
    await client.query(`SET TIME ZONE 'Asia/Manila'`);
    await client.query("BEGIN");

    const prayerResult = await client.query(
        `INSERT INTO prayers (
          content, details, post_type, church, theme_color
        ) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING id, created_at`,
        [
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

// POST /addComment
router.post("/addComment", async (req, res) => {
  const {prayerId, text} = req.body;
  try {
    const result = await pool.query(
        `INSERT INTO comments (prayer_id, text) VALUES ($1, $2) RETURNING *`,
        [prayerId, text],
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error adding comment:", error);
    res.status(500).json({error: "Failed to add comment"});
  }
});

// POST /likePrayer
router.post("/:id/likePrayer", async (req, res) => {
  const {id} = req.params;
  try {
    const result = await pool.query(
        `UPDATE prayers SET likes = likes + 1 WHERE id = $1 RETURNING *`,
        [id],
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error liking prayer:", error);
    res.status(500).json({error: "Failed to like prayer"});
  }
});

// POST /unlikePrayer
router.post("/id:/unlikePrayer", async (req, res) => {
  const {id} = req.params;
  try {
    const result = await pool.query(
        `UPDATE prayers SET likes = likes - 1 WHERE id = $1 RETURNING *`,
        [id],
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error unliking prayer:", error);
    res.status(500).json({error: "Failed to unlike prayer"});
  }
});

module.exports = router;
