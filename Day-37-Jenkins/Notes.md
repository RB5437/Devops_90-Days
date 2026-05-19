# 📝 Day 37 — Jenkins Complete Revision Notes 

---

## 🔄 CI/CD — The Big Picture

```
Developer pushes code to GitHub
         ↓
GitHub Webhook triggers Jenkins
         ↓
Jenkins Pipeline starts on Agent Node
         ↓
Stage 1: Code Clone
Stage 2: Build Docker Image
Stage 3: Push to DockerHub
Stage 4: Deploy on EC2
         ↓
Email Notification → Team gets alert
```

This is what happens in EVERY real DevOps company!

---

## 1. Jenkins Architecture — Deep Dive

```
Jenkins Master (Controller)
├── Manages job queue
├── Stores configuration
├── Displays UI (port 8080)
├── Does NOT run builds itself
└── Delegates to Agents

Jenkins Agent (Node)
├── Runs actual build commands
├── Has Java installed
├── Connected via SSH
└── Labeled (e.g., "agent-jenkins")

Executor
└── One thread = one build at a time
    (2 executors = 2 parallel builds possible)
```

**Why Master should NOT run builds:**
- Master crash = all pipelines lost
- Security risk — build code runs on master
- Resource contention — UI becomes slow

---

## 2. Freestyle vs Declarative Pipeline

| Feature | Freestyle | Declarative Pipeline |
|---------|-----------|---------------------|
| Configuration | GUI clicks | Code (Groovy) |
| Version control | ❌ No | ✅ Yes (Jenkinsfile) |
| Reusable | ❌ No | ✅ Yes |
| Complex logic | ❌ Hard | ✅ Easy |
| Industry use | Legacy | Modern standard |

**Always use Declarative Pipeline in real projects!**

---

## 3. Declarative Pipeline Structure

```groovy
pipeline {
    agent { label "agent-jenkins" }   // WHERE to run
    
    environment {
        IMAGE_NAME = "notes_app"       // Variables
        TAG = "latest"
    }
    
    stages {
        stage("Code") {               // WHAT to do
            steps {
                git url: "https://github.com/RB5437/django-notes-app.git",
                    branch: "main"
            }
        }
        stage("Build") {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }
        stage("Push") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "dockerhub-creds",
                    usernameVariable: "USER",
                    passwordVariable: "PASS"
                )]) {
                    sh "docker login -u ${USER} -p ${PASS}"
                    sh "docker push ritik2909/${IMAGE_NAME}:${TAG}"
                }
            }
        }
        stage("Deploy") {
            steps {
                sh "docker compose down && docker compose up -d"
            }
        }
    }
    
    post {                             // AFTER pipeline
        success { echo "Deployed!" }
        failure { echo "Failed!"   }
    }
}
```

---

## 4. Shared Libraries — Deep Concept

**Problem without Shared Libraries:**
```
Pipeline 1 (Project A) → same docker_build code
Pipeline 2 (Project B) → same docker_build code
Pipeline 3 (Project C) → same docker_build code

Bug found → fix in 3 places!
```

**Solution with Shared Libraries:**
```
Shared Library repo (groovy functions)
└── vars/
    └── docker_build.groovy → fix once → all pipelines updated!
```

**Library structure:**
```
jenkins-shared-library/          ← GitHub repo
└── vars/
    ├── hello.groovy             ← def call() { echo "Hello!" }
    ├── clone.groovy             ← def call(url, branch) { git url: url, branch: branch }
    ├── docker_build.groovy      ← def call(name, tag, user) { sh "docker build -t ${user}/${name}:${tag} ." }
    └── docker_push.groovy       ← def call(name, tag, user) { sh "docker push ${user}/${name}:${tag}" }
```

**Register in Jenkins:**
```
Manage Jenkins → System → Global Pipeline Libraries
Name: Shared
Default Version: main
GitHub URL: https://github.com/RB5437/jenkins-shared-library.git
```

**Use in pipeline:**
```groovy
@Library("Shared") _   // ← this line loads the library

pipeline {
    stages {
        stage("Build") {
            steps {
                script {
                    docker_build("notes_app", "latest", "ritik2909")
                    // ↑ calls docker_build.groovy automatically!
                }
            }
        }
    }
}
```

---

## 5. GitHub Webhook — How it Actually Works

```
Step 1: Developer does "git push origin main"

Step 2: GitHub receives the push

Step 3: GitHub sends HTTP POST request to:
        http://<jenkins-ip>:8080/github-webhook/

Step 4: Jenkins receives the webhook

Step 5: Jenkins finds all jobs with 
        "GitHub hook trigger for GITScm polling" enabled

Step 6: Matching jobs are triggered automatically

Step 7: Pipeline starts running on Agent node
```

**Security Group must allow:**
- Port 8080 from GitHub IP ranges (or 0.0.0.0/0 for testing)

---

## 6. RBAC — Why It Matters in Companies

```
Without RBAC:
Developer accidentally deletes a job ❌
Intern modifies system configuration ❌
New joiner sees sensitive credentials ❌

With RBAC:
Developer → can only trigger builds ✅
Intern → view-only access ✅
Admin → full access (limited people) ✅
```

**Role hierarchy:**
```
admin     → ALL permissions
developer → Build, Cancel, Read, Workspace
viewer    → Read only
```

---

## 7. Multibranch Pipeline — Real World Use

```
Company workflow:
main branch     → Production pipeline → deploy to PROD
staging branch  → Staging pipeline   → deploy to STAGING
feature/login   → Feature pipeline   → run tests only

Multibranch Pipeline handles ALL of this automatically!
No DevOps engineer needs to create jobs manually per branch.
```

---

## 8. Jenkins Credentials — Best Practices

```
NEVER hardcode passwords in Jenkinsfile!

❌ BAD:
sh "docker login -u ritik2909 -p mypassword123"

✅ GOOD:
withCredentials([usernamePassword(
    credentialsId: "dockerhub-creds",
    usernameVariable: "USER",
    passwordVariable: "PASS"
)]) {
    sh "docker login -u ${USER} -p ${PASS}"
}
```

---

## 9. Jenkins Complete Interview Q&A

**Q1: What is the difference between Freestyle and Pipeline job?**
Freestyle is GUI-based, not version controlled. Pipeline (Declarative) uses Jenkinsfile which is stored in GitHub, version controlled, and reviewable via PR. In production, always use Pipeline.

**Q2: What is Master-Agent architecture?**
Master is the Jenkins controller — it manages job queue, stores config, and shows UI. Agents are worker nodes that actually execute the builds. Master should never run builds to avoid resource issues and security risks.

**Q3: Explain Shared Libraries.**
Shared Libraries store reusable Groovy functions in a separate GitHub repo. Instead of duplicating pipeline code across projects, functions like docker_build() and docker_push() are written once and called in any pipeline using @Library("name").

**Q4: How does GitHub Webhook work with Jenkins?**
When a developer pushes code, GitHub sends an HTTP POST to Jenkins webhook URL. Jenkins receives it, finds matching jobs, and triggers the pipeline automatically — no manual "Build Now" needed.

**Q5: What is RBAC in Jenkins?**
Role-Based Access Control using the "Role-based Authorization Strategy" plugin. You create roles (admin, developer, viewer) with specific permissions, then assign users to roles. This ensures least-privilege access.

**Q6: What is Multibranch Pipeline?**
Jenkins automatically scans a GitHub repo, discovers all branches with a Jenkinsfile, and creates a separate pipeline per branch. Feature branches get tested automatically without any manual job creation.

**Q7: How do you send notifications from Jenkins?**
Using the Email Extension plugin with the post{} block. post{success{}} sends on success, post{failure{}} sends on failure. Configure SMTP in Manage Jenkins → System.

**Q8: Where should Jenkinsfile be stored?**
Always in the GitHub repository root. This makes the pipeline version controlled, auditable, and reviewable via Pull Requests — a production best practice.
