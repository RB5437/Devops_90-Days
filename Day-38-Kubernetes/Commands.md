# ⚡ Day 38 — Kubernetes Commands 

---

## 🔧 KIND Installation

```bash
# install_kind.sh — run this script
#!/bin/bash
[ $(uname -m) = x86_64 ] && \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind

# kubectl install
VERSION="v1.30.0"
curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify
kind --version       # kind version 0.31.0
kubectl version --client
```

---

## 🐳 Docker Setup (required for KIND)

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

# Fix permission
sudo usermod -aG docker $USER && newgrp docker

# Verify
docker ps
docker --version     # Docker version 29.1.3
```

---

## ☸️ KIND Cluster — Create & Manage

```bash
# config.yml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.33.1
- role: worker
  image: kindest/node:v1.33.1
- role: worker
  image: kindest/node:v1.33.1
  extraPortMappings:
    - containerPort: 80
      hostPort: 80
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      protocol: TCP
YAML

# Create cluster
kind create cluster --name rbb-cluster --config=config.yml

# Verify
kubectl cluster-info --context kind-rbb-cluster
kubectl get nodes

# List all KIND clusters
kind get clusters

# Delete cluster
kind delete cluster --name rbb-cluster
```

---

## 🚗 Minikube Commands

```bash
# Install
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
minikube version

# Start / Stop / Delete
minikube start --driver=docker --vm=true
minikube status
minikube stop
minikube delete
```

---

## 🔄 kubectl Context Switching

```bash
# See all contexts (clusters)
kubectl config get-contexts

# Switch context
kubectl config use-context kind-rbb-cluster
kubectl config use-context minikube

# Current context
kubectl config current-context
```

---

## 📦 Namespace Commands

```bash
# List namespaces
kubectl get namespace
kubectl get ns                          # short form

# Create namespace
kubectl create ns nginx
kubectl create ns dev
kubectl create ns prod

# Delete namespace
kubectl delete ns nginx

# Get pods in specific namespace
kubectl get pods -n kube-system
kubectl get pods -n nginx
kubectl get pods -A                     # ALL namespaces
```

---

## 🫙 Pod Commands

```bash
# Run a pod (imperative)
kubectl run nginx --image=nginx
kubectl run nginx --image=nginx -n nginx        # in specific namespace
kubectl run myapp --image=python:3.9 --port=80

# Get pods
kubectl get pods                                # default namespace
kubectl get pods -n nginx                       # specific namespace
kubectl get pods -o wide                        # with IP + Node info
kubectl get pods -A                             # all namespaces
kubectl get pods --watch                        # live watch

# Pod details
kubectl describe pod nginx
kubectl describe pod nginx -n nginx

# Pod logs
kubectl logs nginx
kubectl logs nginx -f                           # follow logs
kubectl logs nginx -n nginx

# Execute into pod
kubectl exec -it nginx -- bash
kubectl exec -it nginx -n nginx -- sh

# Delete pod
kubectl delete pod nginx
kubectl delete pod nginx -n nginx

# Get pod YAML
kubectl get pod nginx -o yaml
```

---

## 📊 Cluster Info Commands

```bash
# Cluster info
kubectl cluster-info
kubectl cluster-info --context kind-rbb-cluster

# Nodes
kubectl get nodes
kubectl get nodes -o wide               # with IP info
kubectl describe node rbb-cluster-worker

# All resources
kubectl get all
kubectl get all -n kube-system

# API resources list
kubectl api-resources
```

---

## 🔍 kube-system Pods (Control Plane)

```bash
kubectl get pods -n kube-system

# You should see:
# coredns                    → DNS for pods
# etcd                       → cluster database
# kube-apiserver             → API server
# kube-controller-manager    → controller manager
# kube-proxy                 → network proxy on each node
# kube-scheduler             → pod scheduler
# kindnet                    → KIND's CNI plugin
```

---

## 📝 YAML Practice

```bash
# Create pod from YAML
cat > pod.yaml << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  namespace: default
  labels:
    app: myapp
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
YAML

kubectl apply -f pod.yaml
kubectl get pods
kubectl describe pod my-pod
kubectl delete -f pod.yaml
```

---

## 🚨 Common Errors & Fixes

```bash
# Error: permission denied docker.sock
sudo usermod -aG docker $USER && newgrp docker

# Error: kubectl connection refused
# Make sure cluster is running
kind get clusters
kubectl config use-context kind-rbb-cluster

# Error: YAML indentation
# Never use TABS in YAML — always SPACES!

# Error: image not found
# Check available KIND node images at:
# https://hub.docker.com/r/kindest/node/tags
```

---

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
