# Day 69 — Project 1 Complete: Ultimate CI/CD Pipeline

**Date:** 20 June 2026 | **Challenge:** #90DaysOfDevOps
**Days Spent:** Day 65 → Day 68 (4 days)
**Status:** ✅ LIVE & COMPLETE

---

## 📌 Project Name

**Ultimate CI/CD Pipeline — Java Spring Boot on Kubernetes using GitOps**

> A production-style, end-to-end CI/CD pipeline that takes code from a developer's laptop to a live running application on Kubernetes — fully automated, with zero manual deployment steps.

**Project GitHub:** https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
**Reference:** Abhishek Veeramalla — Jenkins Zero To Hero
**Live Output:** http://18.206.219.155:8085

---

## 🛠️ Tech Stack

| Category | Tool | Version |
|---|---|---|
| Cloud | AWS EC2 (Ubuntu) | — |
| CI Server | Jenkins | 2.555.3 |
| Build Tool | Apache Maven | 3.x |
| Code Quality | SonarQube | Community 10.4 |
| Containerization | Docker | — |
| Container Registry | Docker Hub | ritik2909/ultimate-cicd |
| GitOps CD | ArgoCD Operator | v0.18.0 (via OLM) |
| Kubernetes | Minikube | v1.35.1 (K8s v1.35.1) |
| Pipeline Type | Declarative Pipeline | — |
| Build Agent | Docker-in-Docker | ritik2909/maven-abhishek-docker-agent:v1 |

---

## 🏗️ Architecture

```
Developer
    │
    │  git push / pull request
    ▼
GitHub (Source Repo)
    │
    │  Webhook → HTTP POST to Jenkins
    ▼
┌─────────────────────────────────────────────────────────┐
│                  JENKINS CI PIPELINE                    │
│  (Declarative Pipeline | Docker Agent)                  │
│                                                         │
│  Stage 1: Checkout SCM                                  │
│  Stage 2: Build & Test  →  mvn clean package            │
│  Stage 3: Static Code Analysis  →  SonarQube (9000)    │
│  Stage 4: Build & Push Docker Image  →  DockerHub       │
│  Stage 5: Update Deployment File  →  sed + git push     │
└─────────────────────────────────────────────────────────┘
                              │
              deployment.yml updated with new BUILD_NUMBER
                              │
                              ▼
                    GitHub (Manifests Repo)
                              │
                   ArgoCD watches this repo
                              │
                              ▼
                    ┌────────────────┐
                    │    ArgoCD      │  GitOps Auto-Sync
                    │  (Operator)    │
                    └────────────────┘
                              │
                              ▼
                    ┌────────────────┐
                    │  Kubernetes    │  Minikube
                    │  (Minikube)    │  2 pods running
                    └────────────────┘
                              │
                              ▼
              http://18.206.219.155:8085  ✅  LIVE
```

---

## 🔧 Implementation — Step by Step

### Day 65 — Project Kickoff

- Forked the reference repo to: `RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project`
- Explored project structure:
  - `Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/` → source code + Dockerfile + JenkinsFile
  - `Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app-manifests/` → `deployment.yml` + `service.yml`
- Understood CI/CD architecture before writing a single line

---

### Day 66 — Infrastructure Setup

**Jenkins Setup on EC2:**
```bash
# Access Jenkins
http://<EC2-IP>:8080

# Plugins installed:
# Docker Pipeline, SonarQube Scanner, Pipeline Stage View

# Pipeline job created:
New Item → ultimate-cicd-project → Pipeline
Definition: Pipeline script from SCM
Repository: https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
Script Path: Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile
```

**SonarQube Setup:**
```bash
http://<EC2-IP>:9000
# Login: admin/admin → forced password reset
# Generated token: Account → Security → Generate Tokens
# Token added to Jenkins as: Secret text | ID: sonarqube
```

**Jenkins Credentials Added:**
| ID | Type | Purpose |
|---|---|---|
| `sonarqube` | Secret text | SonarQube auth token |
| `github` | Secret text | GitHub PAT for git push |
| `docker-cred` | Username/password | DockerHub push (ritik2909) |

**Minikube Cluster:**
```bash
newgrp docker              # refresh docker group permissions
minikube start --driver=docker
minikube status
kubectl get nodes
# minikube   Ready   control-plane   32s   v1.35.1
```

**ArgoCD Install (OperatorHub via OLM):**
```bash
# Step 1 — Install Operator Lifecycle Manager
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.45.0/install.sh | bash -s v0.45.0

# Step 2 — Install ArgoCD Operator
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml

# Step 3 — Verify
kubectl get csv -n operators
# argocd-operator.v0.18.0   Succeeded ✅

# Step 4 — Create ArgoCD instance
kubectl apply -f argocd-basic.yml
kubectl get pods
# example-argocd-application-controller   Running ✅
# example-argocd-redis                    Running ✅
# example-argocd-repo-server              Running ✅
# example-argocd-server                   Running ✅
```

---

### Day 67 — Pipeline Debugging

Fixed multiple Jenkinsfile issues (see Errors section below) and got pipeline to Build #3 — all stages GREEN.

**Final JenkinsFile (after all fixes):**
```groovy
pipeline {
  agent {
    docker {
      image 'ritik2909/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=""'
    }
  }
  stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
      }
    }
    stage('Build and Test') {
      steps {
        sh 'ls -ltr'
        sh 'cd Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app && mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://<EC2-IP>:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh '''
            apt-get update -qq && apt-get install -y -qq openjdk-17-jdk
            export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
            export PATH=$JAVA_HOME/bin:$PATH
            cd Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app
            mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
          '''
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "ritik2909/ultimate-cicd:${BUILD_NUMBER}"
        DOCKER_API_VERSION = "1.44"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
          sh 'cd Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app && docker build -t ${DOCKER_IMAGE} .'
          def dockerImage = docker.image("${DOCKER_IMAGE}")
          docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
            dockerImage.push()
          }
        }
      }
    }
    stage('Update Deployment File') {
      environment {
        GIT_REPO_NAME = "Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project"
        GIT_USER_NAME = "RB5437"
      }
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          sh '''
            git config user.email "ritikbawane5437@gmail.com"
            git config user.name "ritik bawane"
            sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
            git add Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
            git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
          '''
        }
      }
    }
  }
}
```

---

### Day 68 — ArgoCD Setup + App Live

**ArgoCD Login:**
```bash
# Get admin password (Operator stores it differently than Helm install)
kubectl get secret example-argocd-cluster -n default \
  -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{$v | base64decode}}{{"\\n"}}{{end}}'

# Output revealed: admin.password: 0iclz4w8KEC3jWNQSY5bpRonITXZVDFg
# Login: admin / 0iclz4w8KEC3jWNQSY5bpRonITXZVDFg ✅
```

**ArgoCD Application Created:**
```
Name: test
Project: default
Source Repo: https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
Path: Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app-manifests
Destination: https://kubernetes.default.svc
Namespace: default
Sync Policy: Automatic
```

**After fixing namespace errors (see Errors section):**
```bash
kubectl get deploy
# spring-boot-app   2/2   2   2   81s ✅

kubectl get pods
# spring-boot-app-58bddd9d8d-n22k7   1/1   Running ✅
# spring-boot-app-58bddd9d8d-vgmjn   1/1   Running ✅

# Port-forward to access externally
kubectl port-forward --address 0.0.0.0 svc/spring-boot-app-service 8085:80 &
```

---

## 🐛 Errors Faced & Solved

### Error 1 — Docker Permission Denied
```
permission denied while trying to connect to Docker daemon socket
```
**Cause:** User added to docker group but session not refreshed.
**Fix:**
```bash
newgrp docker
```

### Error 2 — SonarQube Connection Refused on Port 9000
```
ERR_CONNECTION_REFUSED — 35.175.152.253:9000
```
**Cause:** SonarQube takes 30-60 seconds to fully start after launch.
**Fix:** Waited for "SonarQube is starting..." spinner to disappear → refreshed → login screen appeared.

### Error 3 — Case-Sensitive Folder Name (`java` vs `Java`)
```
cd: can't cd to java-maven-sonarqube-argocd-helm-k8s/spring-boot-app
```
**Cause:** Linux is case-sensitive. Repo folder is `Java-maven-...` (capital J), but some stages used `java-maven-...`.
**Fix:** Used exact case `Java-maven-sonarqube-argocd-helm-k8s` in every `cd` across all stages.

### Error 4 — SonarQube UnsupportedClassVersionError (JDK Mismatch)
```
java.lang.UnsupportedClassVersionError: class file version 61.0
this version of the Java Runtime only recognizes class file versions up to 55.0
```
**Cause:** SonarQube 10.4 requires Java 17 (class file version 61) but build agent had only Java 11 (version 55).
**Fix:** Installed JDK 17 inside the pipeline stage before running SonarQube scan:
```bash
apt-get install -y openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

### Error 5 — Docker Client API Version Mismatch
```
Error response from daemon: client version 1.41 is too old.
Minimum supported API version is 1.44
```
**Cause:** Host Docker Engine was updated but the Docker agent container had an old Docker CLI (API 1.41).
**Fix:** Added environment variable in pipeline stage:
```groovy
environment {
    DOCKER_API_VERSION = "1.44"
}
```

### Error 6 — Deprecated Base Image (adoptopenjdk → Eclipse Temurin)
```
ERROR: pull access denied, repository does not exist
adoptopenjdk/openjdk21:alpine-jre
```
**Cause:** AdoptOpenJDK Docker Hub org was deprecated — images no longer exist.
**Fix:** Updated Dockerfile base image:
```dockerfile
FROM eclipse-temurin:21-jre-alpine
```

### Error 7 — Build #1 Failed (Config Incomplete)
**Cause:** First run — plugins not fully configured, Script Path validation.
**Fix:** Verified all plugins installed + script path correct → re-ran.

### Error 8 — Build #2 Failed at "Update Deployment File"
**Cause:** GitHub credential binding incorrect — `git push` rejected.
**Fix:** Updated Jenkinsfile with correct credential binding and explicit git remote URL with token:
```bash
git push https://${GITHUB_TOKEN}@github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project HEAD:main
```

### Error 9 — ArgoCD Admin Password Not Found
```bash
kubectl get secret example-argocd-cluster -o jsonpath="{.data.['admin\.password']}" | base64 -d
# (empty output)
```
**Cause:** Standard ArgoCD (Helm) stores password in `argocd-initial-admin-secret`. ArgoCD Operator (OLM) stores it in `example-argocd-cluster` with different key — and double quotes broke the jsonpath escaping.
**Fix:** Used go-template to dump all keys and find the correct one:
```bash
kubectl get secret example-argocd-cluster -n default \
  -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{$v | base64decode}}{{"\\n"}}{{end}}'
# admin.password: 0iclz4w8KEC3jWNQSY5bpRonITXZVDFg ✅
```

### Error 10 — ArgoCD App "3 Errors, Health: Missing"
```
ComparisonError: Failed to load live state: cluster level Deployment
can not be managed when in namespaced mode

InvalidSpecError: Namespace for spring-boot-app apps/v1, Kind=Deployment is missing
InvalidSpecError: Namespace for spring-boot-app-service /v1, Kind=Service is missing
```
**Cause:** Kubernetes manifests (`deployment.yml`, `service.yml`) had no `namespace:` field. ArgoCD's namespaced-mode controller requires it to be declared.
**Fix:** Set Destination Namespace to `default` explicitly in ArgoCD Application config → triggered Refresh + Sync.

### Error 11 — App Not Accessible in Browser (Minikube Internal IP)
```bash
minikube service spring-boot-app-service --url
# http://192.168.49.2:31375  → NOT accessible from browser externally
```
**Cause:** `192.168.49.2` is Minikube's internal Docker network IP — only reachable from inside the EC2 instance.
**Fix:**
```bash
# Port-forward to EC2 public IP
kubectl port-forward --address 0.0.0.0 svc/spring-boot-app-service 8085:80 &

# AWS Security Group → Inbound Rules → Add:
# Custom TCP | Port: 8085 | Source: 0.0.0.0/0
```

---

## ✅ Final Output

### Jenkins Pipeline — Build #3 — ALL STAGES GREEN

| Stage | Status | Time |
|---|---|---|
| Declarative: Checkout SCM | ✅ | 379ms |
| Checkout | ✅ | 858ms |
| Build and Test | ✅ | 26s |
| Static Code Analysis | ✅ | 1min 4s |
| Build and Push Docker Image | ✅ | 9s |
| Update Deployment File | ✅ | 1s |
| Declarative: Post Actions | ✅ | 121ms |
| **Total** | **✅ SUCCESS** | **~1min 46s** |

---

### SonarQube Quality Gate — PASSED ✅

| Metric | Grade |
|---|---|
| Security | A |
| Reliability | A |
| Maintainability | A |
| Quality Gate | ✅ Passed |

---

### Docker Hub — Image Pushed ✅

```
Repository: ritik2909/ultimate-cicd
Tag: 3 (BUILD_NUMBER)
Status: ✅ Pushed — "Last pushed a few minutes ago"
```

---

### ArgoCD — Healthy + Synced ✅

```
App: test
Status: 💚 Healthy   ✅ Synced
Last Sync: Succeeded
Commit: "Update deployment image to version 3"

Resource Tree:
  spring-boot-app-service  →  Synced, Healthy
  spring-boot-app (Deploy) →  Synced, Healthy
    └── ReplicaSet spring-boot-app-58bddd9d8d
          ├── Pod spring-boot-app-58bddd9d8d-n22k7  1/1 Running ✅
          └── Pod spring-boot-app-58bddd9d8d-vgmjn  1/1 Running ✅
```

---

### Kubernetes — 2/2 Pods Running ✅

```bash
kubectl get deploy
# NAME              READY   UP-TO-DATE   AVAILABLE
# spring-boot-app   2/2     2            2

kubectl get pods
# spring-boot-app-58bddd9d8d-n22k7   1/1   Running
# spring-boot-app-58bddd9d8d-vgmjn   1/1   Running
```

---

### 🌐 Live App in Browser ✅

**URL:** http://18.206.219.155:8085

```
┌──────────────────────────────────────────────────────────┐
│          Ultimate CI/CD Pipeline using Java              │
│                                                          │
│  "I have successfully built a spring boot application    │
│   using Maven"                                           │
│                                                          │
│  "This application is deployed onto Kubernetes           │
│   using ArgoCD"                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🎓 Key Learnings from This Project

1. **Linux is case-sensitive** — one capital letter difference in folder name = silent pipeline failure
2. **SonarQube version dictates JDK** — the SonarQube server version, not your app's Java version, decides what JDK the scanner needs
3. **ArgoCD Operator ≠ ArgoCD Helm** — secret structure is completely different, can't follow standard docs blindly
4. **Read the full console log** — the real error is often several lines above where the stage showed red
5. **Minikube IP is internal** — always need `port-forward` + Security Group to expose app from EC2 to browser
6. **Docker CLI and Docker daemon can drift** — host daemon update can break agent's bundled CLI version
7. **Tutorials age** — `adoptopenjdk` images no longer exist, switched to Eclipse Temurin
8. **GitOps bridge** — the `sed` + `git push` stage is what connects Jenkins CI to ArgoCD CD — most important stage to understand and explain in interview

---

## 🔗 Links

| Resource | Link |
|---|---|
| My Project Repo | https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project |
| My 90 Days Repo | https://github.com/RB5437/Devops_90-Days |
| Reference Video | https://www.youtube.com/watch?v=JGQI5pkK82w |
| Reference Repo | https://github.com/iam-veeramalla/Jenkins-Zero-To-Hero |
