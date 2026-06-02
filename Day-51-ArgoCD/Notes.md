# 📝 Day 51 — ArgoCD RBAC Deep Notes

---

## 1. 🔐 What is RBAC?

**RBAC = Role-Based Access Control**

Controls **WHO** (user/group) can do **WHAT action** on **WHICH resource**.

ArgoCD RBAC is built on **Casbin** — an open-source authorization library.

```
Without RBAC:              With RBAC:
Everyone = admin ❌        alice = developer (limited) ✅
                           bob = admin (full) ✅
                           ci-user = API only ✅
```

---

## 2. 👤 User Types in ArgoCD

### Built-in Admin
- Created automatically at install
- Has FULL access — everything
- Should be **disabled in production** after setup
- `kubectl patch -n argocd configmap argocd-cm --patch='{"data":{"admin.enabled": "false"}}'`

### Local Users
Defined in `argocd-cm` ConfigMap.

**Two capabilities:**
| Capability | Meaning | Use Case |
|-----------|---------|----------|
| `login` | Can login to ArgoCD UI | Human users |
| `apiKey` | Can generate JWT tokens | CI/CD pipelines, automation |

```yaml
# User with both capabilities
accounts.alice: apiKey, login

# User with only UI login
accounts.bob: login

# User with only API (no UI login)
accounts.ci-user: apiKey
```

### Local User Limitations
- No groups support
- No login history
- No centralized management
→ For enterprise, use **SSO** instead

---

## 3. 📜 RBAC Casbin Syntax

ArgoCD RBAC uses **CSV format** inside `argocd-rbac-cm` ConfigMap.

### Policy Statement (p)
```
p, <role/user>, <resource>, <action>, <object>, <effect>
```

Example:
```
p, role:developer, applications, get, myproject/*, allow
     ^role          ^resource     ^action ^scope      ^allow/deny
```

### Group Assignment (g)
```
g, <user/group>, <role>
```

Example:
```
g, alice, role:developer   # Assign alice to developer role
g, bob, role:admin         # Assign bob to admin role
```

### Wildcard Usage
```
*   = matches everything
myproject/*  = matches all apps in myproject
*/*          = matches all apps in all projects
```

---

## 4. 🏗️ How RBAC ConfigMap Works

```
argocd-rbac-cm
    │
    ├── policy.csv      → All RBAC rules in Casbin format
    │
    ├── policy.default  → Default role for users not assigned any role
    │                     Always set to: role:readonly
    │
    └── scopes          → Which JWT claims to use for group mapping
                          Default: '[groups, email]'
```

---

## 5. 🔑 Built-in Roles

ArgoCD has 2 built-in roles:

| Role | Description |
|------|-------------|
| `role:readonly` | Can view everything, cannot modify |
| `role:admin` | Can do everything |

**Always use `policy.default: role:readonly`** — so new users don't accidentally get admin!

---

## 6. 🧪 RBAC Testing — `rbac can` Command

Test permissions WITHOUT logging in as that user:

```bash
argocd admin settings rbac can <user> <action> <resource> "<scope>" -n argocd
```

Examples from today's practice:
```
alice + get applications myproject/*    → YES  (has permission)
alice + sync applications myproject/*   → YES  (has permission)
alice + delete applications myproject/* → NO   (not in policy)
bob + sync applications *               → YES  (admin role)
bob + delete applications *             → YES  (admin role)
```

---

## 7. 📋 RBAC Validation

Before applying RBAC, always validate:

```bash
argocd admin settings rbac validate --policy-file roles.yml
# Output: Policy is valid. ✅
```

If policy has syntax error, it shows error details.

---

## 8. 🌐 SSO vs Local Users

| Feature | Local Users | SSO (GitHub/Okta/Google) |
|---------|------------|--------------------------|
| Setup complexity | Easy | Medium |
| User management | Manual | Centralized |
| Groups support | ❌ No | ✅ Yes |
| Login history | ❌ No | ✅ Yes |
| Best for | Small teams, CI | Enterprise |
| Production recommended | ❌ | ✅ |

---

## 9. 🏭 Production Best Practices

1. **Disable admin user** after initial setup
2. **Set `policy.default: role:readonly`** always
3. **Least privilege** — grant minimum required
4. **Use groups** instead of individual users (with SSO)
5. **Validate policy** before applying: `rbac validate`
6. **Use SSO** for enterprise (GitHub, Okta, Google)
7. **Separate roles per project** — don't give `*/*` to developers

---

## 10. 🔄 Interview Questions — ArgoCD RBAC

**Q1: What is RBAC in ArgoCD?**
Role-Based Access Control — controls who can do what on which resource. Uses Casbin library, configured in `argocd-rbac-cm` ConfigMap.

**Q2: Difference between `apiKey` and `login` capability?**
`login` = user can login to ArgoCD UI. `apiKey` = user can generate JWT tokens for automation/CI pipelines.

**Q3: What is `policy.default`?**
The default role applied to authenticated users not explicitly assigned a role. Always set to `role:readonly` for security.

**Q4: How do you test RBAC without logging in?**
`argocd admin settings rbac can <user> <action> <resource> "<scope>"` — validates permissions from command line.

**Q5: When should you use SSO instead of local users?**
In enterprise environments where you need groups, login history, centralized user management, and existing identity providers.
