const express = require("express");
const cors = require("cors");
const axios = require("axios");
const {Pool} = require("pg");

let pool;

const createApp = (env) => {
  const app = express();
  app.use(cors({origin: "*", methods: ["GET", "POST"]}));
  app.use(express.json());

  const initDB = async () => {
    if (!pool) {
      pool = new Pool({
        connectionString: env.NEON_DB_URL,
        ssl: {rejectUnauthorized: false},
      });

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
    }
  };

  app.get("/health", async (req, res) => {
    try {
      const result = await pool.query("SELECT NOW()");
      res.json({status: "OK", database: "Connected",
        time: result.rows[0].now});
    } catch (err) {
      res.status(500).json({status: "Error", error: err.message});
    }
  });

  app.post("/donate", async (req, res) => {
    const {amount, description, category} = req.body;

    if (!amount || !category || typeof amount !== "number" || amount < 100) {
      return res.status(400).json({error:
         "Invalid donation: amount and category are required, amount >= 100."});
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
              },
            },
          },
          {
            headers: {
              "Authorization": `Basic ${
                Buffer.from(env.PAYMONGO_SECRET_KEY).toString("base64")}`,
              "Content-Type": "application/json",
            },
          },
      );

      const link = paymongoRes.data.data.attributes;

      await pool.query(
          `INSERT INTO donations (reference_number, amount, 
          description, category, status, checkout_url)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (reference_number) DO NOTHING`,
          [
            link.reference_number,
            link.amount,
            description || "Donation",
            category,
            link.status,
            link.checkout_url,
          ],
      );

      res.json({checkout_url: link.checkout_url,
        reference: link.reference_number});
    } catch (err) {
      console.error("❌ PayMongo error:",
          (err.response && err.response.data) || err.message);
      res.status(500).json({
        error:
            (err.response &&
            err.response.data &&
            err.response.data.errors &&
            err.response.data.errors[0] &&
            err.response.data.errors[0].detail) || "PayMongo failed",
      });
    }
  });

  app.use((req, res) => {
    res.status(404).send(`🛑 No route found for ${req.method},
      ${req.originalUrl}`);
  });

  return {app, initDB};
};

module.exports = {createApp};
