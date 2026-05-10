# 📝 Docker Notes — Day 28
> 10 May 2026 | Shubham Londhe One Shot

---

## 1. Installing Docker on Ubuntu (EC2)

### Method 1 — Using apt (what I did today)
```bash
sudo apt-get update
sudo apt-get install docker.io -y
```

What gets installed automatically with `docker.io`:
- `containerd` — container runtime
- `runc` — OCI container runtime
- `bridge-utils` — network bridge tools
- `dnsmasq-base` — DNS for containers
- `pigz` — parallel gzip (for layer compression)
- `ubuntu-fan` — Ubuntu fan networking

### Method 2 — Official Docker install (recommended for production)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### Start & enable Docker service
```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker        # Should show: active (running)
```

---

## 2. Permission Denied Fix

**Problem:**
```
permission denied while trying to connect to the Docker API
at unix:///var/run/docker.sock
```

**Why it happens:**  
Docker socket (`/var/run/docker.sock`) is owned by `root` and the `docker` group.  
Your user (`ubuntu`) is not in the `docker` group by default.

**Fix:**
```bash
sudo usermod -aG docker $USER       # Add current user to docker group
newgrp docker                       # Apply group change without logout
docker ps                           # Now works without sudo ✅
```

> 💡 `usermod -aG` = append user to Group (without removing from other groups)

---

## 3. Docker Hub Login

```bash
docker login                        # Opens browser-based login (web code)
docker login -u <username>          # Login with username + password in terminal
```

**After login**, credentials stored at:
```
/home/ubuntu/.docker/config.json
```
> ⚠️ Warning: Credentials stored unencrypted — use credential helper in production

---

## 4. Dockerfile — Deep Dive

### What is a Dockerfile?
- A plain text file named `Dockerfile` (no extension)
- Contains step-by-step instructions to build a Docker image
- Each instruction = one layer in the image

### Key Instructions:

| Instruction | What it does | Example |
|-------------|-------------|---------|
| `FROM` | Base image to start from | `FROM python:3.10` |
| `WORKDIR` | Set working directory inside container | `WORKDIR /app` |
| `COPY` | Copy files from host → container | `COPY . .` |
| `RUN` | Execute command during build | `RUN pip install flask` |
| `CMD` | Default command when container starts (overridable) | `CMD ["python","app.py"]` |
| `ENTRYPOINT` | Main command (harder to override than CMD) | `ENTRYPOINT ["python","run.py"]` |
| `EXPOSE` | Document which port app listens on | `EXPOSE 80` |
| `ENV` | Set environment variable | `ENV MYSQL_ROOT_PASSWORD=root` |

### CMD vs ENTRYPOINT:
```
CMD      → Can be overridden: docker run myimage python other.py
ENTRYPOINT → Always runs: docker run myimage (ENTRYPOINT always executes)
```

---

## 5. Java App — Dockerfile Explained

```dockerfile
# Step 1: Pull base image with JDK 17 on Alpine Linux (small size)
FROM eclipse-temurin:17-jdk-alpine

# Step 2: Create /app directory inside container
WORKDIR /app

# Step 3: Copy Main.java from your machine to /app/ inside container
COPY src/Main.java /app/Main.java

# Step 4: Compile the Java file during build
RUN javac Main.java

# Step 5: Run the compiled Java app when container starts
CMD ["java", "Main"]
```

**Why `eclipse-temurin:17-jdk-alpine`?**
- `eclipse-temurin` = Adoptium's JDK distribution (open-source)
- `17` = Java 17 (LTS version)
- `alpine` = Smallest Linux base — keeps image size small (~512MB vs ~1GB)

**Build & run:**
```bash
docker build -t java-app .
docker run java-app
# Output: Hello, Docker! Current date: Sun May 10 08:51:56 GMT 2026
```

---

## 6. Flask App — Dockerfile Explained

```dockerfile
# Step 1: Python 3.10 base image
FROM python:3.10

# Step 2: Set working directory
WORKDIR /app

# Step 3: Copy all files from current directory to /app in container
COPY . .

# Step 4: Install Python dependencies
RUN pip install -r requirements.txt

# Step 5: Start Flask app (ENTRYPOINT = always runs this)
ENTRYPOINT ["python", "run.py"]
```

**Why ENTRYPOINT here instead of CMD?**  
Flask app should always start with `python run.py` — ENTRYPOINT ensures this.

**Build & run:**
```bash
docker build -t flask-app .
docker run -d -p 80:80 flask-app
```

**Port mapping explained:**
```
-p 80:80
    │   └── Container port (Flask listens on 80 inside container)
    └────── Host port (accessible from browser at http://EC2-IP:80)
```

---

## 7. Docker Image Layers

Every Dockerfile instruction creates a **layer**:
```
Layer 5: CMD ["java","Main"]          ← top layer
Layer 4: RUN javac Main.java
Layer 3: COPY src/Main.java /app/
Layer 2: WORKDIR /app
Layer 1: FROM eclipse-temurin:17      ← base layer
```

**Why layers matter:**
- Layers are **cached** — if nothing changed, Docker reuses the cached layer
- Makes rebuilds FAST — only changed layers are rebuilt
- Put `COPY` and `RUN pip install` after stable instructions for better caching

---

## 8. Environment Variables in Docker

```bash
# Pass env variable at runtime
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql

# Why needed for MySQL?
# MySQL image requires root password to be set
# Without it → container exits immediately with error
```

---

## 9. Entering a Running Container

```bash
docker exec -it ce5f543fb57c bash
```

- `exec` = run a command inside running container
- `-i` = interactive (keeps STDIN open)
- `-t` = allocate a terminal (TTY)
- `bash` = command to run (opens bash shell)

Once inside:
```bash
ls              # see container filesystem
cat app.py      # read files
exit            # come back to host
```

---

## 10. What I Observed Today

| Observation | Learning |
|-------------|----------|
| `docker run hello-world` printed steps 1-4 explaining its own flow | Understood Docker CLI → Daemon → Hub → Container flow clearly |
| MySQL image = 1.3GB, hello-world = 25.9KB | Size difference between real app and test image |
| `docker run -d` vs `docker run` | `-d` = detached/background, without it = foreground (blocks terminal) |
| Flask app running on `0.0.0.0:80` | Means accessible from ALL network interfaces — not just localhost |
| `docker exec -it` enters live container | Can debug, check files without stopping container |
| Legacy builder deprecation warning | Need to install `buildx` for newer builds |
