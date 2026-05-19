const express = require("express");
const router = express.Router();
const pool = require("../db");

// Helper: runs a query and sends results as JSON.
// Keeps each route clean — no repeated try/catch boilerplate.
const query = async (res, sql, params = []) => {
  try {
    const result = await pool.query(sql, params);
    res.json(result.rows);
  } catch (err) {
    console.error("DB query error:", err.message);
    res.status(500).json({ error: "Database error" });
  }
};

// GET /api/cv — full CV in one shot, useful for the frontend on load
router.get("/", async (req, res) => {
  try {
    // Run all queries in parallel — faster than one by one
    const [profile, experience, education, skills, projects, awards, languages] =
      await Promise.all([
        pool.query("SELECT * FROM profile LIMIT 1"),
        pool.query("SELECT * FROM experience ORDER BY sort_order ASC"),
        pool.query("SELECT * FROM education ORDER BY sort_order ASC"),
        pool.query("SELECT * FROM skills ORDER BY category, sort_order ASC"),
        pool.query("SELECT * FROM projects ORDER BY sort_order ASC"),
        pool.query("SELECT * FROM awards ORDER BY sort_order ASC"),
        pool.query("SELECT * FROM languages ORDER BY id ASC"),
      ]);

    res.json({
      profile: profile.rows[0],
      experience: experience.rows,
      education: education.rows,
      skills: skills.rows,
      projects: projects.rows,
      awards: awards.rows,
      languages: languages.rows,
    });
  } catch (err) {
    console.error("DB query error:", err.message);
    res.status(500).json({ error: "Database error" });
  }
});

// Individual section endpoints — handy for partial updates later
router.get("/profile",    (req, res) => query(res, "SELECT * FROM profile LIMIT 1"));
router.get("/experience", (req, res) => query(res, "SELECT * FROM experience ORDER BY sort_order ASC"));
router.get("/education",  (req, res) => query(res, "SELECT * FROM education ORDER BY sort_order ASC"));
router.get("/skills",     (req, res) => query(res, "SELECT * FROM skills ORDER BY category, sort_order ASC"));
router.get("/projects",   (req, res) => query(res, "SELECT * FROM projects ORDER BY sort_order ASC"));
router.get("/awards",     (req, res) => query(res, "SELECT * FROM awards ORDER BY sort_order ASC"));
router.get("/languages",  (req, res) => query(res, "SELECT * FROM languages ORDER BY id ASC"));

module.exports = router;
