# Day 80 of #90DaysOfDevOps ✅

## 🌍 Wanderlust — Full Kubernetes Deployment (Manual `kubectl apply`, No Jenkins/GitOps)

**Date:** 08 July 2026
**Status:** ✅ App LIVE at `http://34.236.151.105:31000`

> **Note:** Is deployment mein Jenkins CI/CD aur GitOps flow **use nahi kiya** — sab kuch manually `kubectl apply -f` se kiya gaya, seedha self-managed `kubeadm` cluster pe. Docker images bhi manually `docker build` + `docker push` se banaye. Jenkins pipeline is project mein hai (repo ke andar), lekin Day 80 ka deployment isse independent hai.

---

## 📌 What I Did Today

### 1. PersistentVolume + PVC for MongoDB
- Applied `persistentVolume.yaml` (hostPath, 5Gi) aur `persistentVolumeClaim.yaml`
- MongoDB data ab pod restart pe persist karega

### 2. MongoDB Deployment
- Pehle `mongo:8.0` try kiya → crash
- Root cause debug kiya (see Errors.md) → `mongo:7.0` pe downgrade kiya
- Stale ReplicaSet cleanup kiya jo purane crash-looping pods spawn kar raha tha

### 3. Redis Deployment
- `redis.yaml` apply kiya — pehli try mein hi Running ho gaya

### 4. Backend + Frontend Deployment
- `backend.yaml` aur `frontend.yaml` apply kiye (NodePort services — backend `31100`, frontend `31000`)
- Docker images DockerHub pe push kiye (`ritik2909/backend-wanderlust`, `ritik2909/frontend-wanderlust`)
- `.env.docker` mein `FRONTEND_URL` galat port (`5173`) pe tha — `31000` (NodePort) pe fix kiya, image rebuild + push + rollout restart kiya

### 5. Service Discovery Debug
- Backend se MongoDB tak DNS resolution intermittent fail ho raha tha (`mongo-service`) — CoreDNS, resolv.conf, endpoints sab verify kiye, rollout restart se resolve ho gaya

### 6. App LIVE Verification
- Browser mein `http://34.236.151.105:31000` khola → Homepage load
- Blog post create kiya — MongoDB save + Redis cache dono working confirm kiya

---

## 🏗️ Final Cluster State

| Component | Image | Status |
|---|---|---|
| MongoDB | `mongo:7.0` | 1/1 Running |
| Redis | `redis:7.4-alpine` (existing yaml) | 1/1 Running |
| Backend | `ritik2909/backend-wanderlust:latest` | 1/1 Running |
| Frontend | `ritik2909/frontend-wanderlust:latest` | 1/1 Running |

| Service | Type | Port |
|---|---|---|
| mongo-service | ClusterIP | 27017 |
| redis-service | ClusterIP | 6379 |
| backend-service | NodePort | 8080 → 31100 |
| frontend-service | NodePort | 5173 → 31000 |

**App URL:** http://34.236.151.105:31000

---

## 📋 Key Commands Used

```bash
# Storage
kubectl apply -f persistentVolume.yaml
kubectl apply -f persistentVolumeClaim.yaml

# Core services
kubectl apply -f mongodb.yaml
kubectl apply -f redis.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml

# Debug
kubectl get pods -n wanderlust
kubectl describe pod <pod-name>
kubectl logs deployment/backend-deployment
kubectl get replicaset
kubectl rollout restart deployment <name>
kubectl rollout undo deployment mongo-deployment --to-revision=2

# Rebuild + push after .env fix
docker build -t ritik2909/backend-wanderlust:latest .
docker push ritik2909/backend-wanderlust:latest
```


## Project Repo
https://github.com/RB5437/wanderlust.git
