# Day 85 — Interview Preparation: Docker (Day 1 + Day 2)

**Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90) | **Target:** 10+ LPA / 3+ years experience bar

---

## ⚠️ Status: Files pending upload to this folder

This README is written to match the Docker interview-prep content already built — **`Day8_Docker_Interview_Prep.docx`** and **`Day9_Docker_Interview_Prep.docx`** — but those two files aren't in this folder yet. Add them here (same filenames) and this README will be accurate.

---

## 🎯 Focus (once files are added)

The full 2-day Docker block, same senior-calibrated format as every prior day: **20 Basic + 10 Advanced + 10 Scenario (STAR format)** per day, sourced from real interview posts shared earlier in this journey (Ansh Saxena, Kyndryl, James R.) plus verified 2026 Docker interview banks (KodeKloud, Hirist, DataCamp, Second Talent, WeCreateProblems, Cloud Soft Solutions).

---

## 📋 Topics Covered

### 1. Docker, Day 1 of 2 (`Day8_Docker_Interview_Prep.docx`)
- **Basic (20):** Image vs Container, Dockerfile instructions, WORKDIR, ENTRYPOINT vs CMD, `COPY app.jar app.jar` vs `COPY . .`, `docker run` flags, volumes vs bind mounts, networking modes, docker-compose, `depends_on` gotcha, environment-specific config — several sourced directly from your real screenshots (Ansh Saxena, James R.)
- **Advanced (10):** namespaces + cgroups isolation mechanism in depth, single-stage vs multi-stage builds with real measured numbers (1.27GB → 15.5MB), why `latest` breaks production, image optimization techniques, container security checklist, build-cache mechanism, health checks/restart policies, "is your Dockerfile production-ready?" audit checklist
- **Scenario (10):** deployment succeeded but app unreachable (127.0.0.1 vs 0.0.0.0), container exits instantly (PID 1 issue), two containers can't talk (localhost trap), stale volume masking a rebuild, exit code 137 (OOMKilled), Jenkins Docker-socket permission fix, 80x image-size reduction via multi-stage, secret baked into an image layer, `depends_on` readiness gotcha, staging-vs-prod behavior mismatch

### 2. Docker, Day 2 of 2 (`Day9_Docker_Interview_Prep.docx`)
- **Basic (20):** Compose YAML structure, build args (ARG vs ENV), custom networks, log management, Docker Swarm basics, Docker-in-Docker, image vulnerability scanning, blue-green concept, container lifecycle hooks, env-var precedence, restart policies, overlay networks, CPU/memory limits
- **Advanced (10):** Compose vs Swarm vs Kubernetes trade-offs, overlay networking at the packet level (VXLAN), canary/blue-green implementation depth, DinD security risk + Kaniko/Buildah as the safer alternative, multi-host networking at scale, secrets management comparison (Swarm vs Kubernetes vs Vault), CPU shares vs quota, zero-downtime deployment on Swarm specifically, centralized logging/monitoring, "build once, promote everywhere"
- **Scenario (10):** Compose scaling wall → Swarm migration, CI container-failure debugging, zero-downtime Swarm rolling update, disk-filling logs, DinD security remediation, override file leaking to production, cross-host MTU networking bug, canary rollout catching a bug at 25%, noisy-neighbor CPU starvation, staging-vs-prod drift fixed via immutable image promotion

---

## 💡 Key Takeaway

Almost every hard Docker question reduces to one of two ideas: **layers** (the build, the cache, image size) or **isolation** (namespaces, cgroups, the shared kernel). Tying an answer back to the right one — rather than reciting syntax — is what separates a senior-sounding answer from a memorized one.

---

## 📁 Reference

- `Day8_Docker_Interview_Prep.docx`
- `Day9_Docker_Interview_Prep.docx`

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*
