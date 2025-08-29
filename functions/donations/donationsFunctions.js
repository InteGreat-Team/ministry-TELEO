// functions/donations/donationsFunctions.js
const {onRequest} = require("firebase-functions/v2/https");
const express = require("express");
const cors = require("cors");
const axios = require("axios");
const {Pool} = require("pg");

// ---- Singleton PG pool across warm invocations ----
let pool;

// Build the Express app once per instance
const app = express();
app.use(cors({origin: "*", methods: ["GET", "POST"]}));
app.use(express.json());

// --- Utility: generate structured payment_id like DON-YYYYMMDD-12345 ---
const generatePaymentId = () => {
  const date = new Date();
  const yyyy = date.getFullYear();
  const mm = String(date.getMonth() + 1).padStart(2, "0");
  const dd = String(date.getDate()).padStart(2, "0");
  const randomNum = Math.floor(10000 + Math.random() * 90000);
  return `DON-${yyyy}${mm}${dd}-${randomNum}`;
};

// --- DB init (runs once per cold start) ---
const initDB = async () => {
  if (!pool) {
    const connectionString =
      process.env.NEON_DB_URL || process.env.DATABASE_URL;

    if (!connectionString) {
      throw new Error(
          "NEON_DB_URL or DATABASE_URL is required for PostgreSQL.",
      );
    }

    pool = new Pool({
      connectionString,
      ssl: {rejectUnauthorized: false},
    });

    await pool.query(`
      CREATE TABLE IF NOT EXISTS test_donation (
        id SERIAL PRIMARY KEY,
        payment_id TEXT UNIQUE,
        amount INT NOT NULL,
        category TEXT,
        description TEXT,
        status VARCHAR(50),
        checkout_url TEXT,
        client_key TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // eslint-disable-next-line no-console
    console.log("✅ Table 'test_donation' ready");
  }
};

// --- Health check ---
app.get("/health", async (_req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json({
      status: "OK",
      database: "Connected",
      time: result.rows[0].now,
    });
  } catch (err) {
    res.status(500).json({status: "Error", error: err.message});
  }
});

// --- Donation endpoint (Checkout Sessions; response keys unchanged) ---
app.post("/donate", async (req, res) => {
  const {amount, description, category} = req.body;

  if (!amount || typeof amount !== "number" || amount < 100 || !category) {
    return res.status(400).json({
      error:
        "Invalid donation: need { amount >= 100, category }. " +
        "Amount must be a number.",
    });
  }

  const paymentId = generatePaymentId();
  const desc = description || `Donation worth ₱${amount} for ${category}`;
  const phpAmountCentavos = Math.round(amount * 100);

  try {
    const secret = process.env.PAYMONGO_SECRET_KEY;
    if (!secret) {
      return res.status(500).json({
        error: "PAYMONGO_SECRET_KEY env var is missing.",
      });
    }

    const basic = Buffer.from(`${secret}:`).toString("base64");

    const pmRes = await axios.post(
        "https://api.paymongo.com/v1/checkout_sessions",
        {
          data: {
            attributes: {
              billing: {
                name: null,
                phone: null,
                email: null,
              },
              send_email_receipt: true,
              show_description: true,
              show_line_items: true,
              line_items: [
                {
                  name: "Donation",
                  description: "Donations",
                  amount: phpAmountCentavos,
                  currency: "PHP",
                  quantity: 1,
                },
              ],
              payment_method_types: [
                "gcash",
                "paymaya",
                "brankas_bdo",
                "brankas_landbank",
                "brankas_metrobank",
              ],
              description: desc,
              remarks: "donation",
              metadata: {
                payment_id: paymentId,
              },
            },
          },
        },
        {
          headers: {
            "Authorization": `Basic ${basic}`,
            "Content-Type": "application/json",
          },
          timeout: 15000,
        },
    );

    const attrs = pmRes.data.data.attributes;
    const checkoutUrl = attrs.checkout_url;
    const clientKey = attrs.client_key;
    const status = attrs.status;

    await pool.query(
        `
      INSERT INTO test_donation
        (payment_id, amount, category, description, status,
         checkout_url, client_key)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT (payment_id) DO NOTHING
      `,
        [
          paymentId,
          amount,
          category,
          desc,
          status,
          checkoutUrl,
          clientKey,
        ],
    );

    res.json({
      checkout_url: checkoutUrl,
      reference: paymentId,
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error(
        "❌ PayMongo error:",
        (err.response && err.response.data) || err.message,
    );

    const detail =
      err.response &&
      err.response.data &&
      err.response.data.errors &&
      err.response.data.errors[0] &&
      err.response.data.errors[0].detail;

    res.status(500).json({
      error: detail || "PayMongo failed",
    });
  }
});

// Fallback
app.use((req, res) => {
  res
      .status(404)
      .send(`🛑 No route for ${req.method} ${req.originalUrl}`);
});

// Initialize DB once and export the HTTPS function
const ready = initDB();

exports.donations = onRequest(
    {region: "asia-southeast1", cors: true},
    async (req, res) => {
      await ready;
      return app(req, res);
    },
);
