# Day 82 — Interview Preparation: Day 1 (Linux Basics)

**Date:** 27 July 2026 | **Challenge:** #90DaysOfDevOps | **Phase:** Interview Prep (Day 81–90)

---

## 🎯 Today's Focus

Started structured interview preparation — revisiting every topic from Day 1 (Linux) through an interview lens rather than a "learning" lens. Format followed for every topic going forward: **10 Basic Q&A + 5 Advanced Q&A + 5 Scenario Questions in STAR format**, so answers are ready to speak out loud, not just understood conceptually.

Today's topic: **Linux — Basic to Advanced**, plus real troubleshooting scenarios.

---

## 📋 Topics Covered

### Basic (10 Q&A)
Linux file system hierarchy, file permissions (`chmod`), process vs thread, soft vs hard links, `grep`/`awk`/`sed`, shells, checking running processes, package managers (`apt` vs `yum`), environment variables, `ls -l` output interpretation.

### Advanced (5 Q&A)
`kill -9` vs `kill -15`, interpreting load average, zombie processes, `ulimit` soft/hard limits, SWAP space usage and risks.

### Scenario Round — STAR Format (5)
1. Debugging a production server that suddenly became slow (systematic CPU → memory → disk → network → logs approach)
2. Handling a disk-full emergency on a live production server without downtime
3. Fixing a Docker socket permission error in a Jenkins pipeline (tied directly back to Project 1)
4. Diagnosing "can't SSH into a server" — separating network/Security-Group issues from service-level issues
5. Tracing an OOM-killed process using `dmesg` when the application's own logs showed nothing

---

## 💡 Key Takeaway

Knowing a command isn't the same as being able to explain **why** you'd reach for it under pressure. STAR-formatting real (or realistic) troubleshooting stories is what actually lands well in interviews — interviewers remember stories, not command lists.

---

## 📁 Reference

Full Q&A document: `Day1_Linux_Interview_Prep.docx` (Basic + Advanced + Scenario sections)

---

*Part of the #90DaysOfDevOps interview-prep stretch (Day 81–90) — Ritik Bawane*
