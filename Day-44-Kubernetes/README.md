# ☸️ Day 44 — Kubernetes: Init Container, Sidecar Container & Istio Service Mesh

**Date:** 26 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered

| # | Topic | Status |
|---|-------|--------|
| 1 | Init Container | ✅ Done |
| 2 | Sidecar Container | ✅ Done |
| 3 | Istio Service Mesh — Install + Bookinfo App | ✅ Done |

---

## 🚀 1. Init Container

An **Init Container** runs **before** the main container starts. Used for setup tasks like DB checks, config downloads, or waiting for dependencies.

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/pods/init-containers/

```yaml
# init-container.yml
kind: Pod
apiVersion: v1
metadata:
  name: init-test
spec:
  initContainers:
  - name: init-container
    image: busybox:latest
    command: ["sh", "-c", "echo 'Initialization started...'; sleep 10; echo 'Initialization completed.'"]

  containers:
  - name: main-container
    image: busybox:latest
    command: ["sh", "-c", "echo 'Main container started'"]
```

**Flow:**
```
Init Container runs → completes → Main Container starts
```

**Verify:**
```bash
kubectl apply -f init-container.yml
kubectl get pods
# NAME        READY   STATUS      AGE
# init-test   0/1     Init:0/1    8s   ← init running

kubectl logs init-test -c main-container
# Main container started ✅
```

**Key facts:**
- Init containers run sequentially (one after another)
- Main container only starts after ALL init containers complete
- If init container fails → pod restarts
- Use case: wait for DB, download config, set permissions

---

## 🚗 2. Sidecar Container

A **Sidecar Container** runs **alongside** the main container in the same pod. Shares volumes, network, and lifecycle.

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/

```yaml
# sidecar-container.yml
kind: Pod
apiVersion: v1
metadata:
  name: sidecar-test
spec:
  volumes:
  - name: shared-logs
    emptyDir: {}

  containers:
  # Main app — produces logs
  - name: main-container
    image: busybox
    command: ["sh", "-c", "while true; do echo 'Hello Dosto' >> /var/log/app.log; sleep 5; done"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/

  # Sidecar — displays logs
  - name: sidecar-container
    image: busybox
    command: ["sh", "-c", "tail -f /var/log/app.log"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/
```

**Result:**
```bash
kubectl get pods
# NAME           READY   STATUS    RESTARTS   AGE
# sidecar-test   2/2     Running   0          7s  ← 2/2 = both containers running!

kubectl logs sidecar-test -c sidecar-container
# Hello Dosto
# Hello Dosto
# Hello Dosto  ← logs streaming every 5 seconds ✅
```

**Init vs Sidecar:**

| Feature | Init Container | Sidecar Container |
|---------|---------------|-------------------|
| When runs | Before main | Alongside main |
| Lifecycle | Completes & exits | Runs entire pod lifetime |
| Purpose | Setup/pre-checks | Logging, proxy, sync |
| Pod status | `Init:0/1` | `2/2 Running` |
| Real use | Wait for DB | Istio Envoy proxy, log shipper |

---

## 🕸️ 3. Istio Service Mesh

Istio is a **service mesh** that adds traffic management, security (mTLS), and observability to microservices — **without changing app code**.

**Official Docs:** https://istio.io/latest/docs/

**Components:**
- **Istiod** — Control plane (config, certificates, service discovery)
- **Envoy** — Sidecar proxy injected into every pod automatically
- **Kiali** — Visualization dashboard
- **Jaeger** — Distributed tracing

### Installation on KIND

```bash
# Step 1 — Create KIND cluster
kind create cluster --name istio-testing
kubectl cluster-info --context kind-istio-testing

# Step 2 — Download Istio 1.30.0
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.30.0/

# Step 3 — Install istioctl
sudo mv bin/istioctl /usr/local/bin/
istioctl version

# Step 4 — Install Istio (demo profile)
istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y
# ✔ Istio core installed ⛵️
# ✔ Istiod installed 🧠
# ✔ Installation complete

# Step 5 — Enable auto sidecar injection for default namespace
kubectl label namespace default istio-injection=enabled

# Verify
kubectl get namespace -L istio-injection
# default   Active   enabled ✅

# Step 6 — Install Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.5.1" | kubectl apply -f -; }
```

### Deploy Bookinfo App (Istio Sample)

```bash
# Deploy all services
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

# Services created:
# details, ratings, reviews (v1/v2/v3), productpage

kubectl get services
# NAME          TYPE        CLUSTER-IP       PORT(S)
# details       ClusterIP   10.96.182.220    9080/TCP
# productpage   ClusterIP   10.96.138.144    9080/TCP
# ratings       ClusterIP   10.96.111.200    9080/TCP
# reviews       ClusterIP   10.96.224.34     9080/TCP

# Test app is working
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
# <title>Simple Bookstore App</title> ✅

# Setup Gateway
kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
kubectl get gateway

# Access app
kubectl port-forward svc/bookinfo-gateway-istio 8080:80
# Open: http://<EC2-IP>:8080/productpage
```

**Bookinfo Architecture (Service Mesh in action):**
```
Browser → productpage → details (v1)
                      → reviews (v1 / v2 / v3)
                              → ratings
```
Each service has **Envoy sidecar injected automatically** — mTLS + traffic control + observability!

---

## 🔧 Errors Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| `docker: executable not found` | Fresh EC2, Docker not installed | `sudo apt-get install docker.io` |
| `kubectl log` not found | Wrong command | `kubectl logs` (with s) |
| `mv istioctl /usr/local/bin/` permission denied | No sudo | `sudo mv istioctl /usr/local/bin/` |
| `kubectl get namspace` | Typo | `kubectl get namespace` |

---

## 🔗 Official Links

| Topic | Link |
|-------|------|
| Init Containers | https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| Sidecar Containers | https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/ |
| Istio Docs | https://istio.io/latest/docs/ |
| Istio Getting Started | https://istio.io/latest/docs/setup/getting-started/ |
| Bookinfo Sample | https://istio.io/latest/docs/examples/bookinfo/ |
| Istio GitHub | https://github.com/istio/istio |

---

## 📊 Kubernetes Progress

| Day | Topic | Status |
|-----|-------|--------|
| Day 38 | Architecture + KIND + Minikube + Namespaces | ✅ |
| Day 39 | Pods + Deployments + ReplicaSets + DaemonSets + Jobs + CronJobs | ✅ |
| Day 40 | Storage + Services + Ingress + Django Project | ✅ |
| Day 41 | StatefulSets (MySQL) | ✅ |
| Day 42 | ConfigMap + Secrets + Probes + Taints + HPA + VPA | ✅ |
| Day 43 | RBAC + ServiceAccount + CRD + Dashboard + Helm | ✅ |
| Day 44 | Init Container + Sidecar + Istio Service Mesh | ✅ |
| Day 45 | Kubernetes Final Revision | ⬜ |

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
