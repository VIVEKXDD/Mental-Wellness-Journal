const express = require("express");
const mysql = require("mysql");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const cors = require("cors");
require("dotenv").config();

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MySQL Database Connection
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // Change this if necessary
  password: "root", // Change this if you have a different password
  database: "mental_wellness",
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    return;
  }
  console.log("Connected to MySQL database");
});

// Authentication Middleware
const authenticateToken = (req, res, next) => {
  const token = req.header("Authorization");
  if (!token) return res.status(401).json({ message: "Access Denied" });
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: "Invalid Token" });
    req.user = user;
    next();
  });
};

// User Registration
app.post("/register", (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = bcrypt.hashSync(password, 10);
  const sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
  db.query(sql, [username, email, hashedPassword], (err, result) => {
    if (err) {
      console.error("Error registering user:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "User Registered" });
  });
});

// User Login
app.post("/login", (req, res) => {
  const { email, password } = req.body;
  const sql = "SELECT * FROM users WHERE email = ?";
  db.query(sql, [email], (err, result) => {
    if (err) {
      console.error("Error fetching user:", err);
      return res.status(500).json({ error: "Database error" });
    }
    if (
      result.length === 0 ||
      !bcrypt.compareSync(password, result[0].password)
    ) {
      return res.status(400).json({ message: "Invalid Credentials" });
    }
    const token = jwt.sign({ id: result[0].id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });
    res.json({ token });
  });
});

// Get all Journals and Notes for a User (Combined)
app.get("/journals", authenticateToken, (req, res) => {
  const userId = req.user.id;

  const sqlJournals =
    "SELECT id AS _id, date, content, 'journal' AS type FROM journals WHERE userId = ?";
  const sqlNotes =
    "SELECT id AS _id, created_at AS date, content, title AS title, 'note' AS type FROM notes WHERE userId = ?";

  db.query(sqlJournals, [userId], (errJournals, resultJournals) => {
    if (errJournals) {
      console.error("Error fetching journals:", errJournals);
      return res
        .status(500)
        .json({ error: "Database error fetching journals" });
    }

    db.query(sqlNotes, [userId], (errNotes, resultNotes) => {
      if (errNotes) {
        console.error("Error fetching notes:", errNotes);
        return res.status(500).json({ error: "Database error fetching notes" });
      }

      // Combine the results
      const combinedEntries = [
        ...resultJournals.map((j) => ({ ...j, date: new Date(j.date) })), // Ensure date is a Date object
        ...resultNotes.map((n) => ({
          ...n,
          date: new Date(n.date),
          title: n.title || "Note",
        })), // Ensure date is a Date object, add a default title
      ];

      // Sort combined entries by date (newest first)
      combinedEntries.sort((a, b) => new Date(b.date) - new Date(a.date));

      res.json(combinedEntries);
    });
  });
});

// Create a Journal Entry
app.post("/journals", authenticateToken, (req, res) => {
  const { date, content } = req.body;
  const sql = "INSERT INTO journals (userId, date, content) VALUES (?, ?, ?)";
  db.query(sql, [req.user.id, date, content], (err, result) => {
    if (err) {
      console.error("Error adding journal:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "Journal Added" });
  });
});

// Delete a Journal Entry
app.delete("/journals/:id", authenticateToken, (req, res) => {
  const sql = "DELETE FROM journals WHERE id = ? AND userId = ?";
  db.query(sql, [req.params.id, req.user.id], (err, result) => {
    if (err) {
      console.error("Error deleting journal:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "Journal Deleted" });
  });
});

// Get all Notes for a User
app.get("/notes", authenticateToken, (req, res) => {
  const sql = "SELECT * FROM notes WHERE userId = ?";
  db.query(sql, [req.user.id], (err, result) => {
    if (err) {
      console.error("Error fetching notes:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json(result);
  });
});

// Create a Note
app.post("/notes", authenticateToken, (req, res) => {
  const { title, content, journalId } = req.body;
  const sql =
    "INSERT INTO notes (userId, title, content, journalId) VALUES (?, ?, ?, ?)";
  db.query(sql, [req.user.id, title, content, journalId], (err, result) => {
    if (err) {
      console.error("Error adding note:", err);
      return res.status(500).json({ error: "Database error" });
    }
    // Send back the newly created note object (or at least its ID)
    const newNoteId = result.insertId;
    db.query(
      "SELECT * FROM notes WHERE id = ?",
      [newNoteId],
      (err, newNoteResult) => {
        if (err) {
          console.error("Error fetching new note:", err);
          return res.status(500).json({ error: "Database error" });
        }
        res.json(newNoteResult[0]);
      }
    );
  });
});

// Update a Note
app.put("/notes/:id", authenticateToken, (req, res) => {
  const { title, content, journalId } = req.body;
  const noteId = req.params.id;
  const sql =
    "UPDATE notes SET title = ?, content = ?, journalId = ? WHERE id = ? AND userId = ?";
  db.query(
    sql,
    [title, content, journalId, noteId, req.user.id],
    (err, result) => {
      if (err) {
        console.error("Error updating note:", err);
        return res.status(500).json({ error: "Database error" });
      }
      if (result.affectedRows === 0) {
        return res
          .status(404)
          .json({ message: "Note not found or unauthorized" });
      }
      res.json({ message: "Note Updated" });
    }
  );
});

// Delete a Note
app.delete("/notes/:id", authenticateToken, (req, res) => {
  const sql = "DELETE FROM notes WHERE id = ? AND userId = ?";
  db.query(sql, [req.params.id, req.user.id], (err, result) => {
    if (err) {
      console.error("Error deleting note:", err);
      return res.status(500).json({ error: "Database error" });
    }
    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ message: "Note not found or unauthorized" });
    }
    res.json({ message: "Note Deleted" });
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
