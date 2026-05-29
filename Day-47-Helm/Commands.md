# ⌨️ Day 47 — Helm Commands

## Setup — Docker + KIND + kubectl + Helm
```bash
# Docker
sudo apt update && sudo apt install docker.io -y
sudo systemctl enable docker
sudo usermod -aG docker $USER && newgrp docker
docker --version    # Docker version 29.1.3 ✅

# KIND + kubectl
chmod 700 install_kind.sh && ./install_kind.sh
kind version        # kind version 0.31.0 ✅
kubectl version --client  # v1.36.1 ✅

# Helm v3.20.0
chmod 700 helm_install.sh && ./helm_install.sh
helm version        # v3.20.0 ✅
```

## KIND Cluster
```bash
kind create cluster --name rbb-helm-cluster --config=config.yml
kubectl get nodes   # control-plane + worker ✅
docker ps           # 2 kindest/node containers ✅
```

## Helm Repo Management
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add eks https://aws.github.io/eks-charts
helm repo list                          # bitnami + eks ✅
helm repo update eks
helm search repo bitnami                # 140+ charts
helm search repo bitnami | grep nginx
helm search repo bitnami | grep prometheus
helm search repo bitnami | grep elastic
helm search repo eks | grep load        # aws-load-balancer-controller
```

## Install Public Charts
```bash
# Install NGINX from bitnami
helm install nginxv1 bitnami/nginx
kubectl get pods    # nginxv1-77dcdb5d4b-4sqp7 Running ✅

# Install Prometheus from bitnami
helm install prometheus bitnami/prometheus
# STATUS: deployed, REVISION: 1 ✅

# Uninstall
helm uninstall nginxv1
kubectl get pods    # No resources found ✅

# List all releases
helm list
helm repo list
```

## Create Custom Helm Chart
```bash
mkdir -p Helm/ && cd Helm/
mkdir -p best-commerce/{payments,shipping}
cd best-commerce/

# Create charts
helm create payments   # Creates full chart structure ✅
helm create shipping   # Creates full chart structure ✅

ls payments/
# Chart.yaml  charts/  templates/  values.yaml

ls payments/templates/
# NOTES.txt  _helpers.tpl  deployment.yaml  hpa.yaml
# httproute.yaml  ingress.yaml  service.yaml  serviceaccount.yaml  tests/
```

## Edit Chart Files
```bash
# Edit deployment.yaml (Go templating)
vim payments/templates/deployment.yaml
# name: {{ .Release.Name }}-{{ .Chart.Name }}
# image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
# command: echo {{ .Values.appMessage }}

# Edit values.yaml
vim payments/values.yaml
# image.repository: busybox
# image.tag: latest
# appMessage: "Payments Service"

vim shipping/values.yaml
# appMessage: "Shipping Service"
```

## Package + Repo Index
```bash
helm package shipping/   # → shipping-0.1.0.tgz ✅
helm package payments/   # → payments-0.1.0.tgz ✅
ls                       # payments/ payments-0.1.0.tgz shipping/ shipping-0.1.0.tgz

helm repo index .        # → index.yaml (your own Helm repo!)
cat index.yaml           # entries: payments + shipping ✅
```

## Helm Override at Install
```bash
# Override single value
helm install my-payments payments/ --set appMessage="Hello from CLI"

# Override with custom values file
helm install my-payments payments/ -f prod-values.yaml

# Upgrade existing release
helm upgrade my-payments payments/ --set image.tag=v2

# Rollback
helm rollback my-payments 1    # back to revision 1

# History
helm history my-payments

# Dry run (test without installing)
helm install my-payments payments/ --dry-run
helm template my-payments payments/   # render templates locally
```

## AWS Load Balancer Controller (EKS production)
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0
```
