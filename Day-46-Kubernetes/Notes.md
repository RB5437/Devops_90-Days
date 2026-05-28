# 📝 Day 46 — Deployment Strategies Notes

## Quick Comparison Table

| Strategy | Downtime | Rollback | Cost | Use Case |
|----------|----------|----------|------|----------|
| Recreate | ✅ Yes | Slow | Low | Major DB migrations |
| Rolling | ❌ None | Fast (`undo`) | Low | Everyday deployments |
| Blue-Green | ❌ None | Instant | 2x infra | Critical apps, zero risk |
| Canary | ❌ None | Delete canary | Low | Test on real users |

---

## ♻️ Recreate — Key Points
- `strategy: type: Recreate`
- ALL old pods killed FIRST → then new pods created
- Gap in between = **downtime**
- Simple — no mixed versions
- Good for: major schema changes, stateful apps, license conflicts

## 🔄 Rolling Update — Key Points
- `strategy: type: RollingUpdate` ← K8s **default**
- `maxSurge: 1` → 1 extra pod allowed during update
- `maxUnavailable: 0` → no pod goes down before new one is up
- v1 + v2 run together briefly
- `kubectl rollout undo` → instant rollback

## 🔵🟢 Blue-Green — Key Points
- Two full deployments run simultaneously
- Blue = current live, Green = new version
- Switch = change Service selector OR patch service
- Instant rollback = switch selector back to blue
- Cost: **double infrastructure** during deployment
- No mixed versions — clean cutover

## 🐤 Canary — Key Points
- Small % of traffic → new version first
- Replica ratio controls traffic: `nginx:4, apache:1` = 80/20
- Single Service selects BOTH via common label (`app: web`)
- Monitor: error rate, latency, CPU before scaling up
- Scale up canary → scale down stable gradually
- Rollback = `kubectl scale apache --replicas=0`

## ⚠️ Error Fixed Today
- Rolling update: `ImagePullBackOff` on `online_shop_with_footer`
  - Fix: changed to `online_shop_without_footer` (correct image name)
  - Old pods stayed Running during fix — maxUnavailable: 0 worked! ✅

## 🎯 Interview Answer Template
**Q: "What deployment strategy would you use?"**

**A:** "It depends on the risk tolerance and requirements:
- Everyday low-risk → **Rolling** (default, no extra cost)
- Zero-risk critical app → **Blue-Green** (instant rollback, 2x cost)
- Testing new features safely → **Canary** (real traffic, gradual)
- Breaking DB schema change → **Recreate** (only when v1+v2 can't coexist)"
