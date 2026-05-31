# 📝 Day 49 — ArgoCD Deep Dive Notes

## 3 Ways to Deploy in ArgoCD — Recap

| Method | How | Production? |
|--------|-----|-------------|
| UI | Click + form | ❌ Not recommended |
| CLI | `argocd app create` | ✅ Scripting |
| **Declarative** | `kubectl apply -f app.yml` | ✅✅ **Production standard** |

---

## 📄 Application YAML — Key Fields

```yaml
spec:
  project: default          # which ArgoCD project
  source:
    repoURL: <git-url>      # Git repo
    targetRevision: main    # branch
    path: <folder>          # path in repo
  destination:
    server: <cluster-url>   # target cluster
    namespace: default      # target namespace
  syncPolicy:
    automated:
      prune: true           # delete removed resources
      selfHeal: true        # revert manual changes
    syncOptions:
      - CreateNamespace=true # auto-create namespace
```

---

## 🗂️ Projects — Key Points

- Projects = RBAC + source/destination restrictions
- Every app belongs to a project (default if not specified)
- `sourceRepos` → which Git repos allowed
- `destinations` → which clusters/namespaces allowed
- `roles` → who can do what (RBAC)

**Common error:** `application repo is not permitted in project` → fix: add repo to `sourceRepos` in project.yml ✅

---

## 🌳 App-of-Apps Pattern

```
root-app (ArgoCD Application)
    └── watches: app_of_apps/apps/ folder in Git
            ├── nginx_app.yml    → nginx-child
            ├── apache_app.yml   → apache-child
            └── online_shop.yml  → online-shop-child
```

**Why use it:**
- Manage 100s of apps from one root
- Add new app = just add YAML to folder + Git push
- Root auto-syncs → child apps auto-created!

---

## 🌐 Multi-Cluster — Key Points

| Env | Cluster | App |
|-----|---------|-----|
| Dev | `kubernetes.default.svc` | nginx-dev |
| Staging | `argocd-cluster` | apache-stg |
| Prod | `prod-cluster` | online-shop-prod |

- One ArgoCD = manage ALL clusters
- `argocd cluster add <context> --insecure`
- Each app's `destination.server` = target cluster URL

---

## 📋 ApplicationSets — 3 Generators

| Generator | Use case |
|-----------|---------|
| **List** | Static list of apps — fixed elements |
| **Cluster** | One app per registered cluster |
| **Git** | One app per folder/file in repo |

**List generator = simplest:** Define elements → template auto-creates apps!

---

## ⚠️ Error Faced + Fix

**Error:** `chai-app` → `ErrImagePull`
```
Failed to pull image "trainwithshubham/chai-devopsssss:v1.0.0"
pull access denied, repository does not exist
```
**Root cause:** Wrong Docker image tag in repo YAML — image doesn't exist on DockerHub.
**Fix:** Update image in Git repo → ArgoCD auto-syncs → correct image deployed!

---

## 🎯 Interview Q&A

**Q: What is App-of-Apps in ArgoCD?**
A: It's a pattern where one root ArgoCD Application watches a Git folder containing other Application YAMLs. When the root syncs, it creates all child apps automatically. Used to manage hundreds of apps from a single Git push.

**Q: What is ApplicationSet?**
A: ApplicationSet is a controller that generates multiple ArgoCD Applications from a single template. The List generator creates one app per element, Cluster generator creates one per cluster, Git generator creates one per folder. Eliminates copy-paste of Application YAMLs.

**Q: How do you do multi-cluster with ArgoCD?**
A: Register multiple clusters with `argocd cluster add`, then set different `destination.server` in each Application YAML. One ArgoCD instance manages dev, staging, and prod clusters from a single UI.
