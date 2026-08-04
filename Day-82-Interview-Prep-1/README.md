# Day 82 — Interview Preparation: Linux (Basic → Advanced → Addendum)

**Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90) | **Target:** 10+ LPA / 3+ years experience bar

---

## 🎯 Today's Focus

Rebuilt Linux interview prep from the ground up at a **senior/3+ years experience calibration** — not fresher-level definitions, but trade-off reasoning, internals, and real production RCA depth. Every question is sourced from actual posted interview experiences (LinkedIn) or verified 2026 DevOps/SRE interview question banks — sources are noted under each question in the docs, nothing invented.

Format used throughout: **20 Basic + 10 Advanced + 10 Scenario (STAR format)** per document — a deliberate move away from the earlier 10+5+5 pass, to go deeper and cover more real-world ground per topic.

---

## 📋 Topics Covered

### 1. Linux — Full Depth (`Day1_Linux_Interview_Prep_FULL.docx`)
- **Basic (20):** file system hierarchy, permissions, process vs thread, hard vs soft links, execute permissions, cgroups + namespaces (how Docker actually isolates), `grep`/`awk`/`sed`, package managers, inodes, `find`, iptables basics, `fork()` vs `exec()`
- **Advanced (10):** `kill -9` vs `-15`, load average, zombie processes, `ulimit`, SWAP, systemd unit files, LVM live extend, `apt`/`yum` internals, cron vs systemd timers, iptables/firewalld/nftables chains
- **Scenario (10):** real Kyndryl-interview questions (app unavailable, identifying high-CPU processes, server unreachable) + disk full, Docker socket permission denied, SSH access issues, OOM killer, systemd post-reboot failure, cron silent failure, dependency errors

### 2. Linux Advanced — Senior Level (`Day2_Linux_Advanced_Senior_Interview_Prep.docx`)
- **Basic (20):** boot process internals, RAID levels, SELinux modes, `strace` vs `ltrace` vs `perf`, kernel panics, `sysctl`, NFS mount options, containers vs VMs, core dumps, CPU steal time
- **Advanced (10):** storage design for write-heavy databases (RAID10 + XFS), production hardening approach, `perf`-based slow-box debugging, capacity planning, memory leak vs cache growth, MTTR reduction strategy, container escape risk, config drift diagnosis
- **Scenario (10):** inode exhaustion ("disk not full but full"), SELinux denial after hardening, RAID-degraded-disk causing DB slowness, cloud CPU steal time, kernel panic rollback via `kdump`, iptables rule not persisting, memory-leak RSS-trend proof, fleet config drift RCA, MTTR runbook building, fleet-wide security remediation

### 3. Linux Addendum — Gaps From a Real Troubleshooting Cheat Sheet (`Linux_Addendum_Interview_Prep.docx`)
Covers exactly what wasn't already in the two docs above, cross-checked against a real "Common Troubleshooting for Linux" reference sheet: boot failure/rescue mode, network command-level flow (`ip a` / `ip r` / `resolv.conf`), SSH permission specifics (700/600), NTP/clock drift (with a real "intermittent TLS failure" scenario), mount/unmount busy-device fix, SELinux-specific fix commands, and package-manager lock files — each with a full STAR scenario.

---

## 💡 Key Takeaway

At the 3+ years / 10+ LPA bar, interviewers aren't testing whether you know a command exists — they're testing whether you can reason about **trade-offs** (RAID10 vs XFS, rebase vs merge, Vault vs env vars) and whether your troubleshooting **story** shows a systematic sequence (not a lucky guess). Real, sourced questions matter more than invented ones because they show what's actually being asked in the room right now.

---

## 📁 Reference

- `Day1_Linux_Interview_Prep_FULL.docx`
- `Day2_Linux_Advanced_Senior_Interview_Prep.docx`
- `Linux_Addendum_Interview_Prep.docx`

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*
