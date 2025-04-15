const express = require("express");
const mysql = require("mysql2");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const cors = require("cors");
const passport = require("passport");
const GoogleStrategy = require("passport-google-oauth20").Strategy;
const AppleStrategy = require("passport-apple").Strategy;
const dotenv = require("dotenv");

dotenv.config();
const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(passport.initialize());

// MySQL Database Connection
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "root",
  database: process.env.DB_DATABASE || "wellness",
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    return;
  }
  console.log("✅ Connected to MySQL database");
});

// Register User
app.post("/register", async (req, res) => {
  try {
    const { fullName, username, email, password, provider } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    const sql =
      "INSERT INTO users (full_name, username, email, password, provider) VALUES (?, ?, ?, ?, ?)";
    db.query(
      sql,
      [fullName, username, email, hashedPassword, provider || "local"],
      (err, result) => {
        if (err) {
          console.error("❌ Error registering user:", err);
          return res.status(500).json({ error: "Database error" });
        }
        res.json({ message: "✅ User registered successfully" });
      }
    );
  } catch (error) {
    res.status(500).json({ error: "❌ Server error" });
  }
});

// Login User
app.post("/login", (req, res) => {
  const { identifier, password } = req.body;
  const sql = "SELECT * FROM users WHERE email = ? OR username = ?";

  db.query(sql, [identifier, identifier], async (err, results) => {
    if (err) {
      console.error("❌ Error fetching user:", err);
      return res.status(500).json({ error: "Database error" });
    }
    if (results.length === 0) {
      return res.status(401).json({ error: "❌ Invalid credentials" });
    }

    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ error: "❌ Invalid credentials" });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.json({
      token,
      user: { id: user.id, email: user.email, fullName: user.full_name },
    });
  });
});

// Google Authentication
/*passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "/auth/google/callback", // Modified callback URL to be relative
    },
    (accessToken, refreshToken, profile, done) => {
      const { id, displayName, emails } = profile;
      const email = emails[0].value;

      const sql = "SELECT * FROM users WHERE email = ?";
      db.query(sql, [email], (err, results) => {
        if (err) return done(err);

        if (results.length > 0) {
          return done(null, results[0]);
        } else {
          const insertSql =
            "INSERT INTO users (full_name, email, provider) VALUES (?, ?, 'google')";
          db.query(insertSql, [displayName, email], (err, result) => {
            if (err) return done(err);
            return done(null, {
              id: result.insertId,
              email,
              full_name: displayName,
            });
          });
        }
      });
    }
  )
);

app.get(
  "/auth/google",
  passport.authenticate("google", { scope: ["profile", "email"] })
);

app.get(
  "/auth/google/callback",
  passport.authenticate("google", { session: false }),
  (req, res) => {
    const token = jwt.sign(
      { id: req.user.id, email: req.user.email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.redirect(`http://localhost:3000/dashboard?token=${token}`);
  }
);

// Apple Authentication
passport.use(
  new AppleStrategy(
    {
      clientID: process.env.APPLE_CLIENT_ID,
      teamID: process.env.APPLE_TEAM_ID,
      keyID: process.env.APPLE_KEY_ID,
      key: process.env.APPLE_PRIVATE_KEY
        ? process.env.APPLE_PRIVATE_KEY.replace(/\\n/g, "\n")
        : undefined,
      callbackURL: "/auth/apple/callback", // Modified callback URL to be relative
      passReqToCallback: true, // Added to potentially access request details
    },
    (req, accessToken, refreshToken, idToken, profile, done) => {
      // Log profile information for debugging
      console.log("Apple Profile:", profile);

      const { email } = profile;

      if (!email) {
        return done(null, false, { message: "No email provided by Apple" });
      }

      const sql = "SELECT * FROM users WHERE email = ?";
      db.query(sql, [email], (err, results) => {
        if (err) return done(err);

        if (results.length > 0) {
          return done(null, results[0]);
        } else {
          const fullName = profile.name
            ? `${profile.name.firstName} ${profile.name.lastName}`.trim()
            : email.split("@")[0];
          const insertSql =
            "INSERT INTO users (full_name, email, provider) VALUES (?, ?, 'apple')";
          db.query(insertSql, [fullName, email], (err, result) => {
            if (err) return done(err);
            return done(null, {
              id: result.insertId,
              email,
              full_name: fullName,
            });
          });
        }
      });
    }
  )
);

app.get("/auth/apple", passport.authenticate("apple"));

app.get(
  "/auth/apple/callback",
  passport.authenticate("apple", { session: false, failureRedirect: "/login" }), // Added failureRedirect
  (req, res) => {
    if (!req.user) {
      return res.redirect("/login?error=apple_auth_failed");
    }
    const token = jwt.sign(
      { id: req.user.id, email: req.user.email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.redirect(`http://localhost:3000/dashboard?token=${token}`);
  }
);*/

// Start Server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
