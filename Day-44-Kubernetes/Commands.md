# ⌨️ Day 44 — Commands Reference

## Cluster Setup
```bash
# Docker install (fresh EC2)
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl enable docker && sudo systemctl start docker
sudo usermod -aG docker $USER && newgrp docker
docker --version

# KIND cluster
kind create cluster --name rbb-cluster --config=config.yml
kubectl get nodes
```

## Init Container
```bash
kubectl apply -f init-container.yml
kubectl get pods
# Status: Init:0/1 → Running → Completed

kubectl logs init-test -c init-container    # init logs
kubectl logs init-test -c main-container    # main logs
kubectl describe pod init-test              # see init events
kubectl delete pod init-test
```

## Sidecar Container
```bash
kubectl apply -f sidecar-container.yml
kubectl get pods
# sidecar-test   2/2   Running  ← 2 containers!

kubectl logs sidecar-test -c main-container      # app logs
kubectl logs sidecar-test -c sidecar-container   # sidecar reading logs
kubectl logs sidecar-test -c sidecar-container -f  # live stream

kubectl exec -it sidecar-test -c main-container -- sh
kubectl delete pod sidecar-test
```

## Istio Install
```bash
# Step 1 — New cluster for Istio
kind create cluster --name istio-testing
kubectl cluster-info --context kind-istio-testing

# Step 2 — Download Istio
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.30.0/

# Step 3 — Install istioctl
sudo mv bin/istioctl /usr/local/bin/
istioctl version
istioctl x precheck   # pre-install checks

# Step 4 — Install Istio
istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y
kubectl get pods -n istio-system   # istiod Running ✅

# Step 5 — Enable sidecar injection
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection

# Step 6 — Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.5.1" | kubectl apply -f -; }
```

## Istio Bookinfo App
```bash
# Deploy
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get services
kubectl get pods
# Each pod should show 2/2 (app + envoy sidecar)

# Test
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
# Output: <title>Simple Bookstore App</title> ✅

# Gateway
kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
kubectl get gateway
kubectl get httproute

# Access
kubectl port-forward svc/bookinfo-gateway-istio 8080:80 --address=0.0.0.0
# http://<EC2-IP>:8080/productpage

# Istio status
istioctl proxy-status
istioctl analyze
```

## Cleanup
```bash
# Delete KIND clusters
kind delete cluster --name rbb-cluster
kind delete cluster --name istio-testing

# List all clusters
kind get clusters
```
