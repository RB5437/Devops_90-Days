

##  Git Hooks Overview
Git hooks are scripts that run automatically at certain points in the Git lifecycle.

### Types of Hooks:
- **Pre-commit** → Runs before commit
- **Commit-msg** → Validates commit message
- **Pre-push** → Runs before push

---

##  Why Use Hooks?
- Prevent bad code from being committed
- Enforce coding standards
- Catch syntax errors early
- Avoid committing secrets (API keys, passwords)

---

##  Pre-commit Hook Concept

Before committing:
- Code is checked automatically
- If errors exist → commit is blocked
- If everything is correct → commit proceeds

Example checks:
- Syntax errors
- Code quality
- API keys / secrets detection

---

##  Flake8 (Python Code Quality Tool)

- Used for checking Python code quality
- Detects:
  - Syntax errors
  - Style issues
  - Bugs

 Installed using pip and added in pre-commit hook

---

##  Git Hook Flow

1. Code changes
2. `git add`
3. Pre-commit hook runs
4. If checks pass → commit success
5. If checks fail → commit blocked

---

##  Secret Detection in Hooks

Prevent committing sensitive data like:
- Passwords
- API keys
- Secret keys

If detected → commit fails

---

##  CI/CD Concept

### GitHub Actions / Jenkins Pipeline

When you push code:
- Build runs
- Tests run
- Code quality checks run (like pylint)
- Deployment can happen

---

##  GitHub Actions Flow

1. Push code to GitHub repo
2. Go to **Actions tab**
3. Workflow runs automatically
4. Tools like pylint check code
5. View results in Actions panel

---

##  CI vs Hooks

| Feature        | Git Hooks        | CI/CD (GitHub Actions) |
|---------------|----------------|------------------------|
| Runs Locally  |  Yes           |  No                 |
| Runs on Push  |  No            |  Yes                |
| Speed         | Fast           | Slower                |
| Use Case      | Early checks   | Full pipeline         |

---

##  Deployment Idea

- GitHub integrates with AWS
- Example:
  - Upload project to GitHub
  - Use pipeline to deploy to AWS S3 (portfolio site)

---

##  Key Learning

- Hooks prevent bad commits
- Flake8 ensures code quality
- CI/CD automates testing & deployment
- Combining both = strong workflow
