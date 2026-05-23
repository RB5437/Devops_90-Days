# ⚡ Day 41 — StatefulSet Commands 

---

## 📦 Apply All Files

```bash
cd mysql/
kubectl apply -f namespace.yml
kubectl apply -f service.yml
kubectl apply -f statefulsets.yml

# Or apply all at once
kubectl apply -f .
```

---

## 🔍 StatefulSet Commands

```bash
# Get StatefulSet
kubectl get statefulset -n mysql
kubectl get sts -n mysql                    # short form
kubectl describe sts mysql-statefulset -n mysql

# Get pods (ordered naming!)
kubectl get pods -n mysql
# mysql-statefulset-0   1/1   Running ✅
# mysql-statefulset-1   1/1   Running ✅

# Watch pods start in order
kubectl get pods -n mysql -w

# Scale StatefulSet
kubectl scale sts mysql-statefulset -n mysql --replicas=3
kubectl scale sts mysql-statefulset -n mysql --replicas=1

# Delete StatefulSet (PVCs remain!)
kubectl delete sts mysql-statefulset -n mysql
```

---

## 💾 PVC Commands (volumeClaimTemplates)

```bash
# Get auto-created PVCs
kubectl get pvc -n mysql
# mysql-data-mysql-statefulset-0   Bound   1Gi ✅
# mysql-data-mysql-statefulset-1   Bound   1Gi ✅

# PVCs survive StatefulSet deletion!
kubectl delete sts mysql-statefulset -n mysql
kubectl get pvc -n mysql   # still there!

# Manually delete PVCs
kubectl delete pvc mysql-data-mysql-statefulset-0 -n mysql
kubectl delete pvc -n mysql --all
```

---

## 🌐 Headless Service Commands

```bash
kubectl apply -f service.yml
kubectl get svc -n mysql
# mysql-service   None   <none>   3306/TCP ← clusterIP: None

# Test DNS from inside cluster
kubectl run -it --rm debug --image=busybox -n mysql -- sh
nslookup mysql-service.mysql.svc.cluster.local
nslookup mysql-statefulset-0.mysql-service.mysql.svc.cluster.local
```

---

## 🗄️ Connect to MySQL Pod

```bash
# Enter the MySQL pod
kubectl exec -it mysql-statefulset-0 -n mysql -- bash

# Connect to MySQL
mysql -u root -proot
show databases;
use devops;
show tables;
```

---

## 📊 Resource Monitoring

```bash
# Check resource usage
kubectl top pods -n mysql
kubectl top nodes

# Describe pod to see resource requests/limits
kubectl describe pod mysql-statefulset-0 -n mysql
# Requests: cpu=100m, memory=128Mi
# Limits:   cpu=250m, memory=384Mi
```

---

## 🔁 StatefulSet Update Strategy

```bash
# Rolling update (default)
kubectl set image sts/mysql-statefulset mysql=mariadb:10.7 -n mysql
kubectl rollout status sts/mysql-statefulset -n mysql

# Rollback
kubectl rollout undo sts/mysql-statefulset -n mysql

# History
kubectl rollout history sts/mysql-statefulset -n mysql
```

---

## 🧹 Cleanup

```bash
# Delete everything in order
kubectl delete sts mysql-statefulset -n mysql
kubectl delete svc mysql-service -n mysql
kubectl delete pvc -n mysql --all
kubectl delete ns mysql
```

---

## 📝 Quick Reference — StatefulSet YAML Structure

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: <name>
  namespace: <ns>
spec:
  serviceName: <headless-service-name>   # REQUIRED
  replicas: <N>
  selector:
    matchLabels:
      app: <label>
  template:
    metadata:
      labels:
        app: <label>
    spec:
      containers:
      - name: <container>
        image: <image>
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "384Mi"
            cpu: "250m"
        volumeMounts:
        - name: <vol-name>
          mountPath: /data
  volumeClaimTemplates:              # Auto-creates PVC per pod
  - metadata:
      name: <vol-name>
    spec:
      accessModes: [ReadWriteOnce]
      resources:
        requests:
          storage: 1Gi
```

---

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
