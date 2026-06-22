# Day 70 — Project 2 Planning: BoardGame DevSecOps Pipeline 🎲🔒

> **Status: Planning & Architecture only — implementation starts Day 71**

---

## Project Name

**BoardGame DevSecOps Pipeline**
*"Secure CI/CD Pipeline for a Java Spring Boot Web Application"*

---

## Real World Problem It Solves

Companies fear unsigned, vulnerable, or low-quality code reaching production. A normal CI/CD pipeline (like Day 68's capstone) builds and deploys fast — but does not check for **security vulnerabilities** or **code quality** before deployment. This project adds a full **DevSecOps** layer: security scanning is built into every stage, not bolted on afterward.

**Why this project is different from Day 68 capstone:**

| Day 68 Capstone | Day 70 BoardGame Project |
|---|---|
| Jenkins → SonarQube → Docker → ArgoCD → K8s | Jenkins → SonarQube → **Trivy (filesystem scan)** → Docker → **Trivy (image scan)** → K8s → **Prometheus + Grafana** |
| Focus: GitOps automation | Focus: Security at every gate (DevSecOps) |
| ArgoCD-driven deployment | Direct kubectl/Jenkins-driven deployment + monitoring |

---

## Skills Used in This Project

| Skill | Where It's Used |
|-------|-----------------|
| Linux | Jenkins server setup on EC2, file permissions, service management |
| Git/GitHub | Source repo, pull request + merge workflow |
| Jenkins | Full CI pipeline — compile, test, build, scan, deploy |
| AWS | EC2 hosting for Jenkins + SonarQube |
| Docker | Multi-stage Dockerfile — build + runtime image |
| Kubernetes | Deployment + Service (LoadBalancer) for the live app |
| Prometheus + Grafana | Post-deployment monitoring of the running application |
| Python (optional extension) | Custom health-check or notification script |

---

## Application Overview

**App:** BoardGame Database — a Java Spring Boot web app where users can list, review, and rate board games.

| Detail | Value |
|--------|-------|
| Language | Java 17 |
| Framework | Spring Boot |
| Build Tool | Maven |
| Source | https://github.com/RB5437 (forked from DevOps Shack reference) |
| Container Port | 8080 |

---

## Complete Flow — From Ticket to Production

This is the real-world process, exactly as planned on paper:

1. **Client raises a ticket** (Jira/ServiceNow) — e.g. "Add a new feature / change background color"
2. **Ticket assigned to developer**
3. **Developer writes code locally**, adds the new feature, tests it locally
4. **Developer pushes code to GitHub** — on a feature branch
5. **Developer raises a Pull Request** to merge feature branch → main
6. **Project architect/lead reviews the PR** — if code looks fine, it's merged to main
7. **GitHub webhook fires** → Jenkins pipeline triggers automatically on new commit to main
8. **Jenkins Pipeline stages run in order:**
   - Compile the source code
   - Run unit test cases (Maven)
   - SonarQube static analysis — code quality check
   - SonarQube Quality Gate check (pass/fail gate)
   - Trivy filesystem scan — scan entire repo for vulnerabilities/sensitive data
   - Build the application — generate the artifact (.jar)
   - Publish artifact to GitHub (instead of Nexus, since this is a smaller setup)
   - Build Docker image from the artifact
   - Trivy image scan — scan the Docker image for vulnerabilities
   - Push Docker image to Docker Hub
   - Deploy to Kubernetes (Deployment + Service)
9. **Application is live** — accessible via Kubernetes LoadBalancer/NodePort
10. **Monitor the live application** using Prometheus (metrics) + Grafana (dashboards)
11. **Feedback loop** — if client raises another ticket (new feature/bug), the cycle repeats from step 1

---

## Architecture — Pipeline Stages (as planned)

```
Client → Jira Ticket → Developer (local code + test)
        ↓
GitHub (push + PR + merge to main)
        ↓
Jenkins triggered via webhook
        ↓
   ┌─────────────────────────────────┐
   │ Compile → Unit Test (Maven)     │
   │ SonarQube Analysis + Gate Check │
   │ Trivy FS Scan (repo)            │
   │ Build Artifact (Maven package)  │
   │ Publish Artifact → GitHub       │
   │ Docker Build & Tag              │
   │ Trivy Image Scan                │
   │ Docker Push → Docker Hub        │
   └─────────────────────────────────┘
        ↓
Kubernetes Deployment + Service (LoadBalancer)
        ↓
Live Deployed Website
        ↓
Prometheus + Grafana (Monitoring)
        ↓
(Feedback loop → new ticket if issue/feature found)
```

---

## Jenkinsfile (Current — base version, to be extended)

```groovy
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    stages {
        stage('Compile') {
            steps { sh 'mvn compile' }
        }
        stage('Test') {
            steps { sh 'mvn test' }
        }
        stage('Build') {
            steps { sh 'mvn package' }
        }
    }
}
```

**To be added in Day 71-72:** SonarQube stage, Trivy FS scan stage, Docker build/push stage, Trivy image scan stage, Kubernetes deploy stage.

---

## Dockerfile (Multi-stage — already prepared)

```dockerfile
# ===== Build Stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# ===== Runtime Stage =====
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Why multi-stage build?** Build stage has Maven + JDK (heavy), runtime stage only has JRE (lightweight). Final image is much smaller — good practice point to mention in interview.

---

## Kubernetes Manifest (deployment-service.yaml — already prepared)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: boardgame-deployment
spec:
  selector:
    matchLabels:
      app: boardgame
  replicas: 2
  template:
    metadata:
      labels:
        app: boardgame
    spec:
      containers:
        - name: boardgame
          image: <your-dockerhub>/boardgame:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: boardgame-ssvc
spec:
  selector:
    app: boardgame
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

**Note:** 2 replicas configured for high availability — if one pod fails, the other continues serving traffic.

---

## SonarQube Project Config (already prepared)

```properties
sonar.projectKey=Boardgame
sonar.projectName=Boardgame
sonar.java.binaries=.
```

---

## What's Different/New vs Day 68 — Key Talking Point for Interview

| New Tool | Why It's Added Here |
|----------|---------------------|
| **Trivy (filesystem scan)** | Scans the entire source repo before build — catches secrets, vulnerable dependencies early |
| **Trivy (image scan)** | Scans the final Docker image before pushing — catches vulnerabilities baked into the container layers |
| **SonarQube Quality Gate (enforced)** | Pipeline can be configured to actually FAIL if code quality drops below threshold — not just informational |
| **Prometheus + Grafana on live app** | Unlike Day 68 (infra-focused monitoring), this monitors the actual application's health post-deployment |

---



---

## Official Links

| Resource | Link |
|----------|------|
| Trivy Official | https://aquasecurity.github.io/trivy/ |
| SonarQube | https://www.sonarsource.com/products/sonarqube/ |
| Spring Boot | https://spring.io/projects/spring-boot |
| Reference Project (DevOps Shack) | https://github.com/jaiswaladi246/Boardgame |
