# ⌨️ Day 43 — Commands Reference

## Cluster Setup
```bash
kind create cluster --name rbb-cluster --config=config.yml
kubectl cluster-info --context kind-rbb-cluster
kubectl get nodes
```

## RBAC — Check Permissions
```bash
kubectl auth whoami
kubectl auth can-i get pods
kubectl auth can-i get pods -n apache
kubectl auth can-i get pods --as=system:serviceaccount:apache:apache-user -n apache
kubectl auth can-i get deployments --as=system:serviceaccount:apache:apache-user -n apache
```

## RBAC — Apply Resources
```bash
kubectl apply -f namespace.yml
kubectl apply -f service-account.yml
kubectl apply -f role.yml
kubectl apply -f role-binding.yml

kubectl get serviceaccount -n apache
kubectl get role -n apache
kubectl get rolebinding -n apache
```

## Kubernetes Dashboard
```bash
# Install
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Admin user
kubectl apply -f dashboard-admin-user.yml

# Get token
kubectl -n kubernetes-dashboard create token admin-user

# Proxy (public access)
kubectl proxy --address=0.0.0.0 --accept-hosts='.*'

# Kill existing proxy
sudo lsof -i :8001
kill -9 <PID>

# Proxy (local only)
kubectl proxy &

# SSH tunnel from local machine
ssh -i "DevOps_Key.pem" -L 8001:localhost:8001 ubuntu@<EC2-IP>
```

## CRD
```bash
kubectl apply -f devops-crd.yml
kubectl get crd
kubectl apply -f devops-cr.yml
kubectl apply -f devops-cr2.yml
kubectl get devopsbatches
kubectl get junoon           # shortname works!
kubectl describe devopsbatch
kubectl delete crd devopsbatches.trainwithritik.com
```

## Helm
```bash
# Install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
helm version

# Create chart
helm create apache-helm
tree apache-helm/

# Package
helm package apache-helm/

# Install
helm install dev-apache apache-helm
helm install dev-apache apache-helm -n dev-apache --create-namespace

# Check
kubectl get pods -n dev-apache
kubectl get svc -n dev-apache
kubectl get deployment -n dev-apache
helm list -n dev-apache

# Upgrade
helm upgrade prod-apache apache-helm

# Rollback
helm rollback prod-apache 1 -n prod-apache

# Uninstall
helm uninstall dev-apache -n dev-apache
```
