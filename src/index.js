require("dotenv").config();

const express = require("express");
const path = require("path");
const cvRoutes = require("./routes/cv");

const app = express();
const PORT = process.env.PORT || 3001;

app.disable("x-powered-by");
app.use(express.json());

// Serve static frontend assets from /public
app.use(express.static(path.join(__dirname, "../public")));

app.use("/api/cv", cvRoutes);

// Clean URL for the full CV (resume is the landing page at /)
app.get("/cv", (_req, res) => {
  res.sendFile(path.join(__dirname, "../public/cv.html"));
});

// Catch-all: unknown routes fall back to the resume landing page
app.get("*", (_req, res) => {
  res.sendFile(path.join(__dirname, "../public/index.html"));
});

app.listen(PORT, () => {
  console.log(`CV API running on port ${PORT}`);
});
