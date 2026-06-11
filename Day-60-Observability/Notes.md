# Day 60 — Notes | Distributed Tracing with Jaeger

## 📅 Date: 11 June 2026

---

## 🔭 Concept 1: The 3 Pillars of Observability — Complete Picture
**Reference**: https://opentelemetry.io/docs/concepts/observability-primer/

```
Observability
    ├── Metrics (Prometheus + Grafana)   → WHAT is happening — numbers
    ├── Logs    (EFK Stack)              → WHY it happened — events
    └── Traces  (Jaeger)                → HOW it happened — request journey
```

**When to use each:**
| Pillar | Question it answers | Tool |
|--------|---------------------|------|
| Metrics | Is my service healthy right now? | Prometheus |
| Logs | What error occurred at 14:32? | Elasticsearch + Kibana |
| Traces | Why did this request take 5 seconds? | Jaeger |

---

## 🕵️ Concept 2: Distributed Tracing Deep Dive

### The Problem Without Tracing
```
User: "Checkout is slow!"

Without tracing:
→ Check service-a logs → nothing obvious
→ Check service-b logs → nothing obvious
→ Check DB logs → nothing obvious
→ 2 hours wasted

With Jaeger:
→ Find trace for /checkout
→ See: payment-service took 4.8s out of 5s total
→ Drill into payment-service span
→ See: external payment API call timing out
→ Root cause in 2 minutes ✅
```

### Trace vs Span
```
Trace ID: abc123 (unique per request)
├── Span 1: [frontend] GET /checkout          0ms → 5000ms (5s total)
├── Span 2: [cart-service] getCart()          10ms → 80ms
├── Span 3: [inventory-service] checkStock()  80ms → 200ms
├── Span 4: [payment-service] processPayment() 200ms → 5000ms ← 4.8s!!
│     └── Span 5: [external-api] POST /charge  201ms → 4990ms ← TIMEOUT
└── Span 6: [email-service] sendConfirmation() skipped (payment failed)
```

---

## 🏠 Concept 3: Jaeger Architecture Components

### Agent
- Runs as a **sidecar** or **DaemonSet** in K8s
- Listens for spans sent by app on UDP port 6831
- Batches and forwards to Collector
- **Docs**: https://www.jaegertracing.io/docs/latest/architecture/#agent

### Collector
- Receives traces from Agent via gRPC/HTTP
- Validates, transforms, stores in backend
- Backend = Elasticsearch (production) or in-memory (dev)
- **Docs**: https://www.jaegertracing.io/docs/latest/architecture/#collector

### Query (UI)
- Web UI to search and visualize traces
- Connects to Elasticsearch to fetch stored traces
- Default port: 16686 (or 80 via Helm)
- **Docs**: https://www.jaegertracing.io/docs/latest/architecture/#query-service--ui

### Storage — Elasticsearch
- Stores traces as JSON documents
- Indexed by trace ID, service name, operation, tags
- Shares Elasticsearch with EFK logging stack in this setup

---

## 🔗 Concept 4: OpenTelemetry — The Standard
**Docs**: https://opentelemetry.io/docs/

OpenTelemetry (OTel) is a **vendor-neutral** standard for instrumentation. Write once → send to Jaeger, Zipkin, Datadog, or any backend.

### Key concepts:
| Term | Meaning |
|------|---------|
| **Tracer** | Creates and manages spans |
| **Span** | Represents one unit of work |
| **Exporter** | Sends spans to backend (Jaeger) |
| **Propagator** | Injects/extracts trace context from HTTP headers |

### Context Propagation — How Traces Cross Service Boundaries
```
Service A makes HTTP call to Service B:

Request Headers:
  traceparent: 00-abc123-def456-01
       ↑trace ID  ↑span ID

Service B:
1. Extracts trace ID from header
2. Creates child span with same trace ID
3. Trace stays connected across services
```
**Docs**: https://opentelemetry.io/docs/concepts/context-propagation/

---

## ⚙️ Concept 5: jaeger-values.yaml Explained

```yaml
storage:
  type: elasticsearch
  elasticsearch:
    host: elasticsearch-master.logging.svc  # K8s DNS — ES in logging namespace
    port: 9200
    scheme: https                            # TLS enabled
    user: elastic
    password: cbTQj1qxRIPNF5uc              # From ES secret

provisionDataStore:
  cassandra: false      # Don't create Cassandra
  elasticsearch: false  # Don't create new ES — use existing one

query:
  cmdlineParams:
    es.tls.ca: "/tls/ca-cert.pem"   # TLS cert for ES connection
  extraConfigmapMounts:
    - name: jaeger-tls
      mountPath: /tls               # Mount CA cert into container
      configMap: jaeger-tls

collector:
  cmdlineParams:
    es.tls.ca: "/tls/ca-cert.pem"  # Same TLS cert for collector
```

**Why TLS?** Elasticsearch was deployed with TLS enabled (Helm default). Jaeger must present the CA certificate to trust the ES server certificate.

---

## 🔑 Key Points to Remember

| Concept | Remember |
|---------|----------|
| Trace | Unique per request — one trace ID across all services |
| Span | One operation — has parent span (forms tree structure) |
| Context Propagation | Via HTTP headers — `traceparent` (W3C standard) |
| Jaeger Agent | Lightweight — runs close to app, UDP 6831 |
| Jaeger Collector | Heavy — processes + stores to ES |
| OpenTelemetry | Vendor-neutral — same code works for Jaeger + Zipkin + Datadog |
| TLS config | Jaeger needs ES CA cert when ES has TLS enabled |
| Trace vs Log | Trace = cross-service journey, Log = single service event |

---

## 📖 Official Links

| Topic | Link |
|-------|------|
| Jaeger Overview | https://www.jaegertracing.io/docs/latest/ |
| Jaeger Architecture | https://www.jaegertracing.io/docs/latest/architecture/ |
| Jaeger Deployment | https://www.jaegertracing.io/docs/latest/deployment/ |
| Jaeger + Elasticsearch | https://www.jaegertracing.io/docs/latest/deployment/#elasticsearch |
| Jaeger Helm Chart | https://github.com/jaegertracing/helm-charts |
| OpenTelemetry Concepts | https://opentelemetry.io/docs/concepts/ |
| OTel Context Propagation | https://opentelemetry.io/docs/concepts/context-propagation/ |
| OTel Node.js SDK | https://opentelemetry.io/docs/languages/js/getting-started/nodejs/ |
| W3C Trace Context | https://www.w3.org/TR/trace-context/ |
| Abhishek Day 6 | https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-6 |
