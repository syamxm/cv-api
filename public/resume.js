// =============================================================================
// resume.js — Resume Frontend Logic
//
// 1. Fetches all CV data from the API in one request on page load
// 2. Builds the compact 1-page A4 resume DOM from the returned JSON
// 3. Handles PDF export via the browser's native print (window.print)
//
// Data source: /api/cv/resume — the compact, curated subset (rows flagged
// in_resume in sql/seed.sql, with short resume_description text). To change
// what the resume shows: edit those flags/descriptions and re-seed. Tuned to
// one A4 page — trim a project line if it overflows.
// =============================================================================


// --- Entry point ------------------------------------------------------------

document.addEventListener("DOMContentLoaded", loadResume);


// --- Fetch + render ----------------------------------------------------------

async function loadResume() {
  try {
    const res = await fetch("/api/cv/resume");

    if (!res.ok) throw new Error(`API returned ${res.status}`);

    const data = await res.json();

    buildResume(data);

    document.getElementById("loading").style.display = "none";
    document.getElementById("resume").classList.remove("hidden");

  } catch (err) {
    document.getElementById("loading").textContent =
      "Failed to load resume. Is the API running?";
    console.error("Resume load error:", err);
  }
}


// --- Build the resume DOM ---------------------------------------------------

function buildResume(data) {
  const container = document.getElementById("resume");

  container.innerHTML = `
    ${buildHeader(data.profile)}
    ${buildSummary(data.profile)}
    <div class="body">
      <div class="col-left">
        ${buildExperience(data.experience)}
        ${buildProjects(data.projects)}
      </div>
      <div class="col-right">
        ${buildEducation(data.education)}
        ${buildSkills(data.skills)}
        ${buildAwards(data.awards)}
        ${buildLanguages(data.languages)}
      </div>
    </div>
  `;
}


// --- Section builders -------------------------------------------------------

function buildHeader(p) {
  return `
    <header class="header">
      <div class="header-left">
        <h1>${p.name}</h1>
        <p class="title">${p.title}</p>
      </div>
      <div class="header-right">
        <span>${p.location}</span>
        <a href="mailto:${p.email}">${p.email}</a>
        <a href="${p.github}" target="_blank">${p.github}</a>
        <span class="availability">Available for 14-week internship</span>
      </div>
    </header>
  `;
}


function buildSummary(p) {
  if (!p.summary) return "";
  return `<section class="summary">${p.summary}</section>`;
}


function buildExperience(items) {
  if (!items.length) return "";

  const entries = items.map(e => `
    <div class="entry">
      <div class="entry-header">
        <span class="entry-role">${e.role} — ${e.company}</span>
        <span class="entry-date">${e.start_date === e.end_date ? e.start_date : `${e.start_date} – ${e.end_date || "Present"}`}</span>
      </div>
      ${e.location ? `<div class="entry-sub">${e.location}</div>` : ""}
      ${e.bullets ? `<ul class="entry-bullets">${e.bullets.map(b => `<li>${b}</li>`).join("")}</ul>` : ""}
    </div>
  `).join("");

  return section("Experience", entries);
}


function buildProjects(items) {
  if (!items.length) return "";

  const projects = items.map(p => {
    const badgeClass = {
      "Complete": "badge-complete",
      "Maintained": "badge-maintained",
      "In Development": "badge-dev",
      "Planned": "badge-planned",
    }[p.status] || "badge-planned";

    const stack = p.tech_stack && p.tech_stack[0] !== "TBD"
      ? `<p class="project-stack">${p.tech_stack.join(" · ")}</p>`
      : "";

    const githubLink = p.github_url
      ? `<a class="project-link" href="${p.github_url}" target="_blank">↗ GitHub</a>`
      : p.private_repo
        ? `<span class="project-private">Private repo</span>`
        : "";

    return `
      <div class="project">
        <div class="project-header">
          <span class="project-name">${p.name}</span>
          <span class="badge ${badgeClass}">${p.status}</span>
        </div>
        ${stack}
        <p class="project-desc">${p.description}</p>
        ${githubLink}
      </div>
    `;
  }).join("");

  return section("Projects", projects);
}


function buildEducation(items) {
  if (!items.length) return "";

  const entries = items.map(e => {
    const note = e.achievements && e.achievements.length
      ? e.achievements.join(" · ")
      : "";

    return `
      <div class="edu-entry">
        <div class="edu-header">
          <span class="edu-place">${e.institution}</span>
          <span class="edu-date">${e.start_date === e.end_date ? e.start_date : `${e.start_date} – ${e.end_date || "Present"}`}</span>
        </div>
        <p class="edu-degree">${e.degree}${e.location ? ` · ${e.location}` : ""}</p>
        ${note ? `<p class="edu-note">${note}</p>` : ""}
      </div>
    `;
  }).join("");

  return section("Education", entries);
}


function buildSkills(items) {
  if (!items.length) return "";

  const grouped = items.reduce((acc, s) => {
    if (!acc[s.category]) acc[s.category] = [];
    acc[s.category].push(s.name);
    return acc;
  }, {});

  const groups = Object.entries(grouped).map(([cat, names]) => `
    <div class="skill-group">
      <h3>${cat}</h3>
      <p>${names.join(", ")}</p>
    </div>
  `).join("");

  return section("Skills", groups);
}


function buildAwards(items) {
  if (!items.length) return "";

  const awards = items
    .map(a => `<li>${a.title}</li>`)
    .join("");

  return section("Awards", `<ul class="awards-list">${awards}</ul>`);
}


function buildLanguages(items) {
  if (!items.length) return "";

  const langs = items
    .map(l => `<li>${l.name} <span class="lang-level">(${l.level})</span></li>`)
    .join("");

  return section("Languages", `<ul class="awards-list">${langs}</ul>`);
}


// --- Utility: wrap content in a labelled section ----------------------------

function section(title, content) {
  return `
    <section class="section">
      <h2>${title}</h2>
      ${content}
    </section>
  `;
}


// --- PDF Export — native print to A4 (styled by @media print + @page) --------

function exportPDF() {
  window.print();
}
