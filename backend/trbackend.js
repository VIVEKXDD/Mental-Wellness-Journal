require("dotenv").config();
const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MySQL Database Connection Pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "root",
  database: process.env.DB_DATABASE || "wellness", // Replace with your actual database name
  port: parseInt(process.env.DB_PORT || "3306"),
  connectionLimit: 10,
});

// Test the database connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error("❌ MySQL Connection Error:", err);
    return;
  }
  console.log("✅ Connected to MySQL database");
  connection.release();
});

// --- Therapist API Endpoints ---

// Get all therapists
app.get("/api/therapists", async (req, res) => {
  try {
    const [therapists] = await pool.promise().query("SELECT * FROM Therapists");
    res.json(therapists);
  } catch (error) {
    console.error("❌ MySQL Error (Get All Therapists):", error);
    res.status(500).json({ error: "Failed to retrieve therapists." });
  }
});

// Get a specific therapist by ID
app.get("/api/therapists/:id", async (req, res) => {
  const therapistId = req.params.id;
  try {
    const [therapist] = await pool
      .promise()
      .query("SELECT * FROM Therapists WHERE id = ?", [therapistId]);
    if (therapist.length > 0) {
      res.json(therapist[0]);
    } else {
      res.status(404).json({ error: "Therapist not found." });
    }
  } catch (error) {
    console.error("❌ MySQL Error (Get Therapist by ID):", error);
    res.status(500).json({ error: "Failed to retrieve therapist." });
  }
});

// Add a new therapist
app.post("/api/therapists", async (req, res) => {
  const {
    name,
    specialization,
    experience,
    image,
    bio,
    email,
    phone,
    location,
    rating,
  } = req.body;
  if (!name || !specialization || !experience || !email) {
    return res.status(400).json({
      error: "Name, specialization, experience, and email are required.",
    });
  }
  try {
    const [result] = await pool
      .promise()
      .query(
        "INSERT INTO Therapists (name, specialization, experience, image, bio, email, phone, location, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          name,
          specialization,
          experience,
          image,
          bio,
          email,
          phone,
          location,
          rating,
        ]
      );
    res
      .status(201)
      .json({ id: result.insertId, message: "Therapist added successfully." });
  } catch (error) {
    console.error("❌ MySQL Error (Add Therapist):", error);
    res.status(500).json({ error: "Failed to add therapist." });
  }
});

// Update an existing therapist
app.put("/api/therapists/:id", async (req, res) => {
  const therapistId = req.params.id;
  const {
    name,
    specialization,
    experience,
    image,
    bio,
    email,
    phone,
    location,
    rating,
  } = req.body;
  try {
    const [result] = await pool
      .promise()
      .query(
        "UPDATE Therapists SET name = ?, specialization = ?, experience = ?, image = ?, bio = ?, email = ?, phone = ?, location = ?, rating = ? WHERE id = ?",
        [
          name,
          specialization,
          experience,
          image,
          bio,
          email,
          phone,
          location,
          rating,
          therapistId,
        ]
      );
    if (result.affectedRows > 0) {
      res.json({ message: "Therapist updated successfully." });
    } else {
      res.status(404).json({ error: "Therapist not found." });
    }
  } catch (error) {
    console.error("❌ MySQL Error (Update Therapist):", error);
    res.status(500).json({ error: "Failed to update therapist." });
  }
});

// Delete a therapist
app.delete("/api/therapists/:id", async (req, res) => {
  const therapistId = req.params.id;
  try {
    const [result] = await pool
      .promise()
      .query("DELETE FROM Therapists WHERE id = ?", [therapistId]);
    if (result.affectedRows > 0) {
      res.json({ message: "Therapist deleted successfully." });
    } else {
      res.status(404).json({ error: "Therapist not found." });
    }
  } catch (error) {
    console.error("❌ MySQL Error (Delete Therapist):", error);
    res.status(500).json({ error: "Failed to delete therapist." });
  }
});

// Get availability for a specific therapist
app.get("/api/therapists/:therapistId/availability", async (req, res) => {
  const therapistId = req.params.therapistId;
  try {
    const [availability] = await pool
      .promise()
      .query("SELECT day, timeSlot FROM Availability WHERE therapistId = ?", [
        therapistId,
      ]);
    res.json(availability);
  } catch (error) {
    console.error("❌ MySQL Error (Get Availability):", error);
    res.status(500).json({ error: "Failed to retrieve availability." });
  }
});

// Add availability for a specific therapist
app.post("/api/therapists/:therapistId/availability", async (req, res) => {
  const therapistId = req.params.therapistId;
  const { day, timeSlot } = req.body;
  if (!day || !timeSlot) {
    return res.status(400).json({ error: "Day and timeSlot are required." });
  }
  try {
    const [result] = await pool
      .promise()
      .query(
        "INSERT INTO Availability (therapistId, day, timeSlot) VALUES (?, ?, ?)",
        [therapistId, day, timeSlot]
      );
    res.status(201).json({
      id: result.insertId,
      message: "Availability added successfully.",
    });
  } catch (error) {
    console.error("❌ MySQL Error (Add Availability):", error);
    res.status(500).json({ error: "Failed to add availability." });
  }
});

// Delete specific availability for a therapist
app.delete("/api/therapists/:therapistId/availability", async (req, res) => {
  const therapistId = req.params.therapistId;
  const { day, timeSlot } = req.body;
  if (!day || !timeSlot) {
    return res
      .status(400)
      .json({ error: "Day and timeSlot are required to delete availability." });
  }
  try {
    const [result] = await pool
      .promise()
      .query(
        "DELETE FROM Availability WHERE therapistId = ? AND day = ? AND timeSlot = ?",
        [therapistId, day, timeSlot]
      );
    if (result.affectedRows > 0) {
      res.json({ message: "Availability deleted successfully." });
    } else {
      res.status(404).json({
        error:
          "Availability not found for the given therapist, day, and time slot.",
      });
    }
  } catch (error) {
    console.error("❌ MySQL Error (Delete Availability):", error);
    res.status(500).json({ error: "Failed to delete availability." });
  }
});

// Get reviews for a specific therapist
app.get("/api/therapists/:therapistId/reviews", async (req, res) => {
  const therapistId = req.params.therapistId;
  try {
    const [reviews] = await pool
      .promise()
      .query(
        "SELECT id, userId, comment, rating, date FROM Reviews WHERE therapistId = ?",
        [therapistId]
      );
    res.json(reviews);
  } catch (error) {
    console.error("❌ MySQL Error (Get Reviews):", error);
    res.status(500).json({ error: "Failed to retrieve reviews." });
  }
});

// Add a review for a specific therapist
app.post("/api/therapists/:therapistId/reviews", async (req, res) => {
  const therapistId = req.params.therapistId;
  const { userId, comment, rating } = req.body;
  if (!userId || !rating) {
    return res
      .status(400)
      .json({ error: "UserId and rating are required for a review." });
  }
  if (rating < 1 || rating > 5) {
    return res.status(400).json({ error: "Rating must be between 1 and 5." });
  }
  try {
    const [result] = await pool
      .promise()
      .query(
        "INSERT INTO Reviews (therapistId, userId, comment, rating) VALUES (?, ?, ?, ?)",
        [therapistId, userId, comment, rating]
      );
    res
      .status(201)
      .json({ id: result.insertId, message: "Review added successfully." });
  } catch (error) {
    console.error("❌ MySQL Error (Add Review):", error);
    res.status(500).json({ error: "Failed to add review." });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(
    `🚀 Server running on http://localhost:${PORT} (Thane, Maharashtra, India - Current Time: Friday, April 4, 2025 at 6:42 PM PST)`
  );
});
