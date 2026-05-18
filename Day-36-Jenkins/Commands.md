# ⚡ Day 36 — Jenkins Advanced Commands 

---

## 🔐 RBAC — Role Based Access Control

```bash
# Plugin install via CLI (if needed)
java -jar jenkins-cli.jar -s http://localhost:8080/ \
  install-plugin role-strategy --username admin --password <password>

# Restart Jenkins after plugin install
sudo systemctl restart jenkins
```

**UI Steps (no commands needed):**
```
1. Manage Jenkins → Plugins → Available
   Search: "Role-based Authorization Strategy" → Install

2. Manage Jenkins → Security
   Authorization: Role-Based Strategy → Save

3. Manage Jenkins → Manage and Assign Roles → Manage Roles
   Add Role: "developer" 
   Permissions: Build ✅, View ✅, Cancel ✅

4. Manage Jenkins → Manage and Assign Roles → Assign Roles
   User: Ritik → Role: developer → Add
```

---

## 📂 Jenkinsfile from GitHub SCM

```groovy
# Jenkinsfile — save this in root of your GitHub repo
@Library("Shared") _
pipeline {
    agent { label "agent-jenkins" }
    stages {
        stage("Code") {
            steps {
                script {
                    clone("https://github.com/RB5437/django-notes-app.git", "main")
                }
            }
        }
        stage("Build") {
            steps {
                script {
                    docker_build("notes_app", "latest", "ritik2909")
                }
            }
        }
        stage("Push to DockerHub") {
            steps {
                script {
                    docker_push("notes_app", "latest", "ritik2909")
                }
            }
        }
        stage("Deploy") {
            steps {
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}
```

**Jenkins UI Steps:**
```
Pipeline Job → Configure
→ Pipeline → Definition: Pipeline script from SCM
→ SCM: Git
→ Repository URL: https://github.com/RB5437/django-notes-app.git
→ Branch Specifier: */main
→ Script Path: Jenkinsfile
→ Save → Build Now
```

---

## 🌿 Multibranch Pipeline

**UI Steps:**
```
New Item → Enter name: "MultibranchDemo"
→ Multibranch Pipeline → OK

Branch Sources → Add Source → GitHub
→ Repository HTTPS URL: https://github.com/RB5437/django-notes-app.git
→ Credentials: (add if private repo)

Scan Repository Triggers
→ Periodically if not otherwise run: 1 minute

Save → Scan Repository Now

# Jenkins will auto-create pipelines for each branch with Jenkinsfile
```

**Create branch and Jenkinsfile:**
```bash
# On your local machine
git checkout -b feature/test-branch
echo "pipeline { agent any; stages { stage('Test') { steps { echo 'Feature branch!' } } } }" > Jenkinsfile
git add Jenkinsfile
git commit -m "Add Jenkinsfile for feature branch"
git push origin feature/test-branch

# Jenkins will auto-detect and create pipeline for this branch
```

---

## 📧 Email Notification

**SMTP Configuration (UI):**
```
Manage Jenkins → System → Extended E-mail Notification
SMTP Server: smtp.gmail.com
SMTP Port: 465
Advanced:
  Use SSL: ✅ checked
  Credentials: Add → Username + Gmail App Password
Default user e-mail suffix: @gmail.com
Test → Send Test Email → ritikbawane5437@gmail.com
```

**Gmail App Password:**
```
myaccount.google.com → Security
→ 2-Step Verification (must be ON)
→ App passwords → Create
→ Name: Jenkins → Generate
→ Copy 16-digit password → use in Jenkins credentials
```

**Pipeline with Email:**
```groovy
pipeline {
    agent any
    stages {
        stage("Build") {
            steps { echo "Building application..." }
        }
        stage("Test") {
            steps { echo "Running tests..." }
        }
        stage("Deploy") {
            steps { echo "Deploying to server..." }
        }
    }
    post {
        success {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build passed! URL: ${env.BUILD_URL}"
            )
        }
        failure {
            emailext(
                to: 'ritikbawane5437@gmail.com',
                subject: "❌ FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed! Check: ${env.BUILD_URL}"
            )
        }
        always {
            echo "Notification sent!"
        }
    }
}
```

---

## 📊 Jenkins Series — Complete Command Reference

```bash
# Jenkins service commands
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
sudo systemctl status jenkins
sudo systemctl enable jenkins

# Jenkins logs
sudo journalctl -u jenkins -f
sudo cat /var/log/jenkins/jenkins.log

# Initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Jenkins workspace
ls /var/lib/jenkins/workspace/
ls /var/lib/jenkins/jobs/

# Jenkins user
id jenkins
cat /etc/passwd | grep jenkins

# Port check
sudo ss -tlnp | grep 8080
curl -I http://localhost:8080
```

---

## 🎯 Day 36 Practice Flow

```
Step 1: Install Role-based Authorization plugin
Step 2: Configure RBAC — create admin + developer roles
Step 3: Create user "Ritik" → assign developer role
Step 4: Test login with new user — verify limited access

Step 5: Push Jenkinsfile to GitHub repo root
Step 6: Create Pipeline job → SCM → point to repo
Step 7: Build → verify it reads Jenkinsfile from GitHub

Step 8: Create Multibranch Pipeline → point to repo
Step 9: Create feature branch with Jenkinsfile → push
Step 10: Verify Jenkins auto-detects new branch

Step 11: Setup Gmail SMTP + App Password
Step 12: Add post{success/failure} block to pipeline
Step 13: Trigger build → verify email received
```

---

📂 **GitHub:** https://github.com/RB5437/Devops_90-Days
