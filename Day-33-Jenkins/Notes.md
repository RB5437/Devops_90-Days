# 📝 Day 33 — Jenkins Notes (Deep Concepts)

---

## 1. 🔄 What is Jenkins & Why CI/CD?

### The problem before Jenkins:
```
Developer A codes → manually build → manually test → manually deploy
Developer B codes → manually build → manually test → manually deploy
                              ↓
               Errors, delays, inconsistency, slow delivery
```

### With Jenkins:
```
Developer pushes code to GitHub
            ↓
     Jenkins detects change (webhook/poll)
            ↓
     Auto: Build → Test → Deploy
            ↓
     Faster delivery + fewer errors ✅
```

### CI/CD explained simply:
| Stage | What happens | Jenkins role |
|-------|-------------|-------------|
| CI — Continuous Integration | Every commit → auto build + test | Detects push, runs tests |
| CD — Continuous Delivery | Tested code → auto deploy to staging | Deploys after tests pass |
| CD — Continuous Deployment | Auto deploy to production | Full automation |

### Why Jenkins?
- Free + open source
- 1800+ plugins
- Works with Docker, K8s, AWS, GitHub — everything
- Industry standard for CI/CD
- Most DevOps job descriptions mention Jenkins

---

## 2. 🏛️ Jenkins Architecture (Deep Dive)

### Master-Agent architecture:
```
┌──────────────────────────────────────┐
│           JENKINS MASTER              │
│                                      │
│  - Web UI (port 8080)                │
│  - Job scheduler                     │
│  - Plugin manager                    │
│  - User management                   │
│  - Build queue management            │
│  - Does NOT run builds (best practice)│
└──────────────┬───────────────────────┘
               │  SSH / JNLP connection
    ┌──────────┴──────────────┐
    │                         │
┌───▼──────┐           ┌──────▼───┐
│  AGENT 1  │           │  AGENT 2  │
│           │           │           │
│ Linux EC2 │           │ Docker    │
│ Executor 1│           │ Executor 1│
│ Executor 2│           │ Executor 2│
└───────────┘           └───────────┘
```

### Key terms explained:
| Term | Analogy | Technical meaning |
|------|---------|-----------------|
| Master | Manager in office | Schedules and monitors all work |
| Agent/Node | Worker in office | Machine that actually runs builds |
| Executor | Worker's desk | One build slot on an agent |
| Job | Task assigned | A build/deploy task configured in Jenkins |
| Build | Task execution | One run of a job |
| Workspace | Worker's folder | `/var/lib/jenkins/workspace/<jobname>` |
| Pipeline | Workflow | Series of stages: Build → Test → Deploy |

---

## 3. ☕ Java + Jenkins — Why Java?

Jenkins runs on Java — it's a Java application (.war file).

```
Jenkins = jenkins.war (Java Web Application)
         ↓
Runs on: /usr/bin/java -jar jenkins.war --httpPort=8080
```

### Java versions supported:
| Jenkins version | Java required |
|----------------|---------------|
| Jenkins 2.555.2 (installed) | Java 21 ✅ |
| Jenkins 2.346+ | Java 11 or 17 |
| Jenkins 2.235 | Java 8 |

### What we installed:
```bash
sudo apt install fontconfig openjdk-21-jre -y
# openjdk version "21.0.11-ea" 2026-04-21
# OpenJDK Runtime Environment (build 21.0.11-ea+8-Ubuntu-1)
# OpenJDK 64-Bit Server VM
```

---

## 4. 🔧 Jenkins Installation Deep Dive

### Why add a keyring?
```bash
# Keyring = GPG key to verify Jenkins packages are authentic
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Without keyring → apt can't verify package authenticity → security risk
```

### What gets installed:
```
jenkins package → /usr/share/java/jenkins.war
                → /etc/init.d/jenkins (service script)
                → /var/lib/jenkins/ (home directory)
                → /var/log/jenkins/ (log files)
                → /etc/default/jenkins (config)
```

### Jenkins home directory structure:
```
/var/lib/jenkins/
├── config.xml           ← Main Jenkins config
├── jobs/                ← All job configs stored here
│   └── First-Job/
│       ├── config.xml   ← Job configuration
│       └── builds/      ← Build history
├── plugins/             ← Installed plugins
├── secrets/
│   └── initialAdminPassword  ← First-time password
├── users/               ← User accounts
└── workspace/           ← Job workspaces
    └── First-Job/
        └── devops/      ← Our created folder!
```

---

## 5. 🖥️ Jenkins UI — Key Sections

### Dashboard sections:
```
Jenkins Dashboard (http://ip:8080)
├── New Item          → Create new job/pipeline
├── Build History     → All recent builds
├── Manage Jenkins    → Settings, plugins, nodes
├── My Views          → Custom views
└── Build Queue       → Queued builds
    Build Executor    → Running builds (0/2 executors)
```

### Setup Wizard choices:
| Option | What it does |
|--------|-------------|
| Install suggested plugins | Installs ~30 most common plugins | ← We chose this |
| Select plugins to install | Manual selection |

### Important default plugins installed:
- Git plugin — GitHub integration
- Pipeline — Jenkinsfile support
- GitHub plugin — webhook integration
- Credentials — store passwords safely
- SSH Build Agents — connect to agents

---

## 6. 🎯 Freestyle Job vs Pipeline Job

### Job types available in Jenkins:
| Type | Use case | When to use |
|------|----------|------------|
| **Freestyle project** | Simple tasks, shell commands | Learning, simple builds |
| **Pipeline** | Complex multi-stage CI/CD | Production use |
| Multi-configuration | Matrix builds (test on multiple OS) | Testing across platforms |
| Multibranch Pipeline | One pipeline per Git branch | Feature branch workflows |
| Folder | Organize jobs | Large teams |

### Our First-Job (Freestyle) configuration:
```
General:
  Description: "This is simple job"
  Discard old builds: ✅ Log Rotation

Source Code Management:
  None (no GitHub connected yet)

Build Triggers:
  None (manual trigger for now)

Build Steps:
  Execute shell:
    echo "Hello Afternoon"
    mkdir -p devops
    echo "Devops folder created"

Post-build Actions:
  None
```

---

## 7. 📋 Console Output — Understanding Build Logs

### Our console output explained:
```bash
Started by user admin           # Who triggered the build
Running as SYSTEM               # Jenkins system user
Building in workspace /var/lib/jenkins/workspace/First-Job
                                # Where build runs

[First-Job] $ /bin/sh -xe /tmp/jenkins194314558186...sh
# Jenkins creates a temp shell script and runs it
# -x = print each command before running
# -e = stop on first error

+ echo Hello Afternoon          # + means command is executing
Hello Afternoon                 # Output of command
+ mkdir -p devops               # mkdir command
+ echo Devops folder created    # echo command
Devops folder created           # Output
Finished: SUCCESS               # Build result ✅
```

### Build results:
| Result | Meaning |
|--------|---------|
| SUCCESS | All steps completed without errors |
| FAILURE | A step failed or returned non-zero exit code |
| UNSTABLE | Tests failed but build completed |
| ABORTED | Build was manually stopped |

---

## 8. 📁 Jenkins Workspace

### What is workspace?
The workspace is where Jenkins checks out code and runs build commands.

```bash
/var/lib/jenkins/workspace/
└── First-Job/          ← Our job's workspace
    └── devops/         ← Folder created by our build step!
```

### Workspace verified:
```bash
ubuntu@ip-172-31-29-151:~$ cd /var/lib/jenkins/workspace/
ubuntu@ip-172-31-29-151:/var/lib/jenkins/workspace$ ls
First-Job

ubuntu@ip-172-31-29-151:/var/lib/jenkins/workspace$ cd First-Job/
ubuntu@ip-172-31-29-151:/var/lib/jenkins/workspace/First-Job$ ls
devops   ← Our mkdir -p devops command created this!
```

---

## 9. 🎯 Key Interview Points from Day 33

| Question | Answer |
|----------|--------|
| What is Jenkins? | Open-source CI/CD automation server. Automates build, test, deploy |
| What is CI/CD? | CI = auto build+test on commit. CD = auto deploy after tests pass |
| Jenkins architecture? | Master manages jobs, agents run builds, executors are build slots |
| What is a Freestyle job? | Simple Jenkins job — configure shell commands, no code needed |
| What is a Pipeline job? | Code-based job using Jenkinsfile — stages, parallel, conditions |
| Where are jobs stored? | /var/lib/jenkins/jobs/<jobname>/config.xml |
| Where are workspaces? | /var/lib/jenkins/workspace/<jobname>/ |
| Jenkins default port? | 8080 |
| What Java does Jenkins need? | Java 11, 17, or 21 depending on Jenkins version |
| Why Jenkins over others? | Free, 1800+ plugins, industry standard, works with everything |

---

*Day 33 Notes — Jenkins Introduction, Installation, First Job*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
