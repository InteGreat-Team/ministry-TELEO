console.log("🚨🚨 Running FULL donation.js with PayMongo + DB (Firebase + Auth + Webhook)");

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const axios = require("axios");
const { Pool } = require("pg");
const admin = require("firebase-admin");

dotenv.config();

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp();
}

const app = express();

// Logging env status
console.log("ENV: PAYMONGO_SECRET_KEY", process.env.PAYMONGO_SECRET_KEY ? "Loaded" : "Missing");
console.log("ENV: NEON_DB_URL", process.env.NEON_DB_URL ? "Loaded" : "Missing");

app.use(cors({ origin: true }));
app.use(express.json());

// PostgreSQL setup (Neon DB)
const pool = new Pool({
  connectionString: process.env.NEON_DB_URL,
  ssl: { rejectUnauthorized: false },
});

// Initialize DB
const initDB = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS donations (
        id SERIAL PRIMARY KEY,
        user_id TEXT,
        user_name TEXT,
        user_email TEXT,
        reference_number VARCHAR(50) UNIQUE,
        amount INTEGER NOT NULL,
        description TEXT,
        category TEXT,
        status VARCHAR(20),
        checkout_url TEXT,
        created_at TIMESTAMP DEFAULT NOW()
      );
    `);

    const alterQueries = [
      `ALTER TABLE donations ADD COLUMN IF NOT EXISTS user_id TEXT;`,
      `ALTER TABLE donations ADD COLUMN IF NOT EXISTS user_name TEXT;`,
      `ALTER TABLE donations ADD COLUMN IF NOT EXISTS user_email TEXT;`
    ];
    for (const q of alterQueries) await pool.query(q);

    console.log("✅ Table 'donations' ready and up-to-date");
  } catch (err) {
    console.error("❌ DB init error:", err.message);
  }
};

// 🔒 Firebase Auth Middleware
const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Unauthorized: Missing or invalid token" });
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.user = decoded;
    console.log("👤 Decoded Firebase user:", decoded);
    next();
  } catch (err) {
    console.error("❌ Token verification failed:", err.message);
    return res.status(401).json({ error: "Unauthorized: Invalid token" });
  }
};

// ✅ Health check route
app.get("/health", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json({ status: "OK", db: "Connected", time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: "Error", error: err.message });
  }
});

// ✅ Donation route
app.post("/donate", authenticate, async (req, res) => {
  const { amount, description, category } = req.body;
  const { uid, email } = req.user;

  let name = req.user.name || null;
  if (!name || !email) {
    try {
      const userRecord = await admin.auth().getUser(uid);
      name = userRecord.displayName || null;
    } catch (err) {
      console.warn("⚠️ Could not fetch full user info:", err.message);
    }
  }

  if (!amount || !category || typeof amount !== "number" || amount < 100) {
    return res.status(400).json({ error: "Invalid donation: amount and category are required, amount >= 100." });
  }

  try {
    const paymongoRes = await axios.post(
      "https://api.paymongo.com/v1/links",
      {
        data: {
          attributes: {
            amount: amount * 100,
            currency: "PHP",
            description: description || "Donation",
            remarks: category,
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

    await pool.query(
      `INSERT INTO donations (user_id, user_name, user_email, reference_number, amount, description, category, status, checkout_url)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       ON CONFLICT (reference_number) DO NOTHING`,
      [
        uid,
        name,
        email || null,
        link.reference_number,
        link.amount,
        description || "Donation",
        category,
        link.status,
        link.checkout_url
      ]
    );

    console.log("✅ Saved to DB:", link.reference_number);
    res.json({ checkout_url: link.checkout_url, reference: link.reference_number });

  } catch (err) {
    console.error("❌ Donation error:", err.response?.data || err.message);
    res.status(500).json({
      error: err.response?.data?.errors?.[0]?.detail || "PayMongo failed"
    });
  }
});

// ✅ Webhook route
app.post("/webhook", async (req, res) => {
  const event = req.body.data;
  console.log("📩 Webhook received:", event?.type);

  if (!event || !event.type || !event.attributes) {
    return res.status(400).json({ error: "Invalid webhook data" });
  }

  const reference = event.attributes.billing?.reference_number;
  if (!reference) {
    return res.status(400).json({ error: "Missing reference number" });
  }

  try {
    if (event.type === "payment.paid") {
      const update = await pool.query(
        `UPDATE donations SET status = 'paid' WHERE reference_number = $1`,
        [reference]
      );
      console.log(`✅ Updated donation to 'paid' (${reference})`);
    }

    if (event.type === "payment.failed") {
      const update = await pool.query(
        `UPDATE donations SET status = 'failed' WHERE reference_number = $1`,
        [reference]
      );
      console.log(`❌ Updated donation to 'failed' (${reference})`);
    }

    res.status(200).json({ received: true });

  } catch (err) {
    console.error("❌ Webhook error:", err.message);
    res.status(500).json({ error: "Failed to process webhook" });
  }
});

// 404 fallback
app.use((req, res) => {
  res.status(404).send(`🛑 No route found for ${req.method} ${req.originalUrl}`);
});

// Export for Firebase
initDB();
exports.donationApi = functions.https.onRequest(app);
