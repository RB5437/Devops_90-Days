# Day 76 — AI Agents for DevOps | Day 1 🤖
**Date:** 27/06/2026
**Topic:** AI Agents for DevOps — Concepts + Setup + First Agent Running
**Resource:** TrainWithShubham — AI Agents for DevOps Series
**Status:** ✅ Concepts Clear + Docker Monitor Agent Running

---

## 🎯 What Was Covered Today

| # | Topic | Status |
|---|-------|--------|
| 1 | The Evolving DevOps Landscape — Why AI Agents | ✅ |
| 2 | What is AI — History from 1956 | ✅ |
| 3 | What is GPT — Generative Pre-trained Transformer | ✅ |
| 4 | What is LLM — Large Language Model | ✅ |
| 5 | Available LLMs — Claude, Gemini, GPT, Mistral, Llama | ✅ |
| 6 | GenAI vs AI Agent — Key difference | ✅ |
| 7 | How AI Agent works — Architecture diagram | ✅ |
| 8 | How to create AI Agent for DevOps use cases | ✅ |
| 9 | Prerequisites setup — Ollama + Python 3.14.6 | ✅ |
| 10 | Docker Monitor Agent running with Temporal | ✅ |

---

## 🧠 KEY CONCEPTS LEARNED

### 1. The Evolving DevOps Landscape
DevOps & SRE are seeing a new evolution with the rise of AI Agents.

| Old DevOps | New DevOps with AI Agents |
|------------|--------------------------|
| Manual incident response | Deeper Incident Analysis & Response |
| Script-based automation | Intelligent Automation |
| Fixed pipelines | Improved Productivity with AI |

---

### 2. AI History — Brief Timeline
```
1956  →  AI concept born (John McCarthy coined the term)
        ↓
       Machine Learning
        ↓
       Deep Learning
        ↓
       Neural Networks
        ↓
2017  →  Transformer Architecture (Attention is All You Need)
        ↓
2022  →  ChatGPT launched (GPT = Generative Pre-trained Transformer)
        ↓
2024+ →  AI Agents (Autonomous, Action-taking AI)
```

---

### 3. GPT — Full Form & Meaning
```
G → Generative    = Generates new content (text, code, answers)
P → Pre-trained   = Trained on massive internet data (past)
T → Transformer   = Architecture that understands context
```

**ChatGPT** uses GPT model. GPT is the underlying LLM.

---

### 4. LLM — Large Language Model
```
YOU  →  AI [uses LLM underneath]
         ↓
        LLM = The brain
         ↓
     Pre-trained on past data
```

**Popular LLMs available today:**
| LLM | Company | Use |
|-----|---------|-----|
| Claude Sonnet | Anthropic | Best for coding + reasoning |
| Gemini Flash | Google | Fast + multimodal |
| GPT 5.2 | OpenAI | General purpose |
| Mistral | Mistral AI | Open source, efficient |
| Llama | Meta | Open source, run locally |

---

### 5. GenAI vs AI Agent — Critical Difference

```
GenAI (ChatGPT / Claude):
YOU → Question → LLM → Answer
     (One way — just responds)

AI Agent:
YOU → Task → [Code] → LLM → [Action]
              ↑              ↓
         Real-time data ← Result back to YOU
     (Two way — ACTS autonomously)
```

**Simple analogy:**
- GenAI = Employee who gives advice
- AI Agent = Employee who takes advice AND does the work

---

### 6. How to Create an AI Agent for DevOps

3 Steps:
```
01. Use an Agentic AI Framework  →  Strands Agents (AWS)
02. Build Tools and Orchestrations  →  Define what agent can do
03. Make your AI Agent Production-Ready  →  Temporal (durable execution)
```

---

### 7. AI Agent Architecture (Shubham's Diagram)

```
YOU (DevOps Engineer)
    ↓ gives task
[Code] — defines tools + orchestration
    ↓ sends to
[LLM] — Claude Sonnet / Llama / GPT
    ↓ decides action
[Action] — kubectl, docker, aws cli, etc.
    ↓
Real-time data / Action result back to YOU
```

---

## 🛠️ PREREQUISITES SETUP

### Tools Required:
| Tool | Purpose | Status |
|------|---------|--------|
| VS Code | Code editor | ✅ |
| Ollama | Local LLM runner (run Llama locally) | ✅ Searched |
| Python | Agent code language | ✅ |
| AWS Account | For production agents | ✅ |

### Python Version Installed:
```bash
python --version
# Python 3.14.6 ✅ Latest
```

### Ollama Install:
```bash
# Linux
curl -fsSL https://ollama.com/install.sh | sh

# Windows — download from
# https://ollama.com/download/windows

# Pull a model
ollama pull llama3.2
ollama pull nomic-embed-text
```

---

## 🚀 DOCKER MONITOR AGENT — Running!

### What It Does:
AI Agent that monitors Docker containers — you ask in plain English,
agent checks Docker and gives you real-time status.

### Tools Used:
| Tool | Role |
|------|------|
| Strands Agents | AWS AI Agent framework |
| Temporal | Durable workflow execution + retry |
| Python | Agent code |
| Docker | What the agent monitors |

### Agent Running — Terminal Output:
```
Monitor workflows at: http://localhost:8233
Connecting to Temporal server at localhost:7233...
✓ Connected to Temporal server

Example queries:
  - Check container status
  - Show me logs for nginx
  - Is redis healthy?
  - Restart the postgres container
  - Check nginx health and show logs

Type 'quit' or 'exit' to stop
Enter task: how many containers are running?
```

### Agent Response:
```
Found 4 container(s):

Container: demo-nginx (4e3767279a21)
  Status: running
  Image: nginx:alpine
  Uptime: 2 days
  Ports: 80/tcp->0.0.0.0:8080,:::8080

Container: demo-redis (69e6d774c7ec)
  Status: running
  Image: redis:alpine
  Uptime: 1 days
  Ports: 6379/tcp->0.0.0.0:6379,:::6379

Container: demo-logger (6ec5cad787a1)
  Status: running
```

**The agent checked Docker in real-time and reported — zero manual command!** ✅

---

## 📁 GitHub Repo Used

```bash
git clone https://github.com/LondheShubham153/strands-temporal-agents
cd strands-temporal-agents/docker_monitor

# Start demo containers
docker compose -f docker-compose.demo.yml up -d

# Run Temporal server (Terminal 1)
temporal server start-dev

# Run worker (Terminal 2)
python docker_worker.py

# Run agent (Terminal 3)
python docker_client.py
```

---

## 🔗 Official Links

| Resource | Link |
|----------|------|
| Strands Agents (AWS) | https://github.com/strands-agents/sdk-python |
| Temporal | https://temporal.io |
| Ollama | https://ollama.com |
| GitHub Repo | https://github.com/LondheShubham153/strands-temporal-agents |
| Python | https://www.python.org |

---

## 📊 What's Next — Day 77

| Topic | Details |
|-------|---------|
| Strands Agents deep dive | Tools, orchestration, system prompt |
| AWS Bedrock integration | Use Claude Sonnet via API |
| Build custom DevOps agent | K8s monitoring / CI/CD automation |

---

*Day 76 of #90DaysOfDevOps | Ritik Bhatia | DevOps Engineer*
