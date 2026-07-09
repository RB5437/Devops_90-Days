# Day 80 of #90DaysOfDevOps ✅

## 🌍 Wanderlust — Kubernetes Deployment Complete + App LIVE!

**Date:** 08 July 2026
**Status:** ✅ Full MERN stack app deployed on Kubernetes — LIVE in browser!
**Live URL:** http://34.236.151.105:31000

---

## 📌 What I Did Today

### 1. Applied Kubernetes Manifests
- PersistentVolume + PVC for MongoDB data persistence
- MongoDB, Redis, Backend, Frontend deployments
- All 4 NodePort/ClusterIP services configured

### 2. Debugged and Fixed Multiple Real Errors
- MongoDB kernel incompatibility (mongo:8.0 → mongo:7.0)
- ImagePullBackOff (creator's image → ritik2909's own images)
- CORS issue (wrong port 5173 → correct NodePort 31000)
- Frontend calling wrong backend IP (old IP → updated, rebuilt image)
- MongoDB DNS resolution failure (EAI_AGAIN — timing issue, fixed with rollout restart)

### 3. Final Working State
- All 4 pods Running: MongoDB + Redis + Backend + Frontend
- Blog post created and saved to MongoDB
- Featured post visible on homepage
- Full MERN stack working end-to-end

---

## 🏗️ Final Architecture

```
Browser (User)
    ↓ http://34.236.151.105:31000
Frontend Pod (React + Vite) — NodePort 31000
    ↓ API calls to http://34.236.151.105:31100
Backend Pod (Node.js + Express) — NodePort 31100
    ↓ mongodb://mongo-service/wanderlust
MongoDB Pod (mongo:7.0) — ClusterIP 27017 — PVC mounted
    ↓ redis://redis-service:6379
Redis Pod (redis:7.4-alpine) — ClusterIP 6379
```

---

## 🏆 Cluster Info

| Component | Details |
|---|---|
| Master Node | `ip-172-31-27-26` (control-plane) |
| Worker Node | `ip-172-31-30-194` (Ready) |
| Kubernetes Version | v1.35.0 |
| CRI Runtime | CRI-O |
| CNI Plugin | Calico v3.32.1 |
| Namespace | wanderlust |

---

## 🐳 Docker Images Used

| Image | Version |
|---|---|
| `ritik2909/backend-wanderlust` | latest (node:22-slim) |
| `ritik2909/frontend-wanderlust` | latest (node:22-slim) |
| `mongo` | 7.0 (downgraded from 8.0 — kernel incompatibility) |
| `redis` | 7.4-alpine |

---

## 📋 Final kubectl get all Output

```
NAME                                       READY   STATUS    RESTARTS
pod/backend-deployment-d979c77f-7ldtz      1/1     Running   0
pod/frontend-deployment-78bb57857c-7vkbq   1/1     Running   0
pod/mongo-deployment-7874cfd947-bd4mr      1/1     Running   0
pod/redis-deployment-d7d987df6-psc2d       1/1     Running   0

NAME                       TYPE        CLUSTER-IP      PORT(S)
backend-service            NodePort    10.101.209.79   8080:31100/TCP
frontend-service           NodePort    10.98.33.219    5173:31000/TCP
mongo-service              ClusterIP   10.102.18.210   27017/TCP
redis-service              ClusterIP   10.105.222.14   6379/TCP
```

---

## 📅 Key Commands Used Today

```bash
# Apply manifests
kubectl apply -f persistentVolume.yaml
kubectl apply -f persistentVolumeClaim.yaml
kubectl apply -f mongodb.yaml
kubectl apply -f redis.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml

# Debug
kubectl describe pod <pod-name>
kubectl logs deployment/backend-deployment
kubectl logs deployment/backend-deployment -f
kubectl get endpoints
kubectl exec -it deployment/backend-deployment -- cat /app/.env

# Fix and redeploy
kubectl rollout restart deployment backend-deployment
kubectl rollout restart deployment frontend-deployment
kubectl delete replicaset <old-rs-name>

# Verify
kubectl get all -n wanderlust
kubectl get pods -o wide
```

---

## 🎯 What This Project Demonstrates

- Manual Kubernetes cluster setup (kubeadm) — not managed (EKS/GKE)
- 4 microservices deployed and communicating via Kubernetes DNS
- PersistentVolume for stateful MongoDB data
- Real-world debugging — kernel incompatibility, CORS, DNS, ImagePull
- GitOps-ready manifests with version-pinned images
- Live accessible application in browser

---

## 📚 Project References

- App: [DevMadhup/wanderlust](https://github.com/DevMadhup/wanderlust) — devops branch
- My DockerHub: [ritik2909/backend-wanderlust](https://hub.docker.com/r/ritik2909/backend-wanderlust)
- My DockerHub: [ritik2909/frontend-wanderlust](https://hub.docker.com/r/ritik2909/frontend-wanderlust)
- My GitHub: [RB5437/Devops-90-Days](https://github.com/RB5437/Devops-90-Days)
