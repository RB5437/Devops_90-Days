# 📝 Day 44 — Kubernetes Notes

## Init Container
- Runs BEFORE main container — setup/pre-check tasks
- Runs sequentially if multiple init containers
- Pod shows `Init:0/1` status while running
- Main container starts ONLY after init completes successfully
- Common use: wait for DB, download config, set file permissions
- `kubectl logs <pod> -c <init-container-name>` to see init logs

## Sidecar Container
- Runs ALONGSIDE main container — entire pod lifetime
- Shares same network + volumes as main container
- Pod shows `2/2 Running` (both containers counted)
- `kubectl logs <pod> -c <sidecar-name>` to see sidecar logs
- Common use: log shipper, Envoy proxy (Istio), sync agent
- emptyDir volume = shared memory between containers in same pod

## Init vs Sidecar — Quick Recall
| | Init | Sidecar |
|-|------|---------|
| Status | Init:0/1 → Completed | 2/2 Running |
| Lifecycle | Exits before main starts | Lives with main |
| Purpose | Setup | Support |

## Istio Service Mesh
- Service mesh = infrastructure layer for service-to-service communication
- Solves: traffic management, mTLS security, observability — WITHOUT code changes
- **Istiod** = control plane (brains)
- **Envoy** = sidecar proxy injected into every pod auto (data plane)
- `kubectl label namespace default istio-injection=enabled` = auto-inject Envoy into all new pods
- `istio-injection=enabled` label = magic label for auto sidecar injection

## Istio Install Steps (remember)
1. Download: `curl -L https://istio.io/downloadIstio | sh -`
2. Move binary: `sudo mv bin/istioctl /usr/local/bin/`
3. Install: `istioctl install -f <profile>.yaml -y`
4. Label namespace: `kubectl label namespace default istio-injection=enabled`
5. Deploy app → Envoy auto-injected!

## Bookinfo App (Istio Sample)
- 4 microservices: productpage → details + reviews → ratings
- reviews has 3 versions (v1/v2/v3) → Istio traffic splitting demo
- `<title>Simple Bookstore App</title>` = app working ✅
- Gateway + HTTPRoute = Istio ingress (newer Gateway API)

## Errors Fixed
- `kubectl log` → `kubectl logs` (add s!)
- `mv` without sudo → `sudo mv`
- `namspace` typo → `namespace`
- Docker not installed → `sudo apt-get install docker.io`
