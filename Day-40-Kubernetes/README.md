# ☸️ Day 40 — Kubernetes: Storage, PV, PVC, Services, Ingress & Django Project

**Date:** 22 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Persistent Volume (PV) | ✅ Done |
| 2 | Persistent Volume Claim (PVC) | ✅ Done |
| 3 | PV + PVC + Deployment integration | ✅ Done |
| 4 | Services — ClusterIP | ✅ Done |
| 5 | Port Forwarding | ✅ Done |
| 6 | Django Notes App — Docker Build + Push | ✅ Done |
| 7 | Django Notes App — K8s Deployment | ✅ Done |
| 8 | Ingress Controller — NGINX | ✅ Done |
| 9 | Ingress Rules + Annotations | ✅ Done |
| 10 | foo-bar Ingress example | ✅ Done |

---

## 📁 Files Created Today

```
Day-40-Kubernetes/
├── kind-cluster
├── NameSpace.yml
├── Deployment.yml          (with PVC volume mount)
├── PersistentVolume.yml
├── PersistentVolumeClaim.yml
├── service.yml
└── project/
    ├── Dockerfile
    ├── notesapp/settings.py
    └── k8s/
        ├── namespace.yml
        ├── deployment.yml
        └── service.yml
    └── nginx/
        └── ingress.yml
```

---

## 📌 1. Persistent Volume (PV)

```yaml
# PersistentVolume.yml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: local-pv
  namespace: nginx
  labels:
    app: local
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  hostPath:
    path: /mnt/data
```

```bash
kubectl apply -f PersistentVolume.yml
kubectl get pv
# NAME       CAPACITY   ACCESS MODES   STATUS      STORAGECLASS
# local-pv   1Gi        RWO            Available   local-storage ✅
```

---

## 📌 2. Persistent Volume Claim (PVC)

```yaml
# PersistentVolumeClaim.yml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: local-pvc
  namespace: nginx
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 900Mi
  storageClassName: local-storage
```

```bash
kubectl apply -f PersistentVolumeClaim.yml
kubectl get pvc -n nginx
# NAME        STATUS   VOLUME     CAPACITY   STORAGECLASS
# local-pvc   Bound    local-pv   1Gi        local-storage ✅

kubectl get pv,pvc
# PV: Bound → default/local-pvc ✅
# PVC: Bound → local-pv ✅
```

---

## 📌 3. Deployment with PVC (Volume Mount)

```yaml
# Deployment.yml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: nginx-deployment
  namespace: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      name: nginx-dep-pod
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
          - containerPort: 80
          volumeMounts:
          - mountPath: /var/www/html
            name: my-local-volume
      volumes:
        - name: my-local-volume
          persistentVolumeClaim:
            claimName: local-pvc
```

```bash
kubectl apply -f Deployment.yml
kubectl get pods -n nginx
# nginx-deployment-xxx   1/1   Running ✅
# nginx-deployment-xxx   1/1   Running ✅

# Verify volume mounted inside worker node
docker exec -it <worker-container-id> bash
cd /mnt/data   # PV hostPath — exists! ✅
```

---

## 📌 4. Service — ClusterIP

```yaml
# service.yml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

```bash
kubectl apply -f service.yml
kubectl get all -n nginx
# service/nginx-service   ClusterIP   10.96.243.163   <none>   80/TCP ✅

# Port forward to access service
sudo KUBECONFIG=$HOME/.kube/config kubectl port-forward \
  service/nginx-service -n nginx 81:80 --address=0.0.0.0
```

---

## 📌 5. Django Notes App — Docker Build & Push

```bash
# Build image
docker build -t notes-app-k8s .
# Successfully built f8cddb4ade92 ✅

# Tag & Push to DockerHub
docker login -u ritik2909
docker image tag notes-app-k8s:latest ritik2909/notes-app-k8s:latest
docker push ritik2909/notes-app-k8s:latest
# latest: digest: sha256:f8cddb4... ✅
```

---

## 📌 6. Django Notes App — Kubernetes Deployment

```yaml
# k8s/deployment.yml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: notes-app-deployment
  namespace: notes-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: notes-app
  template:
    metadata:
      labels:
        app: notes-app
    spec:
      containers:
        - name: notes-app
          image: ritik2909/notes-app-k8s
          ports:
          - containerPort: 8000
```

```yaml
# k8s/service.yml
kind: Service
apiVersion: v1
metadata:
  name: notes-app-services
  namespace: nginx
spec:
  selector:
    app: notes-app
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
  type: ClusterIP
```

```bash
kubectl apply -f namespace.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml

kubectl get pods -n notes-app
# notes-app-deployment-xxx   1/1   Running ✅

# Port forward
kubectl port-forward service/notes-app-services \
  -n notes-app 8000:8000 --address=0.0.0.0
```

---

## 📌 7. Ingress Controller — NGINX

```bash
# Install NGINX Ingress Controller for KIND
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Verify
kubectl get pods -n ingress-nginx
# ingress-nginx-controller-xxx   1/1   Running ✅

kubectl get svc -n ingress-nginx
# ingress-nginx-controller   LoadBalancer   80:32756,443:31617 ✅
```

---

## 📌 8. Ingress Rules + Annotations

```yaml
# ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-notes-ingress
  namespace: nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /nginx
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: notes-app-services
            port:
              number: 8000
```

```bash
kubectl apply -f ingress.yml
kubectl get ingress -n nginx
# nginx-notes-ingress   nginx   *   localhost   80 ✅

# Access via port-forward
kubectl port-forward service/ingress-nginx-controller \
  -n ingress-nginx 9090:80 --address=0.0.0.0
# http://<ec2-ip>:9090/nginx  → nginx service
# http://<ec2-ip>:9090/       → notes-app service
```

---

## 🐛 Errors Faced & Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| Pod stuck in Pending | PVC not found in pod's namespace | Added `namespace: nginx` to PVC |
| `mountPth` YAML error | Typo in volumeMounts | Fixed to `mountPath` |
| Port 80 permission denied | Port <1024 needs root | Used port 81 or `sudo KUBECONFIG=...` |
| Port 8080 already in use | Another process using it | Used port 9090 |
| `notes-app-service` not found | Wrong service name in ingress | Fixed to `notes-app-services` |
| `kubernets.io` annotation typo | Typo in annotation key | Fixed to `kubernetes.io` |
| Django DB error | `HOST` env var not set | Updated settings.py |

---

## 🆚 Service Types Comparison

| Type | Access | Use Case |
|------|--------|---------|
| ClusterIP | Inside cluster only | Internal services |
| NodePort | Via node IP + port | Dev/testing |
| LoadBalancer | External via cloud LB | Production |
| Ingress | HTTP/HTTPS routing | Multiple services |

---

## 📊 Kubernetes Progress

| Day | Date | Topics | Timestamp | Status |
|-----|------|--------|-----------|--------|
| Day 38 | 20 May | Architecture + KIND + Minikube + Namespaces | 00:00 – 01:35 | ✅ Done |
| Day 39 | 21 May | Pods + Deployments + ReplicaSets + DaemonSets + Jobs + CronJobs | 01:35 – 02:39 | ✅ Done |
| Day 40 | 22 May | Storage + PV + PVC + Services + Django Project + Ingress + Annotations | 02:39 – 03:47 | ✅ Done |
| Day 41 | 23 May | StatefulSets + ConfigMaps + Secrets + Resource Quotas | 03:47 – 04:40 | ⬜ Tomorrow |
| Day 42 | 24 May | Probes + Taints/Tolerations + HPA + VPA + Node Affinity | 04:40 – 06:11 | ⬜ Upcoming |
| Day 43 | 25 May | RBAC + Monitoring + CRDs + Helm | 06:11 – 07:37 | ⬜ Upcoming |
| Day 44 | 26 May | SideCar + Istio Service Mesh | 08:13 – 09:09 | ⬜ Upcoming |
| Day 45 | 27 May | Projects — Chat App + Three-tier + EKS | 09:09 – End | ⬜ Upcoming |

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
