#  Git Commands Cheat Sheet

---

## 1. Initialization

### Initialize a Git repository

```bash
git init
```

---

## 2. File Tracking Workflow

### Check repository status

```bash
git status
```

### Add file to staging area

```bash
git add testing.py
```

### Remove file from staging (keep in working directory)

```bash
git rm --cached testing.py
```

---

## 3. Commit Changes

### Commit staged changes

```bash
git commit -m "added testing file"
```

---

## 4. File Deletion & Restore

### Delete file from working directory

```bash
rm testing.py
```

### Restore deleted file

```bash
git restore testing.py
```

---

## 5. Full Workflow Example

```bash
git status
git add testing.py
git status
git rm --cached testing.py
git status
git add testing.py
git status
git commit -m "added testing file"
git status
rm testing.py
git status
git restore testing.py
git status
```

---

##  Notes

* `git add` → moves file to staging area
* `git rm --cached` → removes from staging only
* `rm` → deletes file from system
* `git restore` → recovers deleted file

---

##  Best Practice

Always follow:

```bash
git status → git add → git commit
```

---

