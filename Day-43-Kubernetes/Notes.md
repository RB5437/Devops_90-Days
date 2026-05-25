# 📝 Day 43 — Kubernetes Notes

## RBAC
- Controls WHO can do WHAT on WHICH resource
- 4 objects: Role, RoleBinding, ClusterRole, ClusterRoleBinding
- Role = namespace scoped | ClusterRole = cluster-wide
- `kubectl auth whoami` → see current identity
- `kubectl auth can-i <verb> <resource>` → check permissions
- For ServiceAccount: `--as=system:serviceaccount:<ns>:<sa-name>` (full format!)

## ServiceAccount
- Identity for pods/applications (not humans)
- Every pod gets `default` SA automatically
- Custom SA: `kubectl create serviceaccount <name> -n <ns>`
- SA needs RoleBinding to get permissions

## Role vs ClusterRole
| | Role | ClusterRole |
|-|------|-------------|
| Scope | Namespace | Cluster-wide |
| Binding | RoleBinding | ClusterRoleBinding |
| Use | App permissions | Admin, monitoring |

## Kubernetes Dashboard
- Visual UI for monitoring pods, logs, deployments
- Needs ServiceAccount + ClusterRoleBinding for access
- Token auth: `kubectl -n kubernetes-dashboard create token admin-user`
- Proxy: `kubectl proxy --address=0.0.0.0 --accept-hosts='.*'`
- SSH tunnel needed if accessing from local machine
- insecure error on public IP → use SSH tunnel to localhost

## CRD (Custom Resource Definition)
- Extend K8s API with your own resource types
- `kubectl get crd` → lists all CRDs
- Shortnames: `kubectl get junoon` = `kubectl get devopsbatches`
- Two steps: 1) Create CRD schema 2) Create Custom Resource objects
- Used by: Helm, ArgoCD, Prometheus (they all add CRDs!)

## Helm
- Package manager for Kubernetes
- Chart = package of K8s manifests
- `helm create <name>` → scaffold new chart
- `helm install <release> <chart>` → deploy
- `helm upgrade <release> <chart>` → update
- `helm rollback <release> <revision>` → undo
- `helm uninstall <release>` → delete all resources
- `values.yaml` = customizable defaults
- Templates use `{{ .Values.xxx }}` Go templating
- One command deploys everything (deployment + service + ingress + SA...)

## Common Typos Fixed Today
- `--as=apache-user` ❌ → `--as=system:serviceaccount:apache:apache-user` ✅
- `rolbinding` ❌ → `rolebinding` ✅
- `authcan-i` ❌ → `auth can-i` ✅ (space!)
- `kuberctl` ❌ → `kubectl` ✅
- `get_helm.s` ❌ → `get_helm.sh` ✅
