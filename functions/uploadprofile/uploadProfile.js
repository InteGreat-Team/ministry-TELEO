/* eslint new-cap: ["error", { "capIsNew": false }] */
const express = require("express");
const multer = require("multer");
const AWS = require("aws-sdk");
const {v4: uuidv4} = require("uuid");
const cors = require("cors");

// Multer config to handle file upload parsing
const storage = multer.memoryStorage();
const upload = multer({storage: storage});

/**
 * Creates an Express app for handling profile picture uploads to S3
 * @param {Object} env - Environment variables object
 * @return {Object} Express app instance
 */
function createUploadApp(env) {
  const app = express();
  app.use(cors({origin: true}));

  // AWS S3 Config with passed environment variables
  AWS.config.update({
    accessKeyId: env.AWS_ACCESS_KEY_ID,
    secretAccessKey: env.AWS_SECRET_ACCESS_KEY,
    region: env.AWS_REGION || "us-east-1", // default region
  });

  console.log("AWS_ACCESS_KEY_ID:", process.env.AWS_ACCESS_KEY_ID);
  console.log("AWS_SECRET_ACCESS_KEY:",
    process.env.AWS_SECRET_ACCESS_KEY ? "Loaded" : "Missing");
  console.log("AWS_REGION:", process.env.AWS_REGION);
  console.log("S3_BUCKET_NAME:", process.env.S3_BUCKET_NAME);

  const s3 = new AWS.S3();

  app.post(
      "/uploadProfilePicture",
      upload.single("profilePicture"),
      async (req, res) => {
        if (!req.file) {
          return res.status(400).json({error: "No file uploaded"});
        }

        console.log("✅ File received:", {
          originalname: req.file.originalname,
          mimetype: req.file.mimetype,
          size: req.file.size,
        });

        const fileKey = `profile-pictures/${uuidv4()}-${req.file.originalname}`;
        console.log("Generated S3 File Key:", fileKey);

        const params = {
          Bucket: env.S3_BUCKET_NAME,
          Key: fileKey,
          Body: req.file.buffer,
          ContentType: req.file.mimetype,
          ACL: "public-read",
        };

        console.log("S3 Upload Params:", params);

        try {
          const result = await s3.upload(params).promise();
          console.log("✅ S3 Upload Success:", result);

          // Use the Location from S3 response or construct URL
          const fileUrl = result.Location ||
            `https://${env.S3_BUCKET_NAME}.s3.${env.AWS_REGION || "us-east-1"}.amazonaws.com/${fileKey}`;

          res.status(200).json({url: fileUrl});
        } catch (err) {
          console.error("S3 Upload Error:", err);
          res.status(500).json({
            error: "Failed to upload image",
            details: err.message,
          });
        }
      },
  );

  return app;
}

module.exports = {createUploadApp};
