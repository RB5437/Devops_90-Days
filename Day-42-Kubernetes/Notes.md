# 📝 Day 42 — Kubernetes Notes

## ConfigMap
- Stores non-sensitive config (DB name, URLs, settings)
- Injected via `configMapKeyRef` (env) or volume mount
- `kubectl get configmap -n <ns>` to list
- Change config without rebuilding Docker image!

## Secrets
- Stores sensitive data — always base64 encoded
- `echo "password" | base64` to encode
- Injected via `secretKeyRef`
- Type: Opaque (default)
- Never commit secrets to GitHub!

## Resource Requests & Limits
- `requests` = minimum guaranteed resources
- `limits` = maximum allowed resources
- CPU unit: `m` = millicores (1000m = 1 CPU core)
- Memory unit: `Mi` = mebibytes
- QoS Classes: BestEffort (no requests) → Burstable (requests < limits) → Guaranteed (requests = limits)
- Common typo: `request` ❌ → `requests` ✅

## Probes
- **Liveness**: Is container alive? → Restart if fails
- **Readiness**: Is container ready to serve? → Remove from Service endpoints if fails
- **Startup**: For slow-starting apps → disable liveness/readiness until startup passes
- Types: httpGet, tcpSocket, exec
- period=10s, failure=3 = default settings

## Taints & Tolerations
- Taint = "repel pods from this node"
- Toleration = "allow this pod on tainted nodes"
- Effects: NoSchedule, PreferNoSchedule, NoExecute
- Add taint: `kubectl taint node <node> key=value:Effect`
- Remove taint: `kubectl taint node <node> key=value:Effect-` (dash at end)
- Control plane always has taint — that's why pods don't run on master!

## HPA (Horizontal Pod Autoscaler)
- Scales pod COUNT automatically
- Needs Metrics Server to work!
- `averageUtilization: 50` = scale up when CPU > 50%
- minReplicas / maxReplicas define bounds
- Check: `kubectl get hpa -n <ns>`

## VPA (Vertical Pod Autoscaler)
- Adjusts pod RESOURCES (CPU/Memory) automatically
- Not built-in — install from kubernetes/autoscaler repo
- `./hack/vpa-up.sh` to install
- updateMode: Auto = restart pods with new resources
- Recommendation: lowerBound / target / upperBound
- HPA + VPA can conflict — use carefully!

## Key Differences
| | HPA | VPA |
|-|-----|-----|
| What scales | Pod count | Pod resources |
| Best for | Stateless (web) | Stateful (DB) |
| Conflict | Can conflict together | Can conflict with HPA |

## Errors Fixed
- `configMapKeyref` → `configMapKeyRef` (capital R!)
- `request` → `requests` (plural!)
- Missing `labels` in pod template → selector mismatch
- Taint blocks all pods → untaint one node
- Metrics API not available → install metrics-server + `--kubelet-insecure-tls`
