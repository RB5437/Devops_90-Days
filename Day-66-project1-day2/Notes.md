# 📝 Day 65 — Project Notes

## Project Identity
- Name: Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
- Stack: Java Maven + SonarQube + ArgoCD + Helm + Kubernetes
- Goal: Full GitOps pipeline — code push to live deployment, automatically

## Jenkins
- v2.555.3, running on EC2 port 8080
- Pipeline jobs pull JenkinsFile directly from GitHub (SCM) — not typed in UI
- Script Path field tells Jenkins exactly where the JenkinsFile lives in repo
- Plugins needed for this project: Docker Pipeline, SonarQube Scanner

## SonarQube
- Runs on port 9000 — takes a minute to fully start ("SonarQube is starting...")
- Static code analysis — catches bugs, code smells, security issues before deploy
- Token-based auth is safer than username/password for CI integration
- Token shown only ONCE at generation — must copy immediately
- Token stored in Jenkins as "Secret text" credential type

## Minikube
- Local single-node Kubernetes — good for testing before EKS/real cluster
- `newgrp docker` needed after adding user to docker group (session refresh)
- `--driver=docker` runs minikube inside a Docker container
- Watch memory allocation — EC2 free tier has limited RAM, don't over-allocate

## ArgoCD
- GitOps tool — watches a Git repo, auto-syncs cluster to match
- Operator Lifecycle Manager (OLM) = standard way to install K8s Operators
- ArgoCD Operator simplifies install + upgrades vs raw manifests

## Key Mindset for Today
- Don't rush into pipeline runs without understanding the architecture
- Tool integration (Jenkins ↔ SonarQube ↔ ArgoCD) takes setup time
- "Day 1" of a real project = infrastructure + tool wiring, not feature code

## Errors & Fixes
- Docker permission denied → `newgrp docker`
- SonarQube connection refused → just needed to wait for startup
- Memory warning on minikube start → noted for future smaller allocation
