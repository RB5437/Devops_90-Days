# ⚡ Docker Commands — Quick Reference
> Day 28 | 10 May 2026 | One-click copy-paste ready

---

## 🔧 Installation & Setup

```bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io -y

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

# Fix permission denied — add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker run hello-world

# Quick install (one-liner)
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
```

---

## 🔑 Docker Hub Login

```bash
# Web-based login (opens browser)
docker login

# Login with username in terminal
docker login -u your-dockerhub-username

# Logout
docker logout
```

---

## 🖼️ Image Commands

```bash
# List all local images
docker images

# Pull image from Docker Hub
docker pull nginx
docker pull ubuntu:22.04
docker pull mysql:latest
docker pull hello-world

# Remove one image
docker rmi nginx

# Remove image by ID
docker rmi f9078146db2e

# Remove ALL images (force)
docker rmi $(docker images -q) -f

# Inspect image details
docker image inspect nginx

# Show image history (layers)
docker image history nginx

# Tag an image
docker tag myapp:latest ritikbawane/myapp:v1

# Push image to Docker Hub
docker push ritikbawane/myapp:v1

# Save image to tar file (offline)
docker save -o myapp.tar myapp:latest

# Load image from tar file
docker load -i myapp.tar
```

---

## 🏗️ Build Commands

```bash
# Build image from Dockerfile in current directory
docker build -t myapp .

# Build with specific tag/version
docker build -t myapp:v1 .

# Build from custom Dockerfile name
docker build -t myapp -f Dockerfile.dev .

# Build without cache (fresh build)
docker build --no-cache -t myapp .

# Build and push in one step
docker build -t ritikbawane/myapp:v1 . && docker push ritikbawane/myapp:v1
```

---

## 🚀 Container Run Commands

```bash
# Run container (foreground — blocks terminal)
docker run nginx

# Run in background (detached mode)
docker run -d nginx

# Run with port mapping (host:container)
docker run -d -p 8080:80 nginx
docker run -d -p 80:80 flask-app

# Run with environment variable
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql
docker run -d -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=mydb mysql

# Run with a custom name
docker run -d --name mycontainer nginx

# Run interactive terminal (for Ubuntu/bash images)
docker run -it ubuntu bash

# Run and auto-remove when stopped
docker run --rm hello-world

# Run with volume
docker run -d -v mydata:/app/data nginx

# Run with bind mount
docker run -d -v /home/ubuntu/data:/app/data nginx

# Run Java app (today's practice)
docker run java-app

# Run Flask app on port 80 (today's practice)
docker run -d -p 80:80 flask-app

# Run MySQL with env variable (today's practice)
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql
```

---

## 📋 Container Management

```bash
# List running containers
docker ps

# List ALL containers (running + stopped)
docker ps -a

# List only container IDs
docker ps -q

# Stop a container (graceful)
docker stop container_id
docker stop mycontainer

# Start a stopped container
docker start container_id
docker start mycontainer

# Restart container
docker restart mycontainer

# Kill container immediately
docker kill mycontainer

# Remove stopped container
docker rm container_id

# Force remove running container
docker rm -f container_id

# Remove ALL stopped containers
docker rm $(docker ps -aq)

# Remove ALL containers (running + stopped) force
docker rm -f $(docker ps -aq)

# Pause and unpause container
docker pause mycontainer
docker unpause mycontainer
```

---

## 🔍 Container Inspection & Logs

```bash
# View container logs
docker logs container_id
docker logs mycontainer

# Follow logs live (like tail -f)
docker logs -f mycontainer

# Last 50 lines of logs
docker logs --tail 50 mycontainer

# Inspect container details (JSON)
docker inspect container_id

# See running processes inside container
docker top mycontainer

# Live resource stats (CPU, RAM)
docker stats

# Stats for specific container
docker stats mycontainer
```

---

## 💻 Exec Into Container

```bash
# Enter running container with bash
docker exec -it container_id bash

# Enter with sh (if bash not available — alpine images)
docker exec -it container_id sh

# Run single command inside container
docker exec mycontainer ls /app
docker exec mycontainer cat /etc/os-release

# Run command as root
docker exec -it -u root mycontainer bash
```

---

## 💾 Volume Commands

```bash
# Create a volume
docker volume create mydata

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mydata

# Remove a volume
docker volume rm mydata

# Remove ALL unused volumes
docker volume prune

# Run container with named volume
docker run -d -v mydata:/app/data nginx

# Run with bind mount
docker run -d -v /home/ubuntu/myfiles:/app nginx
```

---

## 🌐 Network Commands

```bash
# List networks
docker network ls

# Create a network
docker network create mynet

# Inspect network
docker network inspect mynet

# Run container in specific network
docker run -d --network mynet --name app1 nginx
docker run -d --network mynet --name app2 nginx

# Connect running container to network
docker network connect mynet mycontainer

# Disconnect container from network
docker network disconnect mynet mycontainer

# Remove network
docker network rm mynet

# Remove all unused networks
docker network prune
```

---

## 🧹 Cleanup Commands

```bash
# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune

# Remove all unused images (including tagged)
docker image prune -a

# Remove all unused volumes
docker volume prune

# Remove all unused networks
docker network prune

# Remove EVERYTHING unused (containers, images, networks, build cache)
docker system prune

# Remove EVERYTHING including volumes (⚠️ careful!)
docker system prune -a --volumes

# Check disk usage
docker system df
```

---

## 🐋 Docker Compose Commands

```bash
# Start all services (foreground)
docker compose up

# Start all services in background
docker compose up -d

# Stop all services
docker compose down

# Stop and remove volumes too
docker compose down -v

# List running services
docker compose ps

# View logs
docker compose logs

# Follow logs for specific service
docker compose logs -f web

# Build images
docker compose build

# Rebuild without cache
docker compose build --no-cache

# Enter a service container
docker compose exec web bash

# Restart a service
docker compose restart web

# Scale a service (run 3 instances of web)
docker compose up -d --scale web=3
```

---

## 📝 Today's Exact Commands (Practice Log)

```bash
# 1. Install Docker
sudo apt-get install docker.io

# 2. Check Docker status
sudo systemctl status docker

# 3. Fix permission denied
sudo usermod -aG docker $USER
newgrp docker

# 4. Verify Docker works
docker ps

# 5. Login to Docker Hub
docker login

# 6. Pull and run hello-world
docker pull hello-world
docker run hello-world

# 7. Pull MySQL and run with env variable
docker pull mysql
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql

# 8. Clone Java project and build
git clone https://github.com/RB5437/simple-java-docker.git
cd simple-java-docker
docker build -t java-app .
docker run java-app

# 9. Clone Flask project and build
cd ..
git clone https://github.com/RB5437/flask-app-ecs.git
cd flask-app-ecs
docker build -t flask-app .
docker run -d -p 80:80 flask-app

# 10. Check logs
docker logs <container_id>

# 11. Stop and start container
docker stop <container_id>
docker start <container_id>

# 12. Enter container
docker exec -it <container_id> bash
```

---

## 🐳 Dockerfiles Written Today

### Java App Dockerfile
```dockerfile
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY src/Main.java /app/Main.java
RUN javac Main.java
CMD ["java","Main"]
```

### Flask App Dockerfile
```dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT ["python","run.py"]
```

---

> 💡 **Pro Tip:** Always run `docker system prune` after practice sessions to clean up unused images and containers and save disk space!
