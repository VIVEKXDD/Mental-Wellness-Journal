const mongoose = require("mongoose");

const ChatSchema = new mongoose.Schema(
  {
    userMessage: String,
    aiReply: String,
  },
  { timestamps: true }
);

module.exports = mongoose.model("Chat", ChatSchema);
