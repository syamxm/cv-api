-- =============================================================================
-- CV Database Schema + Seed Data
-- Ahmad Syamim | ahmadsyamim200@gmail.com | github.com/syamxm
--
-- To update any section: edit the INSERT values below and re-seed,
-- or run a direct UPDATE query against the running container.
-- =============================================================================


-- Drop tables if re-seeding from scratch (safe on fresh volume)
DROP TABLE IF EXISTS languages, awards, projects, skills, education, experience, profile CASCADE;


-- -----------------------------------------------------------------------------
-- PROFILE — one row, your identity at the top of the CV
-- -----------------------------------------------------------------------------
CREATE TABLE profile (
  id        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  title     TEXT NOT NULL,         -- headline shown under your name
  location  TEXT,
  email     TEXT,
  github    TEXT,
  summary   TEXT                   -- 2-3 sentence pitch
);

INSERT INTO profile (name, title, location, email, github, summary) VALUES (
  'Ahmad Syamim',
  'Computer Science Student · Junior Developer · DevOps Enthusiast',
  'Shah Alam, Selangor, Malaysia',
  'ahmadsyamim200@gmail.com',
  'https://github.com/syamxm',
  'Computer Science student at UiTM Shah Alam (graduating April 2027) with hands-on DevOps experience through a self-hosted production server running Docker, Tailscale, and automated security hardening. Builds open-source projects across Android, web, and backend. Dean''s List every semester. Available for a 14-week internship from 7 September to 11 December 2026.'
);


-- -----------------------------------------------------------------------------
-- EXPERIENCE — work history, newest first
-- sort_order controls display sequence
-- -----------------------------------------------------------------------------
CREATE TABLE experience (
  id          SERIAL PRIMARY KEY,
  company     TEXT NOT NULL,
  role        TEXT NOT NULL,
  location    TEXT,
  start_date  TEXT NOT NULL,        -- stored as readable string e.g. "March 2021"
  end_date    TEXT,                 -- NULL means current
  bullets     TEXT[],               -- array of bullet points describing responsibilities
  sort_order  INT DEFAULT 0,
  in_resume   BOOLEAN DEFAULT false -- include this entry on the compact resume
);

INSERT INTO experience (company, role, location, start_date, end_date, bullets, sort_order, in_resume) VALUES
(
  'Community Tuition Group',
  'Examination Area Coordinator',
  'Selangor',
  '2025',
  '2025',
  ARRAY[
    'Single-day paid engagement supervising an exam hall of 20+ students under minimal supervision',
    'Managed seating, distributed materials, and kept the room orderly and silent throughout'
  ],
  1,
  true
),
(
  'Subway',
  'Part-time Crew Member',
  'Eco Grandeur, Puncak Alam',
  'March 2021',
  'July 2021',
  ARRAY[
    'Balanced 15+ hours/week of part-time crew work alongside a full-time Foundation semester',
    'Coordinated with team members to keep daily operations running during peak hours'
  ],
  2,
  true
);


-- -----------------------------------------------------------------------------
-- EDUCATION — academic history, newest first
-- -----------------------------------------------------------------------------
CREATE TABLE education (
  id          SERIAL PRIMARY KEY,
  institution TEXT NOT NULL,
  degree      TEXT NOT NULL,
  field       TEXT,
  location    TEXT,
  start_date  TEXT NOT NULL,
  end_date    TEXT,                 -- "Expected April 2027" for ongoing
  gpa         TEXT,                 -- stored as text for flexibility e.g. "3.5 – 3.7"
  achievements TEXT[],
  sort_order  INT DEFAULT 0
);

INSERT INTO education (institution, degree, field, location, start_date, end_date, gpa, achievements, sort_order) VALUES
(
  'Universiti Teknologi MARA (UiTM)',
  'Bachelor of Computer Science',
  'Computer Science',
  'Shah Alam, Selangor',
  'March 2023',
  'Expected April 2027',
  '3.5 – 3.7',
  ARRAY[
    'Dean''s List every semester',
    'Consistent GPA range of 3.5 – 3.7 throughout degree',
    'Final Year Project: C-Aegis — Android parental monitoring app (Kotlin + Firebase)'
  ],
  1
),
(
  'Universiti Teknologi MARA (UiTM)',
  'Foundation in Engineering',
  'Engineering',
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
-- SKILLS — grouped by category for clean display
-- -----------------------------------------------------------------------------
CREATE TABLE skills (
  id          SERIAL PRIMARY KEY,
  category    TEXT NOT NULL,        -- e.g. "Languages", "Tools & Platforms"
  name        TEXT NOT NULL,
  sort_order  INT DEFAULT 0
);

INSERT INTO skills (category, name, sort_order) VALUES
-- Programming Languages
('Languages',         'JavaScript',   1),
('Languages',         'Python',       2),
('Languages',         'Java',         3),
('Languages',         'Kotlin',       4),
('Languages',         'C / C++',      5),
('Languages',         'PHP',          6),
('Languages',         'Dart',         7),
('Languages',         'Bash',         8),
('Languages',         'Fish',         9),
('Languages',         'HTML / CSS',   10),
('Languages',         'SQL',          11),

-- Tools, platforms, infra
('Tools & Platforms', 'Docker',               1),
('Tools & Platforms', 'Git / GitHub',          2),
('Tools & Platforms', 'Linux (Debian, PopOS, CachyOS)', 3),
('Tools & Platforms', 'Firebase',             4),
('Tools & Platforms', 'Flutter',              5),
('Tools & Platforms', 'Android (Kotlin + XML)', 6),
('Tools & Platforms', 'PostgreSQL',           7),
('Tools & Platforms', 'Express.js / Node.js', 8),
('Tools & Platforms', 'MongoDB',              9),
('Tools & Platforms', 'React',                10),
('Tools & Platforms', 'Nginx',                11),
('Tools & Platforms', 'Nmap',                 12),

-- Concepts and practices
('Concepts',          'Self-hosted Infrastructure',   1),
('Concepts',          'DevOps Fundamentals',          2),
('Concepts',          'REST API Design',              3),
('Concepts',          'Version Control & Branching',  4),
('Concepts',          'Network Security (UFW, Fail2ban, CrowdSec, Tailscale)', 5),
('Concepts',          'NoSQL',                        6),
('Concepts',          'MERN Stack',                   7),
('Concepts',          'JWT Authentication',           8);


-- -----------------------------------------------------------------------------
-- PROJECTS — personal and academic work
-- status: "Complete" | "Maintained" | "In Development" | "Planned"
-- -----------------------------------------------------------------------------
CREATE TABLE projects (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  description TEXT NOT NULL,         -- full description, shown on the CV
  tech_stack  TEXT[],               -- array of tech used
  status      TEXT DEFAULT 'Complete',
  github_url  TEXT,                 -- NULL if private or not on GitHub
  demo_url    TEXT,                 -- live deployment URL, NULL if none
  private_repo BOOLEAN DEFAULT false, -- show "Private repo" when no public github_url
  sort_order  INT DEFAULT 0,
  in_resume   BOOLEAN DEFAULT false, -- include on the compact resume
  resume_description TEXT            -- short one-line description for the resume
);

INSERT INTO projects (name, description, tech_stack, status, github_url, demo_url, private_repo, sort_order, in_resume, resume_description) VALUES
(
  'Debian Homeserver',
  'Built a production Debian homeserver running 5+ Dockerised services behind layered network security (UFW, Fail2ban, CrowdSec) with a Tailscale VPN for remote access — zero cloud cost. Hosts self-hosted tools including Vaultwarden for password management, kept current via automated unattended upgrades.',
  ARRAY['Debian Linux', 'Docker', 'UFW', 'Fail2ban', 'CrowdSec', 'Tailscale', 'Vaultwarden', 'Bash'],
  'Maintained',
  'https://github.com/syamxm',
  NULL,
  false,
  1,
  true,
  'Production Debian homeserver: 5+ Dockerised services, layered security (UFW/Fail2ban/CrowdSec), Tailscale VPN — zero cloud cost.'
),
(
  'C-Aegis',
  'Built an Android parental monitoring app (Final Year Project) with a bilateral dashboard (parent and child views), real-time geofence alerts via the Radar API, and app-usage enforcement using the Device Admin API and AccessibilityService to resist tampering.',
  ARRAY['Kotlin', 'XML', 'Firebase', 'Google Maps API', 'Radar API'],
  'In Development',
  NULL,
  NULL,
  true,
  2,
  true,
  'Android parental monitoring app: parent/child dashboard, real-time geofence alerts (Radar API), tamper-resistant usage enforcement (Device Admin + AccessibilityService).'
),
(
  'Family Monitor',
  'Flutter app for monitoring family members'' app usage and browser search history, helping guardians keep an eye on digital activity. Currently supports Android devices and Chrome-based browsers. Backend runs on a Debian virtual machine managed through virt-manager.',
  ARRAY['Flutter', 'Dart', 'Debian Linux', 'virt-manager'],
  'In Development',
  NULL,
  NULL,
  false,
  3,
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
  4,
  true,
  'Flutter timetable + push-notification app for UiTM students; FastAPI + Redis backend, Dockerised on a self-hosted Debian server.'
),
(
  'TaskFlow',
  'Built a full-stack task manager with per-project Kanban boards (Todo / In Progress / Done), JWT authentication, priorities, due dates, and progress tracking. MERN stack with Vite + Tailwind on the frontend, fully Dockerised behind an Nginx reverse proxy and self-hosted.',
  ARRAY['MongoDB', 'Express', 'React', 'Node.js', 'Vite', 'Tailwind CSS', 'Nginx', 'JWT', 'Docker'],
  'Complete',
  'https://github.com/syamxm/taskflow',
  NULL,
  false,
  5,
  true,
  'Full-stack MERN task manager: per-project Kanban, JWT auth, Nginx reverse proxy — Dockerised and self-hosted.'
),
(
  'cv-api',
  'Data-driven CV and resume served from a single PostgreSQL-backed REST API. A Node.js/Express backend exposes /api/cv; both the full CV and the one-page resume render entirely from the database, so a content update is just a SQL change. Containerised with Docker and deployed on a personal homeserver.',
  ARRAY['Node.js', 'Express', 'PostgreSQL', 'Docker', 'JavaScript'],
  'In Development',
  NULL,
  NULL,
  false,
  6,
  false,
  NULL
),
(
  'Enigma-Java',
  'CLI implementation of the World War II Enigma cipher machine in Java. Supports custom rotor and reflector configuration via external config files, allowing users to replicate historical encryption setups.',
  ARRAY['Java'],
  'Complete',
  'https://github.com/syamxm',
  NULL,
  false,
  9,
  false,
  NULL
);


-- -----------------------------------------------------------------------------
-- AWARDS — achievements and recognition
-- -----------------------------------------------------------------------------
CREATE TABLE awards (
  id          SERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  description TEXT,
  sort_order  INT DEFAULT 0
);

INSERT INTO awards (title, description, sort_order) VALUES
('Dean''s List — Every Semester',       'Maintained a GPA of 3.5–3.7 every semester throughout Bachelor''s degree at UiTM Shah Alam.', 1),
('SPM — 8A out of 9 Subjects',          'Achieved 8 distinctions in the Malaysian Certificate of Education (SPM).', 2),
('Foundation Top 10% — UiTM Dengkil',   'Ranked in the top 10% of the Engineering faculty cohort.', 3),
('Foundation 1st Place — 2nd Semester', 'Achieved 1st place in cohort rankings during the 2nd semester of Foundation in Engineering.', 4);


-- -----------------------------------------------------------------------------
-- LANGUAGES — spoken/written languages
-- -----------------------------------------------------------------------------
CREATE TABLE languages (
  id    SERIAL PRIMARY KEY,
  name  TEXT NOT NULL,
  level TEXT DEFAULT 'Fluent'
);

INSERT INTO languages (name, level) VALUES
('English', 'Fluent'),
('Malay',   'Native');
