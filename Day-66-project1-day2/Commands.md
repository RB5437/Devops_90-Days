# ⌨️ Day 65 — Commands Reference

## Jenkins Setup
```bash
# Access Jenkins
http://<EC2-IP>:8080

# Install plugins via UI
Manage Jenkins → Plugins → Available plugins
Search: docker, sonar → select → Install
```

## Pipeline Job Creation
```
New Item → Name: ultimate-cicd-demo → Type: Pipeline
Configure → Pipeline → Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project
Branch Specifier: *main
Script Path: java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile
Save
```

## SonarQube
```bash
# Access SonarQube
http://<EC2-IP>:9000

# Default login (first time)
Username: admin
Password: admin
# → forces password reset

# Generate token for Jenkins
Account → Security → Generate Tokens
Name: jenkins | Type: Global | Expires: 30 days → Generate
# Copy token immediately!
```

## Jenkins Credentials — Add SonarQube Token
```
Manage Jenkins → Credentials → System → Global credentials → Add Credentials
Kind: Secret text
Secret: <paste sonarqube token>
ID: sonarqube
Create
```

## Docker + Minikube
```bash
docker ps
# permission denied while trying to connect to docker API

newgrp docker
docker ps          # works now

minikube start --driver=docker
minikube status
kubectl get nodes
```

## ArgoCD Operator (researched, not yet installed)
```bash
# Step 1 — Install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.45.0/install.sh | bash -s v0.45.0

# Step 2 — Install ArgoCD Operator
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml

# Step 3 — Verify
kubectl get csv -n operators
```

## Jenkins Restart (if needed)
```bash
http://<EC2-IP>:8080/restart
```
