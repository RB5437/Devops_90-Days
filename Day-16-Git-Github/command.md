

##  Initialize Git

```bash
git init
```

---

## Check Hidden Files (.git folder)

```bash
ls -a
```

---

##  Go to Hooks Directory

```bash
cd .git/hooks
ls
```

---

##  Create Pre-commit Hook

```bash
vim pre-commit
```

---

##  Basic Pre-commit Hook (Flake8)

```bash
#!/bin/sh

# Get staged Python files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')

# Run flake8 on staged files
if [ "$files" != "" ]; then
    python -m flake8 $files
    if [ $? -ne 0 ]; then
        echo " Code quality failed. Fix errors before commit."
        exit 1
    fi
fi
```

---

##  Make Hook Executable

```bash
chmod +x pre-commit
```

---

##  Install Flake8

```bash
 Python -m  install flake8
```

---

##  Add & Commit Code

```bash
git add demo.py
git commit -m "added demo file"
```

---

##  Secret Detection (Add to Hook)

```bash
if git grep -q -E "password|secret|api_key"; then
    echo " Sensitive data detected! Commit blocked."
    exit 1
fi
```

---

##  General Git Commands

### Add all files

```bash
git add .
```

### Commit

```bash
git commit -m "your message"
```

### Push

```bash
git push origin main
```

### Pull

```bash
git pull origin main
```

---

##  Quick Workflow

```bash
git init
git add .
git commit -m "first commit"
git push origin main
```
