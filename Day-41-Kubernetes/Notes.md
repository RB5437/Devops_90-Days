# 📝 Day 41 — StatefulSet Deep Notes

---

## 1. Why StatefulSet Exists — The Problem

```
Imagine MySQL cluster with 3 replicas using Deployment:

Pod-1 (mysql-abc) → /var/lib/mysql (PVC-1)
Pod-2 (mysql-xyz) → /var/lib/mysql (PVC-1) ← SAME PVC!
Pod-3 (mysql-def) → /var/lib/mysql (PVC-1) ← SAME PVC!

All 3 pods writing to same database files = DATA CORRUPTION ❌

Also:
Pod restarts → gets NEW random name → mysql-abc → mysql-qwe
Database loses its identity — replication breaks!
```

**StatefulSet Solution:**
```
mysql-statefulset-0 → mysql-data-0 (OWN PVC) ✅
mysql-statefulset-1 → mysql-data-1 (OWN PVC) ✅
mysql-statefulset-2 → mysql-data-2 (OWN PVC) ✅

Pod restarts → SAME name (mysql-statefulset-0) ✅
Pod restarts → SAME PVC (mysql-data-0) ✅
Pod restarts → SAME DNS ✅
Identity preserved!
```

---

## 2. Headless Service — Deep Understanding

```
Normal Service (clusterIP: 10.96.x.x):
  client → Service IP → random pod (load balanced)
  You don't know WHICH pod you're talking to

Headless Service (clusterIP: None):
  No cluster IP assigned
  DNS returns individual pod IPs directly
  You can talk to SPECIFIC pods

DNS entries created:
  mysql-statefulset-0.mysql-service.mysql.svc.cluster.local
  mysql-statefulset-1.mysql-service.mysql.svc.cluster.local
  mysql-statefulset-2.mysql-service.mysql.svc.cluster.local

Why needed for MySQL?
  Primary (mysql-0) → accepts WRITES
  Replicas (mysql-1, mysql-2) → accept READS only
  App needs to know WHICH is primary!
  Only possible with headless service + stable DNS
```

---

## 3. Ordered Startup and Shutdown

```
Scale UP (replicas: 1 → 3):
  mysql-statefulset-0 starts → waits for Running+Ready
  mysql-statefulset-1 starts → waits for Running+Ready
  mysql-statefulset-2 starts ✅

Why ordered? Database needs:
  Primary (0) must be up before replicas (1,2) can join!

Scale DOWN (replicas: 3 → 1):
  mysql-statefulset-2 deleted first
  mysql-statefulset-1 deleted
  mysql-statefulset-0 remains ✅

Why reverse order? Graceful replication teardown
```

---

## 4. volumeClaimTemplates vs volumes

```yaml
# Deployment way (WRONG for databases):
volumes:
  - name: mysql-data
    persistentVolumeClaim:
      claimName: my-pvc    # ALL pods share same PVC!

# StatefulSet way (CORRECT):
volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ReadWriteOnce]
      resources:
        requests:
          storage: 1Gi
# K8s auto-creates PVC per pod:
# mysql-data-mysql-statefulset-0
# mysql-data-mysql-statefulset-1
```

**Important:** PVCs are NOT deleted when StatefulSet is deleted!
```bash
kubectl delete statefulset mysql-statefulset
# Pods deleted ✅
# PVCs still exist! (data safe) ✅

kubectl get pvc -n mysql
# mysql-data-mysql-statefulset-0   Bound   1Gi   ← still there!
```

---

## 5. Resource Requests and Limits — Deep Dive

```
CPU units:
  1 CPU = 1000m (millicores)
  100m = 0.1 CPU = 10% of one core
  500m = 0.5 CPU = half a core

Memory units:
  Mi = Mebibytes (1Mi = 1048576 bytes)
  Gi = Gibibytes
  128Mi ≈ 134 MB

Today's MySQL config:
  requests.cpu: 100m    → K8s reserves 0.1 CPU on node
  requests.memory: 128Mi → K8s reserves 128Mi on node
  limits.cpu: 250m      → MySQL throttled if uses >0.25 CPU
  limits.memory: 384Mi  → MySQL OOMKilled if uses >384Mi
```

**Scheduling logic:**
```
Node has 2 CPU, 4Gi RAM available

Pod A: requests 1 CPU, 2Gi → fits ✅
Pod B: requests 1 CPU, 2Gi → fits ✅
Pod C: requests 1 CPU, 1Gi → NO SPACE ❌ → Pending!

(Even if actual usage is low — requests are RESERVED)
```

---

## 6. Real World StatefulSet Use Cases

| App | Why StatefulSet |
|-----|----------------|
| MySQL/MariaDB | Each replica needs own data |
| PostgreSQL | Primary/replica identity needed |
| MongoDB | Each shard needs own storage |
| Kafka | Each broker needs own log directory |
| Elasticsearch | Each node needs own index storage |
| Redis Sentinel | Leader election needs stable identity |
| ZooKeeper | Ensemble members need fixed IDs |

---

## 7. Interview Q&A

**Q: When to use StatefulSet vs Deployment?**
Deployment = stateless apps (web servers, APIs) — pods are interchangeable. StatefulSet = stateful apps (databases, message brokers) — each pod has unique identity, stable storage, and ordered operations.

**Q: What is a Headless Service?**
Service with `clusterIP: None`. No load balancing — DNS returns individual pod IPs. Used with StatefulSets so each pod gets a stable DNS name like `pod-0.service.namespace.svc.cluster.local`.

**Q: What happens to PVCs when StatefulSet is deleted?**
PVCs are NOT automatically deleted. This is intentional — data is preserved. You must manually delete PVCs if you want to clean up storage.

**Q: What is volumeClaimTemplates?**
A StatefulSet feature that automatically creates a unique PVC for each pod. Unlike Deployment where all pods share one PVC, each StatefulSet pod gets its own isolated PVC.

**Q: What is the difference between resource requests and limits?**
Requests = minimum guaranteed resources used for scheduling. Limits = maximum allowed — pod gets throttled (CPU) or OOMKilled (memory) if exceeded.

**Q: Why does StatefulSet scale in order?**
Databases have dependencies — primary must start before replicas join the cluster. StatefulSet ensures ordered startup (0→1→2) and ordered shutdown (2→1→0) for safe operations.
