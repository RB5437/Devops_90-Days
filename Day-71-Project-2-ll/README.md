# Day 71 — BoardGame DevSecOps: 4-Phase Plan + Repository Setup 🎲

> **Date:** 22/06/2026  
> **Status:** Architecture understood + Phase 1 (Repository Setup) complete

---

## The 4-Phase Implementation Plan

Before touching any tool, the whole project was broken down into 4 clear phases — this is exactly how real DevOps engineers plan infra work before executing.

```
PHASE 1 → Setup Repository
PHASE 2 → Setting up Infra (Cluster, Runner, SonarQube server, Monitoring)
PHASE 3 → Write the whole CI/CD pipeline
PHASE 4 → Perform Monitoring (System level + Website level)
```

---

## Phase 1 — Setup Repository ✅ (Done Today)

This is the foundation — fork/clone the source code, understand the project structure, and prepare the Git repo that the entire pipeline will be built around.

```bash
# Fork the reference repo to your own GitHub account
# https://github.com/jaiswaladi246/Boardgame → fork to RB5437/Boardgame

git clone https://github.com/RB5437/Boardgame.git
cd Boardgame
ls
```

**Repo Structure Reviewed:**
```
Boardgame/
├── src/                      ← Java Spring Boot source code
├── Dockerfile                ← Multi-stage build (Maven build → JRE runtime)
├── deployment-service.yaml   ← Kubernetes Deployment + Service
├── sonar-project.properties  ← SonarQube project config
├── Jenkinsfile                ← Base pipeline (compile, test, build)
└── pom.xml                   ← Maven dependencies
```

---

## Phase 2 — Setting Up Infra (Planned, starts next)

### 2.1 Setup Kubernetes Cluster
This is where the application will finally be deployed.

### 2.2 Setup Runner
A Runner = a virtual machine that we configure and add as a device to run all the CI/CD commands. We provision a VM, configure it, then register it with GitHub Actions — once configured, it becomes the "runner" that executes pipeline jobs.

**Two types of Runners:**

| Type | Description |
|------|-------------|
| **Public Runner** | Free to use, but it's a **shared runner** — used by many people on GitHub's infrastructure |
| **Private Runner** | A **personal runner** — your own VM, dedicated only to your pipelines |

### 2.3 Setup SonarQube Server
Self-hosted code quality + security analysis server.

### 2.4 Setup Monitoring
Base infra for Prometheus + Grafana — set up before the app is even deployed, so metrics are captured from day one.

---

## Phase 3 — CI/CD Pipeline (Planned)

Write the complete CI/CD pipeline covering:
- Building the application
- Building Docker images
- Pushing Docker images
- Scanning Docker images (Trivy)
- Deployment to Kubernetes

---

## Phase 4 — Monitoring (Planned)

Two types of monitoring will be performed:

| Type | What It Tracks |
|------|----------------|
| **System Level** | CPU, RAM — health of the underlying infrastructure |
| **Website Level** | Traffic — health and usage of the actual deployed application |

---

## Networking — Ports & Security Groups Planned

Before provisioning the EC2/VM, the required inbound rules were mapped out in advance — this avoids repeated back-and-forth security group edits later.

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | SSH | Server access |
| 80 | HTTP | Web traffic |
| 443 | HTTPS | Secure web traffic |
| 3000–10000 | Custom TCP | General app/dashboard ports (e.g. Grafana) |
| 6443 | Custom TCP | Kubernetes API server |
| 465 | SMTPS | Secure mail notifications |
| 25 | SMTP | Mail notifications |
| 27017 | Custom TCP | MongoDB (self-hosted, if used) |
| 30000–32767 | Custom TCP | Kubernetes NodePort range |

**Why plan ports in advance:** Kubernetes NodePort services always use the 30000–32767 range, and the API server always listens on 6443 — knowing this ahead of time means the EC2 Security Group can be created correctly in one shot instead of debugging "connection refused" errors later (a mistake from the Day 68 project).

---

## Why This Planning Matters (Interview Angle)

> "Before implementation, I broke the project into 4 phases — repository setup, infrastructure setup (cluster, runner, SonarQube, monitoring), the actual CI/CD pipeline, and finally monitoring. I also pre-planned the required network ports based on what Kubernetes and the supporting tools need — this is the same approach used in real infrastructure projects to avoid firefighting security group issues mid-deployment."

---

## Next Steps — Day 72

| Task | Detail |
|------|--------|
| Provision Kubernetes cluster | EC2-based or managed |
| Setup GitHub Actions Runner | Decide public vs private runner |
| Install SonarQube server | Self-hosted on EC2 |
| Base monitoring setup | Prometheus + Grafana skeleton |

---

## Official Links

| Resource | Link |
|----------|------|
| Reference Project | https://github.com/RB5437/Boardgame.git |
| GitHub Actions Runners Docs | https://docs.github.com/en/actions/hosting-your-own-runners |
| Kubernetes NodePort Docs | https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport |
| SonarQube | https://www.sonarsource.com/products/sonarqube/ |
