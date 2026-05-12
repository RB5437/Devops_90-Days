# 📝 Docker Notes — Day 30
> 12 May 2026 | Multi-Stage Builds + Monitoring + Django Project

---

## 1. Multi-Stage Docker Builds — Deep Dive

### The problem with normal builds:
Every `RUN`, `COPY`, `FROM` adds a layer to the image.
Build tools (gcc, pip, compilers) stay in the final image even if not needed at runtime.

```
FROM python:3.10          → 994 MB base
RUN pip install flask     → +50 MB
RUN apt install gcc       → +200 MB
= Total: ~1.6 GB          ← you ship ALL of this to production!
```

### Multi-stage solution:
```
Stage 1 (builder) — do the heavy work:
  FROM python:3.10 AS builder    ← full image with all tools
  RUN pip install requirements   ← install everything needed
  (gcc, build tools stay here)

Stage 2 (final) — take only the output:
  FROM python:3.10-slim          ← small clean image
  COPY --from=builder /site-packages/ /site-packages/   ← only packages
  COPY app code                  ← only code
  = 212 MB ✅ (no build tools!)
```

### Key syntax — `COPY --from`:
```dockerfile
# Copy from a previous stage by its alias
COPY --from=builder /usr/local/lib/python3.10/site-packages/ \
                    /usr/local/lib/python3.10/site-packages/

# Copy from a public image directly
COPY --from=nginx:alpine /etc/nginx/nginx.conf /etc/nginx/nginx.conf
```

### What `AS builder` does:
```dockerfile
FROM python:3.10 AS builder   ← gives this stage a name "builder"
# Later stages can reference it:
COPY --from=builder /path /path
```

### Real size savings — today's result:
```
python:3.10         = 1.6 GB   (base image)
flask-app (normal)  = ~1.6 GB  (no improvement without multi-stage)
flask-app-mini      = 212 MB   ← 87% smaller! ✅
```

### When to use multi-stage builds:
- Compiled languages (Go, Java, C++) — compile in stage 1, copy binary in stage 2
- Python/Node — install deps in stage 1, copy site-packages in stage 2
- Any time you need build tools but NOT in production

---

## 2. Docker Monitoring & Logging

### docker logs — most used command:
```bash
docker logs <id>              # all logs from start
docker logs -f <id>           # live follow (Ctrl+C to stop)
docker logs --tail 100 <id>   # last 100 lines only
docker logs --since 30m <id>  # logs from last 30 minutes
docker logs -t <id>           # show timestamps
```

### docker attach vs docker exec:
```
docker attach <id>:
  → Connects to container's MAIN process (PID 1)
  → You see live stdout of the app
  → Ctrl+C = STOPS the container! ⚠️
  → Use: nohup docker attach <id> & to detach safely

docker exec -it <id> bash:
  → Opens a NEW shell inside container
  → Ctrl+D = exits shell, container keeps running ✅
  → Better for debugging
```

### nohup trick used today:
```bash
nohup docker attach 1db4f752d4d2 &
# nohup = no hang up — keeps running after you close terminal
# & = run in background
# Output goes to nohup.out file

cat nohup.out
# 223.185.39.192 - [12/May/2026 07:27:45] "GET / HTTP/1.1" 200 -
# 223.185.39.192 - [12/May/2026 07:28:20] "GET /error/ HTTP/1.1" 404 -
```

### docker stats — live resource monitoring:
```bash
docker stats                    # all containers — CPU, RAM, NET, DISK
docker stats <container_id>     # specific container
docker stats --no-stream        # snapshot (don't follow)
```

### docker inspect — detailed info:
```bash
docker inspect <id>             # full JSON — network, mounts, config
docker inspect <id> | grep IP   # find container IP
```

---

## 3. Project — Django + Nginx + MySQL Architecture

### Why Nginx in front of Django?

```
Without Nginx:
  Browser → Django (port 8000) directly
  ❌ Django dev server = not production-safe
  ❌ Can't handle many concurrent requests well
  ❌ No SSL termination, no static file serving

With Nginx (Reverse Proxy):
  Browser → Nginx (port 80) → Django (port 8000) → MySQL
  ✅ Nginx handles HTTP efficiently
  ✅ Nginx serves static files directly
  ✅ Django focuses only on Python/business logic
  ✅ Production-ready setup
```

### How Nginx reverse proxy works:
```
User types: http://44.203.201.83
                ↓
           Nginx (port 80)
           nginx_cont
           location / → proxy_pass http://django_cont:8000
                ↓
           Django (port 8000)
           django_cont
           python manage.py + gunicorn
                ↓
           MySQL (port 3306)
           db_cont
```

### healthcheck explained:
```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  interval: 10s      # check every 10 seconds
  timeout: 5s        # wait 5s for response
  retries: 5         # try 5 times before marking unhealthy
  start_period: 60s  # wait 60s before first check (DB needs time to start)
```

Status in `docker ps`:
```
Up 52 seconds (healthy)     ✅ — passed healthcheck
Up 49 seconds (health: starting)  ⏳ — still in start_period
Up 5 minutes (unhealthy)    ❌ — failed all retries
```

### depends_on explained:
```yaml
django:
  depends_on:
    - db      # Start db container BEFORE django container

nginx:
  depends_on:
    - django  # Start django BEFORE nginx
```
> ⚠️ `depends_on` only waits for container to START — not for the app inside to be READY!
> That's why `healthcheck` + `restart: always` is needed.

### gunicorn vs Django dev server:
```
python manage.py runserver:
  ❌ Development only
  ❌ Single-threaded
  ❌ Not safe for production

gunicorn notesapp.wsgi --bind 0.0.0.0:8000:
  ✅ Production WSGI server
  ✅ Multi-worker, handles concurrent requests
  ✅ Used by real companies
```

---

## 4. .dockerignore — Why It Matters

### Error I hit today:
```
failed to solve: error from sender:
open /home/ubuntu/project/django-notes-app/mysql-data/#innodb_redo: permission denied
```

### Why it happened:
```
docker compose up --build
  → Docker reads ALL files in context directory
  → mysql-data/ folder created by MySQL container (root-owned)
  → Docker can't read root-owned InnoDB files
  → Build fails!
```

### Fix — .dockerignore:
```
# .dockerignore file
mysql-data/
*.pyc
__pycache__/
.env
.git/
```

### .dockerignore vs .gitignore:
```
.gitignore   → tells Git what NOT to track
.dockerignore → tells Docker what NOT to include in build context

Same syntax, different purpose!
```

---

## 5. Key Observations Today

| Observation | Learning |
|-------------|----------|
| `flask-app-mini` = 212MB vs `python:3.10` = 1.6GB | Multi-stage = 87% size reduction |
| `docker attach` stopped the container on Ctrl+C | Use `exec` for debugging, not `attach` |
| `nohup docker attach &` saved logs to nohup.out | Useful for capturing live logs to file |
| MySQL data dir caused permission denied in build | Always add data dirs to `.dockerignore` |
| `depends_on` doesn't wait for app to be ready | Use `healthcheck` + `restart: always` together |
| Nginx config uses `proxy_pass http://django_cont:8000` | Container name = hostname on same network |
| 3 containers running together via one compose file | Power of Docker Compose for multi-service apps |
