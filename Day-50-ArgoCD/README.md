# 🔁 Day 50 — ArgoCD Notifications + Image Updater + Monitoring

**Date:** 1 Jun 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered Today

| # | Topic | Status |
|---|-------|--------|
| 1 | ArgoCD Notifications — Email alerts | ✅ Done |
| 2 | ArgoCD Image Updater — Auto image tag update | ✅ Done |
| 3 | Prometheus + Grafana — ArgoCD Monitoring | ✅ Done |

---

## 📧 1. ArgoCD Notifications — Email

Auto-send email when app deploys successfully or health degrades.

**Setup:**
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/notifications_catalog/install.yaml
kubectl apply -f secret.yml -n argocd      # Gmail SMTP credentials
kubectl apply -f configmap-email.yml       # Email templates + triggers
kubectl apply -f chai-app.yaml -n argocd   # App with notification annotations
```

**App annotations:**
```yaml
notifications.argoproj.io/subscribe.on-health-degraded.email: "ritikbawane5437@gmail.com"
notifications.argoproj.io/subscribe.on-deployed.email: "ritikbawane5437@gmail.com"
```

**Result:** chai-app Synced + Healthy ✅ — email received on deploy! 📧

---

## 🔄 2. ArgoCD Image Updater

Automatically detects new Docker image tags → updates Git → ArgoCD syncs!

**Flow:**
```
docker push ritik2909/chai-devops:v1.0.4
       ↓
Image Updater detects new semver tag
       ↓
Commits to Git repo (kustomization.yaml updated)
       ↓
ArgoCD syncs → K8s updated to v1.0.4!
```

**Setup:**
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/config/install.yaml
kubectl apply -f secret-image-updater-git.yaml -n argocd
kubectl apply -f image-updater.yml     # ImageUpdater CRD
```

**App annotations:**
```yaml
argocd-image-updater.argoproj.io/image-list: chai-app=ritik2909/chai-devops
argocd-image-updater.argoproj.io/write-back-method: git:secret:argocd/argocd-image-updater-git-creds
argocd-image-updater.argoproj.io/chai-app.update-strategy: semver
```

**Result:**
- v1.0.0 → v1.0.1 → v1.0.3 → **v1.0.4 auto-updated!** ✅
- `kubectl get deployment chai-app -o jsonpath='{...image}'` → `ritik2909/chai-devops:v1.0.4` ✅

---

## 📊 3. Prometheus + Grafana — ArgoCD Monitoring

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring
```

**ArgoCD ServiceMonitors** applied to scrape ArgoCD metrics into Prometheus!

---

## 🔗 Official Links

| Topic | Link |
|-------|------|
| ArgoCD Notifications | https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/ |
| Image Updater | https://argocd-image-updater.readthedocs.io/en/stable/ |
| Prometheus Helm | https://github.com/prometheus-community/helm-charts |
| argocd-demos | https://github.com/RB5437/argocd-demos |

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
