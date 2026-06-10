# Day 59 — Commands | Custom Metrics + Alertmanager + EFK Stack

## 📅 Date: 10 June 2026

---

## 🚀 Part 1 — Deploy Node.js App (Custom Metrics)

```bash
# Official: https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-4

# Clone repo
git clone https://github.com/iam-veeramalla/observability-zero-to-hero
cd observability-zero-to-hero/day-4

# Option 1 — Use pre-built images (faster)
# abhishekf5/demoservice-a:v
# abhishekf5/demoservice-b:v

# Option 2 — Build your own
docker build -t <YOUR_REPO>/service-a:v1 application/service-a/
docker build -t <YOUR_REPO>/service-b:v1 application/service-b/
docker push <YOUR_REPO>/service-a:v1
docker push <YOUR_REPO>/service-b:v1

# Create dev namespace + deploy
kubectl create ns dev
kubectl apply -k kubernetes-manifest/

# Verify pods running
kubectl get pods -n dev
kubectl get svc -n dev
```

---

## 📊 Part 2 — ServiceMonitor + Prometheus Rules + Alertmanager

```bash
# Official: https://prometheus-operator.dev/docs/developer/api-reference/

# Step 1 — Create Gmail App Password secret
# Go to: Google Account → Security → App Passwords → Create password
# Put the password in email-secrets.yml

# Step 2 — Update email in alertmanagerconfig.yml
# Replace YOUR_EMAIL_ID with your actual email

# Step 3 — Apply all alert + monitoring configs
kubectl apply -k alerts-alertmanager-servicemonitor-manifest/

# Verify ServiceMonitor created
kubectl get servicemonitor -n monitoring

# Verify PrometheusRule created
kubectl get prometheusrule -n monitoring

# Verify AlertmanagerConfig created
kubectl get alertmanagerconfig -n monitoring

# Check Prometheus UI → Status → Targets
# Should show: a-service-service-monitor target ✅

# Check Prometheus UI → Alerts
# Should show: HighCpuUsage + PodRestart rules
```

---

## 🔍 Part 3 — Test Custom Metrics + Trigger Alerts

```bash
# Get LoadBalancer URL (EKS)
kubectl get svc -n dev

# Test all endpoints (replace with your LB URL)
LBURL="http://YOUR_LB_DNS"

curl $LBURL/              # Returns "Running"
curl $LBURL/healthy       # Health check
curl $LBURL/metrics       # Prometheus metrics endpoint
curl $LBURL/logs          # Generate logs
curl $LBURL/example       # Gauge metric demo
curl $LBURL/serverError   # 500 error (increments counter with status=500)
curl $LBURL/notFound      # 404 error
curl $LBURL/call-service-b  # Service-to-service call

# Run automated load test
./test.sh $LBURL

# Trigger PodRestart alert (crash container 3+ times)
curl $LBURL/crash
curl $LBURL/crash
curl $LBURL/crash
# → Should receive email after 3rd crash!
```

---

## 📊 Part 4 — PromQL for Custom Metrics

```promql
# Official: https://prometheus.io/docs/prometheus/latest/querying/examples/

# Total HTTP requests
http_requests_total

# Request rate per second (last 5 min)
rate(http_requests_total[5m])

# Request rate by path
rate(http_requests_total[5m]) by (path)

# Error rate (5xx only)
rate(http_requests_total{status_code=~"5.."}[5m])

# 95th percentile response time
histogram_quantile(0.95,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)

# P99 response time
histogram_quantile(0.99,
  rate(http_request_duration_seconds_bucket[5m])
)

# Gauge — current async task duration
node_gauge_example

# Pod restart count (triggers alert if > 2)
kube_pod_container_status_restarts_total{namespace="dev"}
```

---

## 📝 Part 5 — EFK Stack Setup (EKS)

```bash
# Official Elasticsearch Helm: https://helm.elastic.co
# Official Fluentbit Helm: https://fluent.github.io/helm-charts

# Step 1 — EBS CSI Driver (needed for Elasticsearch PVC)
eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster observability \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

ARN=$(aws iam get-role --role-name AmazonEKS_EBS_CSI_DriverRole --query 'Role.Arn' --output text)

eksctl create addon --cluster observability --name aws-ebs-csi-driver \
    --version latest --service-account-role-arn $ARN --force

# Step 2 — Create logging namespace
kubectl create namespace logging

# Step 3 — Install Elasticsearch
helm repo add elastic https://helm.elastic.co
helm install elasticsearch \
    --set replicas=1 \
    --set volumeClaimTemplate.storageClassName=gp2 \
    --set persistence.labels.enabled=true \
    elastic/elasticsearch -n logging

# Step 4 — Get Elasticsearch credentials
kubectl get secrets --namespace=logging elasticsearch-master-credentials \
    -ojsonpath='{.data.username}' | base64 -d
echo ""
kubectl get secrets --namespace=logging elasticsearch-master-credentials \
    -ojsonpath='{.data.password}' | base64 -d

# Step 5 — Install Kibana (LoadBalancer)
helm install kibana --set service.type=LoadBalancer elastic/kibana -n logging

# Step 6 — Update fluentbit-values.yaml with ES password
# Edit: HTTP_Passwd field with password from step 4

# Step 7 — Install Fluentbit
helm repo add fluent https://fluent.github.io/helm-charts
helm install fluent-bit fluent/fluent-bit -f fluentbit-values.yaml -n logging

# Step 8 — Verify all logging pods
kubectl get pods -n logging

# Step 9 — Get Kibana URL
kubectl get svc -n logging
# Access: http://KIBANA_LB_DNS:5601
```

---

## 🧼 Cleanup

```bash
helm uninstall monitoring -n monitoring
helm uninstall fluent-bit -n logging
helm uninstall elasticsearch -n logging
helm uninstall kibana -n logging

cd day-4
kubectl delete -k kubernetes-manifest/
kubectl delete -k alerts-alertmanager-servicemonitor-manifest/

eksctl delete cluster --name observability
```

---

## 📖 Official Docs Links

| Command/Topic | Official Link |
|---------------|---------------|
| prom-client library | https://github.com/siimon/prom-client |
| Metric Types | https://prometheus.io/docs/concepts/metric_types/ |
| Histogram vs Summary | https://prometheus.io/docs/practices/histograms/ |
| ServiceMonitor | https://prometheus-operator.dev/docs/developer/api-reference/ |
| PrometheusRule | https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1.PrometheusRule |
| AlertmanagerConfig | https://prometheus-operator.dev/docs/developer/api-reference/#monitoring.coreos.com/v1alpha1.AlertmanagerConfig |
| Alertmanager Email Config | https://prometheus.io/docs/alerting/latest/configuration/#email_config |
| Elasticsearch Helm | https://github.com/elastic/helm-charts/tree/main/elasticsearch |
| Fluentbit K8s | https://docs.fluentbit.io/manual/installation/kubernetes |
| Kibana Docs | https://www.elastic.co/guide/en/kibana/current/index.html |
| Abhishek Day 4 | https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-4 |
| Abhishek Day 5 | https://github.com/iam-veeramalla/observability-zero-to-hero/tree/main/day-5 |
