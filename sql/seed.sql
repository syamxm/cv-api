-- =============================================================================
-- CV database: schema + all the content for the site.
-- Ahmad Syamim | ahmadsyamim200@gmail.com | github.com/syamxm
--
-- Want to change something? Edit the INSERTs below and re-seed,
-- or just run an UPDATE straight against the running container.
-- =============================================================================


-- Start clean: drop these tables so a re-seed rebuilds them from scratch
DROP TABLE IF EXISTS languages, awards, projects, skills, education, experience, profile CASCADE;


-- -----------------------------------------------------------------------------
-- PROFILE — just you. One row holding the name, headline and blurb up top.
-- -----------------------------------------------------------------------------
CREATE TABLE profile (
  id        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  title     TEXT NOT NULL,         -- the line that sits under your name
  location  TEXT,
  email     TEXT,
  phone     TEXT,
  github    TEXT,
  summary   TEXT                   -- your short pitch, a sentence or two
);

INSERT INTO profile (name, title, location, email, phone, github, summary) VALUES (
  'Ahmad Syamim',
  'Computer Science Student · DevSecOps & Infrastructure',
  'Shah Alam, Selangor, Malaysia',
  'ahmadsyamim200@gmail.com',
  '+60 17 796 7290',
  'https://github.com/syamxm',
  'Computer Science (Hons) student at UiTM Shah Alam, focused on DevSecOps and self-hosted infrastructure. Available for a 14-week internship from 7 September to 11 December 2026.'
);


-- -----------------------------------------------------------------------------
-- EXPERIENCE — where you've worked, newest first.
-- sort_order decides what shows up top
-- -----------------------------------------------------------------------------
CREATE TABLE experience (
  id          SERIAL PRIMARY KEY,
  company     TEXT NOT NULL,
  role        TEXT NOT NULL,
  location    TEXT,
  start_date  TEXT NOT NULL,        -- plain text so it reads nicely, e.g. "March 2021"
  end_date    TEXT,                 -- leave NULL if you're still there
  bullets     TEXT[],               -- the points listed under each role
  resume_bullet TEXT,               -- one compressed bullet for the resume; falls back to bullets[0]
  sort_order  INT DEFAULT 0,
  in_resume   BOOLEAN DEFAULT false -- show this on the one-page resume
);

INSERT INTO experience (company, role, location, start_date, end_date, bullets, resume_bullet, sort_order, in_resume) VALUES
(
  'Community Tuition Group',
  'Examination Area Coordinator',
  'Selangor',
  'May 2025',
  'May 2025',
  ARRAY[
    'Supervised an exam hall of 20+ students independently, managed seating, distributed materials, and maintained order throughout'
  ],
  NULL,
  1,
  true
),
(
  'Subway',
  'Part-time Crew Member',
  'Eco Grandeur, Puncak Alam',
  'April 2021',
  'July 2021',
  ARRAY[
    'Handled high-volume peak operations from opening to closing with consistent accuracy and speed',
    'Coordinated with team members to keep daily operations running during peak hours'
  ],
  'Handled high-volume peak operations from open to close, coordinating with the team to keep service running.',
  2,
  true
);


-- -----------------------------------------------------------------------------
-- EDUCATION — schools and degrees, newest first.
-- -----------------------------------------------------------------------------
CREATE TABLE education (
  id          SERIAL PRIMARY KEY,
  institution TEXT NOT NULL,
  degree      TEXT NOT NULL,
  field       TEXT,
  location    TEXT,
  start_date  TEXT NOT NULL,
  end_date    TEXT,                 -- use "Expected ..." while it's still ongoing
  gpa         TEXT,                 
  achievements TEXT[],
  sort_order  INT DEFAULT 0
);

INSERT INTO education (institution, degree, field, location, start_date, end_date, gpa, achievements, sort_order) VALUES
(
  'Universiti Teknologi MARA (UiTM)',
  'Bachelor of Computer Science (Honours)',
  NULL,
  'Shah Alam, Selangor',
  'October 2023',
  'Expected March 2027',
  '3.66',
  ARRAY[
    'Dean''s List every semester',
    'Final Year Project: C-Aegis, Android parental monitoring app'
  ],
  1
),
(
  'Universiti Teknologi MARA (UiTM)',
  'Foundation in Engineering',
  NULL,
  'Dengkil, Selangor',
  'August 2021',
  'July 2022',
  NULL,
  ARRAY[
    'Top 10% of faculty cohort',
    'Ranked 1st in cohort during 2nd semester'
  ],
  2
),
(
  'SMK Saujana Utama',
  'SPM (Malaysian Certificate of Education)',
  NULL,
  'Saujana Utama, Selangor',
  '2020',
  '2020',
  NULL,
  ARRAY[
    'Achieved 8A out of 9 subjects'
  ],
  3
);


-- -----------------------------------------------------------------------------
-- SKILLS — grouped by category so they sit in neat columns.
-- -----------------------------------------------------------------------------
CREATE TABLE skills (
  id             SERIAL PRIMARY KEY,
  category       TEXT NOT NULL,        -- the column header, e.g. "Infrastructure & DevOps"
  category_order INT DEFAULT 0,        -- which category column comes first
  name           TEXT NOT NULL,
  sort_order     INT DEFAULT 0         -- order within the category
);

INSERT INTO skills (category, category_order, name, sort_order) VALUES
-- Infrastructure & DevOps — deployable now, leads the section
('Infrastructure & DevOps', 1, 'Docker',                                                1),
('Infrastructure & DevOps', 1, 'Linux',                                                 2),
('Infrastructure & DevOps', 1, 'CI/CD (GitHub Actions)',                                3),
('Infrastructure & DevOps', 1, 'Self-hosted Infrastructure',                            4),
('Infrastructure & DevOps', 1, 'Network Security (UFW, Fail2ban, CrowdSec, Tailscale)', 5),
('Infrastructure & DevOps', 1, 'Nginx',                                                 6),
('Infrastructure & DevOps', 1, 'Cloudflare',                                            7),
('Infrastructure & DevOps', 1, 'Git / GitHub',                                          8),

-- Security & DevSecOps
('Security & DevSecOps', 2, 'Nmap',                  1),
('Security & DevSecOps', 2, 'SAST (Semgrep)',        2),
('Security & DevSecOps', 2, 'DAST (OWASP ZAP)',      3),
('Security & DevSecOps', 2, 'Trivy (SCA/Image/IaC)', 4),
('Security & DevSecOps', 2, 'Gitleaks',              5),
('Security & DevSecOps', 2, 'Hadolint',              6),
('Security & DevSecOps', 2, 'SBOM (CycloneDX)',      7),
('Security & DevSecOps', 2, 'Dependabot',            8),

-- Frameworks & Tools
('Frameworks & Tools', 3, 'Express.js / Node.js', 1),
('Frameworks & Tools', 3, 'FastAPI',              2),
('Frameworks & Tools', 3, 'React',                3),
('Frameworks & Tools', 3, 'PostgreSQL',           4),
('Frameworks & Tools', 3, 'MongoDB',              5),
('Frameworks & Tools', 3, 'Flutter',              6),
('Frameworks & Tools', 3, 'Android',              7),
('Frameworks & Tools', 3, 'Firebase',             8),
('Frameworks & Tools', 3, 'REST API Design',      9),
('Frameworks & Tools', 3, 'JWT Authentication',  10),
('Frameworks & Tools', 3, 'MERN Stack',          11),

-- Languages
('Languages', 4, 'JavaScript', 1),
('Languages', 4, 'Python',     2),
('Languages', 4, 'Java',       3),
('Languages', 4, 'Kotlin',     4),
('Languages', 4, 'Dart',       5),
('Languages', 4, 'SQL',        6),
('Languages', 4, 'Bash',       7),
('Languages', 4, 'HTML / CSS', 8);


-- -----------------------------------------------------------------------------
-- PROJECTS — the things you've built, personal and uni.
-- status: "Complete" | "Maintained" | "In Development" | "Planned"
-- -----------------------------------------------------------------------------
CREATE TABLE projects (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  description TEXT NOT NULL,         -- the full write-up shown on the CV
  tech_stack  TEXT[],               -- what you built it with
  status      TEXT DEFAULT 'Complete',
  github_url  TEXT,                 -- leave NULL if it's private or not on GitHub
  demo_url    TEXT,                 -- live link, if it's deployed somewhere
  private_repo BOOLEAN DEFAULT false, -- shows the "Private repo" tag when there's no public link
  sort_order  INT DEFAULT 0,
  in_resume   BOOLEAN DEFAULT false, -- show this on the one-page resume
  resume_description TEXT            -- a tighter one-liner for the resume
);

INSERT INTO projects (name, description, tech_stack, status, github_url, demo_url, private_repo, sort_order, in_resume, resume_description) VALUES
(
  'Debian Homeserver',
  'Self-hosted Debian homeserver running 8+ Dockerised services behind layered network security (UFW, Fail2ban, CrowdSec), a Tailscale VPN for private remote access, and a Cloudflare Tunnel publishing select services on a custom domain with zero open inbound ports. A hardened Nginx reverse proxy fronts every service with per-domain routing, security headers (HSTS, CSP, referrer and permissions policies), real-IP detection, and WebSocket support. Hosts tools including Vaultwarden for password management, kept current with automated unattended upgrades.',
  ARRAY['Debian Linux', 'Docker', 'Nginx', 'UFW', 'Fail2ban', 'CrowdSec', 'Tailscale', 'Cloudflare', 'Vaultwarden', 'Bash'],
  'Maintained',
  'https://github.com/syamxm',
  NULL,
  false,
  1,
  true,
  'Self-hosted Debian server running 8+ Dockerised services behind a hardened Nginx reverse proxy and layered network security, with private VPN access and a Cloudflare Tunnel exposing zero inbound ports.'
),
(
  'Final Year Project - C-Aegis',
  'Built an Android parental monitoring app (Final Year Project) focused on location and on-device control: a parent/child dashboard, real-time geofence alerts via the Radar API, and app-usage enforcement using the Device Admin API and AccessibilityService to resist tampering.',
  ARRAY['Kotlin', 'XML', 'Firebase', 'Google Maps API', 'Radar API'],
  'In Development',
  NULL,
  NULL,
  true,
  4,
  true,
  'Android parental monitoring app (Final Year Project): parent/child dashboard, real-time geofence alerts, and tamper-resistant app-usage enforcement.'
),
(
  'Family Monitor',
  'Flutter app that gives guardians visibility into family members'' web activity: browsing and search history across Chrome-based browsers. Backend runs on a self-hosted Debian virtual machine managed through virt-manager.',
  ARRAY['Flutter', 'Dart', 'Debian Linux', 'virt-manager'],
  'In Development',
  NULL,
  NULL,
  true,
  6,
  false,
  NULL
),
(
  'Student Reminder System',
  'Built a Flutter app that lets UiTM students manage class timetables and receive local push notifications for deadlines, backed by a FastAPI + Redis API with rate-limited login, deployed in Docker on a self-hosted Debian server and served over a CDN.',
  ARRAY['Flutter', 'Dart', 'Python', 'FastAPI', 'Redis', 'Docker'],
  'Maintained',
  'https://github.com/syamxm/student_reminder_system',
  NULL,
  false,
  5,
  true,
  'Flutter timetable and push-notification app for UiTM students, backed by a Dockerised FastAPI service.'
),
(
  'TaskFlow',
  'Self-hosted MERN task manager with a security-gated CI/CD pipeline. Reusable GitHub Actions workflows run 8 automated scanners that block deploy on HIGH or CRITICAL findings: Gitleaks for secrets, Semgrep for SAST, npm audit and Trivy for dependencies, Hadolint and Trivy config for Dockerfiles and IaC, Trivy image scanning with CycloneDX SBOMs, and an OWASP ZAP DAST baseline. Application security covers JWT (HS256), httpOnly and SameSite cookies, bcrypt password hashing, AES-256-GCM encryption of GitHub tokens at rest, MongoDB-backed per-route rate limiting, input validation, and owner-scoped authorization. Containers run non-root on Alpine across isolated Docker networks behind a hardened Nginx reverse proxy, with Dependabot keeping dependencies and base images current. The app provides per-project Kanban boards, priorities, due dates, and GitHub repo integration.',
  ARRAY['MongoDB', 'Express', 'React', 'Node.js', 'Docker', 'Nginx', 'GitHub Actions', 'Semgrep', 'Trivy', 'Gitleaks', 'Hadolint', 'OWASP ZAP', 'JWT', 'AES-256-GCM'],
  'Maintained',
  'https://github.com/syamxm/taskflow',
  'https://taskflow.syamxm.com',
  false,
  2,
  true,
  'MERN task manager with a security-gated CI/CD pipeline: 8 automated scanners block deploy on HIGH or CRITICAL findings. Hardened non-root containers, per-route rate limiting, and JWT auth.'
),
(
  'cv-api',
  'Built a data-driven CV and one-page resume served from a single PostgreSQL-backed REST API (Node.js/Express), so a content update is just a SQL change. Set up a GitHub Actions CI/CD pipeline that auto-deploys on push to main, connecting to the homeserver over Tailscale and rebuilding the Docker stack via SSH. Published on a custom domain (cv.syamxm.com) through a Cloudflare Tunnel, with no inbound ports opened on the server.',
  ARRAY['Node.js', 'Express', 'PostgreSQL', 'Docker', 'GitHub Actions', 'Tailscale', 'Cloudflare', 'CI/CD'],
  'Maintained',
  'https://github.com/syamxm/cv-api',
  'https://cv.syamxm.com',
  false,
  3,
  true,
  'Data-driven CV and one-page resume served from a single REST API, auto-deployed by a GitHub Actions pipeline to a self-hosted server and published through a Cloudflare Tunnel.'
),
(
  'Enigma-Java',
  'CLI implementation of the World War II Enigma cipher machine in Java. Supports custom rotor and reflector configuration via external config files, allowing users to replicate historical encryption setups.',
  ARRAY['Java'],
  'Complete',
  'https://github.com/syamxm/enigma-java',
  NULL,
  false,
  7,
  false,
  NULL
);


-- -----------------------------------------------------------------------------
-- AWARDS — wins worth showing off.
-- -----------------------------------------------------------------------------
CREATE TABLE awards (
  id          SERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  description TEXT,
  sort_order  INT DEFAULT 0
);

-- Awards intentionally empty: these honors live under Education (with dates and
-- context), so a separate Awards section would just repeat them. The resume and CV
-- hide the section when there are no rows.


-- -----------------------------------------------------------------------------
-- LANGUAGES — the ones you speak.
-- -----------------------------------------------------------------------------
CREATE TABLE languages (
  id    SERIAL PRIMARY KEY,
  name  TEXT NOT NULL,
  level TEXT DEFAULT 'Fluent'
);

INSERT INTO languages (name, level) VALUES
('English', 'Fluent'),
('Malay',   'Native');
