// Builds the two-column resume PDF (Ahmad_Syamim_Resume.pdf) from data.json,
// reusing the site's resume design (public/resume.css). The ATS version is
// built separately from the same data.json via ats.typ (see package.json).
const fs = require("fs");
const path = require("path");
const puppeteer = require("puppeteer");

const data = require("./data.json");

const badgeClass = {
  "Complete": "badge-complete",
  "Maintained": "badge-maintained",
  "In Development": "badge-dev",
  "Planned": "badge-planned",
};

const section = (title, content) => `
  <section class="section">
    <h2>${title}</h2>
    ${content}
  </section>
`;

const header = (p) => `
  <header class="header">
    <div class="header-left">
      <h1>${p.name}</h1>
      <p class="title">${p.title}</p>
    </div>
    <div class="header-right">
      <span>${p.location}</span>
      <a href="tel:${p.phone}">${p.phone}</a>
      <a href="mailto:${p.email}">${p.email}</a>
      <a href="${p.github}">${p.github}</a>
      <a href="${p.linkedin}">${p.linkedin}</a>
    </div>
  </header>
`;

const projectLinks = (p) => {
  const github = p.github_url
    ? `<a class="project-link" href="${p.github_url}">↗ GitHub</a>`
    : p.private_repo
      ? `<span class="project-link project-private">Private repo</span>`
      : "";
  const demo = p.demo_url
    ? `<a class="project-link" href="${p.demo_url}">↗ Live demo</a>`
    : "";
  return github + demo;
};

const projects = (items) => section("Projects", items.map(p => `
  <div class="project">
    <div class="project-header">
      <span class="project-name">${p.name}</span>
      <span class="badge ${badgeClass[p.status] || "badge-planned"}">${p.status}</span>
    </div>
    <p class="project-stack">${p.stack.join(" · ")}</p>
    <p class="project-desc">${p.description}</p>
    ${projectLinks(p)}
  </div>
`).join(""));

const experience = (items) => section("Experience", items.map(e => `
  <div class="entry entry-compact">
    <div class="entry-header">
      <span class="entry-role">${e.role} — ${e.company}</span>
      <span class="entry-date">${e.dates}</span>
    </div>
    <div class="entry-sub">${e.location}</div>
    <ul class="entry-bullets">${e.bullets.map(b => `<li>${b}</li>`).join("")}</ul>
  </div>
`).join(""));

const education = (items) => section("Education", items.map(e => `
  <div class="edu-entry">
    <div class="edu-header">
      <span class="edu-place">${e.institution}</span>
      <span class="edu-date">${e.dates}</span>
    </div>
    <p class="edu-degree">${e.degree} · ${e.location}${e.gpa ? ` · CGPA ${e.gpa}` : ""}</p>
    <p class="edu-note">${e.notes.join(" · ")}</p>
  </div>
`).join(""));

const skills = (groups) => section("Skills", groups.map(g => `
  <div class="skill-group">
    <h3>${g.group}</h3>
    <p>${g.items.join(", ")}</p>
  </div>
`).join(""));

const languages = (items) => section("Spoken Languages", `
  <ul class="awards-list">
    ${items.map(l => `<li>${l.name} <span class="lang-level">(${l.level})</span></li>`).join("")}
  </ul>
`);

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Ahmad Syamim — Resume</title>
  <link rel="stylesheet" href="../public/resume.css" />
  <style>
    /* Clean text layer for the exported PDF: no fi/fl ligature glyphs. */
    * { font-variant-ligatures: none; }
  </style>
</head>
<body>
  <div class="page" id="resume">
    ${header(data.profile)}
    <section class="summary">${data.profile.summary}</section>
    <div class="body">
      <div class="col-left">
        ${projects(data.projects)}
        ${experience(data.experience)}
      </div>
      <div class="col-right">
        ${education(data.education)}
        ${skills(data.skills)}
        ${languages(data.languages)}
      </div>
    </div>
  </div>
</body>
</html>
`;

async function main() {
  const htmlPath = path.join(__dirname, "resume-a.html");
  fs.writeFileSync(htmlPath, html);

  const browser = await puppeteer.launch({ args: ["--no-sandbox"] });
  const page = await browser.newPage();
  await page.goto(`file://${htmlPath}`, { waitUntil: "networkidle0" });
  await page.pdf({
    path: path.join(__dirname, "Ahmad_Syamim_Resume.pdf"),
    printBackground: true,
    preferCSSPageSize: true,
  });
  await browser.close();
  console.log("Wrote Ahmad_Syamim_Resume.pdf");
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
