# 📝 Day 31 — Docker Notes 
> Based on actual Student Grade Tracker project — live on AWS EC2

---

## 1. 🛡️ Docker Scout

### What is Docker Scout?
Docker Scout is Docker's built-in security tool. It creates an **SBOM (Software Bill of Materials)** — a complete list of every package in your image — then compares against CVE databases.

### How it works internally:
```
Your Docker Image
      │
      ▼
┌─────────────────────┐
│   SBOM Generated    │  ← Lists every package + version inside image
│   (by Docker Scout) │     e.g. python 3.11, flask 3.0.0, gunicorn 21.2.0
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   CVE Database      │  ← Compares against:
│   Comparison        │     NIST NVD, GitHub Advisories, Docker Advisory DB
└────────┬────────────┘
         │
         ▼
  Severity Report: CRITICAL / HIGH / MEDIUM / LOW
```

### Severity Levels:
| Level | Meaning | Action |
|-------|---------|--------|
| CRITICAL | Attacker can immediately exploit | Block deployment |
| HIGH | Serious security risk | Fix within 24 hours |
| MEDIUM | Moderate risk | Fix within sprint |
| LOW | Minor risk | Fix when time allows |

### Key learning from Shubham's video:
```
Base image python:3.11 has vulnerabilities
         ↓
Your two-tier-app INHERITS all of them + adds your own packages
         ↓
Solution: Use python:3.11-slim (fewer packages = fewer CVEs)
```

### Why it matters in interviews:
> "How do you ensure Docker image security before production?"
> Answer: "We integrate Docker Scout in our CI/CD pipeline. It generates SBOM and checks CVEs. Pipeline fails if CRITICAL vulnerabilities found."

---

## 2. 🪄 Docker Init

### What is Docker Init?
`docker init` auto-detects your project type and generates production-ready Docker files — saving time and enforcing best practices.

### Detection logic:
| File Found | Platform Detected |
|-----------|------------------|
| `requirements.txt` / `Pipfile` | Python |
| `package.json` | Node.js |
| `go.mod` | Go |
| `pom.xml` / `build.gradle` | Java |
| `Cargo.toml` | Rust |

### What it generates:
```
your-project/
├── Dockerfile          ← Production-ready, multi-stage by default
├── docker-compose.yml  ← Basic service config
├── .dockerignore       ← Excludes .git, node_modules, etc.
└── README.Docker.md    ← Usage guide
```

### docker init vs Manual — when to use which:
| Aspect | docker init | Manual Dockerfile |
|--------|------------|------------------|
| Speed | Instant | Takes time |
| Best practices | Auto-applied | Your responsibility |
| Customization | Limited | Full control |
| Use for | Starting point | Production fine-tuning |

**Pro tip:** Run `docker init` → get skeleton → then customize for your needs!

---

## 3. 🏗️ Multi-Stage Build — Actual Code from Project

### Backend Dockerfile breakdown:
```dockerfile
# ── STAGE 1: BUILDER ──────────────────────────────
FROM python:3.11 AS builder        # Full python — has gcc, build tools (1.1GB)
WORKDIR /build
COPY requirements.txt .            # Copy deps FIRST (layer cache trick!)
RUN pip install --user \           # Install to /root/.local (not system)
    --no-cache-dir \               # Don't cache pip downloads
    -r requirements.txt

# ── STAGE 2: RUNTIME (FINAL IMAGE) ────────────────
FROM python:3.11-slim AS runtime   # Slim python — no build tools (125MB)
RUN useradd -m -u 1000 appuser    # Create non-root user (security!)
WORKDIR /app
COPY --from=builder \              # ← KEY: copy ONLY installed packages
    /root/.local \                 #   from builder stage
    /home/appuser/.local           #   build tools NOT included!
COPY app.py .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser                       # Switch to non-root user
EXPOSE 5000
HEALTHCHECK ...
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
#    ↑ Gunicorn = production WSGI server (not Flask dev server!)
```

### Frontend Dockerfile breakdown:
```dockerfile
# ── STAGE 1: BUILDER ──────────────────────────────
FROM node:20-alpine AS builder     # Node environment for "building" frontend
WORKDIR /build
COPY index.html .                  # In real React: npm install + npm run build

# ── STAGE 2: RUNTIME ──────────────────────────────
FROM nginx:alpine AS runtime       # Only 25MB!
RUN rm -rf /usr/share/nginx/html/* # Clear default nginx page
COPY --from=builder \
    /build/index.html \            # Only the built output — no node_modules!
    /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Layer caching — critical optimization:
```dockerfile
# ❌ WRONG — cache breaks every time code changes
COPY . .                           # any code change → cache miss here
RUN pip install -r requirements.txt # reinstalls ALL packages every time!

# ✅ CORRECT — used in our project
COPY requirements.txt .            # only changes when dependencies change
RUN pip install -r requirements.txt # cached! only reruns when req.txt changes
COPY app.py .                      # code changes here don't break pip cache
```

---

## 4. 📦 Docker Compose — Actual Config Explained

### Service startup order in our project:
```
mysql starts
    │
    └──▶ healthcheck passes (mysqladmin ping)
              │
              └──▶ backend starts (depends_on mysql: service_healthy)
                        │
                        └──▶ healthcheck passes (urllib /health)
                                  │
                                  └──▶ frontend starts (depends_on backend: service_healthy)
```

### depends_on conditions — 3 types:
| Condition | Meaning | Used in project |
|-----------|---------|----------------|
| `service_started` | Container started (NOT safe — app may not be ready) | ❌ Not used |
| `service_healthy` | Health check passing ✅ | ✅ Used for both |
| `service_completed_successfully` | For migration jobs | ❌ Not needed here |

### Environment variables — how backend connects to MySQL:
```yaml
environment:
  DB_HOST: mysql        # ← NOT an IP! Docker DNS resolves 'mysql' → container IP
  DB_USER: root
  DB_PASSWORD: rootpass
  DB_NAME: gradesdb
```

### Volumes in docker-compose.yml:
```yaml
volumes:
  mysql-data:           # Named volume — Docker manages location
  backend-logs:         # Named volume — for app logs

# In service:
volumes:
  - mysql-data:/var/lib/mysql    # mysql-data volume → mounted inside container
```

---

## 5. 🌐 Docker Networks — Container DNS

### How containers talk by name (not IP):
```
backend container wants to connect to MySQL

Code: mysql.connector.connect(host="mysql", ...)
                                      ↓
                         Docker DNS lookup: "mysql"
                                      ↓
                         Resolves to: 172.18.0.2 (MySQL container IP)
                                      ↓
                         Connection established! ✅
```

### Custom bridge vs default bridge:
| Feature | Default Bridge | Custom (grade-tracker-net) |
|---------|---------------|--------------------------|
| Container DNS | ❌ No name resolution | ✅ Resolve by service name |
| Isolation | ❌ All containers share | ✅ Only our 3 containers |
| Production safe | ❌ No | ✅ Yes |

### Network in our project:
```yaml
networks:
  grade-tracker-net:
    driver: bridge       # Bridge type — single host communication
```

---

## 6. 💾 Docker Volumes — Data Persistence Proof

### Volume types comparison:
```
Named Volume:   mysql-data:/var/lib/mysql
                → Docker controls location (/var/lib/docker/volumes/)
                → Survives: container stop, restart, deletion
                → Best for: databases, production data ✅ Used in project

Bind Mount:     ./local:/app/code
                → You control location (host path)
                → Good for: dev (live reload), not production
                → Risky: host path issues in production

tmpfs:          tmpfs:/tmp
                → RAM only — lost when container stops
                → Good for: temp data, sensitive data not on disk
```

### Volume lifecycle test:
```bash
docker compose up -d               # mysql-data volume created
# → Add students: Ritik Bawane — DevOps 80, AWS 95, Linux 85

docker compose restart mysql       # Container restarted
docker exec grade-tracker-mysql \
  mysql -u root -prootpass \
  -e "SELECT * FROM gradesdb.students;"
# → Data STILL THERE! Volume persisted ✅

docker compose down                # Containers removed
# → Volume STILL EXISTS (docker volume ls shows it)

docker compose up -d               # Containers recreated
# → Data STILL THERE! Volume reattaches ✅

docker compose down -v             # THIS deletes volumes too!
# → DATA GONE ⚠️
```

---

## 7. 🔒 Security Best Practices — Used in Our Project

### Non-root user (backend/Dockerfile):
```dockerfile
# Why root is dangerous:
# If container is compromised, attacker has root = full host access (in some configs)

RUN useradd -m -u 1000 appuser    # Create dedicated user, UID 1000
USER appuser                       # All subsequent commands run as this user
CMD ["gunicorn", "app:app"]        # Runs as appuser, not root
```

### Health checks — all 3 services:
```dockerfile
# Backend healthcheck:
HEALTHCHECK --interval=30s \      # Check every 30 seconds
            --timeout=10s \        # Fail if no response in 10s
            --start-period=40s \   # Grace period — app needs time to start
            --retries=3 \          # Mark unhealthy after 3 failures
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

# MySQL healthcheck (in compose):
test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-prootpass"]
interval: 10s      # Check frequently — backend depends on this
retries: 10        # MySQL needs more time to initialize
start_period: 30s

# Frontend healthcheck:
CMD wget -qO- http://localhost/health || exit 1
```

### .dockerignore — actual file used:
```
mysql-data        # Don't send local MySQL data to build context
```

---

## 8. 🔁 Nginx as Reverse Proxy — Actual Config

### Request flow in project:
```
Browser → GET http://54.226.172.26/api-backend/students
                           ↓
               Nginx (grade-tracker-frontend:80)
                           ↓
            location /api-backend/ {
                proxy_pass http://backend:5000/;
            }                      ↓
               Flask API (grade-tracker-backend:5000)
               → GET /students
                           ↓
               MySQL (grade-tracker-mysql:3306)
               → SELECT * FROM students
                           ↓
               JSON response back to browser ✅
```

### Why Nginx proxy instead of direct backend access:
- Only port 80 open on EC2 — single entry point
- Backend runs on port 5000 — not directly public
- Nginx handles: SSL termination, load balancing, static files
- Security: backend never directly exposed to internet

---

## 9. 🐍 Flask API — Actual Endpoints

```
GET  /health              → {"status": "healthy", "service": "grade-tracker-backend"}
GET  /api/students        → List all students (JSON array)
POST /api/students        → Add student (body: {name, subject, grade})
DELETE /api/students/<id> → Delete student by ID
GET  /api/stats           → {total, avg_grade, top_grade}
```

### DB connection with retry logic (actual code):
```python
def get_db():
    retries = 5
    while retries > 0:
        try:
            conn = mysql.connector.connect(
                host=os.environ.get("DB_HOST", "mysql"),   # from env var
                user=os.environ.get("DB_USER", "root"),
                password=os.environ.get("DB_PASSWORD", "rootpass"),
                database=os.environ.get("DB_NAME", "gradesdb")
            )
            return conn
        except Exception as e:
            retries -= 1
            print(f"DB not ready, retrying... ({retries} left)")
            time.sleep(3)   # Wait 3 seconds before retry
    raise Exception("Could not connect to DB")
```
**Why retry logic?** Even with `depends_on: service_healthy`, brief connection delay can occur. Retry = resilient code.

---

## 10. 🎯 Key Interview Points from Day 31

| Question | Best Answer |
|----------|-------------|
| What is Docker Scout? | Security scanner that generates SBOM and checks packages against CVE databases (NIST NVD, GitHub Advisories). Severity: CRITICAL/HIGH/MEDIUM/LOW |
| What is Docker Init? | CLI command that detects project type and auto-generates Dockerfile, docker-compose.yml, .dockerignore |
| Why multi-stage builds? | Stage 1 has build tools (large). Stage 2 only copies compiled output (small). Result: 87% smaller image |
| Named vs bind volume? | Named: Docker manages, survives deletion, for production databases. Bind: host path, for development live reload |
| How do containers communicate? | Custom bridge network + Docker DNS. Container name resolves to IP. `backend` → 172.18.x.x |
| What is HEALTHCHECK? | Docker periodically runs a command. If it fails N times → container marked unhealthy → depends_on blocks dependent services |
| depends_on limitation? | `service_started` only waits for container start, NOT app readiness. Use `condition: service_healthy` for production |
| Why non-root in Dockerfile? | Prevents privilege escalation. If container is breached, attacker gets limited user access, not root |
| Why Gunicorn not Flask dev server? | Flask dev server = single-threaded, not production-safe. Gunicorn = multi-worker, handles concurrent requests |

---

*Day 31 Notes — Student Grade Tracker | Docker Scout + Init + Full Stack*
*DevOps 90-Day Challenge — Ritik Bawane | AWS Certified | RHCSA | Kyndryl MNC*
