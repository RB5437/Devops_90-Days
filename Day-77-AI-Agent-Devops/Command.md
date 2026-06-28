# Day 77 — Commands ⚡

## Environment Setup (Fixing Python Version)

```bash
# Check available Python versions
py -3.11 --version

# Remove the broken venv (was created with unsupported Python 3.14)
rm -rf venv

# Create a fresh venv with Python 3.11
py -3.11 -m venv venv

# Activate it (Git Bash / MINGW64)
source venv/Scripts/activate

# Confirm correct interpreter is active
python --version
# Must show: Python 3.11.9
```

## Installing Dependencies

```bash
pip install strands-agents
pip install 'strands-agents[ollama]'
pip install strands-agents-tools
pip install temporalio
pip install -r requirements.txt
```

## Ollama (Local LLM) Setup

```bash
# List installed models
ollama list

# Pull a model (1B - too small for reliable tool calling)
ollama pull llama3.2:1b

# Pull a better model (3B - works for tool calling)
ollama pull llama3.2

# Ollama server runs automatically in the background on:
# http://localhost:11434
```

## Running the Basic Agent (agent.py)

```bash
python agent.py
# You: what is the current time and weather in nagpur
```

## Temporal CLI Setup

```bash
# Verify installation
temporal version

# Start the local Temporal dev server (keep this terminal open)
temporal server start-dev

# Output:
# Temporal Server:  localhost:7233
# Temporal UI:      http://localhost:8233
```

## Running the Docker Monitoring Agent (3 separate terminals)

```bash
# Terminal 1 — Temporal server (must stay running)
temporal server start-dev

# Terminal 2 — the worker process (executes workflows + activities)
cd strands-temporal-agents-main/docker_monitor
source ../../venv/Scripts/activate
python docker_temporal_agent.py

# Terminal 3 — the client (where you type natural-language requests)
cd strands-temporal-agents-main/docker_monitor
source ../../venv/Scripts/activate
python docker_client.py
```

## Example Queries Used to Test the Agent

```text
can you tell me how many docker containers are running in my system
can you restart demo-redis container
is redis healthy?
show me logs for nginx
check nginx health and show logs
```

## Verifying the Workflow in the Temporal UI

```
Open in browser: http://localhost:8233

Navigate to: Workflows → docker-monitor-<uuid>

Confirms:
- Status: Completed
- Result: "✓ Successfully restarted container 'demo-redis'"
- Event History: ai_orchestrator_activity → restart_container_activity
- Duration: ~2.7 seconds
```

## Demo Docker Containers (for testing restart/health/logs)

```bash
cd strands-temporal-agents-main/docker_monitor
docker compose -f docker-compose.demo.yml up -d

# Confirm they're running
docker ps
```
