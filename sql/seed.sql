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
  'Computer Science Student · Junior Developer · DevOps Enthusiast',
  'Shah Alam, Selangor, Malaysia',
  'ahmadsyamim200@gmail.com',
  '+60 0177967290',
  'https://github.com/syamxm',
  'Computer Science student at UiTM Shah Alam with hands-on DevOps experience through a self-hosted production server running Docker, Tailscale, and automated security hardening. Builds open-source projects across Android, web, and backend. Available for a 14-week internship from 7th September to 11th December 2026.'
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
  sort_order  INT DEFAULT 0,
  in_resume   BOOLEAN DEFAULT false -- show this on the one-page resume
);

INSERT INTO experience (company, role, location, start_date, end_date, bullets, sort_order, in_resume) VALUES
(
  'Community Tuition Group',
  'Examination Area Coordinator',
  'Selangor',
  'May 2025',
  'May 2025',
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
  'April 2021',
  'July 2021',
  ARRAY[
    'Balanced 15+ hours/week of part-time crew work alongside a full-time Foundation semester',
    'Coordinated with team members to keep daily operations running during peak hours'
  ],
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
  'March 2023',
  'Expected March 2027',
  '3.6',
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

-- Frameworks & Tools
('Frameworks & Tools', 2, 'Express.js / Node.js', 1),
('Frameworks & Tools', 2, 'FastAPI',              2),
('Frameworks & Tools', 2, 'React',                3),
('Frameworks & Tools', 2, 'PostgreSQL',           4),
('Frameworks & Tools', 2, 'MongoDB',              5),
('Frameworks & Tools', 2, 'Flutter',              6),
('Frameworks & Tools', 2, 'Android',              7),
('Frameworks & Tools', 2, 'Firebase',             8),
('Frameworks & Tools', 2, 'REST API Design',      9),
('Frameworks & Tools', 2, 'JWT Authentication',  10),
('Frameworks & Tools', 2, 'MERN Stack',          11),

-- Languages
('Languages', 3, 'JavaScript', 1),
('Languages', 3, 'Python',     2),
('Languages', 3, 'Java',       3),
('Languages', 3, 'Kotlin',     4),
('Languages', 3, 'Dart',       5),
('Languages', 3, 'SQL',        6),
('Languages', 3, 'Bash',       7),
('Languages', 3, 'HTML / CSS', 8);


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
  'Built a self-hosted Debian homeserver running 5+ Dockerised services behind layered network security (UFW, Fail2ban, CrowdSec), with a Tailscale VPN for private remote access and a Cloudflare Tunnel publishing select services on a custom domain — zero open inbound ports, zero cloud cost. Hosts self-hosted tools including Vaultwarden for password management, kept current via automated unattended upgrades.',
  ARRAY['Debian Linux', 'Docker', 'UFW', 'Fail2ban', 'CrowdSec', 'Tailscale', 'Cloudflare', 'Vaultwarden', 'Bash'],
  'Maintained',
  'https://github.com/syamxm',
  NULL,
  false,
  1,
  true,
  'Self-hosted Debian server: 5+ Dockerised services, layered security (UFW/Fail2ban/CrowdSec), Tailscale + Cloudflare Tunnel, zero cloud cost.'
),
(
  'Final Year Project - C-Aegis',
  'Built an Android parental monitoring app (Final Year Project) focused on location and on-device control: a parent/child dashboard, real-time geofence alerts via the Radar API, and app-usage enforcement using the Device Admin API and AccessibilityService to resist tampering.',
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
  'Flutter app that gives guardians visibility into family members'' web activity: browsing and search history across Chrome-based browsers. Backend runs on a self-hosted Debian virtual machine managed through virt-manager.',
  ARRAY['Flutter', 'Dart', 'Debian Linux', 'virt-manager'],
  'In Development',
  NULL,
  NULL,
  true,
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
  'https://taskflow.syamxm.com',
  false,
  5,
  true,
  'Full-stack MERN task manager: per-project Kanban, JWT auth, Nginx reverse proxy, Dockerised and self-hosted.'
),
(
  'cv-api',
  'Built a data-driven CV and one-page resume served from a single PostgreSQL-backed REST API (Node.js/Express), so a content update is just a SQL change. Set up a GitHub Actions CI/CD pipeline that auto-deploys on push to main, connecting to the homeserver over Tailscale and rebuilding the Docker stack via SSH. Published on a custom domain (cv.syamxm.com) through a Cloudflare Tunnel, with no inbound ports opened on the server.',
  ARRAY['Node.js', 'Express', 'PostgreSQL', 'Docker', 'GitHub Actions', 'Tailscale', 'Cloudflare', 'CI/CD'],
  'Maintained',
  'https://github.com/syamxm/cv-api',
  'https://cv.syamxm.com',
  false,
  6,
  true,
  'Data-driven CV + resume from a PostgreSQL REST API (Node/Express); GitHub Actions CI/CD over Tailscale + SSH, public via a Cloudflare Tunnel.'
),
(
  'Enigma-Java',
  'CLI implementation of the World War II Enigma cipher machine in Java. Supports custom rotor and reflector configuration via external config files, allowing users to replicate historical encryption setups.',
  ARRAY['Java'],
  'Complete',
  'https://github.com/syamxm/enigma-java',
  NULL,
  false,
  9,
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

INSERT INTO awards (title, description, sort_order) VALUES
('Dean''s List, Every Semester',       'Maintained a CGPA of 3.6 every semester throughout Bachelor''s degree at UiTM Shah Alam.', 1),
('SPM, 8A out of 9 Subjects',          'Achieved 8 distinctions in the Malaysian Certificate of Education (SPM).', 2),
('Foundation Top 10%, UiTM Dengkil',   'Ranked in the top 10% of the Engineering faculty cohort.', 3),
('Foundation 1st Place, 2nd Semester', 'Achieved 1st place in cohort rankings during the 2nd semester of Foundation in Engineering.', 4);


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
