// =============================================================================
// app.js — CV Frontend Logic
//
// 1. Fetches all CV data from the API in one request on page load
// 2. Builds the page DOM from the returned JSON
// 3. Handles PDF export via the browser's native print (window.print)
//
// To update CV content: edit sql/seed.sql and re-seed the database.
// No need to touch this file unless you're changing layout or structure.
// =============================================================================


// --- Entry point ------------------------------------------------------------

document.addEventListener("DOMContentLoaded", loadCV);


// --- Fetch + render ----------------------------------------------------------

async function loadCV() {
  try {
    const res = await fetch("/api/cv");

    if (!res.ok) throw new Error(`API returned ${res.status}`);

    const data = await res.json();

    buildCV(data);

    // Swap loading spinner for the real content
    document.getElementById("loading").style.display = "none";
    document.getElementById("cv").classList.remove("hidden");

  } catch (err) {
    document.getElementById("loading").textContent =
      "Failed to load CV. Is the API running?";
    console.error("CV load error:", err);
  }
}


// --- Build the full CV DOM --------------------------------------------------

function buildCV(data) {
  const container = document.getElementById("cv");

  container.innerHTML = `
    ${buildHeader(data.profile)}
    ${buildSummary(data.profile)}
    ${buildExperience(data.experience)}
    ${buildEducation(data.education)}
    ${buildSkills(data.skills)}
    ${buildProjects(data.projects)}
    ${buildAwards(data.awards)}
    ${buildLanguages(data.languages)}
  `;
}


// --- Section builders -------------------------------------------------------

function buildHeader(p) {
  return `
    <header class="cv-header">
      <h1>${p.name}</h1>
      <p class="cv-title">${p.title}</p>
      <div class="cv-contacts">
        <span>${p.location}</span>
        <a href="mailto:${p.email}">${p.email}</a>
        <a href="${p.github}" target="_blank">${p.github}</a>
      </div>
    </header>
  `;
}


function buildSummary(p) {
  if (!p.summary) return "";
  return `<p class="cv-summary">${p.summary}</p>`;
}


function buildExperience(items) {
  if (!items.length) return "";

  const entries = items.map(e => `
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">${e.role}</span>
        <span class="entry-date">${e.start_date} – ${e.end_date || "Present"}</span>
      </div>
      <div class="entry-sub">${e.company}${e.location ? ` · ${e.location}` : ""}</div>
      ${e.bullets ? `<ul>${e.bullets.map(b => `<li>${b}</li>`).join("")}</ul>` : ""}
    </div>
  `).join("");

  return section("Experience", entries);
}


function buildEducation(items) {
  if (!items.length) return "";

  const entries = items.map(e => `
    <div class="entry">
      <div class="entry-header">
        <span class="entry-title">${e.institution}</span>
        <span class="entry-date">${e.start_date} – ${e.end_date || "Present"}</span>
      </div>
      <div class="entry-sub">${e.degree}${e.field ? ` in ${e.field}` : ""}${e.location ? ` · ${e.location}` : ""}</div>
      ${e.gpa ? `<span class="entry-gpa">GPA ${e.gpa}</span>` : ""}
      ${e.achievements ? `<ul>${e.achievements.map(a => `<li>${a}</li>`).join("")}</ul>` : ""}
    </div>
  `).join("");

  return section("Education", entries);
}


function buildSkills(items) {
  if (!items.length) return "";

  // Group skills by category
  const grouped = items.reduce((acc, s) => {
    if (!acc[s.category]) acc[s.category] = [];
    acc[s.category].push(s.name);
    return acc;
  }, {});

  const grid = Object.entries(grouped).map(([cat, names]) => `
    <div class="skill-group">
      <h3>${cat}</h3>
      <div class="skill-tags">
        ${names.map(n => `<span class="skill-tag">${n}</span>`).join("")}
      </div>
    </div>
  `).join("");

  return section("Skills", `<div class="skills-grid">${grid}</div>`);
}


function buildProjects(items) {
  if (!items.length) return "";

  const projects = items.map(p => {
    // Map status string to a CSS class
    const statusClass = {
      "Complete":       "status-complete",
      "Maintained":     "status-maintained",
      "In Development": "status-development",
      "Planned":        "status-planned",
    }[p.status] || "status-planned";

    const stack = p.tech_stack && p.tech_stack[0] !== "TBD"
      ? `<div class="project-stack">${p.tech_stack.join(" · ")}</div>`
      : "";

    const link = p.github_url
      ? `<a class="project-link" href="${p.github_url}" target="_blank">↗ GitHub</a>`
      : "";

    return `
      <div class="project">
        <div class="project-header">
          <span class="project-name">${p.name}</span>
          <span class="status-badge ${statusClass}">${p.status}</span>
        </div>
        ${stack}
        <p class="project-desc">${p.description}</p>
        ${link}
      </div>
    `;
  }).join("");

  return section("Projects", projects);
}


function buildAwards(items) {
  if (!items.length) return "";

  const awards = items.map(a => `
    <div class="award">
      <div class="award-dot"></div>
      <div>
        <div class="award-title">${a.title}</div>
        ${a.description ? `<div class="award-desc">${a.description}</div>` : ""}
      </div>
    </div>
  `).join("");

  return section("Awards", awards);
}


function buildLanguages(items) {
  if (!items.length) return "";

  const langs = items.map(l => `
    <span class="lang-item">
      ${l.name}<span class="lang-level">(${l.level})</span>
    </span>
  `).join("");

  return section("Languages", `<div class="languages-list">${langs}</div>`);
}


// --- Utility: wrap content in a labelled section ----------------------------

function section(title, content) {
  return `
    <section class="cv-section">
      <h2>${title}</h2>
      ${content}
    </section>
  `;
}


// --- PDF Export — native print (styled by @media print + @page) --------------

function exportPDF() {
  window.print();
}
