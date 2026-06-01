# 📝 Day 50 — ArgoCD Advanced Notes

## 📧 Notifications — Key Points

| Component | Purpose |
|-----------|---------|
| `argocd-notifications-secret` | SMTP credentials (email + password) |
| `argocd-notifications-cm` | Templates + triggers + SMTP config |
| App annotation | Subscribe app to notification triggers |

**2 Triggers used:**
- `on-health-degraded` → email when app health = Degraded
- `on-deployed` → email when sync Succeeded + Healthy

**Email template uses Go templating:**
```
{{.app.metadata.name}}        → app name
{{.app.status.health.status}} → health status
{{.app.status.sync.status}}   → sync status
{{.context.argocdUrl}}        → ArgoCD URL
```

---

## 🔄 Image Updater — Key Points

**Problem it solves:**
- Without Image Updater: manually update image tag in Git → ArgoCD syncs
- With Image Updater: push new Docker tag → auto-detected → Git auto-updated → ArgoCD syncs!

**3 Update Strategies:**
| Strategy | Behavior |
|----------|----------|
| `semver` | Latest semantic version (v1.0.0, v1.0.1...) |
| `latest` | Always use latest tag |
| `digest` | Pin to exact image digest |

**Write-back methods:**
- `git` → commits updated kustomization.yaml to Git repo
- `argocd` → updates ArgoCD app spec directly (no Git commit)

**Flow today:**
```
v1.0.0 → push v1.0.1 → Image Updater detects
      → git commit "update image to v1.0.1"
      → ArgoCD syncs → K8s updated ✅
v1.0.3 → push v1.0.4 → auto-updated ✅
```

---

## ⚠️ Errors Fixed Today

| Error | Cause | Fix |
|-------|-------|-----|
| `kindest/node:v1.31.7` not found | Wrong K8s version | Changed to `v1.33.1` ✅ |
| `chai-devops:v1.0.3` ImagePullBackOff | Pushed tag but KIND can't pull | `docker push` + `kubectl rollout restart` ✅ |
| `argocd-image-updater` deployment not found | Wrong deploy name | Used `argocd-image-updater-controller` ✅ |

---

## 🎯 Interview Q&A

**Q: What is ArgoCD Image Updater?**
A: It's a tool that monitors Docker registries for new image tags. When a new tag is found, it automatically updates the image reference in Git and ArgoCD re-syncs the app. Fully automated image promotion — no manual Git commits needed.

**Q: What is the difference between `git` and `argocd` write-back methods?**
A: `git` write-back commits the updated image tag to the Git repo (true GitOps — Git is the source of truth). `argocd` write-back updates the ArgoCD app spec directly without a Git commit (faster but not GitOps-pure).

**Q: How do ArgoCD Notifications work?**
A: ArgoCD Notifications watches application events (health changes, sync status). When a trigger condition is met (e.g., health=Degraded), it sends alerts via configured services (email, Slack, Teams). Configured via ConfigMap for templates and Secret for credentials.
