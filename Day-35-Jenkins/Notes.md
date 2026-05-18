# 📝 Day 35 — Jenkins Notes 
> Webhook + Shared Libraries + User Management

---

## 1. 🔗 GitHub Webhook — How it Works Internally

### Without webhook (polling):
```
Jenkins checks GitHub every 5 minutes:
"Any new commits?" → No → Wait 5 min
"Any new commits?" → No → Wait 5 min
"Any new commits?" → Yes → Trigger build
Problem: Up to 5 minute delay + wasted API calls
```

### With webhook (event-driven):
```
Developer: git push origin main
GitHub: "Jenkins needs to know!" → POST request to Jenkins URL
Jenkins: Receives POST → immediately triggers pipeline
Result: Build starts within seconds of push!
```

### Webhook payload URL format:
```
http://<jenkins-ip>:8080/github-webhook/
                                ↑
                    MUST end with /github-webhook/
                    Jenkins GitHub plugin handles this endpoint
```

### What GitHub sends to Jenkins:
```json
{
  "ref": "refs/heads/main",
  "commits": [...],
  "repository": {
    "name": "django-notes-app",
    "full_name": "RB5437/django-notes-app"
  },
  "pusher": {
    "name": "RB5437"
  }
}
```

### Why "Recent Deliveries" matters:
- Shows every webhook event sent by GitHub
- ✅ Green = Jenkins received and processed
- ❌ Red = Jenkins unreachable (EC2 stopped, port blocked)

---

## 2. 📚 Shared Libraries — Deep Dive

### The DRY principle in Jenkins:
DRY = Don't Repeat Yourself. Shared Libraries apply this to CI/CD pipelines.

### File structure — mandatory:
```
jenkins-shared-libraries/
└── vars/                  ← MUST be named 'vars'
    ├── hello.groovy       ← Each file = one function
    ├── clone.groovy
    ├── docker_build.groovy
    └── docker_push.groovy
```

**Rule:** Each `.groovy` file in `vars/` must have a `def call()` function. The filename becomes the function name in pipeline!

### How `@Library` works:
```groovy
@Library("Shared") _
//       ↑        ↑
//  Library name  _ = import everything
//  (must match name in Jenkins config)

// Now you can call any function from vars/
hello()                                    // → hello.groovy
clone("url", "branch")                     // → clone.groovy
docker_build("app", "latest", "user")      // → docker_build.groovy
docker_push("app", "latest", "user")       // → docker_push.groovy
```

### Global Trusted vs Untrusted:
| Type | Security | Can use @Grab | Use case |
|------|---------|---------------|---------|
| Global Trusted | High trust | ✅ Yes | Internal, company libraries |
| Global Untrusted | Sandboxed | ❌ No | External, community libraries |

**We used Global Untrusted** — safer for learning and external repos.

---

## 3. 🔐 withCredentials — Secure Docker Login

### Why not hardcode credentials?
```groovy
// ❌ BAD — credentials in pipeline code!
sh "docker login -u ritik2909 -p mypassword123"
// Anyone who reads Jenkinsfile sees your password!

// ✅ GOOD — credentials from Jenkins store
withCredentials([
    usernamePassword(
        credentialsId: 'dockerHubcred',
        usernameVariable: 'DOCKER_USER',
        passwordVariable: 'DOCKER_PASS'
    )
]) {
    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
}
// Password never appears in logs or code!
```

### withCredentials flow:
```
Jenkins Credentials Store
    → 'dockerHubcred' stored securely
         ↓
withCredentials block
    → Injects DOCKER_USER and DOCKER_PASS as env vars
         ↓
sh command uses env vars
    → docker login uses them
         ↓
After block exits: env vars cleared from memory
```

---

## 4. 🔄 Complete CI/CD Flow with Shared Libraries

```
Developer pushes code to GitHub
            ↓
GitHub Webhook sends POST to Jenkins
            ↓
Jenkins pipeline triggers automatically
            ↓
@Library("Shared") loads groovy functions
            ↓
Stage 1: hello() → echo "Hello Dosti"
            ↓
Stage 2: clone(url, branch) → git pull from GitHub
            ↓
Stage 3: docker_build(name, tag, user) → docker build -t image .
            ↓
Stage 4: docker_push(name, tag, user) → docker push to DockerHub
            ↓
Stage 5: docker compose down && docker compose up -d → Deploy!
            ↓
App updated! Zero manual steps! ✅
```

---

## 5. 👥 Jenkins User Management

### Why user management?
- Admin should not be the only user
- Different teams need different access levels
- Audit trail — know who triggered what build

### User roles (with Role-Based Authorization plugin):
| Role | Access |
|------|--------|
| Admin | Full access — manage Jenkins |
| Developer | Can trigger builds, view logs |
| Viewer | Read-only — see build status |
| No access | Cannot login |

### What we did today:
```
Manage Jenkins → Users → Create User:
Username: Ritik
Full name: Ritik Bawane
Email: Ritikbawane5437@gmail.com

Result: 2 users now:
admin → full admin access
Ritik → Ritik Bawane (developer)
```

---

## 6. 🏗️ docker-compose.yml in django-notes-app

### Actual docker-compose used for deployment:
```yaml
services:
  nginx:
    build:
      context: ./nginx
    container_name: nginx_cont
    ports:
      - "80:80"
    networks:
      - notes-app
    restart: always
    depends_on:
      - django

  django:
    image: ritik2909/notes-app:latest    # ← Uses pre-built image from DockerHub!
    container_name: django_cont
    command: >
      sh -c "python manage.py migrate --noinput &&
             gunicorn 'notesapp.wsgi:application' --bind 0.0.0.0:8000 --timeout 120"
    ports:
      - "8000:8000"
    env_file:
      - .env
    restart: always
    networks:
      - notes-app
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8000/admin || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 60s
```

**Key:** Django service uses `image: ritik2909/notes-app:latest` — pulls from DockerHub after Jenkins pushes!

---

## 7. ⚡ Build Time Optimization

### Build #12 — ~7 seconds total!
```
Hello:           252ms   (shared library function call)
Code:            400ms   (git clone)
Build:           718ms   (docker build — image cached!)
Push to DockerHub: 1s    (push — cached layers)
Deploy:          416ms   (compose restart)
```

**Why so fast?** Docker layer caching! After first build, unchanged layers are cached. Only changed layers are rebuilt.

---

## 8. 🎯 Key Interview Points from Day 35

| Question | Answer |
|----------|--------|
| What is a GitHub webhook? | Event-driven trigger — GitHub sends POST to Jenkins when code is pushed. Immediate pipeline trigger. |
| Webhook vs Poll SCM? | Webhook = event-driven, instant, efficient. Poll SCM = Jenkins checks periodically, delay, wasteful |
| What are Shared Libraries? | Reusable Groovy functions stored in Git. Used with @Library annotation. Eliminates code duplication |
| Where are Shared Library files? | Must be in `vars/` folder. Each file = one callable function with `def call()` |
| How to use shared library? | `@Library("LibraryName") _` at top of Jenkinsfile |
| withCredentials purpose? | Securely inject credentials from Jenkins store into pipeline. Never expose passwords in code/logs |
| What is dockerHubcred? | Credential ID in Jenkins store containing DockerHub username and password |
| User management in Jenkins? | Manage Jenkins → Users → Create User. Role-based access with Role Strategy Plugin |
| Webhook payload URL format? | `http://<jenkins-ip>:8080/github-webhook/` — must end with /github-webhook/ |
| Build #12 ran in 7 seconds — why fast? | Docker layer caching — unchanged layers reused from previous build |

---

*Day 35 Notes — Webhook + Shared Libraries + User Management*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
