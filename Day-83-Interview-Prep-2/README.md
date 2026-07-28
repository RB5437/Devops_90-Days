# Day 83 — Interview Preparation: Day 2 (Linux Advanced)

**Date:** 28 July 2026 | **Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90)

---

## 🎯 Today's Focus

Continued the interview-prep stretch with **Linux Advanced** — systemd, cron internals, logging, disk/LVM management, and package management internals. Same format as Day 82: **10 Basic + 5 Advanced + 5 Scenario (STAR format)** questions.

---

## 📋 Topics Covered

### Basic (10 Q&A)
systemd and service management (`systemctl status/enable`), cron syntax, `journalctl` vs `/var/log/syslog`, package manager dependency resolution, `df` vs `du`, LVM basics, checking/managing SWAP.

### Advanced (5 Q&A)
systemd unit file structure (`After=`, `Requires=`, `WantedBy=`), how log rotation works alongside the systemd journal, extending a filesystem live with LVM (no downtime), what happens internally during `apt install`/`yum install`, cron vs systemd timers and the classic "cron has a different PATH" gotcha.

### Scenario Round — STAR Format (5)
1. A critical service didn't restart after a reboot — debugging with `systemctl status` + `journalctl -u`
2. A cron job that worked manually but failed silently on schedule — traced to a missing PATH
3. Production disk hit 100% from runaway logs — fixed live using LVM extend, zero downtime
4. A package install failed with dependency errors — resolved by refreshing repo metadata first
5. A service stuck in a restart loop — traced back to the kernel OOM killer via `dmesg`

---

## 💡 Key Takeaway

Most "mysterious" Linux production issues aren't actually mysterious — they're a handful of repeat patterns (stale cron PATH, disk growth without rotation, OOM kills with no app-level error). Recognizing the pattern fast matters more than memorizing every flag.

---

## 📁 Reference

Full Q&A document: `Day2_Linux_Advanced_Interview_Prep.docx`

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*.
