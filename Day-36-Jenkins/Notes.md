# 📝 Day 36 — Jenkins Advanced Notes

---

## 🔐 1. RBAC — Role Based Access Control

### Why RBAC?
In a company, not everyone should have admin access to Jenkins.
- **Admin** → Can install plugins, configure system, delete jobs
- **Developer** → Can trigger builds, view logs, create jobs
- **Viewer** → Can only see job status — no actions

### How it works internally:
```
Jenkins Security Layer
├── Authentication → Who are you? (username/password)
└── Authorization  → What can you do? (RBAC decides this)
```

### Plugin: Role-based Authorization Strategy
```
Manage Jenkins
└── Plugins → Available → "Role-based Authorization Strategy"
    └── Install without restart

Manage Jenkins
└── Security → Authorization → Role-Based Strategy (select this)

Manage Jenkins
└── Manage and Assign Roles
    ├── Manage Roles → Create: admin, developer, viewer
    └── Assign Roles → User "Ritik" → developer role
```

### Interview Answer:
**Q: How do you manage access in Jenkins?**
"We use Role-Based Authorization Strategy plugin. I create roles — admin, developer, viewer — with specific permissions, then assign users to roles. This ensures developers can trigger builds but cannot change system configuration."

---

## 📂 2. Jenkinsfile from GitHub SCM

### Why SCM over UI?
| Jenkins UI Pipeline | SCM Pipeline |
|---------------------|--------------|
| Stored in Jenkins | Stored in GitHub |
| Not version controlled | Full Git history |
| Lost if Jenkins crashes | Safe in repo |
| Team can't review | PR review possible |

### Configuration:
```
Pipeline Job
└── Pipeline Definition
    └── Pipeline script from SCM
        ├── SCM: Git
        ├── Repository URL: https://github.com/RB5437/django-notes-app.git
        ├── Branch: */main
        └── Script Path: Jenkinsfile
```

### Jenkinsfile in repo root:
```groovy
@Library("Shared") _
pipeline {
    agent { label "agent-jenkins" }
    stages {
        stage("Code") {
            steps {
                script { clone("https://github.com/RB5437/django-notes-app.git", "main") }
            }
        }
        stage("Build") {
            steps {
                script { docker_build("notes_app", "latest", "ritik2909") }
            }
        }
        stage("Push") {
            steps {
                script { docker_push("notes_app", "latest", "ritik2909") }
            }
        }
        stage("Deploy") {
            steps {
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}
```

---

## 🌿 3. Multibranch Pipeline

### What it does:
Jenkins scans your GitHub repo → finds ALL branches with a Jenkinsfile → auto-creates one pipeline per branch

```
GitHub Repo: django-notes-app
├── main          → Jenkins auto-creates "main" pipeline
├── feature/login → Jenkins auto-creates "feature/login" pipeline
└── hotfix/bug    → Jenkins auto-creates "hotfix/bug" pipeline
```

### Why companies use it:
- No manual job creation for new branches
- Feature branches tested before merging to main
- Each branch can have different pipeline logic

### Setup:
```
New Item → Multibranch Pipeline → OK
Branch Sources → Add Source → GitHub
  └── Repository HTTPS URL: https://github.com/RB5437/django-notes-app.git
Scan Repository Triggers → Periodically if not otherwise run: 1 min
Save → Scan Now
```

### Interview Answer:
**Q: How do you handle CI/CD for feature branches?**
"We use Multibranch Pipeline. Jenkins automatically discovers all branches in the GitHub repo and creates a pipeline for each branch that has a Jenkinsfile. This ensures every feature branch is tested in isolation before merging."

---

## 📧 4. Email Notification

### How it works:
Pipeline finishes → post{} block runs → emailext sends email

### SMTP Setup (Gmail):
```
Manage Jenkins → System → Extended E-mail Notification
├── SMTP server: smtp.gmail.com
├── SMTP Port: 465
├── Use SSL: ✅
├── Credentials: Gmail App Password
└── Default To: ritikbawane5437@gmail.com
```

### Gmail App Password (mandatory):
```
Google Account → Security → 2-Step Verification → App Passwords
Create → Name: Jenkins → Copy 16-digit password
```

### Full pipeline with notifications:
```groovy
pipeline {
    agent any
    stages {
        stage("Build") { steps { echo "Building..." } }
        stage("Test")  { steps { echo "Testing..."  } }
        stage("Deploy"){ steps { echo "Deploying..." } }
    }
    post {
        always {
            echo "Pipeline finished — sending notification"
        }
        success {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build Passed! 🎉
                    Job: ${env.JOB_NAME}
                    Build: #${env.BUILD_NUMBER}
                    URL: ${env.BUILD_URL}
                """
            )
        }
        failure {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "❌ FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build Failed! ⚠️
                    Job: ${env.JOB_NAME}
                    Build: #${env.BUILD_NUMBER}
                    URL: ${env.BUILD_URL}
                """
            )
        }
    }
}
```

### post{} block conditions:
| Condition | When it runs |
|-----------|-------------|
| always | Every time, pass or fail |
| success | Only on success |
| failure | Only on failure |
| unstable | When tests fail but build passes |
| changed | When result changes from last build |

---

## 🎯 Jenkins Complete — Interview Q&A

**Q: What is RBAC in Jenkins?**
Role-Based Access Control — assigns permissions based on roles, not individual users. Uses "Role-based Authorization Strategy" plugin.

**Q: Jenkinsfile in UI vs GitHub — which is better?**
GitHub (SCM) is always better — version controlled, reviewable via PR, survives Jenkins crash.

**Q: What is Multibranch Pipeline?**
Jenkins auto-discovers all branches with a Jenkinsfile and creates separate pipelines per branch. Used for feature branch testing.

**Q: How do you alert team on build failure?**
Using emailext plugin with post{failure{}} block. Configure SMTP in Manage Jenkins → System.
