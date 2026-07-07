# Day 79 — Errors & Solutions

## Error 1 — Docker Push Failed: "authentication required - access token has insufficient scopes"

**Command:**
```bash
docker push ritik2909/backend-wanderlust:latest
```

**Error:**
```
authentication required - access token has insufficient scopes
```

**Root Cause:**
DockerHub Personal Access Token (PAT) was created with **Read-only** permissions. Docker no longer allows password-based login — PAT is mandatory, but push requires **Read & Write** scope.

**Solution:**
1. Go to: `https://app.docker.com/accounts/ritik2909/settings/personal-access-tokens`
2. Generate new token → select **"Read & Write"** permissions
3. Run `docker logout` then `docker login -u ritik2909` with new token

**Result:** ✅ Both images pushed successfully after token fix

---

## Error 2 — Integration Tests Failed During Docker Build

**Where:** `docker build -t ritik2909/backend-wanderlust:latest .` — Step 5 `RUN npm run test`

**Error:**
```
MongooseError: The `uri` parameter to `openUri()` must be a string, got "undefined".
Make sure the first parameter to `mongoose.connect()` is a string.

Exceeded timeout of 5000 ms for a test.
```

**Tests Failed:** 9 integration tests failed out of 37 total

**Root Cause:**
Integration tests try to connect to a real MongoDB database, but during Docker build there is **no MongoDB running** — the container is being built, not deployed yet. `MONGODB_URI` is undefined inside the build environment, so `mongoose.connect(undefined)` throws an error. All 9 failing tests are integration tests that require a live DB connection.

**Unit tests:** 28/28 passed ✅ (these don't need DB connection)

**Important Note:**
This is **expected behavior** — the build still succeeded (`Successfully built 1dadedb45369`) because Docker treats failed tests as non-blocking in this Dockerfile. In production pipelines, integration tests should run against a test DB container, not inside the image build step.

**Solution (for future):**
Run integration tests separately with a test MongoDB instance, not inside Dockerfile:
```bash
# Separate test step before docker build
MONGODB_URI=mongodb://localhost/test npm run test
# Then build image
docker build -t ritik2909/backend-wanderlust:latest .
```

---

## Error 3 — CoreDNS Pods All Stuck on Master Node

**Observation:**
After cluster setup, both CoreDNS pods were running only on master node (`ip-172-31-29-72`), even after worker node joined.

**Root Cause:**
CoreDNS by default runs with `replicas: 2`, and both pods were scheduled before worker node joined. CoreDNS has a `podAntiAffinity` rule that "prefers" spreading pods, but it's not enforced — so both landed on master.

**Solution:**
Scaled CoreDNS to 4 replicas:
```bash
kubectl edit deploy coredns -n kube-system
# replicas: 2 → 4
```

**Result:** ✅ 2 new pods scheduled on worker node, DNS now spread across both nodes:
```
coredns pods on ip-172-31-22-15 (worker)  → 2 pods
coredns pods on ip-172-31-29-72 (master)  → 2 pods
```
