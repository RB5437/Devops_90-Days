# 📝 Docker Notes — Day 29
> 11 May 2026 | Networking + Volumes + Compose + Registry

---

## 1. Docker Networking — Deep Dive

### Default Networks (created automatically):
```bash
docker network ls
# NETWORK ID     NAME      DRIVER    SCOPE
# dc02eecbfd23   bridge    bridge    local   ← default
# d6de4e1701d5   host      host      local
# e688c7b4fcc0   none      null      local
```

### Network Types Explained:

#### 🔹 bridge (default)
- Every container gets its own IP (e.g., 172.17.0.2)
- Containers can communicate via IP only
- **Problem:** IP can change — unreliable for service discovery
```bash
docker run -d nginx   # automatically uses bridge network
```

#### 🔹 host
- Container uses HOST machine's network directly
- No port mapping needed — container port = host port
- Less isolation
```bash
docker run -d --network host nginx
# nginx accessible at host's IP directly, no -p needed
```

#### 🔹 User-defined Bridge (Custom) ← Most important!
- You create it: `docker network create mynet -d bridge`
- Containers talk by **container NAME** (DNS resolution built-in)
- This is why Flask could reach MySQL using hostname `mysql`
```bash
docker network create two-tier -d bridge
docker run --name mysql --network two-tier mysql:8.0
docker run --name flask --network two-tier flask-app
# flask container can reach mysql by typing: mysql (not IP)
```

#### 🔹 none
- No network interface — completely isolated
- Used for batch jobs or max security containers
```bash
docker run --network none ubuntu
```

---

### Why Flask couldn't connect to MySQL — mistakes made today:

| Attempt | Command | Error | Reason |
|---------|---------|-------|--------|
| 1 | `docker run flask-app` | `Can't connect to socket '/run/mysqld/mysqld.sock'` | MySQL container not running |
| 2 | `-e MYSQL_HOST=mysql` without network | `Unknown server host 'mysql' (-2)` | Containers on different networks — can't resolve name |
| 3 | `-e MYSQL_HOST=mysql:latest` | `Unknown server host 'mysql:latest' (-2)` | `:latest` is image tag, NOT hostname |
| 4 | Both on `two-tier` network, `-e MYSQL_HOST=mysql` | ✅ Connected! | Same network + correct hostname = works |

**Key lesson:** `MYSQL_HOST` = container **name**, not image name or tag!

---

## 2. Docker Volumes — Deep Dive

### Problem without volumes:
```
docker run mysql          → data stored in container layer
docker stop mysql         → container stopped
docker rm mysql           → container DELETED
                          → ALL MySQL data GONE forever ❌
```

### Solution — Named Volume:
```
docker volume create mysql-data
docker run -v mysql-data:/var/lib/mysql mysql
docker rm mysql           → container deleted
                          → volume mysql-data STILL EXISTS ✅
docker run -v mysql-data:/var/lib/mysql mysql
                          → NEW container, OLD data! ✅
```

### Volume inspect output (what I saw today):
```json
{
    "CreatedAt": "2026-05-11T09:17:47Z",
    "Driver": "local",
    "Mountpoint": "/var/lib/docker/volumes/mysql-data/_data",
    "Name": "mysql-data",
    "Scope": "local"
}
```
> Data physically stored at: `/var/lib/docker/volumes/mysql-data/_data` on the HOST

### Anonymous volumes (auto-created):
```
8f97b00746f0e1c6fb981e08db55e9cd...   ← ugly random name
da8764cf6ae15277a37cb098b7f4eb47...   ← ugly random name
```
These are created automatically when you use `docker run mysql` without `-v`.
They're hard to manage — always use **named volumes** instead!

### Volume types comparison:

```
Named Volume:
  -v mysql-data:/var/lib/mysql
  → Managed by Docker, easy to reference by name

Bind Mount:
  -v /home/ubuntu/data:/app/data
  → Maps host directory directly, good for development

tmpfs:
  --tmpfs /app/temp
  → In-memory only, lost on restart, good for sensitive data
```

---

## 3. Docker Compose — Deep Dive

### What problem does it solve?

Without Compose (manual commands):
```bash
docker network create two-tier -d bridge
docker volume create mysql-data
docker run -d --name mysql --network two-tier \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  mysql:8.0
docker run -d --name flask --network two-tier \
  -p 5000:5000 \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=devops \
  two-tier-backend:latest
```

With Compose (one command):
```bash
docker compose up -d    # starts everything ✅
docker compose down     # stops everything ✅
```

### YAML errors I hit and fixed:

**Error 1:** `volumes must be a mapping`
```yaml
# ❌ Wrong
volumes:
   mysql-data          # no colon

# ✅ Fixed
volumes:
  mysql-data:           # colon needed
```

**Error 2:** `networks must be a mapping`
```yaml
# ❌ Wrong
networks:
  two-tier             # no colon

# ✅ Fixed
networks:
  two-tier:             # colon needed
```

**Error 3:** `service "mysql" refers to undefined network two-tier`
```yaml
# ❌ Wrong — service uses network but network not defined at bottom
# ✅ Fix — always define networks at the bottom of compose file
networks:
  two-tier:
```

**Error 4:** Flask container exits before MySQL is ready
- Flask starts → tries to connect MySQL → MySQL not ready yet → Flask exits
- Fix: add `depends_on` OR add `restart: on-failure` to flask service

---

## 4. Docker Registry — Deep Dive

### Tagging explained:
```
docker image tag SOURCE_IMAGE DESTINATION_IMAGE

docker image tag mysql:latest ritik2909/mysql:latest
#               └── local image    └── dockerhub: username/imagename:tag

docker image tag two-tier-flask-app-flask:latest ritik2909/two-tier-flask-app-flask:v2
#               └── local image                    └── pushed with version tag v2
```

### Mistakes made today:
```bash
# ❌ Wrong — 'docker images' is not the same as 'docker image'
docker images tag mysql:latest ritik2909/mysql

# ✅ Correct
docker image tag mysql:latest ritik2909/mysql

# ❌ Wrong — can't have two colons in tag
docker image tag flask:latest ritik2909/flask:latest:v2
# error: "ritik2909/flask:latest:v2" is not a valid repository/tag

# ✅ Correct — pick ONE tag
docker image tag flask:latest ritik2909/flask:v2
```

### Push layers — what happened:
```
e9c4cbeb03b4: Pushed           ← your app layer
0525ec23091c: Pushed           ← your dependencies layer
38513bd72563: Mounted from library/python  ← reused from python base image
b3ec39b36ae8: Mounted from library/python  ← reused (not re-uploaded!)
```
> 💡 Docker only uploads NEW layers — base image layers are reused from Hub = fast upload!

---

## 5. Key Observations Today

| Observation | Learning |
|-------------|----------|
| Flask crashed 3 times before MySQL was ready | Containers start simultaneously — add `depends_on` or `restart: on-failure` |
| `docker stop X && docker rm X` at same time caused error | Stop first, then remove — or use `docker rm -f X` |
| `docker build -t mysql .` overwrote mysql image tag | Be careful with image names — don't use official image names! |
| `docker system prune` freed 380.4MB | Always prune after practice to save disk space |
| Flask used `mysql:latest` as hostname → failed | Container name = hostname, not image name |
| Data persisted in MySQL after container restart | Volume working correctly ✅ |
