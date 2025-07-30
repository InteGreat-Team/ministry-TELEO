console.log("🚨🚨 Running FULL donation.js with PayMongo + DB (Firebase Version)");

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const axios = require("axios");
const { Pool } = require("pg");

dotenv.config();

const app = express();

// Logging env status
console.log("ENV: PAYMONGO_SECRET_KEY", process.env.PAYMONGO_SECRET_KEY ? "Loaded" : "Missing");
console.log("ENV: NEON_DB_URL", process.env.NEON_DB_URL ? "Loaded" : "Missing");

// Middleware
app.use(cors({ origin: true }));
app.use(express.json());

// PostgreSQL setup (Neon DB)
const pool = new Pool({
  connectionString: process.env.NEON_DB_URL,
  ssl: { rejectUnauthorized: false }
});

// Initialize DB
const initDB = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS donations (
        id SERIAL PRIMARY KEY,
        reference_number VARCHAR(50) UNIQUE,
        amount INTEGER NOT NULL,
        description TEXT,
        category TEXT,
        status VARCHAR(20),
        checkout_url TEXT,
        created_at TIMESTAMP DEFAULT NOW()
      );
    `);
    console.log("✅ Table 'donations' ready");
  } catch (err) {
    console.error("❌ DB init error:", err.message);
  }
};

// Health check route
app.get("/health", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json({ status: "OK", db: "Connected", time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: "Error", error: err.message });
  }
});

// Donation route
app.post("/donate", async (req, res) => {
  console.log("📥 /donate request:", req.body);

  const { amount, description, category } = req.body;

  if (!amount || !category || typeof amount !== "number" || amount < 100) {
    return res.status(400).json({ error: "Invalid donation: amount and category are required, amount >= 100." });
  }

  try {
    // Call PayMongo
    const paymongoRes = await axios.post(
      "https://api.paymongo.com/v1/links",
      {
        data: {
          attributes: {
            amount: amount * 100,
            currency: "PHP",
            description: description || "Donation",
            remarks: category
          }
        }
      },
      {
        headers: {
          Authorization: `Basic ${Buffer.from(process.env.PAYMONGO_SECRET_KEY).toString("base64")}`,
          "Content-Type": "application/json"
        }
      }
    );

    const link = paymongoRes.data.data.attributes;

    try {
      await pool.query(
        `INSERT INTO donations (reference_number, amount, description, category, status, checkout_url)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (reference_number) DO NOTHING`,
        [
          link.reference_number,
          link.amount,
          description || "Donation",
          category,
          link.status,
          link.checkout_url
        ]
      );
      console.log("✅ Saved to DB:", link.reference_number);
    } catch (dbErr) {
      console.error("❌ DB error:", dbErr.message);
      return res.status(500).json({ error: `Database insert failed: ${dbErr.message}` });
    }

    res.json({ checkout_url: link.checkout_url, reference: link.reference_number });

  } catch (err) {
    console.error("❌ PayMongo error:", err.response?.data || err.message);
    res.status(500).json({
      error: err.response?.data?.errors?.[0]?.detail || "PayMongo failed"
    });
  }
});

// 404 for unmatched routes
app.use((req, res) => {
  res.status(404).send(`🛑 No route found for ${req.method} ${req.originalUrl}`);
});

// ✅ Export for Firebase Functions
initDB(); // Only call this once on cold start
exports.donationApi = functions.https.onRequest(app);
