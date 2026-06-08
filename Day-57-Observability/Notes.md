# Day 57 — Notes | Observability + Prometheus Architecture + EKS Setup

## 📅 Date: 8 June 2026

---

## 🔭 Concept 1: Observability — The 3 Pillars

### Official Reference: https://opentelemetry.io/docs/concepts/observability-primer/

```
Observability = Metrics + Logs + Traces
                    ↓         ↓       ↓
               Prometheus   EFK    Jaeger
               Grafana     Stack  OpenTelemetry
```
## 🆚 What is the Exact Difference Between Monitoring and Observability?
- 🔥 Monitoring is the *`when and what`* of a system error, and observability is the *`why and how`*

| Category       | Monitoring                                   | Observability                                         |
|----------------|----------------------------------------------|------------------------------------------------------|
| Focus          | Checking if everything is working as expected| Understanding why things are happening in the system  |
| Data           | Collects metrics like CPU usage, memory usage, and error rates | Collects logs, metrics, and traces to provide a full picture |
| Alerts         | Sends notifications when something goes wrong| Correlates events and anomalies to identify root causes |
| Example        | If a server's CPU usage goes above 90%, monitoring will alert us | If a website is slow, observability helps us trace the user's request through different services to find the bottleneck |
| Insight        | Identifies potential issues before they become critical | Helps diagnose issues and understand system behavior |

### Metrics (Monitoring)
- Quantitative data points — CPU %, memory MB, requests/sec
- Tells us **WHAT** is happening
- Tool: Prometheus + Grafana
- Docs: https://prometheus.io/docs/concepts/data_model/

### Logs (Logging)
- Detailed text records of events and transactions
- Tells us **WHY** it is happening
- Tool: EFK Stack (Elasticsearch + Fluentbit + Kibana)
- Docs: https://www.elastic.co/what-is/elk-stack

### Traces (Tracing)
- Tracks flow of a request across multiple services
- Shows **HOW** it is happening
- Tool: Jaeger + OpenTelemetry
- Docs: https://www.jaegertracing.io/docs/

---

## 🆚 Concept 2: Monitoring vs Observability

### Key Difference
- **Monitoring** = REACTIVE — you know what to look for
- **Observability** = PROACTIVE — you can find what you don't know

### Real Example
```
User: "App is slow!"

Monitoring:
→ Alert fired: Response time > 2s ❌
→ Only knows WHAT went wrong

Observability:
→ Metrics: /checkout API taking 5s
→ Logs: DB connection timeout at 14:32:05
→ Traces: payment-service stuck for 4.8s
→ ROOT CAUSE FOUND ✅
```

### Monitoring is Subset of Observability
```
┌─────────────────────────────────┐
│         Observability           │
│   ┌─────────────────────────┐   │
│   │       Monitoring        │   │
│   │   (Metrics + Alerts)    │   │
│   └─────────────────────────┘   │
│   + Logging + Tracing           │
└─────────────────────────────────┘
```

---

## 🏠 Concept 3: Prometheus Architecture Deep Dive

### Official: https://prometheus.io/docs/introduction/overview/

### 1. Prometheus Server
- **Retrieval**: Scrapes metrics from targets via HTTP
- **TSDB**: Time Series Database — stores metrics on local disk
- **HTTP Server**: Serves PromQL queries via REST API
- Storage path: `/var/lib/prometheus/`

### 2. Service Discovery
- **Kubernetes SD**: Auto-discovers pods, services, nodes via K8s API
- **File SD**: Static targets from YAML/JSON files
- Docs: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config

### 3. Pushgateway
- For short-lived jobs (batch, cron) that exit before being scraped
- Job pushes metrics → Pushgateway stores → Prometheus scrapes
- Docs: https://github.com/prometheus/pushgateway
- ⚠️ Not for long-running services

### 4. Exporters
- Bridge between Prometheus and 3rd party apps
- App doesn't natively expose metrics → Exporter translates
- **Node Exporter**: CPU, memory, disk, network (port 9100)
- **kube-state-metrics**: K8s object states — pods, deployments
- **MySQL Exporter**: Database metrics
- Full list: https://prometheus.io/docs/instrumenting/exporters/

### 5. Alertmanager
- Receives alerts from Prometheus
- **Deduplication**: Same alert fired multiple times → sent once
- **Grouping**: Multiple alerts → single notification
- **Routing**: Different alerts → different channels (Slack/Email/PagerDuty)
- Default port: 9093
- Docs: https://prometheus.io/docs/alerting/latest/alertmanager/

### 6. Grafana
- Connects to Prometheus as data source
- Creates dashboards from PromQL queries
- Default port: 3000
- Docs: https://grafana.com/docs/grafana/latest/datasources/prometheus/

---

## ⚙️ Concept 4: kube-prometheus-stack

### What It Is
- Helm chart that installs complete monitoring stack in one command
- Chart: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

### What Gets Deployed
| Component | Type | Port |
|-----------|------|------|
| Prometheus Server | StatefulSet | 9090 |
| Grafana | Deployment | 3000 (mapped 8080) |
| Alertmanager | StatefulSet (2 replicas) | 9093 |
| Node Exporter | DaemonSet | 9100 |
| kube-state-metrics | Deployment | 8080 |
| Prometheus Operator | Deployment | — |

### Custom Config — alertmanager HA
```yaml
alertmanager:
  alertmanagerSpec:
    replicas: 2                          # HA — 2 replicas
    alertmanagerConfigSelector:
      matchLabels:
        release: monitoring              # Match CRD configs
    alertmanagerConfigMatcherStrategy:
      type: None                         # No namespace matchers
```

### Why replicas: 2?
- Single replica → if pod crashes → alerts stop
- 2 replicas → High Availability → alerts always fire

---

## 📊 Concept 5: Bare Metal vs Kubernetes Monitoring

| Aspect | Bare Metal | Kubernetes |
|--------|-----------|------------|
| Environment | Static, predictable | Dynamic, ephemeral |
| Targets | Fixed IPs | Pods change constantly |
| Discovery | Manual/File SD | Kubernetes SD (auto) |
| Complexity | Simple | Complex — distributed |
| Layers | Few | Many (node→pod→container) |

---

## 🔑 Key Points to Remember

1. Monitoring = **subset** of Observability
2. Prometheus uses **Pull model** (not Push — except Pushgateway)
3. TSDB stores data locally — **not** distributed by default
4. kube-prometheus-stack = **batteries included** monitoring for K8s
5. Alertmanager needs **2 replicas** for HA in production
6. Node Exporter = **DaemonSet** — runs on every node
7. Grafana is just a **visualization layer** — Prometheus is the data source

---

## 📖 All Official Links

| Topic | Link |
|-------|------|
| Prometheus Overview | https://prometheus.io/docs/introduction/overview/ |
| Data Model | https://prometheus.io/docs/concepts/data_model/ |
| Storage | https://prometheus.io/docs/prometheus/latest/storage/ |
| Exporters | https://prometheus.io/docs/instrumenting/exporters/ |
| Alertmanager | https://prometheus.io/docs/alerting/latest/alertmanager/ |
| Grafana Prometheus DS | https://grafana.com/docs/grafana/latest/datasources/prometheus/ |
| kube-state-metrics | https://github.com/kubernetes/kube-state-metrics |
| Node Exporter | https://github.com/prometheus/node_exporter |
| OpenTelemetry Observability | https://opentelemetry.io/docs/concepts/observability-primer/ |
| Abhishek GitHub | https://github.com/iam-veeramalla/observability-zero-to-hero |
