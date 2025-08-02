const axios = require("axios");

const codes = new Map();

const sendVerificationCode = async (req, res, brevoSecret) => {
  const {email, name} = req.body;

  if (!email || !name) {
    return res.status(400).send("Missing email or name");
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = Date.now() + 5 * 60 * 1000;

  try {
    // Add debugging
    console.log("Attempting to retrieve Brevo API key...");

    if (!brevoSecret) {
      console.error("brevoSecret binding is undefined!");
      return res.status(500).send("API key configuration error");
    }

    const brevoApiKey = await brevoSecret.value();

    // More detailed debugging
    console.log("Secret retrieved successfully");
    console.log("API Key exists:", !!brevoApiKey);
    console.log("API Key length:", brevoApiKey ? brevoApiKey.length : 0);
    console.log("API Key starts with:",
        brevoApiKey ? brevoApiKey.substring(0, 10) + "..." : "undefined");

    if (!brevoApiKey) {
      console.error("Brevo API key is empty or undefined");
      return res.status(500).send("API key not found");
    }

    console.log("Making request to Brevo API...");

    const response = await axios.post(
        "https://api.brevo.com/v3/smtp/email",
        {
          sender: {name: "Teleo", email: "teleo@teleo.alphaexplora.com"},
          to: [{email, name}],
          subject: "Your Teleo Verification Code",
          htmlContent: `
          <h3>Hello ${name},</h3>
          <p>Your verification code is:</p>
          <h2 style="color:#002642;">${code}</h2>
          <p>This code is valid for 5 minutes.</p>
        `,
        },
        {
          headers: {
            "Content-Type": "application/json",
            "api-key": brevoApiKey,
          },
        },
    );

    console.log("Brevo API response status:", response.status);

    if (response.status === 201) {
      codes.set(email, {code, expiresAt});
      console.log("Email sent successfully, code stored");
      res.status(200).send({code});
    } else {
      console.log("Unexpected response status:", response.status);
      res.status(500).send("Failed to send email");
    }
  } catch (error) {
    console.error("Email error:", {
      message: error.message,
      responseData: error.response && error.response.data,
      status: error.response && error.response.status,
      headers: error.response && error.response.headers,
      stack: error.stack,
    });

    // More specific error handling
    if (error.response && error.response.status === 401) {
      console.error("Authentication failed - check your Brevo API key");
      res.status(500).send("Email service authentication failed");
    } else {
      res.status(500).send("Error sending email");
    }
  }
};

const verifyCode = (req, res) => {
  const {email, code} = req.body;

  if (!email || !code) {
    return res.status(400).send("Missing email or code");
  }

  const entry = codes.get(email);
  if (!entry) return res.status(400).send("No code found for this email");

  if (Date.now() > entry.expiresAt) {
    codes.delete(email);
    return res.status(400).send("Code expired");
  }

  if (entry.code !== code) return res.status(400).send("Incorrect code");

  codes.delete(email);
  res.sendStatus(200);
};

module.exports = {
  sendVerificationCode,
  verifyCode,
};
