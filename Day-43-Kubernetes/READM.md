# ☸️ Day 43 — Kubernetes: RBAC, ServiceAccount, CRD, Dashboard, Helm

**Date:** 25 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered

| # | Topic | Status |
|---|-------|--------|
| 1 | RBAC — Role Based Access Control | ✅ Done |
| 2 | ServiceAccount + Role + RoleBinding | ✅ Done |
| 3 | Kubernetes Dashboard (Monitoring) | ✅ Done |
| 4 | Custom Resource Definition (CRD) | ✅ Done |
| 5 | Helm — Install + Create Chart + Deploy | ✅ Done |

---

## 🔐 1. RBAC — Role Based Access Control

RBAC controls **who can do what** in a Kubernetes cluster.

```
RBAC
├── Service Account (identity for pods/apps)
│   └── Namespace scoped
│       ├── Role
│       └── RoleBinding
└── User (human identity)
    └── Cluster scoped
        ├── ClusterRole
        └── ClusterRoleBinding
```

**Check current identity:**
```bash
kubectl auth whoami
# Username: kubernetes-admin
# Groups: [kubeadm:cluster-admins system:authenticated]

kubectl auth can-i get pods        # yes (admin)
kubectl auth can-i get pods -n apache --as=system:serviceaccount:apache:apache-user
# yes (after rolebinding)
```

---

## 👤 2. ServiceAccount + Role + RoleBinding

### ServiceAccount
```yaml
kind: ServiceAccount
apiVersion: v1
metadata:
  name: apache-user
  namespace: apache
```

### Role (namespace-scoped permissions)
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: apache-manager
  namespace: apache
rules:
- apiGroups: ["", "apps"]
  resources:
    - pods
    - services
    - deployments
  verbs:
    - get
    - list
    - watch
    - create
    - patch
    - delete
```

### RoleBinding (connects ServiceAccount ↔ Role)
```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: apache-manager-rolebinding
  namespace: apache
subjects:
- kind: ServiceAccount
  name: apache-user
  namespace: apache
roleRef:
  kind: Role
  name: apache-manager
  apiGroup: rbac.authorization.k8s.io
```

**Key learning:** `--as=apache-user` (wrong) vs `--as=system:serviceaccount:apache:apache-user` (correct full format!)

---

## 📊 3. Kubernetes Dashboard (Monitoring & Logging)

Visual UI to monitor pods, deployments, services, and logs.

```bash
# Install Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create admin user + ClusterRoleBinding
kubectl apply -f dashboard-admin-user.yml

# Get token
kubectl -n kubernetes-dashboard create token admin-user

# Start proxy
kubectl proxy --address=0.0.0.0 --accept-hosts='.*'

# Access URL
http://<EC2-IP>:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
```

**SSH tunnel (if accessing from local machine):**
```bash
ssh -i "DevOps_Key.pem" -L 8001:localhost:8001 ubuntu@<EC2-IP>
# Then open: http://localhost:8001/...
```

**dashboard-admin-user.yml:**
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

---

## 🧩 4. Custom Resource Definition (CRD)

CRDs let you extend Kubernetes with your OWN custom resource types.

**Step 1 — Define the CRD:**
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: devopsbatches.trainwithritik.com
spec:
  group: trainwithritik.com
  names:
    plural: devopsbatches
    singular: devopsbatch
    kind: DevOpsBatch
    shortNames:
      - junoon
      - batches
      - twr
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              name:
                type: string
              duration:
                type: string
              mode:
                type: string
              platform:
                type: string
```

**Step 2 — Create a Custom Resource:**
```yaml
# devops-cr.yml
apiVersion: trainwithritik.com/v1
kind: DevOpsBatch
metadata:
  name: junoon-batch-9
spec:
  name: DevOps-Zero To Hero Junoon Batch 9
  duration: 3 months from 25th May 2026
  mode: Live as always
  platform: trainwithritik.com
```

**Result:**
```bash
kubectl get devopsbatches
# NAME              AGE
# junoon-batch-12   22s
# junoon-batch-9    2m9s

kubectl describe devopsbatch   # Shows full spec
```

---

## ⛵ 5. Helm — Kubernetes Package Manager

Helm = apt/yum for Kubernetes. Install complex apps with one command.

```
HELM
├── NGINX    → deployment + service + ingress + hpa + configMap + secret
├── MySQL    → deployment + service + ingress + hpa + configMap + secret
└── Notes    → deployment + service + ingress + hpa + configMap + secret
```

**Install Helm v4.2.0:**
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
helm version   # v4.2.0
```

**Create + Deploy Helm Chart:**
```bash
helm create apache-helm      # Scaffolds chart structure
tree apache-helm/
# ├── Chart.yaml
# ├── charts/
# ├── templates/
# │   ├── deployment.yaml
# │   ├── service.yaml
# │   ├── ingress.yaml
# │   ├── hpa.yaml
# │   └── ...
# └── values.yaml

helm package apache-helm/    # Creates apache-helm-0.1.0.tgz

# Install in default namespace
helm install dev-apache apache-helm
kubectl get pods             # dev-apache-apache-helm-xxx Running ✅

# Install in custom namespace
helm install dev-apache apache-helm -n dev-apache --create-namespace
kubectl get pods -n dev-apache   # Running ✅

# Uninstall
helm uninstall dev-apache -n dev-apache

# Upgrade
helm upgrade prod-apache apache-helm

# Rollback to revision 1
helm rollback prod-apache 1 -n prod-apache
```

**Helm Chart Structure:**
| File | Purpose |
|------|---------|
| `Chart.yaml` | Chart metadata (name, version, description) |
| `values.yaml` | Default configurable values |
| `templates/` | K8s manifests with Go templating |
| `charts/` | Sub-chart dependencies |

---

## 🔧 Errors Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| `--as=apache-user` → no | Wrong format for ServiceAccount | Use `--as=system:serviceaccount:apache:apache-user` |
| `rolbinding` not found | Typo in kubectl command | `rolebinding` (correct spelling) |
| `authcan-i` unknown | Missing space | `kubectl auth can-i` |
| `kuberctl` not found | Typo | `kubectl` |
| `get_helm.s` not found | Typo in chmod | `get_helm.sh` |
| Port 8001 already in use | Previous proxy running | `kill -9 <PID>` then restart |

---

## 📊 Kubernetes Progress

| Day | Topic | Status |
|-----|-------|--------|
| Day 38 | Architecture + KIND + Minikube + Namespaces | ✅ |
| Day 39 | Pods + Deployments + ReplicaSets + DaemonSets + Jobs + CronJobs | ✅ |
| Day 40 | Storage + Services + Ingress + Django Project | ✅ |
| Day 41 | StatefulSets (MySQL) | ✅ |
| Day 42 | ConfigMap + Secrets + Probes + Taints + HPA + VPA | ✅ |
| Day 43 | RBAC + ServiceAccount + CRD + Dashboard + Helm | ✅ |
| Day 44 | SideCar + Istio + Projects | ⬜ |
| Day 45 | K8s Final Revision | ⬜ |

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
