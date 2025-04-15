# 🧘‍♀️ Mental Wellness Journal Web App

## 📝 Overview

The Mental Wellness Journal Web App is a secure and minimalistic platform designed to encourage daily journaling and mental wellness. It provides users with a private, distraction-free space to record their thoughts and track emotional patterns. This full-stack web application uses Node.js, Express, and JavaScript to handle authentication, dashboard functionality, and journal entry management.

---

## 🚀 Features

- 🧑‍💻 User Registration and Login
- 📓 Secure Journaling Interface
- 🗂️ Personalized Dashboard
- 📁 File-based Storage (or Database-ready)
- 🔐 Secure Configuration using `.env`
- ✨ Modular Backend Routes (reg, dashboard, journalling)

---

## 📦 Project Structure

```
mental-wellness-journal/
│
├── public/                 # Static HTML/CSS/JS files
├── routes/                 # Express route files (reg.js, dashboard.js, journalling.js)
├── views/                  # HTML templates (if applicable)
├── .env                    # Environment variables
├── server.js               # Main server setup
├── package.json            # Project dependencies
└── README.md               # You're reading it!
```

---

## 🔧 Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/mental-wellness-journal.git
   cd mental-wellness-journal
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Set Up Environment**
   Create a `.env` file and add your configurations:
   ```
   PORT=3000
   SESSION_SECRET=your-secret
   DB_URL=your-database-url (if using DB)
   ```

4. **Run the Application**
   ```bash
   npm start
   ```

5. Open your browser and go to `http://localhost:3000`

---

## 🌐 Technologies Used

- Node.js
- Express.js
- HTML5 & CSS3
- JavaScript (Vanilla)
- dotenv (for secure configuration)
- (Optional) MongoDB or file-based storage

---

## 📌 Future Enhancements

- Mood tracker and emotion tagging
- Sentiment analysis for journal entries
- Rich-text editor with formatting options
- Data visualization and insights dashboard
- Mobile responsiveness

---

## 🧠 Purpose

This project is designed to:
- Encourage mindfulness through journaling
- Provide a simple yet effective web-based solution
- Showcase full-stack web development skills
- Demonstrate modular and secure architecture

---

## 🙌 Acknowledgements

Built as part of the MBATECH Web Programming course project.

---

## 📬 Feedback

For suggestions or queries, feel free to open an issue or contact the contributor.
