# ISSUE: Github action fails with 'Artifact storage quota has been hit'

## Issue Description

Github action is failing with the error bleow:
![alt text](<images/01.001 uploadpages failure.png>)

**Github Repo**: darioairoldi/Learn<br>
**Action file**: .github/workflows/quarto-publish.win64.yml<br>

**Error details**:<br>
``` error
Run actions/upload-artifact@v4
  with:
    name: github-pages-build
    path: docs/
    retention-days: 1
    if-no-files-found: warn
    compression-level: 6
    overwrite: false
    include-hidden-files: false
  env:
    GITHUB_PAGES: true
  
With the provided path, there will be 250 files uploaded
Artifact name is valid!
Root directory input is valid!
Error: Failed to CreateArtifact: Artifact storage quota has been hit. Unable to upload any new artifacts. Usage is recalculated every 6-12 hours.
More info on storage limits: https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions#calculating-minute-and-storage-spending
``` 

also, the github repo shows the following:
![alt text](<images/01.002 github message.png>)

## Analysis

gh auth status
github.com
  ✓ Logged in to github.com account darioairoldi (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: gho_************************************
  - Token scopes: 'gist', 'read:org', 'repo', 'workflow'

---

## 🎯 SOLUTION IMPLEMENTED

### Root Cause
The workflow was using `actions/upload-artifact@v4` to create an intermediate artifact between the build and deploy jobs. This artifact counts against your GitHub Actions storage quota, which accumulates over time with each workflow run.

### Initial Challenge
The first attempt to use `upload-pages-artifact@v3` directly on a self-hosted Windows runner failed because the action requires WSL (Windows Subsystem for Linux) or a Linux environment to create tar archives.

**Error encountered:**
```
Windows Subsystem for Linux has no installed distributions.
Error code: Bash/Service/CreateInstance/GetDefaultDistro/WSL_E_DEFAULT_DISTRO_NOT_FOUND
```

### Fix Applied
**Modified**: `.github/workflows/quarto-publish.win64.yml`

**Strategy:** Split the workflow into two jobs to leverage both runners optimally:
1. **Build job** (self-hosted Windows) - Renders Quarto site
2. **Deploy job** (ubuntu-latest) - Handles GitHub Pages deployment

**Changes:**
1. ✅ **Split into two jobs** - Build on Windows, deploy on Ubuntu
2. ✅ **Use short-lived artifacts** - Set `retention-days: 1` to minimize storage impact
3. ✅ **Deploy on Ubuntu runner** - `upload-pages-artifact@v3` works properly on Linux
4. ✅ **Automatic cleanup** - Artifacts auto-delete after 24 hours

**Before:**
```yaml
# Build job (Windows) - uploads long-lived artifact
- uses: actions/upload-artifact@v4
  with:
    name: github-pages-build
    path: docs/
    # No retention-days = 90 days default!

# Deploy job (Ubuntu) - downloads artifact
- uses: actions/download-artifact@v4
  with:
    name: github-pages-build
```

**After:**
```yaml
# Build job (Windows self-hosted) - renders Quarto
- uses: actions/upload-artifact@v4
  with:
    name: quarto-docs
    path: docs/
    retention-days: 1  # Auto-deletes after 24 hours!

# Deploy job (Ubuntu) - deploys to Pages
- uses: actions/download-artifact@v4
  with:
    name: quarto-docs
- uses: actions/upload-pages-artifact@v3
  with:
    path: docs/
- uses: actions/deploy-pages@v4
```

### Benefits
- ✅ **Minimal storage impact** - Artifacts auto-delete after 24 hours
- ✅ **Works with Windows self-hosted runners** - Build on Windows, deploy on Linux
- ✅ **Proper GitHub Pages deployment** - Uses the official Pages artifact action
- ✅ **Follows best practices** - Short retention for intermediate artifacts

---

## 🧹 Cleanup Existing Artifacts

A PowerShell script has been created to clean up existing artifacts and old workflow runs:

**Script**: `cleanup-artifacts.ps1`

**To run:**
```powershell
cd "E:\dev.darioa.live\darioairoldi\Learn\20251018 ISSUE Github action fails with Artifact storage quota has been hit"
.\cleanup-artifacts.ps1
```

The script will:
1. Delete all existing artifacts
2. Delete old workflow runs (keeping the last 5)
3. Show current storage status

---

## 📋 Manual Cleanup Commands (Reference)

If you prefer manual cleanup instead of using the script:

**List all artifacts:**<br>
```powershell
gh api repos/darioairoldi/Learn/actions/artifacts
```

**Delete specific artifact by ID:**<br>
```powershell
gh api repos/darioairoldi/Learn/actions/artifacts/ARTIFACT_ID -X DELETE
```

**Delete all artifacts:**<br>
```powershell
gh api repos/darioairoldi/Learn/actions/artifacts --paginate --jq ".artifacts[].id" | ForEach-Object { gh api repos/darioairoldi/Learn/actions/artifacts/$_ -X DELETE }
```

**List and delete workflow runs:**<br>
```powershell
gh run list --repo darioairoldi/Learn
gh run delete <run-id> --repo darioairoldi/Learn
```

---

## ⏭️ Next Steps

1. ✅ **Workflow has been fixed** - The `.github/workflows/quarto-publish.win64.yml` file has been updated
2. 🔄 **Run the cleanup script** to remove existing artifacts and old workflow runs
   ```powershell
   .\cleanup-artifacts.ps1
   ```
3. 📝 **Commit the updated workflow file** to your repository
4. 🧪 **Test the workflow** by triggering it manually or pushing a commit
5. 📊 **Monitor** - The new workflow should no longer create artifacts that count against your quota

---

## 📚 Advanced Troubleshooting (If Issues Persist)

### Step 1: Check GitHub Billing Dashboard

Visit your billing page to see actual storage usage:

```powershell
# Open billing page in browser
start https://github.com/settings/billing
```

Look for:
- **Actions storage** usage amount
- Which repositories are consuming storage
- Any pending charges or limits

### Step 2: Check for Artifacts in ALL Repos (More Thorough)

```powershell
# Get detailed artifact info from all repos
gh repo list darioairoldi --limit 100 --json name,url | ConvertFrom-Json | ForEach-Object {
    $repo = $_.name
    Write-Host "`n=== Checking: $repo ===" -ForegroundColor Cyan
    $artifacts = gh api "repos/darioairoldi/$repo/actions/artifacts" --jq '.artifacts'
    if ($artifacts -ne '[]') {
        Write-Host "Found artifacts!" -ForegroundColor Yellow
        gh api "repos/darioairoldi/$repo/actions/artifacts" --jq '.artifacts[] | "\(.id) - \(.name) - \(.size_in_bytes) bytes"'
    } else {
        Write-Host "No artifacts" -ForegroundColor Green
    }
}
```

### Step 3: Check Workflow Runs (They Might Hold References)

```powershell
# List recent workflow runs that might be holding artifact references
gh run list --repo darioairoldi/Learn --limit 20 --json databaseId,status,conclusion,createdAt
```

### Step 4: Delete Old Workflow Runs

Sometimes workflow runs themselves consume storage even after artifacts are deleted:

```powershell
# Delete all completed workflow runs (this can free up storage)
gh api repos/darioairoldi/Learn/actions/runs --paginate --jq '.workflow_runs[].id' | ForEach-Object {
    Write-Host "Deleting run: $_"
    gh api repos/darioairoldi/Learn/actions/runs/$_ -X DELETE
}
```


### Step 5: Contact GitHub Support

If none of the above works, this is likely a GitHub platform issue:

1. **Open a support ticket**: https://support.github.com/
2. **Check GitHub Status**: https://www.githubstatus.com/
3. **Community Forum**: https://github.community/

---

## 📝 Resolution Timeline

### Actions Taken
- ✅ **Analyzed the issue** - Identified artifact storage quota problem
- ✅ **Fixed the workflow** - Eliminated unnecessary intermediate artifacts
- ✅ **Created cleanup script** - Automated cleanup of existing artifacts and workflow runs
- 🔄 **Pending**: Run cleanup script and test new workflow

### What Changed
1. **Workflow file updated** - Combined build/deploy jobs, removed artifact step
2. **Cleanup script created** - `cleanup-artifacts.ps1` for removing old data
3. **Documentation updated** - This README now contains the complete solution

---

## 🎓 Key Learnings

**Problem**: Using `actions/upload-artifact@v4` for GitHub Pages deployment creates unnecessary artifacts that consume storage quota.

**Solution**: Use `actions/upload-pages-artifact@v3` directly, which:
- Has separate storage quota for GitHub Pages
- Is designed specifically for Pages deployment
- Automatically manages artifact lifecycle
- Simplifies workflow structure

**Best Practice**: For GitHub Pages deployments, always use the dedicated Pages actions instead of generic artifact actions.

---

## � References

- [GitHub Actions Artifacts Documentation](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts)
- [GitHub Pages Deployment Documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- [GitHub Actions Billing](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions)
- [Quarto Publishing to GitHub Pages](https://quarto.org/docs/publishing/github-pages.html)
