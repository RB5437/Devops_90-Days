# Day 77 — Notes: AI Agent for DevOps Concepts 📝

## Core Concept: Agent vs Chatbot

A regular LLM chatbot only **talks**. An **Agent** can **act** — it can call tools/APIs/scripts to actually do something in the real world, then use the result to decide its next step.

```
Chatbot:  "You could restart the container by running docker restart redis"
Agent:    *actually calls docker_utils.restart_container("redis")*
          "✓ Successfully restarted container 'redis'"
```

## Key Building Blocks Used Today

### 1. Strands Agents (the "brain" framework)
A framework for building AI agents — you give it a system prompt, a model, and a list of tools, and it decides which tool to call and when, based on the user's request.

```python
agent = Agent(
    model=ollama_model,
    system_prompt=system_prompt,
    tools=[http_request]
)
```

### 2. Ollama (running an LLM locally, for free)
Ollama lets you run open-source LLMs (like Llama 3.2) on your own machine — no API key, no cost, no internet dependency for the model itself.

```python
ollama_model = OllamaModel(
    host="http://localhost:11434",
    model_id="llama3.2"
)
```

**Important lesson learned today:** Model size matters for tool calling. `llama3.2:1b` (1 billion parameters) could *describe* what tool to call but couldn't reliably execute the call. `llama3.2` (3B) handled it correctly. Bigger models are generally more reliable at structured tool use.

### 3. AWS Bedrock (used for the "smart" orchestration step)
For the actual Docker monitoring agent, the AI orchestrator step (`ai_orchestrator_activity`) uses **Claude via AWS Bedrock** instead of a local Ollama model — because deciding "which exact Docker operation does this request map to" needs a more capable model than a small local one.

```python
agent = Agent(
    model=BedrockModel(
        model_id="us.anthropic.claude-sonnet-4-20250514-v1:0",
        region_name="us-east-1"
    ),
    system_prompt="...turns natural language into status/health/logs/restart commands..."
)
```

### 4. Temporal (durable workflow orchestration)
Temporal is a workflow engine designed for **reliability**. Instead of writing a script that might silently fail halfway through, you define:
- **Workflows** — the overall sequence of steps (`DockerMonitorWorkflow`)
- **Activities** — individual units of work that can fail and be retried independently (`restart_container_activity`, `get_container_logs_activity`, etc.)

Each activity gets its own `RetryPolicy` — for example, restarting a container retries up to 5 times with increasing wait times, because a restart might legitimately take a few seconds to succeed:

```python
retry_policy=RetryPolicy(
    maximum_attempts=5,
    initial_interval=timedelta(seconds=5),
    maximum_interval=timedelta(seconds=30),
    backoff_coefficient=2.0
)
```

## The Full Request Lifecycle (What Actually Happens)

1. You type a question into `docker_client.py`
2. It opens a connection to the Temporal server and starts a `DockerMonitorWorkflow` with a unique ID
3. The workflow's first activity (`ai_orchestrator_activity`) sends your question to Claude (via Bedrock), which returns a short machine-readable plan like `restart:demo-redis`
4. The workflow parses that plan and calls the matching activity — in this case `restart_container_activity("demo-redis")`
5. That activity uses `docker_utils.py` (a wrapper around the real Docker SDK) to actually restart the container
6. The result bubbles back up through the workflow to the client, and gets printed to your terminal
7. Every one of these steps — including the exact timing and any retries — is visible in the Temporal Web UI at `localhost:8233`

## Why This Matters for DevOps (Not Just "AI Hype")

This pattern — natural language in, durable+auditable action out — is exactly what real "AIOps" platforms (like the Kyndryl Bridge platform mentioned in earlier interview prep) are doing at a larger scale: turning incident response from "an engineer manually runs commands at 2 AM" into "the system safely takes the action itself, with full traceability."

## Debugging Lessons From Today (Real, Not Just Theory)

| Problem | Root Cause | Fix |
|---------|-----------|-----|
| `ModuleNotFoundError: No module named 'psutil'`-style env issues | Python 3.14 too new for `strands-agents` | Reinstalled venv with Python 3.11 |
| Agent used AWS Bedrock by accident | `model=` parameter wasn't passed to `Agent()` | Explicitly pass `model=ollama_model` |
| Agent "talked about" calling a tool instead of calling it | Model too small (`llama3.2:1b`) | Used `llama3.2` (3B) instead |
| Weather API returned 401 Unauthorized | Free-tier weather APIs still require a key | Switched to genuinely free APIs (`wttr.in`) |
| SSL errors on the free weather API | Default `verify_ssl=true` failing on that endpoint | Told the agent in the system prompt to pass `verify_ssl=false` |
| `temporal: command not found` | Temporal CLI wasn't installed yet | Installed the official Temporal CLI binary |
| `Failed to connect to Temporal server: ConnectionRefused` | Tried to run the client before starting the server | Always start `temporal server start-dev` first, in its own terminal |
| Tried running `docker_worker.py` (doesn't exist in this repo) | Assumed a filename from memory instead of checking the actual zip | Confirmed actual file is `docker_temporal_agent.py` |
