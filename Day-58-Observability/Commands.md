# Day 58 — Commands | Prometheus + PromQL + Node Exporter + kube-state-metrics

## 📅 Date: 9 June 2026

---

## 📦 Helm — kube-prometheus-stack Deploy

```bash
# Add Helm repo
# Official: https://github.com/prometheus-community/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace
kubectl create ns monitoring

# Deploy with custom config
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f ./custom_kube_prometheus_stack.yml

# Verify all pods running
kubectl get all -n monitoring

# Watch pods come up
kubectl get pods -n monitoring -w
```

---

## ✅ Verify Installation

```bash
# All pods status
kubectl get pods -n monitoring

# All services
kubectl get svc -n monitoring

# Check Prometheus StatefulSet
kubectl get statefulset -n monitoring

# Check Node Exporter DaemonSet (should be 3/3)
kubectl get daemonset -n monitoring

# Check Alertmanager HA (2/2)
kubectl get statefulset alertmanager-monitoring-kube-prometheus-alertmanager -n monitoring
```

---

## 🌐 Port Forwarding (Access UIs)

```bash
# Official: https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/

# Grafana (background)
kubectl port-forward svc/monitoring-grafana -n monitoring 8080:80 --address 0.0.0.0 &
# Access: http://<vm-ip>:8080  |  admin / prom-operator

# Prometheus (background)
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 --address 0.0.0.0 &
# Access: http://<vm-ip>:9090

# Alertmanager (background)
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093 --address 0.0.0.0 &
# Access: http://<vm-ip>:9093

# Check running background jobs
jobs

# Kill port-forwards when done
kill %1 %2 %3
```

---

## 🔍 Verify Node Exporter + kube-state-metrics

```bash
# Enter a worker node container (kind cluster)
docker exec -it rbb-kind-cluster-worker bash

# Verify Node Exporter metrics (port 9100)
# Official: https://github.com/prometheus/node_exporter
curl 10.96.174.83:9100/metrics
# Shows: node_cpu_seconds_total, node_memory_MemTotal_bytes, node_load1...

# Verify kube-state-metrics (port 8080)
# Official: https://github.com/kubernetes/kube-state-metrics
curl 10.96.138.2:8080/metrics
# Shows: kube_pod_container_status_ready, kube_pod_status_phase...

# Filter for container metrics
curl 10.96.138.2:8080/metrics | grep container

# Exit container
exit
```

---

## 📊 PromQL Queries — Run in Prometheus UI (9090)

```promql
# Official: https://prometheus.io/docs/prometheus/latest/querying/examples/

# CPU usage rate per node
rate(node_cpu_seconds_total{mode!="idle"}[5m])

# Total CPU usage
sum(rate(node_cpu_seconds_total{mode!="idle"}[5m]))

# Memory available on nodes
node_memory_MemAvailable_bytes

# Memory usage %
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

# Load average
node_load1
node_load5
node_load15

# Pod restart count
kube_pod_container_status_restarts_total{namespace="monitoring"}

# Pod status (1=running)
kube_pod_status_phase{phase="Running"}

# Node Exporter — disk available
node_filesystem_avail_bytes

# 95th percentile API latency
histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (le))

# Container CPU usage rate
rate(container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}[5m])
```

---

## 🔧 Debug Commands

```bash
# Describe a pod if it's not starting
kubectl describe pod monitoring-grafana-5fbdcdf6c4-qlm7k -n monitoring

# Check pod logs
kubectl logs monitoring-grafana-5fbdcdf6c4-qlm7k -n monitoring -c grafana

# Get Grafana admin password
kubectl get secret monitoring-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode

# Check Prometheus config
kubectl get configmap -n monitoring | grep prometheus

# Check all CRDs installed
kubectl get crd | grep monitoring.coreos.com

# Get service IPs (for curl testing)
kubectl get svc -n monitoring
```

---

## 🧼 Cleanup

```bash
# Uninstall helm chart
helm uninstall monitoring --namespace monitoring

# Delete namespace
kubectl delete ns monitoring

# Kill all port-forwards
kill $(jobs -p)
```

---

## 📋 Service Port Reference

| Service | ClusterIP | Port | Access |
|---------|-----------|------|--------|
| Prometheus | 10.96.111.226 | 9090 | Port-forward → 9090 |
| Grafana | 10.96.157.24 | 80 | Port-forward → 8080 |
| Alertmanager | 10.96.87.246 | 9093 | Port-forward → 9093 |
| Node Exporter | 10.96.174.83 | 9100 | curl internal |
| kube-state-metrics | 10.96.138.2 | 8080 | curl internal |

---

## 📖 Official Docs Links

| Command/Topic | Official Link |
|---------------|---------------|
| kube-prometheus-stack | https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack |
| PromQL Basics | https://prometheus.io/docs/prometheus/latest/querying/basics/ |
| PromQL Functions | https://prometheus.io/docs/prometheus/latest/querying/functions/ |
| PromQL Examples | https://prometheus.io/docs/prometheus/latest/querying/examples/ |
| Node Exporter | https://github.com/prometheus/node_exporter |
| kube-state-metrics | https://github.com/kubernetes/kube-state-metrics |
| Alertmanager Config | https://prometheus.io/docs/alerting/latest/configuration/ |
| Port-forward Docs | https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/ |
