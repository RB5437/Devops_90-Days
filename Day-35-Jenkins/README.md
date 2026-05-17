# 🔄 Day 35 — Jenkins Webhook, Shared Libraries & User Management

![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Groovy](https://img.shields.io/badge/Groovy-4298B8?style=for-the-badge&logo=apachegroovy&logoColor=white)

> **Jenkins URL:** http://34.228.55.4:8080
> **Project:** django-notes-app CI/CD with Shared Libraries
> **Shared Library Repo:** github.com/RB5437/jenkins-shared-libraries

---

## ✅ What I Learned Today

| # | Topic | Status |
|---|-------|--------|
| 1 | GitHub Webhook — auto trigger Jenkins on code push | ✅ Done |
| 2 | Webhook Payload URL configured | ✅ Done |
| 3 | Recent Deliveries — webhook delivery verified | ✅ Done |
| 4 | Jenkins Credentials — DockerHub credentials added | ✅ Done |
| 5 | Shared Libraries — concept + setup | ✅ Done |
| 6 | Created `jenkins-shared-libraries` GitHub repo | ✅ Done |
| 7 | `vars/hello.groovy` — simple function | ✅ Done |
| 8 | `vars/clone.groovy` — git clone function | ✅ Done |
| 9 | `vars/docker_build.groovy` — docker build function | ✅ Done |
| 10 | `vars/docker_push.groovy` — docker push with credentials | ✅ Done |
| 11 | Global Untrusted Pipeline Libraries configured in Jenkins | ✅ Done |
| 12 | `@Library("Shared") _` used in pipeline | ✅ Done |
| 13 | 5-stage pipeline — Hello+Code+Build+Push+Deploy | ✅ Done |
| 14 | Build #12 — SUCCESS in ~7 seconds! | ✅ Done |
| 15 | User Management — created user "Ritik" | ✅ Done |

---

## 🔗 GitHub Webhook — Auto CD

### What is a Webhook?
When you push code to GitHub, GitHub sends a POST request to Jenkins URL — Jenkins automatically triggers the pipeline. Zero manual builds needed!

```
Developer pushes code to GitHub
            ↓
GitHub sends POST request to Jenkins webhook URL
            ↓
Jenkins detects push → triggers pipeline automatically
            ↓
Code → Build → Push → Deploy — all automatic! ✅
```

### Webhook Configuration:
```
GitHub Repo → Settings → Webhooks → Add webhook

Payload URL: http://34.228.55.4:8080/github-webhook/
Content type: application/x-www-form-urlencoded
Secret: (empty)
SSL verification: Enable
Events: Send me everything ✅
Active: ✅
```

### Jenkins Trigger setting:
```
Pipeline Configure → Triggers → 
✅ GitHub hook trigger for GITScm polling
```

### Webhook delivery verified:
```
Recent Deliveries tab:
✅ ping — redelivery — 2026-05-17 12:29:11
```

---

## 📚 Jenkins Shared Libraries

### What are Shared Libraries?
Shared Libraries allow you to write Groovy functions ONCE and reuse them across ALL pipelines. No more copy-pasting code!

```
Without Shared Libraries:
Pipeline 1 → docker build code copy-pasted
Pipeline 2 → docker build code copy-pasted
Pipeline 3 → docker build code copy-pasted
Problem: Update in one place = update everywhere ❌

With Shared Libraries:
vars/docker_build.groovy → ONE function
Pipeline 1 → docker_build("app","latest","user")
Pipeline 2 → docker_build("api","v2","user")
Pipeline 3 → docker_build("web","main","user")
Update once → all pipelines updated ✅
```

### Repository Structure:
```
jenkins-shared-libraries/        ← GitHub repo
└── vars/
    ├── hello.groovy             ← def call() { echo "Hello Dosti" }
    ├── clone.groovy             ← def call(url, branch) { git clone }
    ├── docker_build.groovy      ← def call(name, tag, user) { docker build }
    └── docker_push.groovy       ← def call(name, tag, user) { docker push }
```

### Groovy Files — Actual Code:

**hello.groovy:**
```groovy
def call(){
    echo "Hello Dosti"
}
```

**clone.groovy:**
```groovy
def call(String url, String branch){
    echo "This is cloning the code"
    git url: "${url}", branch: "${branch}"
    echo "Code Clone Successful"
}
```

**docker_build.groovy:**
```groovy
// Define function
def call(String ProjectName, String ImageTag, String DockerHubUser){
    sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} ."
}
```

**docker_push.groovy:**
```groovy
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

## ⚙️ Register Shared Library in Jenkins

```
Manage Jenkins → System → Global Untrusted Pipeline Libraries

Name: Shared
Default version: main
Retrieval method: Modern SCM
SCM: Git
Project Repository: https://github.com/RB5437/jenkins-shared-libraries.git
Credentials: none (public repo)
```

---

## 🎯 Final Pipeline with Shared Libraries

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

## 📊 Stage View — Build #12 SUCCESS

| Stage | Time | Status |
|-------|------|--------|
| Hello | 252ms | ✅ |
| Code | 400ms | ✅ |
| Build | 718ms | ✅ |
| Push to DockerHub | 1s | ✅ |
| Deploy | 416ms | ✅ |
| **Total** | **~7 seconds!** | **✅ SUCCESS** |

---

## 👤 User Management in Jenkins

```
Manage Jenkins → Users → Create User

Username: Ritik
Full name: Ritik Bawane
Email: Ritikbawane5437@gmail.com
Password: ****

Users list:
admin — admin
Ritik — Ritik Bawane ✅
```

---

## 🔐 Jenkins Credentials

```
Manage Jenkins → Credentials → Add

1. ubuntu-ki-key (SSH key for Agent)
   Type: SSH Username with private key
   Username: ubuntu

2. dockerHubcred (DockerHub login)
   Type: Username with password
   Username: ritik2909
   Password: ****
   ID: dockerHubcred
```

---

## 📊 Progress Tracker

| Day | Date | Topic | Status |
|-----|------|-------|--------|
| Day 33 | 15 May | Jenkins Intro + Install + Freestyle | ✅ Done |
| Day 34 | 16 May | Declarative Pipeline + Multi-Node Agent | ✅ Done |
| **Day 35** | **17 May** | **Webhook + Shared Libraries + User Mgmt** | **✅ Done** |
| Day 36 | 18 May | DevSecOps — Trivy + SonarQube | ⬜ |
| Day 37 | 19 May | Jenkins Final Project | ⬜ |

---

*Day 35 of 90 — Jenkins Series | DevOps 90-Day Challenge*
*Ritik Bawane | AWS Certified | RHCSA | Kyndryl MNC*
*GitHub: https://github.com/RB5437/Devops_90-Days*
