# ⌨️ Day 49 — ArgoCD Commands

## Declarative Approach — Online-Shop

```bash
cd ~/argocd-demos/declarative_approach/online_shop
ls   # online_shop_app.yml  online_shop_deployment.yml  online_shop_svc.yml

cat online_shop_app.yml
kubectl apply -f online_shop_app.yml
kubectl get pods     # 5 online-shop pods Running ✅
kubectl get svc      # online-shop-service ClusterIP
kubectl port-forward svc/online-shop-service 8083:3000 --address=0.0.0.0 &
# Browser: 54.87.51.207:8083 → Online Shop live! 🛒
```

## Projects — Declarative

```bash
mkdir ~/project && cd ~/project
vi project.yml   # AppProject manifest

kubectl apply -f project.yml -n argocd
argocd proj list   # frontend-team created ✅

# App inside project
vi nginx_app.yml   # spec.project: frontend-team
kubectl apply -f nginx_app.yml -n argocd
kubectl get applications -n argocd

# Debug project error
kubectl describe application nginx-frontend -n argocd
kubectl get appproject frontend-team -n argocd -o yaml
```

## App-of-Apps Pattern

```bash
cd ~/argocd-features/app_of_apps
ls   # README.md  root_app.yml

cat root_app.yml
kubectl apply -f root_app.yml -n argocd

# Check all child apps created
kubectl get applications -n argocd
# apache-child      Synced    Healthy ✅
# nginx-child       Synced    Progressing
# online-shop-app   Synced    Progressing
# root-app          Synced    Healthy ✅
```

## Multi-Cluster Setup

```bash
# Create second (prod) cluster
vi kind-config-prod.yml
kind create cluster --name prod-kind --config kind-config-prod.yml

# Switch back to argocd cluster
kubectl config use-context kind-argocd-cluster

# Register both clusters
argocd cluster add kind-argocd-cluster --name argocd-cluster --insecure
argocd cluster add kind-prod-kind --name prod-cluster --insecure
argocd cluster list
# argocd-cluster  v1.33  Successful ✅
# prod-cluster    v1.33  Successful ✅

# Deploy to different clusters
cd ~/argocd-features/multicluster
kubectl apply -f dev_app.yml    # → kubernetes.default.svc
kubectl apply -f stg_app.yml    # → argocd-cluster
kubectl apply -f prod_app.yml   # → prod-cluster
```

## ApplicationSets — List Generator

```bash
cd ~/argocd-features/applicationsets
cat list_generator.yml

kubectl apply -f list_generator.yml -n argocd
argocd appset list   # demo-list Healthy ✅

# Check generated apps
kubectl get applications -n argocd
kubectl get deployment
kubectl get svc
kubectl get pods

# Debug chai-app ErrImagePull
kubectl describe pod chai-app-79bb8b4459-8cn5g
kubectl get deployment chai-app -o yaml | grep image:
kubectl describe deployment chai-app | grep Image

# Port forward
kubectl port-forward svc/chai-app-service 8084:3000 --address=0.0.0.0 &

# Cleanup
kubectl delete deployment apache
kubectl delete svc apache-service
```

## Useful ArgoCD Commands

```bash
argocd app list                    # all apps
argocd proj list                   # all projects
argocd appset list                 # all applicationsets
argocd cluster list                # all clusters
argocd app get <name>              # app details
argocd app sync <name>            # manual sync
argocd app delete <name>          # delete app
kubectl get applications -n argocd # K8s way to list apps
```
