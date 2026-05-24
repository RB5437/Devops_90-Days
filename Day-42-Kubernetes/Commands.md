# ⌨️ Day 42 — Commands Reference

## ConfigMap
```bash
kubectl apply -f configMap.yml
kubectl get configmap -n mysql
kubectl describe configmap mysql-config-map -n mysql
```

## Secrets
```bash
echo "root" | base64                    # Encode
echo "cm9vdAo=" | base64 --decode       # Decode

kubectl apply -f secrets.yml
kubectl get secret -n mysql
kubectl describe secret mysql-secret -n mysql
```

## Resource Limits — Verify
```bash
kubectl describe pod <pod-name> -n nginx
# Check: Limits & Requests section
free -h     # Node memory
df -h       # Node disk
```

## Probes — Verify
```bash
kubectl describe pod notes-app-deployment-78cfbfdc7c-2qd86 -n nginx
# Check: Liveness + Readiness probe sections
kubectl get pods -n nginx   # Should show Running + Ready 1/1
```

## Taints & Tolerations
```bash
# Add taint
kubectl taint node rbb-cluster-worker  prod=true:NoSchedule
kubectl taint node rbb-cluster-worker2 prod=true:NoSchedule

# Check effect — pod goes Pending
kubectl get pods -n nginx
kubectl describe pod nginx -n nginx   # See: FailedScheduling events

# Remove taint (dash at end!)
kubectl taint node rbb-cluster-worker2 prod=true:NoSchedule-

# Pod now runs on untainted node
kubectl get pods -n nginx   # Running ✅
```

## Metrics Server (required for HPA)
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system edit deployment metrics-server
# Add under args: --kubelet-insecure-tls
kubectl -n kube-system rollout restart deployment metrics-server
kubectl get pods -n kube-system   # metrics-server Running
kubectl top node
kubectl top pod -n <ns>
```

## HPA
```bash
kubectl apply -f hpa.yml
kubectl get hpa -n apache
kubectl describe hpa apache-hpa -n apache

# Manual scale (test before HPA)
kubectl scale deployment apache-deployment -n apache --replicas=2
kubectl scale deployment apache-deployment -n apache --replicas=3
kubectl scale deployment apache-deployment -n apache --replicas=1

# Generate load for HPA test
kubectl run load-generator --image=busybox --restart=Never -- \
  /bin/sh -c "while true; do wget -q -O- http://apache-service.apache; done"
```

## VPA
```bash
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler/
./hack/vpa-up.sh

kubectl apply -f vpa.yml
kubectl get vpa -n apache
kubectl describe vpa apache-vpa -n apache
```

## Port Forward (access app locally)
```bash
kubectl port-forward svc/apache-service -n apache 8082:80 --address=0.0.0.0
# Access: http://<EC2-IP>:8082

# Kill stuck port-forward
sudo lsof -i :8082
kill -9 <PID>
```

## MySQL + ConfigMap + Secret Combined
```bash
kubectl apply -f namespace.yml
kubectl apply -f configMap.yml
kubectl apply -f secrets.yml
kubectl apply -f service.yml
kubectl apply -f statefulsets.yml
kubectl get pods -n mysql          # Running ✅
kubectl exec -it mysql-statefulset-0 -n mysql -- bash
# Inside: mysql -u root -p → show databases;
```
