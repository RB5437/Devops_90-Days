# ⚡ Day 35 — Jenkins Commands 
> Webhook + Shared Libraries + User Management

---

## 🔗 GITHUB WEBHOOK SETUP

```bash
# ── In GitHub Repository ───────────────────────────────

# Go to: Your Repo → Settings → Webhooks → Add webhook

Payload URL: http://<jenkins-ec2-ip>:8080/github-webhook/
# Our URL: http://34.228.55.4:8080/github-webhook/

Content type: application/x-www-form-urlencoded
Secret: (leave empty for now)
SSL verification: Enable SSL verification
Which events: Send me everything ✅
Active: ✅

# Click: Add webhook

# Verify in "Recent Deliveries" tab:
# ✅ ping event = webhook connected!

# ── In Jenkins Pipeline Configure ─────────────────────

# Triggers section → Check:
# ✅ GitHub hook trigger for GITScm polling
```

---

## 🔐 JENKINS CREDENTIALS SETUP

```bash
# ── Add DockerHub Credentials ──────────────────────────

# Navigate to:
Manage Jenkins → Credentials → System → Global → Add Credentials

Kind: Username with password
Scope: Global
Username: ritik2909             ← Your DockerHub username
Password: <your-password>       ← Your DockerHub password or token
ID: dockerHubcred               ← Used in withCredentials() in pipeline
Description: DockerHub credentials

# ── Add SSH Key for Agent ──────────────────────────────

Kind: SSH Username with private key
Scope: Global
Username: ubuntu
ID: ubuntu-ki-key
Private Key: Enter directly → paste id_ed25519 content
```

---

## 📚 SHARED LIBRARY GROOVY FILES

```groovy
# ── vars/hello.groovy ──────────────────────────────────
def call(){
    echo "Hello Dosti"
}

# ── vars/clone.groovy ──────────────────────────────────
def call(String url, String branch){
    echo "This is cloning the code"
    git url: "${url}", branch: "${branch}"
    echo "Code Clone Successful"
}

# ── vars/docker_build.groovy ───────────────────────────
// Define function
def call(String ProjectName, String ImageTag, String DockerHubUser){
    sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} ."
}

# ── vars/docker_push.groovy ────────────────────────────
// vars/docker_push.groovy
def call(String Project, String ImageTag, String dockerhubuser){
    echo "Pushing Docker image to DockerHub"
    withCredentials([
        usernamePassword(
            credentialsId: 'dockerHubcred',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )
    ]) {
        sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
        '''
        sh "docker push ${dockerhubuser}/${Project}:${ImageTag}"
    }
    echo "Docker image pushed successfully"
}
```

---

## ⚙️ REGISTER SHARED LIBRARY IN JENKINS

```bash
# Navigate to:
Manage Jenkins → System → (scroll to) Pipeline Libraries

# Under "Global Untrusted Pipeline Libraries":
Click: + Add

Name: Shared
Default version: main
Load implicitly: ❌ (unchecked)
Allow default version to be overridden: ✅
Include @Library changes in job recent changes: ✅

Retrieval method: Modern SCM
Source Code Management: Git
Project Repository: https://github.com/RB5437/jenkins-shared-libraries.git
Credentials: -none- (public repo)

Save
```

---

## 🎯 FINAL PIPELINE WITH SHARED LIBRARIES

```groovy
@Library("Shared") _
pipeline{
    agent { label "agent-jenkins"}
    stages{
        stage("Hello"){
            steps{
                script{
                  hello()
                }  
            }
        }
        stage("Code"){
            steps{
                script{
                    clone("https://github.com/RB5437/django-notes-app.git","main")
                }
            }
        }
        stage("Build"){
            steps{
                script{
                    docker_build("notes_app","latest","ritik2909")
                }
            }
        }
        stage("Push to DockerHub"){
            steps{
                script{
                    docker_push("notes_app","latest","ritik2909")
                }
            }
        }
        stage("Deploy"){
            steps{
                echo "This is deploying the code"
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}
```

---

## 👤 USER MANAGEMENT COMMANDS

```bash
# ── Create User in Jenkins ─────────────────────────────

# Navigate to:
Manage Jenkins → Users → + Create User

Username: Ritik
Password: ****
Confirm password: ****
Full name: Ritik Bawane
E-mail address: Ritikbawane5437@gmail.com

# Click: Create User

# ── View all users ─────────────────────────────────────
# Navigate to:
Manage Jenkins → Users
# Shows: admin, Ritik

# ── Delete a user ──────────────────────────────────────
# Users list → Red trash icon next to user

# ── Change password ────────────────────────────────────
# Users → Username → Configure → Password
```

---

## 🔄 COMPLETE CD FLOW — VERIFY WEBHOOK

```bash
# STEP 1: Make code change
# Edit any file in django-notes-app repo

# STEP 2: Push to GitHub
git add .
git commit -m "test webhook trigger"
git push origin main

# STEP 3: Watch Jenkins
# Jenkins pipeline should trigger automatically!
# Check: GitHub Hook Log in pipeline

# STEP 4: Verify in GitHub
# Repo → Settings → Webhooks → Recent Deliveries
# ✅ Green tick = successful delivery
```

---

## 🐳 DOCKER COMPOSE — DEPLOYMENT COMMANDS

```bash
# On Agent EC2 — in project directory
cd /home/ubuntu/workspace/Demo-CI-CD/

# Manual deploy test
docker compose down
docker compose up -d

# Check running containers
docker ps

# View logs
docker compose logs -f

# Check Django app
curl http://localhost:8000/admin
```

---

## 📋 TODAY'S PRACTICE FLOW

```bash
# STEP 1: Set up webhook
# GitHub → django-notes-app → Settings → Webhooks
# Payload URL: http://34.228.55.4:8080/github-webhook/

# STEP 2: Enable trigger in Jenkins pipeline
# Pipeline configure → Triggers → 
# ✅ GitHub hook trigger for GITScm polling

# STEP 3: Create shared library repo on GitHub
# New repo: jenkins-shared-libraries
# Create vars/ folder
# Add hello.groovy, clone.groovy, docker_build.groovy, docker_push.groovy

# STEP 4: Register library in Jenkins
# Manage Jenkins → System → Global Untrusted Pipeline Libraries
# Name: Shared, Repo: jenkins-shared-libraries.git

# STEP 5: Update pipeline to use @Library
# @Library("Shared") _
# Use hello(), clone(), docker_build(), docker_push()

# STEP 6: Add DockerHub credentials
# Manage Jenkins → Credentials → dockerHubcred

# STEP 7: Create user
# Manage Jenkins → Users → Create User "Ritik"

# STEP 8: Test full CD
# Push code to GitHub → Watch Jenkins trigger automatically! 🚀
```

---

*Day 35 Commands — Webhook + Shared Libraries + User Management*
*DevOps 90-Day Challenge — Ritik Bawane*
*GitHub: https://github.com/RB5437/Devops_90-Days*
