const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const { faker } = require("@faker-js/faker");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(bodyParser.json());

const corsOptions = {
  origin: "http://127.0.0.1:5501",
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
  credentials: true,
  optionsSuccessStatus: 204,
};

app.use(cors(corsOptions));

const dbConfig = {
  host: "localhost",
  user: "root",
  password: "root",
  database: "wellness",
};

const pool = mysql.createPool(dbConfig);

const handleDBError = (res, err) => {
  console.error("Database Error:", err);
  res.status(500).json({ error: "Database error occurred" });
};

// --- Dynamic Image Endpoints ---
app.get("/api/dynamic-image/:type", (req, res) => {
  const { type } = req.params;
  const bgColor = faker.internet.color().substring(1);
  const textColor = faker.internet.color().substring(1);
  const imageUrl = `https://via.placeholder.com/150x100/${bgColor}/${textColor}?Text=${type.toUpperCase()}+${faker.number.int(
    100
  )}`;
  res.json({ imageUrl });
});

app.get("/api/dynamic-image/logo", (req, res) => {
  const bgColor = faker.internet.color().substring(1);
  const imageUrl = `https://via.placeholder.com/60/${bgColor}/ffffff?Text=Logo`;
  res.json({ imageUrl });
});

app.get("/api/dynamic-image/avatar", (req, res) => {
  const bgColor = faker.internet.color().substring(1);
  const imageUrl = `https://via.placeholder.com/50/${bgColor}/ffffff?Text=User`;
  res.json({ imageUrl });
});

app.get("/image/:filename", async (req, res) => {
  const { filename } = req.params;
  const imagePath = path.join(__dirname, "temp", `${filename}.png`);
  if (fs.existsSync(imagePath)) {
    res.sendFile(imagePath);
  } else {
    res.status(404).send("Image not found");
  }
});

// --- User Data Endpoint ---
app.get("/api/users/:userId", (req, res) => {
  const userId = req.params.userId;
  const query = "SELECT username, email FROM users WHERE id = ?";
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    if (results.length > 0) {
      res.json(results[0]);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  });
});

// --- Random Productive Hours ---
app.get("/api/users/:userId/random-productive-hours", (req, res) => {
  const startHour = faker.number.int({ min: 0, max: 23 });
  const endHour = faker.number.int({ min: startHour + 1, max: 24 });
  const startTime = `${startHour.toString().padStart(2, "0")}:00`;
  const endTime = `${endHour.toString().padStart(2, "0")}:00`;
  res.json({ start: startTime, end: endTime });
});

// --- Random Prompt ---
const prompts = [
  "What are you grateful for today?",
  "Describe a moment that made you smile recently.",
  "What is one small step you can take towards a goal?",
  "How are you feeling right now, and why?",
  "What is something you appreciate about yourself?",
];
app.get("/api/random-prompt", (req, res) => {
  const randomPrompt =
    prompts[faker.number.int({ min: 0, max: prompts.length - 1 })];
  res.json({ prompt: randomPrompt });
});

// --- Random Mood Swing Factors ---
app.get("/api/users/:userId/random-mood-swing-factors", (req, res) => {
  const factors = [
    "Sleep quality",
    "Diet",
    "Social interaction",
    "Exercise",
    "Work stress",
    "Weather",
  ];
  const factor1 =
    factors[faker.number.int({ min: 0, max: factors.length - 1 })];
  let factor2 = factors[faker.number.int({ min: 0, max: factors.length - 1 })];
  while (factor2 === factor1) {
    factor2 = factors[faker.number.int({ min: 0, max: factors.length - 1 })];
  }
  res.json({ factor1, factor2 });
});

// --- Latest Mental Score ---
app.get("/api/users/:userId/latest-mental-score", (req, res) => {
  const randomScore = faker.number.int({ min: 50, max: 95 });
  res.json({ overall_score: randomScore });
});

// --- Mood Graph Data (7-day average mood trend) ---
app.get("/api/users/:userId/mood-graph-data", (req, res) => {
  const userId = req.params.userId;
  const query = `
    SELECT DATE(log_time) AS date, ROUND(AVG(mood_level), 2) AS average_mood
    FROM mood_logs
    WHERE user_id = ?
    GROUP BY DATE(log_time)
    ORDER BY DATE(log_time) DESC
    LIMIT 7
  `;
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    res.json(results.reverse()); // Reverse for chronological order
  });
});

// --- Score Trend Graph (Stress, Anxiety, Wellbeing) ---
app.get("/api/users/:userId/score-trends", (req, res) => {
  const userId = req.params.userId;
  const query = `
    SELECT score_date, overall_score, stress_level, anxiety_level, wellbeing_level
    FROM mental_scores
    WHERE user_id = ?
    ORDER BY score_date DESC
    LIMIT 7
  `;
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    res.json(results.reverse());
  });
});

// --- Journal Entries by Date Range ---
app.get("/api/users/:userId/journals-range", (req, res) => {
  const { userId } = req.params;
  const { start, end } = req.query;
  const query = `
    SELECT id, date, content
    FROM Journals
    WHERE userId = ? AND date BETWEEN ? AND ?
    ORDER BY date DESC
  `;
  pool.query(query, [userId, start, end], (err, results) => {
    if (err) return handleDBError(res, err);
    res.json(results);
  });
});

// --- Register Endpoint ---
app.post("/api/register", async (req, res) => {
  const { username, password, email } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const query =
      "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
    pool.query(query, [username, hashedPassword, email], (err, results) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res
            .status(409)
            .json({ error: "Username or email already exists" });
        }
        return handleDBError(res, err);
      }
      res.status(201).json({
        message: "User registered successfully",
        userId: results.insertId,
      });
    });
  } catch (error) {
    console.error("Hashing error:", error);
    res.status(500).json({ error: "Failed to hash password" });
  }
});

// --- Login Endpoint ---
app.post("/api/login", async (req, res) => {
  const { username, password } = req.body;
  const query = "SELECT id, password FROM users WHERE username = ?";
  pool.query(query, [username], async (err, results) => {
    if (err) return handleDBError(res, err);
    if (results.length === 0) {
      return res.status(401).json({ error: "Invalid credentials" });
    }
    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (passwordMatch) {
      res.json({ message: "Login successful", userId: user.id });
    } else {
      res.status(401).json({ error: "Invalid credentials" });
    }
  });
});

// --- Get Journal Entries ---
app.get("/api/users/:userId/journal", (req, res) => {
  const userId = req.params.userId;
  const query =
    "SELECT id, date, content FROM Journals WHERE userId = ? ORDER BY date DESC";
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    res.json(results);
  });
});

// --- Create Journal Entry ---
app.post("/api/users/:userId/journal", (req, res) => {
  const userId = req.params.userId;
  const { entry_date, content } = req.body;
  const query = "INSERT INTO Journals (userId, date, content) VALUES (?, ?, ?)";
  pool.query(query, [userId, entry_date, content], (err, results) => {
    if (err) return handleDBError(res, err);
    res
      .status(201)
      .json({ message: "Journal entry created", entryId: results.insertId });
  });
});

// --- Generate Random Data ---
app.post("/api/generate-data", async (req, res) => {
  const {
    numUsers = 5,
    entriesPerUser = 10,
    moodLogsPerUser = 20,
    scoresPerUser = 5,
  } = req.body;

  try {
    const userIds = [];

    for (let i = 0; i < numUsers; i++) {
      const username = faker.internet.userName();
      const password = await bcrypt.hash("password123", 10);
      const email = faker.internet.email();
      const query =
        "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
      const [results] = await pool
        .promise()
        .query(query, [username, password, email]);
      userIds.push(results.insertId);
    }

    for (const userId of userIds) {
      for (let i = 0; i < entriesPerUser; i++) {
        const entry_date = faker.date
          .past()
          .toISOString()
          .slice(0, 19)
          .replace("T", " ");
        const content = faker.lorem.paragraph();
        await pool
          .promise()
          .query(
            "INSERT INTO Journals (userId, date, content) VALUES (?, ?, ?)",
            [userId, entry_date, content]
          );
      }
    }

    for (const userId of userIds) {
      for (let i = 0; i < moodLogsPerUser; i++) {
        const log_time = faker.date
          .recent()
          .toISOString()
          .slice(0, 19)
          .replace("T", " ");
        const mood_level = faker.number.int({ min: 1, max: 5 });
        const notes = faker.lorem.sentence();
        await pool
          .promise()
          .query(
            "INSERT INTO mood_logs (user_id, log_time, mood_level, notes) VALUES (?, ?, ?, ?)",
            [userId, log_time, mood_level, notes]
          );
      }
    }

    for (const userId of userIds) {
      for (let i = 0; i < scoresPerUser; i++) {
        const score_date = faker.date.past().toISOString().slice(0, 10);
        const overall_score = faker.number.int({ min: 50, max: 95 });
        const stress_level = faker.number.int({ min: 1, max: 10 });
        const anxiety_level = faker.number.int({ min: 1, max: 10 });
        const wellbeing_level = faker.number.int({ min: 1, max: 10 });
        await pool
          .promise()
          .query(
            "INSERT INTO mental_scores (user_id, score_date, overall_score, stress_level, anxiety_level, wellbeing_level) VALUES (?, ?, ?, ?, ?, ?)",
            [
              userId,
              score_date,
              overall_score,
              stress_level,
              anxiety_level,
              wellbeing_level,
            ]
          );
      }
    }

    res.status(201).json({ message: "Random data generated successfully" });
  } catch (error) {
    console.error("Error generating random data:", error);
    res.status(500).json({ error: "Failed to generate random data" });
  }
});
app.get("/api/users/:userId/mood-heatmap", (req, res) => {
  const { userId } = req.params;
  const query = `
    SELECT DATE(log_time) AS date, ROUND(AVG(mood_level), 1) AS mood_level
    FROM mood_logs
    WHERE user_id = ?
    GROUP BY DATE(log_time)
    ORDER BY DATE(log_time)
  `;
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    res.json(results);
  });
});

app.get("/api/users/:userId/insights", (req, res) => {
  const { userId } = req.params;
  const query = `
    SELECT DATE(log_time) AS date, AVG(mood_level) AS avg_mood
    FROM mood_logs
    WHERE user_id = ?
    GROUP BY DATE(log_time)
    ORDER BY DATE(log_time) DESC
    LIMIT 7
  `;
  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);

    if (results.length === 0) return res.json({ message: "No data available" });

    const average = (
      results.reduce((sum, r) => sum + r.avg_mood, 0) / results.length
    ).toFixed(2);

    const trend =
      results[0].avg_mood > results[results.length - 1].avg_mood
        ? "Mood is improving"
        : "Mood is declining";

    res.json({
      moodAverage: average,
      moodTrend: trend,
      rawData: results.reverse(),
    });
  });
});
const { createCanvas } = require("canvas");
const fs = require("fs");
const path = require("path");

app.get("/api/users/:userId/insight-visual", (req, res) => {
  const { userId } = req.params;

  const query = `
    SELECT DATE(log_time) AS date, AVG(mood_level) AS avg_mood
    FROM mood_logs
    WHERE user_id = ?
    GROUP BY DATE(log_time)
    ORDER BY DATE(log_time) DESC
    LIMIT 7
  `;

  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    if (results.length === 0) return res.status(404).send("No mood data");

    const width = 600;
    const height = 300;
    const canvas = createCanvas(width, height);
    const ctx = canvas.getContext("2d");

    ctx.fillStyle = "#fff";
    ctx.fillRect(0, 0, width, height);

    ctx.font = "20px Arial";
    ctx.fillStyle = "#333";
    ctx.fillText("Mood Trend (Last 7 Days)", 150, 30);

    // Draw graph axes
    ctx.strokeStyle = "#ccc";
    ctx.beginPath();
    ctx.moveTo(50, 250);
    ctx.lineTo(550, 250);
    ctx.lineTo(550, 50);
    ctx.stroke();

    // Mood line
    ctx.beginPath();
    ctx.strokeStyle = "#4CAF50";
    results.reverse().forEach((entry, i) => {
      const x = 70 + i * 70;
      const y = 250 - entry.avg_mood * 30;
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
      ctx.fillText(entry.avg_mood.toFixed(1), x - 10, y - 10);
      ctx.fillText(entry.date.slice(5), x - 15, 270);
    });
    ctx.stroke();

    res.setHeader("Content-Type", "image/png");
    canvas.pngStream().pipe(res);
  });
});

app.get("/api/users/:userId/heatmap-image", (req, res) => {
  const { userId } = req.params;

  const query = `
    SELECT DATE(log_time) AS date, ROUND(AVG(mood_level), 1) AS mood_level
    FROM mood_logs
    WHERE user_id = ?
    GROUP BY DATE(log_time)
    ORDER BY DATE(log_time)
  `;

  pool.query(query, [userId], (err, results) => {
    if (err) return handleDBError(res, err);
    if (results.length === 0) return res.status(404).send("No data");

    const width = 500;
    const height = 200;
    const cellWidth = 60;
    const cellHeight = 60;

    const canvas = createCanvas(width, height);
    const ctx = canvas.getContext("2d");

    ctx.fillStyle = "#fff";
    ctx.fillRect(0, 0, width, height);

    results.slice(-7).forEach((entry, i) => {
      const mood = entry.mood_level;
      const color = `rgba(${255 - mood * 40}, ${mood * 40}, 100, 1)`; // Heat coloring
      const x = i * cellWidth + 10;
      const y = 50;

      ctx.fillStyle = color;
      ctx.fillRect(x, y, cellWidth - 10, cellHeight);
      ctx.fillStyle = "#000";
      ctx.fillText(entry.date.slice(5), x + 5, y + cellHeight + 15);
      ctx.fillText(mood.toFixed(1), x + 5, y + 30);
    });

    res.setHeader("Content-Type", "image/png");
    canvas.pngStream().pipe(res);
  });
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
