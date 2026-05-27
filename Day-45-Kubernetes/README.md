# ☸️ Day 45 — Kubernetes Final Revision

**Date:** 27 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Revised Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Init Container | ✅ Revised |
| 2 | Sidecar Container | ✅ Revised |
| 3 | Istio Service Mesh | ✅ Revised |
| 4 | KIND Cluster Setup | ✅ Revised |

---

## 🔁 1. Init Container — Revision

Runs **before** the main container. Used for setup tasks.

**Key Points:**
- Status: `Init:0/1` → `Running` → `Completed`
- Main container starts ONLY after init completes
- Common use: wait for DB, download config, set permissions

```yaml
spec:
  initContainers:
  - name: init-container
    image: busybox:latest
    command: ["sh", "-c", "echo 'Init done'; sleep 10"]
  containers:
  - name: main-container
    image: busybox:latest
    command: ["sh", "-c", "echo 'Main started'"]
```

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/pods/init-containers/

---

## 🚗 2. Sidecar Container — Revision

Runs **alongside** the main container for the entire pod lifetime.

**Key Points:**
- Pod shows `2/2 Running` (both containers counted)
- Shares same network + emptyDir volume
- Common use: log shipper, Envoy proxy, sync agent

```yaml
spec:
  containers:
  - name: main-container
    image: busybox:latest
    command: ["sh", "-c", "while true; do echo 'Hello Dosto' >> /var/log/app.log; sleep 2; done"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
  - name: sidecar-container
    image: busybox:latest
    command: ["sh", "-c", "tail -f /var/log/app.log"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
  volumes:
  - name: shared-logs
    emptyDir: {}
```

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/

---

## 🕸️ 3. Istio Service Mesh — Revision

Infrastructure layer for service-to-service communication. Zero code changes needed.

**Key Points:**
- **Istiod** = Control plane (brains)
- **Envoy** = Sidecar proxy auto-injected into every pod
- Provides: mTLS, traffic management, observability

**Install Flow:**
```
Download Istio → Install istioctl → istioctl install → Label namespace → Deploy app → Envoy auto-injected!
```

**Quick Check Commands:**
```bash
kubectl get pods -n istio-system        # istiod Running ✅
kubectl get namespace -L istio-injection # injection enabled ✅
istioctl proxy-status                   # all envoys synced
```

**Official Docs:** https://istio.io/latest/docs/

---

## 📊 Full Kubernetes Journey — Summary

| Day | Topic |
|-----|-------|
| Day 38 | K8s Architecture + Cluster Setup |
| Day 39 | Pods + Deployments + Services + Namespaces |
| Day 40 | Storage — PV, PVC, StorageClass + Notes App |
| Day 41 | StatefulSets + DaemonSets + Jobs |
| Day 42 | ConfigMap + Secrets + Probes + Taints + HPA + VPA |
| Day 43 | RBAC + CRD + Dashboard + Helm |
| Day 44 | Init Container + Sidecar + Istio |
| Day 45 | **Final Revision ✅** |

---

## 🔗 Quick Reference Links

| Topic | Official Docs |
|-------|--------------|
| Init Containers | https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| Sidecar Containers | https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/ |
| Istio | https://istio.io/latest/docs/ |
| KIND | https://kind.sigs.k8s.io/ |
| kubectl Cheatsheet | https://kubernetes.io/docs/reference/kubectl/cheatsheet/ |

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
