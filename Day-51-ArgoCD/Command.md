# Commands Used

## Apply Local User Configuration

```bash
kubectl apply -f local-user-cm.yml
```

## Verify ConfigMap

```bash
kubectl -n argocd get configmap argocd-cm -o yaml
```

## Update User Password

```bash
argocd account update-password --account alice
```

## List Accounts

```bash
argocd account list
```

## Get Account Details

```bash
argocd account get --account alice
```

## Create RBAC File

```bash
vi roles.yml
```

## Apply RBAC Configuration

```bash
kubectl apply -f roles.yml
```

## Validate RBAC Policy

```bash
argocd admin settings rbac validate --policy-file roles.yml
```

## Test Developer Access

```bash
argocd admin settings rbac can alice get applications "myproject/*" -n argocd

argocd admin settings rbac can alice sync applications "myproject/*" -n argocd

argocd admin settings rbac can alice delete applications "myproject/*" -n argocd
```

## Test Admin Access

```bash
argocd admin settings rbac can bob sync applications "*" -n argocd

argocd admin settings rbac can bob delete applications "*" -n argocd
```
