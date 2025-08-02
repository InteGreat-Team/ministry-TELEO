const postgres = require("postgres");
const {defineSecret} = require("firebase-functions/params");

// Define the secret (but DO NOT call .value() here)
const neonDbUrl = defineSecret("NEON_DB_URL");

// Export postgres module and the secret reference
module.exports = {postgres, neonDbUrl};
