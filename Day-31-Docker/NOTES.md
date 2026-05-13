# 📝 Day 31 — Docker Notes (Deep Concepts)

---

## 1. 🛡️ Docker Scout

### What is Docker Scout?
Docker Scout is a security tool that analyzes Docker images for vulnerabilities (CVEs — Common Vulnerabilities and Exposures). It checks every package inside your image against a known vulnerability database.

### Why it matters in DevOps?
- Companies require security scans before production deployment
- CI/CD pipelines integrate Scout to block vulnerable images
- Interviewers ask: "How do you handle image security?"

### How Docker Scout works internally:
```
Your Docker Image
      │
      ▼
┌─────────────────┐
│  SBOM Generated │  ← Software Bill of Materials
│  (all packages  │     (list of every package + version)
│   listed)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CVE Database   │  ← Compares against known vulnerabilities
│  Comparison     │     (NIST NVD, GitHub Advisories, etc.)
└────────┬────────┘
         │
         ▼
  Severity Report
  CRITICAL / HIGH / MEDIUM / LOW
```

### Severity Levels:
| Level | Meaning | Action |
|-------|---------|--------|
| CRITICAL | Immediate exploit possible | Block deployment |
| HIGH | Serious risk | Fix within 24 hours |
| MEDIUM | Moderate risk | Fix within sprint |
| LOW | Minor risk | Fix when possible |

### Key observation from Shubham's video:
- Base image (python:3.11) has some vulnerabilities
- Your two-tier-app image inherits ALL base image vulnerabilities PLUS any you add
- Solution: use slim/alpine base images + keep packages minimal

---

## 2. 🪄 Docker Init

### What is Docker Init?
`docker init` is a CLI command that **auto-generates** Dockerfile, docker-compose.yml, and .dockerignore by detecting your project type.

### What it detects:
| Project Type | Files Detected |
|-------------|----------------|
| Python | requirements.txt, Pipfile, pyproject.toml |
| Node.js | package.json |
| Go | go.mod |
| Java | pom.xml, build.gradle |
| Rust | Cargo.toml |

### What docker init generates:
```
docker-init-test/
├── Dockerfile          ← Platform-specific, production-ready
├── docker-compose.yml  ← Basic compose config
├── .dockerignore       ← Excludes unnecessary files
└── README.Docker.md    ← Usage instructions
```

### Important: docker init vs manual Dockerfile
| Aspect | docker init | Manual |
|--------|------------|--------|
| Speed | Very fast | Takes time |
| Customization | Basic | Full control |
| Multi-stage | Yes (auto) | You decide |
| Best for | Starting point | Production fine-tuning |

### Pro tip: Use docker init to get the skeleton, then customize it!

---

## 3. 🏗️ Multi-Stage Docker Build (Deep Dive)

### Problem without multi-stage:
```dockerfile
# BAD - everything in one stage
FROM python:3.11          # 1.1GB base
RUN pip install ...       # adds build tools
COPY . .
# Final image = 1.6GB+ (build tools + source + runtime all mixed)
```

### Solution with multi-stage:
```dockerfile
# Stage 1: Builder
FROM python:3.11 AS builder        # Has gcc, build tools
WORKDIR /build
COPY requirements.txt .
RUN pip install --user -r requirements.txt   # install here

# Stage 2: Runtime (FINAL IMAGE)
FROM python:3.11-slim AS runtime   # Minimal base, no build tools
COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .
# build tools from Stage 1 are NOT copied → smaller image!
```

### Layer caching — critical optimization:
```dockerfile
# WRONG ORDER (cache breaks on every code change)
COPY . .                     # code changes → cache miss
RUN pip install -r req.txt   # reinstalls every time!

# CORRECT ORDER (dependencies cached separately)
COPY requirements.txt .      # only changes when deps change
RUN pip install -r req.txt   # cached unless req.txt changes
COPY . .                     # code changes don't affect pip cache
```

### Multi-stage for Frontend (Node → Nginx):
```
Stage 1: node:20             (1.1GB) → npm install + npm build
Stage 2: nginx:alpine        (25MB)  → only /dist files copied
Result: 25MB image (no node_modules, no source, no npm!)
```

---

## 4. 🌐 Docker Networks (Review + Day 31 focus)

### Types recap:
| Type | Use Case | Day 31 usage |
|------|----------|-------------|
| Bridge | Container-to-container on same host | grade-tracker-net |
| Host | Container shares host network | Not used (security risk) |
| None | No network | Not used |
| Overlay | Multi-host (Swarm/K8s) | Not yet |

### Container DNS — most important concept:
When containers are on the same custom bridge network, they can reach each other by **service name** (not IP address).

```
backend container → connects to → mysql (container name)
# Docker DNS resolves 'mysql' → 172.18.0.2 (internal IP)
# No hardcoded IPs needed!
```

### Why custom network > default bridge?
| Feature | Default Bridge | Custom Bridge |
|---------|---------------|---------------|
| Container DNS | ❌ No | ✅ Yes |
| Isolation | ❌ Shared | ✅ Isolated |
| Production safe | ❌ No | ✅ Yes |

---

## 5. 💾 Docker Volumes (Review + Day 31 focus)

### Types comparison:
```
┌──────────────────────────────────────────────────────┐
│ Named Volume     mysql-data:/var/lib/mysql            │
│ → Docker manages location                            │
│ → Survives container deletion                        │
│ → Best for: databases, production data               │
├──────────────────────────────────────────────────────┤
│ Bind Mount       ./local-folder:/app/code            │
│ → You control location (host path)                   │
│ → Good for development (live code reload)            │
│ → Risky in production                                │
├──────────────────────────────────────────────────────┤
│ tmpfs Mount      tmpfs:/tmp/cache                    │
│ → In memory only, lost on container stop             │
│ → Best for: temp files, secrets in memory            │
└──────────────────────────────────────────────────────┘
```

### Volume lifecycle in Day 31 project:
```
docker compose up          → volume 'mysql-data' created
  ↓ add students to app
docker compose restart     → data STILL there (volume persists)
  ↓ more changes
docker compose down        → containers removed, volume STILL there
docker compose down -v     → containers + volumes BOTH removed (data lost!)
```

---

## 6. 🔒 Docker Security Best Practices (Day 31)

### Non-root user:
```dockerfile
# Bad: runs as root (security risk)
CMD ["python", "app.py"]

# Good: create and use non-root user
RUN useradd -m -u 1000 appuser
USER appuser
CMD ["gunicorn", "app:app"]
```

### Health checks:
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1
```
- `interval` — how often to check
- `timeout` — max time for one check
- `start-period` — grace period at startup (app warming up)
- `retries` — failures before marking unhealthy

### .dockerignore (always create!):
```
.git
.env
*.pyc
__pycache__
node_modules
*.log
tests/
docs/
```

---

## 7. 🔄 depends_on with health checks

### Problem: services start in parallel by default
```
MySQL  ──▶ starting...
Backend ──▶ starting... (tries to connect MySQL — FAILS! MySQL not ready)
```

### Solution: depends_on with condition
```yaml
backend:
  depends_on:
    mysql:
      condition: service_healthy   # wait until MySQL health check passes
```

### Three conditions:
| Condition | Meaning |
|-----------|---------|
| `service_started` | Container started (default, not safe) |
| `service_healthy` | Health check passing (production safe) |
| `service_completed_successfully` | For one-time jobs/migrations |

---

## 8. 🔁 Nginx as Reverse Proxy

### What Nginx does in Day 31:
```
Browser → http://ec2-ip:80/api-backend/students
              ↓
         Nginx (frontend container)
              ↓ proxy_pass http://backend:5000/students
         Flask API (backend container)
              ↓
         MySQL (db container)
```

### Why not expose backend directly?
- Security: only port 80 open on EC2
- Centralized: one entry point
- SSL termination: Nginx handles HTTPS
- Load balancing: Nginx can distribute to multiple backend instances

---

## 9. 📊 Key Interview Points from Day 31

| Question | Answer |
|----------|--------|
| What is Docker Scout? | Security scanner that checks image vulnerabilities (CVEs) using SBOM |
| What is Docker Init? | CLI command that auto-generates Dockerfile + compose from project type |
| Why multi-stage builds? | Separate build environment from runtime — smaller, more secure images |
| Named vs bind volume? | Named = Docker manages, survives deletion. Bind = host path, for dev |
| How containers communicate? | Custom bridge network + Docker DNS (container name as hostname) |
| Why non-root in Dockerfile? | Privilege escalation attack prevention |
| What is HEALTHCHECK? | Docker monitors container health, restarts if unhealthy |
| depends_on limitation? | Default only waits for container start, NOT app readiness — use condition: service_healthy |

---

*Day 31 Notes — Docker Scout, Docker Init, Multi-stage, Full Stack Project*
*DevOps 90-Day Challenge — Ritik Sharma*
