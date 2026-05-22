# ⚡ Day 40 — Storage, Services & Ingress Commands 

---

## 💾 Persistent Volume (PV)

```bash
kubectl apply -f PersistentVolume.yml
kubectl get pv
kubectl get pv -n nginx
kubectl describe pv local-pv
kubectl delete pv local-pv
```

---

## 📋 Persistent Volume Claim (PVC)

```bash
kubectl apply -f PersistentVolumeClaim.yml
kubectl get pvc -n nginx
kubectl describe pvc local-pvc -n nginx
kubectl delete pvc local-pvc -n nginx

# Get both PV and PVC together
kubectl get pv,pvc
kubectl get pv,pvc -n nginx
```

---

## 🔗 Deployment with Volume Mount

```yaml
# Add to deployment spec:
containers:
  - name: nginx
    image: nginx:latest
    volumeMounts:
    - mountPath: /var/www/html
      name: my-local-volume
volumes:
  - name: my-local-volume
    persistentVolumeClaim:
      claimName: local-pvc
```

```bash
# Verify volume inside node
docker ps                           # get worker container ID
docker exec -it <worker-id> bash
ls /mnt/data                        # PV hostPath
```

---

## 🌐 Service Commands

```bash
kubectl apply -f service.yml
kubectl get svc -n nginx
kubectl get svc -A                  # all namespaces
kubectl describe svc nginx-service -n nginx
kubectl get endpoints -n nginx
kubectl delete svc nginx-service -n nginx
```

---

## 🔄 Port Forwarding

```bash
# Basic port forward
kubectl port-forward service/nginx-service -n nginx 8081:80

# With external access (EC2)
sudo KUBECONFIG=$HOME/.kube/config kubectl port-forward \
  service/nginx-service -n nginx 81:80 --address=0.0.0.0

# Notes app
kubectl port-forward service/notes-app-services \
  -n notes-app 8000:8000 --address=0.0.0.0

# Ingress controller
kubectl port-forward service/ingress-nginx-controller \
  -n ingress-nginx 9090:80 --address=0.0.0.0

# Kill port-forward process
lsof -i :9090
kill -9 <PID>

# Kill all port-forward processes
sudo pkill -f "kubectl port-forward"
```

---

## 🐳 Docker Build + Push (Django App)

```bash
# Build
docker build -t notes-app-k8s .
docker build -t ritik2909/notes-app-k8s .

# Tag
docker image tag notes-app-k8s:latest ritik2909/notes-app-k8s:latest

# Login + Push
docker login -u ritik2909
docker push ritik2909/notes-app-k8s:latest

# Verify
docker images
```

---

## ☸️ Django App on Kubernetes

```bash
# Apply all
kubectl apply -f namespace.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml

# Check
kubectl get pods -n notes-app
kubectl get svc -n notes-app
kubectl get all -n notes-app

# Logs
kubectl logs -f deployment/notes-app-deployment -n notes-app

# Restart deployment (after image update)
kubectl rollout restart deployment notes-app-deployment -n notes-app
```

---

## 🔀 Ingress Controller

```bash
# Install NGINX Ingress for KIND
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Check ingress controller
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

# Apply ingress rules
kubectl apply -f ingress.yml

# Check ingress
kubectl get ingress -n nginx
kubectl get ingress -A                  # all namespaces
kubectl describe ingress nginx-notes-ingress -n nginx

# Access
# http://<ec2-ip>:9090/nginx → nginx service
# http://<ec2-ip>:9090/     → notes-app service
```

---

## 📋 Ingress YAML Template

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-notes-ingress
  namespace: nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /nginx
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: notes-app-services
            port:
              number: 8000
```

---

## 🔍 Useful Debug Commands

```bash
# All resources in namespace
kubectl get all -n nginx
kubectl get all -n ingress-nginx

# Check what's using a port
lsof -i :9090
lsof -i :8080

# Background jobs management
jobs                    # list background jobs
kill %1                 # kill job number 1
fg %1                   # bring job to foreground
```

---

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
