const express = require("express");
const router = express.Router();
const pool = require("../db");

const send = async (res, run) => {
  try {
    res.json(await run());
  } catch (err) {
    console.error("DB query error:", err.message);
    res.status(500).json({ error: "Database error" });
  }
};

const rows = async (sql, params = []) => (await pool.query(sql, params)).rows;

// Full CV, or the curated subset for the 1-page resume (in_resume rows, short
// project descriptions via COALESCE(resume_description, description)).
const getCv = async (resumeOnly) => {
  const experienceSql = resumeOnly
    ? "SELECT * FROM experience WHERE in_resume = true ORDER BY sort_order ASC"
    : "SELECT * FROM experience ORDER BY sort_order ASC";

  const projectsSql = resumeOnly
    ? "SELECT id, name, COALESCE(resume_description, description) AS description, " +
      "tech_stack, status, github_url, demo_url, private_repo, sort_order " +
      "FROM projects WHERE in_resume = true ORDER BY sort_order ASC"
    : "SELECT * FROM projects ORDER BY sort_order ASC";

  const [profile, experience, education, skills, projects, awards, languages, traits] =
    await Promise.all([
      rows("SELECT * FROM profile LIMIT 1"),
      rows(experienceSql),
      rows("SELECT * FROM education ORDER BY sort_order ASC"),
      rows("SELECT * FROM skills ORDER BY category_order, sort_order ASC"),
      rows(projectsSql),
      rows("SELECT * FROM awards ORDER BY sort_order ASC"),
      rows("SELECT * FROM languages ORDER BY id ASC"),
      resumeOnly ? [] : rows("SELECT * FROM traits ORDER BY sort_order ASC"),
    ]);

  return {
    profile: profile[0],
    experience,
    education,
    skills,
    projects,
    awards,
    languages,
    ...(resumeOnly ? {} : { traits }),
  };
};

router.get("/", (_req, res) => send(res, () => getCv(false)));
router.get("/resume", (_req, res) => send(res, () => getCv(true)));

// Individual section endpoints — handy for partial updates later
router.get("/profile",    (_req, res) => send(res, () => rows("SELECT * FROM profile LIMIT 1")));
router.get("/experience", (_req, res) => send(res, () => rows("SELECT * FROM experience ORDER BY sort_order ASC")));
router.get("/education",  (_req, res) => send(res, () => rows("SELECT * FROM education ORDER BY sort_order ASC")));
router.get("/skills",     (_req, res) => send(res, () => rows("SELECT * FROM skills ORDER BY category_order, sort_order ASC")));
router.get("/projects",   (_req, res) => send(res, () => rows("SELECT * FROM projects ORDER BY sort_order ASC")));
router.get("/awards",     (_req, res) => send(res, () => rows("SELECT * FROM awards ORDER BY sort_order ASC")));
router.get("/languages",  (_req, res) => send(res, () => rows("SELECT * FROM languages ORDER BY id ASC")));
router.get("/traits",     (_req, res) => send(res, () => rows("SELECT * FROM traits ORDER BY sort_order ASC")));

module.exports = router;
