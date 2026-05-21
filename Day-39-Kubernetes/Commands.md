# ⚡ Day 39 — Kubernetes Workloads Commands

---

## 📦 Namespace

```bash
kubectl apply -f namespace.yml
kubectl get ns
kubectl get namespace
kubectl delete ns nginx
```

---

## 🫙 Pod

```bash
kubectl apply -f pod.yml
kubectl get pods -n nginx
kubectl describe pod nginx -n nginx
kubectl logs nginx -n nginx
kubectl exec -it nginx -n nginx -- bash
kubectl delete pod nginx -n nginx
```

---

## 🔁 ReplicaSet

```bash
kubectl apply -f replicasets.yml
kubectl get replicasets -n nginx       # full
kubectl get rs -n nginx                # short form
kubectl describe rs nginx-replicsets -n nginx
kubectl delete rs nginx-replicsets -n nginx
```

---

## 🚀 Deployment

```bash
# Apply
kubectl apply -f deployment.yml
kubectl get deployments -n nginx
kubectl get deploy -n nginx            # short

# Scale
kubectl scale deployment/nginx-deployment -n nginx --replicas=1
kubectl scale deployment/nginx-deployment -n nginx --replicas=5
kubectl scale deployment/nginx-deployment -n nginx --replicas=10

# Rolling Update
kubectl set image deployment/nginx-deployment nginx=nginx:1.19 -n nginx
kubectl rollout status deployment/nginx-deployment -n nginx
kubectl rollout history deployment/nginx-deployment -n nginx

# Rollback
kubectl rollout undo deployment/nginx-deployment -n nginx
kubectl rollout undo deployment/nginx-deployment -n nginx --to-revision=2

# Pause / Resume
kubectl rollout pause deployment/nginx-deployment -n nginx
kubectl rollout resume deployment/nginx-deployment -n nginx

# Delete
kubectl delete deploy nginx-deployment -n nginx
```

---

## 👿 DaemonSet

```bash
kubectl apply -f daemonsets.yml
kubectl get daemonsets -n nginx
kubectl get ds -n nginx                # short
kubectl describe ds nginx-daemonsets -n nginx
kubectl delete ds nginx-daemonsets -n nginx
```

---

## 💼 Job

```bash
kubectl apply -f job.yml
kubectl get job -n nginx
kubectl get jobs -n nginx
kubectl describe job demo-job -n nginx

# Get pod created by job
kubectl get pods -n nginx

# Get logs of job pod
kubectl logs pod/demo-job-nrlfq -n nginx
# Output: Hello Good Evening! ✅

kubectl delete job demo-job -n nginx
```

---

## ⏰ CronJob

```bash
kubectl apply -f cron-job.yml

# Get cronjob
kubectl get cronjob -n nginx
kubectl get cj -n nginx               # short

# Watch jobs being created every minute
kubectl get jobs -n nginx -w

# Get logs
kubectl get pods -n nginx
kubectl logs <cronjob-pod-name> -n nginx

# Manually trigger a cronjob
kubectl create job --from=cronjob/minute-backup manual-backup -n nginx

# Delete
kubectl delete cj minute-backup -n nginx
```

---

## 🏷️ Labels & Selectors

```bash
# Filter pods by label
kubectl get pods -l app=nginx -n nginx
kubectl get pods -l env=prod

# Add label to pod
kubectl label pod nginx version=v1 -n nginx

# Remove label
kubectl label pod nginx version- -n nginx

# Show labels
kubectl get pods --show-labels -n nginx
```

---

## 🔍 Useful Debug Commands

```bash
# All resources in namespace
kubectl get all -n nginx

# Watch pods live
kubectl get pods -n nginx -w

# Pod events
kubectl describe pod <pod-name> -n nginx

# Resource usage
kubectl top pods -n nginx
kubectl top nodes
```

---

## 📝 Apply All Files

```bash
cd kubernetes-2/
kubectl apply -f namespace.yml
kubectl apply -f pod.yml
kubectl apply -f replicasets.yml
kubectl apply -f deployment.yml
kubectl apply -f daemonsets.yml
kubectl apply -f job.yml
kubectl apply -f cron-job.yml

# Or apply all at once
kubectl apply -f .
```

---

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
