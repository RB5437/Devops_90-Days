# 🔄 Day 33 — Jenkins Introduction, Installation & First Job

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)

> **Resource:** Jenkins In One Shot | DevOps Production CI/CD Pipelines — Shubham Londhe
> **EC2:** ubuntu@ip-172-31-29-151 | Jenkins 2.555.2 | Port 8080

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Jenkins Introduction + CI/CD concept | ✅ Done |
| 2 | Java 21 installation on AWS EC2 | ✅ Done |
| 3 | Jenkins repo + keyring setup | ✅ Done |
| 4 | Jenkins installation + systemctl enable | ✅ Done |
| 5 | Jenkins UI — Setup Wizard + Plugins | ✅ Done |
| 6 | First Freestyle Job — "First-Job" created | ✅ Done |
| 7 | Build Steps — echo + mkdir commands | ✅ Done |
| 8 | Console Output — BUILD SUCCESS | ✅ Done |
| 9 | Jenkins Workspace — /var/lib/jenkins/workspace/ | ✅ Done |

---

## 🏗️ What is Jenkins?

Jenkins is an open-source **CI/CD automation server** that automates building, testing, and deploying applications.

```
Developer → Push Code → GitHub
                            ↓
                        Jenkins (detects change)
                            ↓
                    Build → Test → Deploy
                            ↓
                    Production Server ✅
```

### CI vs CD:
| Term | Full Form | Meaning |
|------|-----------|---------|
| CI | Continuous Integration | Auto build + test on every code push |
| CD | Continuous Delivery | Auto deploy to staging after tests pass |
| CD | Continuous Deployment | Auto deploy to production |

---

## 🏛️ Jenkins Architecture

```
┌─────────────────────────────────────────────┐
│              Jenkins Master                  │
│   - Manages jobs and pipelines               │
│   - Schedules builds                         │
│   - Monitors agents                          │
│   - Port: 8080                               │
└──────────────┬──────────────────────────────┘
               │
    ┌──────────┴──────────┐
    ▼                     ▼
┌────────┐           ┌────────┐
│ Agent1 │           │ Agent2 │
│ Node   │           │ Node   │
│(Linux) │           │(Docker)│
└────────┘           └────────┘
```

### Key terms:
| Term | Meaning |
|------|---------|
| Master | Main Jenkins server — manages everything |
| Agent/Node | Worker machine that runs builds |
| Executor | Thread on agent that runs one build at a time |
| Job/Project | A task Jenkins performs |
| Build | One execution of a job |
| Pipeline | Series of automated steps |
| Workspace | Directory where Jenkins runs builds |

---

## 🚀 Jenkins Installation — Step by Step (AWS EC2)

### Step 1: Update + Install Java
```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
java -version
# openjdk version "21.0.11-ea" 2026-04-21
```

### Step 2: Add Jenkins Repository
```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

### Step 3: Install Jenkins
```bash
sudo apt update
sudo apt install jenkins -y
# Jenkins 2.555.2 installed
```

### Step 4: Start + Enable Jenkins
```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
# Active: active (running) ✅
```

### Step 5: Get Initial Password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 6: Access Jenkins UI
```
http://<ec2-public-ip>:8080
# EC2 Security Group: port 8080 open karo!
```

---

## 🖥️ Jenkins Setup Wizard

```
1. Enter initialAdminPassword
2. "Customize Jenkins" → "Install suggested plugins"
3. Create admin user
4. Jenkins URL confirm karo
5. Jenkins Dashboard ready! ✅
```

**Jenkins version installed:** `2.555.2`
**EC2 IP:** `98.91.21.52:8080`

---

## 🎯 First Freestyle Job — "First-Job"

### Job created:
```
Jenkins Dashboard → New Item → "First-Job" → Freestyle project → OK
```

### Build Steps added:
```bash
echo "Hello Afternoon"
mkdir -p devops
echo "Devops folder created"
```

### Console Output — BUILD SUCCESS:
```
Started by user admin
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/First-Job
[First-Job] $ /bin/sh -xe /tmp/jenkins194314558186...sh
+ echo Hello Afternoon
Hello Afternoon
+ mkdir -p devops
+ echo Devops folder created
Devops folder created
Finished: SUCCESS ✅
```

### Workspace verified:
```bash
cd /var/lib/jenkins/workspace/
ls
# First-Job

cd First-Job/
ls
# devops  ← folder created by our job!
```

---

## 📋 Jenkins Topics Covered Today (from Shubham's One Shot)

| Topic | Status |
|-------|--------|
| Introduction to Jenkins & CI/CD | ✅ |
| Jenkins Setup on VM (AWS EC2) | ✅ |
| Jenkins UI / Dashboard / Jobs | ✅ |
| Jenkins Freestyle Project | ✅ |
| Declarative Pipeline | ⬜ Tomorrow |
| Jenkins Agents (Multi-Node) | ⬜ |
| Shared Libraries | ⬜ |
| User Management (Role Based) | ⬜ |
| CI/CD Project with K8s, ArgoCD | ⬜ |
| DevSecOps — OWASP, Trivy, Sonarqube | ⬜ |
| Email Notification on Pipeline | ⬜ |

---

## 📊 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 27-32 | 9–14 May | Docker Series | ✅ Done |
| **Day 33** | **15 May 2026** | **Jenkins Intro + Install + First Job** | **✅ Done** |
| Day 34 | 16 May 2026 | Declarative Pipeline + Jenkinsfile | ⬜ |
| Day 35 | 17 May 2026 | Jenkins + Docker Integration | ⬜ |
| Day 36 | 18 May 2026 | Jenkins + GitHub Integration | ⬜ |
| Day 37 | 19 May 2026 | Jenkins Final Project | ⬜ |

---

## 📚 Resources

| Resource | Link |
|----------|------|
| Shubham Londhe Jenkins One Shot | https://www.youtube.com/@TrainWithShubham |
| Jenkins Official Docs | https://www.jenkins.io/doc/ |
| GitHub Repo | https://github.com/RB5437/Devops_90-Days |

---

*Day 33 of 90 — Jenkins Series | DevOps 90-Day Challenge*
*Ritik Bawane | AWS Certified | RHCSA | Kyndryl MNC*
