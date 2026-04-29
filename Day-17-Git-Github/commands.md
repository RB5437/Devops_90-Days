# Day 17 Commands (Git Advanced)

# Create branch
git branch feature-1

# Switch branch
git checkout feature-1

# Create + switch
git checkout -b feature-2

# Merge branch
git checkout main
git merge feature-1

# Rebase
git checkout feature-1
git rebase main

# Stash changes
git stash

# Apply stash
git stash apply

# Delete branch
git branch -d feature-1

# View branches
git branch

# View graph
git log --oneline --graph
