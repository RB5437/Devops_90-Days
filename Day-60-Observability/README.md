# Day 60 — Distributed Tracing with Jaeger 🕵️
## 📅 Date: 11 June 2026
## 🎯 Topic: Jaeger Architecture + OpenTelemetry Instrumentation + Helm Setup on Kubernetes

---

## 📚 Resources Used
- 📺 **Abhishek Veeramalla — Observability Series Day 6**
  - Playlist: https://www.youtube.com/playlist?list=PLdpzxOOAlwvJUIfwmmVDoPYqXXUNbdBmb
  - GitHub: https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-6

---

## 🕵️ What is Jaeger?
Jaeger is an open-source **end-to-end distributed tracing** system for monitoring and troubleshooting microservices. It traces the **complete journey of a request** across multiple services and measures how long each step takes.

**Official Docs**: https://www.jaegertracing.io/docs/

---

## ❓ Why Distributed Tracing?

In microservices, a single user request touches **multiple services**. When something is slow or broken, you need to know exactly **which service** caused it.

| Problem | Jaeger Solves It |
|---------|-----------------|
| Request is slow — which service? | Trace shows time spent in each service |
| Error occurred — where exactly? | Trace shows exact span where error happened |
| Performance optimization | Shows bottlenecks across service chain |

---

## 📚 Core Concepts

| Concept | Description |
|---------|-------------|
| **Trace** | Complete journey of one request across all services |
| **Span** | Single operation within a trace (API call, DB query) — has start time + duration |
| **Tags** | Key-value pairs on a span — HTTP method, status code, user ID |
| **Logs** | Events within a span — errors, checkpoints |
| **Context Propagation** | Trace info passed between services via HTTP headers |

```
User Request
    └── Trace (full journey)
            ├── Span 1: API Gateway (50ms)
            ├── Span 2: Auth Service (20ms)
            ├── Span 3: Product Service (150ms)
            │       └── Span 4: DB Query (140ms) ← BOTTLENECK
            └── Span 5: Response (5ms)
```

---

## 🏠 Jaeger Architecture

| Component | Role |
|-----------|------|
| **Agent** | Collects traces from application — runs as sidecar/DaemonSet |
| **Collector** | Receives traces from Agent → processes → stores in Elasticsearch |
| **Query** | Provides UI to search and view traces (port 80/16686) |
| **Storage** | Elasticsearch — stores all trace data |

**Official Architecture**: https://www.jaegertracing.io/docs/latest/architecture/

---

## 🔗 OpenTelemetry Instrumentation

OpenTelemetry is the standard way to instrument applications for tracing.

**Official Docs**: https://opentelemetry.io/docs/

```javascript
// tracing.js — Node.js instrumentation
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');

const provider = new NodeTracerProvider();
const exporter = new OTLPTraceExporter({
    url: 'http://jaeger-collector:4318/v1/traces'
});
provider.register();
```

**How it works:**
```
App (OpenTelemetry) → Jaeger Agent → Jaeger Collector → Elasticsearch → Jaeger UI
```

---

## ⚙️ Jaeger Setup on Kubernetes (Helm)

### Prerequisites
- Elasticsearch running in `logging` namespace (from Day 5 EFK setup)
- EKS cluster running

### Helm Chart
- **ArtifactHub**: https://artifacthub.io/packages/helm/jaegertracing/jaeger
- **GitHub**: https://github.com/jaegertracing/helm-charts

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Jaeger Docs | https://www.jaegertracing.io/docs/ |
| Jaeger Architecture | https://www.jaegertracing.io/docs/latest/architecture/ |
| Jaeger Helm Chart | https://github.com/jaegertracing/helm-charts |
| OpenTelemetry Docs | https://opentelemetry.io/docs/ |
| OpenTelemetry Node.js | https://opentelemetry.io/docs/languages/js/ |
| Jaeger + Elasticsearch | https://www.jaegertracing.io/docs/latest/deployment/#elasticsearch |
| Context Propagation | https://opentelemetry.io/docs/concepts/context-propagation/ |
| Observability Series | https://github.com/iam-veeramalla/observability-zero-to-hero |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
