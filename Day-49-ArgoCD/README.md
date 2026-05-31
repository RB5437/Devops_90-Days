# 🔁 Day 49 — ArgoCD Deep Dive

**Date:** 31 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Declarative Approach — Online-Shop App | ✅ Done |
| 2 | ArgoCD Projects — Declarative YAML | ✅ Done |
| 3 | App-of-Apps Pattern | ✅ Done |
| 4 | Multi-Cluster Management | ✅ Done |
| 5 | ApplicationSets — List Generator | ✅ Done |

---

## 📄 1. Declarative Approach — Online-Shop

The production way to deploy apps — define as YAML, apply with kubectl.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: online-shop-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/RB5437/argocd-demos.git
    targetRevision: main
    path: declarative_approach/online_shop
  destination:
    server: https://172.31.21.55:33893
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

```bash
kubectl apply -f online_shop_app.yml
kubectl get pods   # 5 online-shop pods Running ✅
```
**Online Shop live at 54.87.51.207:8083** 🛒

---

## 🗂️ 2. ArgoCD Projects — Declarative

Projects = logical grouping + RBAC boundaries for apps.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: frontend-team
  namespace: argocd
spec:
  description: this project holds a new frontend app
  sourceRepos:
    - https://github.com/RB5437/argocd-demos.git
  destinations:
    - namespace: frontend
      server: https://172.31.21.55:33893
  clusterResourceWhitelist:
    - group: "*"
      kind: "*"
  roles:
    - name: frontend-admins
      policies:
        - p, proj:frontend-team:frontend-admins, applications, *, frontend-team/*, allow
```

```bash
kubectl apply -f project.yml -n argocd
argocd proj list   # frontend-team created ✅
```

---

## 🌳 3. App-of-Apps Pattern

One root app manages ALL child apps. Git push = all apps sync!

```yaml
# root_app.yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-app
  namespace: argocd
spec:
  source:
    path: app_of_apps/apps   # folder with child app YAMLs
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

```bash
kubectl apply -f root_app.yml -n argocd
kubectl get applications -n argocd
# apache-child    Synced  Healthy ✅
# nginx-child     Synced  Progressing
# root-app        Synced  Healthy ✅
```

---

## 🌐 4. Multi-Cluster Management

Manage dev + staging + prod from ONE ArgoCD UI!

```bash
# 2 clusters registered
argocd cluster list
# argocd-cluster  v1.33  Successful
# prod-cluster    v1.33  Successful

# dev → in-cluster, staging → argocd-cluster, prod → prod-cluster
kubectl apply -f dev_app.yml
kubectl apply -f stg_app.yml
kubectl apply -f prod_app.yml
```

---

## 📋 5. ApplicationSets — List Generator

Template-based multi-app deployment — one YAML, many apps!

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: demo-list
  namespace: argocd
spec:
  generators:
    - list:
        elements:
          - app: nginx
            path: ui_approach/nginx
          - app: online-shop
            path: multicluster/online-shop
          - app: chaiapp
            path: applicationsets/chai-app
  template:
    metadata:
      name: '{{app}}-list'
    spec:
      source:
        path: '{{path}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

```bash
kubectl apply -f list_generator.yml -n argocd
argocd appset list   # demo-list Healthy ✅
# nginx + online-shop → Running ✅
# chai-app → ErrImagePull (wrong image tag in repo)
```

---

## 🔗 Official Links

| Topic | Link |
|-------|------|
| ArgoCD Docs | https://argo-cd.readthedocs.io/en/stable/ |
| App-of-Apps | https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/ |
| ApplicationSets | https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/ |
| argocd-demos | https://github.com/RB5437/argocd-demos |

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
