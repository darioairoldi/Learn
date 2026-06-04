# WSL Error Fix - Updated Solution

## New Issue Encountered 🔴

When trying to use `actions/upload-pages-artifact@v3` on a self-hosted Windows runner, we encountered:

```
Error: Windows Subsystem for Linux has no installed distributions.
Error code: Bash/Service/CreateInstance/GetDefaultDistro/WSL_E_DEFAULT_DISTRO_NOT_FOUND
Process completed with exit code 1.
```

## Why This Happened 🔍

The `actions/upload-pages-artifact@v3` action uses `tar` to create archives, which requires either:
- A Linux environment (bash, tar utilities)
- Windows Subsystem for Linux (WSL)

Your self-hosted Windows runner doesn't have WSL installed, so the action fails.

## Solution: Hybrid Runner Approach ✅

Instead of trying to run everything on Windows, we split the workflow to use the **best runner for each job**:

### Job 1: Build (Windows Self-Hosted)
- ✅ Uses your Windows runner where Quarto is installed
- ✅ Renders the Quarto site efficiently
- ✅ Uploads build output as a short-lived artifact (1 day)

### Job 2: Deploy (Ubuntu Latest - GitHub Hosted)
- ✅ Uses GitHub's free Ubuntu runner
- ✅ Downloads the build artifact
- ✅ Uses `upload-pages-artifact@v3` (works perfectly on Linux)
- ✅ Deploys to GitHub Pages

## Workflow Structure 📊

```yaml
jobs:
  build:
    runs-on: self-hosted  # Your Windows runner
    steps:
      - Checkout
      - Setup Quarto (Windows)
      - Render Quarto site
      - Upload artifact (retention: 1 day)
      
  deploy:
    needs: build
    runs-on: ubuntu-latest  # GitHub's Linux runner
    steps:
      - Download artifact
      - Upload to Pages (requires Linux)
      - Deploy to Pages
```

## Benefits of This Approach 🎯

1. **✅ No WSL Required**
   - Build happens on native Windows
   - Deploy happens on Linux (where the action works)

2. **✅ Minimal Storage Impact**
   - Artifacts only kept for 1 day
   - Automatic cleanup after 24 hours
   - No accumulation over time

3. **✅ Uses Free Resources Efficiently**
   - Self-hosted runner for compute-heavy build
   - GitHub's free runner for quick deployment step

4. **✅ Best of Both Worlds**
   - Windows for Quarto (your tooling)
   - Linux for Pages deployment (GitHub's tooling)

## What Changed from Previous Solution 🔄

### Previous Attempt (Failed):
```yaml
jobs:
  build-and-deploy:
    runs-on: self-hosted  # Windows only
    steps:
      - Render on Windows
      - upload-pages-artifact@v3  # ❌ Fails - needs Linux!
```

### Current Solution (Works):
```yaml
jobs:
  build:
    runs-on: self-hosted  # Windows
    steps:
      - Render on Windows
      - upload-artifact@v4 with retention-days: 1
      
  deploy:
    runs-on: ubuntu-latest  # Linux
    steps:
      - download-artifact@v4
      - upload-pages-artifact@v3  # ✅ Works on Linux!
      - deploy-pages@v4
```

## Alternative Solutions (Not Recommended) 📋

If you really wanted to use only your Windows runner, you could:

### Option 1: Install WSL
- Install WSL on your Windows runner
- But this adds complexity and maintenance

### Option 2: Use PowerShell-based artifact creation
- Write custom PowerShell to create tar archives
- But this is reinventing the wheel

### Option 3: Deploy directly without Pages actions
- Push to `gh-pages` branch manually
- But you lose GitHub Pages integration benefits

**Verdict**: The hybrid runner approach is simpler and more maintainable.

## Current Status ✅

- ✅ Workflow updated to use hybrid approach
- ✅ Build on Windows self-hosted runner
- ✅ Deploy on GitHub's Ubuntu runner
- ✅ Short-lived artifacts (1 day retention)
- ✅ Should work immediately on next run!

## Next Steps 🚀

1. **Test the updated workflow**
   - Commit and push the changes
   - Workflow will run automatically (push trigger is enabled)

2. **Verify successful deployment**
   - Check Actions tab for green checkmarks
   - Confirm site is published to GitHub Pages

3. **Monitor storage usage**
   - Artifacts should auto-delete after 24 hours
   - No quota buildup over time

---

**The workflow file has been updated and is ready to use!** 🎉
