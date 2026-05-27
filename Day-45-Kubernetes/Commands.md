# ⌨️ Day 45 — Kubernetes Final Revision Commands

## KIND Cluster Setup
```bash
# Install KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# Create cluster
kind create cluster --name rbb-cluster --config=config.yml
kubectl get nodes

# List / Delete clusters
kind get clusters
kind delete cluster --name rbb-cluster
```

## Init Container
```bash
kubectl apply -f init-container.yml
kubectl get pods                            # Init:0/1 → Running
kubectl logs init-test -c init-container   # init logs
kubectl logs init-test -c main-container   # main logs
kubectl describe pod init-test             # events
kubectl delete pod init-test
```

## Sidecar Container
```bash
kubectl apply -f sidecar-container.yml
kubectl get pods                                         # 2/2 Running ✅
kubectl logs sidecar-test -c main-container             # app logs
kubectl logs sidecar-test -c sidecar-container          # sidecar logs
kubectl logs sidecar-test -c sidecar-container -f       # live stream
kubectl exec -it sidecar-test -c main-container -- sh   # exec into main
kubectl delete pod sidecar-test
```

## Istio Service Mesh
```bash
# Download + Install
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.30.0/
sudo mv bin/istioctl /usr/local/bin/
istioctl version
istioctl x precheck

# Install Istio
istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y
kubectl get pods -n istio-system              # istiod Running ✅

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection      # default istio-injection=enabled

# Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.5.1" | kubectl apply -f -; }

# Deploy Bookinfo app
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get services
kubectl get pods                              # Each pod: 2/2 (app + envoy)

# Test app
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
# Output: <title>Simple Bookstore App</title> ✅

# Gateway
kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
kubectl get gateway && kubectl get httproute
kubectl port-forward svc/bookinfo-gateway-istio 8080:80 --address=0.0.0.0

# Status check
istioctl proxy-status
istioctl analyze
```

## General kubectl Revision Commands
```bash
# Pods
kubectl get pods -A                    # all namespaces
kubectl describe pod <name>
kubectl logs <pod> -c <container>
kubectl exec -it <pod> -- bash

# Deployments
kubectl get deploy
kubectl rollout status deploy/<name>
kubectl rollout undo deploy/<name>
kubectl scale deploy <name> --replicas=3

# Services
kubectl get svc
kubectl port-forward svc/<name> 8080:80

# ConfigMap + Secret
kubectl get cm && kubectl get secrets
kubectl describe cm <name>

# HPA + VPA
kubectl get hpa
kubectl get vpa

# RBAC
kubectl get sa,role,rolebinding -n default
kubectl auth can-i get pods --as=system:serviceaccount:<ns>:<sa>

# Helm
helm list
helm install <name> <chart>
helm upgrade <name> <chart>
helm rollback <name>
helm uninstall <name>
```
