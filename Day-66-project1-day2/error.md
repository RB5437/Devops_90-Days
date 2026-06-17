# 🔧 Day 66 — Errors Faced & Solutions

**Project:** Ultimate CI/CD Pipeline (Jenkins + SonarQube + Minikube + ArgoCD)
**Date:** 17 June 2026

---

## ❌ Error 1 — Docker Permission Denied

**Error Message:**
```
ubuntu@ip-172-31-80-153:~$ docker ps
permission denied while trying to connect to the docker API at unix:///var/run/docker.sock
```

**Cause:**
User was added to the `docker` group, but the current shell session hadn't refreshed group membership yet. Linux loads group permissions only at login — adding a user to a group mid-session doesn't apply until the session refreshes.

**Solution:**
```bash
newgrp docker
exit
newgrp docker
docker ps
```
`newgrp docker` starts a new shell with the `docker` group applied immediately, without needing to log out and back in.

**Verify Fix:**
```bash
docker ps
# CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
# (empty output = working, no error!) ✅
```

---

## ❌ Error 2 — SonarQube "Site Can't Be Reached" (Connection Refused)

**Error Message:**
```
35.175.152.253:9000
This site can't be reached.
35.175.152.253 refused to connect.
ERR_CONNECTION_REFUSED
```

**Cause:**
SonarQube takes 30-60 seconds to fully initialize after the container/service starts — its internal Elasticsearch + web server need time to boot up. Trying to access it too early results in connection refused.

**Solution:**
Simply wait and refresh — SonarQube shows a proper loading screen once the service responds:
```
SonarQube is starting... (with a loading spinner)
```
After ~30-60 seconds, refresh the page again → login screen appears.

**Verify Fix:**
```bash
# Check SonarQube logs (if self-hosted, not Docker)
sudo systemctl status sonarqube
# OR if using Docker:
docker logs <sonarqube-container-id>
# Look for: "SonarQube is operational"
```

---

## ⚠️ Warning 3 — Minikube Memory Allocation Too Close to System Limit

**Warning Message:**
```
The requested memory allocation of 3072MiB does not leave room for system 
overhead (total system memory: 3906MiB). You may face stability issues.
Suggestion: Start minikube with less memory allocated: 'minikube start --memory=3072mb'
```

**Cause:**
EC2 instance has only ~3906MiB total RAM. Allocating 3072MiB to minikube leaves barely 800MiB for the OS, Jenkins, SonarQube, and other running services — high risk of OOM (Out of Memory) crashes.

**Solution (for next time):**
```bash
minikube start --driver=docker --memory=2048mb
```
Leaves more headroom for the OS and other tools running on the same EC2 instance.

**Status:** Noted, not yet fixed — cluster still came up fine today since nothing else heavy was running simultaneously. Will apply the fix before running the full pipeline (Jenkins + SonarQube + Minikube together).

---

## 📊 Summary Table

| # | Error/Warning | Component | Severity | Status |
|---|---------------|-----------|----------|--------|
| 1 | Permission denied on docker.sock | Docker | Blocking | ✅ Fixed — `newgrp docker` |
| 2 | ERR_CONNECTION_REFUSED | SonarQube | Blocking (temporary) | ✅ Fixed — waited for startup |
| 3 | Memory allocation warning | Minikube | Non-blocking | ⚠️ Noted — will use `--memory=2048mb` next time |

---

## 🎓 Key Takeaway

Most "errors" on Day 1 of a new tool setup aren't actual bugs — they're **timing issues** (service still starting) or **session/permission issues** (group membership not refreshed). Reading the error message carefully before panicking saves a lot of time!

🔗 **GitHub:** https://github.com/RB5437/Devops_90-Days
