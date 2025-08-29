/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const {defineSecret} = require("firebase-functions/params");
const express = require("express");
const cors = require("cors");

// 🔐 Define Secrets
const brevoApiKey = defineSecret("BREVO_API_KEY");
const paymongoSecretKey = defineSecret("paymongo-secret-key");
const neonDbUrl = defineSecret("neon-db-url");

// 🔧 Global Options
setGlobalOptions({
  region: "asia-southeast1",
  memory: "256MiB",
  secrets: [brevoApiKey, paymongoSecretKey, neonDbUrl],
});

// ✅ EMAIL FUNCTION
const {sendVerificationCode, verifyCode} = require("./email/emailFunctions");
const emailApp = express();

emailApp.use(cors({origin: true}));
emailApp.use(express.json());

emailApp.post("/sendVerificationCode", (req, res) =>
  sendVerificationCode(req, res, brevoApiKey),
);
emailApp.post("/verifyCode", verifyCode);

exports.sendCodeEmail = onRequest(emailApp);

// ✅ DONATION FUNCTION
const {createApp} = require("./donations/donationsFunctions");

exports.donationApi = onRequest(
    {
      secrets: [paymongoSecretKey, neonDbUrl],
    },
    async (req, res) => {
      const env = {
        PAYMONGO_SECRET_KEY: paymongoSecretKey.value(),
        NEON_DB_URL: neonDbUrl.value(),
      };

      const {app, initDB} = createApp(env);
      await initDB();
      return app(req, res);
    },
);

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
