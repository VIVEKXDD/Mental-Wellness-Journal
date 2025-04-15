require("dotenv").config();
const mongoose = require("mongoose");
const Therapist = require("./models/Therapist");

mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const seedTherapists = async () => {
  await Therapist.deleteMany(); // Clear existing data

  const therapists = [
    {
      name: "Aashwin",
      specialization: "Anxiety & Depression",
      experience: 8,
      image: "https://via.placeholder.com/60",
      bio: "Expert in managing anxiety and depression.",
      contact: { email: "aashwin@example.com", phone: "1234567890" },
      availability: [{ day: "Monday", timeSlots: ["10:00 AM - 11:00 AM"] }],
      location: "New York, USA",
      rating: 4.5,
      reviews: [],
    },
    {
      name: "Priya",
      specialization: "Relationship Issues",
      experience: 5,
      image: "https://via.placeholder.com/60",
      bio: "Helping couples and individuals with relationship challenges.",
      contact: { email: "priya@example.com", phone: "0987654321" },
      availability: [{ day: "Tuesday", timeSlots: ["2:00 PM - 3:00 PM"] }],
      location: "Los Angeles, USA",
      rating: 4.8,
      reviews: [],
    },
  ];

  await Therapist.insertMany(therapists);
  console.log("✅ Therapists seeded!");
  mongoose.connection.close();
};

seedTherapists();
