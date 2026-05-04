#   Git & GitHub (Local → GitHub Push)

##  Topics Covered

* Local to GitHub Push
* Remote Repository
* Git Pull & Rebase
* Clone vs Fork
* Branching Strategy
* Pull Request (PR)
* Fetch vs Pull

---

##  Local to GitHub Flow

```
Local Repo (PC) → Git → GitHub (Remote Repo)
```

* `git push` → send code to GitHub
* `git pull` → get latest code from GitHub

 Authentication using Personal Access Token (PAT)

---

##  Important Git Commands Flow

1. Check status
2. Add file
3. Commit changes
4. Push to GitHub

---

##  Remote Repository

* `origin` → default remote name
* Used to connect local repo with GitHub

---

##  Git Rebase

* Used to keep history clean
* Apply your changes on top of latest code

---

##  Clone vs Fork

### Clone

* Copy GitHub repo → Local system

```bash
git clone <repo-url>
```

### Fork

* Copy someone else's repo → Your GitHub account
* Used in open source contribution

---

##  Git Pull

* Used to get latest changes from GitHub

```bash
git pull origin main
```

---

##  Branching Strategy

Branches:

* main / master → Production
* dev → Development
* feature → New features

Flow:

```
main → dev → feature
```

---

##  Git Log

* Shows commit history
* `HEAD` → latest commit

---

## Pull Request (PR)

Steps:

1. Push code to GitHub
2. Create Pull Request
3. Review changes
4. Merge into main branch

---

##  Fetch vs Pull

### Fetch

* Only downloads changes

```bash
git fetch
```

### Pull

* Downloads + merges changes

```bash
git pull
```

