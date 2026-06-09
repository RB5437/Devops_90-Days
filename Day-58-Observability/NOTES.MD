# Day 58 — Notes | Prometheus + PromQL + Metrics + Node Exporter + kube-state-metrics

## 📅 Date: 9 June 2026

---

## 📊 Concept 1: Metrics in Prometheus
**Docs**: https://prometheus.io/docs/concepts/data_model/

- Metrics = core data objects representing measurements from monitored systems
- Every metric has a **name** + **labels** (key-value pairs)
- Labels differentiate dimensions — same metric, different services/instances

```
# Format: metric_name{label1="value1", label2="value2"}
container_cpu_usage_seconds_total{namespace="kube-system", endpoint="https-metrics"}
```

**Why labels matter:**
- Without labels: `node_cpu_seconds_total` → all CPUs combined
- With labels: `node_cpu_seconds_total{cpu="0", mode="idle"}` → specific CPU + mode

---

## 🛠️ Concept 2: PromQL Deep Dive
**Docs**: https://prometheus.io/docs/prometheus/latest/querying/basics/

### Types of Selectors
```promql
# Exact match
container_cpu_usage_seconds_total{namespace="kube-system"}

# Regex match (~=)
container_cpu_usage_seconds_total{pod=~"kube-proxy.*"}

# Negative regex (!~)
container_cpu_usage_seconds_total{pod!~"kube-proxy.*"}
```

### Instant vs Range Vector
```promql
# Instant vector — current value
node_load1

# Range vector — last 5 minutes of data
node_cpu_seconds_total[5m]
```

### Key Functions
| Function | Use | Example |
|----------|-----|---------|
| `rate()` | Per-second rate over time range | `rate(http_requests_total[5m])` |
| `irate()` | Instant rate (last 2 points) | `irate(http_requests_total[5m])` |
| `increase()` | Total increase over time range | `increase(restarts_total[1h])` |
| `sum()` | Aggregate across all series | `sum(rate(cpu[5m]))` |
| `avg()` | Average | `avg(memory_bytes) by (namespace)` |
| `histogram_quantile()` | Percentile from histogram | `histogram_quantile(0.95, ...)` |

**Docs**: https://prometheus.io/docs/prometheus/latest/querying/functions/

---

## 🔍 Concept 3: Node Exporter
**GitHub**: https://github.com/prometheus/node_exporter

- Runs as **DaemonSet** — one pod per node
- Exposes hardware metrics on port **9100**
- Prometheus pulls from `/metrics` endpoint

**Key metrics from Node Exporter:**
```
node_cpu_seconds_total{cpu="0",mode="idle"}          → CPU idle time
node_memory_MemTotal_bytes                           → Total RAM
node_memory_MemAvailable_bytes                       → Available RAM
node_filesystem_avail_bytes                          → Disk available
node_load1 / node_load5 / node_load15               → Load averages
node_network_receive_bytes_total                     → Network RX
node_network_transmit_bytes_total                    → Network TX
node_disk_io_time_seconds_total                      → Disk I/O time
```

**Verified in live cluster:**
```
node_load1 = 1.14  (1-min load)
node_load5 = 1.41  (5-min load)
node_memory_MemTotal_bytes = 7.16GB
node_memory_MemAvailable_bytes = 2.72GB
```

---

## 🔍 Concept 4: kube-state-metrics
**GitHub**: https://github.com/kubernetes/kube-state-metrics

- Listens to K8s API → generates metrics about K8s object **states**
- Exposes on port **8080**
- Different from Node Exporter — Node Exporter = hardware, kube-state-metrics = K8s objects

**Key metrics:**
```
kube_pod_status_phase                    → Pod Running/Pending/Failed
kube_pod_container_status_ready          → Container ready = 1
kube_pod_container_status_restarts_total → Restart count
kube_deployment_status_replicas_ready    → Ready replicas
kube_node_status_condition               → Node Ready/NotReady
kube_daemonset_status_number_ready       → DaemonSet pods ready
```

**Verified in live cluster:**
- All 9 monitoring pods: `kube_pod_container_status_ready = 1` ✅
- Node Exporter DaemonSet: 3 desired, 3 ready ✅
- Alertmanager StatefulSet: 2/2 replicas ready ✅

---

## ⚙️ Concept 5: custom_kube_prometheus_stack.yml

**Why custom config?**
```yaml
alertmanager:
  alertmanagerSpec:
    replicas: 2                        # HA — prevents alert blackout on pod crash
    alertmanagerConfigSelector:
      matchLabels:
        release: monitoring            # Selects AlertmanagerConfig CRDs
    alertmanagerConfigMatcherStrategy:
      type: None                       # No namespace matchers — clean routing
```

**Without this config:**
- `alertmanagerConfigSelector` mismatch → custom alert configs not picked up
- `replicas: 1` → single point of failure for alerting
- `namespace matchers` → routing issues with multi-namespace setups

---

## 🔑 Key Concepts to Remember

| Concept | What to Remember |
|---------|-----------------|
| Prometheus | Pull-based — it scrapes targets, not push |
| TSDB | Local disk — not distributed by default |
| Node Exporter | DaemonSet — runs on every node, port 9100 |
| kube-state-metrics | K8s API watcher — pod/deploy/node states |
| PromQL rate() | Always use with counter metrics, not gauge |
| Labels | Key to filtering — use `{}` for label selectors |
| Alertmanager HA | 2+ replicas in production — always |

---

## 📖 Official Links

| Topic | Link |
|-------|------|
| PromQL Basics | https://prometheus.io/docs/prometheus/latest/querying/basics/ |
| PromQL Functions | https://prometheus.io/docs/prometheus/latest/querying/functions/ |
| PromQL Examples | https://prometheus.io/docs/prometheus/latest/querying/examples/ |
| Storage/TSDB | https://prometheus.io/docs/prometheus/latest/storage/ |
| Node Exporter | https://github.com/prometheus/node_exporter |
| Node Exporter metrics | https://github.com/prometheus/node_exporter#collectors |
| kube-state-metrics | https://github.com/kubernetes/kube-state-metrics |
| kube-state-metrics exposed | https://github.com/kubernetes/kube-state-metrics/tree/main/docs |
| Alertmanager HA | https://prometheus.io/docs/alerting/latest/alertmanager/#high-availability |
