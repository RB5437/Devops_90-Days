# ⌨️ Day 48 — ArgoCD Commands

## Setup — Docker + KIND + kubectl + Helm

```bash
# Docker
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
docker --version   # 29.1.3 ✅

# KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
kind version       # v0.31.0 ✅

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client   # v1.36.1 ✅

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh && ./get_helm.sh
helm version   # v4.2.0 ✅
```

## KIND Cluster

```bash
vim kind-config.yml
# kind: Cluster
# apiVersion: kind.x-k8s.io/v1alpha4
# networking:
#   apiServerAddress: "172.31.17.5"   # EC2 private IP
#   apiServerPort: 33893
# nodes:
#   - role: control-plane
#     image: kindest/node:v1.33.1
#   - role: worker
#     image: kindest/node:v1.33.1

kind create cluster --name argocd-cluster --config kind-config.yml
kubectl get nodes   # control-plane + worker Ready ✅
kubectl cluster-info --context kind-argocd-cluster
```

## Install ArgoCD via Helm

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd

# Verify — 7 pods running
kubectl get pods -n argocd
kubectl get svc -n argocd

# Access UI — port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &

# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
# Output: cFazyeKZTRksqVOE
```

## ArgoCD CLI

```bash
# Install CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
argocd version --client   # v3.4.3 ✅

# Login
argocd login 54.167.12.217:8080 --username admin --password admin@123 --insecure

# Verify login
argocd account get-user-info

# Add cluster
kubectl config get-contexts
argocd cluster add kind-argocd-cluster --name argocd-cluster --insecure
argocd cluster list
```

## Deploy Nginx — UI Approach

```bash
# Port forward after UI deploy
kubectl get pods      # nginx-5644956b5f-2zst5  Running ✅
kubectl get svc       # nginx-service ClusterIP ✅
kubectl port-forward svc/nginx-service 8081:80 --address 0.0.0.0
# Browser: 54.167.12.217:8081 → Welcome to nginx! ✅
```

## Deploy Apache — CLI Approach

```bash
argocd app create apache-app \
  --repo https://github.com/rb5437/argocd-demos.git \
  --path cli_approach/apache \
  --dest-server https://172.31.17.5:33893 \
  --dest-namespace default \
  --sync-policy automated \
  --self-heal \
  --auto-prune

# Verify
kubectl get pods   # 4 apache pods Running ✅
kubectl port-forward svc/apache-service 8082:80 --address 0.0.0.0

# Check app status
argocd app get apache-app
argocd app list
```

## ArgoCD Projects — UI

```bash
# Settings → Projects → New Project
# Name: online-shop
# Description: This project holds apps for online shopping website
# → CREATE ✅
```

## Useful ArgoCD Commands

```bash
argocd app list                          # list all apps
argocd app get <app-name>               # app details
argocd app sync <app-name>             # manual sync
argocd app delete <app-name>           # delete app
argocd app history <app-name>          # sync history
argocd app rollback <app-name> <id>    # rollback
argocd cluster list                     # list clusters
argocd repo list                        # list repos
```
