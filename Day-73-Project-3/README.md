# Day 73 — Live DevOps Kubernetes Project with Monitoring 🚀

**Date:** 24/06/2026  
**Project:** K8s Kind Voting App with Prometheus + Grafana Monitoring  
**GitHub Repo:** https://github.com/LondheShubham153/k8s-kind-voting-app  
**Status:** Architecture Understood — Implementation Starting

---

## 🎯 Project Overview

A production-style Kubernetes project that combines:
- **Multi-service application** (Voting App — Python, Redis, .NET Worker, PostgreSQL, Node.js)
- **GitOps deployment** via ArgoCD
- **Full Observability** via Prometheus + Grafana (Helm)

---

## 🏗️ Architecture

```
User
 │
 ▼ Push Vote
┌────────────────────────────────────────┐
│           GitHub Repository             │
│  (Python, .NET, Node.js, Redis, PG)    │
└───────────────┬────────────────────────┘
                │ Pull (GitOps)
                ▼
           ┌─────────┐
           │  ArgoCD │
           └────┬────┘
                │ Deploy
                ▼
┌───────────────────────────────┐
│         K8s Cluster (Kind)    │
│  ┌─────────────┐              │
│  │ Control-plane│             │
│  └─────────────┘              │
│  ┌──────────┐  ┌──────────┐  │
│  │  Node 1  │  │  Node 2  │  │
│  └──────────┘  └──────────┘  │
└───────────────────────────────┘
                │
                ▼ Monitor
┌───────────────────────────────┐
│     Monitoring (Helm)         │
│   Prometheus   +   Grafana    │
└───────────────────────────────┘
```

---

## 🗂️ Application Components

| Service | Tech | Port | Role |
|---------|------|------|------|
| vote | Python (Flask) | 5000 | Frontend — user votes here |
| redis | Redis | 6379 | Queue — stores incoming votes |
| worker | .NET | — | Consumes Redis queue → writes to DB |
| db | PostgreSQL | 5432 | Persistent storage for votes |
| result | Node.js | 5001 | Shows real-time vote results |

---

## 🔁 Data Flow

```
User votes on Vote UI (port 5000)
        ↓
    Redis Queue
        ↓
  .NET Worker (consumes)
        ↓
  PostgreSQL DB (stores)
        ↓
  Result UI (port 5001) — shows live results
```

---

## 📦 Infrastructure Stack

| Layer | Tool |
|-------|------|
| Cloud | AWS EC2 |
| Container Runtime | Docker |
| K8s Cluster | Kind (Kubernetes IN Docker) |
| GitOps CD | ArgoCD |
| Monitoring | kube-prometheus-stack (Helm) |
| Dashboards | Grafana |
| Alerting | Alertmanager |

---

## 🔍 Monitoring Architecture

```
kube-prometheus-stack (via Helm)
├── Prometheus       → NodePort 30000
├── Grafana          → NodePort 31000
├── Alertmanager     → NodePort 32000
└── Node Exporter    → NodePort 32001
```

**Key PromQL Queries this project uses:**
```promql
# CPU usage % across default namespace
sum(rate(container_cpu_usage_seconds_total{namespace="default"}[1m])) 
  / sum(machine_cpu_cores) * 100

# Memory per pod
sum(container_memory_usage_bytes{namespace="default"}) by (pod)

# Network receive per pod
sum(rate(container_network_receive_bytes_total{namespace="default"}[5m])) by (pod)

# Network transmit per pod
sum(rate(container_network_transmit_bytes_total{namespace="default"}[5m])) by (pod)
```

---

## 📋 Implementation Plan (Day 74 onwards)

| Step | Task |
|------|------|
| 1 | Launch AWS EC2 (t2.large recommended) |
| 2 | Install Docker + Kind + kubectl |
| 3 | Create 3-node Kind cluster (1 control-plane + 2 workers) |
| 4 | Clone repo + apply k8s-specifications/ |
| 5 | Port-forward vote (5000) + result (5001) — verify app |
| 6 | Install ArgoCD + expose via NodePort |
| 7 | Connect ArgoCD to GitHub repo — GitOps sync |
| 8 | Install kube-prometheus-stack via Helm |
| 9 | Port-forward Prometheus (9090) + Grafana (31000) |
| 10 | View dashboards — CPU, Memory, Network per pod |

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| GitHub Repo | https://github.com/LondheShubham153/k8s-kind-voting-app |
| TrainWithShubham | https://www.trainwithshubham.com |
| Kind Docs | https://kind.sigs.k8s.io |
| ArgoCD Docs | https://argo-cd.readthedocs.io |
| kube-prometheus-stack | https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack |
| Grafana Helm Chart | https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm |

---

## 📁 Repo Structure

```
k8s-kind-voting-app/
├── k8s-specifications/
│   ├── vote-deployment.yaml + vote-service.yaml
│   ├── result-deployment.yaml + result-service.yaml
│   ├── worker-deployment.yaml
│   ├── redis-deployment.yaml + redis-service.yaml
│   └── db-deployment.yaml + db-service.yaml
├── kind-cluster/
│   ├── config.yml          ← 3-node Kind cluster config
│   ├── commands.md         ← All commands
│   ├── install_kind.sh
│   └── install_kubectl.sh
├── vote/                   ← Python Flask app
├── result/                 ← Node.js app
├── worker/                 ← .NET worker
└── seed-data/              ← Test data generator
```

---

*Day 73 of #90DaysOfDevOps | Ritik Bhatia | DevOps Engineer*
