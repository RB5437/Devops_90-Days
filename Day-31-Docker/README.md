# 🐳 Day 31 — Student Grade Tracker (Full Stack Docker Project)

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

> **Live on AWS EC2:** `http://54.226.172.26` ✅  
> **Stack:** React-style Frontend (Nginx) + Flask Backend + MySQL Database  
> **All running inside Docker containers on AWS Free Tier**

---

## ✅ What I Learned & Practiced Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Docker Scout — Image Security Scanning (CVE) | ✅ Done |
| 2 | Docker Init — Auto-generate Dockerfiles | ✅ Done |
| 3 | Multi-stage Dockerfile — Backend (Python builder → slim runtime) | ✅ Done |
| 4 | Multi-stage Dockerfile — Frontend (Node builder → Nginx runtime) | ✅ Done |
| 5 | Docker Compose — 3-service orchestration | ✅ Done |
| 6 | Docker Volumes — MySQL data persistence (`mysql-data`) | ✅ Done |
| 7 | Docker Networks — Custom bridge (`grade-tracker-net`) | ✅ Done |
| 8 | Health Checks — All 3 services | ✅ Done |
| 9 | depends_on with `condition: service_healthy` | ✅ Done |
| 10 | Nginx Reverse Proxy — `/api-backend/` → `backend:5000` | ✅ Done |
| 11 | Non-root user in Dockerfile (security best practice) | ✅ Done |
| 12 | Full Stack App Live on AWS EC2 port 80 | ✅ Done |

---

## 🖥️ Project Output (Live on AWS EC2)

```
✅ Total Students : 3
✅ Average Grade  : 87
✅ Top Grade      : 95 (A)
✅ Add / Delete   : Working
✅ Data Persists  : MySQL volume
✅ URL            : http://54.226.172.26:80
```

---

## 🏗️ Project Architecture

```
                ┌──────────────────────────────────────────────┐
                │          grade-tracker-net (Bridge)           │
                │                                              │
Browser ──80──▶ │  ┌────────────┐      ┌────────────┐         │
                │  │  Frontend  │─────▶│  Backend   │         │
                │  │ nginx:80   │      │ flask:5000 │         │
                │  └────────────┘      └─────┬──────┘         │
                │   port 80:80               │                 │
                │   (exposed)         ┌──────▼──────┐         │
                │                     │    MySQL    │         │
                │   port 5000:5000    │   :3306     │         │
                │   (exposed)         └─────────────┘         │
                └──────────────────────────────────────────────┘

  Named Volumes:
    mysql-data   ──▶  /var/lib/mysql    (MySQL data persists!)
    backend-logs ──▶  /app/logs         (App logs)
```

---

## 📁 Actual Project Structure

```
Student-Grade-Tracker/
├── .dockerignore                 ← Excludes mysql-data from build context
├── docker-compose.yml            ← Orchestrates mysql + backend + frontend
├── backend/
│   ├── Dockerfile                ← Multi-stage: python:3.11 → python:3.11-slim
│   ├── app.py                    ← Flask REST API (CRUD + /health + /stats)
│   └── requirements.txt          ← flask, flask-cors, mysql-connector, gunicorn
└── frontend/
    ├── Dockerfile                ← Multi-stage: node:20-alpine → nginx:alpine
    ├── index.html                ← Full UI (dark theme dashboard)
    └── nginx.conf                ← Proxy /api-backend/ → backend:5000
```

---

## 🔐 Docker Scout — Security Scanning

Docker Scout scans images for CVE (Common Vulnerabilities & Exposures).

```
Base Image (python:3.11) ──▶ Your App Image ──▶ Docker Scout Scan
                                                        │
                                              ┌─────────▼─────────┐
                                              │   SBOM Generated  │
                                              │ (all packages list)│
                                              └─────────┬─────────┘
                                                        │
                                              ┌─────────▼─────────┐
                                              │   CVE Database    │
                                              │   Comparison      │
                                              └─────────┬─────────┘
                                                        │
                                              CRITICAL / HIGH / MEDIUM / LOW
```

| Severity | Meaning | Action |
|----------|---------|--------|
| CRITICAL | Immediate exploit possible | Block deployment |
| HIGH | Serious risk | Fix within 24 hours |
| MEDIUM | Moderate risk | Fix within sprint |
| LOW | Minor risk | Fix when possible |

**Key insight from Shubham's video:**
- Base image vulnerabilities are inherited by your app image
- Fix: use `python:3.11-slim` (not full `python:3.11`) + minimal packages

---

## 🪄 Docker Init — Auto-generate Dockerfiles

```bash
mkdir docker-init-test && cd docker-init-test
docker init
# Detects project type → generates Dockerfile + compose + .dockerignore
```

**Generated files:**
```
docker-init-test/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── README.Docker.md
```

---

## 🏗️ Multi-Stage Build — Actual Dockerfiles Used

### Backend (backend/Dockerfile):
```dockerfile
# STAGE 1: Builder — has build tools
FROM python:3.11 AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# STAGE 2: Runtime — slim, no build tools
FROM python:3.11-slim AS runtime
RUN useradd -m -u 1000 appuser        # non-root user
WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

### Frontend (frontend/Dockerfile):
```dockerfile
# STAGE 1: Builder — node environment
FROM node:20-alpine AS builder
WORKDIR /build
COPY index.html .

# STAGE 2: Runtime — nginx serves static files
FROM nginx:alpine AS runtime
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /build/index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget -qO- http://localhost/health || exit 1
CMD ["nginx", "-g", "daemon off;"]
```

### Size Savings:
| Image | Without Multi-stage | With Multi-stage | Savings |
|-------|-------------------|-----------------|---------|
| Backend | ~1.6 GB | ~212 MB | **87%** |
| Frontend | ~1.1 GB | ~25 MB | **97%** |

---

## 📦 Actual docker-compose.yml

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: grade-tracker-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: gradesdb
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppass
    volumes:
      - mysql-data:/var/lib/mysql        # Named volume
    networks:
      - grade-tracker-net
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-prootpass"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 30s

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: grade-tracker-backend
    restart: unless-stopped
    ports:
      - "5000:5000"                      # Exposed for direct API testing
    environment:
      DB_HOST: mysql                     # Docker DNS — resolves to mysql container
      DB_USER: root
      DB_PASSWORD: rootpass
      DB_NAME: gradesdb
    volumes:
      - backend-logs:/app/logs
    networks:
      - grade-tracker-net
    depends_on:
      mysql:
        condition: service_healthy       # Waits for MySQL health check ✅

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: grade-tracker-frontend
    restart: unless-stopped
    ports:
      - "80:80"                          # Main entry point
    networks:
      - grade-tracker-net
    depends_on:
      backend:
        condition: service_healthy       # Waits for backend health check ✅

networks:
  grade-tracker-net:
    driver: bridge

volumes:
  mysql-data:
  backend-logs:
```

---

## 🌐 Nginx Reverse Proxy Config (nginx.conf)

```nginx
server {
    listen 80;
    server_name _;

    location /health {
        return 200 'OK';
    }

    location /api-backend/ {
        proxy_pass http://backend:5000/;   # Docker DNS resolves 'backend'
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
```

---

## 🚀 How to Run on AWS EC2 (Free Tier)

```bash
# Step 1: Launch t2.micro, Ubuntu 22.04
# Security Group: port 22 (SSH) + port 80 (HTTP) open

# Step 2: Install Docker
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER && newgrp docker

# Step 3: Upload project and run
unzip Student-Grade-Tracker.zip && cd Student-Grade-Tracker-Full-Stack--main
docker compose up -d --build

# Step 4: Access app
http://<your-ec2-public-ip>:80
```

---

## 📊 Docker Series Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27 | 9 May 2026 | Docker Intro + Architecture | ✅ Done |
| Day 28 | 10 May 2026 | Install + Dockerfile + Java + Flask | ✅ Done |
| Day 29 | 11 May 2026 | Networking + Volumes + Compose + Registry | ✅ Done |
| Day 30 | 12 May 2026 | Multi-stage + Monitoring + Django+Nginx+MySQL | ✅ Done |
| Day 31 | 13 May 2026 | Docker Scout + Init + Student Grade Tracker | ✅ Done |
| Day 32 | 14 May 2026 | Final Docker Project | ⬜ Pending |

---

## 📚 Resources

| Resource | Link |
|----------|------|
| Docker Scout Docs | https://docs.docker.com/scout/ |
| Docker Init Docs | https://docs.docker.com/engine/reference/commandline/init/ |
| Shubham Londhe Docker One Shot | https://www.youtube.com/@TrainWithShubham |
| Docker Hub | https://hub.docker.com |
| Project Repo | https://github.com/RitikBawane/devops-90-days |

---

*Day 31 of 90 — Docker Series | DevOps 90-Day Challenge*
*Ritik Bawane | AWS Certified | RHCSA | Kyndryl MNC*
