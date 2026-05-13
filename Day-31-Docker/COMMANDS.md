# ⚡ Day 31 — Docker Commands (Copy-Paste Ready)

---

## 🛡️ DOCKER SCOUT COMMANDS

```bash
# Check if Docker Scout is available
docker scout --version

# Quick overview of image vulnerabilities
docker scout quickview <image-name>

# Detailed CVE list for an image
docker scout cves <image-name>

# Scan a specific image from Docker Hub
docker scout cves python:3.11-slim

# Compare your image vs base image
docker scout compare myapp:latest --to python:3.11-slim

# Scan your project image (after building)
docker scout quickview grade-tracker-backend:latest
docker scout cves grade-tracker-backend:latest

# Scan with specific severity filter
docker scout cves --only-severity critical,high <image-name>

# Recommendations to fix vulnerabilities
docker scout recommendations <image-name>
```

---

## 🪄 DOCKER INIT COMMANDS

```bash
# Create test directory
mkdir docker-init-test
cd docker-init-test

# Run docker init (interactive)
docker init

# docker init will ask:
# → What application platform? (Python/Node/Go/etc.)
# → What version? (3.11)
# → What port? (5000)
# → What start command? (python app.py)

# See generated files
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

## 🏗️ MULTI-STAGE BUILD COMMANDS

```bash
# Build multi-stage backend image
docker build -t grade-tracker-backend:latest ./backend

# Build multi-stage frontend image
docker build -t grade-tracker-frontend:latest ./frontend

# Check image sizes (compare multi-stage vs normal)
docker images | grep grade-tracker

# Build with specific target stage (debug builder stage)
docker build --target builder -t backend-builder ./backend

# Build with BuildKit (faster, better caching)
DOCKER_BUILDKIT=1 docker build -t grade-tracker-backend ./backend

# See all layers of an image
docker history grade-tracker-backend:latest

# See image details
docker inspect grade-tracker-backend:latest

# See image size breakdown
docker image inspect grade-tracker-backend:latest --format='{{.Size}}'
```

---

## 🚀 PROJECT RUN COMMANDS

```bash
# ---- FULL PROJECT (Student Grade Tracker) ----

# Clone/Upload project to EC2
# Then go to project directory
cd student-grade-tracker

# Build and start all services (first time)
docker compose up -d --build

# Start without rebuilding
docker compose up -d

# Check all containers status
docker compose ps

# Watch real-time logs (all services)
docker compose logs -f

# Watch logs of specific service
docker compose logs -f backend
docker compose logs -f mysql
docker compose logs -f frontend

# Check last 50 lines of logs
docker compose logs --tail=50 backend

# Stop all containers (keep volumes)
docker compose stop

# Start stopped containers
docker compose start

# Restart specific service
docker compose restart backend

# Rebuild only one service
docker compose up -d --build backend

# Stop and remove containers (volumes kept)
docker compose down

# Stop + remove containers + volumes (DATA DELETED!)
docker compose down -v

# Scale backend to 2 instances
docker compose up -d --scale backend=2
```

---

## 🐳 DOCKER IMAGE COMMANDS

```bash
# List all images
docker images

# List images with full details
docker images -a

# List only image IDs
docker images -q

# Pull image from Docker Hub
docker pull python:3.11-slim
docker pull mysql:8.0
docker pull nginx:alpine

# Tag an image
docker tag grade-tracker-backend:latest <dockerhub-username>/grade-tracker-backend:v1.0

# Push to Docker Hub
docker login
docker push <dockerhub-username>/grade-tracker-backend:v1.0

# Remove specific image
docker rmi grade-tracker-backend:latest

# Remove all unused images
docker image prune

# Remove all images (CAREFUL!)
docker image prune -a

# Save image to tar file (backup)
docker save grade-tracker-backend:latest -o backend-backup.tar

# Load image from tar file
docker load -i backend-backup.tar

# Build with no cache (fresh build)
docker build --no-cache -t grade-tracker-backend ./backend
```

---

## 📦 DOCKER CONTAINER COMMANDS

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List with custom format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Enter running container
docker exec -it grade-tracker-backend bash
docker exec -it grade-tracker-mysql bash
docker exec -it grade-tracker-frontend sh   # alpine uses sh not bash

# Run command in container without entering
docker exec grade-tracker-backend python --version
docker exec grade-tracker-mysql mysql -u root -prootpass -e "show databases;"

# Copy file from container to host
docker cp grade-tracker-backend:/app/app.py ./app-backup.py

# Copy file from host to container
docker cp ./new-app.py grade-tracker-backend:/app/app.py

# View container resource usage (live)
docker stats

# View resource usage (snapshot)
docker stats --no-stream

# Check container health
docker inspect grade-tracker-backend | grep -A 10 Health

# View container logs
docker logs grade-tracker-backend
docker logs grade-tracker-backend -f          # follow
docker logs grade-tracker-backend --tail=100  # last 100 lines
docker logs grade-tracker-backend --since=1h  # last 1 hour

# Stop container (graceful - SIGTERM)
docker stop grade-tracker-backend

# Kill container (force - SIGKILL)
docker kill grade-tracker-backend

# Start stopped container
docker start grade-tracker-backend

# Restart container
docker restart grade-tracker-backend

# Remove stopped container
docker rm grade-tracker-backend

# Remove running container (force)
docker rm -f grade-tracker-backend
```

---

## 🌐 DOCKER NETWORK COMMANDS

```bash
# List all networks
docker network ls

# Inspect your custom network
docker network inspect grade-tracker-net

# See containers on the network
docker network inspect grade-tracker-net \
  --format='{{range .Containers}}{{.Name}} - {{.IPv4Address}}{{"\n"}}{{end}}'

# Create custom bridge network
docker network create --driver bridge my-network

# Connect a container to a network
docker network connect grade-tracker-net my-container

# Disconnect container from network
docker network disconnect grade-tracker-net my-container

# Test DNS between containers
docker exec grade-tracker-backend ping mysql
docker exec grade-tracker-backend ping frontend
docker exec grade-tracker-backend nslookup mysql

# Test API from backend container
docker exec grade-tracker-backend curl http://mysql:3306
docker exec grade-tracker-frontend curl http://backend:5000/health

# Remove unused networks
docker network prune
```

---

## 💾 DOCKER VOLUME COMMANDS

```bash
# List all volumes
docker volume ls

# Inspect named volume
docker volume inspect grade-tracker-mysql-data

# See volume mount point on host
docker volume inspect grade-tracker-mysql-data \
  --format='{{.Mountpoint}}'

# Create named volume manually
docker volume create my-data

# Remove specific volume
docker volume rm my-data

# Remove all unused volumes
docker volume prune

# Backup volume data to tar
docker run --rm \
  -v grade-tracker-mysql-data:/data \
  -v $(pwd):/backup \
  ubuntu tar czf /backup/mysql-backup.tar.gz /data

# Restore volume from backup
docker run --rm \
  -v grade-tracker-mysql-data:/data \
  -v $(pwd):/backup \
  ubuntu tar xzf /backup/mysql-backup.tar.gz -C /

# Prove persistence test:
docker compose restart mysql
docker exec grade-tracker-mysql mysql -u root -prootpass -e \
  "SELECT * FROM gradesdb.students LIMIT 5;"
# Data still there even after restart!
```

---

## 🔧 API TEST COMMANDS

```bash
# Test backend health
curl http://localhost:5000/health

# Get all students
curl http://localhost:5000/api/students

# Get stats
curl http://localhost:5000/api/stats

# Add a student
curl -X POST http://localhost:5000/api/students \
  -H "Content-Type: application/json" \
  -d '{"name":"Ritik Sharma","subject":"Docker","grade":95}'

# Delete a student (replace 1 with actual ID)
curl -X DELETE http://localhost:5000/api/students/1

# Test via nginx proxy
curl http://localhost/api-backend/health
curl http://localhost/api-backend/api/students

# Test from EC2 public IP
curl http://<your-ec2-ip>/api-backend/health
```

---

## 🧹 CLEANUP COMMANDS

```bash
# Remove everything unused (images, containers, networks, cache)
docker system prune

# Remove everything including volumes (DANGER!)
docker system prune -a --volumes

# Check Docker disk usage
docker system df

# Verbose disk usage (see what's taking space)
docker system df -v

# Remove dangling images (untagged)
docker image prune

# Remove all stopped containers
docker container prune
```

---

## 📋 TODAY'S PRACTICE FLOW (Step by Step)

```bash
# STEP 1: Go to project directory
cd student-grade-tracker

# STEP 2: Build and start all services
docker compose up -d --build

# STEP 3: Check all running
docker compose ps
docker ps

# STEP 4: Check network
docker network ls
docker network inspect grade-tracker-net

# STEP 5: Check volumes
docker volume ls
docker volume inspect grade-tracker-mysql-data

# STEP 6: Test the app
curl http://localhost/api-backend/health
# Open browser: http://<ec2-ip>:80

# STEP 7: Add some data via UI, then test persistence
docker compose restart mysql
curl http://localhost/api-backend/api/students
# Data still there!

# STEP 8: Check image sizes (multi-stage proof)
docker images | grep grade-tracker

# STEP 9: Docker Scout scan
docker scout quickview grade-tracker-backend:latest

# STEP 10: Docker Init test
mkdir /tmp/init-test && cd /tmp/init-test
docker init
cat Dockerfile

# STEP 11: Enter containers and explore
docker exec -it grade-tracker-backend bash
docker exec -it grade-tracker-mysql bash -c "mysql -u root -prootpass gradesdb"

# STEP 12: Cleanup
docker compose down
docker system df
```

---

*Day 31 Commands — Docker Scout, Init, Multi-stage, Full Stack Project*
*DevOps 90-Day Challenge — Ritik Bawane*
