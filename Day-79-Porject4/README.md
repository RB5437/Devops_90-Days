# Day 79 of #90DaysOfDevOps ✅

## 🌍 Wanderlust — Kubernetes Setup + Docker Build & Push

**Date:** 07 July 2026
**Status:** ✅ Kubernetes cluster ready, Docker images built & pushed to DockerHub

---

## 📌 What I Did Today

### 1. Kubernetes Cluster Setup (kubeadm v1.35)
- Launched 2 EC2 instances — Master node + Worker node
- Ran `script1.sh` on both nodes — CRI-O runtime + Kubernetes v1.35 packages installed
- Ran `script2.sh` on Master node — kubeadm init, Calico CNI applied, join command generated
- Worker node joined cluster successfully

### 2. Namespace + Context Setup
- Created `wanderlust` namespace
- Set default context to `wanderlust` namespace

### 3. CoreDNS Scaling
- Scaled CoreDNS replicas from 2 → 4 (spread across both master + worker nodes)
- Verified CoreDNS pods running on both nodes

### 4. Environment Variables Updated
- `backend/.env.docker` — updated `FRONTEND_URL` with Worker node public IP
- `frontend/.env.docker` — updated `VITE_API_PATH` with Worker node public IP (port 31100)

### 5. Docker Images Built
- `ritik2909/backend-wanderlust:latest` — Node.js Express backend (node:22 → node:22-slim, multi-stage)
- `ritik2909/frontend-wanderlust:latest` — React + Vite frontend (node:22 → node:22-slim, multi-stage)
- Unit tests ran inside Docker build — 28/37 tests passed

### 6. Docker Images Pushed to DockerHub ✅
- Fixed DockerHub PAT token issue (Read-only → Read & Write)
- Both images successfully pushed to `ritik2909` DockerHub account

---

## 🏗️ Cluster Info

| Component | Details |
|---|---|
| Master Node | `ip-172-31-29-72` — control-plane |
| Worker Node | `ip-172-31-22-15` — Ready |
| Kubernetes Version | v1.35.0 |
| CRI Runtime | CRI-O |
| CNI Plugin | Calico v3.32.1 |
| Namespace | wanderlust |

---

## 🐳 Docker Images

| Image | Tag | Size |
|---|---|---|
| `ritik2909/backend-wanderlust` | latest | 458MB |
| `ritik2909/frontend-wanderlust` | latest | 749MB |

---

## 📋 Key Commands Used

```bash
# Cluster verify
kubectl get nodes
kubectl get pods -n kube-system

# Namespace setup
kubectl create namespace wanderlust
kubectl config set-context --current --namespace wanderlust

# CoreDNS scaling
kubectl edit deploy coredns -n kube-system
# replicas: 2 → 4

# Docker build
docker build -t ritik2909/backend-wanderlust:latest .    # backend/
docker build -t ritik2909/frontend-wanderlust:latest .   # frontend/

# Docker push
docker logout
docker login -u ritik2909   # Read & Write PAT token
docker push ritik2909/backend-wanderlust:latest
docker push ritik2909/frontend-wanderlust:latest
```

---

## 📅 Next Steps (Day 80)

- [ ] Apply Kubernetes manifests (`kubectl apply -f kubernetes/`)
- [ ] Create PersistentVolume + PVC for MongoDB
- [ ] Deploy MongoDB + Redis pods
- [ ] Deploy Backend + Frontend pods
- [ ] Verify app accessible at `Worker-Node-IP:31000`
## Project Repo
https://github.com/RB5437/wanderlust.git
