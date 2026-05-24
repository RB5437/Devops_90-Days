# ☸️ Day 42 — Kubernetes: ConfigMap, Secrets, Resource Quotas, Probes, Taints/Tolerations, HPA, VPA

**Date:** 24 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered

| # | Topic | Status |
|---|-------|--------|
| 1 | ConfigMap | ✅ Done |
| 2 | Secrets | ✅ Done |
| 3 | Resource Quotas & Limits | ✅ Done |
| 4 | Liveness, Readiness & Startup Probes | ✅ Done |
| 5 | Taints & Tolerations | ✅ Done |
| 6 | Horizontal Pod Autoscaler (HPA) | ✅ Done |
| 7 | Vertical Pod Autoscaler (VPA) | ✅ Done |

---

## 📘 1. ConfigMap

ConfigMap stores **non-sensitive** configuration data as key-value pairs, injected into pods as environment variables or volume mounts.

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: mysql-config-map
  namespace: mysql
data:
  MYSQL_DATABASE: devops
```

- Applied to MySQL StatefulSet via `configMapKeyRef`
- `kubectl get configmap -n mysql` → shows `mysql-config-map` with 1 DATA entry

**Key concept:** ConfigMap = external config → pod reads it at runtime. No need to rebuild Docker image for config changes!

---

## 🔐 2. Secrets

Secrets store **sensitive** data (passwords, tokens) encoded in base64.

```bash
echo "root" | base64        # cm9vdAo=
echo "rootpassword" | base64  # cm9vdHBhc3N3b3JkCg==
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: mysql
data:
  MYSQL_ROOT_PASSWORD: cm9vdAo=   # base64 encoded "root"
```

- Injected into pod via `secretKeyRef`
- `kubectl get secret -n mysql` → shows `mysql-secret` Opaque type

**ConfigMap vs Secret:**

| Feature | ConfigMap | Secret |
|---------|-----------|--------|
| Data type | Non-sensitive | Sensitive |
| Encoding | Plain text | Base64 |
| Use case | DB name, URLs | Passwords, tokens |

---

## ⚙️ 3. Resource Quotas & Limits

Set CPU and memory bounds per container.

```yaml
resources:
  requests:
    cpu: 100m       # Minimum guaranteed
    memory: 128Mi
  limits:
    cpu: 200m       # Maximum allowed
    memory: 256Mi
```

**Typo gotcha:** `request` (wrong) vs `requests` (correct) — strict decoding error!

- nginx-deployment: requests 100m/128Mi, limits 200m/256Mi → 2 pods Running ✅
- apache-deployment: requests 100m/128Mi, limits 200m/256Mi → Running ✅

---

## 🩺 4. Probes (Liveness, Readiness, Startup)

Probes let Kubernetes know if a container is healthy and ready.

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8000
readinessProbe:
  httpGet:
    path: /
    port: 8000
```

Applied to **notes-app-deployment** (ritik2909/notes-app-k8s):

- Liveness: `http://:8000/` — period=10s, failure=3 → restart if unhealthy
- Readiness: `http://:8000/` — period=10s, failure=3 → remove from service if not ready
- Pod: `notes-app-deployment-78cfbfdc7c-2qd86` — Running ✅, Ready: True ✅

| Probe | Purpose |
|-------|---------|
| Liveness | Restart container if dead |
| Readiness | Remove from Service endpoints if not ready |
| Startup | Give slow apps time to initialize |

---

## 🚫 5. Taints & Tolerations

**Taints** repel pods from nodes. **Tolerations** allow pods to bypass taints.

```bash
# Add taint — NoSchedule = no new pods allowed
kubectl taint node rbb-cluster-worker   prod=true:NoSchedule
kubectl taint node rbb-cluster-worker2  prod=true:NoSchedule

# Result: pod stuck in Pending — no node available!
# Events: 0/3 nodes available: 1 control-plane taint, 2 prod=true taint
```

```bash
# Remove taint
kubectl taint node rbb-cluster-worker2 prod=true:NoSchedule-
# Pod moves from Pending → ContainerCreating → Running ✅
```

**Toleration in pod spec:**
```yaml
tolerations:
  - key: "prod"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
```
Pod with toleration → runs even on tainted node ✅

---

## 📈 6. Horizontal Pod Autoscaler (HPA)

HPA automatically scales pods based on CPU/memory utilization.

**Setup Metrics Server (required for HPA):**
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system edit deployment metrics-server
# Add: --kubelet-insecure-tls flag
kubectl -n kube-system rollout restart deployment metrics-server
kubectl top node   # Verify metrics working
```

**HPA manifest:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-hpa
  namespace: apache
spec:
  scaleTargetRef:
    kind: Deployment
    name: apache-deployment
    apiVersion: apps/v1
  minReplicas: 1
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 3
```

**Result:**
```
NAME        REFERENCE                      TARGETS      MINPODS   MAXPODS   REPLICAS
apache-hpa  Deployment/apache-deployment   cpu: 1%/3%   1         3         3
```

- HPA auto-scaled apache from 1 → 3 pods when CPU exceeded 3% ✅
- Used load-generator pod to simulate traffic

---

## 📊 7. Vertical Pod Autoscaler (VPA)

VPA automatically adjusts CPU/memory **requests** of existing pods (not pod count).

```bash
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler/
./hack/vpa-up.sh   # Installs VPA CRDs + controllers
```

**VPA manifest:**
```yaml
kind: VerticalPodAutoscaler
apiVersion: autoscaling.k8s.io/v1
metadata:
  name: apache-vpa
  namespace: apache
spec:
  targetRef:
    name: apache-deployment
    apiVersion: apps/v1
    kind: Deployment
  updatePolicy:
    updateMode: "Auto"
```

**Result:**
```
NAME        MODE   CPU   MEM     PROVIDED
apache-vpa  Auto   25m   250Mi   True
```

VPA recommendation: CPU=25m, Memory=250Mi (right-sized from original 100m/128Mi) ✅

| Feature | HPA | VPA |
|---------|-----|-----|
| Scales | Pod count | Pod resources |
| Trigger | CPU/Memory % | Resource usage over time |
| Use case | Web servers, stateless | DBs, ML workloads |

---

## 🔧 Errors Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| `unknown field resources.request` | Typo: `request` instead of `requests` | Fixed to `requests` |
| `unknown field configMapKeyref` | Wrong case: `configMapKeyref` | Fixed to `configMapKeyRef` |
| `selector does not match template labels` | Missing `labels` in pod template | Added `labels: app: apache` |
| Pod stuck `Pending` | Both nodes tainted `prod=true:NoSchedule` | Untainted one node |
| `Metrics API not available` | metrics-server not installed | Installed + added `--kubelet-insecure-tls` |

---

## 📊 Kubernetes Progress

| Day | Topic | Status |
|-----|-------|--------|
| Day 38 | Architecture + KIND + Minikube + Pods + Namespaces | ✅ |
| Day 39 | Deployments + ReplicaSets + DaemonSets + Jobs + CronJobs | ✅ |
| Day 40 | Storage + Services + Ingress + Django Project | ✅ |
| Day 41 | StatefulSets (MySQL) | ✅ |
| Day 42 | ConfigMap + Secrets + Probes + Taints + HPA + VPA | ✅ |
| Day 43 | RBAC + Monitoring + Helm | ⬜ |
| Day 44 | SideCar + Istio Service Mesh | ⬜ |
| Day 45 | Projects (3-tier + EKS) | ⬜ |

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
