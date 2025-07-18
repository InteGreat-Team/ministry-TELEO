// File: index.js
const axios = require('axios');

exports.sendVerificationCode = async (req, res) => {
  const { email, name } = req.body;

  if (!email || !name) {
    return res.status(400).send('Missing email or name');
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();

  try {
    const response = await axios.post('https://api.brevo.com/v3/smtp/email', {
      sender: { name: 'Teleo', email: 'your@email.com' },
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
        'api-key': process.env.BREVO_API_KEY,
      }
    });

    if (response.status === 201) {
      res.status(200).send({ code });
    } else {
      res.status(500).send('Failed to send email');
    }

  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).send('Error sending email');
  }
};
