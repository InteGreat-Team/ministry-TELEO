/* eslint new-cap: ["error", { "capIsNew": false }] */
const {onRequest} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const {defineSecret} = require("firebase-functions/params");
const express = require("express");
const cors = require("cors");

// 🔐 Define Secrets
const brevoApiKey = defineSecret("BREVO_API_KEY");
const paymongoSecretKey = defineSecret("paymongo-secret-key");
const neonDbUrl = defineSecret("NEON_DB_URL");
const awsAccessKeyId = defineSecret("AWS_ACCESS_KEY_ID");
const awsSecretAccessKey = defineSecret("AWS_SECRET_ACCESS_KEY");
const s3BucketName = defineSecret("S3_BUCKET_NAME");
const awsRegion = defineSecret("AWS_REGION");

// 🔧 Global Options
setGlobalOptions({
  region: "asia-southeast1",
  memory: "256MiB",
  secrets: [
    brevoApiKey,
    paymongoSecretKey,
    neonDbUrl,
    awsAccessKeyId,
    awsSecretAccessKey,
    s3BucketName,
    awsRegion,
  ],
});

// ✅ EMAIL FUNCTION (Brevo)
const {sendVerificationCode, verifyCode} =
  require("./email/emailFunctions");
const emailApp = express();
emailApp.use(cors({origin: true}));
emailApp.use(express.json());

emailApp.post(
    "/sendVerificationCode",
    (req, res) => sendVerificationCode(req, res, brevoApiKey),
);
emailApp.post("/verifyCode", verifyCode);

exports.sendCodeEmail = onRequest(emailApp);

// ✅ DONATION FUNCTION (PayMongo + NeonDB)
const {createApp: createDonationApp} =
  require("./donations/donationsFunctions");

exports.donationApi = onRequest(
    {secrets: [paymongoSecretKey, neonDbUrl]},
    async (req, res) => {
      const env = {
        PAYMONGO_SECRET_KEY: paymongoSecretKey.value(),
        NEON_DB_URL: neonDbUrl.value(),
      };

      const {app, initDB} = createDonationApp(env);
      await initDB();

      return app(req, res);
    },
);

// ✅ USER SIGNUP FUNCTION (NeonDB + Firebase Auth)
const {createSignupApp} = require("./signup/signup");

exports.signupApi = onRequest(
    {secrets: [neonDbUrl]},
    async (req, res) => {
      const env = {NEON_DB_URL: neonDbUrl.value()};
      const {app, initDB} = createSignupApp(env);
      await initDB();
      return app(req, res);
    },
);

// ✅ PROFILE PICTURE UPLOAD FUNCTION (AWS S3)
const {createUploadApp} = require("./uploadprofile/uploadProfile");

exports.uploadProfileApi = onRequest(
    {secrets: [awsAccessKeyId, awsSecretAccessKey, s3BucketName, awsRegion]},
    async (req, res) => {
      const env = {
        AWS_ACCESS_KEY_ID: awsAccessKeyId.value(),
        AWS_SECRET_ACCESS_KEY: awsSecretAccessKey.value(),
        S3_BUCKET_NAME: s3BucketName.value(),
        AWS_REGION: awsRegion.value(),
      };

      const app = createUploadApp(env);
      return app(req, res);
    },
);
