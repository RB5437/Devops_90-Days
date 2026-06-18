# DevOps 90 Days Challenge — Day 67 Notes

## Goal for today

Get the Jenkins pipeline (Checkout → Build and Test → Static Code Analysis → Build and Push Docker Image → Update Deployment File) to a clean, fully green run.

## What I worked on

- Cleaned up the Jenkinsfile: replaced the dummy `echo passed` Checkout step with a real `checkout scm`, fixed inconsistent folder casing across stages, and removed an invalid multiline `mvn sonar:sonar \` continuation that Groovy couldn't parse.
- Debugged a real `UnsupportedClassVersionError` from SonarQube — root-caused it to a JDK mismatch between my SonarQube server (10.4, needs Java 17) and my Maven build agent (Java 11 only).
- Hit a Docker client/daemon API version mismatch (`client version 1.41 is too old`) because the host's Docker Engine had been upgraded but the build agent's bundled Docker CLI hadn't.
- Found that my Dockerfile's base image (`adoptopenjdk/openjdk21`) no longer exists on Docker Hub — the AdoptOpenJDK org was deprecated and folded into Eclipse Temurin.

## Key learnings

- **Linux is case-sensitive.** A folder referenced as `Java-maven-...` in one stage and `java-maven-...` in another causes silent `cd: no such file or directory` failures — easy to miss when skimming a long Jenkinsfile.
- **Read the full console log, not just the last few lines.** Several of today's "Build and Push Docker Image failed" reports actually had the real error several stages earlier — Jenkins still runs later stages' shells which mask the original cause if you only check the final error block.
- **SonarQube server version dictates the JDK the scanner needs**, not the JDK your app is compiled with. A 10.x server can fail loudly with a Java bytecode version error even though the app build itself succeeded.
- **Docker-in-Docker setups can silently drift** — the build container's CLI version and the host daemon's API version are two separate things that can fall out of sync after host updates.
- **Tutorials age.** Public Docker base images referenced in older guides (like `adoptopenjdk/*`) can disappear entirely; always have a plan to swap to a maintained equivalent (Eclipse Temurin, in this case).

## Still pending / next steps

- Confirm the `Build and Push Docker Image` stage passes cleanly after the Dockerfile base-image fix.
- Validate the `Update Deployment File` stage pushes the updated manifest back to GitHub without errors.
- Once the pipeline is fully green, check that ArgoCD picks up the new image tag and syncs the deployment.
- Consider rebuilding the custom `maven-abhishek-docker-agent` image with JDK 17 and a newer Docker CLI pre-installed, so future builds don't need to install/patch these at runtime every single time.
