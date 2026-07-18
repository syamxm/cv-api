document.addEventListener("DOMContentLoaded", () =>
  mountOnLoad("/api/cv", "cv", buildCV, "Failed to load CV. Is the API running?")
);

function buildCV(data) {
  document.getElementById("cv").innerHTML = `
    ${buildHeader(data.profile)}
    ${buildSummary(data.profile)}
    ${buildProjects(data.projects)}
    ${buildExperience(data.experience)}
    ${buildEducation(data.education)}
    ${buildSkills(data.skills)}
    ${buildAwards(data.awards)}
    ${buildLanguages(data.languages)}
    ${buildTraits(data.traits)}
  `;
}

function buildHeader(p) {
  return `
    <header class="cv-header">
      <div class="cv-header-main">
        <h1>${p.name}</h1>
        <p class="cv-title">${p.title}</p>
        <div class="cv-contacts">
          <span>${p.location}</span>
          ${p.address ? `<span>${p.address}</span>` : ""}
          <a href="tel:${p.phone}">${p.phone}</a>
          <a href="mailto:${p.email}">${p.email}</a>
          <a href="${p.github}" target="_blank">${p.github}</a>
          ${p.linkedin ? `<a href="${p.linkedin}" target="_blank">${p.linkedin}</a>` : ""}
        </div>
      </div>
      <img class="cv-photo" src="photo.png" alt="Photograph of ${p.name}" />
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
        <span class="entry-date">${formatDateRange(e.start_date, e.end_date)}</span>
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
        <span class="entry-date">${formatDateRange(e.start_date, e.end_date)}</span>
      </div>
      <div class="entry-sub">${e.degree}${e.field ? ` in ${e.field}` : ""}${e.location ? ` · ${e.location}` : ""}</div>
      ${e.gpa ? `<span class="entry-gpa">CGPA ${e.gpa}</span>` : ""}
      ${e.achievements ? `<ul>${e.achievements.map(a => `<li>${a}</li>`).join("")}</ul>` : ""}
    </div>
  `).join("");

  return section("Education", entries);
}

function buildSkills(items) {
  if (!items.length) return "";

  const grid = Object.entries(groupByCategory(items)).map(([cat, names]) => `
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

  const statusClass = {
    "Complete":       "status-complete",
    "Maintained":     "status-maintained",
    "In Development": "status-development",
    "Planned":        "status-planned",
  };

  const projects = items.map(p => {
    const stack = p.tech_stack && p.tech_stack[0] !== "TBD"
      ? `<div class="project-stack">${p.tech_stack.join(" · ")}</div>`
      : "";

    return `
      <div class="project">
        <div class="project-header">
          <span class="project-name">${p.name}</span>
          <span class="status-badge ${statusClass[p.status] || "status-planned"}">${p.status}</span>
        </div>
        ${stack}
        <p class="project-desc">${p.description}</p>
        ${projectLinks(p)}
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

  return section("Communication Languages", `<div class="languages-list">${langs}</div>`);
}

function buildTraits(items) {
  if (!items || !items.length) return "";

  const traits = items
    .map(t => `<span class="lang-item">${t.name}</span>`)
    .join("");

  return section("Personal Attributes", `<div class="languages-list">${traits}</div>`);
}

function section(title, content) {
  return `
    <section class="cv-section">
      <h2>${title}</h2>
      ${content}
    </section>
  `;
}
