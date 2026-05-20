# ☸️ Day 38 — Kubernetes: Core Concepts, Architecture & Cluster Setup

**Date:** 20 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Monolithic vs Microservices | ✅ Done |
| 2 | Kubernetes Architecture | ✅ Done |
| 3 | KIND Cluster Setup on AWS EC2 | ✅ Done |
| 4 | Minikube Setup on AWS EC2 | ✅ Done |
| 5 | kubectl — core commands | ✅ Done |
| 6 | Pods — create, run, delete | ✅ Done |
| 7 | Namespaces — create, list, use | ✅ Done |
| 8 | YAML basics (demo.yml) | ✅ Done |

---

## 📌 Monolithic vs Microservices

| Monolithic | Microservices |
|-----------|---------------|
| One big application | Many small services |
| Scale whole app | Scale individual service |
| One failure = full down | Failure isolated |
| Hard to update | Easy to update one service |
| Example: Old-school app | Example: Netflix, Amazon |

**Kubernetes manages microservices** — each service runs in its own container/pod!

---

## 📌 Kubernetes Architecture

```
┌─────────────────────────────────────┐
│         CONTROL PLANE (Master)       │
│                                      │
│  ┌──────────┐  ┌──────────────────┐  │
│  │ API      │  │      etcd        │  │
│  │ Server   │  │  (cluster DB)    │  │
│  └──────────┘  └──────────────────┘  │
│  ┌──────────┐  ┌──────────────────┐  │
│  │Scheduler │  │Controller Manager│  │
│  └──────────┘  └──────────────────┘  │
└─────────────────────────────────────┘
           │ manages
┌──────────┴──────────────────────────┐
│           WORKER NODES               │
│  ┌────────┐ ┌──────────┐ ┌───────┐  │
│  │kubelet │ │kube-proxy│ │Docker │  │
│  └────────┘ └──────────┘ └───────┘  │
│  ┌──────────────────────────────┐    │
│  │  Pod  [ Container ]          │    │
│  └──────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Control Plane Components:
| Component | Role | Analogy |
|-----------|------|---------|
| API Server | Entry point — kubectl talks here | Front desk |
| etcd | Stores ALL cluster state | Database |
| Scheduler | Decides which node runs which pod | Event planner |
| Controller Manager | Maintains desired state | Robots watching cluster |

### Worker Node Components:
| Component | Role | Analogy |
|-----------|------|---------|
| kubelet | Node agent — ensures pods running | Node manager |
| kube-proxy | Network routing rules | Traffic cop |
| Container Runtime | Runs containers (Docker/containerd) | Engine |

---

## 📌 Cluster Setup — KIND (Kubernetes IN Docker)

### What is KIND?
- Runs Kubernetes cluster INSIDE Docker containers
- Perfect for local development + AWS EC2
- No VM required — uses Docker as nodes

### install_kind.sh
```bash
#!/bin/bash
[ $(uname -m) = x86_64 ] && \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64

chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind

# kubectl install
VERSION="v1.30.0"
URL="https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
curl -LO "$URL"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
echo "kind & kubectl installation complete."
```

### KIND config.yml — 1 Master + 2 Workers
```yaml
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
```

### Cluster Created Successfully!
```bash
kind create cluster --name rbb-cluster --config=config.yml

# Output:
# ✓ Ensuring node image (kindest/node:v1.33.1)
# ✓ Preparing nodes
# ✓ Writing configuration
# ✓ Starting control-plane
# ✓ Installing CNI
# ✓ Installing StorageClass
# ✓ Joining worker nodes
# Set kubectl context to "kind-rbb-cluster"

kubectl get nodes
# NAME                        STATUS   ROLES           AGE   VERSION
# rbb-cluster-control-plane   Ready    control-plane   95s   v1.33.1
# rbb-cluster-worker          Ready    <none>          82s   v1.33.1
# rbb-cluster-worker2         Ready    <none>          82s   v1.33.1
```

---

## 📌 Minikube Setup

```bash
# Install
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Start
minikube start --driver=docker --vm=true

# Result:
# minikube   Ready    control-plane   v1.35.1
```

> **Note:** Minikube deleted after practice — switched back to KIND cluster (rbb-cluster)

---

## 📌 Namespaces + Pods Practice

```bash
# Namespaces
kubectl get namespace          # list all namespaces
kubectl create ns nginx        # create nginx namespace
kubectl get ns                 # short form

# Default namespaces:
# default, kube-system, kube-public, kube-node-lease, local-path-storage

# Pods
kubectl run nginx --image=nginx           # run in default namespace
kubectl get pods                           # Running ✅
kubectl delete pod nginx                   # delete

kubectl run nginx --image=nginx -n nginx   # run in nginx namespace
kubectl get pods -n nginx                  # Running ✅

# kube-system pods — all control plane components running!
kubectl get pods -n kube-system
# coredns, etcd, kube-apiserver, kube-controller-manager,
# kube-proxy, kube-scheduler — all Running ✅
```

---

## 📊 KIND vs Minikube vs Kubeadm

| Tool | Use Case | Nodes | Best For |
|------|----------|-------|---------|
| KIND | Local dev, CI/CD | Multi-node possible | AWS EC2, testing |
| Minikube | Local dev | Single node | Laptop/local |
| Kubeadm | Production-like | Multi-node real VMs | Real clusters |

---

## 📊 Kubernetes Series Progress

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 38 | 20 May | Core Concepts + Architecture + KIND + Minikube | ✅ Done |
| Day 39 | 21 May | Workloads — Deployments, ReplicaSets, StatefulSets | ⬜ |
| Day 40 | 22 May | Networking — Services, Ingress | ⬜ |
| Day 41 | 23 May | Storage — PV, PVC, ConfigMaps, Secrets | ⬜ |
| Day 42 | 24 May | Scaling — HPA, VPA, Taints, Probes | ⬜ |
| Day 43 | 25 May | RBAC + Security + Monitoring | ⬜ |
| Day 44 | 26 May | Advanced + Helm + Debugging | ⬜ |
| Day 45 | 27 May | Projects — Jenkins + ArgoCD + MongoDB | ⬜ |

---

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
