# 📝 Day 48 — ArgoCD Notes

## 🔑 Key Concepts

### GitOps vs Traditional CI/CD
```
Traditional:  Git → Jenkins builds → Jenkins PUSHES to K8s
GitOps:       Git → ArgoCD PULLS from Git → Syncs to K8s
```
Key difference: **Push vs Pull model**

### DVAO Principle
| Letter | Meaning | Example |
|--------|---------|---------|
| D | Declarative | YAML files in Git |
| V | Versioned | Git history + branches |
| A | Automatically applied | Auto-sync on Git push |
| O | Observable | ArgoCD UI shows drift |

---

## 🏗️ ArgoCD Components

| Component | Role |
|-----------|------|
| **API Server** | Entry point — UI, CLI, gRPC |
| **Repo Server** | Clones Git, renders Helm/Kustomize/YAML |
| **App Controller** | Compares desired (Git) vs actual (K8s) |
| **Redis** | Caching |
| **Dex Server** | SSO/OAuth integration |
| **Notifications** | Slack, email alerts |
| **ApplicationSet** | Template-based multi-app creation |

---

## 🔄 App Health States

| State | Meaning |
|-------|---------|
| **Healthy** | All pods Running ✅ |
| **Degraded** | Pods failing ❌ |
| **Progressing** | Rolling update in progress |
| **Suspended** | Auto-sync paused |
| **Missing** | Resource not found in K8s |
| **Unknown** | Can't determine state |

## 🔄 Sync Status

| Status | Meaning |
|--------|---------|
| **Synced** | Git = K8s (no drift) ✅ |
| **OutOfSync** | Git ≠ K8s (drift detected) |

---

## 3 Ways to Deploy Apps in ArgoCD

| Method | How | When |
|--------|-----|------|
| **UI** | Click + fill form | Learning, one-off |
| **CLI** | `argocd app create` | Scripting, automation |
| **Declarative** | Apply `Application` YAML | Production, GitOps |

---

## ⚡ Self-Heal + Auto-Prune

- **Auto-Sync** → ArgoCD syncs when Git changes
- **Self-Heal** → ArgoCD reverts manual kubectl changes
- **Auto-Prune** → Deletes K8s resources removed from Git

```bash
# All 3 enabled via CLI:
--sync-policy automated --self-heal --auto-prune
```

---

## 🎯 ArgoCD vs JenkinsX vs FluxCD

| | ArgoCD | FluxCD | JenkinsX |
|--|--------|--------|---------|
| UI | ✅ Rich | ❌ CLI only | Limited |
| GitOps | ✅ | ✅ | ✅ |
| Helm support | ✅ | ✅ | ✅ |
| Learning curve | Easy | Medium | Hard |
| Popular in jobs | ⭐⭐⭐ | ⭐⭐ | ⭐ |

---

## 🎯 Interview Q&A

**Q: What is GitOps?**
A: GitOps is a practice where Git is the single source of truth for both application code and infrastructure. Changes are made via Git commits, and tools like ArgoCD automatically sync those changes to Kubernetes.

**Q: What is the difference between ArgoCD and Jenkins?**
A: Jenkins is a CI tool — it builds, tests, and pushes. ArgoCD is a CD tool — it pulls from Git and syncs to Kubernetes. Jenkins PUSHES changes to K8s, ArgoCD PULLS from Git. Together they form a complete CI/CD pipeline.

**Q: What is Self-Heal in ArgoCD?**
A: If someone manually changes a K8s resource (kubectl edit), ArgoCD detects the drift and automatically reverts it back to match what's in Git. Git is always the source of truth.
