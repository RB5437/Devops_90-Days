#  Git Commands Cheat Sheet

---

##  What is Git?

Git is a **Version Control System (VCS)** used to track code changes, manage history, and collaborate.

---

##  Basic Workflow (Local → GitHub)

```bash
git status
git add <file_name>
git commit -m "message"
git push origin main
```

###  Use:

* `git status` → check current changes
* `git add` → move file to staging
* `git commit` → save changes
* `git push` → upload to GitHub

---

##  Initialization

```bash
git init
```

###  Use:

Create a new Git repository in your project.

---

##  File Tracking

```bash
git status
git add <file_name>
git rm --cached <file_name>
```

###  Use:

* `git status` → shows untracked/staged files
* `git add` → untracked → staged
* `git rm --cached` → unstage file (keep in folder)

---

##  Commit Changes

```bash
git commit -m "your message"
```

###  Use:

Save your changes permanently in Git history.

---

##  Delete & Restore File

```bash
rm <file_name>
git restore <file_name>
```

###  Use:

* `rm` → delete file
* `git restore` → bring file back

---

##  Remote Repository

```bash
git remote -v
git remote set-url origin https://github.com/username/repo.git
```

###  Use:

* `git remote -v` → check connected GitHub repo
* `set-url` → change repository link

---

##  Push Code

```bash
git push origin main
```

###  Use:

Send your local code to GitHub.

---

##  Pull Latest Code

```bash
git pull origin main
git pull origin main --rebase
```

###  Use:

* `pull` → download + merge code
* `rebase` → clean history (no extra commits)

---

##  Rebase Continue

```bash
git rebase --continue
```

###  Use:

Continue after fixing conflicts.

---

## 🔹 Clone Repository

```bash
git clone <repo-url>
```

###  Use:

Download GitHub repo to your local system.

---

##  Branch Commands

```bash
git branch
git branch dev
git switch dev
```

###  Use:

* `git branch` → list branches
* `git branch dev` → create new branch
* `git switch dev` → switch branch

---

##  Git Logs

```bash
git log
git log --oneline
```

###  Use:

* `git log` → full history
* `--oneline` → short history

---

##  Fetch vs Pull

```bash
git fetch
git pull
```

###  Use:

* `fetch` → download changes only
* `pull` → download + apply changes

---

##  Full Workflow Example

```bash
git init
git status
git add testing.py
git commit -m "adding file"
git remote -v
git push origin main
```

---

##  Notes

* **Untracked → Staged → Tracked**
* `origin` = remote repo name
* `main` = default branch
* Always pull before push to avoid errors

---

##  Best Practice

```bash
git status
git add .
git commit -m "message"
git pull origin main --rebase
git push origin main
```

---

