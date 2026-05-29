# ⛵ Day 47 — Helm Deep Dive

**Date:** 29 May 2026 | **Challenge:** #90DaysOfDevOps

---

## ✅ Topics Covered Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Helm Install + KIND Cluster Setup | ✅ Done |
| 2 | Helm Components — Repo, Chart, Release | ✅ Done |
| 3 | Bitnami Repo — nginx, prometheus install | ✅ Done |
| 4 | EKS Charts Repo — AWS Load Balancer Controller | ✅ Done |
| 5 | Custom Helm Chart — `helm create` | ✅ Done |
| 6 | Go Templating — `{{ .Values }}`, `{{ .Release }}`, `{{ .Chart }}` | ✅ Done |
| 7 | Multi-Service Project — best-commerce (payments + shipping) | ✅ Done |
| 8 | `helm package` + `helm repo index` | ✅ Done |

**Helm Version:** v3.20.0 | **Cluster:** KIND `rbb-helm-cluster`

---

## 🧩 Helm Components

```
Repo   → Registry of charts (bitnami, eks, your own)
Chart  → Package = deployment + service + ingress + values
Release → Installed instance of a chart in K8s
```

**Key concept:** One chart, many releases!
```bash
helm install dev-nginx  bitnami/nginx   # Release: dev-nginx
helm install prod-nginx bitnami/nginx   # Release: prod-nginx
```

---

## 📦 1. Install from Public Repo (Bitnami)

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami | grep nginx
helm install nginxv1 bitnami/nginx       # REVISION: 1 ✅
kubectl get pods                          # nginxv1-77dcdb5d4b Running ✅

helm install prometheus bitnami/prometheus  # STATUS: deployed ✅
helm uninstall nginxv1                      # clean removal ✅
```

---

## ☁️ 2. EKS Charts Repo — AWS Load Balancer Controller

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm search repo eks | grep load         # eks/aws-load-balancer-controller ✅

# Install (real EKS cluster needed):
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

---

## 🛒 3. Custom Project — best-commerce

**E-commerce app with 2 microservices:**

```
best-commerce/
├── payments/          ← helm create payments
│   ├── Chart.yaml
│   ├── values.yaml    ← image: busybox, appMessage: "Payments Service"
│   └── templates/
│       └── deployment.yaml   ← Go templates
└── shipping/          ← helm create shipping
    ├── Chart.yaml
    ├── values.yaml    ← image: busybox, appMessage: "Shipping Service"
    └── templates/
        └── deployment.yaml
```

**Go Templating in deployment.yaml:**
```yaml
name: {{ .Release.Name }}-{{ .Chart.Name }}
image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
command: ['sh', '-c', 'echo {{ .Values.appMessage }}; sleep 3600']
```

---

## 📦 4. Helm Package + Repo Index

```bash
helm package shipping/          # → shipping-0.1.0.tgz ✅
helm package payments/          # → payments-0.1.0.tgz ✅
helm repo index .               # → index.yaml (your own Helm repo!)
cat index.yaml                  # entries: payments + shipping ✅
```

---

## 🔗 Official Links

| Topic | Link |
|-------|------|
| Helm Docs | https://helm.sh/docs/ |
| Helm Install | https://helm.sh/docs/intro/install/ |
| Bitnami Charts | https://charts.bitnami.com/bitnami |
| EKS Charts | https://github.com/aws/eks-charts |
| AWS LBC Helm | https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html |


📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
