# 📝 Day 34 — Jenkins Notes 
> Declarative Pipeline + Multi-Node Agent Architecture

---

## 1. 🔄 Declarative Pipeline — Deep Dive

### What is a Declarative Pipeline?
A Declarative Pipeline is a **code-based way** to define CI/CD workflow in Jenkins using Groovy DSL. It lives in a `Jenkinsfile` and is stored in Git alongside your code.

### Pipeline structure — every section explained:
```groovy
pipeline {                    // ← Root block — mandatory
    agent any                 // ← Where to run: any, none, specific label
    
    environment {             // ← Global environment variables
        APP_NAME = "myapp"
        VERSION = "1.0"
    }
    
    stages {                  // ← Container for all stages
        stage('Build') {      // ← One stage — has a name
            steps {           // ← Actual commands to run
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker build -t myapp .'
                sh 'docker push myapp'
            }
        }
    }
    
    post {                    // ← Run after all stages
        always {
            echo 'Pipeline finished!'
        }
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

### Agent options:
| Option | Meaning | When to use |
|--------|---------|-------------|
| `agent any` | Run on any available node | Simple pipelines |
| `agent none` | No global agent — define per stage | Different stages on different agents |
| `agent { label 'agent-jenkins' }` | Run on specific labeled node | Production use |
| `agent { docker 'python:3.11' }` | Run inside Docker container | Isolated builds |

---

## 2. 🏗️ Freestyle vs Declarative Pipeline

| Feature | Freestyle Job | Declarative Pipeline |
|---------|--------------|---------------------|
| Configuration | Jenkins UI (GUI) | Code (Jenkinsfile) |
| Version control | ❌ Not in Git | ✅ In Git with code |
| Complex workflows | ❌ Limited | ✅ Stages, parallel, conditions |
| Reusability | ❌ Copy-paste | ✅ Shared libraries |
| Production use | ❌ Simple tasks only | ✅ Industry standard |
| Review process | ❌ No code review | ✅ PR review like any code |

**Today we used both:**
- Day 33: Freestyle Job → "First-Job"
- Day 34: Declarative Pipeline → "Demo-CI-CD"

---

## 3. 🌐 Jenkins Master-Agent Architecture (Deep Dive)

### Why separate Master and Agent?

**Problem with running builds on Master:**
```
Master running builds:
- Master busy with builds → UI becomes slow
- Build failures can crash Master
- Security risk — build code runs with Jenkins permissions
- Scalability issue — single machine bottleneck
```

**Solution — Dedicated Agents:**
```
Master:
- Only manages, schedules, monitors
- Always available for UI
- Never runs build commands

Agents:
- Only runs build commands
- Can have multiple agents
- Can be specialized (Docker agent, Linux agent, Windows agent)
- Scale out as needed
```

### Our setup today:
```
Master (t3.small, 204.236.194.98):
└── Jenkins installed, UI on port 8080
└── Manages all jobs

Agent (t3.micro, 18.212.88.18):
└── Java installed (required for agent)
└── SSH access from Master
└── Runs actual build commands
└── Workspace: /home/ubuntu/workspace/
```

---

## 4. 🔑 SSH Key Authentication — How it Works

### Why SSH for Master-Agent?
Jenkins Master connects to Agent via SSH to:
- Copy the agent.jar file
- Start the agent process
- Send build commands
- Receive build results

### Key pair flow:
```
Master generates key pair:
~/.ssh/id_ed25519      ← Private key (stays on Master, never share!)
~/.ssh/id_ed25519.pub  ← Public key (copy to Agent)

Agent stores public key:
~/.ssh/authorized_keys ← Contains Master's public key

When Master SSHes to Agent:
Master presents private key → Agent verifies against public key → 
Connection established ✅
```

### Commands used today:
```bash
# On Master — generate key pair
cd ~/.ssh
ssh-keygen
# → Algorithm: ed25519 (modern, more secure than RSA)
# → Saves: id_ed25519 and id_ed25519.pub

# View public key to copy
cat id_ed25519.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... ubuntu@Master

# On Agent — add public key
cd ~/.ssh/
vi authorized_keys
# Paste public key here → save → exit
```

### ed25519 vs RSA:
| Algorithm | Key size | Security | Speed |
|-----------|----------|---------|-------|
| RSA | 2048-4096 bits | Good | Slower |
| ed25519 | 256 bits | Better | Faster |

---

## 5. ⚙️ Agent Node Configuration Explained

### Each field in Jenkins Node config:
```
Name: Agents-jenkins
→ Unique identifier for this node in Jenkins

Description: "This is an ubuntu machine agent"
→ Human-readable description

Number of executors: 1
→ How many builds can run simultaneously on this agent
→ Usually = number of CPU cores

Remote root directory: /home/ubuntu
→ Where agent stores workspace and temp files
→ Agent's "home" on the remote machine

Labels: agents-jenkins
→ Tag used to route builds to specific agents
→ Pipeline uses: agent { label 'agents-jenkins' }

Launch method: Launch agents via SSH
→ How Master connects to Agent
→ SSH = most common and secure

Host: 18.212.88.18
→ Agent's IP address or hostname

Credentials: ubuntu (ubuntu-b-key)
→ SSH private key stored in Jenkins Credentials Manager
→ Used to authenticate to Agent

Host Key Verification: Non verifying
→ Skip SSH host key verification
→ For learning OK, in production: "Known hosts file"
```

---

## 6. 📋 Pipeline Build — What Changed

### Build #3 — agent any (Master):
```
Running on Jenkins in /var/lib/jenkins/workspace/Demo-CI-CD
```

### Build #10 — agent { label 'agent-jenkins' } (Agent):
```
Running on Agent-jenkins in /home/ubuntu/workspace/Demo-CI-CD
```

**Big difference:** Workspace location changed — proves build ran on Agent!

### Build #4 — FAILED — Why?
Agent not yet connected when pipeline ran with `agent { label 'agent-jenkins' }`. After connecting Agent, Build #10 succeeded!

**Learning:** Always verify agent is online before running agent-specific pipeline!

---

## 7. 🎯 Key Interview Points from Day 34

| Question | Answer |
|----------|--------|
| What is Declarative Pipeline? | Code-based CI/CD workflow in Jenkinsfile using Groovy DSL. Stored in Git. |
| Freestyle vs Pipeline? | Freestyle = GUI config, simple tasks. Pipeline = code, complex workflows, version controlled |
| Why use Jenkins agents? | Master should only manage, not build. Agents scale builds, isolate environments, improve performance |
| How does Master connect to Agent? | SSH using key pair. Master has private key, Agent has public key in authorized_keys |
| What is agent { label }? | Routes pipeline to run on specifically labeled agent node |
| What is executor? | One build slot on an agent. executor=1 means one build at a time on that agent |
| What is workspace? | Directory where Jenkins checks out code and runs build commands on agent |
| What is ed25519? | Modern SSH key algorithm — faster and more secure than RSA |
| Why Build #4 failed? | Agent not connected yet — pipeline couldn't find node with label 'agent-jenkins' |
| What is Groovy Sandbox? | Security feature — limits what Groovy code can do in pipelines. Always enabled |

---

*Day 34 Notes — Declarative Pipeline + Multi-Node Agent*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
