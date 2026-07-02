<div align="center">

# 🚀 Devops_90-Days

### From Technical Engineer to DevOps Engineer — 90 Days of Hands-On Learning

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Ritik%20Bawane-blue?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ritik-bawane)
[![GitHub followers](https://img.shields.io/github/followers/RB5437?style=social)](https://github.com/RB5437)
[![AWS Certified](https://img.shields.io/badge/AWS-Certified%20SAA-orange?logo=amazonaws)](https://aws.amazon.com/certification/)
[![RHCSA](https://img.shields.io/badge/Red%20Hat-RHCSA%20Certified-red?logo=redhat)](https://www.redhat.com/en/services/certification/rhcsa)

</div>

---

## 👨‍💻 About Me

**Ritik Bawane** | AWS Certified Solutions Architect – Associate | RHCSA Certified | 3.4 Years at Kyndryl India

After 3.4 years as a **System Management Engineer at Kyndryl India**, I made a deliberate decision to fully transition into DevOps Engineering.

I enrolled in a structured DevOps program, cleared two global certifications, and started this **90-day hands-on challenge** to build real projects and become interview-ready.

This repository documents every single day — commands, notes, projects, and live deployments on AWS.

> *"The gap was not wasted. It was invested."*

---

## 🎯 Goal

Become a job-ready **DevOps Engineer** with hands-on experience across the complete modern DevOps toolchain — not just theory, but real projects deployed on real infrastructure.

---

## 📅 90-Day Roadmap & Progress

| Days | Topic | Dates | Status |
|------|-------|-------|--------|
| Day 01–05 | 🐧 Linux Administration | 13–17 Apr 2026 | ✅ Complete |
| Day 06–07 | 🌐 Networking | 18–19 Apr 2026 | ✅ Complete |
| Day 08–12 | 💻 Shell Scripting | 20–24 Apr 2026 | ✅ Complete |
| Day 13 | ⚙️ DevOps Fundamentals | 25 Apr 2026 | ✅ Complete |
| Day 14–17 | 🔧 Git & GitHub | 26–29 Apr 2026 | ✅ Complete |
| Day 18–26 | ☁️ AWS | 30 Apr–8 May 2026 | ✅ Complete |
| Day 27–32 | 🐳 Docker | 9–14 May 2026 | ✅ Complete |
| Day 33–37 | 🔄 Jenkins | 15–19 May 2026 | ✅ Complete |
| Day 38–45 | ☸️ Kubernetes | 20–27 May 2026 | 🔄 In Progress |
| Day 46–48 | ⛵ Helm | 28–30 May 2026 | ⬜ Upcoming |
| Day 49–51 | 🔁 ArgoCD | 31 May–2 Jun 2026 | ⬜ Upcoming |
| Day 52–57 | 🏗️ Terraform | 3–8 Jun 2026 | ⬜ Upcoming |
| Day 58–61 | 📊 Prometheus & Grafana | 9–12 Jun 2026 | ⬜ Upcoming |
| Day 62–65 | 🤖 GenAI for DevOps | 13–16 Jun 2026 | ⬜ Upcoming |
| Day 66–75 | 🏆 Real World Projects | 17–26 Jun 2026 | ⬜ Upcoming |
| Day 76–90 | 🎯 Resume + Interview Prep | 27 Jun–11 Jul 2026 | ⬜ Upcoming |

---

## 🛠️ Tools & Technologies

| Category | Tools |
|----------|-------|
| OS & Shell | Linux (RHEL/Ubuntu), Bash Scripting |
| Version Control | Git, GitHub |
| Cloud | AWS (EC2, S3, RDS, IAM, VPC, ALB, Auto Scaling, CloudWatch) |
| Containers | Docker, Docker Compose, Docker Scout |
| CI/CD | Jenkins (Pipelines, Agents, Shared Libraries, Webhooks, RBAC) |
| Orchestration | Kubernetes *(in progress)* |
| Package Manager | Helm *(upcoming)* |
| GitOps | ArgoCD *(upcoming)* |
| Infrastructure as Code | Terraform *(upcoming)* |
| Monitoring | Prometheus, Grafana *(upcoming)* |
| Certifications | AWS SAA ✅ · RHCSA ✅ |

---

## 🏆 Projects Built

### 🐳 Project 1 — Student Grade Tracker (Docker Full Stack)
> Flask + MySQL + Nginx — fully containerized and live on AWS EC2

**Tech Stack:** Python Flask · MySQL · Nginx · Docker · Docker Compose

| Feature | Detail |
|---------|--------|
| Multi-stage Docker build | Image size reduced **87%** — 1.6GB → 212MB |
| Docker Compose | 3 services started with one command |
| Custom bridge network | Container-to-container DNS resolution |
| Named volumes | MySQL data persists across restarts |
| Health checks | Non-root user security best practices |
| Live deployment | AWS EC2 — `http://54.226.172.26` |

```bash
# Start entire stack with one command
docker compose up -d
```

---

### ☁️ Project 2 — AWS 3-Tier Architecture
> EC2 + ALB + RDS + Auto Scaling + CloudWatch

**Tech Stack:** AWS EC2 · ALB · RDS · Auto Scaling · VPC · CloudWatch · IAM

- Public subnet: ALB + EC2 web tier
- Private subnet: EC2 app tier + RDS Multi-AZ data tier
- Auto Scaling Group with launch template
- CloudWatch alarms with SNS notifications
- IAM roles with least-privilege access

---

### 🔄 Project 3 — DjangoCICD (Jenkins CI/CD Pipeline)
> GitHub → Jenkins → Docker Build → DockerHub Push → Deploy on EC2

**Tech Stack:** Jenkins · GitHub Webhook · Docker · Shared Libraries · Groovy

| Feature | Detail |
|---------|--------|
| Declarative Pipeline | 4 stages: Code → Build → Test → Deploy |
| Master-Agent setup | Builds run on dedicated Agent EC2 |
| GitHub Webhook | Auto-trigger on every code push |
| Shared Libraries | Reusable Groovy functions across pipelines |
| Credentials Manager | Secure DockerHub login — no hardcoded passwords |
| Build result | Build #10 — **Finished: SUCCESS** ✅ (~1min 37s) |

```groovy
// Reusable pipeline using Shared Libraries
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

## 📁 Repository Structure

```
Devops_90-Days/
│
├── Day-01_Linux/               # File permissions, processes, systemctl
├── Day-06_Networking/          # TCP/IP, DNS, VPC, subnets
├── Day-08_Shell_Scripting/     # Automation scripts
├── Day-13_DevOps_Fundamentals/ # CI/CD concepts, SDLC, Agile
├── Day-14_Git/                 # Branching, merge, GitFlow
│
├── Day-18_AWS/                 # EC2, S3, RDS, IAM, VPC, ALB
│
├── Day-27_Docker/              # Dockerfiles, Compose, Networks, Volumes
│   └── Student-Grade-Tracker/  # Full stack project — live on AWS EC2
│
├── Day-33_Jenkins/             # Pipelines, Agents, Webhooks, RBAC
│   └── DjangoCICD/             # Complete CI/CD pipeline project
│
├── Day-38_Kubernetes/          # In Progress...
│
└── README.md
```

---

## 📊 Progress Tracker

```
🐧 Linux          ████████████████████  100% ✅
🌐 Networking     ████████████████████  100% ✅
💻 Shell Script   ████████████████████  100% ✅
⚙️  DevOps Basics  ████████████████████  100% ✅
🔧 Git/GitHub     ████████████████████  100% ✅
☁️  AWS            ████████████████████  100% ✅
🐳 Docker         ████████████████████  100% ✅
🔄 Jenkins        ████████████████████  100% ✅
☸️  Kubernetes     ████░░░░░░░░░░░░░░░░   100% ✅
⛵ Helm           ░░░░░░░░░░░░░░░░░░░░    100% ✅
🔁 ArgoCD         ░░░░░░░░░░░░░░░░░░░░  100% ✅
🏗️  Terraform      ░░░░░░░░░░░░░░░░░░░░   100% ✅
📊 Monitoring     ░░░░░░░░░░░░░░░░░░░░    100% ✅
```

---

## 🏅 Certifications

| Certification | Issuer | Valid Until |
|---------------|--------|-------------|
| AWS Certified Solutions Architect – Associate | Amazon Web Services | 2027 |
| RHCSA — Red Hat Certified System Administrator | Red Hat | 2027 |

---

## 💼 Professional Background

| Company | Role | Duration |
|---------|------|----------|
| Kyndryl India | System Management Engineer | Jan 2023 – Mar 2025 |
| Kyndryl India | Associate Technical Engineer | Sep 2021 – Jan 2023 |

**Production experience with:** AWS · Linux · IBM DB2 · IIS/FTP Web Servers · ServiceNow · 24×7 SLA Support

---

## 🔗 Connect With Me

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect%20with%20me-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/ritik-bawane)
[![GitHub](https://img.shields.io/badge/GitHub-Follow%20me-black?style=for-the-badge&logo=github)](https://github.com/RB5437)

📍 **Location:** Nagpur, Maharashtra | Open to Relocation
💼 **Open to:** DevOps Engineer · Cloud Engineer · Linux Admin
⚡ **Available:** Immediately

</div>

---

<div align="center">

**⭐ If this repo helped you, give it a star!**

*"Every expert was once a beginner. Consistency beats talent every single day."*

</div>
