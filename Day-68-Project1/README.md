# Day 68 — Capstone Project COMPLETE: Jenkins + SonarQube + Docker + ArgoCD + Kubernetes 🎉

## Project Final Status: ✅ LIVE & WORKING

**Project Name:** Ultimate CI/CD Pipeline using Java  
**Source:** Abhishek Veeramalla — Jenkins Zero To Hero  
**Repo:** https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project  
**Final Output:** http://18.206.219.155:8085 — "I have successfully built a spring boot application using Maven — deployed onto Kubernetes using ArgoCD"

---

## Complete Architecture

```
Developer → Code Push → GitHub
                ↓ (Webhook)
        Jenkins Pipeline Triggered
                ↓
   ┌─── Jenkins CI Pipeline ───────────────┐
   │  Checkout SCM                         │
   │  Checkout                             │
   │  Build and Test (Maven)               │
   │  Static Code Analysis (SonarQube)     │
   │  Build and Push Docker Image          │
   │  Update Deployment File (sed + push)  │
   └────────────────────────────────────────┘
                ↓
        Image Updater → Manifests Repo
                ↓
        ArgoCD watches Git repo
                ↓
        Kubernetes (Minikube) — Auto Deploy
                ↓
        spring-boot-app — 2/2 pods Running ✅
```

---

## Infrastructure Setup

| Component | Tool | Detail |
|-----------|------|--------|
| Cloud | AWS EC2 (Ubuntu) | IP: 18.206.219.155 |
| CI Server | Jenkins 2.555.3 | Port 8080 |
| Code Quality | SonarQube Community | Port 9000 |
| Container Runtime | Docker | Used as Jenkins agent too |
| K8s Cluster | Minikube (driver=docker) | v1.35.1 |
| GitOps CD | ArgoCD Operator v0.18.0 | Installed via OLM |
| Image Registry | Docker Hub | ritik2909/ultimate-cicd |

---

## Setup Steps Followed

### Step 1: Jenkins Initial Setup
```
http://18.206.219.155:8080/
Set Jenkins URL → Save and Finish
```

### Step 2: Install Jenkins Plugins
```
Manage Jenkins → Plugins → Available Plugins
✅ Docker Pipeline
✅ SonarQube Scanner
✅ Pipeline: Stage View
```

### Step 3: Create Jenkins Pipeline Job
```
New Item → Name: ultimate-cicd-project → Type: Pipeline
Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
Branch: */main
Script Path: java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile
```

### Step 4: SonarQube Project + Token
```
http://18.206.219.155:9000/projects/create
Create a local project → spring-boot-demo
Generate Token: My Account → Security → Generate Token (name: jenkins)
```

### Step 5: Jenkins Credentials Setup
```
Manage Jenkins → Credentials → Global → Add Credentials

ID: sonarqube       → Secret text (SonarQube token)
ID: github           → Secret text (GitHub PAT)
ID: docker-cred      → Username with password (ritik2909 + Docker token)
```

### Step 6: Minikube Cluster Setup
```bash
minikube start --driver=docker
minikube status
kubectl get nodes
```

### Step 7: ArgoCD Operator Install (via OperatorHub)
```bash
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.45.0/install.sh | bash -s v0.45.0
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
kubectl get csv -n operators
```

### Step 8: Create ArgoCD Instance
```bash
kubectl apply -f argocd-basic.yml
kubectl get pods
```

---

## Final Result — All Stages GREEN ✅

| Stage | Status | Time |
|-------|--------|------|
| Declarative: Checkout SCM | ✅ | 379ms |
| Checkout | ✅ | 858ms |
| Build and Test | ✅ | 26s |
| Static Code Analysis | ✅ | 1min 4s |
| Build and Push Docker Image | ✅ | 9s |
| Update Deployment File | ✅ | 1s |
| Declarative: Post Actions | ✅ | 121ms |

**Total Pipeline Run Time:** ~1 minute 46 seconds  
**Build Number:** #3 (Build #1 and #2 failed — see Day68-Errors.md)

---

## SonarQube Quality Gate Result

| Metric | Grade | Value |
|--------|-------|-------|
| Security | A | 0 issues |
| Reliability | A | 0 issues |
| Maintainability | A | 1 issue |
| Coverage | — | 0.0% |
| Duplications | — | 0.0% |
| **Quality Gate** | **✅ Passed** | spring-boot-demo (79 lines, XML+Java) |

---

## Docker Image Verification

```
Docker Hub Repository: ritik2909/ultimate-cicd
Status: Public
Contains: IMAGE
Last Pushed: ✅ Confirmed
```

---

## ArgoCD Application — Final State

```
Application Name: test
Project: default
Status: 💚 Healthy  ✅ Synced
Sync: HEAD (3432212)
Last Sync: Succeeded
Comment: "Update deployment image to version 3"

Resource Tree:
test → spring-boot-app-service (Synced, Healthy)
     → spring-boot-app (Deploy, rev:1)
          → spring-boot-app-58bddd9d8d (ReplicaSet)
               → 2 pods Running (1/1 each)
```

---

## Final Live Output 🎉

```bash
kubectl get deploy
# spring-boot-app   2/2   2   2   81s

kubectl get pods
# spring-boot-app-58bddd9d8d-n22k7   1/1   Running   0   89s
# spring-boot-app-58bddd9d8d-vgmjn   1/1   Running   0   89s
```

**Browser Output:** http://18.206.219.155:8085

```
Ultimate CI/CD Pipeline using Java

"I have successfully built a spring boot application using Maven"
"This application is deployed onto Kubernetes using ArgoCD"
```

---

## Tools Used — Why Each One?

| Tool | Purpose |
|------|---------|
| Jenkins | CI automation — triggered by GitHub webhook |
| Maven | Builds Java code into .jar, runs tests |
| SonarQube | Static code analysis — quality gate check |
| Docker | Containerizes Spring Boot app |
| Docker Hub | Stores built image (ritik2909/ultimate-cicd) |
| Minikube | Local Kubernetes cluster for deployment |
| ArgoCD (Operator) | GitOps CD — auto-syncs from Git to K8s |
| OLM (Operator Lifecycle Manager) | Manages ArgoCD Operator install |

---

## Official Links

| Resource | Link |
|----------|------|
| Project GitHub | https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project |
| ArgoCD Operator | https://operatorhub.io/operator/argocd-operator |
| Jenkins | https://www.jenkins.io/ |
| SonarQube | https://www.sonarsource.com/products/sonarqube/ |
| Minikube | https://minikube.sigs.k8s.io/docs/ |
