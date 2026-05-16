# 🔄 Day 34 — Jenkins Declarative Pipeline & Multi-Node Agent Setup

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![AWS EC2](https://img.shields.io/badge/AWS_EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Groovy](https://img.shields.io/badge/Groovy-4298B8?style=for-the-badge&logo=apachegroovy&logoColor=white)

> **EC2 Setup:** Jenkins Master (t3.small) + Agent Node (t3.micro)
> **Jenkins URL:** http://204.236.194.98:8080
> **Agent IP:** 18.212.88.18

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | Declarative Pipeline — pipeline{} syntax | ✅ Done |
| 2 | Pipeline job — "Demo-CI-CD" created | ✅ Done |
| 3 | Stages — Hello + create folder | ✅ Done |
| 4 | Console Output — Pipeline SUCCESS | ✅ Done |
| 5 | Jenkins Master-Agent Architecture | ✅ Done |
| 6 | 2 EC2 instances — Master + Agent | ✅ Done |
| 7 | SSH Keygen on Master | ✅ Done |
| 8 | Public key copied to Agent authorized_keys | ✅ Done |
| 9 | Agent Node configured in Jenkins UI | ✅ Done |
| 10 | Agent successfully connected and online | ✅ Done |
| 11 | Pipeline running on Agent node | ✅ Done |
| 12 | Build #10 — Running on Agent-jenkins | ✅ Done |

---

## 🏗️ Jenkins Master-Agent Architecture

```
┌─────────────────────────────────────────────────┐
│          JENKINS MASTER (t3.small)               │
│          IP: 204.236.194.98:8080                │
│                                                  │
│  - Manages jobs and pipelines                    │
│  - Schedules builds                              │
│  - Jenkins UI runs here                          │
└──────────────────┬──────────────────────────────┘
                   │  SSH connection
                   │  Private key → Public key
                   ▼
┌─────────────────────────────────────────────────┐
│          AGENT NODE (t3.micro)                   │
│          Name: Agent-jenkins                     │
│          IP: 18.212.88.18                       │
│          Label: agents-jenkins                   │
│          Root dir: /home/ubuntu                  │
│                                                  │
│  - Runs the actual build commands                │
│  - Workspace: /home/ubuntu/workspace/Demo-CI-CD  │
└─────────────────────────────────────────────────┘
```

---

## 📄 Declarative Pipeline — Demo-CI-CD

### Pipeline 1 — agent any (Master):
```groovy
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello Good Morning'
            }
        }
        stage('create folder') {
            steps {
                sh "mkdir -p devops"
            }
        }
    }
}
```

### Pipeline 2 — agent label (Agent Node):
```groovy
pipeline {
    agent { label 'agent-jenkins' }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello Good Morning'
            }
        }
        stage('create folder') {
            steps {
                sh "mkdir -p devops"
            }
        }
    }
}
```

**Key difference:**
- `agent any` → runs on any available node (Master)
- `agent { label 'agent-jenkins' }` → runs specifically on labeled Agent

---

## 🔑 SSH Key Setup — Master to Agent

### Step 1: Generate SSH key on Master
```bash
# On Master EC2
cd ~/.ssh
ssh-keygen
# Type: ed25519
# Key saved: ~/.ssh/id_ed25519 (private)
#             ~/.ssh/id_ed25519.pub (public)

# View public key
cat id_ed25519.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... ubuntu@Master
```

### Step 2: Copy public key to Agent
```bash
# On Agent EC2
cd .ssh/
vi authorized_keys
# Paste Master's public key here
# Save and exit

# Verify
cat authorized_keys
# ssh-rsa AAAA... Jenkins_Devops
# ssh-ed25519 AAAA... ubuntu@Master
```

---

## ⚙️ Agent Node Configuration in Jenkins

```
Manage Jenkins → Nodes → New Node

Name: Agents-jenkins
Description: This is an ubuntu machine agent
Number of executors: 1
Remote root directory: /home/ubuntu
Labels: agents-jenkins
Usage: Use this node as as much as possible
Launch method: Launch agents via SSH
  Host: 18.212.88.18
  Credentials: ubuntu (ubuntu-b-key)
  Host Key Verification: Non verifying Verification Strategy
Availability: Keep this agent online as much as possible
```

### Agent connected successfully:
```
Agent successfully connected and online ✅
Communication Protocol: Standard in/out
Remoting version: 3261.v9c670a_4748a_9
This is a Unix agent
```

---

## 🖥️ Nodes Dashboard

| Node | Architecture | Free Disk | Status |
|------|-------------|-----------|--------|
| Agent-jenkins | Linux (amd64) | 2.25 GiB | ✅ Online |
| Built-In Node | Linux (amd64) | 5.44 GiB | ✅ Online |

---

## 📋 Console Output — Build #10 (on Agent)

```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Agent-jenkins in /home/ubuntu/workspace/Demo-CI-CD
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Hello)
[Pipeline] echo
Hello Good Morning
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (create folder)
[Pipeline] sh
+ mkdir -p devops
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS ✅
```

**Key observation:** `Running on Agent-jenkins` — build ran on Agent, not Master!

---

## 📊 Build History — Demo-CI-CD

| Build | Time | Status | Notes |
|-------|------|--------|-------|
| #10 | 09:09 | ✅ SUCCESS | Running on Agent-jenkins |
| #4 | 08:39 | ❌ FAILED | Agent not connected yet |
| #3 | 07:50 | ✅ SUCCESS | Running on Master |

---

## 📊 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 33 | 15 May 2026 | Jenkins Intro + Install + Freestyle Job | ✅ Done |
| **Day 34** | **16 May 2026** | **Declarative Pipeline + Multi-Node Agent** | **✅ Done** |
| Day 35 | 17 May 2026 | Shared Libraries + User Management | ⬜ |
| Day 36 | 18 May 2026 | Jenkins + GitHub + Docker | ⬜ |
| Day 37 | 19 May 2026 | Jenkins Final Project | ⬜ |

---

*Day 34 of 90 — Jenkins Series | DevOps 90-Day Challenge*
*Ritik Bawane | AWS Certified | RHCSA | Kyndryl MNC*
*GitHub: https://github.com/RB5437/Devops_90-Days*
