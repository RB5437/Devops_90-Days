# Ultimate CI/CD Pipeline — Jenkins End-to-End Project

A complete CI/CD pipeline for a Spring Boot application, built with Jenkins, Maven, SonarQube, Docker, and a GitOps-style deployment manifest update consumed by ArgoCD on Kubernetes.

## Pipeline Stages

| Stage | What it does |
|---|---|
| Checkout | Pulls the latest source from GitHub via Jenkins SCM |
| Build and Test | Runs `mvn clean package` to compile the app and run tests |
| Static Code Analysis | Runs `mvn sonar:sonar` against a self-hosted SonarQube server |
| Build and Push Docker Image | Builds the app image from the `Dockerfile` and pushes it to Docker Hub, tagged with `${BUILD_NUMBER}` |
| Update Deployment File | Updates the image tag in the Kubernetes manifest and pushes the change back to GitHub (ArgoCD watches this and auto-syncs) |

## Tech Stack

- **CI server:** Jenkins (Declarative Pipeline + Docker Pipeline plugin)
- **Build agent:** Docker-in-Docker container (`ritik2909/maven-abhishek-docker-agent:v1`), socket-mounted from the host
- **App:** Spring Boot 2.2.4, built with Apache Maven
- **Code quality:** SonarQube 10.4 (self-hosted on EC2)
- **Registry:** Docker Hub
- **Source + GitOps:** GitHub
- **Deployment:** ArgoCD + Kubernetes / Helm (consumes the manifest updated by this pipeline)

## Required Jenkins Credentials

| Credential ID | Type | Used for |
|---|---|---|
| `sonarqube` | Secret text | SonarQube auth token |
| `docker-cred` | Username/password | Docker Hub login for image push |
| `github` | Secret text | GitHub personal access token for manifest push |

## Folder Structure

```
Java-maven-sonarqube-argocd-helm-k8s/
├── spring-boot-app/                  # Spring Boot source + pom.xml + Dockerfile + JenkinsFile
├── spring-boot-app-manifests/        # Kubernetes deployment.yml (image tag updated by pipeline)
└── ArgoCD/                           # ArgoCD application manifests
```

## Host Prerequisites

- Docker Engine installed on the Jenkins host, with `jenkins` and the EC2 user added to the `docker` group
- Jenkins **Docker Pipeline** plugin installed
- `/var/run/docker.sock` accessible inside the build container (mounted via `args` in the `agent` block)
- Network access from the EC2 instance to: GitHub, Docker Hub, Maven Central, and the SonarQube server

## Running the Pipeline

The Jenkins job (`ultimate-cicd-project`) is configured as **Pipeline script from SCM**, so it always pulls the Jenkinsfile from:

```
Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app/JenkinsFile
```

Trigger a run with **Build Now**. Any change to the Jenkinsfile or Dockerfile must be committed and pushed to GitHub first — editing it locally has no effect on the next build.

## Status

Currently being debugged as part of the **#DevOps90Days** challenge (Day 67). See `ERRORS.md` for every issue hit so far and how each was fixed, and `NOTES.md` for the day's learning log.
