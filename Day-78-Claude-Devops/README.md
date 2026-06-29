# Day 78 — Installing Claude Code on Windows 🤖💻

## What This Day Covered

Today's focus was getting **Claude Code** (Anthropic's agentic coding CLI) properly installed and running on Windows — and understanding exactly which login method is free versus paid, since this tripped up the setup more than once.

**Reference:** "Claude Code In One Shot — Build Production Ready Apps | 2026" (TrainWithShubham)

---

## What Is Claude Code?

An agentic AI coding assistant by Anthropic that runs directly in the terminal — instead of copy-pasting code between a browser and your editor, Claude Code can read your project files, write code, run commands, and fix bugs directly inside your working directory.

```
1. Introduction to Claude Code
2. How to install Claude Code
3. The core loop (how it works)
4. Permission modes explained
5. What is CLAUDE.md
6. Auto memory
```

---

## Installation Journey — What Actually Happened

### Attempt 1 — Git Bash (Failed)
```bash
curl -fsSL https://claude.ai/install.sh | bash
# ❌ Doesn't work — this is the macOS/Linux installer, not for native Windows
```

**Lesson:** Claude Code's official installer is OS-specific. The `curl | bash` one-liner is for macOS/Linux only.

### Attempt 2 — PowerShell (Correct method)
```powershell
irm https://claude.ai/install.ps1 | iex
```
This is `Invoke-RestMethod` (downloads the script) piped into `Invoke-Expression` (runs it) — the official native Windows installer.

### Issue — PATH Not Set
After install, `claude --version` returned "command not found" because the binary was installed to `C:\Users\HP\.local\bin` but that folder wasn't in PATH yet.

**Fix applied:**
```powershell
$env:PATH += ";C:\Users\HP\.local\bin"
claude --version
# Welcome to Claude Code v2.1.195
```

### Result
```
PS C:\Users\HP> claude
Welcome to Claude Code v2.1.195

Claude Code can be used with your Claude subscription or billed
based on API usage through your Console account.

Select login method:
> 1. Claude account with subscription · Pro, Max, Team, or Enterprise
  2. Anthropic Console account · API usage billing
  3. 3rd-party platform · Amazon Bedrock, Microsoft Foundry, or Vertex AI
```

---

## Important Lesson — Free vs Paid (This Was the Real Confusion Today)

| Login Method | Cost | Notes |
|--------------|------|-------|
| **Option 1 — Claude subscription** (Pro/Max/Team/Enterprise) | Subscription cost (e.g. Pro ~$20/mo) | Claude Code usage is *included* in the plan |
| **Option 2 — Anthropic Console (API billing)** | Pay-per-token | This is what got accidentally selected — leads to per-request charges |
| **Option 3 — 3rd-party (Bedrock/Foundry/Vertex)** | Billed via that cloud platform | Same per-token billing model, through AWS/Azure/GCP instead |
| **Free claude.ai account (no subscription)** | Does **not** unlock Claude Code | The free web chat plan alone is not enough |

**Key takeaway:** Claude Code itself is never "free forever" — it always needs either an active paid subscription (Option 1) or a billed API/cloud account (Options 2 or 3). There is no genuinely free tier for the CLI tool.

---

## Separate Tool, Different Story — Ollama

While debugging the Claude Code billing confusion, it became clear that the **Ollama + local model (e.g. `llama3.2`, `gemma`)** setup from Day 76-77 is the actually-free path — it runs entirely on the local machine with no API billing at all:

```bash
ollama run llama3.2
# 100% free — runs locally, no token billing
```

This is a useful distinction for explaining in an interview: **Claude Code** = a paid, hosted, agentic coding assistant; **Ollama** = a free, local LLM runtime with no built-in coding-agent features.

---

## Why Learn Claude Code as a DevOps Engineer

| Use Case | Example |
|----------|---------|
| Explain unfamiliar code fast | `claude "explain docker_temporal_agent.py"` |
| Debug quickly | `claude "fix the SSL error in agent.py"` |
| Generate documentation | `claude "write README for this project"` |
| Write tests | `claude "write unit tests for docker_utils.py"` |
| Scaffold infra files | `claude "create a Dockerfile for this Python app"` |

For someone building multiple DevOps projects in parallel (like the Day 65-77 projects), an agentic coding assistant that can read an entire repo and make consistent edits is directly useful — not just a novelty.

---

## Status at End of Day

| Step | Status |
|------|--------|
| Claude Code installed (PowerShell method) | ✅ v2.1.195 |
| PATH fixed | ✅ |
| Login method understood (free vs paid) | ✅ |
| Account actually created/subscribed | ❌ Not yet — decision pending |
| Ollama (confirmed free alternative) | ✅ Already working from Day 76-77 |

---

## Official Links

| Resource | Link |
|----------|------|
| Claude Code Docs | https://code.claude.com/docs/en/setup |
| Claude Code Quickstart | https://docs.claude.com/en/docs/claude-code/quickstart |
| Claude Pricing | https://claude.com/pricing |
| Ollama | https://ollama.com/ |
