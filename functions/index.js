const {onRequest} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const express = require("express");
const {Pool} = require("pg");

const prayersRouter = require("./prayerwall/routes/prayers");
const tagsRouter = require("./prayerwall/routes/tags");
const commentsRouter = require("./prayerwall/routes/comments");

const DATABASE_URL = defineSecret("DATABASE_URL");

exports.prayerwall = onRequest(
    {
      secrets: [DATABASE_URL],
      region: "asia-southeast1",
    },
    (req, res) => {
      const app = express();
      app.use(express.json());

      const dbUrl = DATABASE_URL.value();

      const pool = new Pool({
        connectionString: dbUrl,
        ssl: {rejectUnauthorized: false},
      });

      // Inject db pool into req.env
      app.use((req, _, next) => {
        req.env = {db: pool};
        next();
      });

      app.use("/api/prayers", prayersRouter);
      app.use("/api/tags", tagsRouter);
      app.use("/api/comments", commentsRouter);

      return app(req, res);
    },
);
