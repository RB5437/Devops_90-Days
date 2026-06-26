# Day 74 — Live DevOps Kubernetes Project | Cluster Setup + ArgoCD 🚀

**Date:** 25/06/2026
**Project:** K8s Kind Voting App with Monitoring
**GitHub Ref:** https://github.com/RB5437/k8s-kind-voting-app.git
**Status:** ✅ Kind Cluster + ArgoCD Running

---

## 🎯 What Was Done Today

| Step | Task | Status |
|------|------|--------|
| 1 | Docker install on AWS EC2 | ✅ |
| 2 | Kind v0.32.0 install (updated) | ✅ |
| 3 | kubectl v1.33.1 install (updated) | ✅ |
| 4 | 3-node Kind cluster created | ✅ |
| 5 | ArgoCD installed with `--server-side --force-conflicts` | ✅ |
| 6 | ArgoCD server exposed via NodePort | ✅ |
| 7 | ArgoCD UI accessible via port-forward | ✅ |

---

## 🏗️ Infrastructure Setup

### EC2 Instance
- **OS:** Ubuntu (resolute)
- **Docker:** v29.1.3
- **Kind:** v0.32.0 ✅ Latest
- **kubectl:** v1.33.1 ✅ Latest
- **K8s Node Image:** kindest/node:v1.33.1 ✅ Latest

### Kind Cluster — 3 Nodes

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4

nodes:
- role: control-plane
  image: kindest/node:v1.33.1
- role: worker
  image: kindest/node:v1.33.1
- role: worker
  image: kindest/node:v1.33.1
```

**Cluster Output:**
```
NAME                 STATUS   ROLES           AGE     VERSION
kind-control-plane   Ready    control-plane   2m13s   v1.33.1
kind-worker          Ready    <none>          118s    v1.33.1
kind-worker2         Ready    <none>          119s    v1.33.1
```

---

## 🔧 ArgoCD Installation (v3.x — Updated Command)

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD — --server-side --force-conflicts required for v3.x
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### ArgoCD Pods Running
```
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          61s
argocd-applicationset-controller-55b9b9cb8c-8ldqv   1/1     Running   0          63s
argocd-dex-server-6674db5986-6k4zv                  1/1     Running   0          63s
argocd-notifications-controller-645c6f77cd-drdj4    1/1     Running   0          62s
argocd-redis-bcfd845d4-t8qps                        1/1     Running   0          62s
argocd-repo-server-6dbc7fd64f-bz7dm                 1/1     Running   0          62s
argocd-server-8597fbcddf-9cjrz                      1/1     Running   0          61s
```

### Expose ArgoCD Server
```bash
# Patch to NodePort
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Port forward for browser access
kubectl port-forward -n argocd service/argocd-server 8443:443 --address=0.0.0.0 &
```

### Get ArgoCD Admin Password
```bash
kubectl get secret -n argocd argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
# Output: qqKdVBklqfj8cOCz
```

**Access:** `https://<EC2-PUBLIC-IP>:8443`
**Username:** `admin`
**Password:** from above command

---

## 🔗 Official Links

| Resource | Link |
|----------|------|
| Kind Install | https://kind.sigs.k8s.io/docs/user/quick-start/ |
| ArgoCD Install | https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/ |
| ArgoCD v3.x Upgrade | https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.14-3.0/ |
| kubectl Install | https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ |

---

*Day 74 of #90DaysOfDevOps | Ritik Bhatia | DevOps Engineer*
