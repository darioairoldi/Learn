# 🚀 CLI Commands to Interact with GitHub Repositories

## 📑 Table of Contents

- [🚀 CLI Commands to Interact with GitHub Repositories](#-cli-commands-to-interact-with-github-repositories)
  - [📑 Table of Contents](#-table-of-contents)
  - [📖 Overview](#-overview)
    - [Available CLI Tools](#available-cli-tools)
    - [Command Categories](#command-categories)
  - [💻 GitHub CLI (gh) Commands](#-github-cli-gh-commands)
    - [Authentication](#authentication)
    - [Repository Management](#repository-management)
    - [Issues and Pull Requests](#issues-and-pull-requests)
    - [GitHub Actions](#github-actions)
    - [Releases](#releases)
    - [Gists](#gists)
  - [🔧 Git Commands](#-git-commands)
    - [Repository Operations](#repository-operations)
    - [Branch Management](#branch-management)
    - [Commit Operations](#commit-operations)
    - [Remote Operations](#remote-operations)
  - [🌐 GitHub REST API via CLI](#-github-rest-api-via-cli)
    - [Basic API Calls](#basic-api-calls)
    - [Artifacts Management](#artifacts-management)
    - [Workflow Runs](#workflow-runs)
    - [Repository Information](#repository-information)
  - [📚 Additional Details](#-additional-details)
    - [gh auth - Authentication Management](#gh-auth---authentication-management)
    - [gh repo - Repository Operations](#gh-repo---repository-operations)
    - [gh pr - Pull Request Management](#gh-pr---pull-request-management)
    - [gh run - GitHub Actions Workflow Management](#gh-run---github-actions-workflow-management)
    - [gh api - Direct API Access](#gh-api---direct-api-access)
 - [gh release - Release Management](#gh-release---release-management)
  - [🔗 References](#-references)
 - [Official Documentation](#official-documentation)
    - [GitHub CLI Resources](#github-cli-resources)
    - [API Documentation](#api-documentation)
    - [Community Resources](#community-resources)

---

## 📖 Overview

### Available CLI Tools

GitHub provides several command-line tools for interacting with repositories:

| Tool | Description | Installation |
|------|-------------|--------------|
| **GitHub CLI (<mark>`gh`</mark>)** | Official GitHub command-line tool | `winget install GitHub.cli` |
| **<mark>Git** | Version control system | `winget install Git.Git` |
| **<mark>GitHub REST API** | Direct API access via `gh api` | Included with GitHub CLI |
| **<mark>PowerShell/Bash** | Scripting environments | Built-in on Windows/Linux |

### Command Categories

GitHub CLI commands are organized into these main categories:

- 🔐 **Authentication** - Login, token management
- 📦 **Repository** - Create, clone, view, fork
- 🐛 **Issues** - Create, list, view, close
- 🔀 **Pull Requests** - Create, review, merge
- ⚙️ **Actions** - Workflows, runs, artifacts
- 🎯 **Releases** - Create, list, download
- 📝 **Gists** - Create, list, view
- 🌐 **API** - Direct REST API access

---

## 💻 GitHub CLI (gh) Commands

### Authentication

```bash
# Check authentication status
gh auth status

# Login to GitHub
gh auth login

# Login with specific scopes
gh auth login --scopes "repo,read:org,workflow"

# Refresh authentication
gh auth refresh

# Logout
gh auth logout
```

### Repository Management

```bash
# List repositories
gh repo list [OWNER]
gh repo list --limit 100
gh repo list --json name,url,description

# View repository details
gh repo view [OWNER/REPO]
gh repo view --web

# Clone repository
gh repo clone OWNER/REPO
gh repo clone OWNER/REPO TARGET-DIR

# Create new repository
gh repo create NAME
gh repo create NAME --public --description "My new repo"
gh repo create NAME --private --source=. --remote=origin

# Fork repository
gh repo fork OWNER/REPO
gh repo fork --clone

# Delete repository (requires confirmation)
gh repo delete OWNER/REPO

# Rename repository
gh repo rename NEW-NAME

# Set repository visibility
gh repo edit --visibility public
gh repo edit --visibility private
```

### Issues and Pull Requests

```bash
# List issues
gh issue list
gh issue list --state open
gh issue list --label bug
gh issue list --assignee @me

# Create issue
gh issue create
gh issue create --title "Bug found" --body "Description"

# View issue
gh issue view 123
gh issue view 123 --web

# Close issue
gh issue close 123

# List pull requests
gh pr list
gh pr list --state open
gh pr list --author @me

# Create pull request
gh pr create
gh pr create --title "Fix bug" --body "Description"
gh pr create --draft

# View pull request
gh pr view 456
gh pr view --web

# Checkout pull request
gh pr checkout 456

# Merge pull request
gh pr merge 456
gh pr merge 456 --squash
gh pr merge 456 --rebase

# Review pull request
gh pr review 456 --approve
gh pr review 456 --comment --body "LGTM"
gh pr review 456 --request-changes
```

### GitHub Actions

```bash
# List workflow runs
gh run list
gh run list --workflow=ci.yml
gh run list --limit 10

# View run details
gh run view RUN-ID
gh run view --log

# Watch run in real-time
gh run watch RUN-ID

# Rerun workflow
gh run rerun RUN-ID

# Cancel run
gh run cancel RUN-ID

# Download run artifacts
gh run download RUN-ID
gh run download RUN-ID --name artifact-name

# List workflows
gh workflow list

# View workflow
gh workflow view WORKFLOW-NAME

# Enable/disable workflow
gh workflow enable WORKFLOW-NAME
gh workflow disable WORKFLOW-NAME

# Trigger workflow
gh workflow run WORKFLOW-NAME
gh workflow run WORKFLOW-NAME --ref branch-name
```

### Releases

```bash
# List releases
gh release list
gh release list --limit 20

# View release
gh release view TAG
gh release view --web

# Create release
gh release create v1.0.0
gh release create v1.0.0 --title "Version 1.0.0" --notes "Release notes"
gh release create v1.0.0 file1.zip file2.tar.gz

# Upload assets to release
gh release upload v1.0.0 file.zip

# Download release assets
gh release download v1.0.0
gh release download v1.0.0 --pattern "*.zip"

# Delete release
gh release delete v1.0.0
```

### Gists

```bash
# List gists
gh gist list
gh gist list --public

# Create gist
gh gist create file.txt
gh gist create --public --desc "My gist" file1.txt file2.txt

# View gist
gh gist view GIST-ID
gh gist view --web

# Edit gist
gh gist edit GIST-ID

# Delete gist
gh gist delete GIST-ID
```

---

## 🔧 Git Commands

### Repository Operations

```bash
# Clone repository
git clone https://github.com/OWNER/REPO.git
git clone git@github.com:OWNER/REPO.git

# Initialize repository
git init
git init --bare

# Add remote
git remote add origin https://github.com/OWNER/REPO.git

# List remotes
git remote -v

# Remove remote
git remote remove origin

# Rename remote
git remote rename old-name new-name
```

### Branch Management

```bash
# List branches
git branch
git branch -a
git branch -r

# Create branch
git branch new-branch
git checkout -b new-branch

# Switch branch
git checkout branch-name
git switch branch-name

# Delete branch
git branch -d branch-name
git branch -D branch-name  # Force delete

# Push branch to remote
git push origin branch-name
git push -u origin branch-name

# Delete remote branch
git push origin --delete branch-name
```

### Commit Operations

```bash
# Stage changes
git add file.txt
git add .
git add -A

# Commit changes
git commit -m "Commit message"
git commit -am "Add and commit"

# Amend last commit
git commit --amend
git commit --amend -m "New message"

# View commit history
git log
git log --oneline
git log --graph --oneline --all

# View specific commit
git show COMMIT-HASH

# Reset commits
git reset HEAD~1     # Soft reset
git reset --hard HEAD~1   # Hard reset
```

### Remote Operations

```bash
# Fetch from remote
git fetch
git fetch origin

# Pull from remote
git pull
git pull origin main

# Push to remote
git push
git push origin main
git push --force# Force push (use carefully!)

# View remote info
git remote show origin
```

---

## 🌐 GitHub REST API via CLI

### Basic API Calls

```bash
# Make GET request
gh api /repos/OWNER/REPO

# Make POST request
gh api -X POST /repos/OWNER/REPO/issues -f title="New issue" -f body="Description"

# Make DELETE request
gh api -X DELETE /repos/OWNER/REPO/issues/123

# Use jq for JSON processing
gh api /repos/OWNER/REPO | jq '.name'
gh api /repos/OWNER/REPO --jq '.name'
```

### Artifacts Management

```bash
# List artifacts
gh api repos/OWNER/REPO/actions/artifacts
gh api repos/OWNER/REPO/actions/artifacts --jq '.artifacts'

# Get specific artifact
gh api repos/OWNER/REPO/actions/artifacts/ARTIFACT-ID

# Delete artifact
gh api repos/OWNER/REPO/actions/artifacts/ARTIFACT-ID -X DELETE

# Delete all artifacts (PowerShell)
gh api repos/OWNER/REPO/actions/artifacts --paginate --jq ".artifacts[].id" | ForEach-Object {
    gh api repos/OWNER/REPO/actions/artifacts/$_ -X DELETE
}

# Delete all artifacts (Bash)
gh api repos/OWNER/REPO/actions/artifacts --paginate --jq '.artifacts[].id' | xargs -I {} gh api repos/OWNER/REPO/actions/artifacts/{} -X DELETE
```

### Workflow Runs

```bash
# List workflow runs
gh api repos/OWNER/REPO/actions/runs

# Get specific run
gh api repos/OWNER/REPO/actions/runs/RUN-ID

# Delete workflow run
gh api repos/OWNER/REPO/actions/runs/RUN-ID -X DELETE

# Rerun workflow
gh api repos/OWNER/REPO/actions/runs/RUN-ID/rerun -X POST

# Cancel workflow run
gh api repos/OWNER/REPO/actions/runs/RUN-ID/cancel -X POST
```

### Repository Information

```bash
# Get repository details
gh api /repos/OWNER/REPO

# Get repository topics
gh api /repos/OWNER/REPO/topics

# Get repository languages
gh api /repos/OWNER/REPO/languages

# Get repository contributors
gh api /repos/OWNER/REPO/contributors

# Get repository statistics
gh api /repos/OWNER/REPO/stats/contributors
gh api /repos/OWNER/REPO/stats/commit_activity
```

---

## 📚 Additional Details

### gh auth - Authentication Management

The `gh auth` command manages your GitHub authentication.

**Example: Check current authentication status**
```bash
gh auth status
```

**Output:**
```
github.com
  ✓ Logged in to github.com account username (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: gho_************************************
  - Token scopes: 'gist', 'read:org', 'repo', 'workflow'
```

**Example: Login with specific scopes**
```bash
gh auth login --scopes "repo,read:org,workflow,delete_repo"
```

This ensures you have the necessary permissions for operations like:
- `repo` - Full repository access
- `read:org` - Read organization data
- `workflow` - Manage GitHub Actions
- `delete_repo` - Delete repositories

**Example: Refresh token**
```bash
# Useful when you need additional scopes
gh auth refresh --scopes "repo,workflow,admin:org"
```

---

### gh repo - Repository Operations

The `gh repo` command handles all repository-related operations.

**Example: List repositories with JSON output**
```bash
gh repo list username --limit 100 --json name,url,description,isPrivate,updatedAt
```

**Example: Create a new repository from current directory**
```bash
# Initialize git, create GitHub repo, and push
git init
git add .
git commit -m "Initial commit"
gh repo create my-new-repo --source=. --public --remote=origin --push
```

**Example: Clone and navigate**
```bash
gh repo clone owner/repo
cd repo
```

**Example: View repository in browser**
```bash
gh repo view --web
```

**Example: Fork and clone**
```bash
gh repo fork owner/repo --clone
```

This forks the repository to your account and clones it locally.

---

### gh pr - Pull Request Management

The `gh pr` command streamlines pull request workflows.

**Example: Create PR interactively**
```bash
gh pr create
```

This launches an interactive prompt for:
- Title
- Body/Description
- Reviewers
- Assignees
- Labels
- Projects

**Example: Create PR with all details**
```bash
gh pr create \
  --title "Add new feature" \
  --body "This PR adds feature X which does Y" \
  --base main \
  --head feature-branch \
  --reviewer username1,username2 \
  --assignee @me \
  --label enhancement,priority-high
```

**Example: Check out PR for local testing**
```bash
gh pr checkout 123
```

This checks out the PR branch locally for testing.

**Example: View PR diff**
```bash
gh pr diff 123
```

**Example: Add comment to PR**
```bash
gh pr comment 123 --body "This looks great! 👍"
```

**Example: Merge PR with squash**
```bash
gh pr merge 123 --squash --delete-branch
```

---

### gh run - GitHub Actions Workflow Management

The `gh run` command manages workflow runs.

**Example: Watch workflow in real-time**
```bash
gh run watch
```

This displays live updates of the current workflow run.

**Example: View logs for failed run**
```bash
gh run view 123456789 --log-failed
```

**Example: Download all artifacts**
```bash
gh run download 123456789
```

**Example: Download specific artifact**
```bash
gh run download 123456789 --name build-artifacts
```

**Example: List recent failed runs**
```bash
gh run list --status failure --limit 10
```

**Example: Rerun failed jobs only**
```bash
gh run rerun 123456789 --failed
```

**Example: Delete old workflow runs (PowerShell)**
```powershell
# Delete runs older than 30 days
gh api repos/owner/repo/actions/runs --paginate --jq '.workflow_runs[] | select(.created_at < "2024-01-01") | .id' | ForEach-Object {
    gh api repos/owner/repo/actions/runs/$_ -X DELETE
}
```

---

### gh api - Direct API Access

The `gh api` command provides direct access to GitHub's REST API.

**Example: Get repository details with jq filtering**
```bash
gh api /repos/owner/repo --jq '{name: .name, stars: .stargazers_count, forks: .forks_count}'
```

**Example: Paginate through all results**
```bash
gh api /repos/owner/repo/issues --paginate
```

**Example: Create issue via API**
```bash
gh api -X POST /repos/owner/repo/issues \
  -f title="Bug: App crashes on startup" \
  -f body="Detailed description here" \
  -f labels='["bug","priority-high"]' \
  -f assignees='["username"]'
```

**Example: Update repository settings**
```bash
gh api -X PATCH /repos/owner/repo \
  -f description="New description" \
  -f has_issues=true \
  -f has_wiki=false
```

**Example: Get workflow run logs**
```bash
gh api /repos/owner/repo/actions/runs/123456789/logs
```

**Example: Complex query with PowerShell processing**
```powershell
# Get all artifacts and calculate total size
$artifacts = gh api repos/owner/repo/actions/artifacts --paginate | ConvertFrom-Json
$totalSize = ($artifacts.artifacts | Measure-Object -Property size_in_bytes -Sum).Sum
Write-Host "Total artifact storage: $([math]::Round($totalSize / 1MB, 2)) MB"
```

---

### gh release - Release Management

The `gh release` command handles software releases.

**Example: Create release with auto-generated notes**
```bash
gh release create v1.0.0 --generate-notes
```

**Example: Create release with specific notes**
```bash
gh release create v2.0.0 \
  --title "Version 2.0.0 - Major Update" \
  --notes "## What's New
- Feature A
- Feature B

## Bug Fixes
- Fixed issue #123
- Fixed issue #456"
```

**Example: Create pre-release**
```bash
gh release create v2.0.0-beta.1 --prerelease
```

**Example: Upload multiple files**
```bash
gh release create v1.0.0 \
  ./dist/app-windows.zip \
  ./dist/app-linux.tar.gz \
  ./dist/app-macos.dmg \
--notes "Cross-platform release"
```

**Example: Download latest release assets**
```bash
gh release download --pattern "*.zip"
```

**Example: View release in browser**
```bash
gh release view v1.0.0 --web
```

---

## 🔗 References

### Official Documentation

- **GitHub CLI Manual**: https://cli.github.com/manual/
- **GitHub CLI Documentation**: https://docs.github.com/en/github-cli
- **Git Documentation**: https://git-scm.com/doc
- **GitHub REST API**: https://docs.github.com/en/rest

### GitHub CLI Resources

- **GitHub CLI Repository**: https://github.com/cli/cli
- **GitHub CLI Releases**: https://github.com/cli/cli/releases
- **Installation Guide**: https://github.com/cli/cli#installation
- **GitHub CLI Extensions**: https://github.com/topics/gh-extension

### API Documentation

- **GitHub REST API Reference**: https://docs.github.com/en/rest/reference
- **Authentication**: https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api
- **Actions API**: https://docs.github.com/en/rest/actions
- **Artifacts API**: https://docs.github.com/en/rest/actions/artifacts
- **Workflow Runs API**: https://docs.github.com/en/rest/actions/workflow-runs
- **Rate Limiting**: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting

### Community Resources

- **GitHub Community Forum**: https://github.community/
- **GitHub CLI Discussions**: https://github.com/cli/cli/discussions
- **GitHub Skills**: https://skills.github.com/
- **GitHub Learning Lab**: https://lab.github.com/
- **Awesome GitHub CLI**: https://github.com/villelahdenvuo/awesome-gh-cli

---

**💡 Pro Tips:**

1. **Use aliases** - Create shortcuts for commonly used commands:
   ```bash
   gh alias set prc 'pr create'
   gh alias set co 'pr checkout'
   ```

2. **Output formats** - Use `--json` and `--jq` for scripting:
   ```bash
   gh repo list --json name,url --jq '.[].name'
   ```

3. **Pagination** - Use `--paginate` for complete results:
   ```bash
 gh api /repos/owner/repo/issues --paginate
   ```

4. **Combine tools** - Mix `gh`, `git`, and API calls in scripts for powerful automation

5. **Check help** - Use `gh <command> --help` for detailed information about any command

---

*Last updated: 2025-01-18*
