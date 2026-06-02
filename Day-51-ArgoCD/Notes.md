# ArgoCD RBAC Notes

## What is RBAC?

Role-Based Access Control (RBAC) is a security mechanism used to restrict access based on user roles.

Benefits:

- Better Security
- Least Privilege Access
- Easy Management
- Compliance Requirements

---

## Local Users in ArgoCD

Configured in:

```yaml
argocd-cm
```

Example:

```yaml
accounts.alice: apiKey, login
accounts.bob: login
accounts.ci-user: apiKey
```

Capabilities:

### login

Allows user to access ArgoCD UI.

### apiKey

Allows token generation for automation.

---

## RBAC ConfigMap

Configured in:

```yaml
argocd-rbac-cm
```

Policy Syntax:

```csv
p, role:developer, applications, get, myproject/*, allow
```

Format:

```text
p, role, resource, action, object, effect
```

---

## Role Mapping

```csv
g, alice, role:developer
g, bob, role:admin
```

---

## Validate Policies

```bash
argocd admin settings rbac validate --policy-file roles.yml
```

---

## Verify Access

```bash
argocd admin settings rbac can alice sync applications "myproject/*" -n argocd
```

---

## Real-World Usage

Developer:
- View Applications
- Sync Applications

Admin:
- Full Access

CI User:
- API Token Automation

---

## Interview Questions

### What is RBAC?

RBAC controls permissions using roles instead of assigning permissions directly to users.

### Where is RBAC configured in ArgoCD?

```yaml
argocd-rbac-cm
```

### How are users assigned roles?

```csv
g, username, role
```

### How do you validate RBAC policies?

```bash
argocd admin settings rbac validate --policy-file roles.yml
```

### Difference between login and apiKey?

login = UI Access

apiKey = Automation Token Access
