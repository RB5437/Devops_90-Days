# 🏆 Day 66 — Ultimate CI/CD Pipeline Project: Setup Begins

**Date:** 17 June 2026 | **Challenge:** #90DaysOfDevOps

**Project:** Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
**Tech Stack:** Java Maven + SonarQube + ArgoCD + Helm + Kubernetes
**Path in repo:** `java-maven-sonarqube-argocd-helm-k8s/spring-boot-app`

---

## ✅ Today's Progress

| # | Task | Status |
|---|------|--------|
| 1 | Repo forked + cloned (RB5437/Ultimate-CI-CD-Pipeline-...) | ✅ Done |
| 2 | Jenkins installed on EC2 — v2.555.3 | ✅ Done |
| 3 | Jenkins plugins installed (Docker Pipeline, SonarQube Scanner) | ✅ Done |
| 4 | Pipeline job `ultimate-cicd-demo` created (Pipeline script from SCM) | ✅ Done |
| 5 | SonarQube installed + running on port 9000 | ✅ Done |
| 6 | SonarQube token generated for Jenkins integration | ✅ Done |
| 7 | Jenkins credential `sonarqube` added (Secret text) | ✅ Done |
| 8 | Minikube cluster started (Kubernetes v1.35.1) | ✅ Done |
| 9 | ArgoCD Operator install steps explored (OperatorHub) | ✅ Done |
| 10 | First pipeline build | ⬜ Not run yet |
| 11 | CI stage (build/test) | ⬜ Pending |
| 12 | CD stage (ArgoCD deploy) | ⬜ Pending |

---

## 🎯 What This Project Covers

This end-to-end pipeline brings together everything learned in the last 64 days:

```
Code Push → Jenkins (CI) → SonarQube (Code Quality) → Docker Build
   → Push Image → Helm Chart → ArgoCD (CD/GitOps) → Kubernetes Deploy
```

---

## 🛠️ 1. Jenkins Setup

Installed on AWS EC2 — accessible at `<EC2-IP>:8080`

**Plugins installed:**
- Docker Pipeline — build/use Docker containers from pipelines
- SonarQube Scanner — integrate SonarQube code analysis
- Pipeline: Stage View, GitHub Branch Source (pre-installed defaults)

**Pipeline job created:**
```
Item name: ultimate-cicd-demo
Type: Pipeline
Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
Branch: *main
Script Path: java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile
```

---

## 🔍 2. SonarQube Setup

SonarQube = static code analysis tool — checks code quality, bugs, vulnerabilities before deployment.

```bash
# Access SonarQube
http://<EC2-IP>:9000
# Initial state: "SonarQube is starting..." → wait for it to come up
# Default login: admin / admin (forced password reset on first login)
```

**Generated Jenkins integration token:**
```
Account → Security → Generate Tokens
Name: jenkins
Type: Global
Expires: 30 days
Token: sqa_xxxxxxxxxxxxxxxxxxxxxxxx (copy immediately — shown only once!)
```

**Added to Jenkins as credential:**
```
Manage Jenkins → Credentials → System → Global → Add Credentials
Kind: Secret text
Secret: <sonarqube-token>
ID: sonarqube
```

---

## ☸️ 3. Minikube Cluster (Local K8s for Testing)

```bash
docker ps
# permission denied while trying to connect to docker API

newgrp docker     # refresh group membership
docker ps         # works now ✅

minikube start --driver=docker
# minikube v1.38.1 on Ubuntu 26.04
# Kubernetes v1.35.1 preloaded
# Creating docker container (CPUs=2, Memory=3072MB)
# Done! kubectl configured ✅

minikube status
# host: Running | kubelet: Running | apiserver: Running | kubeconfig: Configured

kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# minikube   Ready    control-plane   32s   v1.35.1
```

---

## 🔁 4. ArgoCD — Researched Install Options

Explored ArgoCD Operator on OperatorHub.io for cluster install:

```bash
# Step 1 — Install Operator Lifecycle Manager (OLM)
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.45.0/install.sh | bash -s v0.45.0

# Step 2 — Install ArgoCD Operator
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml

# Step 3 — Verify operator
kubectl get csv -n operators
```

This will be installed tomorrow — today was just architecture + tool research.

---

## 🔧 Errors Faced + Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| `permission denied ... docker.sock` | User not refreshed in docker group | `newgrp docker` |
| `35.175.152.253:9000 refused to connect` | SonarQube container still starting | Waited for "SonarQube is starting" → ready |
| Memory allocation warning | 3072MB too close to total 3906MB EC2 RAM | Noted — may need `--memory=2048mb` next time |

---

## 📋 Plan for Coming Days

| Day | Step |
|-----|------|
| Day 66 | Run first Jenkins build — fix pipeline errors |
| Day 67 | SonarQube code quality gate integration |
| Day 68 | Docker build + push stage in pipeline |
| Day 69 | Helm chart customization for Spring Boot app |
| Day 70 | ArgoCD install + connect to GitHub repo |
| Day 71 | Full GitOps — auto-deploy to Minikube/EKS |
| Day 72 | Monitoring — Prometheus + Grafana on the deployed app |

---

## 📊 90 Days Progress

| Phase | Status |
|-------|--------|
| Linux → AWS Fundamentals | ✅ Complete |
| Docker → Kubernetes | ✅ Complete |
| Jenkins, Helm, ArgoCD, Terraform (tools) | ✅ Complete |
| Final Project — Ultimate CI/CD Pipeline | 🔄 Day 65 — Infra Setup |

🔗 **Project Repo:** https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
