# ⌨️ Day 46 — Deployment Strategies Commands

## KIND Cluster Setup
```bash
chmod 700 install.sh && ./install.sh
kind create cluster --name rbb-kind-cluster --config=kind-config.yml
kubectl get nodes
kubectl cluster-info --context kind-rbb-kind-cluster
```

## ♻️ Recreate Strategy
```bash
kubectl apply -f recreate-namespace.yml
kubectl apply -f recreate-deployment.yml          # strategy: Recreate
kubectl get pods -n recreate-ns                   # 3/3 Running
kubectl apply -f recreate-svc.yml
kubectl get all -n recreate-ns

# Port forward
kubectl port-forward --address 0.0.0.0 svc/recreate-service 3000:3000 -n recreate-ns &

# Update image — ALL pods killed at once
kubectl set image deployment/online-shop online-shop=amitabhdevops/online_shop_without_footer -n recreate-ns
watch kubectl get pods -n recreate-ns             # see all pods die then restart
```

## 🔄 Rolling Update Strategy
```bash
kubectl apply -f rolling-namespace.yml
kubectl apply -f rolling-update-deployment.yaml   # maxSurge:1, maxUnavailable:0
kubectl get pods -n rolling-ns
kubectl apply -f rolling-update-svc.yml
kubectl get all -n rolling-ns

# Port forward
kubectl port-forward --address 0.0.0.0 svc/rolling-update-service 3000:3000 -n rolling-ns &

# Update image — rolling (one by one)
kubectl apply -f rolling-update-deployment.yaml   # change image tag first
watch kubectl get pods -n rolling-ns

# Rollback
kubectl rollout undo deploy/online-shop -n rolling-ns
kubectl rollout history deploy/online-shop -n rolling-ns
kubectl rollout status deploy/online-shop -n rolling-ns
```

## 🔵🟢 Blue-Green Strategy
```bash
kubectl apply -f blue-green-ns.yml

# Deploy Blue (v1 - without footer)
kubectl apply -f online-shop-without-footer-blue-deployment.yaml
kubectl get all -n blue-green-ns

# Port forward Blue
kubectl port-forward --address 0.0.0.0 svc/online-shop-blue-deployment-service 30001:3001 -n blue-green-ns &

# Deploy Green (v2 - with footer)
kubectl apply -f online-shop-green-deployment.yaml
kubectl get all -n blue-green-ns                  # 8 pods total

# Port forward Green
kubectl port-forward --address 0.0.0.0 svc/online-shop-green-deployment-service 30000:3000 -n blue-green-ns &

# Switch traffic (patch service selector)
kubectl patch svc online-shop-blue-deployment-service -n blue-green-ns \
  -p '{"spec":{"selector":{"app":"online-shop-green"}}}'
```

## 🐤 Canary Strategy
```bash
# Install Ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/kind/deploy.yaml

# Fix: remove nodeSelector (KIND needs this)
kubectl patch deployment ingress-nginx-controller -n ingress-nginx --type=json \
  -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector"}]'
kubectl get pods -n ingress-nginx

# Create namespace
kubectl apply -f namespace.yaml

# Apply ConfigMaps
kubectl apply -f nginx-configmap.yaml             # v1 content
kubectl apply -f apache-configmap.yaml            # v2 content

# Deploy stable (v1) + canary (v2)
kubectl apply -f nginx-deployment.yaml            # 4 replicas = 80%
kubectl apply -f apache-deployment.yaml           # 1 replica  = 20%
kubectl get pods -n simple-canary                 # 5 pods total

# Service + Ingress
kubectl apply -f canary-service.yaml
kubectl apply -f ingress.yaml
kubectl get ingress -n simple-canary

# Port forward ingress
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80 --address 0.0.0.0 &

# Scale canary up / stable down
kubectl scale deployment apache-deployment -n simple-canary --replicas=2   # 30%
kubectl scale deployment nginx-deployment  -n simple-canary --replicas=3   # 70%

# Full cutover to v2
kubectl scale deployment nginx-deployment  -n simple-canary --replicas=0
kubectl scale deployment apache-deployment -n simple-canary --replicas=5

# Rollback (remove canary)
kubectl scale deployment apache-deployment -n simple-canary --replicas=0
kubectl scale deployment nginx-deployment  -n simple-canary --replicas=5
```
