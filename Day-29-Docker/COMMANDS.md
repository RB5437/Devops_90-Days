# ⚡ Docker Commands — Day 29 
> Networking + Volumes + Compose + Registry |

---

## 🌐 Docker Network Commands

```bash
# List all networks
docker network ls

# Create custom bridge network
docker network create mynetwork -d bridge
docker network create two-tier -d bridge

# Inspect network (see connected containers + IPs)
docker network inspect two-tier

# Remove network
docker network rm mynetwork

# Remove all unused networks
docker network prune

# Connect running container to network
docker network connect two-tier mycontainer

# Disconnect container from network
docker network disconnect two-tier mycontainer
```

---

## 💾 Docker Volume Commands

```bash
# List all volumes
docker volume ls

# Create a named volume
docker volume create mysql-data

# Inspect volume (see mountpoint on host)
docker volume inspect mysql-data

# Remove a volume
docker volume rm mysql-data

# Remove all unused volumes
docker volume prune

# Run container with named volume
docker run -d -v mysql-data:/var/lib/mysql mysql:8.0

# Run container with bind mount (map host dir to container)
docker run -d -v /home/ubuntu/data:/app/data nginx

# Run container with read-only bind mount
docker run -d -v /home/ubuntu/data:/app/data:ro nginx
```

---

## 🚀 Today's Exact Practice Commands

### Step 1 — Create custom network
```bash
docker network create two-tier -d bridge
docker network ls
```

### Step 2 — Clone the project
```bash
mkdir project && cd project
git clone https://github.com/LondheShubham153/two-tier-flask-app.git
cd two-tier-flask-app
```

### Step 3 — Build Flask backend image
```bash
docker build -t two-tier-backend .
docker images
```

### Step 4 — Pull MySQL image
```bash
docker pull mysql:8.0
```

### Step 5 — Run MySQL container on custom network
```bash
docker run -d \
  --name mysql \
  --network two-tier \
  -e MYSQL_ROOT_PASSWORD=devops \
  -e MYSQL_DATABASE=devops \
  mysql:8.0
```

### Step 6 — Run Flask container on same network
```bash
docker run -d \
  -p 5000:5000 \
  --network two-tier \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=devops \
  -e MYSQL_DB=devops \
  two-tier-backend:latest
```

### Step 7 — Verify both containers running
```bash
docker ps
docker logs <flask_container_id>
docker network inspect two-tier
```

### Step 8 — Enter MySQL container and verify data
```bash
docker exec -it <mysql_container_id> bash
mysql -u root -p
# enter password: devops
show databases;
use devops;
select * from messages;
exit
exit
```

---

## 💾 Volume Practice Commands

```bash
# Create named volume
docker volume create mysql-data
docker volume ls
docker volume inspect mysql-data

# Run MySQL with volume attached
docker run -d \
  --name mysql \
  --network two-tier \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  mysql:8.0

# Stop and remove container — data stays in volume
docker stop mysql
docker rm mysql

# Run new container — old data restored!
docker run -d \
  --name mysql \
  --network two-tier \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  mysql:8.0
```

---

## 🐙 Docker Compose Commands

### Install Docker Compose (if not installed)
```bash
sudo apt install docker-compose -y
# OR for v2
sudo apt install docker-compose-v2 -y

# Verify
docker compose version
```

### docker-compose.yml (today's working file)
```yaml
version: "3.8"

services:
  mysql:
    image: mysql
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: devops
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - two-tier

  flask:
    build:
      context: .
    container_name: two-tier-backend
    ports:
      - "5000:5000"
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: root
      MYSQL_DB: devops
    networks:
      - two-tier

volumes:
  mysql-data:

networks:
  two-tier:
```

### Compose run commands
```bash
# Start all services (foreground — see logs)
docker compose up

# Start all services in background
docker compose up -d

# Stop and remove all containers + networks
docker compose down

# Stop and remove + delete volumes too
docker compose down -v

# View logs
docker compose logs

# Follow logs live
docker compose logs -f

# List running services
docker compose ps

# Restart a service
docker compose restart flask

# Enter a service container
docker compose exec flask bash

# Build images only
docker compose build

# Build and start
docker compose up --build -d
```

---

## 🏪 Docker Registry Commands

### Login to Docker Hub
```bash
# Web-based login
docker login

# Login with username
docker login -u ritik2909

# Logout
docker logout
```

### Tag image for Docker Hub
```bash
# Format: docker image tag LOCAL_IMAGE USERNAME/IMAGENAME:TAG

docker image tag mysql:latest ritik2909/mysql:latest
docker image tag two-tier-flask-app-flask:latest ritik2909/two-tier-flask-app-flask:v2

# Verify
docker images
```

### Push to Docker Hub
```bash
docker push ritik2909/mysql:latest
docker push ritik2909/two-tier-flask-app-flask:v2
```

### Pull from Docker Hub (on any machine)
```bash
docker pull ritik2909/mysql:latest
docker pull ritik2909/two-tier-flask-app-flask:v2
```

---

## 🧹 Cleanup Commands

```bash
# Remove all stopped containers, unused networks, dangling images, build cache
docker system prune

# Remove everything including unused images
docker system prune -a

# Remove everything including volumes (⚠️ careful — deletes data!)
docker system prune -a --volumes

# Check disk usage
docker system df

# Force remove running container
docker rm -f <container_id>

# Remove all containers
docker rm -f $(docker ps -aq)

# Remove all images
docker rmi -f $(docker images -q)
```

---

## ❌ Common Mistakes & Fixes

```bash
# ❌ Wrong — 'docker images' ≠ 'docker image'
docker images tag mysql:latest ritik2909/mysql
# Error: 'docker images' requires at most 1 argument

# ✅ Correct
docker image tag mysql:latest ritik2909/mysql

# ❌ Wrong — two colons in tag
docker image tag flask:latest ritik2909/flask:latest:v2
# Error: invalid reference format

# ✅ Correct
docker image tag flask:latest ritik2909/flask:v2

# ❌ Wrong — stop and rm at same time (race condition)
docker stop <id> & docker rm <id>
# Error: cannot remove running container

# ✅ Correct — stop first, then remove
docker stop <id> && docker rm <id>
# OR force remove in one command
docker rm -f <id>

# ❌ Wrong — using image tag as hostname
-e MYSQL_HOST=mysql:latest
# Error: Unknown server host 'mysql:latest' (-2)

# ✅ Correct — use container NAME as hostname
-e MYSQL_HOST=mysql
```

---

## 📝 Today's Practice Log (exact commands run)

```bash
# Network
docker network ls
docker network create mynetwork -d bridge
docker network create two-tier -d bridge

# Clone & build
git clone https://github.com/LondheShubham153/two-tier-flask-app.git
cd two-tier-flask-app
docker build -t two-tier-backend .
docker pull mysql:8.0

# Run with network
docker run -d --name mysql --network two-tier \
  -e MYSQL_ROOT_PASSWORD=devops -e MYSQL_DATABASE=devops mysql:8.0

docker run -d -p 5000:5000 --network two-tier \
  -e MYSQL_HOST=mysql -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=devops -e MYSQL_DB=devops \
  two-tier-backend:latest

# Verify
docker ps
docker network inspect two-tier
docker exec -it <mysql_id> bash → mysql -u root -p → select * from messages;

# Volume
docker volume create mysql-data
docker volume inspect mysql-data
docker run -d --name mysql --network two-tier \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=devops mysql:8.0

# Compose
sudo apt install docker-compose-v2 -y
docker compose up
docker compose up -d
docker compose down

# Registry
docker login -u ritik2909
docker image tag mysql:latest ritik2909/mysql:latest
docker image tag two-tier-flask-app-flask:latest ritik2909/two-tier-flask-app-flask:v2
docker push ritik2909/mysql:latest
docker push ritik2909/two-tier-flask-app-flask:v2

# Cleanup
docker system prune
```

> 💡 **Pro Tip:** Always use `docker rm -f` to force-remove containers instead of stop + rm separately. Saves time and avoids race condition errors!
