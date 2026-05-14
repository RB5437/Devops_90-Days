# 🐳 Multi-Stage Docker Builds, Monitoring & Project — Django + Nginx + MySQL

![Docker](https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png)

> **90-Day DevOps Challenge | Day 30 | 12 May 2026**
> Trainer: Shubham Londhe [@TrainWithShubham](https://www.youtube.com/@TrainWithShubham)
> Practiced on: AWS EC2 (Ubuntu)

---

## ✅ What I Did Today

| # | Task | Status |
|---|------|--------|
| 1 | Multi-Stage Docker Build — reduced Flask image from 1.6GB → 212MB | ✅ Done |
| 2 | Monitoring & Logging — `docker logs`, `docker attach`, `nohup` | ✅ Done |
| 3 | Project 1 — Django + Nginx + MySQL app with Docker Compose | ✅ Done |
| 4 | Fixed `.dockerignore` — permission denied error on mysql-data | ✅ Done |
| 5 | App running live on browser — `http://44.203.201.83` | ✅ Done |

---

## 🏗️ Multi-Stage Docker Builds

### Why Multi-Stage?

```
Normal build:
  FROM python:3.10        → 1.6 GB base image
  + pip install           → adds more layers
  = Final image: ~1.6 GB  ❌ Too heavy for production!

Multi-stage build:
  Stage 1 (builder): python:3.10 → install deps  → 994 MB (throw away)
  Stage 2 (final):   python:3.10-slim → copy only needed files → 212 MB ✅
```

### Size comparison — today's result:

| Image | Base | Final Size | Reduction |
|-------|------|-----------|-----------|
| Regular Flask build | `python:3.10` (1.6GB) | ~1.6 GB | — |
| Multi-stage build | `python:3.10-slim` (185MB) | **212 MB** | **87% smaller!** |

### Multi-Stage Dockerfile (Flask app):

```dockerfile
# ── Stage 1: Builder (heavy — install everything) ──
FROM python:3.10 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

# ── Stage 2: Final (slim — copy only what's needed) ──
FROM python:3.10-slim

WORKDIR /app

# Copy only installed packages from Stage 1
COPY --from=builder /usr/local/lib/python3.10/site-packages/ \
                    /usr/local/lib/python3.10/site-packages/

# Copy application code
COPY . .

ENTRYPOINT ["python", "run.py"]
```

### How `COPY --from=builder` works:

```
Stage 1 (builder):                Stage 2 (slim):
┌─────────────────────┐           ┌──────────────────────┐
│ python:3.10 (1.6GB) │           │ python:3.10-slim      │
│ + requirements.txt  │──copy──▶  │ + site-packages/ ✅  │
│ + pip install all   │  only     │ + app code ✅         │
│ (994MB build tools) │  needed   │ = 212MB ONLY ✅       │
└─────────────────────┘           └──────────────────────┘
     DISCARDED ❌                      SHIPPED ✅
```

---

## 📊 Monitoring & Logging in Docker

### Docker Logs:

```bash
docker logs <container_id>          # View all logs
docker logs -f <container_id>       # Follow logs live (like tail -f)
docker logs --tail 50 <id>          # Last 50 lines only
```

### Docker Attach (live terminal):

```bash
docker attach <container_id>        # Attach to running container's stdout
nohup docker attach <id> &          # Attach in background, save to nohup.out
cat nohup.out                       # Read saved logs
```

### What I saw in logs today:

```
223.185.39.192 - - [12/May/2026 07:21:55] "GET / HTTP/1.1" 200 -
223.185.39.192 - - [12/May/2026 07:27:45] "GET / HTTP/1.1" 200 -
223.185.39.192 - - [12/May/2026 07:28:20] "GET /error/ HTTP/1.1" 404 -
223.185.39.192 - - [12/May/2026 07:28:32] "GET /health HTTP/1.1" 200 -
```

---

## 🚀 Project 1 — Django + Nginx + MySQL App

### Architecture:

```
Browser (User)
      ↓  http://44.203.201.83 (Port 80)
┌─────────────────────────────────────────────────┐
│              notes-app network                  │
│                                                 │
│  ┌──────────┐    Reverse    ┌──────────────┐    │
│  │  Nginx   │──── Proxy ───▶│   Django     │    │
│  │ Port: 80 │               │  Port: 8000  │    │
│  │(nginx_   │               │ (django_cont)│    │
│  │  cont)   │               └──────┬───────┘    │
│  └──────────┘                      │ DB          │
│                              ┌─────▼──────┐     │
│                              │   MySQL    │     │
│                              │ Port: 3306 │     │
│                              │ (db_cont)  │     │
│                              └────────────┘     │
└─────────────────────────────────────────────────┘
```

### App running on browser:
> `http://44.203.201.83` — **My Notes App** — "This is amazing" ✅

### docker-compose.yml (final working):

```yaml
version: "3.9"

services:
  nginx:
    build:
      context: ./nginx
    container_name: nginx_cont
    ports:
      - "80:80"
    networks:
      - notes-app
    restart: always
    depends_on:
      - django

  db:
    container_name: db_cont
    image: mysql
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: test_db
    volumes:
      - ./mysql-data:/var/lib/mysql
    networks:
      - notes-app
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 60s

  django:
    build:
      context: .
    container_name: django_cont
    command: sh -c "python manage.py migrate --noinput && gunicorn notesapp.wsgi --bind 0.0.0.0:8000"
    ports:
      - "8000:8000"
    env_file:
      - .env
    restart: always
    depends_on:
      - db
    networks:
      - notes-app
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8000/admin || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 60s

networks:
  notes-app:
```

### Nginx config (reverse proxy):

```nginx
upstream django {
    server django_cont:8000;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://django_cont:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Errors fixed today:

| Error | Cause | Fix |
|-------|-------|-----|
| `permission denied: open mysql-data/#innodb_redo` | MySQL data dir included in build context | Added `mysql-data/` to `.dockerignore` |
| `version is obsolete` | Old compose format | Can safely ignore or remove `version:` line |

---

## 📅 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27 | 9 May 2026 | Virtualization vs Containerization, Docker Architecture | ✅ Done |
| Day 28 | 10 May 2026 | Install Docker, Dockerfile, Java App, Flask App | ✅ Done |
| Day 29 | 11 May 2026 | Docker Networking, Volumes, Compose, Registry | ✅ Done |
| Day 30 | 12 May 2026 | Multi-stage Builds, Monitoring, Django+Nginx+MySQL Project | ✅ Done |
| Day 31 | 13 May 2026 | Mini Project 1 — Push to Docker Hub | ⬜ Pending |
| Day 32 | 14 May 2026 |Docker Complete Revision — Images, Containers, Networks, Volumes, Compose, Scout  | ⬜ Pending |

---

## 🔗 Resources

| Resource | Link |
|----------|------|
| 🎥 Docker One Shot — Shubham Londhe | [YouTube](https://www.youtube.com/watch?v=9bSbNNH4Nqw) |
| 📺 TrainWithShubham Channel | [YouTube](https://www.youtube.com/@TrainWithShubham) |
| 💻 django-notes-app Repo | [GitHub](https://github.com/RB5437/django-notes-app) |
| 📖 Docker Multi-stage Docs | [docs.docker.com](https://docs.docker.com/build/building/multi-stage/) |

---

## 👤 About Me

**Ritik Bawane**
- 🎯 90-Day DevOps Challenge — Day 30/90
- 💼 Ex-Kyndryl | 3.4 Years Experience | Technical Engineer
- 🏅 AWS Solutions Architect Associate Certified
- 🏅 RHCSA Certified
- 🔗 [GitHub](https://github.com/RB5437)

---

*⭐ If this helped you, give the repo a star!*

*Progress: Linux ✅ | Networking ✅ | Shell Scripting ✅ | Git/GitHub ✅ | AWS ✅ | Docker 🔄 | Jenkins ⬜ | Terraform ⬜ | Kubernetes ⬜*
