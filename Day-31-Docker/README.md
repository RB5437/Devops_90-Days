# 🐳 Day 31 — Docker Scout, Docker Init & Student Grade Tracker Project

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Docker Scout — Image Security Scanning | ✅ Done |
| 2 | Docker Init — Auto-generate Dockerfiles | ✅ Done |
| 3 | Multi-stage Docker Build (Backend + Frontend) | ✅ Done |
| 4 | Docker Compose — 3-tier orchestration | ✅ Done |
| 5 | Docker Volumes — Data persistence | ✅ Done |
| 6 | Docker Networks — Custom bridge network | ✅ Done |
| 7 | Docker Images — Multi-stage size optimization | ✅ Done |
| 8 | Docker Containers — Health checks + non-root user | ✅ Done |
| 9 | Nginx Reverse Proxy — Frontend → Backend | ✅ Done |
| 10 | Full Stack Project — Student Grade Tracker | ✅ Done |

---

## 🏗️ Project Architecture — Student Grade Tracker

```
                ┌──────────────────────────────────────────────┐
                │          grade-tracker-net (Bridge)           │
                │                                              │
Browser ──80──▶ │  ┌────────────┐      ┌────────────┐         │
                │  │  Frontend  │─────▶│  Backend   │         │
                │  │  Nginx:80  │      │  Flask:5000│         │
                │  └────────────┘      └─────┬──────┘         │
                │                            │                 │
                │                     ┌──────▼──────┐         │
                │                     │    MySQL    │         │
                │                     │   :3306     │         │
                │                     └─────────────┘         │
                └──────────────────────────────────────────────┘

  Volumes:  mysql-data  ──▶  /var/lib/mysql   (data persists!)
            backend-logs ──▶  /app/logs
```

---

## 📁 Project Structure

```
student-grade-tracker/
├── docker-compose.yml        ← Orchestrates all 3 services
├── frontend/
│   ├── Dockerfile            ← Multi-stage: node builder + nginx runtime
│   ├── nginx.conf            ← Proxy /api-backend/ → backend:5000
│   └── index.html            ← Full UI dashboard
├── backend/
│   ├── Dockerfile            ← Multi-stage: python builder + slim runtime
│   ├── app.py                ← Flask REST API
│   └── requirements.txt      ← Flask, MySQL, Gunicorn
└── README.md
```

---

## 🔐 Docker Scout — Security Scanning

Docker Scout scans your Docker images for known CVE (vulnerabilities) in packages.

```
Base Image ──▶ two-tier-app Image ──▶ Docker Scout Scan
```

### What Docker Scout checks:
- OS-level vulnerabilities (apt packages)
- Language-level vulnerabilities (pip, npm packages)
- Severity levels: CRITICAL, HIGH, MEDIUM, LOW

```bash
# Quick scan
docker scout quickview <image-name>

# Detailed CVE list
docker scout cves <image-name>

# Compare with base image
docker scout compare <image> --to python:3.11-slim
```

---

## 🪄 Docker Init — Auto-generate Dockerfiles

`docker init` detects your project type and auto-generates:
- `Dockerfile`
- `docker-compose.yml`
- `.dockerignore`

```bash
mkdir docker-init-test
cd docker-init-test
docker init
# Answer the prompts:
# → Platform: Python
# → Port: 5000
# → Start command: python app.py
```

---

## 🏗️ Multi-Stage Build — Size Comparison

| Image | Without Multi-stage | With Multi-stage | Savings |
|-------|-------------------|-----------------|---------|
| Backend (Python) | ~1.6 GB | ~212 MB | **87%** |
| Frontend (Node→Nginx) | ~1.1 GB | ~25 MB | **97%** |

### How it works:
```dockerfile
# Stage 1: Builder (has build tools)
FROM python:3.11 AS builder
RUN pip install --user -r requirements.txt

# Stage 2: Runtime (only what we need)
FROM python:3.11-slim AS runtime
COPY --from=builder /root/.local /home/appuser/.local
# Build tools NOT included → smaller image!
```

---

## 🚀 How to Run on AWS EC2 (Free Tier)

```bash
# 1. Launch t2.micro Ubuntu 22.04
#    Security Group: port 22, 80 open

# 2. Install Docker
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER && newgrp docker

# 3. Upload and run project
unzip Day31-Docker-Project.zip -d day31 && cd day31
docker compose up -d --build

# 4. Access app
http://<your-ec2-public-ip>:80
```

---

## 📊 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27 | 9 May 2026 | Docker Intro + Architecture | ✅ Done |
| Day 28 | 10 May 2026 | Install + Dockerfile + Java + Flask Apps | ✅ Done |
| Day 29 | 11 May 2026 | Networking + Volumes + Compose + Registry | ✅ Done |
| Day 30 | 12 May 2026 | Multi-stage + Monitoring + Django+Nginx+MySQL | ✅ Done |
| Day 31 | 13 May 2026 | Docker Scout + Init + Full Stack Project | ✅ Done |
| Day 32 | 14 May 2026 | Final Docker Project | ⬜ Pending |

---

## 📚 Resources

| Resource | Link |
|----------|------|
| Docker Scout Docs | https://docs.docker.com/scout/ |
| Docker Init Docs | https://docs.docker.com/engine/reference/commandline/init/ |
| Shubham Londhe Docker One Shot | https://www.youtube.com/@TrainWithShubham |
| Docker Hub | https://hub.docker.com |

---

*Day 31 of 90 — Docker Series | DevOps 90-Day Challenge*
*Ritik Sharma | AWS Certified | RHCSA | Kyndryl MNC*
