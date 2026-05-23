# ☸️ Day 41 — Kubernetes: StatefulSets (MySQL)

**Date:** 23 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | StatefulSet vs Deployment | ✅ Done |
| 2 | Headless Service | ✅ Done |
| 3 | MySQL StatefulSet | ✅ Done |
| 4 | volumeClaimTemplates | ✅ Done |
| 5 | Resource Requests + Limits | ✅ Done |

---

## 📁 Files Created Today

```
Day-41-Kubernetes/
├── config.yml
├── install_kind.sh
└── mysql/
    ├── namespace.yml
    ├── service.yml
    └── statefulsets.yml
```

---

## 📌 1. Namespace

```yaml
# namespace.yml
kind: Namespace
apiVersion: v1
metadata:
  name: mysql
```

```bash
kubectl apply -f namespace.yml
kubectl get ns
```

---

## 📌 2. Headless Service

```yaml
# service.yml
kind: Service
apiVersion: v1
metadata:
  name: mysql-service
  namespace: mysql
spec:
  clusterIP: None        # ← This makes it Headless!
  selector:
    app: mysql
  ports:
  - name: mysql
    protocol: TCP
    port: 3306
    targetPort: 3306
```

```bash
kubectl apply -f service.yml
kubectl get svc -n mysql
# mysql-service   None   <none>   3306/TCP
```

> **Why clusterIP: None?**
> StatefulSet pods get individual DNS names:
> `mysql-statefulset-0.mysql-service.mysql.svc.cluster.local`
> `mysql-statefulset-1.mysql-service.mysql.svc.cluster.local`
> Each pod is reachable individually — not load balanced!

---

## 📌 3. StatefulSet — MySQL

```yaml
# statefulsets.yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-statefulset
  namespace: mysql
spec:
  serviceName: mysql-service
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mariadb:10.6
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: root
            - name: MYSQL_DATABASE
              value: devops
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "384Mi"
              cpu: "250m"
          volumeMounts:
            - name: mysql-data
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: mysql-data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 1Gi
```

```bash
kubectl apply -f statefulsets.yml
kubectl get statefulset -n mysql
# NAME                READY   AGE
# mysql-statefulset   1/1     2m ✅

kubectl get pods -n mysql
# NAME                  READY   STATUS    AGE
# mysql-statefulset-0   1/1     Running   2m ✅

kubectl get pvc -n mysql
# NAME                           STATUS   VOLUME   CAPACITY
# mysql-data-mysql-statefulset-0 Bound    ...      1Gi ✅
```

---

## 🆚 StatefulSet vs Deployment

| Feature | Deployment | StatefulSet |
|---------|-----------|-------------|
| Pod names | Random (nginx-abc123) | Ordered (mysql-0, mysql-1) |
| Pod identity | Interchangeable | Unique, stable |
| Storage | Shared PVC | Each pod gets OWN PVC |
| Startup order | Parallel | Sequential (0 → 1 → 2) |
| DNS | Single service IP | Individual pod DNS |
| Use case | Stateless apps | Stateful apps (DB, Kafka) |
| Scaling up | Any order | 0 → 1 → 2 → N |
| Scaling down | Any order | N → N-1 → 1 → 0 |

---

## 📌 Resource Requests vs Limits

```yaml
resources:
  requests:           # Minimum guaranteed resources
    memory: "128Mi"   # K8s reserves this on the node
    cpu: "100m"       # 100 millicores = 0.1 CPU
  limits:             # Maximum allowed resources
    memory: "384Mi"   # Pod killed if exceeds this
    cpu: "250m"       # Throttled if exceeds this
```

| Field | Meaning | What happens if exceeded |
|-------|---------|------------------------|
| requests.cpu | Minimum CPU guaranteed | Nothing — just scheduling |
| requests.memory | Minimum RAM guaranteed | Nothing — just scheduling |
| limits.cpu | Max CPU allowed | Pod gets throttled |
| limits.memory | Max RAM allowed | Pod gets OOMKilled! |

---

## 📌 volumeClaimTemplates — Key Concept

```yaml
volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ReadWriteOnce]
      resources:
        requests:
          storage: 1Gi
```

**Why special?**
```
Deployment + PVC:
  All pods → SAME PVC → SAME data
  Problem: 2 DB pods writing same file = corruption!

StatefulSet + volumeClaimTemplates:
  mysql-statefulset-0 → mysql-data-mysql-statefulset-0 (own PVC)
  mysql-statefulset-1 → mysql-data-mysql-statefulset-1 (own PVC)
  mysql-statefulset-2 → mysql-data-mysql-statefulset-2 (own PVC)
  Each pod = own isolated storage ✅
```

---

## 📊 Kubernetes Progress

| Day | Date | Topics | Timestamp | Status |
|-----|------|--------|-----------|--------|
| Day 38 | 20 May | Architecture + KIND + Minikube + Namespaces | 00:00 – 01:35 | ✅ Done |
| Day 39 | 21 May | Pods + Deployments + ReplicaSets + DaemonSets + Jobs + CronJobs | 01:35 – 02:39 | ✅ Done |
| Day 40 | 22 May | Storage + PV + PVC + Services + Django Project + Ingress | 02:39 – 03:47 | ✅ Done |
| Day 41 | 23 May | StatefulSets — MySQL with volumeClaimTemplates | 03:47 – 04:11 | ✅ Done |
| Day 42 | 24 May | ConfigMaps + Secrets + Resource Quotas + Probes + Taints + HPA | 04:11 – 05:50 | ⬜ Tomorrow |
| Day 43 | 25 May | VPA + Node Affinity + RBAC + Monitoring + CRDs + Helm | 05:50 – 07:37 | ⬜ Upcoming |
| Day 44 | 26 May | SideCar + Istio Service Mesh | 08:13 – 09:09 | ⬜ Upcoming |
| Day 45 | 27 May | Projects — Chat App + Three-tier + EKS | 09:09 – End | ⬜ Upcoming |

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
