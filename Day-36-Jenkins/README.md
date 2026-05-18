# 🔧 Day 36 — Jenkins Advanced: RBAC, SCM Pipeline, Multibranch & Email Notification

**Date:** 18 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | RBAC — Role Based Access Control | ✅ Done |
| 2 | Jenkinsfile from GitHub SCM | ✅ Done |
| 3 | Multibranch Pipeline | ✅ Done |
| 4 | Email Notification on Pipeline | ✅ Done |

---

## 🔐 1. RBAC — Role Based Access Control

**What is RBAC?**
Control WHO can do WHAT in Jenkins.
- **Admin** → Full access
- **Developer** → Build + View
- **Viewer** → Read only

**Plugin:** Role-based Authorization Strategy

**Steps:**
1. Manage Jenkins → Plugins → Install "Role-based Authorization Strategy"
2. Manage Jenkins → Security → Authorization → Role-Based Strategy
3. Manage Jenkins → Manage Roles → Create roles
4. Assign Roles → Assign users to roles

---

## 📂 2. Jenkinsfile from GitHub SCM

**What is SCM Pipeline?**
Store Jenkinsfile in GitHub repo — Jenkins reads from there.

- No more writing pipeline in Jenkins UI
- Jenkinsfile is version controlled
- Team can review pipeline changes via PR

**Steps:**
1. Pipeline job → Definition → "Pipeline script from SCM"
2. SCM: Git → Repo URL
3. Branch: main
4. Script Path: Jenkinsfile
5. Save → Build

---

## 🌿 3. Multibranch Pipeline

**What is Multibranch Pipeline?**
Jenkins auto-discovers ALL branches in a repo and creates a pipeline for each!

- Push to `feature/login` → auto pipeline triggers
- Push to `main` → main pipeline triggers
- No manual job creation per branch

**Steps:**
1. New Item → Multibranch Pipeline
2. Branch Sources → GitHub → Repo URL
3. Scan → Jenkins auto-creates pipelines per branch
4. Each branch needs its own `Jenkinsfile`

---

## 📧 4. Email Notification on Pipeline

**What is Email Notification?**
Send automatic email when pipeline Passes or Fails.

**Plugin:** Email Extension Plugin (already in suggested plugins)

**Jenkinsfile syntax:**
```groovy
pipeline {
    agent any
    stages {
        stage("Build") {
            steps {
                echo "Building..."
            }
        }
    }
    post {
        success {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "✅ BUILD SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build passed! Check: ${env.BUILD_URL}"
            )
        }
        failure {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "❌ BUILD FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed! Check: ${env.BUILD_URL}"
            )
        }
    }
}
```

---

## 📊 Jenkins Series Progress

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 33 | 15 May | Intro + Install + Freestyle Job | ✅ Done |
| Day 34 | 16 May | Declarative Pipeline + Multi-Node Agent | ✅ Done |
| Day 35 | 17 May | Webhook + Shared Libraries + User Mgmt | ✅ Done |
| Day 36 | 18 May | RBAC + SCM + Multibranch + Email | ✅ Done |
| Day 37 | 19 May | Jenkins Final Revision + Project | 🔄 Tomorrow |

---

## 🔗 Resources
- GitHub: https://github.com/RB5437/Devops_90-Days
- Video: Jenkins In One Shot — TrainWithShubham
