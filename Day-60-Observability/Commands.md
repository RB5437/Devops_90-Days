# Day 60 — Commands | Jaeger Distributed Tracing on Kubernetes

## 📅 Date: 11 June 2026

---

## 📋 Prerequisites

```bash
# Elasticsearch must be running from Day 5 (EFK setup)
kubectl get pods -n logging
# Should show elasticsearch-master-0 Running ✅

# EKS cluster must be running
kubectl get nodes
```

---

## 🔐 Step 1: Export Elasticsearch CA Certificate

```bash
# Official: https://www.jaegertracing.io/docs/latest/deployment/#elasticsearch

# Get CA cert from Elasticsearch TLS secret — decode and save to file
kubectl get secret elasticsearch-master-certs -n logging \
  -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca-cert.pem

# Verify the cert was saved
cat ca-cert.pem
ls -la ca-cert.pem
```

---

## 🗂️ Step 2: Create Tracing Namespace

```bash
kubectl create ns tracing

# Verify
kubectl get ns tracing
```

---

## 🔒 Step 3: Create ConfigMap + Secret for TLS

```bash
# ConfigMap — mounts CA cert into Jaeger Query and Collector pods
kubectl create configmap jaeger-tls \
  --from-file=ca-cert.pem \
  -n tracing

# Secret — alternative TLS storage
kubectl create secret generic es-tls-secret \
  --from-file=ca-cert.pem \
  -n tracing

# Verify both were created
kubectl get configmap jaeger-tls -n tracing
kubectl get secret es-tls-secret -n tracing
```

---

## 📦 Step 4: Add Jaeger Helm Repository

```bash
# Official: https://github.com/jaegertracing/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

# Verify repo added
helm repo list | grep jaeger

# Search available Jaeger charts
helm search repo jaegertracing
```

---

## ⚙️ Step 5: Update jaeger-values.yaml

```bash
# Get Elasticsearch password (from Day 5 setup)
kubectl get secrets --namespace=logging elasticsearch-master-credentials \
  -o jsonpath='{.data.password}' | base64 -d
echo ""

# Edit jaeger-values.yaml — update password field
vim jaeger-values.yaml
# Change: password: <PASTE_YOUR_ES_PASSWORD_HERE>
```

```yaml
# jaeger-values.yaml contents:
storage:
  type: elasticsearch
  elasticsearch:
    host: elasticsearch-master.logging.svc   # K8s internal DNS
    port: 9200
    scheme: https
    user: elastic
    password: YOUR_ES_PASSWORD_HERE          # ← Update this!
    tls:
      enabled: true
      ca: /tls/ca-cert.pem

provisionDataStore:
  cassandra: false
  elasticsearch: false

query:
  cmdlineParams:
    es.tls.ca: "/tls/ca-cert.pem"
  extraConfigmapMounts:
    - name: jaeger-tls
      mountPath: /tls
      subPath: ""
      configMap: jaeger-tls
      readOnly: true

collector:
  cmdlineParams:
    es.tls.ca: "/tls/ca-cert.pem"
  extraConfigmapMounts:
    - name: jaeger-tls
      mountPath: /tls
      subPath: ""
      configMap: jaeger-tls
      readOnly: true
```

---

## 🚀 Step 6: Install Jaeger via Helm

```bash
# Official: https://artifacthub.io/packages/helm/jaegertracing/jaeger
helm install jaeger jaegertracing/jaeger \
  -n tracing \
  --values jaeger-values.yaml

# Watch pods come up
kubectl get pods -n tracing -w

# Verify all components running
kubectl get all -n tracing
```

**Expected pods:**
```
jaeger-agent          → DaemonSet (1 per node)
jaeger-collector      → Deployment
jaeger-query          → Deployment (UI)
```

---

## 🌐 Step 7: Access Jaeger UI

```bash
# Port forward Jaeger Query service
kubectl port-forward svc/jaeger-query 8080:80 -n tracing

# For EC2/Cloud VM
kubectl port-forward svc/jaeger-query 8080:80 -n tracing --address 0.0.0.0 &

# Access: http://<vm-ip>:8080
```

---

## 🔍 Step 8: Verify Traces in Jaeger UI

```bash
# Generate traffic to instrumented services
LBURL="http://YOUR_SERVICE_LB_DNS"

curl $LBURL/
curl $LBURL/call-service-b    # Cross-service call — creates multi-span trace
curl $LBURL/logs
curl $LBURL/serverError        # Error trace
```

**In Jaeger UI:**
1. Select Service from dropdown → `service-a`
2. Click "Find Traces"
3. Click a trace to see the full span tree
4. Look for long spans — those are bottlenecks
5. Check error traces — red spans = errors

---

## 🔧 Debug Commands

```bash
# Check Jaeger collector logs
kubectl logs -l app.kubernetes.io/component=collector -n tracing

# Check Jaeger query logs
kubectl logs -l app.kubernetes.io/component=query -n tracing

# Check Jaeger agent logs (pick one pod)
kubectl logs -l app.kubernetes.io/component=agent -n tracing

# Check if Elasticsearch indices were created
kubectl exec -it elasticsearch-master-0 -n logging -- \
  curl -u elastic:PASSWORD -k https://localhost:9200/_cat/indices | grep jaeger

# Describe a failing pod
kubectl describe pod <pod-name> -n tracing
```

---

## 🧼 Complete Cleanup

```bash
# Official: https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-6

# Remove Jaeger
helm uninstall jaeger -n tracing
kubectl delete ns tracing

# Remove EFK stack (from Day 5)
helm uninstall elasticsearch -n logging
helm uninstall kibana -n logging
helm uninstall fluent-bit -n logging
kubectl delete ns logging

# Remove Prometheus + Grafana (from Day 2)
helm uninstall monitoring -n monitoring
kubectl delete ns monitoring

# Remove instrumented apps (from Day 4)
cd day-4
kubectl delete -k kubernetes-manifest/
kubectl delete -k alerts-alertmanager-servicemonitor-manifest/

# Delete EKS cluster + all resources
eksctl delete cluster --name observability
```

---

## 📋 Port Reference

| Service | Port | Access |
|---------|------|--------|
| Jaeger UI (Query) | 80 → 8080 | Port-forward |
| Jaeger Collector gRPC | 14250 | Internal |
| Jaeger Collector HTTP | 14268 | Internal |
| Jaeger Agent UDP | 6831 | Internal |
| Elasticsearch | 9200 | Internal |

---

## 📖 Official Docs Links

| Command/Topic | Official Link |
|---------------|---------------|
| Jaeger Helm Chart | https://github.com/jaegertracing/helm-charts |
| ArtifactHub Jaeger | https://artifacthub.io/packages/helm/jaegertracing/jaeger |
| Jaeger Deployment | https://www.jaegertracing.io/docs/latest/deployment/ |
| Jaeger + Elasticsearch | https://www.jaegertracing.io/docs/latest/deployment/#elasticsearch |
| Jaeger CLI Config | https://www.jaegertracing.io/docs/latest/cli/ |
| OpenTelemetry Node.js | https://opentelemetry.io/docs/languages/js/getting-started/nodejs/ |
| OTel Exporters | https://opentelemetry.io/docs/languages/js/exporters/ |
| Abhishek Day 6 | https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-6 |
