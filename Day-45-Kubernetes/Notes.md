# 📝 Day 45 — Kubernetes Final Revision Notes

## 🔁 Init Container — Key Points
- Runs BEFORE main container, sequentially
- Status flow: `Init:0/1` → `Init:1/1` → `Running`
- If init fails → pod restarts init (not main)
- Use: DB readiness check, config download, file permissions
- `kubectl logs <pod> -c <init-name>` → see init logs

## 🚗 Sidecar Container — Key Points
- Runs ALONGSIDE main, entire pod lifetime
- Pod shows `2/2 Running` — both containers counted
- Shares: same network namespace + emptyDir volumes
- Use: log shipping, Envoy proxy (Istio), git sync
- `kubectl logs <pod> -c <sidecar-name>` → sidecar logs

## Init vs Sidecar — Quick Table
| | Init | Sidecar |
|-|------|---------|
| When runs | Before main | Same time as main |
| Status | Init:0/1 → Completed | 2/2 Running |
| Lifecycle | Exits before main starts | Lives with main forever |
| Purpose | Setup/pre-check | Support/enhance |

## 🕸️ Istio — Key Points
- Service mesh = infra layer for pod-to-pod communication
- Control Plane: **Istiod** (pilot + citadel + galley)
- Data Plane: **Envoy proxy** — auto-injected sidecar
- `kubectl label namespace default istio-injection=enabled` → magic label!
- All new pods get Envoy automatically → 2/2 Running

### Istio Features (no code change needed!)
| Feature | What it does |
|---------|-------------|
| mTLS | Encrypts pod-to-pod traffic automatically |
| Traffic routing | A/B testing, canary releases |
| Observability | Tracing, metrics, logs for every request |
| Circuit breaking | Stop cascading failures |

### Bookinfo App — 4 Microservices
```
productpage → details
           → reviews → ratings
```
reviews has v1, v2, v3 — perfect for Istio traffic splitting demo!

## ☸️ KIND Cluster — Quick Commands
```bash
kind create cluster --name <name> --config=config.yml
kind get clusters
kind delete cluster --name <name>
kubectl cluster-info --context kind-<name>
```

## 🎯 Kubernetes Full Revision — Must-Know Concepts

| Concept | One-liner |
|---------|-----------|
| Pod | Smallest unit — 1+ containers |
| Deployment | Manages ReplicaSet — rolling updates |
| Service | Stable IP for pods (ClusterIP/NodePort/LB) |
| Namespace | Logical isolation |
| PV/PVC | Persistent storage |
| ConfigMap | Non-sensitive config |
| Secret | Sensitive data (base64) |
| Ingress | HTTP routing — one entry point |
| HPA | Auto-scale pod count |
| VPA | Auto-size pod resources |
| RBAC | Who can do what in cluster |
| Helm | K8s package manager |
| Init Container | Pre-setup before main |
| Sidecar | Helper alongside main |
| Istio | Service mesh — traffic + security |

## ❌ Common Errors Fixed
- `kubectl log` → `kubectl logs` (add **s**!)
- `namspace` → `namespace`
- `mv` without sudo → `sudo mv`
- Docker not installed → `sudo apt-get install docker.io`
- HPA needs Metrics Server + `--kubelet-insecure-tls`
- RBAC full format: `system:serviceaccount:<namespace>:<name>`
