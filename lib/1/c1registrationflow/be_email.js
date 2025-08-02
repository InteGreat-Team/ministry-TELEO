// index.js
const axios = require('axios');

// Simple in-memory store for verification codes
const codes = new Map(); // key: email, value: { code, expiresAt }

exports.sendVerificationCode = async (req, res) => {
  const { email, name } = req.body;

  if (!email || !name) {
    return res.status(400).send('Missing email or name');
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = Date.now() + 5 * 60 * 1000; // 5 minutes

  try {
    const response = await axios.post('https://api.brevo.com/v3/smtp/email', {
      sender: { name: 'Teleo', email: 'teleomobileapp@gmail.com' },
      to: [{ email, name }],
      subject: 'Your Teleo Verification Code',
      htmlContent: `
        <h3>Hello ${name},</h3>
        <p>Your verification code is:</p>
        <h2 style="color:#002642;">${code}</h2>
        <p>This code is valid for 5 minutes.</p>
      `,
    }, {
      headers: {
        'Content-Type': 'application/json',
        'api-key': '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',
      }
    });

    if (response.status === 201) {
      codes.set(email, { code, expiresAt });
      res.status(200).send({ code }); // Optional: for dev testing only
    } else {
      res.status(500).send('Failed to send email');
    }

  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).send('Error sending email');
  }
};

exports.verifyCode = async (req, res) => {
  const { email, code } = req.body;

  if (!email || !code) {
    return res.status(400).send('Missing email or code');
  }

  const entry = codes.get(email);
  if (!entry) {
    return res.status(404).send({ valid: false, reason: 'No code found' });
  }

  if (Date.now() > entry.expiresAt) {
    codes.delete(email);
    return res.status(410).send({ valid: false, reason: 'Code expired' });
  }

  if (entry.code !== code) {
    return res.status(401).send({ valid: false, reason: 'Incorrect code' });
  }

  codes.delete(email); // Optionally invalidate after use
  res.status(200).send({ valid: true });
};
