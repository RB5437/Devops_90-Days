# 🔁 Day 48 — ArgoCD Basics + First App Deploy

**Date:** 30 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered Today

| # | Topic | Status |
|---|-------|--------|
| 1 | GitOps concept + DVAO Principle | ✅ Done |
| 2 | GitOps vs Traditional CI/CD | ✅ Done |
| 3 | What is ArgoCD + Architecture | ✅ Done |
| 4 | ArgoCD vs JenkinsX vs FluxCD | ✅ Done |
| 5 | KIND Cluster setup | ✅ Done |
| 6 | ArgoCD install via Helm | ✅ Done |
| 7 | ArgoCD UI + CLI setup | ✅ Done |
| 8 | Deploy Nginx — UI approach | ✅ Done |
| 9 | Deploy Apache — CLI approach (auto-sync + self-heal) | ✅ Done |
| 10 | ArgoCD Projects | ✅ Done |

**Versions:** ArgoCD v3.4.3 | Helm v4.2.0 | KIND v0.31.0 | K8s v1.33.1

---

## 🧠 What is GitOps?

GitOps = **Git as Single Source of Truth** for infrastructure and application deployment.

**DVAO Principle:**
- **D**eclarative — everything defined as code (YAML)
- **V**ersioned — stored in Git (history + rollback)
- **A**utomatically applied — no manual kubectl apply
- **O**bservable — continuous sync status visible

---

## 🔄 GitOps vs Traditional CI/CD

| | Traditional CI/CD | GitOps |
|--|-------------------|--------|
| Deploy trigger | Pipeline pushes to K8s | ArgoCD pulls from Git |
| Source of truth | Pipeline scripts | Git repo |
| Rollback | Re-run pipeline | `git revert` |
| Drift detection | ❌ None | ✅ Automatic |
| Tools | Jenkins | ArgoCD, FluxCD |

---

## 🏗️ ArgoCD Architecture

```
Git Repo (YAML) → Webhook → ArgoCD Repo Server → Application Controller
                                                        ↓
                                              Compare desired vs actual
                                                        ↓
                                              Sync to Kubernetes cluster
```

**3 Core Components:**
- **API Server** — UI, CLI, gRPC access
- **Repo Server** — clones Git repo, renders manifests
- **Application Controller** — watches K8s + syncs state

---

## 🛠️ Setup — KIND + ArgoCD via Helm

```bash
# Install Docker + KIND + kubectl + Helm
sudo apt install docker.io -y
kind create cluster --name argocd-cluster --config kind-config.yml
kubectl get nodes   # control-plane + worker Ready ✅

# Install ArgoCD via Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd
kubectl get pods -n argocd   # 7 pods Running ✅

# Access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &

# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

---

## 🖥️ Deploy Nginx — UI Approach

- Source: `github.com/rb5437/argocd-demos` → `ui_approach/nginx`
- Dest: `argocd-cluster` → `default` namespace
- Sync Policy: Manual → then Auto
- Result: nginx 2 pods Running ✅ | `Welcome to nginx!` browser ✅

---

## ⌨️ Deploy Apache — CLI Approach

```bash
argocd app create apache-app \
  --repo https://github.com/rb5437/argocd-demos.git \
  --path cli_approach/apache \
  --dest-server https://172.31.17.5:33893 \
  --dest-namespace default \
  --sync-policy automated \
  --self-heal \
  --auto-prune
```

- 4 Apache pods Running ✅
- APP HEALTH: **Healthy** ✅
- SYNC STATUS: **Synced** to HEAD ✅
- Auto-sync enabled — Git push = auto deploy! 🔥

---

## 🗂️ ArgoCD Projects

- Created `online-shop` project via UI
- Description: "This project holds apps for online shopping website"
- Projects = logical grouping of apps + RBAC boundaries

---

## 🔗 Official Links

| Topic | Link |
|-------|------|
| ArgoCD Docs | https://argo-cd.readthedocs.io/en/stable/ |
| ArgoCD Helm Chart | https://github.com/argoproj/argo-helm |
| GitOps Principles | https://opengitops.dev/ |
| argocd-demos repo | https://github.com/rb5437/argocd-demos |

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
