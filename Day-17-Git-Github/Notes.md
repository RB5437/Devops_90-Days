# Day 17 Notes: Git Advanced Concepts (DevOps)

---

# What is Git Branching?

Branching allows you to:

* Work on features independently
* Avoid breaking main code
* Collaborate safely

Default branch → main / master

---

# Types of Branches

1. main → production code
2. dev → development code
3. feature → new feature
4. hotfix → urgent fix

---

# Branch Workflow

main → dev → feature → PR → merge → main

---

# Git Merge

Merge combines branches.

Example:

feature → main

Types:
* Fast-forward merge
* 3-way merge

---

# Git Rebase

Rebase = cleaner history

Instead of merge commit:
* Moves your branch on top of latest code

---

# Merge vs Rebase

Merge:
 Keeps history
 Extra commits

Rebase:
 Clean history
 Risky if used incorrectly

---

# Git Stash

Used to temporarily save changes

Use case:
Switch branch without committing

---

# Git Hooks (Important DevOps Topic)

Git hooks are scripts that run automatically.

Example:
* pre-commit → run flake8
* pre-push → run tests

Used in:
 CI/CD pipelines
 Code quality checks
 Security scanning

---

# Real DevOps Usage

Before commit:
* Lint code (flake8)
* Format code (black)
* Scan secrets

Before push:
* Run tests
* Check build

---

# Summary

Git is not just version control.

It is used in DevOps for:
✔ Automation
✔ Quality checks
✔ CI/CD pipelines
