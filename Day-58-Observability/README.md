# Day 58 — Prometheus + Grafana | Observability 
## 📅 Date: 9 June 2026
## 🎯 Topic: Prometheus + kube-prometheus-stack + PromQL + Metrics + Node Exporter + kube-state-metrics

---

## 📚 Resources Used

  - Playlist: https://www.youtube.com/playlist?list=PLdpzxOOAlwvJUIfwmmVDoPYqXXUNbdBmb
  - GitHub: https://github.com/iam-veeramalla/observability-zero-to-hero

---

## 🏠 Prometheus Architecture
- **Official Docs**: https://prometheus.io/docs/introduction/overview/

| Component | Role | Port |
|-----------|------|------|
| Prometheus Server | Scrapes + stores + serves metrics via TSDB | 9090 |
| Retrieval | Scrapes targets via HTTP pull model | — |
| TSDB | Time Series Database — local disk storage | — |
| HTTP Server | Serves PromQL queries via REST API | — |
| Service Discovery | Auto-discovers K8s pods, services, nodes | — |
| Pushgateway | Accepts metrics from short-lived jobs | 9091 |
| Alertmanager | Deduplicates, groups, routes alerts | 9093 |
| Node Exporter | Hardware metrics — CPU, RAM, Disk | 9100 |
| kube-state-metrics | K8s object state metrics | 8080 |
| Grafana | Dashboard + Visualization | 3000 |

---

## 📊 Metrics + Labels in Prometheus
- **Official Docs**: https://prometheus.io/docs/concepts/data_model/

Metrics are paired with **Labels** — key-value pairs to differentiate dimensions:
```
container_cpu_usage_seconds_total{namespace="kube-system", endpoint="https-metrics"}
```

---

## 🛠️ PromQL — Prometheus Query Language
- **Official Docs**: https://prometheus.io/docs/prometheus/latest/querying/basics/

### Basic Queries
```promql
# All time series for a metric
container_cpu_usage_seconds_total

# Filter by labels
container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}

# Range vector — last 5 minutes
container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}[5m]
```

### Aggregation + Functions
```promql
# Sum CPU across all nodes
sum(rate(node_cpu_seconds_total[5m]))

# Average memory per namespace
avg(container_memory_usage_bytes) by (namespace)

# rate() — per-second rate of increase
rate(container_cpu_usage_seconds_total[5m])

# increase() — total increase in 1 hour
increase(kube_pod_container_status_restarts_total[1h])

# histogram_quantile() — 95th percentile
histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (le))
```

---

## ⚙️ kube-prometheus-stack Setup (kind cluster)

### Cluster Used
- **Kind cluster**: `rbb-kind-cluster` (1 control-plane + 2 workers)
- **K8s version**: v1.35.1
- **Node OS**: Debian GNU/Linux 13 (trixie)

### Helm Install
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create ns monitoring
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f ./custom_kube_prometheus_stack.yml
```
- **Chart**: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
- **ArtifactHub**: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

### What Got Deployed (All Running ✅)
| Pod | Ready | Role |
|-----|-------|------|
| prometheus-monitoring-kube-prometheus-prometheus-0 | 2/2 | Prometheus Server |
| alertmanager-monitoring-kube-prometheus-alertmanager-0 | 2/2 | Alertmanager (HA) |
| alertmanager-monitoring-kube-prometheus-alertmanager-1 | 2/2 | Alertmanager (HA) |
| monitoring-grafana-5fbdcdf6c4-qlm7k | 3/3 | Grafana |
| monitoring-kube-prometheus-operator-b79ccf6cd-89skk | 1/1 | Prometheus Operator |
| monitoring-kube-state-metrics-868694bc4b-rwbt2 | 1/1 | kube-state-metrics |
| monitoring-prometheus-node-exporter-646f2 | 1/1 | Node Exporter (node 1) |
| monitoring-prometheus-node-exporter-7cjjd | 1/1 | Node Exporter (node 2) |
| monitoring-prometheus-node-exporter-gvjdx | 1/1 | Node Exporter (node 3) |

---

## 🔍 Verified — Node Exporter + kube-state-metrics

### Node Exporter (port 9100) — Hardware metrics verified ✅
```bash
curl 10.96.174.83:9100/metrics
# node_cpu_seconds_total, node_memory_MemTotal_bytes, node_load1, node_filesystem_avail_bytes...
```

### kube-state-metrics (port 8080) — K8s object states verified ✅
```bash
curl 10.96.138.2:8080/metrics | grep container
# kube_pod_container_status_ready, kube_pod_container_status_restarts_total...
```

---

## 🌐 Port Forwarding — UI Access
```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 8080:80 --address 0.0.0.0 &
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 --address 0.0.0.0 &
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093 --address 0.0.0.0 &
```
Access: `http://192.168.120.129:8080` (Grafana) | `http://192.168.120.129:9090` (Prometheus)

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Prometheus Docs | https://prometheus.io/docs/ |
| PromQL Basics | https://prometheus.io/docs/prometheus/latest/querying/basics/ |
| PromQL Functions | https://prometheus.io/docs/prometheus/latest/querying/functions/ |
| Data Model | https://prometheus.io/docs/concepts/data_model/ |
| Node Exporter | https://github.com/prometheus/node_exporter |
| kube-state-metrics | https://github.com/kubernetes/kube-state-metrics |
| Alertmanager | https://prometheus.io/docs/alerting/latest/alertmanager/ |
| Grafana Docs | https://grafana.com/docs/grafana/latest/ |
| kube-prometheus-stack | https://github.com/prometheus-community/helm-charts |
| Abhishek Series | https://github.com/iam-veeramalla/observability-zero-to-hero |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
