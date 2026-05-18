# ⚡ Day 33 — Jenkins Commands 

---

## ☕ JAVA INSTALLATION

```bash
# Update packages
sudo apt update

# Install Java 21 (required for Jenkins 2.555.2)
sudo apt install fontconfig openjdk-21-jre -y

# Verify Java installation
java -version
# openjdk version "21.0.11-ea" 2026-04-21

# Check Java path
which java
# /usr/bin/java
```

---

## 🔧 JENKINS INSTALLATION

```bash
# Step 1: Download Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Step 2: Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Step 3: Update apt with Jenkins repo
sudo apt update

# Step 4: Install Jenkins
sudo apt install jenkins -y
# Jenkins 2.555.2 will be installed
```

---

## 🚀 JENKINS SERVICE COMMANDS

```bash
# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins (auto-start on reboot)
sudo systemctl enable jenkins

# Check Jenkins status
sudo systemctl status jenkins
# Active: active (running) ✅

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# View Jenkins logs (live)
sudo journalctl -u jenkins -f

# View Jenkins logs (last 50 lines)
sudo journalctl -u jenkins -n 50
```

---

## 🔑 JENKINS INITIAL PASSWORD

```bash
# Get initial admin password (needed for first login)
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Example output: 6e89c86d67b54928bd0e2388e9e6f4eb
```

---

## 🌐 JENKINS ACCESS

```bash
# Access Jenkins in browser
# Open: http://<your-ec2-public-ip>:8080

# EC2 Security Group — Add inbound rule:
# Type: Custom TCP
# Port: 8080
# Source: 0.0.0.0/0

# Our Jenkins URL (today):
# http://98.91.21.52:8080
```

---

## 📁 JENKINS DIRECTORY COMMANDS

```bash
# Jenkins home directory
ls /var/lib/jenkins/
# config.xml  jobs  plugins  secrets  users  workspace

# View all jobs
ls /var/lib/jenkins/jobs/
# First-Job

# View job config
cat /var/lib/jenkins/jobs/First-Job/config.xml

# View workspace
ls /var/lib/jenkins/workspace/
# First-Job

# Enter job workspace
cd /var/lib/jenkins/workspace/First-Job/
ls
# devops   ← folder created by our job!

# Jenkins logs
sudo cat /var/log/jenkins/jenkins.log

# Jenkins plugins directory
ls /var/lib/jenkins/plugins/ | head -20
```

---

## 🎯 FIRST JOB — WHAT WE CONFIGURED

```bash
# Job Name: First-Job
# Type: Freestyle project

# Build Steps → Execute shell:
echo "Hello Afternoon"
mkdir -p devops
echo "Devops folder created"

# After running, console output showed:
# + echo Hello Afternoon
# Hello Afternoon
# + mkdir -p devops
# + echo Devops folder created
# Devops folder created
# Finished: SUCCESS ✅
```

---

## 🔍 JENKINS TROUBLESHOOTING COMMANDS

```bash
# Check if Jenkins is running on port 8080
sudo netstat -tulpn | grep 8080
# OR
sudo ss -tulpn | grep 8080

# Check Jenkins process
ps aux | grep jenkins

# Jenkins version
java -jar /usr/share/java/jenkins.war --version

# Check Jenkins memory usage
sudo systemctl show jenkins | grep Memory

# Restart if Jenkins is slow
sudo systemctl restart jenkins

# Jenkins disk space issue — clean workspace
# Go to Jenkins UI → Manage Jenkins → Workspace Cleanup

# Check Jenkins service file
cat /lib/systemd/system/jenkins.service

# Jenkins default port config
sudo cat /etc/default/jenkins | grep PORT
```

---

## 🔧 JENKINS SYSTEMCTL REFERENCE

```bash
# All service management commands
sudo systemctl start jenkins      # Start
sudo systemctl stop jenkins       # Stop
sudo systemctl restart jenkins    # Restart
sudo systemctl reload jenkins     # Reload config
sudo systemctl enable jenkins     # Enable at boot
sudo systemctl disable jenkins    # Disable at boot
sudo systemctl status jenkins     # Check status
sudo systemctl is-active jenkins  # active or inactive
sudo systemctl is-enabled jenkins # enabled or disabled
```

---

## 📋 TODAY'S PRACTICE FLOW

```bash
# STEP 1: Install Java
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
java -version

# STEP 2: Add Jenkins repo
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# STEP 3: Install Jenkins
sudo apt update && sudo apt install jenkins -y

# STEP 4: Start + Enable
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

# STEP 5: Get initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# STEP 6: Open browser
# http://<ec2-ip>:8080
# Paste password → Install suggested plugins → Create admin user

# STEP 7: Create First-Job
# New Item → First-Job → Freestyle project → OK
# Build Steps → Execute shell:
echo "Hello Afternoon"
mkdir -p devops
echo "Devops folder created"
# Save → Build Now

# STEP 8: Verify workspace
cd /var/lib/jenkins/workspace/First-Job/
ls
# devops ✅

# STEP 9: Check console output
# Jenkins UI → First-Job → #1 → Console Output
# Finished: SUCCESS ✅
```

---

## 🔒 AWS EC2 SECURITY GROUP SETUP

```
For Jenkins to be accessible from browser:

Inbound Rules:
- SSH: Port 22, Source: Your IP
- Custom TCP: Port 8080, Source: 0.0.0.0/0

Command to check if port is open:
curl http://<ec2-ip>:8080
```

---

*Day 33 Commands — Jenkins Installation + First Job*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
