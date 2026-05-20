# ☸️ KIND Cluster Setup Guide

**Tool:** KIND (Kubernetes IN Docker) | **Date:** 20 May 2026

---

## 📋 Prerequisites

- AWS EC2 instance (t2.medium or higher)
- Docker installed and running
- sudo privileges

---

## 🔧 Step 1 — Install KIND and kubectl

```bash
#!/bin/bash
# install_kind.sh

[ $(uname -m) = x86_64 ] && \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64

chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind

# Install kubectl
VERSION="v1.30.0"
URL="https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
INSTALL_DIR="/usr/local/bin"

curl -LO "$URL"
chmod +x kubectl
sudo mv kubectl $INSTALL_DIR/

# Verify
kind --version
kubectl version --client

echo "kind & kubectl installation complete."
```

```bash
# Run the script
chmod +x install_kind.sh
./install_kind.sh
```

---

## ☸️ Step 2 — Create KIND Cluster Config

Create `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4

nodes:
  - role: control-plane
    image: kindest/node:v1.35.1

  - role: worker
    image: kindest/node:v1.35.1

  - role: worker
    image: kindest/node:v1.35.1
```

> **Note:** If `v1.35.1` not available, use `v1.33.1`
> Check available tags: https://hub.docker.com/r/kindest/node/tags

---

## 🚀 Step 3 — Create the Cluster

```bash
# Create cluster
kind create cluster --config kind-config.yaml --name tws-kind-cluster

# Expected output:
# ✓ Ensuring node image (kindest/node:v1.35.1)
# ✓ Preparing nodes
# ✓ Writing configuration
# ✓ Starting control-plane
# ✓ Installing CNI
# ✓ Installing StorageClass
# ✓ Joining worker nodes
# Set kubectl context to "kind-tws-kind-cluster"
```

---

## ✅ Step 4 — Verify Cluster

```bash
# Check nodes
kubectl get nodes

# Expected output:
# NAME                           STATUS   ROLES           AGE   VERSION
# tws-kind-cluster-control-plane Ready    control-plane   95s   v1.35.1
# tws-kind-cluster-worker        Ready    <none>          82s   v1.35.1
# tws-kind-cluster-worker2       Ready    <none>          82s   v1.35.1

# Cluster info
kubectl cluster-info --context kind-tws-kind-cluster
```

---

## 🖥️ Step 5 — Setup Kubernetes Dashboard

### 5.1 Deploy Dashboard

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### 5.2 Create Admin User

Create `dashboard-admin-user.yml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

```bash
# Apply admin user config
kubectl apply -f dashboard-admin-user.yml
```

### 5.3 Get Access Token

```bash
kubectl -n kubernetes-dashboard create token admin-user
# Copy the token output — you'll need it to login
```

### 5.4 Access the Dashboard

```bash
# Start kubectl proxy
kubectl proxy
```

Open browser and go to:
```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

Login with the token from Step 5.3 ✅

---

## 🗑️ Step 6 — Delete Cluster

```bash
kind delete cluster --name tws-kind-cluster
```

---

## 🔄 Multiple Cluster Management

```bash
# List all KIND clusters
kind get clusters

# Switch between clusters
kubectl config get-contexts
kubectl config use-context kind-tws-kind-cluster

# Create second cluster with different name
kind create cluster --config kind-config.yaml --name dev-cluster
kind create cluster --config kind-config.yaml --name prod-cluster
```

---

## 📝 Quick Reference — kubectl Commands

```bash
# Nodes
kubectl get nodes
kubectl get nodes -o wide

# Namespaces
kubectl get ns
kubectl create ns myapp

# Pods
kubectl get pods
kubectl get pods -A                    # all namespaces
kubectl get pods -n kube-system

# Run a quick pod
kubectl run nginx --image=nginx
kubectl get pods
kubectl delete pod nginx
```

---

## 📌 Important Notes

| Note | Detail |
|------|--------|
| Multiple clusters | Use unique `--name` for each cluster |
| Custom K8s version | Update `image` in config file |
| Ephemeral clusters | KIND clusters lost if Docker restarts |
| EC2 restart | Re-run `kind create cluster` after reboot |
| Context name | Always `kind-<cluster-name>` format |

---

## 🆚 KIND vs Minikube vs Kubeadm

| Feature | KIND | Minikube | Kubeadm |
|---------|------|----------|---------|
| Multi-node | ✅ Yes | ❌ No | ✅ Yes |
| Needs VM | ❌ No | ✅ Yes | ✅ Yes |
| Works on EC2 | ✅ Perfect | ⚠️ Limited | ✅ Yes |
| Speed | ⚡ Fast | Medium | Slow |
| Best for | Dev/CI/EC2 | Local laptop | Production |

---

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
📚 **KIND Docs:** https://kind.sigs.k8s.io/
