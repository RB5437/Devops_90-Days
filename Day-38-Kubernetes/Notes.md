# 📝 Day 38 — Kubernetes Deep Concepts Notes

---

## 1. Why Kubernetes? — The Problem It Solves

```
Before Kubernetes:
Dev team → builds Docker container → runs on EC2
Problem:
  - Container crashes → manually restart karna padta hai
  - Traffic spike → manually more containers start karna
  - Update app → downtime hota hai
  - 100 containers → 100 EC2 manage karo?

After Kubernetes:
  ✅ Container crashes → K8s auto restarts
  ✅ Traffic spike → K8s auto scales (HPA)
  ✅ Update app → Rolling update, zero downtime
  ✅ 1000 containers → K8s manages all automatically
```

**Kubernetes = Container Orchestration Platform**

---

## 2. Architecture — Deep Understanding

### API Server — Why it's the heart
```
Every action goes through API Server:
kubectl apply   → API Server → etcd (save state)
kubectl get     → API Server → etcd (read state)
Scheduler       → API Server → "where to place pod?"
Controller Mgr  → API Server → "what's the current state?"

Without API Server = cluster is dead
```

### etcd — Why it matters
```
etcd stores:
- All pod information
- Node status
- ConfigMaps, Secrets
- Service definitions
- RBAC rules

etcd backup = cluster backup!
If etcd dies → entire cluster state lost
Production rule: Always backup etcd!
```

### Scheduler — How it decides
```
Pod created → Scheduler checks:
1. Which nodes have enough CPU/Memory?
2. Any node affinity rules?
3. Any taints/tolerations?
4. Any pod anti-affinity rules?
→ Assigns pod to best node
```

### Controller Manager — Types of controllers
```
ReplicaSet Controller  → ensures N replicas always running
Deployment Controller  → manages rolling updates
Node Controller        → handles node failures
Job Controller         → ensures jobs complete
Endpoint Controller    → updates service endpoints
```

---

## 3. KIND — How it Works Internally

```
Your EC2 Instance
└── Docker (running)
    ├── Container: rbb-cluster-control-plane  ← This IS a K8s node!
    ├── Container: rbb-cluster-worker         ← This IS a K8s node!
    └── Container: rbb-cluster-worker2        ← This IS a K8s node!

KIND = Docker containers acting as K8s nodes
Each container runs kubelet, kube-proxy inside it
```

**Why KIND over Minikube for EC2?**
```
Minikube needs VM or nested virtualization
EC2 free tier → no nested virt support
KIND only needs Docker → works perfectly on EC2!
```

---

## 4. YAML — Kubernetes ke liye Essential

### YAML basics (from demo.yml practice):
```yaml
# Key-Value pair
key: value
name: shubham

# List
courses:
  - DevOps
  - AWS
  - Python

# Nested (Dictionary)
info:
  name: Ritik
  age: 26
  jobs:
    - remote
    - YT
```

### Kubernetes YAML structure — always 4 parts:
```yaml
apiVersion: v1          # Which K8s API version
kind: Pod               # What resource type
metadata:               # Name, labels, namespace
  name: my-pod
  labels:
    app: myapp
spec:                   # What to create
  containers:
  - name: nginx
    image: nginx:latest
```

---

## 5. Namespaces — Deep Concept

```
Default Namespaces:
├── default          → User workloads (if no namespace specified)
├── kube-system      → K8s system pods (API server, etcd, etc.)
├── kube-public      → Public cluster info (readable by all)
├── kube-node-lease  → Node heartbeat information
└── local-path-storage → KIND's storage provisioner
```

**Why namespaces matter in companies:**
```
Company uses namespaces for:
├── dev        → Development team
├── staging    → QA team
├── prod       → Production
└── monitoring → Prometheus, Grafana

Team A can't see Team B's pods!
Resource quotas per namespace — fair usage
```

---

## 6. Pods — The Smallest Unit

```
Pod = Wrapper around containers

Why not just containers?
- Pod provides shared network (containers share IP)
- Pod provides shared storage (containers share volumes)
- Pod provides lifecycle management

Pod IP:
- Every pod gets its OWN IP address
- Containers inside pod share that IP
- Pod restarts → NEW IP assigned (that's why Services exist!)
```

**Pod states:**
```
Pending   → Scheduler finding a node
Running   → Container running ✅
Succeeded → Job completed
Failed    → Container crashed
Unknown   → Node communication issue
```

---

## 7. kubectl — Important Commands Deep Dive

```bash
# Context management
kubectl config get-contexts              # list all clusters
kubectl config use-context kind-rbb-cluster  # switch cluster

# Namespace shortcuts
kubectl get pods                         # default namespace
kubectl get pods -n kube-system          # specific namespace
kubectl get pods -A                      # ALL namespaces

# Pod details
kubectl describe pod <name>              # full info
kubectl logs <pod-name>                  # container logs
kubectl exec -it <pod-name> -- bash      # enter container
kubectl get pod <name> -o yaml           # full YAML output
kubectl get pod <name> -o wide           # with node + IP info
```

---

## 8. Errors Faced & Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| `yaml: line 21: mapping values not allowed` | Space before `:` in YAML | Fixed spacing in config.yml |
| `kindest/node:v1.36.1: not found` | Wrong/unavailable image version | Changed to `v1.33.1` |
| `permission denied docker.sock` | User not in docker group | `sudo usermod -aG docker $USER && newgrp docker` |
| `kubect: command not found` | Typo in command | Correct: `kubectl` |
| `no context exists: rbb-cluster` | Wrong context name | Correct: `kind-rbb-cluster` |

**Learning: Typos and YAML indentation = most common K8s errors!**

---

## 9. Interview Q&A — Day 38

**Q: What is Kubernetes?**
Container orchestration platform that automates deployment, scaling, and management of containerized applications.

**Q: What is the role of API Server?**
It's the entry point for all K8s operations. Every kubectl command, every internal component communication goes through API Server.

**Q: What is etcd?**
Distributed key-value store that holds ALL cluster state. Backing it up = backing up the entire cluster.

**Q: Difference between Pod and Container?**
Container is a running process. Pod is K8s's smallest deployable unit that wraps one or more containers, giving them shared network and storage.

**Q: What is a Namespace?**
Virtual cluster inside a K8s cluster. Used to isolate resources between teams/environments (dev, staging, prod).

**Q: KIND vs Minikube vs Kubeadm?**
KIND runs K8s nodes as Docker containers — best for EC2/CI. Minikube runs single-node K8s — best for laptop. Kubeadm sets up production-grade multi-node clusters on real VMs.
