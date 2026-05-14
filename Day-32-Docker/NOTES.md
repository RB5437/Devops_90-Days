# 📝 Day 32 — Docker Complete Revision Notes
> Full Docker Series Recap — Day 27 to Day 32

---

## 1. 🐳 Docker Fundamentals (Day 27 Recap)

### What is Docker?
Docker is an open-source platform that packages applications with all dependencies into **containers** — ensuring they run consistently everywhere.

### VM vs Container:
```
┌─────────────────────────────────────────────────────┐
│  Virtual Machine              Container             │
│  ┌──────────┐                 ┌──────────┐          │
│  │  App     │                 │  App     │          │
│  ├──────────┤                 ├──────────┤          │
│  │Guest OS  │                 │Libraries │          │
│  ├──────────┤                 ├──────────┤          │
│  │Hypervisor│                 │Container │          │
│  ├──────────┤                 │Runtime   │          │
│  │Host OS   │                 ├──────────┤          │
│  ├──────────┤                 │Host OS   │          │
│  │Hardware  │                 ├──────────┤          │
│  └──────────┘                 │Hardware  │          │
│                               └──────────┘          │
│  Size: GBs, Start: minutes    Size: MBs, Start: sec │
└─────────────────────────────────────────────────────┘
```

### Docker Architecture:
```
Docker CLI  ──▶  Docker Daemon (dockerd)  ──▶  Docker Registry
   │                     │                      (Docker Hub)
   │              ┌──────┴──────┐
   │              │             │
   │          Images       Containers
   │          Volumes      Networks
   └──────────────────────────────
```

### Key components:
| Component | What it is |
|-----------|-----------|
| Docker Image | Read-only template — blueprint for container |
| Docker Container | Running instance of an image |
| Dockerfile | Instructions to build an image |
| Docker Volume | Persistent storage for containers |
| Docker Network | Communication between containers |
| Docker Registry | Storage for Docker images (Docker Hub) |

---

## 2. 📄 Dockerfile — Complete Reference (Day 28 Recap)

### All Dockerfile instructions:
```dockerfile
FROM python:3.11-slim          # Base image (always first)
LABEL maintainer="ritik"       # Metadata
WORKDIR /app                   # Set working directory
COPY requirements.txt .        # Copy files (specific)
COPY . .                       # Copy all files
RUN pip install -r req.txt     # Execute command during build
ENV APP_PORT=5000              # Set environment variable
EXPOSE 5000                    # Document port (not publish)
VOLUME ["/data"]               # Create mount point
USER appuser                   # Switch user (security)
HEALTHCHECK CMD curl /health   # Health check command
ENTRYPOINT ["python"]          # Fixed command
CMD ["app.py"]                 # Default arguments
```

### CMD vs ENTRYPOINT:
| | CMD | ENTRYPOINT |
|-|-----|-----------|
| Can override at runtime | ✅ Yes | ❌ No (use --entrypoint) |
| Purpose | Default args | Fixed executable |
| Combined | CMD = args for ENTRYPOINT | ENTRYPOINT = main command |

### Layer caching — correct order:
```dockerfile
# ✅ CORRECT — cache friendly
COPY requirements.txt .        # rarely changes → cached
RUN pip install -r req.txt     # cached unless req.txt changes
COPY . .                       # code changes here — only this layer rebuilds

# ❌ WRONG — breaks cache every code change
COPY . .                       # any change → cache miss
RUN pip install -r req.txt     # reinstalls every time!
```

---

## 3. 🏗️ Multi-Stage Build (Day 30 Recap)

### Concept:
```
Stage 1 (Builder):   FROM python:3.11        → Install all build tools + deps
                                              → 1.6GB image
Stage 2 (Runtime):   FROM python:3.11-slim   → Copy ONLY compiled output
                     COPY --from=builder      → No build tools = smaller image
                                              → 212MB image (87% reduction!)
```

### Real size comparison from our project:
| Image | Type | Size |
|-------|------|------|
| python:3.11 (base) | Full | ~1.1GB |
| Backend without multi-stage | Single stage | ~1.6GB |
| Backend with multi-stage | Multi-stage | ~212MB |
| node:20 (base) | Full | ~1.1GB |
| Frontend without multi-stage | Single stage | ~1.1GB |
| Frontend with multi-stage | nginx:alpine | ~25MB |

### Key command:
```dockerfile
COPY --from=builder /root/.local /home/appuser/.local
#         ↑ source stage    ↑ from path    ↑ to path in runtime
```

---

## 4. 🌐 Docker Networks — Complete (Day 29 Recap)

### Network types:
| Type | Driver | Use Case |
|------|--------|---------|
| Bridge | bridge | Default, single host, container-to-container |
| Host | host | Container uses host network directly |
| None | null | No network — isolated container |
| Overlay | overlay | Multi-host (Docker Swarm / Kubernetes) |
| Macvlan | macvlan | Container gets its own MAC address |

### Custom bridge vs default bridge:
```
Default Bridge:                    Custom Bridge (grade-tracker-net):
- No DNS resolution                - ✅ DNS by container name
- All containers share it          - ✅ Isolated per app
- Not production safe              - ✅ Production safe
```

### Container DNS flow:
```
backend code: host="mysql"
      ↓
Docker DNS lookup: "mysql"
      ↓
Resolves to: 172.18.0.2 (MySQL container IP)
      ↓
Connection established! ✅
```

### Key commands:
```bash
docker network create --driver bridge mynet   # Create network
docker network ls                              # List networks
docker network inspect mynet                   # Inspect network
docker network connect mynet container1        # Connect container
docker network disconnect mynet container1     # Disconnect
docker network rm mynet                        # Remove network
```

---

## 5. 💾 Docker Volumes — Complete (Day 29 Recap)

### Three types:
```
┌────────────────────────────────────────────────────────┐
│ 1. Named Volume    docker volume create mysql-data      │
│    mysql-data:/var/lib/mysql                           │
│    → Docker manages storage location                   │
│    → Survives container deletion                       │
│    → USE FOR: databases, production data               │
├────────────────────────────────────────────────────────┤
│ 2. Bind Mount      -v /host/path:/container/path       │
│    ./code:/app/code                                    │
│    → You control the host path                         │
│    → Good for development (live code reload)           │
│    → USE FOR: local development only                   │
├────────────────────────────────────────────────────────┤
│ 3. tmpfs Mount     --tmpfs /tmp                        │
│    → In RAM only — lost on container stop              │
│    → USE FOR: sensitive temp data, caching             │
└────────────────────────────────────────────────────────┘
```

### Volume lifecycle:
```
docker compose up    → volume created
docker compose stop  → volume SAFE
docker compose down  → volume SAFE (containers removed)
docker compose down -v → volume DELETED ⚠️
```

---

## 6. 📦 Docker Compose — Complete (Day 29 Recap)

### Key sections:
```yaml
version: "3.9"

services:           # Define your containers
  mysql:
    image: mysql:8.0
    environment:    # Environment variables
    volumes:        # Mount volumes
    networks:       # Connect to networks
    healthcheck:    # Health monitoring
    depends_on:     # Service dependencies

networks:           # Define custom networks
  mynet:
    driver: bridge

volumes:            # Define named volumes
  mysql-data:
```

### depends_on conditions:
| Condition | Meaning | Use when |
|-----------|---------|---------|
| service_started | Container started (default) | Never in production |
| service_healthy | Health check passing | ✅ Always use this |
| service_completed_successfully | Job finished | DB migration jobs |

### Most used compose commands:
```bash
docker compose up -d --build    # Build + start all
docker compose ps               # Status of all services
docker compose logs -f          # Follow all logs
docker compose logs -f backend  # Follow specific service
docker compose restart backend  # Restart one service
docker compose stop             # Stop all (keep volumes)
docker compose down             # Remove containers
docker compose down -v          # Remove containers + volumes
docker compose up --scale backend=3  # Scale service
```

---

## 7. 🛡️ Docker Scout (Day 31 Recap)

### How it works:
```
Docker Image
    ↓
SBOM (Software Bill of Materials) — lists every package
    ↓
CVE Database comparison (NIST NVD, GitHub Advisories)
    ↓
Severity Report: CRITICAL / HIGH / MEDIUM / LOW
```

### Severity levels:
| Level | Action |
|-------|--------|
| CRITICAL | Block deployment immediately |
| HIGH | Fix within 24 hours |
| MEDIUM | Fix within sprint |
| LOW | Fix when possible |

### Interview tip:
> "We integrate Docker Scout in CI/CD pipeline. Pipeline fails if CRITICAL CVEs found — image never reaches production."

---

## 8. 🪄 Docker Init (Day 31 Recap)

### What it detects:
```
requirements.txt → Python
package.json     → Node.js
go.mod           → Go
pom.xml          → Java
Cargo.toml       → Rust
```

### What it generates:
```
Dockerfile           ← Multi-stage, production-ready
docker-compose.yml   ← Basic service config
.dockerignore        ← Excludes unnecessary files
README.Docker.md     ← Usage guide
```

---

## 9. 🔒 Docker Security Best Practices

### Non-root user:
```dockerfile
RUN useradd -m -u 1000 appuser
USER appuser
# All subsequent commands run as non-root
```

### HEALTHCHECK parameters:
```dockerfile
HEALTHCHECK --interval=30s   # Check every 30 seconds
            --timeout=10s    # Fail if no response in 10s
            --start-period=40s  # Grace period at startup
            --retries=3      # Unhealthy after 3 failures
    CMD curl -f http://localhost:5000/health || exit 1
```

### .dockerignore — always create:
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

### Why Gunicorn not Flask dev server:
| Flask dev server | Gunicorn |
|-----------------|---------|
| Single-threaded | Multi-worker |
| Not production safe | Production ready |
| Debug mode on | No debug mode |
| One request at a time | Concurrent requests |

---

## 10. 🐳 Docker Hub — Push & Pull (Day 32)

### Full workflow:
```bash
# 1. Login
docker login

# 2. Tag image with your username
docker tag myapp:latest username/myapp:v1.0

# 3. Push to Docker Hub
docker push username/myapp:v1.0

# 4. Pull from anywhere
docker pull username/myapp:v1.0

# 5. Run from Docker Hub
docker run -d username/myapp:v1.0
```

---

## 11. 🧹 Docker System Management (Day 32)

### Check disk usage:
```bash
docker system df          # Summary
docker system df -v       # Detailed breakdown
```

### Cleanup commands:
```bash
docker system prune           # Remove unused: containers, networks, images
docker system prune -a        # Also remove unused images
docker system prune -a --volumes  # Also remove volumes ⚠️ DANGER

docker image prune            # Remove dangling images only
docker container prune        # Remove stopped containers
docker volume prune           # Remove unused volumes
docker network prune          # Remove unused networks
```

---

## 12. 🎯 Full Docker Series — Interview Master Points

| Topic | Key Point to Remember |
|-------|----------------------|
| Container vs VM | Shared kernel vs full OS. Seconds vs minutes startup |
| Dockerfile order | COPY requirements → RUN pip → COPY code (cache!) |
| Multi-stage | COPY --from=builder copies only output, not build tools |
| Networks | Custom bridge = DNS by name. Default bridge = no DNS |
| Volumes | Named = persistent. Bind = dev. tmpfs = RAM only |
| depends_on | service_healthy waits for health check, not just start |
| Docker Scout | SBOM → CVE check → CRITICAL/HIGH/MEDIUM/LOW |
| Non-root | useradd + USER directive = security best practice |
| Gunicorn | Production WSGI server, multi-worker, not Flask dev server |
| docker compose down -v | DELETES volumes — data gone permanently |

---

*Day 32 Notes — Docker Complete Series Revision*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
