require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");
const cvRoutes = require("./routes/cv");

const app = express();
const PORT = process.env.PORT || 3001;

// Allow the frontend (served separately or from same origin) to call the API
app.use(cors());
app.use(express.json());

// Serve the frontend — index.html, style.css, app.js live in /public
app.use(express.static(path.join(__dirname, "../public")));

// All CV data lives under /api/cv
app.use("/api/cv", cvRoutes);

// Clean URL for the 1-page resume
app.get("/resume", (req, res) => {
  res.sendFile(path.join(__dirname, "../public/resume.html"));
});

// Catch-all: any unknown route gets the frontend (single-page behaviour)
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "../public/index.html"));
});

app.listen(PORT, () => {
  console.log(`CV API running on port ${PORT}`);
});
