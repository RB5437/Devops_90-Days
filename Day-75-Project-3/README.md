# Day 75 — Live DevOps Kubernetes Project | Voting App Deploy + K8s Dashboard 🗳️

**Date:** 26/06/2026
**Project:** K8s Kind Voting App with Monitoring
**GitHub Ref:** https://github.com/RB5437/k8s-kind-voting-app.git
**Status:** ✅ Voting App Live + K8s Dashboard Running

---

## 🎯 What Was Done Today

| Step | Task | Status |
|------|------|--------|
| 1 | All 9 K8s YAML files written manually | ✅ |
| 2 | Voting App deployed — 5 services running | ✅ |
| 3 | Vote UI accessible (port 5000) | ✅ |
| 4 | Result UI accessible (port 5001) | ✅ |
| 5 | Kubernetes Dashboard installed (v2.7.0) | ✅ |
| 6 | admin-user ServiceAccount + ClusterRoleBinding created | ✅ |
| 7 | Dashboard token generated + UI accessible | ✅ |

---

## 📝 K8s YAML Files Written (9 Files)

### 1. `vote-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: vote
  name: vote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vote
  template:
    metadata:
      labels:
        app: vote
    spec:
      containers:
      - image: dockersamples/examplevotingapp_vote
        name: vote
        ports:
        - containerPort: 80
          name: vote
```

### 2. `vote-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: vote
  name: vote
spec:
  type: NodePort
  ports:
  - name: "vote-service"
    port: 5000
    targetPort: 80
    nodePort: 31002
  selector:
    app: vote
```

### 3. `result-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: result
  name: result
spec:
  replicas: 1
  selector:
    matchLabels:
      app: result
  template:
    metadata:
      labels:
        app: result
    spec:
      containers:
      - image: dockersamples/examplevotingapp_result
        name: result
        ports:
        - containerPort: 80
          name: result
```

### 4. `result-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: result
  name: result
spec:
  type: NodePort
  ports:
  - name: "result-service"
    port: 5001
    targetPort: 80
    nodePort: 31001
  selector:
    app: result
```

### 5. `worker-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: worker
  name: worker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
      - image: dockersamples/examplevotingapp_worker
        name: worker
```

### 6. `redis-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - image: redis:alpine
        name: redis
        ports:
        - containerPort: 6379
          name: redis
        volumeMounts:
        - mountPath: /data
          name: redis-data
      volumes:
      - name: redis-data
        emptyDir: {}
```

### 7. `redis-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: redis
  name: redis
spec:
  type: ClusterIP
  ports:
  - name: "redis-service"
    port: 6379
    targetPort: 6379
  selector:
    app: redis
```

### 8. `db-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: db
  name: db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - image: postgres:15-alpine
        name: postgres
        env:
        - name: POSTGRES_USER
          value: postgres
        - name: POSTGRES_PASSWORD
          value: postgres
        ports:
        - containerPort: 5432
          name: postgres
        volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: db-data
      volumes:
      - name: db-data
        emptyDir: {}
```

### 9. `db-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: db
  name: db
spec:
  type: ClusterIP
  ports:
  - name: "db-service"
    port: 5432
    targetPort: 5432
  selector:
    app: db
```

---

## 🚀 Deploy Commands

```bash
# Apply all specs
kubectl apply -f k8s-specifications/

# Check pods
kubectl get pods

# Check deployments
kubectl get deployment

# Check services
kubectl get svc
```

### All Pods Running ✅
```
NAME                      READY   STATUS    RESTARTS   AGE
db-74574d66dd-c79t5       1/1     Running   0          88s
redis-6c5fb9c4b7-w4pp5    1/1     Running   0          89s
result-5f99548f7c-tvn5g   1/1     Running   0          89s
vote-5d74dcd7c7-wmp96     1/1     Running   0          89s
worker-6f5f6cdd56-d5rmg   1/1     Running   0          88s
```

### Services
```
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db           ClusterIP   10.96.8.123     <none>        5432/TCP
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP
redis        ClusterIP   10.96.189.244   <none>        6379/TCP
result       NodePort    10.96.248.15    <none>        5001:31001/TCP
vote         NodePort    10.96.189.179   <none>        5000:31002/TCP
```

### Port Forward to Access UI
```bash
kubectl port-forward svc/vote 5000:5000 --address=0.0.0.0 &
kubectl port-forward svc/result 5001:5001 --address=0.0.0.0 &
```

**Access:**
- Vote UI → `http://<EC2-PUBLIC-IP>:5000`
- Result UI → `http://<EC2-PUBLIC-IP>:5001`

---

## 📊 Kubernetes Dashboard Setup

### Install (v2.7.0 manifest)
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### dashboard.yml — Admin User
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

```bash
kubectl apply -f dashboard.yml

# Generate token
kubectl -n kubernetes-dashboard create token admin-user

# Port forward
kubectl port-forward svc/kubernetes-dashboard \
  -n kubernetes-dashboard 8080:443 --address=0.0.0.0 &
```

**Access:** `https://<EC2-PUBLIC-IP>:8080`

---

## 🔗 Official Links

| Resource | Link |
|----------|------|
| Voting App Images | https://hub.docker.com/r/dockersamples/examplevotingapp_vote |
| K8s Deployments | https://kubernetes.io/docs/concepts/workloads/controllers/deployment/ |
| K8s Services | https://kubernetes.io/docs/concepts/services-networking/service/ |
| K8s Dashboard | https://github.com/kubernetes/dashboard |

---

*Day 75 of #90DaysOfDevOps | Ritik Bhatia | DevOps Engineer*
