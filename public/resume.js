document.addEventListener("DOMContentLoaded", () =>
  mountOnLoad("/api/cv/resume", "resume", buildResume, "Failed to load resume. Is the API running?")
);

function buildResume(data) {
  document.getElementById("resume").innerHTML = `
    ${buildHeader(data.profile)}
    ${buildSummary(data.profile)}
    <div class="body">
      <div class="col-left">
        ${buildProjects(data.projects)}
        ${buildExperience(data.experience)}
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

function buildHeader(p) {
  return `
    <header class="header">
      <div class="header-left">
        <h1>${p.name}</h1>
        <p class="title">${p.title}</p>
      </div>
      <div class="header-right">
        <span>${p.location}</span>
        <a href="tel:${p.phone}">${p.phone}</a>
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
        <span class="entry-date">${formatDateRange(e.start_date, e.end_date)}</span>
      </div>
      ${e.location ? `<div class="entry-sub">${e.location}</div>` : ""}
      ${e.bullets ? `<ul class="entry-bullets">${e.bullets.map(b => `<li>${b}</li>`).join("")}</ul>` : ""}
    </div>
  `).join("");

  return section("Experience", entries);
}

function buildProjects(items) {
  if (!items.length) return "";

  const badgeClass = {
    "Complete":       "badge-complete",
    "Maintained":     "badge-maintained",
    "In Development": "badge-dev",
    "Planned":        "badge-planned",
  };

  const projects = items.map(p => {
    const stack = p.tech_stack && p.tech_stack[0] !== "TBD"
      ? `<p class="project-stack">${p.tech_stack.join(" · ")}</p>`
      : "";

    return `
      <div class="project">
        <div class="project-header">
          <span class="project-name">${p.name}</span>
          <span class="badge ${badgeClass[p.status] || "badge-planned"}">${p.status}</span>
        </div>
        ${stack}
        <p class="project-desc">${p.description}</p>
        ${projectLinks(p)}
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
          <span class="edu-date">${formatDateRange(e.start_date, e.end_date)}</span>
        </div>
        <p class="edu-degree">${e.degree}${e.location ? ` · ${e.location}` : ""}${e.gpa ? ` · CGPA ${e.gpa}` : ""}</p>
        ${note ? `<p class="edu-note">${note}</p>` : ""}
      </div>
    `;
  }).join("");

  return section("Education", entries);
}

function buildSkills(items) {
  if (!items.length) return "";

  const groups = Object.entries(groupByCategory(items)).map(([cat, names]) => `
    <div class="skill-group">
      <h3>${cat}</h3>
      <p>${names.join(", ")}</p>
    </div>
  `).join("");

  return section("Skills", groups);
}

function buildAwards(items) {
  if (!items.length) return "";

  const awards = items.map(a => `<li>${a.title}</li>`).join("");
  return section("Awards", `<ul class="awards-list">${awards}</ul>`);
}

function buildLanguages(items) {
  if (!items.length) return "";

  const langs = items
    .map(l => `<li>${l.name} <span class="lang-level">(${l.level})</span></li>`)
    .join("");

  return section("Languages", `<ul class="awards-list">${langs}</ul>`);
}

function section(title, content) {
  return `
    <section class="section">
      <h2>${title}</h2>
      ${content}
    </section>
  `;
}
