# 📝 Day 40 — Kubernetes Storage, Services & Ingress Deep Notes

---

## 1. Storage — Why Pods Need Persistent Storage

```
Problem without PV:
Pod crashes → restarts → ALL data lost!
Database pod crash = all records gone ❌

Solution with PV + PVC:
Pod crashes → restarts → data still on disk ✅
PV = actual disk space
PVC = pod's request for that disk space
```

---

## 2. PV vs PVC — Deep Understanding

```
PersistentVolume (PV):
- Created by Admin/DevOps
- Actual storage (1Gi hostPath /mnt/data)
- Cluster-level resource (no namespace)
- Status: Available → Bound → Released → Failed

PersistentVolumeClaim (PVC):
- Created by Developer/Application
- Request for storage (need 900Mi)
- Namespace-level resource
- K8s matches PVC to best available PV

Binding process:
PVC requests 900Mi with local-storage class
→ K8s finds local-pv (1Gi, same class)
→ PV status: Bound
→ PVC status: Bound
→ Pod can now use PVC as volume ✅
```

**Key lesson from today:**
```
PVC must be in SAME namespace as Pod!
PV has NO namespace (cluster-wide)
PVC has namespace

Error you got:
"persistentvolumeclaim local-pvc not found"
Fix: Added namespace: nginx to PVC ✅
```

---

## 3. Access Modes

| Mode | Short | Meaning |
|------|-------|---------|
| ReadWriteOnce | RWO | One node can read+write |
| ReadOnlyMany | ROX | Many nodes can read |
| ReadWriteMany | RWX | Many nodes can read+write |

---

## 4. Reclaim Policy

| Policy | What happens after PVC deleted |
|--------|-------------------------------|
| Retain | PV data kept — admin must clean manually |
| Delete | PV and data deleted automatically |
| Recycle | Data wiped, PV made available again |

---

## 5. Services — Deep Understanding

```
Problem without Service:
Pod IP = dynamic (changes every restart)
How do other pods find it? ❌

Solution with Service:
Service IP = static (never changes)
Service finds pods using LABELS (selector)
Traffic → Service → Pod (via labels)

Today's example:
service/nginx-service selector: app=nginx
→ Routes to all pods with label app=nginx
→ Load balanced automatically!
```

**Service Types:**
```
ClusterIP (today's practice):
  - Only inside cluster
  - Default type
  - Use: backend talking to database

NodePort:
  - Accessible via NodeIP:NodePort
  - Port range: 30000-32767
  - Use: dev/testing

LoadBalancer:
  - Cloud provider creates external LB
  - Today: EXTERNAL-IP = <pending> (KIND has no cloud)
  - Use: production on AWS/GCP/Azure

Ingress (today's practice):
  - HTTP routing rules
  - Path-based routing (/nginx → nginx, / → notes-app)
  - Use: multiple services, one entry point
```

---

## 6. Ingress — How It Works

```
Without Ingress:
Service A → Port 8080
Service B → Port 9090
Service C → Port 3000
Users need to remember 3 different ports ❌

With Ingress:
All traffic → Port 80
/nginx  → nginx-service:80
/app    → notes-app-services:8000
/api    → api-service:5000
One entry point for everything ✅
```

**Ingress Controller vs Ingress:**
```
Ingress Controller = The actual NGINX pod
  (deployed via kubectl apply -f deploy.yaml)
  Watches for Ingress resources

Ingress = The routing RULES
  (your ingress.yml)
  Tells controller where to route

Think of it like:
Controller = NGINX server installed
Ingress rules = nginx.conf configuration
```

**Annotations:**
```yaml
annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /
```
This strips the path prefix when forwarding:
`/nginx/foo` → `/foo` at the backend ✅

---

## 7. Django App — K8s Architecture

```
Browser
  ↓
port-forward (9090 → 80)
  ↓
ingress-nginx-controller (NGINX pod)
  ↓ (based on path rules)
notes-app-services (ClusterIP:8000)
  ↓ (selector: app=notes-app)
notes-app-deployment pod (Django:8000)
  ↓
ritik2909/notes-app-k8s image (DockerHub)
```

**DB error you faced:**
```
AttributeError: 'NoneType' has no attribute 'startswith'
```
Cause: settings.py reads DB config from env vars
```python
'HOST': os.getenv("DB_HOST")  # returns None if not set!
```
Fix: Set env vars in deployment or use SQLite for testing

---

## 8. Port Forward — Troubleshooting

```bash
# Port 80 permission denied (needs root)
kubectl port-forward ... 80:80
# Error: bind: permission denied

# Fix 1: Use higher port
kubectl port-forward ... 8081:80

# Fix 2: sudo with KUBECONFIG
sudo KUBECONFIG=$HOME/.kube/config kubectl port-forward ...

# Port already in use
lsof -i :9090          # find what's using it
kill -9 <PID>          # kill it
# Then try again
```

---

## 9. Interview Q&A — Day 40

**Q: What is the difference between PV and PVC?**
PV is the actual storage resource created by admin. PVC is the application's request for storage. K8s automatically binds a PVC to a matching PV based on storage class and access mode.

**Q: What happens to data when a Pod restarts?**
Without PV, data is lost on restart. With PV and PVC, data persists on the host path even after pod restarts.

**Q: What is an Ingress?**
Ingress is an API object that manages external HTTP/HTTPS access to services. It provides path-based routing, SSL termination, and name-based virtual hosting — one entry point for multiple services.

**Q: What is the difference between Ingress and LoadBalancer service?**
LoadBalancer creates one external IP per service (expensive in cloud). Ingress uses one LoadBalancer and routes to multiple services based on paths/hostnames — much more cost-efficient.

**Q: What are Ingress annotations?**
Key-value metadata that configures the Ingress controller behavior. Example: `nginx.ingress.kubernetes.io/rewrite-target: /` strips path prefix when forwarding requests.

**Q: Why was your pod stuck in Pending state?**
The PVC was in the default namespace but the pod was in nginx namespace. PVC must be in the same namespace as the pod. Fixed by adding `namespace: nginx` to the PVC definition.
