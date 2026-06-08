# Day 57 — Commands | EKS Cluster + kube-prometheus-stack Setup

## 📅 Date: 8 June 2026

---

## 🛠️ Prerequisites Setup

### Install AWS CLI
```bash
# Official: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
aws configure   # Enter: Access Key, Secret Key, Region, Output format
```

### Install eksctl
```bash
# Official: https://eksctl.io/installation/
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

### Install kubectl
```bash
# Official: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
  https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

### Install Helm
```bash
# Official: https://helm.sh/docs/intro/install/
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

## 📦 Step 1: Create EKS Cluster

```bash
# Official: https://eksctl.io/usage/creating-and-managing-clusters/

# Create cluster without nodegroup
eksctl create cluster --name=observability \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup

# Associate IAM OIDC provider
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster observability \
    --approve

# Create private nodegroup
eksctl create nodegroup --cluster=observability \
                        --region=us-east-1 \
                        --name=observability-ng-private \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=3 \
                        --node-volume-size=20 \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking

# Update kubeconfig
aws eks update-kubeconfig --name observability

# Verify cluster
kubectl get nodes
kubectl get ns
```

---

## 🧰 Step 2: Add Helm Repo

```bash
# Official: https://github.com/prometheus-community/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Verify repo added
helm repo list

# Search available charts
helm search repo prometheus-community
```

---

## 🚀 Step 3: Deploy kube-prometheus-stack

```bash
# Official: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

# Create namespace
kubectl create ns monitoring

# Deploy with custom values
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f ./custom_kube_prometheus_stack.yml

# Deploy without custom values (default)
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring
```

---

## ✅ Step 4: Verify Installation

```bash
# Check all resources in monitoring namespace
kubectl get all -n monitoring

# Check pods
kubectl get pods -n monitoring

# Check services
kubectl get svc -n monitoring

# Check Prometheus CRDs
kubectl get crd | grep monitoring
```

---

## 🌐 Step 5: Access UIs (Port Forwarding)

### Prometheus UI (port 9090)
```bash
# Official: https://prometheus.io/docs/prometheus/latest/getting_started/#using-the-expression-browser
kubectl port-forward service/prometheus-operated -n monitoring 9090:9090

# For EC2/Cloud VM — add --address flag
kubectl port-forward service/prometheus-operated -n monitoring 9090:9090 --address 0.0.0.0
# Access: http://<instance-ip>:9090
```

### Grafana UI (port 8080)
```bash
# Official: https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/
kubectl port-forward service/monitoring-grafana -n monitoring 8080:80

# For EC2/Cloud VM
kubectl port-forward service/monitoring-grafana -n monitoring 8080:80 --address 0.0.0.0
# Access: http://<instance-ip>:8080
# Default credentials: admin / prom-operator
```

### Alertmanager UI (port 9093)
```bash
# Official: https://prometheus.io/docs/alerting/latest/alertmanager/
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093

# For EC2/Cloud VM
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093 --address 0.0.0.0
# Access: http://<instance-ip>:9093
```

---

## 🔍 Useful Debug Commands

```bash
# Check Prometheus targets
# Go to: http://localhost:9090/targets

# Check Alertmanager status
# Go to: http://localhost:9093/#/status

# Get Grafana admin password
kubectl get secret monitoring-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode

# Describe a failing pod
kubectl describe pod <pod-name> -n monitoring

# Check pod logs
kubectl logs <pod-name> -n monitoring

# Check Prometheus config
kubectl get configmap -n monitoring | grep prometheus
kubectl get configmap prometheus-monitoring-kube-prometheus-prometheus-rulefiles-0 \
  -n monitoring -o yaml
```

---

## 🧼 Step 6: Cleanup

```bash
# Uninstall Helm chart
helm uninstall monitoring --namespace monitoring

# Delete namespace
kubectl delete ns monitoring

# Delete EKS cluster and all resources
eksctl delete cluster --name observability

# Verify deletion
kubectl get nodes   # Should show error (cluster gone)
```

---

## 📋 Quick Reference — All Service Ports

| Service | Port | Access |
|---------|------|--------|
| Prometheus | 9090 | http://localhost:9090 |
| Grafana | 3000 (internal) / 8080 (forwarded) | http://localhost:8080 |
| Alertmanager | 9093 | http://localhost:9093 |
| Node Exporter | 9100 | http://localhost:9100/metrics |
| kube-state-metrics | 8080 | http://localhost:8080/metrics |
| Pushgateway | 9091 | http://localhost:9091 |

---

## 📖 Official Documentation Links

| Command/Topic | Official Link |
|---------------|---------------|
| eksctl cluster | https://eksctl.io/usage/creating-and-managing-clusters/ |
| kubectl install | https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ |
| Helm install | https://helm.sh/docs/intro/install/ |
| kube-prometheus-stack | https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack |
| ArtifactHub chart | https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack |
| Port-forward docs | https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/ |
| Prometheus config | https://prometheus.io/docs/prometheus/latest/configuration/configuration/ |
| Alertmanager config | https://prometheus.io/docs/alerting/latest/configuration/ |
