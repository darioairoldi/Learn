# Quick Start Guide - Fixing Artifact Storage Quota Issue

## What Was Done

### 1. Workflow File Fixed ✅
**File**: `.github/workflows/quarto-publish.win64.yml`

**Changes Made:**
- Removed unnecessary `upload-artifact@v4` step that was consuming quota
- Combined build and deploy jobs into one
- Now uses `upload-pages-artifact@v3` directly (separate quota for GitHub Pages)

**Result**: Future workflow runs won't consume artifact storage quota!

---

## What You Need To Do

### Step 1: Run the Cleanup Script

Open PowerShell in this directory and run:

```powershell
cd "E:\dev.darioa.live\darioairoldi\Learn\20251018 ISSUE Github action fails with Artifact storage quota has been hit"
.\cleanup-artifacts.ps1
```

This will:
- Delete all existing artifacts from your repository
- Remove old workflow runs (keeping the last 5)
- Show you the current storage status

### Step 2: Commit and Push the Fixed Workflow

```powershell
cd E:\dev.darioa.live\darioairoldi\Learn

# Check what changed
git status

# Add the modified workflow file
git add .github/workflows/quarto-publish.win64.yml

# Commit the fix
git commit -m "Fix: Eliminate artifact storage quota issue in GitHub Actions workflow"

# Push to GitHub
git push origin main
```

### Step 3: Test the Workflow

Go to your GitHub repository and manually trigger the workflow:
1. Navigate to: https://github.com/darioairoldi/Learn/actions
2. Click on "Quarto Site Render and Deploy to GitHub Pages"
3. Click "Run workflow" button
4. Select the `main` branch
5. Click "Run workflow"

### Step 4: Verify Success

After the workflow runs:
- ✅ Check that it completes successfully
- ✅ Verify your site is published at your GitHub Pages URL
- ✅ Confirm no new artifacts are created (check Actions → Artifacts)

---

## If Problems Persist

### Check Storage Status
```powershell
# Check remaining artifacts
gh api repos/darioairoldi/Learn/actions/artifacts

# Check workflow runs
gh run list --repo darioairoldi/Learn --limit 10
```

### Check Billing Dashboard
Visit: https://github.com/settings/billing/summary

Look for "Actions storage" usage. It should decrease after cleanup (may take 6-12 hours to update).

### Contact Support
If the issue continues after cleanup, it may be a GitHub platform issue:
- Support: https://support.github.com/
- Status: https://www.githubstatus.com/

---

## Summary of the Fix

**Before:**
```
Build Job → Upload Artifact (quota counted!) → Deploy Job → Download Artifact → Deploy
```

**After:**
```
Build-and-Deploy Job → Upload to Pages → Deploy (no quota impact!)
```

**Benefits:**
- ✅ No more artifact storage quota issues
- ✅ Faster workflow (single job)
- ✅ Follows GitHub best practices
- ✅ Simpler to maintain

---

## Files Modified/Created

1. **Modified**: `.github/workflows/quarto-publish.win64.yml`
   - Combined jobs, removed artifact steps
   
2. **Created**: `cleanup-artifacts.ps1`
   - Script to clean up existing artifacts and workflow runs
   
3. **Updated**: `README.md`
   - Complete documentation of the issue and solution
   
4. **Created**: `QUICKSTART.md` (this file)
   - Step-by-step guide to implement the solution

---

## Need Help?

Refer to the main README.md in this folder for:
- Detailed analysis of the issue
- Manual cleanup commands
- Advanced troubleshooting steps
- Additional references and documentation
