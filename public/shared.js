async function fetchJSON(url) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`API returned ${res.status}`);
  return res.json();
}

async function mountOnLoad(url, containerId, build, failMsg) {
  try {
    build(await fetchJSON(url));
    document.getElementById("loading").style.display = "none";
    document.getElementById(containerId).classList.remove("hidden");
  } catch (err) {
    document.getElementById("loading").textContent = failMsg;
    console.error(err);
  }
}

function formatDateRange(start, end) {
  if (start === end) return start;
  return `${start} – ${end || "Present"}`;
}

function groupByCategory(items) {
  return items.reduce((acc, s) => {
    (acc[s.category] ||= []).push(s.name);
    return acc;
  }, {});
}

function projectLinks(p) {
  const github = p.github_url
    ? `<a class="project-link" href="${p.github_url}" target="_blank">↗ GitHub</a>`
    : p.private_repo
      ? `<span class="project-link project-private">Private repo</span>`
      : "";

  const demo = p.demo_url
    ? `<a class="project-link" href="${p.demo_url}" target="_blank">↗ Live demo</a>`
    : "";

  return github + demo;
}

function exportPDF() {
  window.print();
}

// Secret theme: type "vibe-code" anywhere to toggle Catppuccin Mocha.
(function secretTheme() {
  const CODE = "vibe-code";
  const KEY = "cv-theme";

  function apply(on) {
    document.body.classList.toggle("theme-mocha", on);
  }

  apply(localStorage.getItem(KEY) === "mocha");

  let buffer = "";
  document.addEventListener("keydown", e => {
    const tag = document.activeElement?.tagName;
    if (tag === "INPUT" || tag === "TEXTAREA") return;
    if (e.key.length !== 1) return;

    buffer = (buffer + e.key.toLowerCase()).slice(-CODE.length);
    if (buffer === CODE) {
      const on = !document.body.classList.contains("theme-mocha");
      apply(on);
      localStorage.setItem(KEY, on ? "mocha" : "light");
      buffer = "";
    }
  });
})();
