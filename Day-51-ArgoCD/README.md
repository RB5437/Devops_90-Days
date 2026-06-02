# 🔐 Day 51 — ArgoCD RBAC (Role-Based Access Control)

## 📅 Date: 2 June 2026 | #90DaysOfDevOps

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | ArgoCD Local User Management | ✅ Done |
| 2 | User Capabilities — apiKey vs login | ✅ Done |
| 3 | RBAC Policy — Casbin CSV Syntax | ✅ Done |
| 4 | Custom Roles — developer, admin | ✅ Done |
| 5 | Assigning Roles to Users | ✅ Done |
| 6 | Validating RBAC Policy | ✅ Done |
| 7 | Testing Permissions — can command | ✅ Done |
| 8 | Default Role — policy.default | ✅ Done |

---

## 🏗️ ArgoCD RBAC Architecture

```
ArgoCD Server
    │
    ├── argocd-cm (ConfigMap)          → Local Users defined here
    │       accounts.alice: apiKey, login
    │       accounts.bob: login
    │       accounts.ci-user: apiKey
    │
    └── argocd-rbac-cm (ConfigMap)     → Roles & Permissions defined here
            policy.csv:
              p, role:developer, applications, get, myproject/*, allow
              p, role:developer, applications, sync, myproject/*, allow
              p, role:admin, applications, *, *, allow
              g, alice, role:developer
              g, bob, role:admin
            policy.default: role:readonly
```

---

## 👥 Users Created Today

| User | Capabilities | Role Assigned | Can Get | Can Sync | Can Delete |
|------|-------------|---------------|---------|----------|------------|
| alice | apiKey, login | role:developer | ✅ Yes | ✅ Yes | ❌ No |
| bob | login | role:admin | ✅ Yes | ✅ Yes | ✅ Yes |
| ci-user | apiKey | — | Default: readonly | — | — |

---

## 📄 YAML Files Used

### 1. local-user-cm.yml — User Creation
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  accounts.alice: apiKey, login   # Can generate tokens AND login to UI
  accounts.bob: login             # Can only login to UI
  accounts.ci-user: apiKey        # Can only generate tokens (CI/CD automation)
```

### 2. roles.yml — RBAC Policy
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.csv: |
    # Developer role — limited to myproject
    p, role:developer, applications, get, myproject/*, allow
    p, role:developer, applications, sync, myproject/*, allow
    # Admin role — full permissions
    p, role:admin, applications, *, *, allow
    # Assign roles to users
    g, alice, role:developer
    g, bob, role:admin
  policy.default: role:readonly
```

---

## 🔍 Permission Test Results

| Command | Result |
|---------|--------|
| `rbac can alice get applications "myproject/*"` | ✅ Yes |
| `rbac can alice sync applications "myproject/*"` | ✅ Yes |
| `rbac can alice delete applications "myproject/*"` | ❌ No |
| `rbac can bob sync applications "*"` | ✅ Yes |
| `rbac can bob delete applications "*"` | ✅ Yes |

---

## 📊 ArgoCD RBAC Resources & Actions Reference

| Resource | get | create | update | delete | sync |
|----------|:---:|:------:|:------:|:------:|:----:|
| applications | ✅ | ✅ | ✅ | ✅ | ✅ |
| applicationsets | ✅ | ✅ | ✅ | ✅ | ❌ |
| clusters | ✅ | ✅ | ✅ | ✅ | ❌ |
| projects | ✅ | ✅ | ✅ | ✅ | ❌ |
| repositories | ✅ | ✅ | ✅ | ✅ | ❌ |
| accounts | ✅ | ❌ | ✅ | ❌ | ❌ |

---

## 🎯 Key Takeaways

- **Built-in admin** → Use only for initial setup, then disable
- **Local users** → For small teams / CI automation
- **SSO** → Recommended for enterprise environments
- **policy.default: role:readonly** → Always set this as safety net
- **Least privilege** → Grant minimum required permissions

---

## 📂 GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)

---

## 🗺️ Progress Tracker

| Topic | Days | Status |
|-------|------|--------|
| Linux | Day 1-5 | ✅ Done |
| Networking | Day 6-7 | ✅ Done |
| Shell Scripting | Day 8-12 | ✅ Done |
| DevOps Fundamentals | Day 13 | ✅ Done |
| Git & GitHub | Day 14-17 | ✅ Done |
| AWS | Day 18-26 | ✅ Done |
| Docker | Day 27-32 | ✅ Done |
| Jenkins | Day 33-37 | ✅ Done |
| Kubernetes | Day 38-45 | ✅ Done |
| Helm | Day 46-48 | ✅ Done |
| ArgoCD | Day 48-51 | 🔄 Day 51 Today |
| Terraform | Day 52-57 | ⬜ Next |
