# 📝 Day 39 — Kubernetes Workloads Deep Notes

---

## 1. Labels & Selectors — Why They Matter

```
Labels = Key-value tags on K8s objects
Selectors = Filter objects by labels

Example:
Pod has label:  app: nginx
ReplicaSet selector: matchLabels: app: nginx
→ ReplicaSet OWNS that pod!

Without labels → K8s can't connect resources!
```

**Real world use:**
```bash
kubectl get pods -l app=nginx -n nginx      # filter by label
kubectl get pods -l env=prod                # filter by env
kubectl label pod nginx version=v1 -n nginx # add label
```

---

## 2. ReplicaSet vs Deployment

```
ReplicaSet:
✅ Maintains N replicas always running
✅ Auto-restarts crashed pods
❌ No rolling updates
❌ No rollback support

Deployment (wraps ReplicaSet):
✅ Everything ReplicaSet does +
✅ Rolling updates (zero downtime)
✅ Rollback to previous version
✅ Pause/Resume updates

Rule: ALWAYS use Deployment, not ReplicaSet directly!
```

---

## 3. Scaling — What Actually Happens

```bash
kubectl scale deployment/nginx-deployment -n nginx --replicas=10
```

```
Before: 1 pod running
After command:
  K8s Scheduler: "Need 9 more pods"
  → Finds available worker nodes
  → Schedules 9 new pods
  → All start simultaneously
  → 10 pods Running in ~3 seconds!

Scale down to 1:
  Controller Manager: "9 extra pods"
  → Terminates 9 pods gracefully
  → 1 pod remains
```

---

## 4. Rolling Update — Zero Downtime

```
Old version: nginx:latest (3 replicas running)

kubectl set image deployment/nginx-deployment nginx=nginx:1.19 -n nginx

Rolling update process:
1. Create 1 new pod (nginx:1.19)
2. Wait until new pod is Ready
3. Terminate 1 old pod (nginx:latest)
4. Repeat until all pods updated

At no point = 0 pods running!
Users never see downtime ✅
```

**Rollback:**
```bash
kubectl rollout undo deployment/nginx-deployment -n nginx
# Goes back to previous ReplicaSet immediately!
```

---

## 5. DaemonSet — When to Use

```
DaemonSet = 1 pod per node, always

Real company use cases:
✅ Log collector (Fluentd) — collect logs from every node
✅ Monitoring agent (Prometheus Node Exporter)
✅ Security scanner — scan every node
✅ Network plugin (Calico, kindnet) — K8s uses this internally!

You saw it today:
kubectl get pods -n kube-system
kindnet-cfhtl    → DaemonSet pod on node 1
kindnet-kb7rm    → DaemonSet pod on node 2
kindnet-z4bst    → DaemonSet pod on node 3
```

---

## 6. Job vs CronJob

```
Job:
- Run a task ONCE to completion
- Example: database migration, one-time report
- completions: 1 → run once
- parallelism: 1 → one pod at a time
- restartPolicy: Never → don't restart on success

Today's Job output:
demo-job   Complete   1/1   14s
kubectl logs → "Hello Good Evening!" ✅

CronJob:
- Run a task on a SCHEDULE
- Like Linux cron but for K8s
- Creates a new Job every time schedule fires

Today's CronJob:
schedule: "* * * * *" → every minute
minute-backup → creates backup job every minute
Job runs → Complete → new job next minute
```

---

## 7. CronJob Schedule Cheatsheet

```
"* * * * *"     Every minute
"*/5 * * * *"   Every 5 minutes
"0 * * * *"     Every hour at :00
"0 9 * * *"     Every day at 9 AM
"0 9 * * 1"     Every Monday at 9 AM
"0 0 1 * *"     First day of every month
"0 0 1 1 *"     Every year Jan 1st
```

---

## 8. Interview Q&A

**Q: Difference between ReplicaSet and Deployment?**
ReplicaSet maintains N replicas but has no rolling update capability. Deployment wraps ReplicaSet and adds rolling updates, rollback, pause/resume. Always use Deployment in production.

**Q: What is a DaemonSet?**
Ensures one pod runs on every node. Used for log collectors, monitoring agents, network plugins. When a new node joins, DaemonSet automatically adds a pod to it.

**Q: Difference between Job and CronJob?**
Job runs a task once to completion — used for one-time tasks like DB migration. CronJob runs Jobs on a schedule using cron syntax — used for backups, reports, cleanup tasks.

**Q: How does rolling update work?**
K8s creates new pods with updated image one at a time, waits for each to be Ready, then terminates old pods. At no point are zero pods running, ensuring zero downtime.

**Q: What are Labels and Selectors?**
Labels are key-value metadata attached to K8s objects. Selectors filter objects by labels. They connect resources — e.g., a Service uses selector to find which pods to route traffic to.

**Q: What happened when you scaled to 10 replicas?**
Controller Manager detected desired=10, current=1. Scheduler found available nodes and placed 9 new pods. All became Running in ~3 seconds.
