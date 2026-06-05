# cv-api

Personal CV platform — REST API + frontend serving resume data.

**Live:** https://cv.syamxm.com

## Stack

- Node.js + Express
- PostgreSQL
- Docker
- GitHub Actions (CI/CD)

## API

| Endpoint | Description |
|----------|-------------|
| `GET /api/cv` | Full CV (all sections) |
| `GET /api/cv/resume` | Curated one-page resume |
| `GET /api/cv/profile` | Profile |
| `GET /api/cv/experience` | Experience |
| `GET /api/cv/education` | Education |
| `GET /api/cv/skills` | Skills |
| `GET /api/cv/projects` | Projects |
| `GET /api/cv/awards` | Awards |
| `GET /api/cv/languages` | Languages |

## Local Setup

1. Create `.env` with:

```
DB_USER=
DB_PASSWORD=
DB_NAME=
```

2. Start:

```bash
docker compose up
```

## CI/CD

Push to `main` triggers auto-deploy via GitHub Actions (`.github/workflows/deploy.yml`).

**Pipeline:**
1. Checkout code
2. Connect to server via Tailscale
3. SSH into server — pull latest, rebuild Docker containers

**Required GitHub Secrets:**

| Secret | Description |
|--------|-------------|
| `DEPLOY_HOST` | Server hostname/IP |
| `DEPLOY_USER` | SSH username |
| `DEPLOY_SSH_KEY` | Private SSH key |
| `DEPLOY_PORT` | SSH port |
| `TS_AUTHKEY` | Tailscale auth key |

Set these under **GitHub repo → Settings → Secrets and variables → Actions**.
