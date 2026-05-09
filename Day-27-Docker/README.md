# 🚀 Introduction to Docker & Docker Architecture

![Docker](https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png)

## 📌 What is Docker?

Docker is an open-source platform used to develop, package, ship, and run applications inside lightweight containers.

Containers allow developers to package applications with all dependencies, libraries, and configurations so the application runs consistently across all environments.

---

# 🔥 Why Docker?

Before Docker, applications worked differently on different systems because of dependency and environment issues.

Docker solves this problem by using **containers**.

### ✅ Benefits of Docker

- Lightweight
- Faster deployment
- Easy scalability
- Portable applications
- Consistent environments
- Better resource utilization
- Easy CI/CD integration

---

# 🖥️ Virtualization vs Containerization

## 🔹 Virtualization

Virtualization uses a **Hypervisor** to create multiple Virtual Machines (VMs).

Each VM contains:
- Full Operating System
- Application
- Required Libraries

### Architecture

```text
Hardware
   ↓
Host Operating System
   ↓
Hypervisor
   ↓
Virtual Machines
   ↓
Applications
```

### ❌ Disadvantages
- Heavyweight
- High RAM and CPU usage
- Slow boot time
- Requires full OS for every VM

---

## 🔹 Containerization

Containerization uses a **Container Engine** like Docker.

Containers share the host OS kernel.

### Architecture

```text
Hardware
   ↓
Host Operating System
   ↓
Docker Engine
   ↓
Containers
   ↓
Applications
```

### ✅ Advantages
- Lightweight
- Fast startup
- Less memory usage
- Portable
- Efficient resource usage

---

# 🐳 Docker Architecture

Docker uses a client-server architecture.

## Components of Docker

### 1️⃣ Docker Client

The Docker Client is the command-line interface used by users.

Example:

```bash
docker run nginx
```

---

### 2️⃣ Docker Daemon (dockerd)

The Docker daemon runs in the background and manages:

- Containers
- Images
- Networks
- Volumes

---

### 3️⃣ Docker Engine

Docker Engine is the core component that allows Docker to run containers.

It includes:
- Docker Daemon
- REST API
- Docker CLI

---

### 4️⃣ Docker Images

Docker Images are read-only templates used to create containers.

Example:
- Ubuntu Image
- Nginx Image

---

### 5️⃣ Docker Containers

Containers are running instances of Docker images.

Example:

```bash
docker run ubuntu
```

---

# 📊 Docker Workflow

```text
Docker Client
      ↓
Docker Daemon
      ↓
Docker Images
      ↓
Docker Containers
```

---

# ⚙️ Install Docker on Ubuntu

## Step 1: Update Packages

```bash
sudo apt update
```

---

## Step 2: Install Required Packages

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```

---

## Step 3: Add Docker GPG Key

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

---

## Step 4: Add Docker Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## Step 5: Install Docker

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
```

---

## Step 6: Verify Docker Installation

```bash
docker --version
```

---

# ▶️ Start Docker Service

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Check status:

```bash
sudo systemctl status docker
```

---

# 👤 Run Docker Without sudo

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

# 🧪 Test Docker

Run Hello World container:

```bash
docker run hello-world
```

---

# 📦 Basic Docker Commands

## Check Docker Version

```bash
docker --version
```

## Pull Image

```bash
docker pull nginx
```

## Run Container

```bash
docker run -d -p 80:80 nginx
```

## List Running Containers

```bash
docker ps
```

## List All Containers

```bash
docker ps -a
```

## Stop Container

```bash
docker stop <container_id>
```

## Remove Container

```bash
docker rm <container_id>
```

## Remove Image

```bash
docker rmi <image_id>
```

---

# 📁 Docker Use Cases

- Application Deployment
- Microservices
- CI/CD Pipelines
- DevOps Automation
- Cloud-native Applications
- Kubernetes
- Testing Environments

---

# 📚 Key Learnings

✅ Difference between Virtualization and Containerization  
✅ Docker Architecture  
✅ Docker Components  
✅ Installing Docker on Ubuntu  
✅ Running Containers  
✅ Basic Docker Commands  

---

# 📖 Official Documentation

- Docker Official Website: https://www.docker.com/
- Docker Documentation: https://docs.docker.com/
- Docker Hub: https://hub.docker.com/

---

# 🏷️ Tags

`Docker` `DevOps` `Containerization` `Linux` `Docker Engine` `Docker Architecture` `Cloud Computing`

---

# ✨ Author

Learning Docker & DevOps 🚀
