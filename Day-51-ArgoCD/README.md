# Day 50 - ArgoCD RBAC & Local User Management

## Overview

On Day 50 of my #90DaysOfDevOps journey, I implemented ArgoCD Role-Based Access Control (RBAC) and Local User Management.

This hands-on practice covered:

- Creating Local Users
- Managing User Capabilities
- Configuring RBAC Policies
- Assigning Roles to Users
- Validating Policies
- Testing User Permissions

---

## Project Structure

```bash
RBAC/
├── local-user-cm.yml
├── roles.yml
├── README.md
├── command.md
└── notes.md
```

---

## Step 1: Create Local Users

Created users inside ArgoCD ConfigMap.

```yaml
data:
  accounts.alice: apiKey, login
  accounts.bob: login
  accounts.ci-user: apiKey
```

Capabilities:

| User | Login | API Key |
|--------|--------|---------|
| alice | ✅ | ✅ |
| bob | ✅ | ❌ |
| ci-user | ❌ | ✅ |

---

## Step 2: Apply Configuration

```bash
kubectl apply -f local-user-cm.yml
```

Verify:

```bash
kubectl -n argocd get configmap argocd-cm -o yaml
```

---

## Step 3: Update Password

```bash
argocd account update-password --account alice
```

---

## Step 4: Verify Accounts

```bash
argocd account list
```

Output:

```text
NAME     ENABLED  CAPABILITIES
admin    true     login
alice    true     apiKey, login
bob      true     login
ci-user  true     apiKey
```

---

## Step 5: Create RBAC Policy

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd

data:
  policy.csv: |
    p, role:developer, applications, get, myproject/*, allow
    p, role:developer, applications, sync, myproject/*, allow

    p, role:admin, applications, *, *, allow

    g, alice, role:developer
    g, bob, role:admin

  policy.default: role:readonly
```

---

## Step 6: Apply RBAC Configuration

```bash
kubectl apply -f roles.yml
```

---

## Step 7: Validate Policy

```bash
argocd admin settings rbac validate --policy-file roles.yml
```

Output:

```text
Policy is valid.
```

---

## Step 8: Test Permissions

Developer Permissions:

```bash
argocd admin settings rbac can alice get applications "myproject/*" -n argocd
```

Output:

```text
Yes
```

```bash
argocd admin settings rbac can alice sync applications "myproject/*" -n argocd
```

Output:

```text
Yes
```

```bash
argocd admin settings rbac can alice delete applications "myproject/*" -n argocd
```

Output:

```text
No
```

Admin Permissions:

```bash
argocd admin settings rbac can bob delete applications "*" -n argocd
```

Output:

```text
Yes
```

---

## Key Learnings

- ArgoCD User Management
- Local User Accounts
- Account Capabilities
- RBAC Authorization
- Role Assignment
- Policy Validation
- Permission Testing
- GitOps Security

---

## Conclusion

Successfully implemented ArgoCD RBAC using local users and role-based authorization. Verified permissions through real-world testing and policy validation.
