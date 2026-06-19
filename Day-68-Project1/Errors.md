# Day 68 — Errors Faced & Solutions 🐛

This document covers every real error encountered while building the CI/CD pipeline, in the exact order they occurred, with root cause and fix.

---

## Error 1 — Jenkins Pipeline Build #1 FAILED

### What Happened
First pipeline run failed almost immediately — only "Checkout SCM" and "Post Actions" stages ran. All middle stages (Build, SonarQube, Docker) never executed.

### Root Cause
Jenkinsfile path or initial pipeline configuration was incomplete — pipeline job was still being configured for the first time (credentials, plugins not fully set up yet).

### Fix
- Verified Script Path was correct: `java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile`
- Confirmed all required plugins were installed (Docker Pipeline, SonarQube Scanner, Pipeline Stage View)
- Re-ran the build

### Result
Build #2 progressed much further — proof that plugin/config fix worked.

---

## Error 2 — Jenkins Pipeline Build #2 FAILED at "Update Deployment File" Stage

### What Happened
```
Stage View:
Checkout SCM       ✅ 409ms
Checkout           ✅ 1s
Build and Test     ✅ 25s
Static Code Analysis ✅ 1min 3s
Build and Push Docker Image ✅ 14s
Update Deployment File  ❌ 776ms FAILED
```

### Root Cause
The `sed` command that updates the image tag in `deployment.yml`, followed by `git push`, failed — most likely due to:
- GitHub credentials (`github` ID) not having write/push access configured correctly, OR
- The git push step missing proper remote URL with embedded credentials

### Fix
- Re-checked the `github` credential in Jenkins (Secret Text with GitHub Personal Access Token)
- Confirmed the Jenkinsfile git push stage used the correct credential binding:
```groovy
withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
    sh '''
        git config user.email "ritikbawane5437@gmail.com"
        git config user.name "ritik bawane"
        git add .
        git commit -m "Update deployment image to version 3"
        git push https://${GITHUB_TOKEN}@github.com/RB5437/Ultimate-CI-CD-Pipeline-Jenkins-End-to-End-Project HEAD:main
    '''
}
```

### Result
Build #3 — ALL STAGES GREEN ✅ — full pipeline success in 1min 46s.

---

## Error 3 — ArgoCD Login Password Not Found (Operator-based ArgoCD)

### What Happened
```bash
kubectl get secret example-argocd-cluster -n default \
  -o jsonpath="{.data.['admin\.password']}" | base64 -d; echo
# (empty output)

kubectl get secret example-argocd-secret -n default \
  -o jsonpath="{.data.['admin\.password']}" | base64 -d; echo
# Error from server (NotFound): secrets "example-argocd-secret" not found

kubectl get secret argocd-initial-admin-secret -n default \
  -o jsonpath="{.data.password}" | base64 -d; echo
# Error from server (NotFound): secrets "argocd-initial-admin-secret" not found
```

### Root Cause
Standard ArgoCD (Helm install) stores the admin password in a secret called `argocd-initial-admin-secret`. But this setup used the **ArgoCD Operator** (installed via OperatorHub/OLM), which stores the password differently — under `example-argocd-cluster` secret, with the key needing proper escaping.

Also — double quotes (`"`) in the jsonpath command interpret the `\.` escape character differently in bash than single quotes (`'`), which caused empty results.

### Fix
Used single quotes instead of double quotes, and dumped all keys to find the correct one:
```bash
kubectl get secret example-argocd-cluster -n default \
  -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{$v | base64decode}}{{"\n"}}{{end}}'
```

This revealed:
```
admin.password: MGljbHo0dzhLRUMzaldOUVNZNWJwUm9uSVRYWlZERmc=
```

Decoded:
```bash
echo "MGljbHo0dzhLRUMzaldOUVNZNWJwUm9uSVRYWlZERmc=" | base64 -d; echo
# Output: 0iclz4w8KEC3jWNQSY5bpRonITXZVDFg
```

### Result
Successfully logged into ArgoCD UI with username `admin` and the decoded password.

---

## Error 4 — ArgoCD Application "test" — 3 Errors, Health: Missing

### What Happened
After creating the ArgoCD Application, the UI showed:
```
APP HEALTH: Missing
APP CONDITIONS: 3 Errors

1. ComparisonError:
   Failed to load live state: cluster level Deployment "spring-boot-app"
   can not be managed when in namespaced mode

2. InvalidSpecError:
   Namespace for spring-boot-app apps/v1, Kind=Deployment is missing.

3. InvalidSpecError:
   Namespace for spring-boot-app-service /v1, Kind=Service is missing.
```

### Root Cause
The Kubernetes manifest files (`deployment.yml`, `service.yml`) in the repo did **not specify a `namespace` field**. The ArgoCD Application was configured to deploy into the `default` namespace, but since the manifests themselves had no namespace defined, ArgoCD's namespaced-mode controller could not properly match and manage the Deployment/Service objects — it expected each resource to declare its namespace explicitly.

### Fix
- Ensured the ArgoCD Application's **Destination → Namespace** field was explicitly set to `default`
- Confirmed manifests were applied with the namespace properly inherited from the ArgoCD Application destination (rather than relying on the manifest YAML to specify it)
- Triggered a **Refresh + Sync** from the ArgoCD UI

### Result
```
Status: 💚 Healthy   ✅ Synced
Last Sync: Succeeded
Resource Tree:
  spring-boot-app-service  → Synced, Healthy
  spring-boot-app (Deploy) → Synced, Healthy
    → ReplicaSet spring-boot-app-58bddd9d8d
        → 2/2 pods Running
```

---

## Error 5 — Browser Could Not Access Spring Boot App (Minikube Internal IP)

### What Happened
```bash
minikube service spring-boot-app-service --url
# http://192.168.49.2:31375
```
Opening `http://192.168.49.2:31375` in the browser did not work.

### Root Cause
`192.168.49.2` is Minikube's **internal Docker network IP**, only reachable from inside the EC2 instance — not from an external browser.

### Fix
Used `kubectl port-forward` to bridge the EC2's public-facing port to the internal service, then opened the EC2 Security Group for that port:
```bash
kubectl port-forward --address 0.0.0.0 svc/spring-boot-app-service 8085:80 &
```
AWS Console → EC2 → Security Groups → Inbound Rules:
```
Type: Custom TCP | Port: 8085 | Source: 0.0.0.0/0
```

### Result
```
http://18.206.219.155:8085

"Ultimate CI/CD Pipeline using Java"
"I have successfully built a spring boot application using Maven"
"This application is deployed onto Kubernetes using ArgoCD"
```
✅ App fully accessible from browser — project complete.

---

## Summary — All Errors & Fixes

| # | Error | Root Cause | Fix |
|---|-------|-----------|-----|
| 1 | Build #1 failed early | Plugins/config incomplete | Verified plugins + script path |
| 2 | Build #2 failed at deployment update | GitHub credential push issue | Fixed credential binding in Jenkinsfile |
| 3 | ArgoCD admin password not found | Operator stores password differently than Helm install | Used go-template to dump all secret keys, found `admin.password` |
| 4 | ArgoCD app — 3 errors, Missing health | Manifests missing namespace field | Set namespace at ArgoCD Application destination level |
| 5 | Browser can't reach app | Minikube internal IP not externally routable | kubectl port-forward + Security Group port open |
