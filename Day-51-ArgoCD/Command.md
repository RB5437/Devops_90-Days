# ⚡ Day 51 — ArgoCD RBAC Commands

---

## 👤 USER MANAGEMENT COMMANDS

```bash
# List all users
argocd account list

# Get specific user details
argocd account get --account alice

# Update password for a user (run as admin)
argocd account update-password --account alice

# Update password for currently logged-in user
argocd account update-password \
  --current-password <current-password> \
  --new-password <new-password>

# Generate API token for a user
argocd account generate-token --account ci-user

# Disable admin user (production security)
kubectl patch -n argocd configmap argocd-cm \
  --patch='{"data":{"admin.enabled": "false"}}'

# Enable admin user
kubectl patch -n argocd configmap argocd-cm \
  --patch='{"data":{"admin.enabled": "true"}}'
```

---

## 📋 CONFIGMAP COMMANDS

```bash
# Apply local users ConfigMap
kubectl apply -f local-user-cm.yml

# Verify users in ConfigMap
kubectl -n argocd get configmap argocd-cm -o yaml

# Apply RBAC policy ConfigMap
kubectl apply -f roles.yml

# Verify RBAC ConfigMap
kubectl -n argocd get configmap argocd-rbac-cm -o yaml
```

---

## ✅ RBAC VALIDATION COMMANDS

```bash
# Validate RBAC policy file before applying
argocd admin settings rbac validate --policy-file roles.yml
# Output: Policy is valid.

# Test if alice can GET applications in myproject
argocd admin settings rbac can alice get applications "myproject/*" -n argocd

# Test if alice can SYNC applications in myproject
argocd admin settings rbac can alice sync applications "myproject/*" -n argocd

# Test if alice can DELETE applications in myproject
argocd admin settings rbac can alice delete applications "myproject/*" -n argocd

# Test if bob can SYNC all applications
argocd admin settings rbac can bob sync applications "*" -n argocd

# Test if bob can DELETE all applications
argocd admin settings rbac can bob delete applications "*" -n argocd

# Test permissions for any resource
argocd admin settings rbac can <user> <action> <resource> "<scope>" -n argocd
```

---

## 📝 YAML TEMPLATES

### local-user-cm.yml — Create Local Users
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  accounts.alice: apiKey, login   # Can generate tokens and login to UI
  accounts.bob: login             # Can only login to UI
  accounts.ci-user: apiKey        # Can only generate tokens (automation)
```

### roles.yml — RBAC Policy
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.csv: |
    # Developer — limited to myproject
    p, role:developer, applications, get, myproject/*, allow
    p, role:developer, applications, sync, myproject/*, allow
    # Admin — full access
    p, role:admin, applications, *, *, allow
    # Assign roles
    g, alice, role:developer
    g, bob, role:admin
  policy.default: role:readonly
```

---

## 🔐 ARGOCD LOGIN COMMANDS

```bash
# Login to ArgoCD CLI
argocd login <argocd-server-ip>:8080

# Login with username/password (non-interactive)
argocd login <ip>:8080 --username admin --password <password> --insecure

# Check current logged-in user
argocd account get-user-info

# Logout
argocd logout <argocd-server-ip>:8080
```

---

## 🧹 CLEANUP COMMANDS

```bash
# Delete a user (remove from argocd-cm)
kubectl patch -n argocd configmap argocd-cm \
  --type=json \
  -p='[{"op":"remove","path":"/data/accounts.alice"}]'

# Reset RBAC to defaults
kubectl patch -n argocd configmap argocd-rbac-cm \
  --patch='{"data":{"policy.default":"role:readonly","policy.csv":""}}'
```

---

## 📊 RBAC ACTIONS QUICK REFERENCE

```
Resources:    applications, applicationsets, clusters, projects,
              repositories, accounts, certificates, logs, exec

Actions:      get, create, update, delete, sync, action, override, invoke

Scope:        <project>/<app>   →  myproject/myapp
              <project>/*       →  myproject/* (all apps in project)
              */*               →  all apps in all projects
              *                 →  everything

Effect:       allow | deny
```

---

## 🔄 TODAY'S PRACTICE FLOW

```bash
# Step 1: Create local users
kubectl apply -f local-user-cm.yml

# Step 2: Verify users created
kubectl -n argocd get configmap argocd-cm -o yaml
argocd account list

# Step 3: Set passwords
argocd account update-password --account alice  # Set: alice123
argocd account update-password --account bob    # Set: bob12345

# Step 4: Verify user details
argocd account get --account alice

# Step 5: Create RBAC policy
kubectl apply -f roles.yml

# Step 6: Validate policy
argocd admin settings rbac validate --policy-file roles.yml

# Step 7: Test permissions
argocd admin settings rbac can alice get applications "myproject/*" -n argocd   # YES
argocd admin settings rbac can alice sync applications "myproject/*" -n argocd  # YES
argocd admin settings rbac can alice delete applications "myproject/*" -n argocd # NO
argocd admin settings rbac can bob sync applications "*" -n argocd              # YES
argocd admin settings rbac can bob delete applications "*" -n argocd            # YES
```
