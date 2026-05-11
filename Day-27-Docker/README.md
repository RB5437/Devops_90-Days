# 🐳 Introduction to Docker & Docker Architecture

![Docker](https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png)

> **90-Day DevOps Challenge | Day 27 | 9 May 2026**
> Trainer: Shubham Londhe [@TrainWithShubham](https://www.youtube.com/@TrainWithShubham)
> Practiced on: AWS EC2 (Ubuntu)

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | What is Docker & Why Docker | ✅ Done |
| 2 | Virtualization vs Containerization | ✅ Done |
| 3 | VM Architecture vs Container Architecture | ✅ Done |
| 4 | Docker Architecture — Client, Daemon, containerd | ✅ Done |
| 5 | Docker Components — Images, Containers, Registry | ✅ Done |
| 6 | Docker Workflow — Client → Daemon → Image → Container | ✅ Done |
| 7 | Installing Docker on Ubuntu (EC2) | ✅ Done |
| 8 | Basic Docker Commands | ✅ Done |

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
- Less memory usage
- Portable across environments
- Shares Host OS — no separate OS per container
- Efficient resource usage

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

> 💡 **Key insight:** Docker Engine does NOT need its own OS — it runs directly on the Host OS. That's why containers are **lightweight!**

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

---

## 📊 Docker Workflow

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

### Simple view:
```
Docker Client
      ↓
Docker Daemon (dockerd)
      ↓
Docker Images (pulled from Hub)
      ↓
Docker Containers (running instances)
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

## ⚙️ Installing Docker on Ubuntu (EC2)

### Method 1 — Quick install using apt (what I used)

```bash
# Step 1 — Update packages
sudo apt-get update

# Step 2 — Install Docker
sudo apt-get install docker.io -y

# Step 3 — Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Step 4 — Check status
sudo systemctl status docker         # Should show: active (running) ✅

# Step 5 — Fix permission denied error
sudo usermod -aG docker $USER
newgrp docker

# Step 6 — Verify installation
docker --version
docker run hello-world
```

### Method 2 — Official Docker CE install

```bash
# Step 1 — Update packages
sudo apt update

# Step 2 — Install required packages
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Step 3 — Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Step 4 — Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5 — Install Docker CE
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Step 6 — Verify
docker --version
```

---

## 📦 Basic Docker Commands

### Image Commands:
```bash
docker images                        # List all local images
docker pull nginx                    # Pull image from Docker Hub
docker pull ubuntu:22.04             # Pull specific version
docker rmi nginx                     # Remove image
docker rmi <image_id>                # Remove by ID
docker build -t myapp:v1 .           # Build image from Dockerfile
docker push username/myapp:v1        # Push image to Docker Hub
```

### Container Commands:
```bash
docker run nginx                     # Run container (foreground)
docker run -d nginx                  # Run in background (detached)
docker run -d -p 80:80 nginx         # Map port — host:container
docker run -d --name myapp nginx     # Run with custom name
docker run -it ubuntu bash           # Interactive terminal

docker ps                            # List running containers
docker ps -a                         # List all containers (running + stopped)
docker stop <container_id>           # Stop container (graceful)
docker start <container_id>          # Start stopped container
docker restart <container_id>        # Restart container
docker rm <container_id>             # Remove stopped container
docker rm -f <container_id>          # Force remove running container

docker logs <container_id>           # View container logs
docker logs -f <container_id>        # Follow logs live
docker exec -it <container_id> bash  # Enter running container
docker inspect <container_id>        # Inspect container details
docker stats                         # Live CPU/RAM usage
```

### Cleanup Commands:
```bash
docker system prune                  # Remove all unused data
docker system df                     # Check disk usage
docker volume prune                  # Remove unused volumes
```

---

## 📁 Docker Use Cases

| Use Case | Description |
|----------|-------------|
| **Application Deployment** | Ship any app consistently across all environments |
| **Microservices** | Run each service in its own isolated container |
| **CI/CD Pipelines** | Build, test, and deploy in containers automatically |
| **DevOps Automation** | Automate infra with Docker + Terraform + Kubernetes |
| **Cloud-native Apps** | Run on AWS ECS, EKS, Google GKE, Azure AKS |
| **Kubernetes** | Docker containers are the base unit for K8s pods |
| **Testing Environments** | Spin up isolated test environments in seconds |

---

## 📚 Key Learnings Today

- ✅ Difference between Virtualization and Containerization
- ✅ Docker Architecture — Client, Daemon, containerd, REST API
- ✅ Docker Components — Images, Containers, Registry
- ✅ Docker Workflow — how `docker run` flows internally
- ✅ Dockerfile → Image → Container flow
- ✅ Installing Docker on Ubuntu EC2
- ✅ Basic Docker Commands

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

## 🏷️ Tags

`Docker` `DevOps` `Containerization` `Linux` `Docker Engine` `Docker Architecture` `Cloud Computing` `90DaysOfDevOps`

---

## 👤 About Me

**Ritik Bawane**
- 🎯 90-Day DevOps Challenge — Day 27/90
- 💼 Ex-Kyndryl | 3.4 Years Experience | Technical Engineer
- 🏅 AWS Solutions Architect Associate Certified
- 🏅 RHCSA Certified
- 🔗 [GitHub](https://github.com/RB5437)

---

*⭐ If this helped you, give the repo a star!*

*Progress: Linux ✅ | Networking ✅ | Shell Scripting ✅ | Git/GitHub ✅ | AWS ✅ | Docker 🔄 | Jenkins ⬜ | Terraform ⬜ | Kubernetes ⬜*
