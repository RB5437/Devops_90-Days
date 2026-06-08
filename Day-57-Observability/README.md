
## 📅 Date: 8 June 2026
## 🎯 Topic: Introduction to Observability + Prometheus Architecture + EKS Setup

---

## 📚 Resources Used
- 📺 **Abhishek Veeramalla - Observability Series**
  - Day 1: https://www.youtube.com/watch?v=otY2_M_pTmU
  - Full Playlist: https://www.youtube.com/playlist?list=PLdpzxOOAlwvJUIfwmmVDoPYqXXUNbdBmb
  - GitHub Repo: https://github.com/iam-veeramalla/observability-zero-to-hero

---

## 🔭 What is Observability?
Observability is the ability to understand the **internal state** of a system by analyzing the data it produces — including **Metrics, Logs, and Traces**.
- Observability is the ability to understand the internal state of a system by analyzing the data it produces, including logs, metrics, and traces.

- Monitoring(Metrics): involves tracking system metrics like CPU usage, memory usage, and network performance. Provides alerts based on predefined thresholds and conditions
    - `Monitoring tells us what is happening.`
- Logging(Logs):  involves the collection of log data from various components of a system.
    - `Logging explains why it is happening.`
- Tracing(Traces): involves tracking the flow of a request or transaction as it moves through different services and components within a system.
    - `Tracing shows how it is happening.`

### 3 Pillars of Observability

| Pillar | Tool | What it tells |
|--------|------|---------------|
| **Metrics** | Prometheus + Grafana | WHAT is happening — CPU, memory, error rates |
| **Logs** | EFK Stack | WHY it is happening — error messages, events |
| **Traces** | Jaeger + OpenTelemetry | HOW it is happening — request flow across services |

---


## 🆚 Monitoring vs Observability

| Category | Monitoring | Observability |
|----------|-----------|---------------|
| Focus | Is everything working? | Why is it behaving this way? |
| Data | Predefined metrics | Metrics + Logs + Traces |
| Alerts | Threshold-based alerts | Root cause correlation |
| Scope | Known unknowns | Unknown unknowns |
| Key Question | WHAT & WHEN | WHY & HOW |

> 🔥 **Key Rule**: Monitoring is the **WHEN and WHAT** — Observability is the **WHY and HOW**
> Monitoring is a **subset** of Observability.

---

## 🏠 Prometheus Architecture

### Official Docs: https://prometheus.io/docs/introduction/overview/

### Components

| Component | Role | Official Link |
|-----------|------|---------------|
| **Prometheus Server** | Core — scrapes, stores, serves metrics | https://prometheus.io/docs/prometheus/latest/getting_started/ |
| **Retrieval** | Scrapes metrics from targets | https://prometheus.io/docs/prometheus/latest/configuration/configuration/ |
| **TSDB** | Time-series database — stores all metrics on disk | https://prometheus.io/docs/prometheus/latest/storage/ |
| **HTTP Server** | Serves PromQL queries via API | https://prometheus.io/docs/prometheus/latest/querying/api/ |
| **Service Discovery** | Auto-discovers targets — Kubernetes + File SD | https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config |
| **Pushgateway** | Accepts metrics from short-lived jobs | https://github.com/prometheus/pushgateway |
| **Alertmanager** | Deduplicates, groups, routes alerts | https://prometheus.io/docs/alerting/latest/alertmanager/ |
| **Exporters** | Expose 3rd party app metrics for Prometheus | https://prometheus.io/docs/instrumenting/exporters/ |
| **Node Exporter** | Hardware metrics — CPU, RAM, Disk | https://github.com/prometheus/node_exporter |
| **Grafana** | Dashboard + Visualization tool | https://grafana.com/docs/grafana/latest/ |

### Pull vs Push Model
- **Pull Model** (Default): Prometheus scrapes targets at regular intervals
- **Push Model** (via Pushgateway): Short-lived jobs push metrics before exiting

---

## ⚙️ Installation — EKS + kube-prometheus-stack

### Prerequisites
- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- eksctl: https://eksctl.io/installation/
- kubectl: https://kubernetes.io/docs/tasks/tools/
- Helm: https://helm.sh/docs/intro/install/

### Helm Chart Used
- **kube-prometheus-stack**: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
- **ArtifactHub**: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

### What kube-prometheus-stack Deploys
- Prometheus Server
- Grafana (password: `prom-operator`)
- Alertmanager (2 replicas — HA mode)
- Node Exporter (DaemonSet — runs on every node)
- kube-state-metrics
- Prometheus Operator

---

## 🧼 Cleanup Commands
```bash
helm uninstall monitoring --namespace monitoring
kubectl delete ns monitoring
eksctl delete cluster --name observability
```

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Prometheus Docs | https://prometheus.io/docs/ |
| Prometheus Architecture | https://prometheus.io/docs/introduction/overview/ |
| Grafana Docs | https://grafana.com/docs/ |
| Alertmanager Docs | https://prometheus.io/docs/alerting/latest/alertmanager/ |
| Node Exporter | https://github.com/prometheus/node_exporter |
| kube-prometheus-stack | https://github.com/prometheus-community/helm-charts |
| Prometheus Exporters | https://prometheus.io/docs/instrumenting/exporters/ |
| CNCF Prometheus | https://www.cncf.io/projects/prometheus/ |
| Abhishek Series | https://github.com/iam-veeramalla/observability-zero-to-hero |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days

#90DaysOfDevOps #Prometheus #Grafana #Observability #Kubernetes #EKS
