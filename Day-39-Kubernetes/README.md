# ☸️ Day 39 — Kubernetes Workloads: Pods, Deployments, ReplicaSets, DaemonSets, Jobs, CronJobs

**Date:** 21 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Namespaces | ✅ Done |
| 2 | Pods | ✅ Done |
| 3 | Labels & Selectors | ✅ Done |
| 4 | ReplicaSet | ✅ Done |
| 5 | Deployment + Rolling Update | ✅ Done |
| 6 | Scaling (1 → 5 → 10 → 1) | ✅ Done |
| 7 | DaemonSet | ✅ Done |
| 8 | Jobs | ✅ Done |
| 9 | CronJob | ✅ Done |

---

## 📁 Files Created Today

```
kubernetes-2/
├── namespace.yml
├── pod.yml
├── deployment.yml
├── replicasets.yml
├── daemonsets.yml
├── job.yml
└── cron-job.yml
```

---

## 📌 1. Namespace

```yaml
# namespace.yml
kind: Namespace
apiVersion: v1
metadata:
  name: nginx
```
```bash
kubectl apply -f namespace.yml
kubectl get ns
```

---

## 📌 2. Pod

```yaml
# pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```
```bash
kubectl apply -f pod.yml
kubectl get pods -n nginx
```

---

## 📌 3. ReplicaSet

```yaml
# replicasets.yml
kind: ReplicaSet
apiVersion: apps/v1
metadata:
  name: nginx-replicsets
  namespace: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      name: nginx-replic-pod
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
          - containerPort: 80
```
```bash
kubectl apply -f replicasets.yml
kubectl get replicasets -n nginx
# nginx-replicsets   2   2   2   2m8s ✅
```

---

## 📌 4. Deployment + Rolling Update + Scaling

```yaml
# deployment.yml
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
```

```bash
kubectl apply -f deployment.yml

# Scale up to 5
kubectl scale deployment/nginx-deployment -n nginx --replicas=5
kubectl get pods -n nginx   # 5 pods Running ✅

# Scale up to 10
kubectl scale deployment/nginx-deployment -n nginx --replicas=10
kubectl get pods -n nginx   # 10 pods Running ✅

# Scale down to 1
kubectl scale deployment/nginx-deployment -n nginx --replicas=1
kubectl get pods -n nginx   # 1 pod Running ✅
```

### Rolling Update:
```bash
# Update image version
kubectl set image deployment/nginx-deployment nginx=nginx:1.19 -n nginx

# Watch rolling update
kubectl rollout status deployment/nginx-deployment -n nginx

# Rollback if needed
kubectl rollout undo deployment/nginx-deployment -n nginx
```

---

## 📌 5. DaemonSet

```yaml
# daemonsets.yml
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: nginx-daemonsets
  namespace: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      name: nginx-daemon-pod
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
          - containerPort: 80
```
```bash
kubectl apply -f daemonsets.yml
kubectl get daemonsets -n nginx
# DaemonSet runs 1 pod on EVERY node automatically!
```

---

## 📌 6. Job

```yaml
# job.yml
kind: Job
apiVersion: batch/v1
metadata:
  name: demo-job
  namespace: nginx
spec:
  completions: 1
  parallelism: 1
  template:
    metadata:
      name: demo-job-pod
      labels:
        app: batch-task
    spec:
      containers:
      - name: batch-container
        image: busybox:latest
        command: ["sh", "-c", "echo Hello Good Evening! && sleep 10"]
      restartPolicy: Never
```
```bash
kubectl apply -f job.yml
kubectl get job -n nginx
# demo-job   Complete   1/1   14s   24s ✅

kubectl logs pod/demo-job-nrlfq -n nginx
# Hello Good Evening! ✅
```

---

## 📌 7. CronJob

```yaml
# cron-job.yml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: minute-backup
  namespace: nginx
spec:
  schedule: "* * * * *"   # Every minute
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            app: minute-backup
        spec:
          containers:
          - name: backup-container
            image: busybox
            command:
            - sh
            - -c
            - >
              echo "Backup Started";
              mkdir -p /backups &&
              mkdir -p /demo-data &&
              cp -r /demo-data /backups &&
              echo "Backup Completed";
            volumeMounts:
            - name: data-volume
              mountPath: /demo-data
            - name: backup-volume
              mountPath: /backups
          restartPolicy: OnFailure
          volumes:
          - name: data-volume
            hostPath:
              path: /demo-data
              type: DirectoryOrCreate
          - name: backup-volume
            hostPath:
              path: /backup
              type: DirectoryOrCreate
```

### CronJob Schedule Format:
```
* * * * *
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)

"* * * * *"   = Every minute
"0 * * * *"   = Every hour
"0 0 * * *"   = Every day midnight
"0 0 * * 0"   = Every Sunday
```

```bash
kubectl apply -f cron-job.yml
kubectl get cj -n nginx
# minute-backup   * * * * *   <none>   False   0   <none>   11s

kubectl get jobs -n nginx -w
# minute-backup running → Complete 1/1 ✅
```

---

## 🆚 Workload Comparison

| Workload | Use Case | Self-Heal | Scale | Schedule |
|----------|----------|-----------|-------|----------|
| Pod | Single container | ❌ | ❌ | ❌ |
| ReplicaSet | Maintain N replicas | ✅ | ✅ | ❌ |
| Deployment | Rolling updates | ✅ | ✅ | ❌ |
| DaemonSet | 1 pod per node | ✅ | Auto | ❌ |
| Job | Run once to completion | ✅ | ✅ | ❌ |
| CronJob | Scheduled tasks | ✅ | ✅ | ✅ |

---

## 📊 Kubernetes Progress

| Day | Date | Topics | Timestamp | Status |
|-----|------|--------|-----------|--------|
| Day 38 | 20 May | Architecture + KIND + Minikube + Kubeadm + Namespaces | 00:00 – 01:35 | ✅ Done |
| Day 39 | 21 May | Pods + Deployments + Labels + Rolling Update + ReplicaSets + DaemonSets + Jobs + CronJobs | 01:35 – 02:39 | ✅ Done |
| Day 40 | 22 May | Storage + PV + StorageClasses + PVC + Services + Ingress + Annotations | 02:39 – 03:47 | ⬜ Tomorrow |
| Day 41 | 23 May | StatefulSets + ConfigMaps + Secrets + Resource Quotas & Limits | 03:47 – 04:40 | ⬜ Upcoming |
| Day 42 | 24 May | Probes + Taints/Tolerations + HPA + VPA + Node Affinity | 04:40 – 06:11 | ⬜ Upcoming |
| Day 43 | 25 May | RBAC + Monitoring + CRDs + Operators + Helm + K8s API | 06:11 – 07:37 | ⬜ Upcoming |
| Day 44 | 26 May | SideCar/Init Containers + Istio Service Mesh | 08:13 – 09:09 | ⬜ Upcoming |
| Day 45 | 27 May | Project 1: Chat App (Minikube) + Project 2: Three-tier (KIND) + EKS Mega Project | 09:09 – End | ⬜ Upcoming |

---

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
📺 **Video:** Kubernetes In One Shot — TrainWithShubham
