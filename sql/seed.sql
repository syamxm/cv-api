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
  'Computer Science student at UiTM Shah Alam (graduating April 2027) with hands-on DevOps experience through a self-hosted production server running Docker, Tailscale, and automated security hardening. Builds open-source projects across Android, web, and backend. Dean''s List every semester. Fast learner who picks up new languages and tools on the job.'
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
  sort_order  INT DEFAULT 0
);

INSERT INTO experience (company, role, location, start_date, end_date, bullets, sort_order) VALUES (
  'Subway',
  'Part-time Crew Member',
  'Eco Grandeur, Puncak Alam',
  'March 2021',
  'July 2021',
  ARRAY[
    'Maintained high service standards under pressure during peak hours',
    'Coordinated with team members to ensure smooth daily operations',
    'Balanced part-time work alongside full-time academic commitments'
  ],
  1
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
  'May 2023',
  'Expected April 2027',
  '3.5 – 3.7',
  ARRAY[
    'Dean''s List every semester',
    'Consistent GPA range of 3.5 – 3.7 throughout degree'
  ],
  1
),
(
  'Universiti Teknologi MARA (UiTM)',
  'Foundation in Engineering',
  'Engineering',
  'Dengkil, Selangor',
  'August 2021',
  'February 2022',
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
  'January 2020',
  'January 2021',
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
('Languages',         'HTML / CSS',   9),
('Languages',         'SQL',          10),

-- Tools, platforms, infra
('Tools & Platforms', 'Docker',               1),
('Tools & Platforms', 'Git / GitHub',          2),
('Tools & Platforms', 'Linux (Debian, PopOS, CachyOS)', 3),
('Tools & Platforms', 'Firebase',             4),
('Tools & Platforms', 'Flutter',              5),
('Tools & Platforms', 'Android (Kotlin + XML)', 6),
('Tools & Platforms', 'PostgreSQL',           7),
('Tools & Platforms', 'Express.js / Node.js', 8),

-- Concepts and practices
('Concepts',          'Self-hosted Infrastructure',   1),
('Concepts',          'DevOps Fundamentals',          2),
('Concepts',          'REST API Design',              3),
('Concepts',          'Version Control & Branching',  4),
('Concepts',          'Network Security (UFW, Fail2ban, Tailscale)', 5),
('Concepts',          'NoSQL',                        6);


-- -----------------------------------------------------------------------------
-- PROJECTS — personal and academic work
-- status: "Complete" | "In Development" | "Planned"
-- -----------------------------------------------------------------------------
CREATE TABLE projects (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  description TEXT NOT NULL,
  tech_stack  TEXT[],               -- array of tech used
  status      TEXT DEFAULT 'Complete',
  github_url  TEXT,                 -- NULL if private or not on GitHub
  sort_order  INT DEFAULT 0
);

INSERT INTO projects (name, description, tech_stack, status, github_url, sort_order) VALUES
(
  'Debian Homeserver',
  'Production homeserver built from scratch on a laptop running Debian Trixie. Includes Docker containerisation, UFW firewall hardening, Fail2ban intrusion prevention, Tailscale VPN mesh networking, and automated unattended security upgrades. Foundation for all self-hosted projects.',
  ARRAY['Debian Linux', 'Docker', 'UFW', 'Fail2ban', 'Tailscale', 'Bash'],
  'In Development',
  'https://github.com/syamxm',
  1
),
(
  'C-Aegis',
  'Final Year Project. Android application for child safety featuring real-time geofencing, location tracking, and digital wellbeing monitoring tools. Built for parents to set boundaries and monitor screen activity.',
  ARRAY['Kotlin', 'XML', 'Firebase', 'Google Maps API', 'Radar API'],
  'In Development',
  NULL,
  2
),
(
  'TaskFlow',
  'Self-hosted project management tool designed to keep tasks and workflows clean and organised. RESTful API backend with a minimal frontend. Deployed on personal homeserver.',
  ARRAY['Node.js', 'Express', 'PostgreSQL', 'Docker', 'JavaScript'],
  'In Development',
  'https://github.com/syamxm/taskflow',
  3
),
(
  'Student Reminder System',
  'Mobile app to help university students manage their timetable and assignment deadlines. Features push reminders and a clean calendar interface.',
  ARRAY['Flutter', 'Dart', 'Firebase'],
  'In Development',
  NULL,
  4
),
(
  'CoffeeBot',
  'Web-based conversational chatbot specialising in coffee knowledge. Deployed online. Open source.',
  ARRAY['HTML', 'CSS', 'JavaScript', 'Python'],
  'Complete',
  'https://github.com/syamxm',
  5
),
(
  'Enigma-Java',
  'CLI implementation of the World War II Enigma cipher machine in Java. Supports custom rotor and reflector configuration via external config files, allowing users to replicate historical encryption setups.',
  ARRAY['Java'],
  'Complete',
  'https://github.com/syamxm',
  6
),
(
  'Debt Collector App',
  'Mobile application for tracking shared expenses and personal debts between friends.',
  ARRAY['TBD'],
  'Planned',
  NULL,
  7
),
(
  'Password Manager',
  'Self-hosted personal password manager with secure vault and browser integration.',
  ARRAY['TBD'],
  'Planned',
  NULL,
  8
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
