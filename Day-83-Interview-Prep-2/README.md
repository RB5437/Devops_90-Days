# Day 83 — Interview Preparation: Networking + Shell Scripting

**Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90) | **Target:** 10+ LPA / 3+ years experience bar

---

## 🎯 Today's Focus

Continued the senior-calibrated interview-prep stretch with **Networking** and **Shell Scripting** — same format as Day 82: **20 Basic + 10 Advanced + 10 Scenario (STAR format)** per topic, every question sourced from real interview experiences or verified 2026 DevOps question banks (sources noted under each question in the docs).

---

## 📋 Topics Covered

### 1. Networking (`Day3_Networking_Interview_Prep.docx`)
- **Basic (20):** OSI model, TCP vs UDP, DNS resolution flow, common ports, CIDR/subnetting, Security Group vs NACL, Internet Gateway vs NAT Gateway, DNS TTL, reverse proxy, MTU, VPN, and a real interview question — **PUT vs POST** in REST APIs
- **Advanced (10):** TCP 3-way handshake depth, NAT internals, DNS caching at cutover scale, Layer 4 vs Layer 7 load balancing, CNI plugins, BGP, VXLAN, service mesh, NAT Gateway cost optimization, network segmentation
- **Scenario (10):** website unreachable, "works from some networks not others," private-subnet NAT failure, DNS TTL cutover split-brain, DNS propagation with a CDN-cache twist, Kubernetes CNI missing, Kubernetes Service endpoint mismatch, load-balancer health-check flapping, a real interview question — **502 Bad Gateway troubleshooting**, and VPN/hybrid-connectivity drops

### 2. Shell Scripting (`Day4_ShellScripting_Interview_Prep.docx`)
- **Basic (20):** shebang, variables, quoting, loops, functions, positional arguments, `grep`/`sed`/`awk`, exit codes, file-existence checks, finding/deleting old files, bulk file renaming, arrays and associative arrays, debugging with `set -x`, config validation, `sh` vs `bash` vs `source`
- **Advanced (10):** `set -euo pipefail` in depth, secrets leaking via `set -x`, `trap` for guaranteed cleanup, `$()` vs backticks, real `sed` pipeline patterns, retry loops for flaky commands, ShellCheck in CI/CD, testing scripts with `bats`/`shunit2`, secrets handling in pipelines, arrays vs associative arrays
- **Scenario (10):** a backup script silently failing for weeks, safely bulk-editing 200 config files, cron-vs-manual environment mismatch, wait-for-dependency pattern in containers, an O(n×m) log-processing slowdown, a hardcoded secret found in Git, config validation before deploy, a Jenkins shell step masking a real failure, a self-maintaining log-archival script, and testing a critical script with `bats`

---

## 💡 Key Takeaway

Networking and shell scripting are where "I know the command" and "I know why it broke in production" diverge the most. A 502 isn't a load-balancer config problem 90% of the time — it's a backend/target-group health problem. A cron job that "just fails sometimes" is almost never actually random — it's PATH or environment. Recognizing these patterns fast is what the scenario round is really testing.

---

## 📁 Reference

- `Day3_Networking_Interview_Prep.docx`
- `Day4_ShellScripting_Interview_Prep.docx`

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*
