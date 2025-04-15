const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect("mongodb://localhost:27017/mental_health", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define Schemas
const HelplineSchema = new mongoose.Schema({ name: String, number: String });
const TherapistSchema = new mongoose.Schema({
  name: String,
  specialization: String,
  available: Boolean,
});

// Define Models
const Helpline = mongoose.model("Helpline", HelplineSchema);
const Therapist = mongoose.model("Therapist", TherapistSchema);

// Get all helplines
app.get("/api/helplines", async (req, res) => {
  const helplines = await Helpline.find();
  res.json(helplines);
});

// Get active therapists
app.get("/api/therapists", async (req, res) => {
  const therapists = await Therapist.find({ available: true });
  res.json(therapists);
});

// Seed Database (Run once)
app.get("/api/seed", async (req, res) => {
  await Helpline.insertMany([
    { name: "National Helpline", number: "123-456-7890" },
    { name: "Crisis Support", number: "987-654-3210" },
  ]);

  await Therapist.insertMany([
    { name: "Dr. Smith", specialization: "Anxiety", available: true },
    { name: "Dr. Jane", specialization: "Depression", available: false },
    { name: "Dr. Ray", specialization: "Stress Management", available: true },
  ]);

  res.send("Database seeded successfully.");
});

// Start Server
const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
