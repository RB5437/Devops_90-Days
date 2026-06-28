# Day 77 — AI Agent for DevOps: Docker Monitoring Agent with Strands + Temporal 🤖🐳

## What Was Built Today

A working **AI-powered Docker container monitor** that can be asked natural-language questions ("is redis healthy?", "restart the postgres container") and it actually executes real Docker operations through a fault-tolerant Temporal workflow — not just a chatbot that talks about Docker, but one that controls it.

```
You type: "can you restart demo-redis container"
        ↓
AI Orchestrator (Claude via Bedrock) interprets the request
        ↓
Temporal Workflow executes the right Docker operation
        ↓
Result: "✓ Successfully restarted container 'demo-redis'"
```

---

## Journey Today — From Broken venv to a Working Agent

### Step 1 — Fixed the Python Environment
Python 3.14 (too new, unsupported by `strands-agents`) was replaced with Python 3.11.9 in a fresh virtual environment.

```bash
py -3.11 --version          # Python 3.11.9
rm -rf venv
py -3.11 -m venv venv
source venv/Scripts/activate
python --version            # Must show 3.11.9
```

### Step 2 — Installed the Core Libraries
```bash
pip install strands-agents
pip install 'strands-agents[ollama]'
pip install strands-agents-tools
pip install temporalio
```

### Step 3 — Built a Basic Agent (agent.py) First
Before touching Docker or Temporal, a simple standalone agent was built and debugged using a local LLM (Ollama) and a single tool (`http_request`) — to learn how Strands agents work before adding orchestration on top.

Progression of fixes made to `agent.py`:
1. Agent ran AWS Bedrock by default (needs AWS credentials) → fixed by explicitly passing `model=ollama_model`
2. `llama3.2:1b` (1B parameters) was too small to reliably call tools → upgraded to `llama3.2` (3B)
3. Weather API needed a paid key (401 Unauthorized) → switched to free, no-key APIs (`wttr.in`, `worldtimeapi.org`)
4. SSL certificate errors on the free weather API → instructed the agent to pass `verify_ssl=false`

### Step 4 — Installed and Started Temporal Server
```bash
temporal server start-dev
# Temporal Server:  localhost:7233
# Temporal UI:      http://localhost:8233
```

### Step 5 — Ran the Docker Monitoring Agent (3 terminals)
```bash
# Terminal 1
temporal server start-dev

# Terminal 2 — the worker (executes the actual workflow + activities)
python docker_monitor/docker_temporal_agent.py

# Terminal 3 — the client (where you type questions)
python docker_monitor/docker_client.py
```

### Step 6 — Verified It Actually Works
Asked: `"can you restart demo-redis container"`
Result (confirmed in Temporal UI): **"Successfully restarted container 'demo-redis'"** — workflow completed in 2s 718ms with 11 state transitions, fully logged and auditable in the Temporal dashboard.

---

## Architecture

```
┌─────────────────┐     natural language      ┌──────────────────────┐
│  docker_client.py │ ────────────────────────▶ │  Temporal Workflow    │
│  (you type here) │                            │ DockerMonitorWorkflow │
└─────────────────┘                            └──────────┬────────────┘
                                                            │
                                          ┌─────────────────┴──────────────────┐
                                          │   ai_orchestrator_activity          │
                                          │   (Claude via AWS Bedrock decides   │
                                          │    which Docker operation to run)   │
                                          └─────────────────┬────────────────────┘
                                                            │
                              ┌─────────────────────────────┼──────────────────────────────┐
                              ▼                             ▼                              ▼
                  get_container_status_activity   check_container_health_activity   restart_container_activity
                              │                             │                              │
                              └─────────────────────────────┴──────────────────────────────┘
                                                            │
                                              docker_utils.py → Docker SDK → Docker Daemon
```

---

## Why Temporal (and not just a plain Python script)?

A plain script calling the Docker API would lose all progress if it crashed mid-restart. Temporal makes every step **durable**:
- Each operation (`status`, `health`, `logs`, `restart`) is a separate **Activity** with its own retry policy
- If `restart_container_activity` fails, Temporal automatically retries (up to 5 times with exponential backoff) before giving up
- Every workflow run is fully visible in the Temporal UI — inputs, outputs, timing, retries — like a built-in audit log

This is the difference between a script and **production-grade automation**.

---

## Status at End of Day

| Component | Status |
|-----------|--------|
| Python 3.11 venv | ✅ Working |
| Basic Strands Agent (Ollama) | ✅ Working — tool calling confirmed |
| Temporal server | ✅ Running locally |
| Docker Monitor Worker | ✅ Connected, polling task queue |
| Docker Monitor Client | ✅ Connected to Temporal |
| End-to-end test (restart container via natural language) | ✅ **Successful** |

---

## Official Links

| Resource | Link |
|----------|------|
| Strands Agents Docs | https://strandsagents.com/latest/documentation/docs/ |
| Temporal Docs | https://docs.temporal.io/ |
| Ollama | https://ollama.com/ |
| Project Reference (Shubham) | https://github.com/LondheShubham153/strands-temporal-agents |
