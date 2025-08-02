/* eslint camelcase: "off" */
/* eslint new-cap: ["error", { "capIsNew": false }] */
const express = require("express");
const cors = require("cors");
const {Pool} = require("pg");
const {check, validationResult} = require("express-validator");
const bcrypt = require("bcryptjs");
const admin = require("firebase-admin");
const {getApps} = require("firebase-admin/app");
if (getApps().length === 0) {
  admin.initializeApp();
}

require("dotenv").config();

let pool;

const createSignupApp = () => {
  const app = express();
  app.use(cors({origin: true}));
  app.use(express.json());

  const initDB = async () => {
    if (!pool) {
      pool = new Pool({
        connectionString: process.env.NEON_DB_URL,
        ssl: {rejectUnauthorized: false},
      });
      console.log("✅ DB Connected for Signup");
    }
  };

  app.post(
      "/",
      [
        check("first_name")
            .notEmpty()
            .withMessage("First name is required"),
        check("last_name")
            .notEmpty()
            .withMessage("Last name is required"),
        check("birthday")
            .isISO8601()
            .toDate()
            .withMessage("Valid birthday is required"),
        check("gender")
            .isIn(["Male", "Female", "Other"])
            .withMessage("Invalid gender"),
        check("username")
            .matches(/^[a-zA-Z0-9]{4,20}$/)
            .withMessage("Username must be 4-20 alphanumeric characters"),
        check("email_address")
            .isEmail()
            .withMessage("Valid email is required"),
        check("phone_number")
            .matches(/^\+63[0-9]{10}$/)
            .withMessage("Phone number must be in +63 format"),
        check("location_address")
            .notEmpty()
            .withMessage("Location address is required"),
        check("location_lat")
            .isFloat({min: -90, max: 90})
            .withMessage("Invalid latitude"),
        check("location_lng")
            .isFloat({min: -180, max: 180})
            .withMessage("Invalid longitude"),
        check("password")
            .isLength({min: 8})
            .withMessage("Password must be at least 8 characters"),
        check("profile_picture_url")
            .optional()
            .isURL()
            .withMessage("Profile picture must be a valid URL"),
        check("has_accepted_terms")
            .isBoolean()
            .custom((val) => val === true)
            .withMessage("Terms must be accepted"),
        check("is_email_verified")
            .isBoolean()
            .custom((val) => val === true)
            .withMessage("Email must be verified"),
      ],
      async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
          return res.status(400).json({errors: errors.array()});
        }

        const {
          first_name,
          last_name,
          birthday,
          gender,
          username,
          email_address,
          phone_number,
          location_address,
          location_lat,
          location_lng,
          password,
          profile_picture_url,
          has_accepted_terms,
          is_email_verified,
        } = req.body;

        try {
          const existingUser = await pool.query(
              "SELECT * FROM teleo_users " +
              "WHERE email_address = $1 OR username = $2",
              [email_address, username],
          );

          if (existingUser.rows.length > 0) {
            return res.status(400).json({
              errors: [{msg: "User already exists"}],
            });
          }

          try {
            const existingFirebaseUser = await
            admin.auth().getUserByEmail(email_address);
            console.log("⚠️ Firebase user already exists:",
                existingFirebaseUser.uid);
            return res.status(400).json({error:
              "Email already exists in Firebase Auth."});
          } catch (e) {
            if (e.code !== "auth/user-not-found") {
              console.error("Unexpected Firebase lookup error:", e);
              return res.status(500).json({error:
                "Error checking Firebase Auth."});
            }
            // If user-not-found, proceed to create user.
          }

          const salt = await bcrypt.genSalt(10);
          const hashedPassword = await bcrypt.hash(password, salt);

          const insertResult = await pool.query(
              `INSERT INTO teleo_users (
                role,
                first_name, last_name, birthday, gender, username,
                email_address, phone_number, location_address,
                location_lat, location_lng, password, profile_picture_url,
                has_accepted_terms, is_email_verified
              ) VALUES (
                'user',
                $1, $2, $3, $4, $5,
                $6, $7, $8,
                $9, $10, $11, $12,
                $13, $14
              ) RETURNING 
                id, 
                first_name, 
                last_name, 
                email_address, 
                username, 
                role`,
              [
                first_name,
                last_name,
                birthday,
                gender,
                username,
                email_address,
                phone_number,
                location_address,
                location_lat,
                location_lng,
                hashedPassword,
                profile_picture_url,
                has_accepted_terms,
                is_email_verified,
              ],
          );

          const user = insertResult.rows[0];

          let firebaseUser;
          try {
            firebaseUser = await admin.auth().createUser({
              email: email_address,
              password: password,
              displayName: `${first_name} ${last_name}`,
            });
            console.log("✅ Firebase User Created:", firebaseUser.uid);
          } catch (error) {
            console.error("❌ Firebase Auth Create User Error:", error);
            return res.status(500).json({
              error: "Failed to create Firebase Auth user",
              details: error.message,
            });
          }


          await pool.query(
              "UPDATE teleo_users SET firebase_uid = $1 WHERE id = $2",
              [firebaseUser.uid, user.id],
          );

          res.status(201).json({
            message: "User registered successfully",
            user,
            firebase_uid: firebaseUser.uid,
          });
        } catch (err) {
          console.error("Register error:", err);
          res.status(500).json({error: "Server error"});
        }
      },
  );

  return {app, initDB};
};

module.exports = {createSignupApp};
