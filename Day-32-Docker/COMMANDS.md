# ⚡ Day 32 — Complete Docker Command Reference
> Full revision of all Docker commands — Day 27 to Day 32

---

## 🐳 DOCKER IMAGE COMMANDS

```bash
# ── BUILD ──────────────────────────────────────────────
# Build image from Dockerfile
docker build -t myapp:latest .

# Build with no cache (fresh build)
docker build --no-cache -t myapp:latest .

# Build specific stage only (multi-stage)
docker build --target builder -t myapp-builder .

# Build with BuildKit (faster)
DOCKER_BUILDKIT=1 docker build -t myapp .

# ── LIST & INSPECT ─────────────────────────────────────
# List all images
docker images

# List with all details
docker images -a

# List only IDs
docker images -q

# See image layers
docker history myapp:latest

# Full image details (JSON)
docker inspect myapp:latest

# Image size in bytes
docker image inspect myapp:latest --format='{{.Size}}'

# ── TAG & PUSH ─────────────────────────────────────────
# Tag image for Docker Hub
docker tag myapp:latest yourusername/myapp:v1.0
docker tag myapp:latest yourusername/myapp:latest

# Login to Docker Hub
docker login

# Push to Docker Hub
docker push yourusername/myapp:v1.0
docker push yourusername/myapp:latest

# Pull from Docker Hub
docker pull yourusername/myapp:v1.0
docker pull nginx:alpine
docker pull mysql:8.0
docker pull python:3.11-slim

# ── SAVE & LOAD ────────────────────────────────────────
# Save image to tar file
docker save myapp:latest -o myapp-backup.tar

# Load image from tar
docker load -i myapp-backup.tar

# ── REMOVE ─────────────────────────────────────────────
# Remove specific image
docker rmi myapp:latest

# Remove all dangling (untagged) images
docker image prune

# Remove ALL unused images
docker image prune -a

# Force remove image (even if container using it)
docker rmi -f myapp:latest
```

---

## 📦 DOCKER CONTAINER COMMANDS

```bash
# ── RUN ────────────────────────────────────────────────
# Run container in background
docker run -d myapp:latest

# Run with port mapping
docker run -d -p 8080:5000 myapp:latest

# Run with name
docker run -d --name mycontainer myapp:latest

# Run with environment variables
docker run -d -e DB_HOST=mysql -e DB_PORT=3306 myapp:latest

# Run with volume mount
docker run -d -v mydata:/app/data myapp:latest

# Run with network
docker run -d --network mynet myapp:latest

# Run interactively (enter container immediately)
docker run -it python:3.11-slim bash

# Run and remove when done
docker run --rm myapp:latest python --version

# ── LIST ───────────────────────────────────────────────
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Custom format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# ── EXEC & LOGS ────────────────────────────────────────
# Enter running container
docker exec -it mycontainer bash
docker exec -it mycontainer sh       # for alpine

# Run command without entering
docker exec mycontainer python --version
docker exec mycontainer ls /app

# View logs
docker logs mycontainer
docker logs mycontainer -f            # follow
docker logs mycontainer --tail=100    # last 100 lines
docker logs mycontainer --since=1h    # last 1 hour
docker logs mycontainer --since=2026-05-14T00:00:00

# ── INSPECT & STATS ────────────────────────────────────
# Full container details
docker inspect mycontainer

# Check container health
docker inspect mycontainer | grep -A 10 Health

# Live resource usage (all containers)
docker stats

# Snapshot (no live update)
docker stats --no-stream

# ── COPY ───────────────────────────────────────────────
# Copy from container to host
docker cp mycontainer:/app/app.py ./app-backup.py

# Copy from host to container
docker cp ./newfile.py mycontainer:/app/newfile.py

# ── STOP / START / RESTART ─────────────────────────────
# Stop gracefully (SIGTERM)
docker stop mycontainer

# Force kill (SIGKILL)
docker kill mycontainer

# Start stopped container
docker start mycontainer

# Restart container
docker restart mycontainer

# ── REMOVE ─────────────────────────────────────────────
# Remove stopped container
docker rm mycontainer

# Force remove running container
docker rm -f mycontainer

# Remove all stopped containers
docker container prune
```

---

## 🌐 DOCKER NETWORK COMMANDS

```bash
# ── LIST & INSPECT ─────────────────────────────────────
# List all networks
docker network ls

# Inspect specific network
docker network inspect grade-tracker-net

# See containers on network + their IPs
docker network inspect grade-tracker-net \
  --format='{{range .Containers}}{{.Name}} - {{.IPv4Address}}{{"\n"}}{{end}}'

# ── CREATE & REMOVE ────────────────────────────────────
# Create custom bridge network
docker network create --driver bridge mynet

# Create with specific subnet
docker network create --driver bridge \
  --subnet=172.20.0.0/16 mynet

# Remove network
docker network rm mynet

# Remove all unused networks
docker network prune

# ── CONNECT & DISCONNECT ───────────────────────────────
# Connect container to network
docker network connect mynet mycontainer

# Disconnect container from network
docker network disconnect mynet mycontainer

# ── TEST DNS BETWEEN CONTAINERS ────────────────────────
# Test if containers can reach each other by name
docker exec backend ping mysql
docker exec backend ping frontend
docker exec backend nslookup mysql

# Test API from inside container
docker exec backend curl http://mysql:3306
docker exec frontend curl http://backend:5000/health
```

---

## 💾 DOCKER VOLUME COMMANDS

```bash
# ── LIST & INSPECT ─────────────────────────────────────
# List all volumes
docker volume ls

# Inspect volume (see mount path on host)
docker volume inspect grade-tracker-mysql-data

# See actual host path
docker volume inspect grade-tracker-mysql-data \
  --format='{{.Mountpoint}}'

# ── CREATE & REMOVE ────────────────────────────────────
# Create named volume
docker volume create mydata

# Remove specific volume
docker volume rm mydata

# Remove all unused volumes
docker volume prune

# ── BACKUP & RESTORE ───────────────────────────────────
# Backup named volume to tar file
docker run --rm \
  -v grade-tracker-mysql-data:/data \
  -v $(pwd):/backup \
  ubuntu tar czf /backup/mysql-backup.tar.gz /data

# Restore volume from backup
docker run --rm \
  -v grade-tracker-mysql-data:/data \
  -v $(pwd):/backup \
  ubuntu tar xzf /backup/mysql-backup.tar.gz -C /

# ── PERSISTENCE TEST ───────────────────────────────────
# Add data → restart container → verify data persists
docker compose restart mysql
docker exec grade-tracker-mysql \
  mysql -u root -prootpass \
  -e "SELECT * FROM gradesdb.students LIMIT 5;"
# Data still there! Volume persisted ✅
```

---

## 🚀 DOCKER COMPOSE COMMANDS

```bash
# ── START & BUILD ──────────────────────────────────────
# Build + start all services
docker compose up -d --build

# Start without rebuilding
docker compose up -d

# Build only (don't start)
docker compose build

# Rebuild specific service
docker compose up -d --build backend

# Scale service to multiple instances
docker compose up -d --scale backend=3

# ── STATUS & LOGS ──────────────────────────────────────
# Check all services status
docker compose ps

# Follow all logs
docker compose logs -f

# Follow specific service logs
docker compose logs -f backend
docker compose logs -f mysql
docker compose logs -f frontend

# Last N lines
docker compose logs --tail=50 backend

# ── RESTART & UPDATE ───────────────────────────────────
# Restart specific service
docker compose restart backend

# Stop all (containers kept)
docker compose stop

# Start stopped containers
docker compose start

# ── STOP & REMOVE ──────────────────────────────────────
# Stop + remove containers (volumes kept)
docker compose down

# Stop + remove containers + volumes ⚠️ DATA DELETED
docker compose down -v

# Stop + remove containers + images + volumes
docker compose down --rmi all -v

# ── EXEC IN COMPOSE SERVICES ───────────────────────────
# Enter service container
docker compose exec backend bash
docker compose exec mysql bash
docker compose exec frontend sh

# Run command in service
docker compose exec mysql mysql -u root -prootpass
docker compose exec backend python --version
```

---

## 🛡️ DOCKER SCOUT COMMANDS

```bash
# Check Docker Scout available
docker scout --version

# Quick vulnerability overview
docker scout quickview myapp:latest

# Detailed CVE list
docker scout cves myapp:latest

# Filter by severity
docker scout cves --only-severity critical,high myapp:latest

# Compare with base image
docker scout compare myapp:latest --to python:3.11-slim

# Recommendations to fix
docker scout recommendations myapp:latest

# Scan our project images
docker scout quickview grade-tracker-backend:latest
docker scout cves grade-tracker-backend:latest
docker scout quickview grade-tracker-frontend:latest
```

---

## 🪄 DOCKER INIT COMMANDS

```bash
# Create test directory
mkdir docker-init-test && cd docker-init-test

# Run docker init (interactive)
docker init

# Docker init asks:
# → Platform? (Python/Node/Go/Java/Rust)
# → Version? (3.11)
# → Port? (5000)
# → Start command? (python app.py)

# See what was generated
ls -la
cat Dockerfile
cat docker-compose.yml
cat .dockerignore

# Build using generated Dockerfile
docker build -t init-test .

# Run using generated compose
docker compose up
```

---

## 🧹 DOCKER SYSTEM COMMANDS

```bash
# ── DISK USAGE ─────────────────────────────────────────
# Summary of disk usage
docker system df

# Detailed breakdown
docker system df -v

# ── CLEANUP ────────────────────────────────────────────
# Remove all unused resources (safe)
docker system prune

# Remove all unused including untagged images
docker system prune -a

# Remove everything including volumes ⚠️ DANGER
docker system prune -a --volumes

# Individual cleanup
docker image prune -a        # All unused images
docker container prune       # All stopped containers
docker volume prune          # All unused volumes
docker network prune         # All unused networks

# ── INFO ───────────────────────────────────────────────
# Docker system info
docker info

# Docker version
docker version

# Docker events (live)
docker events
```

---

## 🐳 DOCKER HUB COMMANDS (Day 32 Practice)

```bash
# Login to Docker Hub
docker login
# Enter username and password

# Tag images for push
docker tag grade-tracker-backend:latest \
  yourusername/grade-tracker-backend:v1.0

docker tag grade-tracker-frontend:latest \
  yourusername/grade-tracker-frontend:v1.0

# Push all images
docker push yourusername/grade-tracker-backend:v1.0
docker push yourusername/grade-tracker-frontend:v1.0

# Verify — pull from Docker Hub on another machine
docker pull yourusername/grade-tracker-backend:v1.0

# Logout
docker logout
```

---

## 📋 DAY 32 REVISION PRACTICE FLOW

```bash
# STEP 1: Start project
cd student-grade-tracker
docker compose up -d --build
docker compose ps

# STEP 2: Images revision
docker images
docker history grade-tracker-backend:latest
docker scout quickview grade-tracker-backend:latest

# STEP 3: Containers revision
docker ps
docker stats --no-stream
docker exec -it grade-tracker-backend bash
# Inside: ls, python --version, exit
docker logs grade-tracker-backend --tail=20

# STEP 4: Networks revision
docker network ls
docker network inspect grade-tracker-net
docker exec grade-tracker-backend ping mysql  # DNS test

# STEP 5: Volumes revision
docker volume ls
docker volume inspect grade-tracker-mysql-data
# Add data via app → restart mysql → verify persistence
docker compose restart mysql
docker exec grade-tracker-mysql \
  mysql -u root -prootpass \
  -e "SELECT COUNT(*) FROM gradesdb.students;"

# STEP 6: Multi-stage size check
docker images | grep grade-tracker
# backend ~212MB, frontend ~25MB

# STEP 7: Docker Hub push
docker login
docker tag grade-tracker-backend:latest yourusername/grade-tracker-backend:v1.0
docker push yourusername/grade-tracker-backend:v1.0

# STEP 8: Docker Init
mkdir /tmp/init-test && cd /tmp/init-test
docker init
cat Dockerfile

# STEP 9: Cleanup
docker compose down
docker system df
docker system prune

# STEP 10: Docker series COMPLETE! 🎉
echo "Docker Series Day 27-32 COMPLETE!"
```

---

## 🔧 QUICK REFERENCE CHEATSHEET

```bash
# Most used commands in one place

docker build -t app .              # Build image
docker run -d -p 80:80 app         # Run container
docker ps                          # List running
docker logs app -f                 # Follow logs
docker exec -it app bash           # Enter container
docker stop app                    # Stop container
docker rm app                      # Remove container
docker images                      # List images
docker rmi app                     # Remove image
docker compose up -d --build       # Start all services
docker compose down                # Stop all services
docker compose logs -f             # Follow all logs
docker network ls                  # List networks
docker volume ls                   # List volumes
docker system prune                # Cleanup unused
docker scout quickview app         # Security scan
```

---

*Day 32 Commands — Complete Docker Series Reference*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
