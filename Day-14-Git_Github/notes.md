#  Day Notes: Git & GitHub Basics (DevOps)



#  What is Git?

Git is a **Version Control System (VCS)** used in industry to:

* Track source code changes
* Maintain history of code
* Manage different versions
* Enable collaboration

 Created by **Linus Torvalds**

---

#  What is GitHub?

GitHub is a **Source Code Management platform** where:

* Code is stored remotely
* Teams collaborate
* PR (Pull Requests) are used
* CI/CD pipelines (GitHub Actions) run

 Alternatives: GitLab, Bitbucket

---

#  Git Workflow (Basic)

```
Folder → File → Git (VCS) → Push → GitHub → PR → Automation
```

* Developer writes code
* Git tracks changes
* Code pushed to GitHub
* PR created
* Automation (CI/CD) runs

---

#  Git Stores Information

* Author
* Date
* Commit history
* Changes made

 You can:

* Rollback to previous version
* Track who made changes

---

#  File System vs Git (VCS)

## File System

* Cannot recover deleted files
* No version history

## Git (VCS)

* Can restore deleted files
* Can rollback to previous versions
* Tracks changes

---

#  Git File States

### 1. Untracked (Red)

* File not tracked by Git

### 2. Staged (Green)

* File added to staging area

### 3. Tracked

* File committed to repository

---

#  Basic Git Commands

## Initialize repository

```bash id="x1"
git init
```

---

## Check status

```bash id="x2"
git status
```

---

## Add file (Untracked → Staged)

```bash id="x3"
git add <file-name>
```

Example:

```bash id="x4"
git add testing.py
```

---

## Add all files

```bash id="x5"
git add .
```

---

## Commit (Staged → Tracked)

```bash id="x6"
git commit -m "Adding file"
```

---

## Remove from staging

```bash id="x7"
git rm --cached <file-name>
```

---

## Delete file

```bash id="x8"
rm testing.py
```

---

## Restore deleted file

```bash id="x9"
git restore <file-name>
```

---

#  Git Configuration

## Set username

```bash id="x10"
git config --global user.name "your-username"
```

## Set email

```bash id="x11"
git config --global user.email "your-email@example.com"
```

---

#  Step-by-Step Workflow

```bash id="x12"
# Create file
touch testing.py

# Initialize git
git init

# Check status
git status

# Add file
git add testing.py

# Commit file
git commit -m "Adding testing file"

# Delete file
rm testing.py

# Restore file
git restore testing.py
```

---

#  Important Notes

* `git add` → moves file to staging
* `git commit` → saves changes permanently
* `git rm --cached` → removes from staging only
* `git restore` → restores deleted file

---

#  Summary

Git helps you:

* Track code changes
* Collaborate with team
* Recover deleted files
* Manage versions efficiently

---

