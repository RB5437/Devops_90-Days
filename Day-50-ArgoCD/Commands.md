# ⌨️ Day 50 — ArgoCD Commands

## Setup (New EC2)
```bash
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
kind create cluster --name argocd-cluster --config kind-config.yml
# Fix: v1.31.7 not found → use v1.33.1 ✅
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &
argocd login 3.88.41.67:8080 --username admin --password admin@123 --insecure
argocd cluster add kind-argocd-cluster --name argocd-cluster --insecure
```

## Notifications — Email Setup
```bash
mkdir ~/notification && cd ~/notification

# Install notifications catalog
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/notifications_catalog/install.yaml

# Create secret (Gmail SMTP)
kubectl apply -f secret.yml -n argocd
# secret.yml has: email-username + email-password (app password)

# Apply ConfigMap (templates + triggers + SMTP)
kubectl apply -f configmap-email.yml   # service.email + templates + triggers

# Deploy app with notification annotations
kubectl apply -f chai-app.yaml -n argocd
kubectl get applications -n argocd
# chai-app   Synced   Healthy ✅ → email received!
```

## Image Updater — Setup
```bash
# Install Image Updater
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/config/install.yaml

kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-image-updater
# argocd-image-updater-controller Running ✅

# Docker — tag + push your image
docker login
docker pull amitabhdevops/chai-devops:latest
docker tag amitabhdevops/chai-devops:latest ritik2909/chai-devops:v1.0.0
docker push ritik2909/chai-devops:v1.0.0

docker tag ritik2909/chai-devops:v1.0.0 ritik2909/chai-devops:v1.0.1
docker push ritik2909/chai-devops:v1.0.1

# Create Git secret for write-back
kubectl apply -f secret-image-updater-git.yaml -n argocd

# Deploy app with image-updater annotations
kubectl apply -f chai-app.yaml -n argocd
```

## Image Updater — ImageUpdater CRD
```bash
# Create ImageUpdater resource
vi image-updater.yml
# apiVersion: argocd-image-updater.argoproj.io/v1alpha1
# kind: ImageUpdater
# metadata:
#   name: chai-app-updater
#   namespace: argocd
# spec:
#   applicationRefs:
#     - namePattern: "chai-app"
#       useAnnotations: true

kubectl apply -f image-updater.yml

# Watch logs for image update
kubectl logs -n argocd deploy/argocd-image-updater-controller --tail=50
# "Setting new image to ritik2909/chai-devops:v1.0.4" ✅
# "Successfully updated the live application spec" ✅
# "git push origin main" ← writes back to Git! ✅

# Verify image updated
kubectl get deployment chai-app -n default \
  -o jsonpath='{.spec.template.spec.containers[0].image}'
# ritik2909/chai-devops:v1.0.4 ✅

# Fix: ImagePullBackOff on new tag
docker tag ritik2909/chai-devops:v1.0.1 ritik2909/chai-devops:v1.0.3
docker push ritik2909/chai-devops:v1.0.3
kubectl rollout restart deployment chai-app -n default
kubectl get pods -n default -w   # 3 pods Running ✅
```

## Prometheus + Grafana Monitoring
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack -n monitoring

# Apply ArgoCD ServiceMonitors
kubectl apply -f argocd-service-monitors.yaml

# Check monitoring pods
kubectl get pods -n monitoring
```

## Useful Debug Commands
```bash
kubectl get pods -n argocd
kubectl get crds | grep imageupdater
kubectl api-resources | grep -i image
kubectl explain imageupdaters
kubectl explain imageupdaters.spec
kubectl get imageupdaters -A
kubectl get applications -n argocd
```
