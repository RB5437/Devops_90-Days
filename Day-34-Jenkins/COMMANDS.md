# ⚡ Day 34 — Jenkins Commands 
> Declarative Pipeline + Multi-Node Agent Setup

---

## 🔑 SSH KEY SETUP — MASTER TO AGENT

```bash
# ── ON MASTER EC2 ──────────────────────────────────

# Go to .ssh directory
cd ~/.ssh
ls
# authorized_keys (existing)

# Generate new SSH key pair
ssh-keygen
# Enter file: /home/ubuntu/.ssh/id_ed25519
# Passphrase: (leave empty — press Enter)
# Key fingerprint: SHA256:oh9ai3fo/7f5JJ...

# List generated keys
ls
# authorized_keys  id_ed25519  id_ed25519.pub

# View PUBLIC key (copy this to Agent)
cat id_ed25519.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... ubuntu@Master

# View PRIVATE key (never share this!)
cat id_ed25519
# -----BEGIN OPENSSH PRIVATE KEY-----
# ...
# -----END OPENSSH PRIVATE KEY-----

# ── ON AGENT EC2 ───────────────────────────────────

# Go to .ssh directory
cd .ssh/
ls
# authorized_keys

# Add Master's public key to Agent
vi authorized_keys
# Paste Master's id_ed25519.pub content here
# :wq to save

# Verify key was added
cat authorized_keys
# ssh-rsa AAAA... Jenkins_Devops  ← existing key
# ssh-ed25519 AAAA... ubuntu@Master  ← new key added!
```

---

## 🔄 DECLARATIVE PIPELINE — JENKINSFILES

```groovy
// ── Pipeline 1: agent any (runs on Master) ──────────
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

// ── Pipeline 2: agent label (runs on Agent) ──────────
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

// ── Pipeline 3: with post actions ─────────────────────
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'mkdir -p build'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
    post {
        always {
            echo 'Pipeline always runs this'
        }
        success {
            echo 'Build SUCCESS!'
        }
        failure {
            echo 'Build FAILED!'
        }
    }
}
```

---

## ⚙️ AGENT NODE SETUP IN JENKINS UI

```
# Navigate to:
Manage Jenkins → Nodes → New Node

# Fill in these details:
Name: Agents-jenkins
Type: Permanent Agent
OK

# Node configuration:
Description: This is an ubuntu machine agent
Number of executors: 1
Remote root directory: /home/ubuntu
Labels: agents-jenkins
Usage: Use this node as as much as possible
Launch method: Launch agents via SSH
  Host: <Agent-EC2-Private-or-Public-IP>
  Credentials: + Add → Jenkins
    Kind: SSH Username with private key
    Username: ubuntu
    Private Key: Enter directly → paste id_ed25519 content
  Host Key Verification Strategy: Non verifying Verification Strategy
Availability: Keep this agent online as much as possible

Save → Check Agent log for connection status
```

---

## 🔍 VERIFY AGENT CONNECTION

```bash
# In Jenkins UI:
Manage Jenkins → Nodes → Agents-jenkins → Log

# Look for:
# Agent successfully connected and online ✅
# Communication Protocol: Standard in/out
# This is a Unix agent

# Check Nodes dashboard:
Manage Jenkins → Nodes
# Agent-jenkins: Linux (amd64), In sync, Online ✅
# Built-In Node: Linux (amd64), In sync, Online ✅
```

---

## 📁 VERIFY BUILD RAN ON AGENT

```bash
# On Agent EC2 — check workspace
ls /home/ubuntu/workspace/
# Demo-CI-CD  ← created when pipeline ran on agent!

cd /home/ubuntu/workspace/Demo-CI-CD
ls
# devops  ← created by our sh "mkdir -p devops" step

# Console output confirms:
# Running on Agent-jenkins in /home/ubuntu/workspace/Demo-CI-CD
```

---

## 🔧 JENKINS PIPELINE TRIGGERS

```
# In Jenkins Pipeline configure → Triggers:
Build after other projects are built    → Chain pipelines
Build periodically                      → Cron-like schedule
GitHub hook trigger for GITscm polling → Auto build on push
Poll SCM                                → Check Git every N min
Trigger builds remotely                 → API trigger

# Example cron syntax for "Build periodically":
H/5 * * * *   → Every 5 minutes
0 8 * * 1-5   → Every weekday at 8 AM
H H * * *     → Once a day (random minute)
```

---

## 📋 TODAY'S PRACTICE FLOW

```bash
# STEP 1: Create Pipeline job
# Jenkins → New Item → "Demo-CI-CD" → Pipeline → OK

# STEP 2: Write pipeline script
# Configure → Pipeline → Script:
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps { echo 'Hello Good Morning' }
        }
        stage('create folder') {
            steps { sh "mkdir -p devops" }
        }
    }
}
# Save → Build Now → Console Output: SUCCESS ✅

# STEP 3: Setup Agent EC2
# Launch new t3.micro EC2 (Ubuntu)
# Install Java (required for agent):
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y

# STEP 4: Generate SSH key on Master
ssh-keygen
cat ~/.ssh/id_ed25519.pub  # Copy this!

# STEP 5: Add public key to Agent
# SSH into Agent EC2
vi ~/.ssh/authorized_keys  # Paste Master's public key

# STEP 6: Configure Agent in Jenkins
# Manage Jenkins → Nodes → New Node → fill details → Save

# STEP 7: Verify Agent online
# Manage Jenkins → Nodes → Agent-jenkins → Log
# "Agent successfully connected and online" ✅

# STEP 8: Update pipeline to use Agent
pipeline {
    agent { label 'agent-jenkins' }
    ...
}
# Build Now → Console: "Running on Agent-jenkins" ✅
```

---

## 🔒 AWS SECURITY GROUP FOR AGENT

```
Master Security Group:
- Outbound: Port 22 to Agent IP (SSH to connect to Agent)

Agent Security Group:
- Inbound: Port 22 from Master IP (allow SSH from Master)
- Inbound: Port 22 from your IP (for your SSH access)

# No port 8080 needed on Agent — only on Master!
```

---

*Day 34 Commands — Declarative Pipeline + Multi-Node Agent*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
