require('dotenv').config();
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const cors = require('cors');
const pool = require('./dbs2');

const app = express();
const PORT = process.env.PORT || 3000;

const churchPastors = {
  'grace': [
    { id: 1, name: "Pastor John Smith" },
    { id: 2, name: "Pastor Mary Johnson" }
  ],
  'hope': [
    { id: 3, name: "Pastor David Lee" },
    { id: 4, name: "Pastor Sarah Kim" }
  ],
  'faith': [
    { id: 5, name: "Pastor Michael Brown" },
    { id: 6, name: "Pastor Emily Davis" }
  ]
};

app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// ✅ Create tables
(async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS prayers (
        id SERIAL PRIMARY KEY,
        content TEXT NOT NULL,
        details TEXT,
        post_type VARCHAR(20) NOT NULL CHECK (post_type IN ('public', 'church', 'private')),
        church VARCHAR(50),
        theme_color TEXT,
        likes INT DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS comments (
        id SERIAL PRIMARY KEY,
        prayer_id INT REFERENCES prayers(id),
        text TEXT NOT NULL,
        likes INT DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS tags (
        id SERIAL PRIMARY KEY,
        name TEXT UNIQUE NOT NULL
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS prayer_tags (
        prayer_id INT REFERENCES prayers(id) ON DELETE CASCADE,
        tag_id INT REFERENCES tags(id) ON DELETE CASCADE,
        PRIMARY KEY (prayer_id, tag_id)
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS prayer_pastors (
        prayer_id INT REFERENCES prayers(id) ON DELETE CASCADE,
        pastor_id VARCHAR(50) NOT NULL,
        pastor_name VARCHAR(100) NOT NULL,
        PRIMARY KEY (prayer_id, pastor_id)
      );
    `);

    console.log('✅ Database tables checked/created successfully');
  } catch (error) {
    console.error('❌ Error setting up database tables:', error);
  }
})();

// ✅ Get all prayers
app.get('/api/prayers', async (req, res) => {
  try {
    const prayers = await pool.query(`SELECT * FROM prayers ORDER BY created_at DESC`);
    const comments = await pool.query(`SELECT * FROM comments`);
    const tagLinks = await pool.query(`
      SELECT pt.prayer_id, t.name FROM prayer_tags pt
      JOIN tags t ON pt.tag_id = t.id
    `);
    const pastorLinks = await pool.query(`
      SELECT pp.prayer_id, pp.pastor_id, pp.pastor_name 
      FROM prayer_pastors pp
    `);

    const tagMap = {};
    for (let row of tagLinks.rows) {
      if (!tagMap[row.prayer_id]) tagMap[row.prayer_id] = [];
      tagMap[row.prayer_id].push(row.name);
    }

    const pastorMap = {};
    for (let row of pastorLinks.rows) {
      if (!pastorMap[row.prayer_id]) pastorMap[row.prayer_id] = [];
      pastorMap[row.prayer_id].push({ id: row.pastor_id, name: row.pastor_name });
    }

    const result = prayers.rows.map(prayer => ({
      ...prayer,
      tags: tagMap[prayer.id] || [],
      pastors: pastorMap[prayer.id] || [],
      comments: comments.rows.filter(comment => comment.prayer_id === prayer.id),
    }));

    res.json(result);
  } catch (error) {
    console.error('Error fetching prayers:', error);
    res.status(500).json({ error: 'Failed to fetch prayers' });
  }
});

// ✅ Post a new prayer
app.post('/api/prayers', async (req, res) => {
  const { content, details, tags, postType, church, pastors, themeColor } = req.body;
  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    if (!['public', 'church_community', 'private'].includes(postType)) {
      throw new Error('Invalid post type');
    }

    const prayerResult = await client.query(
      `INSERT INTO prayers (content, details, post_type, church, theme_color) 
       VALUES ($1, $2, $3, $4, $5) RETURNING id`,
      [content, details || null, postType, postType === 'church' ? church : null, themeColor || null]
    );
    const prayerId = prayerResult.rows[0].id;

    if (tags && Array.isArray(tags)) {
      for (let tagName of tags) {
        if (!tagName) continue;

        const tagResult = await client.query(
          `INSERT INTO tags (name) VALUES ($1)
           ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
           RETURNING id`,
          [tagName]
        );

        if (tagResult.rows.length > 0) {
          const tagId = tagResult.rows[0].id;
          await client.query(
            `INSERT INTO prayer_tags (prayer_id, tag_id)
             VALUES ($1, $2) ON CONFLICT DO NOTHING`,
            [prayerId, tagId]
          );
        }
      }
    }

    if (postType === 'church_community' && pastors && Array.isArray(pastors)) {
      for (let pastorId of pastors) {
        const pastor = Object.values(churchPastors).flat().find(p => p.id.toString() === pastorId);
        if (pastor) {
          await client.query(
            `INSERT INTO prayer_pastors (prayer_id, pastor_id, pastor_name)
             VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
            [prayerId, pastorId, pastor.name]
          );
        } else {
          throw new Error(`Invalid pastor ID: ${pastorId}`);
        }
      }
    }

    await client.query('COMMIT');
    res.status(201).json({ message: 'Prayer and tags added successfully', prayerId });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error posting prayer with tags:', err);
    res.status(500).json({ error: 'Failed to post prayer' });
  } finally {
    client.release();
  }
});

// ✅ Post comment
app.post('/api/comments', async (req, res) => {
  const { prayer_id, text } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO comments (prayer_id, text) VALUES ($1, $2) RETURNING *`,
      [prayer_id, text]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting comment:', error);
    res.status(500).json({ error: 'Failed to insert comment' });
  }
});

// ✅ Get comments for specific prayer
app.get('/api/comments/:prayerId', async (req, res) => {
  const { prayerId } = req.params;
  try {
    const result = await pool.query(
      'SELECT * FROM comments WHERE prayer_id = $1 ORDER BY created_at ASC',
      [prayerId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching comments:', error);
    res.status(500).json({ error: 'Failed to fetch comments' });
  }
});

// ✅ Get all tags
app.get('/api/tags', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM tags ORDER BY name');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching tags:', error);
    res.status(500).json({ error: 'Failed to fetch tags' });
  }
});

// ✅ Like a prayer
app.post('/api/prayers/:id/like', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      'UPDATE prayers SET likes = likes + 1 WHERE id = $1 RETURNING *',
      [id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error liking prayer:', error);
    res.status(500).json({ error: 'Failed to like prayer' });
  }
});

// ✅ Unlike a prayer
app.post('/api/prayers/:id/unlike', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      'UPDATE prayers SET likes = likes - 1 WHERE id = $1 RETURNING *',
      [id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error unliking prayer:', error);
    res.status(500).json({ error: 'Failed to unlike prayer' });
  }
});

// ✅ Add a new tag
app.post('/api/tags', async (req, res) => {
  const { name } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO tags (name) VALUES ($1) ON CONFLICT (name) DO NOTHING RETURNING *',
      [name]
    );
    res.status(201).json(result.rows[0] || { name, id: null });
  } catch (error) {
    console.error('Error adding tag to database:', error);
    res.status(500).json({ error: 'Failed to add tag' });
  }
});

// ✅ Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
