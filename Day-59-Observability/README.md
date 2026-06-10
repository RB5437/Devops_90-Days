# Day 59 — Custom Metrics + Alertmanager + EFK Stack 🔭
## 📅 Date: 10 June 2026
## 🎯 Topic: Instrumentation + Custom Metrics (Node.js) + Alertmanager Email Alerts + EFK Logging Stack

---

## 📚 Resources Used
- 📺 **Abhishek Veeramalla — Observability Series Day 4 + Day 5**
  - Playlist: https://www.youtube.com/playlist?list=PLdpzxOOAlwvJUIfwmmVDoPYqXXUNbdBmb
  - GitHub: https://github.com/iam-veeramalla/observability-zero-to-hero

---

## 🎛️ Part 1 — Instrumentation + Custom Metrics (Day 4)

### What is Instrumentation?
Adding monitoring capabilities to your application by **embedding code** to expose metrics, logs, or traces.

### 4 Types of Prometheus Metrics
| Type | Behavior | Use Case | K8s Example |
|------|----------|----------|-------------|
| **Counter** | Only goes UP — cumulative | HTTP request count, errors | `kube_pod_container_status_restarts_total` |
| **Gauge** | Goes UP and DOWN | Memory usage, CPU, active connections | `container_memory_usage_bytes` |
| **Histogram** | Samples + configurable buckets | Request duration, response size | `apiserver_request_duration_seconds_bucket` |
| **Summary** | Samples + pre-defined quantiles | 95th percentile latency | `apiserver_request_duration_seconds_sum` |

### Custom Metrics in Node.js (prom-client)
**Docs**: https://prometheus.io/docs/instrumenting/clientlibs/

```javascript
const promClient = require('prom-client');

// Counter — only goes up
const httpRequestCounter = new promClient.Counter({
    name: 'http_requests_total',
    help: 'Total number of HTTP requests',
    labelNames: ['method', 'path', 'status_code'],
});

// Histogram — buckets for response time
const requestDurationHistogram = new promClient.Histogram({
    name: 'http_request_duration_seconds',
    help: 'Duration of HTTP requests in seconds',
    labelNames: ['method', 'path', 'status_code'],
    buckets: [0.1, 0.5, 1, 5, 10],
});

// Summary — percentiles
const requestDurationSummary = new promClient.Summary({
    name: 'http_request_duration_summary_seconds',
    help: 'Summary of HTTP request durations',
    labelNames: ['method', 'path', 'status_code'],
    percentiles: [0.5, 0.9, 0.99],
});

// Gauge — goes up and down
const gauge = new promClient.Gauge({
    name: 'node_gauge_example',
    help: 'Example gauge tracking async task duration',
    labelNames: ['method', 'status']
});
```

### ServiceMonitor — Prometheus Auto-Discovery
```yaml
# Official: https://prometheus-operator.dev/docs/developer/api-reference/
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: a-service-service-monitor
  namespace: monitoring
  labels:
    release: monitoring
spec:
  endpoints:
    - interval: 2s
      port: a-service-port
      path: /metrics
  selector:
    matchLabels:
      app: a-service
  namespaceSelector:
    matchNames:
      - dev
```

---

## 🚨 Part 2 — Alertmanager Email Alerts

### PrometheusRule — Alert Definitions
```yaml
# Official: https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1.PrometheusRule
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: custom-alert-rules
  namespace: monitoring
  labels:
    release: monitoring
spec:
  groups:
  - name: custom.rules
    rules:
    - alert: HighCpuUsage
      expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 50
      for: 5m
      labels:
        severity: warning

    - alert: PodRestart
      expr: kube_pod_container_status_restarts_total > 2
      for: 0m
      labels:
        severity: critical
```

### AlertmanagerConfig — Email Routing
```yaml
# Official: https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1alpha1.AlertmanagerConfig
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: main-rules-alert-config
  namespace: monitoring
  labels:
    release: monitoring
spec:
  route:
    repeatInterval: 30m
    receiver: 'null'
    routes:
    - matchers:
      - name: alertname
        value: HighCpuUsage
      receiver: 'send-email'
    - matchers:
      - name: alertname
        value: PodRestart
      receiver: 'send-email'
  receivers:
  - name: 'send-email'
    emailConfigs:
    - to: YOUR_EMAIL
      smarthost: smtp.gmail.com:587
      authUsername: YOUR_EMAIL
```

---

## 📝 Part 3 — EFK Logging Stack (Day 5)

### What is EFK?
| Component | Role | Port |
|-----------|------|------|
| **Elasticsearch** | Stores + indexes log data | 9200 |
| **Fluentbit** | Lightweight log forwarder — collects from K8s pods | — |
| **Kibana** | Visualization + exploration UI | 5601 |

### Official Links
| Tool | Link |
|------|------|
| Elasticsearch Helm | https://helm.elastic.co |
| Fluentbit Helm | https://fluent.github.io/helm-charts |
| Kibana Docs | https://www.elastic.co/kibana |
| Fluentbit Docs | https://docs.fluentbit.io/manual |

### Architecture
```
K8s Pods (logs) → Fluentbit (DaemonSet) → Elasticsearch → Kibana (UI)
```

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
