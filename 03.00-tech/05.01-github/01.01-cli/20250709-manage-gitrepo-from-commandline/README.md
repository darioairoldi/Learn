# HowTo: Manage your Git repo from the command line

Managing a Git repository from the command line gives you full control and flexibility over your version control workflow. This guide covers the most important Git commands you'll need for day-to-day repository management.

## Table of Contents
- [Basic Repository Operations](#basic-repository-operations)
- [Viewing History](#viewing-history)
- [Managing Changes](#managing-changes)
- [Working with Branches](#working-with-branches)
- [Stashing Changes](#stashing-changes)
- [Common Workflows](#common-workflows)
- [Best Practices](#best-practices)
- [Quick Reference](#quick-reference)
- [Appendix A: Inside Basic Operations](#appendix-a-inside-basic-operations)
- [Appendix B: Inside Viewing History](#appendix-b-inside-viewing-history)
- [Appendix C: Inside Managing Changes](#appendix-c-inside-managing-changes)
- [Appendix D: Inside Working with Branches](#appendix-d-inside-working-with-branches)
- [Appendix E: Inside Stashing Changes](#appendix-e-inside-stashing-changes)

## Basic Repository Operations

These are the fundamental operations you'll use to interact with Git repositories. They form the foundation of your daily Git workflow, allowing you to obtain, synchronize, and manage your code repositories.

| Operation | Command/Example | Description |
|-----------|----------------|-------------|
| **Clone** | `git clone <repository-url>`<br><mark>`git clone https://github.com/darioairoldi/Learn.git`</mark> | Creates a local copy of a remote repository on your machine |
| **Status** | <mark>`git status`</mark> | Shows the current state of your working directory and staging area |
| **List Branches** | `git branch -a`<br><mark>`git branch -a`</mark> | Shows all local and remote branches available |
| **Checkout Branch** | `git checkout <branch-name>`<br><mark>`git checkout main`</mark> | Switch to an existing branch |
| **Fetch** | `git fetch`<br><mark>`git fetch origin`</mark> | Downloads changes from remote repository without merging them into your local branch |
| **Pull** | `git pull`<br><mark>`git pull origin main`</mark> | Fetches and merges changes from the remote repository into your current branch |
| **Push** | `git push`<br><mark>`git push origin main`</mark> | Uploads your local commits to the remote repository |
| **Add** | `git add .`<br><mark>`git add <filename>`</mark> | Stages changes for the next commit |
| **Commit** | `git commit -m "message"`<br><mark>`git commit -m "Add new feature"`</mark> | Records changes to the repository with a descriptive message |
| **Stash All Changes** | `git stash -u`<br><mark>`git stash -u`</mark> | Temporarily save all changes including untracked files |
| **Undo All Changes** | `git reset --hard HEAD`<br><mark>`git reset --hard HEAD`</mark> | ⚠️ Permanently discard all uncommitted changes |

## Viewing History

Understanding your project's history is crucial for tracking changes, debugging issues, and collaborating with others. Git provides powerful tools to explore commits, authors, and file changes over time.

| Operation | Command/Example | Description |
|-----------|----------------|-------------|
| **Show History** | `git log`<br><mark>`git log --oneline`</mark> | Display commit history in various formats |
| **Limit Results** | `git log -5`<br><mark>`git log -10`</mark> | Show only the last N commits |
| **Show Changes** | `git log --stat`<br><mark>`git log --stat --oneline`</mark> | Display commits with file change statistics |
| **Graph View** | `git log --graph`<br><mark>`git log --oneline --graph --all`</mark> | Show commit history as a visual graph |
| **Filter by Author** | `git log --author="Name"`<br><mark>`git log --author="John Doe"`</mark> | Show commits by a specific author |
| **Filter by Date** | `git log --since="date"`<br><mark>`git log --since="2024-01-01"`</mark> | Show commits within a date range |
| **Show Specific Commit** | `git show <commit-hash>`<br><mark>`git show HEAD`</mark> | Display detailed information about a specific commit |

## Managing Changes

Git allows you to undo changes and return to previous states in your repository. These operations are powerful but should be used carefully, especially when working with shared repositories.

| Operation | Command/Example | Description |
|-----------|----------------|-------------|
| **Soft Reset** | `git reset --soft <commit-hash>`<br><mark>`git reset --soft HEAD~1`</mark> | Undo commits but keep changes staged |
| **Mixed Reset** | `git reset <commit-hash>`<br><mark>`git reset HEAD~1`</mark> | Undo commits and unstage changes (default) |
| **Hard Reset** | `git reset --hard <commit-hash>`<br><mark>`git reset --hard HEAD~1`</mark> | ⚠️ Permanently discard all changes |
| **Reset to HEAD** | `git reset --hard HEAD`<br><mark>`git reset --hard HEAD`</mark> | Discard all uncommitted changes |
| **Revert Commit** | `git revert <commit-hash>`<br><mark>`git revert HEAD`</mark> | Create new commit that undoes previous commit |
| **Undo Last Commit** | `git reset --soft HEAD~1`<br><mark>`git reset --soft HEAD~1`</mark> | Keep changes but undo last commit |

**⚠️ Warning:** Hard reset permanently discards changes. Use with caution!

## Working with Branches

Branches allow you to work on different features or experiments in parallel without affecting the main codebase. This is essential for collaborative development and organizing your work.

| Operation | Command/Example | Description |
|-----------|----------------|-------------|
| **Create & Switch** | `git checkout -b <branch-name>`<br><mark>`git checkout -b feature/login`</mark> | Create new branch and switch to it |
| **Create Fix Branch** | `git checkout -b fix/<issue>`<br><mark>`git checkout -b fix/login-bug`</mark> | Create fix branch from current branch |
| **Create & Switch (New)** | `git switch -c <branch-name>`<br><mark>`git switch -c feature/login`</mark> | Modern syntax for creating new branch |
| **Switch Branch** | `git checkout <branch-name>`<br><mark>`git checkout main`</mark> | Switch to existing branch |
| **Switch Branch (New)** | `git switch <branch-name>`<br><mark>`git switch main`</mark> | Modern syntax for switching branches |
| **Delete Branch** | `git branch -d <branch-name>`<br><mark>`git branch -d feature/login`</mark> | Delete a merged branch |
| **Force Delete** | `git branch -D <branch-name>`<br><mark>`git branch -D feature/login`</mark> | Force delete unmerged branch |
| **Rename Branch** | `git branch -m <new-name>`<br><mark>`git branch -m feature/authentication`</mark> | Rename current branch |
| **Cherry-pick Commit** | `git cherry-pick <commit-hash>`<br><mark>`git cherry-pick abc1234`</mark> | Apply specific commit from another branch |
| **Cherry-pick Range** | `git cherry-pick <start>..<end>`<br><mark>`git cherry-pick abc1234..def5678`</mark> | Apply multiple commits from another branch |
| **Create Fix Branch** | `git checkout development && git pull && git checkout -b fix/<issue-name>`<br><mark>`git checkout development && git pull && git checkout -b fix/login-bug`</mark> | Create a fix branch from latest development |

## Stashing Changes

Stashing temporarily saves your uncommitted changes so you can work on something else and come back later. This is essential when you need to quickly switch contexts without losing your work.

| Operation | Command/Example | Description |
|-----------|----------------|-------------|
| **Stash Changes** | `git stash`<br><mark>`git stash`</mark> | Save uncommitted changes temporarily |
| **Stash with Message** | `git stash push -m "message"`<br><mark>`git stash push -m "WIP: login form"`</mark> | Stash with descriptive message |
| **Stash All Files** | `git stash -u`<br><mark>`git stash -u`</mark> | Include untracked files in stash |
| **Apply Latest Stash** | `git stash pop`<br><mark>`git stash pop`</mark> | Apply most recent stash and remove it |
| **Apply Specific Stash** | `git stash apply stash@{0}`<br><mark>`git stash apply stash@{1}`</mark> | Apply specific stash without removing it |
| **List Stashes** | `git stash list`<br><mark>`git stash list`</mark> | Show all saved stashes |
| **Show Stash Contents** | `git stash show`<br><mark>`git stash show stash@{0}`</mark> | Display what's in a stash |
| **Drop Stash** | `git stash drop stash@{0}`<br><mark>`git stash drop stash@{0}`</mark> | Delete a specific stash |
| **Clear All Stashes** | `git stash clear`<br><mark>`git stash clear`</mark> | Remove all stashes |

## Common Workflows

### Daily Development Workflow
```bash
# Start of day - sync with remote
git pull

# Work on your changes...
# Stage and commit your work
git add .
git commit -m "Implement user login validation"

# Push your changes
git push
```

### Feature Branch Workflow
```bash
# Create feature branch
git checkout -b feature/user-dashboard

# Work and commit changes
git add .
git commit -m "Add user dashboard layout"

# Push feature branch
git push -u origin feature/user-dashboard

# When ready to merge, switch to main and pull latest
git checkout main
git pull

# Merge feature branch
git merge feature/user-dashboard
git push

# Clean up
git branch -d feature/user-dashboard
```

### Emergency Fix Workflow
```bash
# You're working on something but need to make an urgent fix
git stash push -m "WIP: new feature development"

# Switch to main and create hotfix branch
git checkout main
git pull
git checkout -b hotfix/critical-bug

# Make your fix and commit
git add .
git commit -m "Fix critical security vulnerability"
git push -u origin hotfix/critical-bug

# After fix is deployed, restore your work
git checkout feature/your-feature
git stash pop
```

### Cherry-pick Workflow (IntegrationFeature → Development)
```bash
# Step 1: Find the commits you want to cherry-pick
git checkout IntegrationFeature
git log --oneline
# Note the commit hashes you want to pick

# Step 2: Switch to target branch (development)
git checkout development
git pull  # Make sure development is up to date

# Step 3: Cherry-pick specific commits
git cherry-pick <commit-hash>
# Example: git cherry-pick abc1234

# Step 4: Cherry-pick multiple commits (if needed)
git cherry-pick <commit1> <commit2> <commit3>
# Example: git cherry-pick abc1234 def5678 ghi9012

# Step 5: Cherry-pick a range of commits
git cherry-pick <start-commit>..<end-commit>
# Example: git cherry-pick abc1234..def5678

# Step 6: Push the changes
git push origin development
```

### Cherry-pick with Conflict Resolution
```bash
# If conflicts occur during cherry-pick
git cherry-pick abc1234
# Git will pause and show conflicts

# Resolve conflicts in your editor, then:
git add .
git cherry-pick --continue

# If you want to abort the cherry-pick
git cherry-pick --abort

# If you want to skip this commit
git cherry-pick --skip
```

### Create Fix Branch from Development
```bash
# Step 1: Switch to development branch and update it
git checkout development
git pull origin development

# Step 2: Create and switch to new fix branch from development
git checkout -b fix/issue-description
# Example: git checkout -b fix/login-validation-bug

# Step 3: Make your fixes and commit
git add .
git commit -m "Fix login validation bug"

# Step 4: Push the fix branch
git push -u origin fix/issue-description

# Step 5: When ready, merge back to development
git checkout development
git pull origin development  # Get latest changes
git merge fix/issue-description
git push origin development

# Step 6: Clean up (optional)
git branch -d fix/issue-description  # Delete local branch
git push origin --delete fix/issue-description  # Delete remote branch
```

## Best Practices

1. **Commit Often**: Make small, focused commits with descriptive messages
2. **Pull Before Push**: Always pull the latest changes before pushing
3. **Use Branches**: Create feature branches for new work
4. **Stash Wisely**: Use stash to temporarily save work when switching contexts
5. **Be Careful with Reset**: Hard reset permanently loses changes
6. **Review Before Push**: Use `git status` and `git diff` to review changes

## Quick Reference

| Command | Description |
|---------|-------------|
| `git clone <url>` | Clone repository |
| `git fetch` | Download changes without merging |
| `git pull` | Fetch and merge changes |
| `git push` | Upload commits to remote |
| `git log --oneline` | Show commit history |
| `git reset --hard <commit>` | Reset to previous commit |
| `git checkout -b <branch>` | Create new branch |
| `git stash` | Temporarily save changes |
| `git stash pop` | Restore stashed changes |
| `git status` | Show working directory status |

Remember: Git is powerful but can be destructive. Always make sure you understand what a command does before running it, especially commands like `reset --hard` and `push --force`.

---

## Appendix A: Inside Basic Operations

This section provides detailed explanations and examples for each of the basic Git operations covered in the main guide.

### Clone a Repository
Clone creates a local copy of a remote repository on your machine.

```bash
# Clone a repository
git clone <repository-url>

# Clone to a specific directory
git clone <repository-url> <directory-name>

# Clone a specific branch
git clone -b <branch-name> <repository-url>
```

**Example:**
```bash
git clone https://github.com/darioairoldi/Learn.git
git clone https://github.com/darioairoldi/Learn.git E:\dev\darioairoldi\Learn
```

### Fetch Changes
Fetch downloads changes from the remote repository without merging them into your local branch.

```bash
# Fetch changes from origin
git fetch

# Fetch from a specific remote
git fetch origin

# Fetch all remotes
git fetch --all
```

### Pull Changes
Pull fetches and merges changes from the remote repository into your current branch.

```bash
# Pull changes from the current branch's upstream
git pull

# Pull from a specific remote and branch
git pull origin main

# Pull with rebase instead of merge
git pull --rebase
```

### Push Changes
Push uploads your local commits to the remote repository.

```bash
# Push to the current branch's upstream
git push

# Push to a specific remote and branch
git push origin main

# Push a new branch and set upstream
git push -u origin <branch-name>

# Force push (use with caution)
git push --force
```

### Sync Repository
To fully synchronize your repository with the remote:

```bash
# Complete sync workflow
git fetch --all
git pull
git push
```

### Status, Add, and Commit
These commands form the core of staging and committing changes:

```bash
# Check current status
git status

# Stage all changes
git add .

# Stage specific files
git add <filename>

# Commit with message
git commit -m "Your commit message"

# Add and commit in one step
git commit -am "Your commit message"
```

**Example workflow:**
```bash
# Check what's changed
git status

# Stage your changes
git add .

# Commit with a descriptive message
git commit -m "Add user authentication feature"

# Push to remote
git push
```

## Appendix B: Inside Viewing History

This section provides detailed explanations and examples for viewing and exploring your repository's history.

### List Commits
View the commit history of your repository.

```bash
# Show commit history
git log

# Show one-line commit history
git log --oneline

# Show last 5 commits
git log -5

# Show commits with file changes
git log --stat

# Show commits in a graph format
git log --oneline --graph --all

# Show commits by a specific author
git log --author="Author Name"

# Show commits in a date range
git log --since="2024-01-01" --until="2024-12-31"
```

**Example output:**
```
commit abc1234 (HEAD -> main, origin/main)
Author: John Doe <john@example.com>
Date:   Wed Jul 9 10:30:00 2025 +0100

    Add new feature for user authentication

commit def5678
Author: Jane Smith <jane@example.com>
Date:   Tue Jul 8 15:45:00 2025 +0100

    Fix bug in payment processing
```

### Show Specific Commit
Display detailed information about a specific commit:

```bash
# Show details of a specific commit
git show <commit-hash>

# Show the last commit
git show HEAD

# Show the commit before last
git show HEAD~1

# Show changes in a specific file for a commit
git show <commit-hash>:<filename>
```

## Appendix C: Inside Managing Changes

This section provides detailed explanations for undoing changes and managing your repository state.

### Reset to a Previous Commit
Reset allows you to undo changes and return to a previous state.

```bash
# Soft reset (keeps changes in staging area)
git reset --soft <commit-hash>

# Mixed reset (keeps changes in working directory, default)
git reset <commit-hash>

# Hard reset (discards all changes - USE WITH CAUTION)
git reset --hard <commit-hash>

# Reset to the last commit
git reset --hard HEAD

# Reset to 3 commits ago
git reset --hard HEAD~3
```

### Revert vs Reset
Understanding the difference between revert and reset:

```bash
# Revert creates a new commit that undoes changes
git revert <commit-hash>

# Reset changes history (dangerous for shared repos)
git reset --hard <commit-hash>
```

**When to use each:**

- **Revert**: When working on shared branches (safe)
- **Reset**: When working on local branches only (destructive)

**⚠️ Warning:** Hard reset permanently discards changes. Make sure you want to lose those changes before using it.

## Appendix D: Inside Working with Branches

This section provides detailed explanations for branch management and workflows.

### Create a New Branch with Current Changes
Create and switch to a new branch while preserving your current work.

```bash
# Create a new branch and switch to it
git checkout -b <new-branch-name>

# Alternative syntax (Git 2.23+)
git switch -c <new-branch-name>

# Create branch from a specific commit
git checkout -b <new-branch-name> <commit-hash>
```

**Example workflow:**
```bash
# You're working on main with uncommitted changes
git status
# shows modified files

# Create new branch with current changes
git checkout -b feature/new-feature
# Your changes are now on the new branch
```

### Branch Management Operations
```bash
# List all branches
git branch -a

# Switch to an existing branch
git checkout <branch-name>
git switch <branch-name>  # Git 2.23+

# Delete a branch
git branch -d <branch-name>

# Force delete unmerged branch
git branch -D <branch-name>

# Rename current branch
git branch -m <new-name>

# Push new branch to remote
git push -u origin <branch-name>
```

### Merging Branches
```bash
# Merge a branch into current branch
git merge <branch-name>

# Merge with no fast-forward (creates merge commit)
git merge --no-ff <branch-name>

# Abort a merge in progress
git merge --abort
```

### Cherry-picking Changes Between Branches
Cherry-pick allows you to apply specific commits from one branch to another without merging the entire branch.

```bash
# Basic cherry-pick (single commit)
git cherry-pick <commit-hash>

# Cherry-pick multiple specific commits
git cherry-pick <commit1> <commit2> <commit3>

# Cherry-pick a range of commits (exclusive of start, inclusive of end)
git cherry-pick <start-commit>..<end-commit>

# Cherry-pick a range including the start commit
git cherry-pick <start-commit>^..<end-commit>

# Cherry-pick without committing (stage changes only)
git cherry-pick --no-commit <commit-hash>

# Cherry-pick and edit the commit message
git cherry-pick --edit <commit-hash>
```

**Real-world example: IntegrationFeature → Development**
```bash
# 1. First, identify the commits you want from IntegrationFeature
git checkout IntegrationFeature
git log --oneline -10
# Output might show:
# abc1234 Add user authentication API
# def5678 Fix login validation bug  
# ghi9012 Update user profile endpoint

# 2. Switch to development branch
git checkout development
git pull origin development  # Ensure it's up to date

# 3. Cherry-pick specific commits
git cherry-pick def5678  # Pick the bug fix
git cherry-pick ghi9012  # Pick the profile update

# 4. Or pick multiple commits at once
git cherry-pick abc1234 def5678 ghi9012

# 5. Push the changes
git push origin development
```

**Handling conflicts during cherry-pick:**
```bash
# If conflicts occur
git cherry-pick abc1234
# Git will show: error: could not apply abc1234...

# View the conflicted files
git status

# Edit files to resolve conflicts, then
git add <resolved-files>
git cherry-pick --continue

# If you want to abandon the cherry-pick
git cherry-pick --abort

# If you want to skip this particular commit
git cherry-pick --skip
```

## Appendix E: Inside Stashing Changes

This section provides detailed explanations for stashing and managing temporary changes.

### Stash Operations
```bash
# Stash current changes
git stash

# Stash with a message
git stash push -m "Work in progress on feature X"

# Stash including untracked files
git stash -u

# Stash including ignored files
git stash -a

# Stash only specific files
git stash push -m "message" -- <file1> <file2>
```

### Stash Restoration
```bash
# Apply the most recent stash
git stash pop

# Apply a specific stash
git stash apply stash@{0}

# Apply stash without removing it from stash list
git stash apply

# List all stashes
git stash list

# Show stash contents
git stash show

# Show detailed stash contents
git stash show -p

# Drop a specific stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

**Example stash workflow:**
```bash
# You're working on a feature but need to switch branches
git stash push -m "Half-completed login form"
git checkout main
# Do some work on main
git checkout feature/login
git stash pop  # Restore your work
```

### Advanced Stashing
```bash
# Create a branch from stash
git stash branch <branch-name> stash@{0}

# Stash only staged changes
git stash --staged

# Stash everything except staged changes
git stash --keep-index
```

## 5. Create Fix Branch from Development

When you need to create a fix branch from the development branch to work on a specific issue:

### 5.1 Switch to Development and Update

```bash
# Switch to development branch
git checkout development

# Pull latest changes
git pull origin development
```

### 5.2 Create Fix Branch

```bash
# Create and switch to fix branch
git checkout -b fix/login-bug

# Or use switch (Git 2.23+)
git switch -c fix/login-bug
```

### 5.3 Work on the Fix

```bash
# Make your changes
# ... edit files ...

# Stage changes
git add .

# Commit the fix
git commit -m "Fix: Resolve login authentication issue"
```

### 5.4 Push Fix Branch

```bash
# Push fix branch to remote
git push origin fix/login-bug
```

### 5.5 Create Pull Request

Create a pull request to merge your fix back into the development branch through your Git hosting platform (GitHub, GitLab, etc.).

### 5.6 Clean Up After Merge

```bash
# Switch back to development
git checkout development

# Pull the merged changes
git pull origin development

# Delete local fix branch
git branch -d fix/login-bug

# Delete remote fix branch (optional)
git push origin --delete fix/login-bug
```

## 6. Cherry-pick Commits Between Branches

Cherry-pick allows you to apply specific commits from one branch to another without merging the entire branch.

### 6.1 Basic Cherry-pick

```bash
# Cherry-pick a single commit
git cherry-pick <commit-hash>

# Cherry-pick multiple specific commits
git cherry-pick <commit1> <commit2> <commit3>
```

### 6.2 Cherry-pick a Range of Commits

```bash
# Cherry-pick a range of commits (exclusive of start, inclusive of end)
git cherry-pick <start-commit>..<end-commit>

# Cherry-pick a range including the start commit
git cherry-pick <start-commit>^..<end-commit>
```

### 6.3 Cherry-pick Options

```bash
# Cherry-pick without committing (stage changes only)
git cherry-pick --no-commit <commit-hash>

# Cherry-pick and edit the commit message
git cherry-pick --edit <commit-hash>
```

### 6.4 Handling Conflicts During Cherry-pick

If conflicts occur during cherry-pick:

```bash
# Start cherry-pick
git cherry-pick <commit-hash>

# Git will pause and show conflicts

# Resolve conflicts in your editor, then:
git add <resolved-files>
git cherry-pick --continue

# If you want to abort the cherry-pick
git cherry-pick --abort

# If you want to skip this commit
git cherry-pick --skip
```
