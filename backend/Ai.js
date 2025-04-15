require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const axios = require("axios");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors({ origin: "*" }));

// Connect to MongoDB
mongoose
  .connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.error("❌ MongoDB Connection Error:", err));

// Define Chat Schema
const chatSchema = new mongoose.Schema({
  userId: { type: String, required: true, unique: true },
  messages: [
    {
      sender: { type: String, enum: ["You", "TAL AI"], required: true },
      text: { type: String, required: true },
      timestamp: { type: Date, default: Date.now },
    },
  ],
});
const Chat = mongoose.model("Chat", chatSchema);

// API to handle chat messages
app.post("/api/chat", async (req, res) => {
  const { userId, userMessage } = req.body;

  // Validate input
  if (!userId || !userMessage || !userMessage.trim()) {
    return res.status(400).json({ error: "User ID and message are required." });
  }

  try {
    console.log(`📨 User: ${userMessage}`);

    // Call DeepSeek v3 API (AIML API website)
    const response = await axios.post(
      process.env.DEEPSEEK_API_URL, // Replace with your AIML API website URL
      {
        pattern: userMessage, // or whatever the api website uses.
        apikey: process.env.DEEPSEEK_API_KEY,
      },
      {
        headers: { "Content-Type": "application/json" },
      }
    );

    console.log("🤖 AI API Response:", response.data);

    // Check if the response contains the expected data
    const aiResponse = response.data.response || "I'm still learning."; // Adjust based on your API's response format

    // Update chat history
    let chat = await Chat.findOneAndUpdate(
      { userId },
      {
        $push: {
          messages: [
            { sender: "You", text: userMessage },
            { sender: "TAL AI", text: aiResponse },
          ],
        },
      },
      { new: true, upsert: true } // Create if not exists
    );

    res.json({ aiResponse, chatHistory: chat.messages });
  } catch (error) {
    // Improved error handling
    console.error("❌ AI API Error:", error.response?.data || error.message);
    res.status(500).json({ error: "Failed to get AI response." });
  }
});

// API to retrieve chat history
app.get("/api/chat/:userId", async (req, res) => {
  const { userId } = req.params;
  try {
    const chat = await Chat.findOne({ userId });
    res.json(chat ? chat.messages : []);
  } catch (error) {
    console.error("❌ Database Error:", error);
    res.status(500).json({ error: "Failed to retrieve chat history." });
  }
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
