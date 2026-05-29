# 📝 Day 47 — Helm Notes

## 🧩 Helm Components — Must Know

| Component | What it is | Example |
|-----------|-----------|---------|
| **Repo** | Registry of charts | bitnami, eks, stable |
| **Chart** | Package (deploy+svc+ingress+values) | bitnami/nginx, bitnami/prometheus |
| **Release** | Installed instance of a chart | `nginxv1`, `prometheus` |
| **values.yaml** | Default config — override at install | `image.tag`, `replicas` |
| **templates/** | Go template YAML files | deployment.yaml, service.yaml |

## 📁 Helm Chart Structure
```
mychart/
├── Chart.yaml      → metadata (name, version, appVersion)
├── values.yaml     → default values
├── charts/         → sub-charts (dependencies)
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    ├── hpa.yaml
    ├── _helpers.tpl   → reusable template snippets
    └── NOTES.txt      → shown after helm install
```

## 🔧 Go Templating — Key Syntax

| Template | What it renders |
|----------|----------------|
| `{{ .Release.Name }}` | Release name (e.g. `nginxv1`) |
| `{{ .Release.Namespace }}` | Namespace |
| `{{ .Chart.Name }}` | Chart name |
| `{{ .Chart.Version }}` | Chart version |
| `{{ .Values.image.tag }}` | Value from values.yaml |
| `{{ .Values.appMessage }}` | Custom value |

## ⚡ Helm Lifecycle Commands

```bash
helm install   <name> <chart>    # Install
helm upgrade   <name> <chart>    # Update to new version
helm rollback  <name> <revision> # Roll back
helm uninstall <name>            # Delete release
helm list                        # List all releases
helm history   <name>            # Release history
helm status    <name>            # Current status
```

## 📦 Helm Package + Repo

```bash
helm package <chart-dir>    # Creates .tgz file
helm repo index .           # Creates index.yaml → your own Helm repo!
```

## 🎯 Interview Q&A

**Q: What is Helm?**
A: Helm is the package manager for Kubernetes. It simplifies deploying complex apps using charts — pre-packaged K8s manifests with templating.

**Q: Difference between Chart, Release, Repo?**
A: Chart = package (like apt package). Release = installed instance (like running app). Repo = registry of charts (like apt repo).

**Q: How do you override values.yaml?**
A: Three ways:
1. `helm install myapp chart --set image.tag=v2`
2. `helm install myapp chart -f custom-values.yaml`
3. Edit values.yaml directly

**Q: What is `helm upgrade --install`?**
A: Idempotent command — installs if not exists, upgrades if exists. Used in CI/CD pipelines!

## 🔥 Why Helm in Production?
- ArgoCD deploys apps via Helm charts
- Prometheus + Grafana installed via `helm install`
- AWS Load Balancer Controller installed via `eks/aws-load-balancer-controller`
- One chart = entire app stack
