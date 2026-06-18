# ERRORS.md — Troubleshooting Log

Every error hit while building this pipeline, with root cause and the fix that resolved it. Newest fix is at the bottom; the pipeline progressed one stage further each time one of these was solved.

---

### 1. Groovy syntax error: invalid backslash continuation

**Symptom**
```
WorkflowScript: ... compile error around mvn sonar:sonar \
```

**Root cause**
A trailing space was left after the line-continuation backslash (`mvn sonar:sonar \ ` instead of `mvn sonar:sonar \`). Groovy/the shell parser treats the space-after-backslash as an invalid character.

**Fix**
Put the whole `mvn sonar:sonar` command on a single line, or make sure no trailing whitespace follows any `\` continuation character.

---

### 2. `cd: can't cd to <folder>` / folder not found

**Symptom**
```
+ cd java-maven-sonarqube-argocd-helm-k8s/spring-boot-app
script.sh: 2: cd: can't cd to java-maven-sonarqube-argocd-helm-k8s/spring-boot-app
```

**Root cause**
Linux is case-sensitive. The actual GitHub folder is `Java-maven-sonarqube-argocd-helm-k8s` (capital J), but some pipeline stages referenced the lowercase `java-maven-...`.

**Fix**
Use the exact same capitalization (`Java-maven-sonarqube-argocd-helm-k8s`) in every `cd` across every stage — Build and Test, Static Code Analysis, Docker build, and the deployment manifest update.

---

### 3. Maven `MissingProjectException` — no POM in directory

**Symptom**
```
[ERROR] The goal you specified requires a project to execute but there is no POM in this directory
```

**Root cause**
`mvn clean package` was run one directory level too high — `cd` stopped at `Java-maven-sonarqube-argocd-helm-k8s` instead of going one level deeper into `Java-maven-sonarqube-argocd-helm-k8s/spring-boot-app`, where `pom.xml` actually lives.

**Fix**
`cd` all the way into the `spring-boot-app` subfolder before running any `mvn` command.

---

### 4. Declarative pipeline parse error — "Expected a stage"

**Symptom**
```
org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:
WorkflowScript: 10: Expected a stage @ line 10, column 1.
```

**Root cause**
Malformed pipeline structure — typically a `stages { }` block closed too early, a stray closing brace, or content placed outside the `stages` block. The error always points near the structural break, not necessarily the exact bad line.

**Fix**
Re-validate the brace structure of the whole Jenkinsfile: every `stage('Name') { steps { ... } }` must be nested correctly inside a single `stages { }` block. Comparing against a known-good Jenkinsfile structure (or using `Pipeline Syntax` validation in Jenkins) catches this fast.

---

### 5. SonarQube `UnsupportedClassVersionError` (JDK mismatch)

**Symptom**
```
java.lang.UnsupportedClassVersionError: org/sonar/batch/bootstrapper/EnvironmentInformation
has been compiled by a more recent version of the Java Runtime (class file version 61.0),
this version of the Java Runtime only recognizes class file versions up to 55.0
```

**Root cause**
The SonarQube server (10.4.1) requires a **Java 17** scanner engine (class file version 61), but the Maven build agent only had **Java 11** (AdoptOpenJDK, class file version 55) installed.

**Fix**
Install JDK 17 and point `JAVA_HOME` at it just for the `Static Code Analysis` step:
```bash
apt-get update -qq && apt-get install -y -qq openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

---

### 6. Docker client/daemon API version mismatch

**Symptom**
```
Error response from daemon: client version 1.41 is too old.
Minimum supported API version is 1.44, please upgrade your client to a newer version
```

**Root cause**
The build agent's bundled Docker CLI (API 1.41, ~Docker 20.10 era) is older than what the host's Docker daemon now requires (API 1.44+), even though the container talks to the host daemon via the mounted socket.

**Fix**
Pin the client to a version the daemon accepts, via an environment variable on the stage:
```groovy
environment {
    DOCKER_API_VERSION = "1.44"
}
```
(If basic `build`/`push` still fail with this set, the more thorough fix is downloading a newer static `docker` CLI binary into the container before running any docker commands.)

---

### 7. Docker image pull failure — deprecated base image

**Symptom**
```
ERROR: pull access denied, repository does not exist or may require authorization:
server message: insufficient_scope: authorization failed
adoptopenjdk/openjdk21:alpine-jre: failed to resolve source metadata
```

**Root cause**
The Dockerfile's `FROM adoptopenjdk/openjdk21:alpine-jre` references an image from the AdoptOpenJDK Docker Hub org, which was deprecated and folded into **Eclipse Temurin** — the image simply no longer exists.

**Fix**
Update the Dockerfile's base image:
```dockerfile
FROM eclipse-temurin:21-jre-alpine
```

---

## Quick diagnostic checklist for next time

- [ ] Does every `cd` in the Jenkinsfile use identical, exact-case folder names?
- [ ] Did `mvn clean package` actually run from the folder containing `pom.xml`?
- [ ] Does the SonarQube server version require a newer JDK than the build agent has?
- [ ] Has the host's Docker Engine been updated recently, breaking the agent's bundled CLI?
- [ ] Are all base images in the Dockerfile still published and maintained?
- [ ] Was the fix actually pushed to GitHub? (This pipeline pulls the Jenkinsfile via SCM — local edits alone do nothing.)
