# 🔧 Day 37 — Jenkins Complete Revision (Day 33 → Day 37)

**Date:** 19 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Jenkins Series — Complete Summary

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 33 | 15 May | Intro + Install + Freestyle Job | ✅ Done |
| Day 34 | 16 May | Declarative Pipeline + Multi-Node Agent + DjangoCICD | ✅ Done |
| Day 35 | 17 May | Webhook + Shared Libraries + User Management | ✅ Done |
| Day 36 | 18 May | RBAC + SCM Pipeline + Multibranch + Email Notification | ✅ Done |
| Day 37 | 19 May | Complete Revision | ✅ Done |

---

## 📌 Day 33 — Jenkins Introduction + Installation + Freestyle Job

**What is Jenkins?**
Open-source CI/CD automation server. Automates build, test, and deploy.

**Architecture:**
- Master (Controller) — manages jobs, schedules builds
- Agent (Node) — actually runs the builds
- Executor — thread that runs one build at a time

**Installation on AWS EC2:**
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo systemctl enable jenkins && sudo systemctl start jenkins
```

**Freestyle Job:**
- Simplest job type in Jenkins
- GUI-based — no code needed
- Good for simple tasks (echo, mkdir, shell commands)

---

## 📌 Day 34 — Declarative Pipeline + Multi-Node Agent + DjangoCICD

**Declarative Pipeline:**
```groovy
pipeline {
    agent any
    stages {
        stage('Build')  { steps { echo 'Building...'  } }
        stage('Test')   { steps { echo 'Testing...'   } }
        stage('Deploy') { steps { echo 'Deploying...' } }
    }
}
```

**Master-Agent Architecture:**
- Master should NEVER run builds
- Agents do the actual work
- SSH key pair connects Master to Agent

**DjangoCICD — 4 Stage Pipeline:**
```
Code → Build → Push to DockerHub → Deploy
```
- Build #22 — SUCCESS ✅
- GitHub webhook connected ✅

---

## 📌 Day 35 — Webhook + Shared Libraries + User Management

**GitHub Webhook:**
- Code push → Jenkins pipeline auto-triggers
- No manual "Build Now" needed
- GitHub → Settings → Webhooks → Jenkins URL

**Shared Libraries:**
```
GitHub Repo (groovy functions)
└── vars/
    ├── hello.groovy
    ├── clone.groovy
    ├── docker_build.groovy
    └── docker_push.groovy
```
Write ONCE → Reuse in ALL pipelines!

**Pipeline using Shared Library:**
```groovy
@Library("Shared") _
pipeline {
    agent { label "agent-jenkins" }
    stages {
        stage("Code")  { steps { script { clone("repo-url", "main") } } }
        stage("Build") { steps { script { docker_build("notes_app", "latest", "ritik2909") } } }
        stage("Push")  { steps { script { docker_push("notes_app", "latest", "ritik2909") } } }
        stage("Deploy"){ steps { sh "docker compose down && docker compose up -d" } }
    }
}
```

---

## 📌 Day 36 — RBAC + SCM Pipeline + Multibranch + Email

**RBAC:**
- Plugin: Role-based Authorization Strategy
- Roles: admin → developer → viewer
- Assign users to roles

**Jenkinsfile from GitHub SCM:**
- Pipeline stored in GitHub repo
- Jenkins reads Jenkinsfile from repo
- Version controlled + PR reviewable

**Multibranch Pipeline:**
- Jenkins auto-detects ALL branches
- Each branch with Jenkinsfile gets its own pipeline
- Feature branch CI/CD — no manual setup

**Email Notification:**
```groovy
post {
    success { emailext(to: 'team@company.com', subject: "✅ SUCCESS: ${env.JOB_NAME}") }
    failure { emailext(to: 'team@company.com', subject: "❌ FAILED: ${env.JOB_NAME}") }
}
```

---

## 🎯 Jenkins Interview Questions — Quick Answers

| Question | Answer |
|----------|--------|
| What is Jenkins? | Open-source CI/CD automation server |
| Master vs Agent? | Master manages, Agent runs builds |
| What is Declarative Pipeline? | Structured pipeline using pipeline{} block |
| Freestyle vs Pipeline? | Freestyle = GUI, Pipeline = code (Jenkinsfile) |
| What is Shared Library? | Reusable Groovy functions across pipelines |
| What is Webhook? | Auto-trigger pipeline on GitHub code push |
| What is RBAC? | Role-based access control via plugin |
| SCM Pipeline? | Jenkinsfile stored and read from GitHub |
| Multibranch Pipeline? | Auto-creates pipeline per branch in repo |
| Email Notification? | post{success/failure} block with emailext |

---

## 🔗 Resources
- GitHub: https://github.com/RB5437/Devops_90-Days
- Video: Jenkins In One Shot — TrainWithShubham
- Next: Kubernetes starts Day 38! ☸️
