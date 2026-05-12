# ⚡ Docker Commands — Day 30 Quick Reference
> Multi-Stage Builds + Monitoring + Django Project | One-click copy-paste ready

---

## 🏗️ Multi-Stage Build Commands

### Build multi-stage image
```bash
# Build normally
docker build -t flask-app-mini .

# Build with no cache (fresh build)
docker build --no-cache -t flask-app-mini .

# Build specific stage only (useful for debugging)
docker build --target builder -t flask-builder .

# Check image size after build
docker images flask-app-mini
```

### Multi-Stage Dockerfile template
```dockerfile
# ── Stage 1: Builder ──────────────────────────────
FROM python:3.10 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

# ── Stage 2: Production ───────────────────────────
FROM python:3.10-slim

WORKDIR /app

# Copy only installed packages from builder stage
COPY --from=builder /usr/local/lib/python3.10/site-packages/ \
                    /usr/local/lib/python3.10/site-packages/

# Copy application code
COPY . .

ENTRYPOINT ["python", "run.py"]
```

---

## 📊 Monitoring & Logging Commands

### docker logs
```bash
docker logs <container_id>              # All logs
docker logs -f <container_id>           # Follow logs live (Ctrl+C to stop)
docker logs --tail 50 <container_id>    # Last 50 lines
docker logs --tail 100 -f <id>          # Last 100 lines + follow
docker logs --since 30m <id>            # Logs from last 30 minutes
docker logs --since 2026-05-12T08:00:00 <id>   # Logs since specific time
docker logs -t <id>                     # Show timestamps
```

### docker attach
```bash
# Attach to container stdout (⚠️ Ctrl+C stops container!)
docker attach <container_id>

# Safe way — attach in background, save logs to file
nohup docker attach <container_id> &

# Read saved logs
cat nohup.out
```

### docker stats — live resource monitoring
```bash
docker stats                            # All containers — CPU, RAM, NET, DISK
docker stats <container_id>             # Specific container
docker stats --no-stream                # One-time snapshot (no follow)
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

### docker inspect
```bash
docker inspect <container_id>           # Full JSON details
docker inspect <container_id> | grep IP # Find container IP
docker inspect --format='{{.State.Status}}' <id>   # Get status only
docker inspect --format='{{.NetworkSettings.IPAddress}}' <id>  # IP only
```

### docker top — processes inside container
```bash
docker top <container_id>               # Show running processes
```

### docker events — real-time Docker events
```bash
docker events                           # Stream all Docker events
docker events --filter type=container   # Container events only
```

---

## 🚀 Today's Project Commands — Django + Nginx + MySQL

### Step 1 — Clone the project
```bash
git clone https://github.com/RB5437/django-notes-app.git
cd django-notes-app
ls
```

### Step 2 — Check project structure
```bash
cat Dockerfile
cat docker-compose.yml
cat nginx/Dockerfile
cat nginx/default.conf
cat .env
```

### Step 3 — Create .dockerignore (fix permission error)
```bash
vi .dockerignore
# Add these lines:
# mysql-data/
# *.pyc
# __pycache__/
# .git/
```

### Step 4 — Build Django image (standalone)
```bash
docker build -t notes-app .
docker images
```

### Step 5 — Create network and volume
```bash
docker network create notes-app -d bridge
docker volume create mysql-data
```

### Step 6 — Start all services with Compose
```bash
# Start in foreground (see all logs)
docker compose up --build

# Start in background
docker compose up --build -d

# Check status
docker ps
docker compose ps
```

### Step 7 — Check logs of each service
```bash
docker logs django_cont
docker logs nginx_cont
docker logs db_cont

# Follow logs
docker logs -f django_cont
```

### Step 8 — Verify app is running
```bash
# Check all 3 containers are up
docker ps

# Test from EC2 itself
curl http://localhost:80
curl http://localhost:8000/admin

# Access from browser
# http://<EC2-Public-IP>
```

### Step 9 — Stop everything
```bash
docker compose down

# Stop + remove volumes too
docker compose down -v
```

---

## 🏗️ Today's Exact Multi-Stage Build Practice

```bash
# Go to flask project
cd ~/project/flask-app-ecs
ls

# See the multi-stage Dockerfile
cat Dockerfile

# Build the multi-stage image
docker build -t flask-app-mini .

# Compare sizes
docker images

# Expected result:
# flask-app-mini:latest   212MB  ← multi-stage ✅
# python:3.10             1.6GB  ← base image
# python:3.10-slim        185MB  ← slim base

# Run the mini image
docker run -d -p 80:80 flask-app-mini:latest
docker ps
docker logs <container_id>

# Attach and monitor logs
nohup docker attach <container_id> &
cat nohup.out
```

---

## 📁 Project Files Reference

### Django Dockerfile
```dockerfile
FROM python:3.9-slim

WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/backend

EXPOSE 8000
```

### Nginx Dockerfile
```dockerfile
FROM nginx:1.23.3-alpine
COPY ./default.conf /etc/nginx/conf.d/default.conf
```

### Nginx default.conf (Reverse Proxy)
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
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### .dockerignore (always create this!)
```
mysql-data/
*.pyc
__pycache__/
.env
.git/
*.log
```

---

## ❌ Errors & Fixes Today

```bash
# Error 1: Permission denied on mysql-data
# failed to solve: error from sender:
# open mysql-data/#innodb_redo: permission denied

# Fix: Add to .dockerignore
echo "mysql-data/" >> .dockerignore


# Error 2: version is obsolete warning
# WARN: the attribute `version` is obsolete

# Fix: Remove version line from docker-compose.yml
# Or just ignore — it's a warning, not an error


# Error 3: cannot attach to a stopped container
# Fix: Start the container first
docker start <container_id>
docker attach <container_id>
```

---

## 🧹 Cleanup

```bash
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove everything unused
docker system prune

# Remove everything including volumes ⚠️
docker system prune -a --volumes

# Check disk usage
docker system df
```

---

> 💡 **Pro Tips from today:**
> 1. Always use **multi-stage builds** for production — save 70-90% image size
> 2. Add `mysql-data/` to `.dockerignore` when using bind mounts for DB
> 3. Use `docker logs -f` instead of `docker attach` — safer for monitoring
> 4. `healthcheck` + `restart: always` = self-healing containers
> 5. `depends_on` ≠ waits for app ready — combine with healthcheck!
