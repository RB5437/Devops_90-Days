# ☸️ Day 46 — Kubernetes Deployment Strategies (Hands-On)

**Date:** 28 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered Today

| # | Strategy | App Used | Status |
|---|----------|----------|--------|
| 1 | Recreate | online-shop (amitabhdevops) | ✅ Done |
| 2 | Rolling Update | online-shop | ✅ Done |
| 3 | Blue-Green | online-shop (blue + green) | ✅ Done |
| 4 | Canary | nginx (v1) + apache (v2) | ✅ Done |

**Cluster:** KIND — `rbb-kind-cluster` (1 control-plane + 2 workers)

---

## ♻️ 1. Recreate Deployment

Kill ALL old pods → create ALL new pods. Causes downtime.

**What I did:**
- Deployed `online-shop` v1 → 3 pods Running ✅
- Changed image to `online_shop_without_footer`
- All 3 old pods terminated at once → 3 new pods created

```bash
kubectl apply -f recreate-deployment.yml   # strategy: Recreate
kubectl set image deployment/online-shop online-shop=amitabhdevops/online_shop_without_footer -n recreate-ns
```

**Use when:** Major DB schema change, v1+v2 can't coexist.

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#recreate-deployment

---

## 🔄 2. Rolling Update Deployment

Replace pods one-by-one. Zero downtime. K8s default strategy.

**What I did:**
- Deployed with `maxSurge: 1`, `maxUnavailable: 0`
- Updated image → pods replaced gradually, 0 downtime
- Fixed `ImagePullBackOff` by using correct image tag ✅

```bash
kubectl apply -f rolling-update-deployment.yaml   # strategy: RollingUpdate
kubectl rollout status deploy/online-shop -n rolling-ns
kubectl rollout undo deploy/online-shop -n rolling-ns   # rollback
```

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment

---

## 🔵🟢 3. Blue-Green Deployment

Two identical environments. Switch traffic by changing Service selector.

**What I did:**
- **Blue** (v1): `online_shop_without_footer` → 4 pods → port 30001 ✅
- **Green** (v2): `online_shop` (with footer) → 4 pods → port 30000 ✅
- Both running simultaneously — zero downtime switch!

```bash
kubectl apply -f online-shop-without-footer-blue-deployment.yaml   # Blue
kubectl apply -f online-shop-green-deployment.yaml                  # Green
kubectl get all -n blue-green-ns                                     # 8 pods running
```

**Traffic switch command:**
```bash
kubectl patch svc <service> -p '{"spec":{"selector":{"app":"online-shop-green"}}}'
```

---

## 🐤 4. Canary Deployment (Simple Example)

Send small % of traffic to new version. Test on real users safely.

**What I did:**
- **Nginx** (v1, stable) → 4 replicas = 80% traffic
- **Apache** (v2, canary) → 1 replica = 20% traffic
- Single `web-service` selects BOTH via `app: web` label
- Ingress-nginx installed + HTTPRoute configured
- Scaled canary up → `nginx: 5, apache: 0` → 100% traffic to v1 ✅
- Then back: `nginx: 4, apache: 1` → back to 80/20 split

```bash
kubectl scale deployment nginx-deployment -n simple-canary --replicas=4   # 80%
kubectl scale deployment apache-deployment -n simple-canary --replicas=1   # 20%
```

**Official Docs:** https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

---

## 🔗 Quick Reference Links

| Topic | Link |
|-------|------|
| Deployment Strategies | https://kubernetes.io/docs/concepts/workloads/controllers/deployment/ |
| KIND Cluster | https://kind.sigs.k8s.io/ |
| Ingress-nginx | https://kubernetes.github.io/ingress-nginx/ |
| KubeStarter Repo | https://github.com/LondheShubham153/kubestarter |

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
