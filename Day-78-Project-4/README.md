# Day 78 of #90DaysOfDevOps ✅

## 🎲 Project 2: Wanderlust — DevSecOps CI/CD Pipeline

**Date:** 22 June 2026
**Status:** 🔄 Project started — architecture planned, implementation in progress

---

## 📌 What I Did Today

- Studied the complete project structure (MERN stack: React + Node.js + MongoDB + Redis)
- Understood the CI/CD flow — Jenkins CI → Jenkins CD (GitOps) → Kubernetes
- Analyzed all key files: `Jenkinsfile`, `GitOps/Jenkinsfile`, `Automations/updateBackend.sh`, `Automations/updateFrontend.sh`, `kubernetes/` yamls, `docker-compose.yml`
- Identified outdated/incorrect versions in the project files (see table below)
- Mapped out the full architecture: Pre-Build → Build → Post-Build phases
- Understood the Jenkins Shared Library pattern (`@Library('Shared') _`) — enterprise-level reusable pipeline code

---

## 🏗️ Project Architecture

```
Developer → GitHub (devops branch) → Jenkins CI (EC2)
                                           │
                    Pre-Build:  Git checkout → OWASP → Trivy → SonarQube
                    Build:      Env setup (EC2 IP) → Docker build → Docker push
                    Post-Build: Trigger CD job + Email notification
                                           │
                              Jenkins CD (GitOps)
                              Update K8s manifest image tags → Git push
                                           │
                    Kubernetes (wanderlust namespace)
                    Frontend(:31000) + Backend(:31100) + MongoDB + Redis
                                           │
                                    User Browser
```

---

## 🆕 What's New Compared to Day 68 Capstone

| Feature | Day 68 Capstone | Day 78 Wanderlust |
|---|---|---|
| Security scanning | ❌ None | ✅ OWASP + Trivy + SonarQube |
| Pipeline pattern | Basic Jenkinsfile | Shared Library `@Library('Shared')` |
| CD approach | ArgoCD GitOps | Jenkins CD GitOps |
| App type | Spring Boot (Java) | MERN Stack (Node.js + React) |
| Kubernetes setup | Minikube | kubeadm (production-grade) |
| Email notification | ❌ None | ✅ Post-build email |

---

## ⚠️ Outdated Versions I Found (Will Fix During Implementation)

| File | Current | Fix to |
|---|---|---|
| `backend/Dockerfile` | `node:21` | `node:22-slim` |
| `frontend/Dockerfile` | `node:21` | `node:22-slim` |
| `docker-compose.yml` → redis | `redis:7.0.5-alpine` | `redis:7.4-alpine` |
| `kubernetes/mongodb.yaml` | `image: mongo` (no tag!) | `mongo:7.0` |
| `kubernetes/redis.yaml` | `image: redis` (no tag!) | `redis:7.4-alpine` |
| `kubernetes/backend.yaml` | Original creator's image | My own DockerHub image |

> Most critical finding: `kubernetes/backend.yaml` had the original creator's Docker image hardcoded — if deployed as-is, my Jenkins-built image would never actually run. This is a real production-level mistake that companies face when forking projects.

---

## 🛠️ Tech Stack

- **App:** MERN (MongoDB + Express + React + Node.js) + Redis caching
- **CI:** Jenkins + Shared Library + OWASP + Trivy + SonarQube
- **CD:** Jenkins GitOps (manifest update + git push)
- **Container:** Docker multi-stage build
- **Orchestration:** Kubernetes (kubeadm v1.29) — wanderlust namespace
- **Cloud:** AWS EC2

---

## 📅 Next Steps (Day 79 onwards)

- [ ] Launch EC2 instances (Jenkins server + Kubernetes nodes)
- [ ] Set up kubeadm cluster
- [ ] Configure Jenkins with Shared Library
- [ ] Run full CI pipeline end-to-end
- [ ] Fix all outdated versions
- [ ] Test CD pipeline — app live on Kubernetes

## Git Repo:
https://github.com/RB5437/wanderlust.git
