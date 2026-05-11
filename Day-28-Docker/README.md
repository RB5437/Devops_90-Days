# 🐳 Introduction to Docker & Docker Architecture

![Docker](https://www.docker.com/wp-content/uploads/2022/03/vertical-logo-monochromatic.png)

---

## 🚀 What is Docker?

Docker is an open-source platform used to develop, package, ship, and run applications inside lightweight **containers**.

Containers allow developers to package applications with all dependencies, libraries, and configurations so the application runs consistently across all environments.

---

## 🔥 Why Docker?

Before Docker, applications worked differently on different systems because of dependency and environment issues.

Docker solves this problem by using **containers**.

### ✅ Benefits of Docker:
- Lightweight
- Faster deployment
- Easy scalability
- Portable applications
- Consistent environments
- Better resource utilization
- Easy CI/CD integration

---

## 🖥️ Virtualization vs Containerization

### ▶ Virtualization

Virtualization uses a **Hypervisor** to create multiple Virtual Machines (VMs).

Each VM contains:
- Full Operating System
- Application
- Required Libraries

#### Architecture:
```
Hardware
  └── Host Operating System
        └── Hypervisor
              ├── Virtual Machine 1
              │     ├── Guest OS
              │     └── Application
              ├── Virtual Machine 2
              │     ├── Guest OS
              │     └── Application
              └── Virtual Machine 3
                    ├── Guest OS
                    └── Application
```

#### ❌ Disadvantages:
- Heavyweight
- High RAM and CPU usage
- Slow boot time
- Requires full OS for every VM

---

### ▶ Containerization

Containerization uses a **Container Engine** like Docker.

Containers share the **Host OS kernel**.

#### Architecture:
```
Hardware
  └── Host Operating System (Linux Kernel — shared)
        └── Docker Engine (Container Runtime)
              ├── Container 1
              │     └── App + Libraries
              ├── Container 2
              │     └── App + Libraries
              └── Container 3
                    └── App + Libraries
```

#### ✅ Advantages:
- Lightweight
- Fast startup (seconds)
- Less resource usage
- Portable across environments
- Shares Host OS — no separate OS per container

---

## ⚖️ VM vs Container — Comparison Table

| Feature | Virtual Machine | Container |
|---------|----------------|-----------|
| OS | Own OS per VM | Shares Host OS Kernel |
| Size | GBs | MBs |
| Boot Time | Minutes | Seconds |
| Performance | Slower | Faster |
| Isolation | Strong (full OS) | Process-level |
| Portability | Less portable | Highly portable |
| Resource Usage | High | Low |
| Tools | VMware, VirtualBox, Hyper-V | Docker, Podman, Containerd |

---

## 🏗️ Docker Architecture

Docker follows a **Client-Server architecture**.

```
┌─────────────────────────────────────────────────────────────┐
│                      DOCKER ENGINE                          │
│                                                             │
│   ┌─────────────┐   REST API   ┌──────────────────────┐    │
│   │  Docker CLI │ ──────────▶  │  Docker Daemon       │    │
│   │  (Client)   │              │  (dockerd)           │    │
│   │             │              │                      │    │
│   │ docker run  │              │  ┌────────────────┐  │    │
│   │ docker build│              │  │  containerd    │  │    │
│   │ docker ps   │              │  │  (runtime)     │  │    │
│   └─────────────┘              │  └────────────────┘  │    │
│                                └──────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                                          │
                    ┌─────────────────────┼──────────────────────┐
                    ▼                     ▼                      ▼
             Container 1           Container 2            Container 3
```

### Components:

| Component | Description |
|-----------|-------------|
| **Docker Client (CLI)** | Interface you use to type commands — `docker run`, `docker build`, `docker ps` |
| **Docker Daemon (dockerd)** | Background service that manages containers, images, networks, volumes |
| **containerd** | Low-level container runtime — actually creates and manages containers |
| **REST API** | Communication bridge between Docker CLI and Docker Daemon |
| **Docker Registry (Hub)** | Stores Docker images — public registry at [hub.docker.com](https://hub.docker.com) |

### How a command flows:
```
You type: docker run nginx
        ↓
Docker CLI sends request → REST API → Docker Daemon
        ↓
Docker Daemon checks if image exists locally
        ↓  (if not found)
Pulls image from Docker Hub (Registry)
        ↓
Passes to containerd → creates and starts container
        ↓
Container is running! ✅
```

---

## 📦 Dockerfile → Image → Container

```
┌─────────────────┐        ┌─────────────────┐        ┌─────────────────┐
│                 │        │                 │        │                 │
│   Dockerfile    │─build─▶│     Image       │─run──▶ │   Container     │
│                 │        │                 │        │                 │
│  Instructions   │        │  Blueprint /    │        │ Running Instance │
│  to build image │        │  Answer Script  │        │  of the image   │
│                 │        │  (Read-only)    │        │                 │
└─────────────────┘        └─────────────────┘        └─────────────────┘
```

- **Dockerfile** = Text file with step-by-step instructions to build image
- **Image** = Read-only blueprint (snapshot) created from Dockerfile
- **Container** = Live running instance of an image — one image → many containers

---

## 📄 Dockerfile — Key Instructions

```dockerfile
# Base image to start from
FROM ubuntu:22.04

# Set working directory inside container
WORKDIR /app

# Copy files from host machine to container
COPY . .

# Run commands during image BUILD time
RUN apt-get update && apt-get install -y python3

# Set environment variable
ENV APP_ENV=production

# Document which port app listens on
EXPOSE 5000

# Default command when container starts (can be overridden)
CMD ["python3", "app.py"]

# Main command — always runs, harder to override
ENTRYPOINT ["python3", "app.py"]
```

### CMD vs ENTRYPOINT:

| | CMD | ENTRYPOINT |
|-|-----|------------|
| Can be overridden at runtime? | ✅ Yes | ❌ No (harder) |
| Use case | Default arguments | Main process that always runs |

---

## ⚡ Basic Docker Commands

### Image Commands:
```bash
docker images                        # List all local images
docker pull nginx                    # Pull image from Docker Hub
docker pull ubuntu:22.04             # Pull specific version
docker rmi nginx                     # Remove image
docker build -t myapp:v1 .           # Build image from Dockerfile
docker push username/myapp:v1        # Push image to Docker Hub
```

### Container Commands:
```bash
docker run nginx                     # Run container (foreground)
docker run -d nginx                  # Run in background (detached)
docker run -d -p 8080:80 nginx       # Map port  →  host:container
docker run -d --name myapp nginx     # Run with custom name
docker run -it ubuntu bash           # Interactive terminal
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql   # Pass env variable

docker ps                            # List running containers
docker ps -a                         # List all containers
docker stop myapp                    # Stop container (graceful)
docker start myapp                   # Start stopped container
docker restart myapp                 # Restart container
docker rm myapp                      # Remove stopped container
docker rm -f myapp                   # Force remove running container

docker logs myapp                    # View container logs
docker logs -f myapp                 # Follow logs live
docker exec -it myapp bash           # Enter running container
docker inspect myapp                 # Inspect container details
docker stats                         # Live CPU/RAM usage
```

### Cleanup Commands:
```bash
docker system prune                  # Remove all unused data
docker system df                     # Check disk usage
docker volume prune                  # Remove unused volumes
```

---

## 🛠️ Installing Docker on Ubuntu (EC2)

```bash
# Step 1 — Update packages
sudo apt-get update

# Step 2 — Install Docker
sudo apt-get install docker.io -y

# Step 3 — Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker         # Should show: active (running) ✅

# Step 4 — Fix permission denied error
sudo usermod -aG docker $USER
newgrp docker

# Step 5 — Verify installation
docker --version
docker run hello-world
```

---

## 🧪 Projects Practiced Today

### 🟡 Project 1 — Java App Container
**Repo:** [simple-java-docker](https://github.com/RB5437/simple-java-docker)

```dockerfile
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY src/Main.java /app/Main.java
RUN javac Main.java
CMD ["java","Main"]
```

```bash
docker build -t java-app .
docker run java-app
# Output: Hello, Docker! Current date: Sun May 10 08:51:56 GMT 2026 ✅
```

---

### 🟢 Project 2 — Flask App Container
**Repo:** [flask-app-ecs](https://github.com/RB5437/flask-app-ecs)

```dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT ["python","run.py"]
```

```bash
docker build -t flask-app .
docker run -d -p 80:80 flask-app
# Accessible at: http://<EC2-Public-IP>:80 ✅
```

---

## 📅 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27 | 9 May 2026 | Virtualization vs Containerization, Docker Architecture | ✅ Done |
| Day 28 | 10 May 2026 | Install Docker, Dockerfile, Java App, Flask App | ✅ Done |
| Day 29 | 11 May 2026 | Docker Volumes & Networking & Docker Compose | ⬜ Pending |
| Day 30 | 12 May 2026 | Docker Registry & Multi-stage Builds  | ⬜ Pending |
| Day 31 | 13 May 2026 |Mini Project1 — Push to Docker Hub | ⬜ Pending |
| Day 32 | 14 May 2026 | Mini Project2 — Push to Docker Hub | ⬜ Pending |

---

## 🔗 Resources

| Resource | Link |
|----------|------|
| 🎥 Docker One Shot — Shubham Londhe | [YouTube](https://www.youtube.com/watch?v=9bSbNNH4Nqw) |
| 📺 TrainWithShubham Channel | [YouTube](https://www.youtube.com/@TrainWithShubham) |
| 📖 Docker Official Docs | [docs.docker.com](https://docs.docker.com) |
| 🐳 Docker Hub | [hub.docker.com](https://hub.docker.com) |
| 💻 LondheShubham153 GitHub | [GitHub](https://github.com/LondheShubham153) |

---

## 👤 About Me

**Ritik Bawane**
- 🎯 90-Day DevOps Challenge — Day 28/90
- 💼 Ex-Kyndryl | 3.4 Years Experience | Technical Engineer
- 🏅 AWS Solutions Architect Associate Certified
- 🏅 RHCSA Certified
- 🔗 [GitHub](https://github.com/RB5437)

---

*⭐ If this helped you, give the repo a star!*

*Progress: Linux ✅ | Networking ✅ | Shell Scripting ✅ | Git/GitHub ✅ | AWS ✅ | Docker 🔄 | Jenkins ⬜ | Terraform ⬜ | Kubernetes ⬜*
