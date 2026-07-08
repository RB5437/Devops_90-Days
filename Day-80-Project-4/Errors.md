# Day 80 — Errors & Solutions

## Error 1 — MongoDB CrashLoopBackOff: Kernel Incompatibility with `mongo:8.0`

**Command:**
```bash
kubectl apply -f mongodb.yaml
kubectl get pods
```

**Symptom:**
```
mongo-deployment-f7d5c5df4-dkdgx   0/1   ErrImagePull → ImagePullBackOff → CrashLoopBackOff
```

**Logs (`kubectl logs`):**
```
{"s":"F","c":"CONTROL","msg":"MongoDB cannot start: Linux kernel versions 6.19 and newer
has a known incompatibility with this version of MongoDB.
See https://jira.mongodb.org/browse/SERVER-121912 for more information."}
```

**Root Cause:**
`mongo:8.0` requires a kernel feature that isn't compatible with the kernel version running on this EC2 node (6.19+). Container pulled fine, but the `mongod` process itself refused to start (`F` = Fatal log level).

**Solution:**
Downgraded the image in `mongodb.yaml`:
```yaml
image: mongo:7.0   # was mongo:8.0
```
```bash
kubectl apply -f mongodb.yaml
kubectl rollout restart deployment mongo-deployment
```

**Result:** ✅ MongoDB pod came up `1/1 Running`

---

## Error 2 — Old ReplicaSet Kept Spawning Crashed Pods After the Fix

**Symptom:**
Even after switching to `mongo:7.0` and deleting the crashing pod multiple times, a **new crashing pod kept appearing** with the same old ReplicaSet hash (`mongo-deployment-6f95cd7fbd`):
```bash
kubectl delete pod mongo-deployment-6f95cd7fbd-dgcj5
# pod deleted...
kubectl get pods
mongo-deployment-6f95cd7fbd-rdkjg   0/1   CrashLoopBackOff   # a NEW one appears
```

**Root Cause:**
`kubectl edit`/apply had created a new revision, but the **old ReplicaSet's `desired` count was still 1** — the Deployment controller kept reconciling it back up every time the pod was deleted, since the ReplicaSet object itself wasn't removed.

**Solution:**
1. Checked revision history: `kubectl rollout history deployment mongo-deployment`
2. Rolled back to the last known-good revision: `kubectl rollout undo deployment mongo-deployment --to-revision=2`
3. Explicitly deleted the stale ReplicaSets: `kubectl delete replicaset mongo-deployment-6f95cd7fbd mongo-deployment-f7d5c5df4`

**Result:** ✅ Only one healthy ReplicaSet (`mongo-deployment-7874cfd947`) remained, pod stable.

**Lesson:** Deleting a *pod* doesn't stop its ReplicaSet from recreating it. Fix the Deployment/ReplicaSet, not just the pod.

---

## Error 3 — Docker Push Denied Again: `insufficient_scope`

**Command:**
```bash
docker push ritik2909/backend-wanderlust:latest
```

**Error:**
```
push access denied, repository does not exist or may require authorization:
server message: insufficient_scope: authorization failed
```

**Root Cause:**
Docker session on this EC2 node had an expired/old login. Same class of issue as Day 79 (PAT scope), but this time it was a stale login, not token permissions.

**Solution:**
```bash
docker login -u ritik2909
docker push ritik2909/backend-wanderlust:latest
```

**Result:** ✅ Push succeeded once re-authenticated.

---

## Error 4 — Backend & Frontend Pods Stuck in `ImagePullBackOff`

**Symptom:**
```bash
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml
kubectl get all
```
```
pod/backend-deployment-86f5d58f85-v5rlb    0/1   ImagePullBackOff
pod/frontend-deployment-54874cf85f-hcn24   0/1   ImagePullBackOff
```

**Root Cause:**
Manifests referenced `ritik2909/backend-wanderlust:latest` / `ritik2909/frontend-wanderlust:latest`, but the freshly rebuilt images hadn't finished pushing to DockerHub yet (blocked by Error 3 above) — the cluster tried to pull an image that either didn't exist yet or wasn't accessible.

**Solution:**
Fixed the DockerHub auth issue first, pushed both images, then:
```bash
kubectl rollout restart deployment backend-deployment
kubectl rollout restart deployment frontend-deployment
```

**Result:** ✅ Both pods came up `1/1 Running` on next scheduling attempt.

---

## Error 5 — Backend Crash: `MongooseServerSelectionError: getaddrinfo EAI_AGAIN mongo-service`

**Logs:**
```
connection error: mongodb://mongo-service/wanderlust
MongooseServerSelectionError: getaddrinfo EAI_AGAIN mongo-service
[nodemon] app crashed - waiting for file changes before starting...
```

**Debug Steps:**
```bash
kubectl exec -it deployment/backend-deployment -- cat /etc/resolv.conf
# nameserver 10.96.0.10 — looked correct

kubectl get pods -n kube-system | grep coredns
# all 4 CoreDNS pods Running

kubectl describe svc mongo-service
# Endpoints: 192.168.85.4:27017 — service had a valid endpoint
```

**Root Cause:**
DNS resolution for `mongo-service` was **transiently unavailable** right when the backend pod first started (likely a race — backend pod started before CoreDNS/kube-proxy fully synced the new service's DNS record). Everything checked out fine on inspection — CoreDNS healthy, resolv.conf correct, endpoint present.

**Solution:**
```bash
kubectl rollout restart deployment backend-deployment
```

**Result:** ✅ On restart, DNS resolved correctly:
```
Database connected: mongodb://mongo-service/wanderlust
Redis Connected: redis://redis-service:6379
```

**Lesson:** If a pod crashes on a DNS lookup right after a dependent Service is created, a restart is often enough — it's a startup race, not a config bug. Confirm with `resolv.conf` + `describe svc` before spending time "fixing" a config that's actually correct.

---

## Error 6 — Wrong `FRONTEND_URL` Port in `.env.docker`

**Symptom:**
Backend's env had:
```
FRONTEND_URL=http://34.236.151.105:5173
```
but the actual externally-reachable frontend NodePort is `31000` (from `frontend-service`), not the container's internal port `5173`.

**Root Cause:**
`.env.docker` was written using the container's internal port instead of the NodePort exposed by the Service — copy-paste leftover from local/docker-compose setup where `5173` was directly reachable.

**Solution:**
```
FRONTEND_URL=http://34.236.151.105:31000
```
Rebuilt and re-pushed the backend image, then `kubectl rollout restart deployment backend-deployment`.

**Result:** ✅ CORS/redirect URLs from backend now point to the correct externally-reachable frontend address.

---

## Non-Issues Encountered (Noted, Not Bugs)

- **`error: the server doesn't have a resource type "endpointskubectl"`** — self-inflicted typo (two commands got concatenated in the terminal), not an actual cluster problem. `kubectl get endpoints` on its own worked fine.
- **`kubectl exec -it ... -- nslookup mongo-service` → `nslookup: not found`** — expected; the `node:22-slim` base image doesn't ship DNS utilities. Used `cat /etc/resolv.conf` and `describe svc` instead to debug DNS.
- **`kubectl exec -it` panic (`nil pointer dereference` in `terminalSizeQueueAdapter`)** — a client-side `kubectl` bug when handling terminal resize during an interactive exec session over SSH; unrelated to the app or cluster health. Re-running the command without `-it` (or in a stable terminal) avoided it.

---

## Test Suite Status (Carried Over from Day 79 — Unchanged)

```
Test Suites: 1 failed, 1 passed, 2 total
Tests:       9 failed, 28 passed, 37 total
```
All 9 failures are integration tests requiring a live MongoDB connection during `npm run test` inside `docker build` — same root cause documented on Day 79, still not fixed. Planned for Day 81: run integration tests against a real test-DB container, separate from the image build step.
