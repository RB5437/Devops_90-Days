# 🐳 Docker Networking, Volumes, Compose & Registry

![Docker](https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png)

> **90-Day DevOps Challenge | Day 29 | 11 May 2026**
> Trainer: Shubham Londhe [@TrainWithShubham](https://www.youtube.com/@TrainWithShubham)
> Practiced on: AWS EC2 (Ubuntu) | Project: Two-Tier Flask + MySQL App

---

## ✅ What I Did Today

| # | Task | Status |
|---|------|--------|
| 1 | Docker Networking — types, custom bridge network | ✅ Done |
| 2 | Ran Two-Tier Flask + MySQL app using custom network | ✅ Done |
| 3 | Docker Volumes — created & mounted `mysql-data` volume | ✅ Done |
| 4 | Data persisted even after container restart/remove | ✅ Done |
| 5 | Docker Compose — wrote `docker-compose.yml` for two-tier app | ✅ Done |
| 6 | Fixed YAML errors — volumes mapping, networks mapping | ✅ Done |
| 7 | `docker compose up` — both containers running together | ✅ Done |
| 8 | Docker Registry — tagged & pushed images to Docker Hub | ✅ Done |
| 9 | App accessible on browser at `http://EC2-IP:5000` | ✅ Done |

---

## 🌐 Docker Networking

### Network Types:

| Network Type | Description | Use Case |
|-------------|-------------|----------|
| **bridge** | Default network — containers get their own IP | Single host container communication |
| **host** | Container shares host network directly | When you need host-level network performance |
| **User-defined Bridge** | Custom bridge — containers talk by **name** | Multi-container apps on same host |
| **none** | No network — fully isolated container | Maximum isolation, no network needed |

### Key insight — Why custom network?

```
Default bridge network:
  Container1 (172.17.0.2) ←→ Container2 (172.17.0.3)
  ❌ Can only communicate by IP — IP can change!

Custom bridge network (two-tier):
  flask-container ←→ mysql (by name)
  ✅ Containers talk by container NAME — reliable!
```

### Architecture of today's project:

```
                    [ two-tier network ]
                    172.19.0.0/16
                         │
           ┌─────────────┴──────────────┐
           │                            │
  ┌────────────────┐          ┌─────────────────┐
  │  Flask App     │          │   MySQL DB      │
  │  (172.19.0.3)  │◀────────▶│  (172.19.0.2)   │
  │  Port: 5000    │  network │  Port: 3306     │
  └────────────────┘  name:  └─────────────────┘
         │            mysql          │
  http://EC2-IP:5000           mysql-data (volume)
  [Browser accessible]         [Data persisted]
```

---

## 💾 Docker Volumes & Storage

### Why Volumes?

```
Without volume:
  Container removed → ALL DATA LOST ❌

With volume:
  Container removed → Data safe in volume ✅
  New container → Attach same volume → Data restored ✅
```

### Storage types:

| Type | Command | Data location | Use Case |
|------|---------|--------------|----------|
| **Volume** | `-v mysql-data:/var/lib/mysql` | `/var/lib/docker/volumes/` | Databases, persistent data |
| **Bind Mount** | `-v /host/path:/container/path` | Any host directory | Dev — live code reload |
| **tmpfs** | `--tmpfs /tmp` | RAM only | Sensitive temp data |

### Volume lifecycle:
```
docker volume create mysql-data          → Created
docker run -v mysql-data:/var/lib/mysql  → Attached
docker stop + docker rm mysql            → Container gone but data SAFE
docker run -v mysql-data:/var/lib/mysql  → New container, old data restored ✅
```

---

## 🐙 Docker Compose

### What is Docker Compose?
- Tool to define and run **multi-container** Docker apps
- Single YAML file = all services + networks + volumes
- One command to start everything: `docker compose up`

### docker-compose.yml (today's project):

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

### Errors I fixed today:

| Error | Cause | Fix |
|-------|-------|-----|
| `volumes must be a mapping` | `mysql-data` without colon | Changed to `mysql-data:` |
| `networks must be a mapping` | `two-tier` without colon | Changed to `two-tier:` |
| `version is obsolete` | Old compose format | Can remove `version:` line |
| Flask exits before MySQL ready | Race condition | MySQL needs time to start |

---

## 🏪 Docker Registry

### What is Docker Registry?
- Storage for Docker images
- **Docker Hub** = public registry (like GitHub for images)
- Can also run private registry

### Flow:

```
Local Image
     ↓  docker image tag
Tagged Image (username/imagename:tag)
     ↓  docker push
Docker Hub Registry ✅
     ↓  docker pull (from anywhere)
Any machine in the world
```

### Images pushed today:
- `ritik2909/mysql:latest` → [Docker Hub](https://hub.docker.com/u/ritik2909)
- `ritik2909/two-tier-flask-app-flask:v2` → [Docker Hub](https://hub.docker.com/u/ritik2909)

---

## 🧪 Project — Two-Tier Flask + MySQL App

**Repo:** [two-tier-flask-app](https://github.com/LondheShubham153/two-tier-flask-app)

### What the app does:
- **Flask** = frontend + backend (Python web app)
- **MySQL** = database stores messages
- User types a message → Flask saves to MySQL → Displays all messages

### App running on browser:
> `http://54.162.250.117:5000` — Flask + MySQL App [2 tier] — Junoon 🔥

### Data verified in MySQL:
```sql
mysql> use devops;
mysql> select * from messages;
+----+--------------+
| id | message      |
+----+--------------+
|  1 | hello        |
|  2 | good morning |
+----+--------------+
```

---

## 📅 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27 | 9 May 2026 | Virtualization vs Containerization, Docker Architecture | ✅ Done |
| Day 28 | 10 May 2026 | Install Docker, Dockerfile, Java App, Flask App | ✅ Done |
| Day 29 | 11 May 2026 | Docker Networking, Volumes, Compose, Registry | ✅ Done |
| Day 30 | 12 May 2026 | Docker Registry & Multi-stage Builds | ⬜ Pending |
| Day 31 | 13 May 2026 | Mini Project 1 — Push to Docker Hub | ⬜ Pending |
| Day 32 | 14 May 2026 | Mini Project 2 — Push to Docker Hub | ⬜ Pending |

---

## 🔗 Resources

| Resource | Link |
|----------|------|
| 🎥 Docker One Shot — Shubham Londhe | [YouTube](https://www.youtube.com/watch?v=9bSbNNH4Nqw) |
| 📺 TrainWithShubham Channel | [YouTube](https://www.youtube.com/@TrainWithShubham) |
| 💻 two-tier-flask-app Repo | [GitHub](https://github.com/LondheShubham153/two-tier-flask-app) |
| 🐳 My Docker Hub | [ritik2909](https://hub.docker.com/u/ritik2909) |
| 📖 Docker Compose Docs | [docs.docker.com/compose](https://docs.docker.com/compose/) |

---

## 👤 About Me

**Ritik Bawane**
- 🎯 90-Day DevOps Challenge — Day 29/90
- 💼 Ex-Kyndryl | 3.4 Years Experience | Technical Engineer
- 🏅 AWS Solutions Architect Associate Certified
- 🏅 RHCSA Certified
- 🔗 [GitHub](https://github.com/RB5437)

---

*⭐ If this helped you, give the repo a star!*

*Progress: Linux ✅ | Networking ✅ | Shell Scripting ✅ | Git/GitHub ✅ | AWS ✅ | Docker 🔄 | Jenkins ⬜ | Terraform ⬜ | Kubernetes ⬜*
