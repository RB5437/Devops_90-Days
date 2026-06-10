# Day 59 — Notes | Custom Metrics + Alertmanager + EFK Stack

## 📅 Date: 10 June 2026

---

## 📈 Concept 1: 4 Types of Prometheus Metrics
**Docs**: https://prometheus.io/docs/concepts/metric_types/

### Counter
- **Only goes UP** — never decreases (except on restart → reset to 0)
- Use for: request counts, errors, total bytes sent
- Always use with `rate()` or `increase()` in PromQL
```promql
# Wrong — raw counter is useless
http_requests_total

# Correct — rate of requests per second
rate(http_requests_total[5m])
```

### Gauge
- **Goes UP and DOWN** — current snapshot
- Use for: memory usage, CPU %, active connections, queue size
```promql
# Current memory
container_memory_usage_bytes{namespace="dev"}

# Memory usage in MB
container_memory_usage_bytes / 1024 / 1024
```

### Histogram
- **Buckets** — counts observations in configurable time ranges
- Provides: `_bucket`, `_sum`, `_count`
- Use for: request duration, response size
```promql
# 95th percentile response time
histogram_quantile(0.95,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)
```

### Summary
- **Pre-computed quantiles** at application level
- Provides: percentiles directly (no need for histogram_quantile)
- More accurate but more expensive (computed client-side)
- Docs: https://prometheus.io/docs/practices/histograms/

---

## 🎛️ Concept 2: Custom Metrics with prom-client
**GitHub**: https://github.com/siimon/prom-client

### How it works:
1. App uses `prom-client` library → defines metrics
2. Middleware tracks every request → increments counter/histogram
3. `/metrics` endpoint → exposes metrics in Prometheus format
4. ServiceMonitor tells Prometheus to scrape `/metrics`

### Middleware pattern:
```javascript
app.use((req, res, next) => {
    const start = Date.now();
    res.on('finish', () => {
        const duration = (Date.now() - start) / 1000;
        const { method, url } = req;
        const statusCode = res.statusCode;

        // Counter — increment on every request
        httpRequestCounter.labels({ method, path: url, status_code: statusCode }).inc();

        // Histogram — observe duration
        requestDurationHistogram.labels({ method, path: url, status_code: statusCode }).observe(duration);
    });
    next();
});
```

### Custom metrics exposed by the Node.js app:
| Metric | Type | What it tracks |
|--------|------|----------------|
| `http_requests_total` | Counter | Total HTTP requests (method + path + status) |
| `http_request_duration_seconds` | Histogram | Request duration in seconds |
| `http_request_duration_summary_seconds` | Summary | Request duration percentiles (p50, p90, p99) |
| `node_gauge_example` | Gauge | Async task duration |

---

## 🔗 Concept 3: ServiceMonitor — How Prometheus Discovers Custom Apps
**Docs**: https://prometheus-operator.dev/docs/developer/api-reference/

### Without ServiceMonitor:
- Prometheus doesn't know about your app
- Have to manually add to `prometheus.yml`

### With ServiceMonitor:
- Prometheus Operator watches for ServiceMonitor CRDs
- Automatically adds scrape config
- Dynamic — no restart needed

```
ServiceMonitor → Prometheus Operator → prometheus.yml auto-updated → Prometheus scrapes /metrics
```

**Key labels must match:**
- ServiceMonitor `release: monitoring` → must match Helm release name
- ServiceMonitor `selector.matchLabels` → must match Service labels

---

## 🚨 Concept 4: Alertmanager — How Alerts Flow
**Docs**: https://prometheus.io/docs/alerting/latest/alertmanager/

### Alert Flow:
```
PrometheusRule (expr) → Prometheus evaluates → FIRING → Alertmanager → Email/Slack/PagerDuty
```

### Alert States:
| State | Meaning |
|-------|---------|
| **Inactive** | Condition not met |
| **Pending** | Condition met, waiting for `for:` duration |
| **Firing** | Alert fired — notification sent |

### Two alerts configured:
```
HighCpuUsage:
- expr: CPU > 50% for 5 minutes
- severity: warning
- → Email sent

PodRestart:
- expr: restarts_total > 2 (immediate — for: 0m)
- severity: critical
- → Email sent every 5 minutes while firing
```

### Gmail App Password (not your real password):
- Google Account → Security → App Passwords → Create
- Used in `email-secrets.yml` as Kubernetes Secret

---

## 📝 Concept 5: EFK Stack — Logging in K8s
**Docs**: https://docs.fluentbit.io/manual

### Why logging is important:
- Metrics tell WHAT is wrong → Logs tell WHY
- Kubernetes pods are ephemeral → logs lost when pod dies
- EFK captures + persists logs centrally

### Fluentbit as DaemonSet:
- Runs on every node
- Reads logs from `/var/log/containers/`
- Forwards to Elasticsearch
- Lightweight (written in C) vs Fluentd (Ruby)

### EFK vs ELK:
| | EFK | ELK |
|--|-----|-----|
| Log collector | Fluentbit (lightweight) | Logstash (heavy) |
| Memory | Low | High |
| Speed | Fast | Slower |
| Best for | K8s | Non-K8s |

### Kibana workflow:
1. Login with Elasticsearch credentials
2. Create Data View (`fluent-bit-*`)
3. Explore logs by pod, namespace, timestamp
4. Create dashboards + alerts

---

## 🔑 Key Points to Remember

| Concept | Remember |
|---------|----------|
| Counter | NEVER use raw — always use rate() or increase() |
| Gauge | Direct value — no rate() needed |
| Histogram | Use histogram_quantile() for percentiles |
| Summary | Pre-computed quantiles — can't aggregate across instances |
| ServiceMonitor | label `release: monitoring` must match Helm release |
| PrometheusRule | label `release: monitoring` must match too |
| AlertmanagerConfig | label `release: monitoring` must match too |
| EFK | Fluentbit DaemonSet → reads /var/log/containers → Elasticsearch → Kibana |

---

## 📖 Official Links

| Topic | Link |
|-------|------|
| Metric Types | https://prometheus.io/docs/concepts/metric_types/ |
| prom-client (Node.js) | https://github.com/siimon/prom-client |
| Instrumentation Guide | https://prometheus.io/docs/practices/instrumentation/ |
| Histogram vs Summary | https://prometheus.io/docs/practices/histograms/ |
| ServiceMonitor API | https://prometheus-operator.dev/docs/developer/api-reference/ |
| PrometheusRule API | https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1.PrometheusRule |
| AlertmanagerConfig | https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1alpha1.AlertmanagerConfig |
| Alertmanager Routing | https://prometheus.io/docs/alerting/latest/configuration/#route |
| Fluentbit Docs | https://docs.fluentbit.io/manual |
| Elasticsearch Helm | https://github.com/elastic/helm-charts |
| Kibana Docs | https://www.elastic.co/guide/en/kibana/current/index.html |
