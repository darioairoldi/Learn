---
title: "Markdown deployment fails after resetting Azure Blob Storage"
author: "Dario Airoldi"
date: "2026-08-13"
categories: [issue, github-actions, azure-storage, ci-cd, powershell]
description: "The Learning Hub content workflow emptied its Azure Blob container and then failed because the staging path wasn't passed between GitHub Actions steps."
publish: false
---

# Markdown deployment fails after resetting Azure Blob Storage

**Date reported:** August 13, 2026  
**Reporter:** Dario Airoldi  
**Status:** Code resolved; end-to-end workflow verification pending  
**Severity:** High  
**Component:** `.github/workflows/deploy-learninghub.yml`  
**Framework:** GitHub Actions on a self-hosted Windows runner, PowerShell 7 (`pwsh`), and Azure CLI Blob Storage commands

---

## 📑 Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)
- [📚 References](#-references)

---

## 📝 Description

The **Deploy Learning Hub content to storage** workflow failed during its Azure Blob Storage synchronization step. The reset phase completed successfully and reduced the `learn` container from 746 active blobs to zero. The following `az storage blob upload-batch` command then failed because its `--source` option received no value.

The decisive error was:

```text
Container reset pass 9 left 0 active blobs
ERROR: argument --source/-s: expected one argument
Blob upload to 'digitoolstestmcstitn01/learn' failed (see errors above).
Error: Process completed with exit code 1.
```

The workflow therefore completed the destructive half of its mirror operation but couldn't complete the restorative half. The log proves that the container reached zero active blobs. It doesn't include a site probe, so the exact user-visible outage duration isn't established by this conversation.

### Expected behavior

The workflow should stage Markdown and image files, verify that the staging directory is available to the synchronization step, reset the destination container, upload the staged files, and invalidate the Learn.Web cache.

### Actual behavior

The staging step populated a local directory, but the directory path remained in a step-local PowerShell variable. The synchronization step read an unset environment variable, deleted the existing blobs, and passed an empty argument to Azure CLI.

### Impact

- The content deployment failed with exit code 1.
- The `digitoolstestmcstitn01/learn` container was left with zero active blobs at the point recorded in the log.
- Learn.Web's Blob content source could no longer enumerate the expected Markdown content until a successful upload restored it.
- Cache invalidation didn't run because the synchronization step failed first.
- Re-running the unchanged workflow would reproduce the failure after another reset.

The severity is **High** because the bug occurs after destructive cleanup and can remove all currently deployed content. It isn't classified as Critical because the affected environment uses test-oriented resource names, and the conversation doesn't establish irreversible data loss or a production outage.

---

## 🔍 Context information

### Deployment environment

| Property | Value |
|---|---|
| Repository | `darioairoldi/Learn` |
| Workflow | `.github/workflows/deploy-learninghub.yml` |
| Workflow run | `31680419805` |
| Job | `94385001773` |
| Runner | Self-hosted Windows runner |
| Shell | PowerShell 7 through `pwsh` |
| Storage account | `digitoolstestmcstitn01` |
| Container | `learn` |
| Authentication | GitHub OIDC through `azure/login@v2`; Azure CLI uses `--auth-mode login` |
| Upload command | `az storage blob upload-batch` |
| Application content model | Learn.Web renders Markdown from Blob Storage on demand |

### Relevant variables

| Variable | Scope before the fix | Value at upload time | Role |
|---|---|---|---|
| `$stage` | Local to **Stage Markdown content** | Not available in the next step | Absolute staging-directory path |
| `$env:RUNNER_TEMP` | Job environment | Available | Parent location used to create the staging directory |
| `$env:CONTENT_STAGE` | Never assigned | Empty or null | Value consumed by `upload-batch --source` |
| `$env:STORAGE_ACCOUNT` | Workflow environment | `digitoolstestmcstitn01` | Destination storage account |
| `$env:STORAGE_CONTAINER` | Workflow environment | `learn` | Destination container |
| `$env:GITHUB_ENV` | GitHub Actions environment file | Available | Supported mechanism for passing values to later steps |

### Exception details

Azure CLI rejected the command during argument parsing:

```text
ERROR: argument --source/-s: expected one argument
```

PowerShell then observed a nonzero native-process exit code and raised the workflow's explicit exception:

```powershell
if ($LASTEXITCODE -ne 0) {
	throw "Blob upload to '$env:STORAGE_ACCOUNT/$env:STORAGE_CONTAINER' failed (see errors above)."
}
```

No application call stack applies. The failure path consists of GitHub Actions invoking PowerShell, PowerShell invoking Azure CLI, Azure CLI rejecting the missing option value, and PowerShell converting `$LASTEXITCODE` into a terminating exception.

---

## 🔬 Analysis

### Root cause

GitHub Actions executes each `run` step in a separate process. A PowerShell variable created in one step doesn't automatically exist in a later step.

The staging step created the source path only as a local variable:

```powershell
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
```

The synchronization step expected a job environment variable instead:

```powershell
az storage blob upload-batch `
	--account-name $env:STORAGE_ACCOUNT --destination $env:STORAGE_CONTAINER `
	--source $env:CONTENT_STAGE --overwrite true --auth-mode login --only-show-errors
```

No statement wrote `CONTENT_STAGE` to `$GITHUB_ENV`, so `$env:CONTENT_STAGE` expanded to no token. Azure CLI consequently parsed `--overwrite` as the next option and reported that `--source` lacked its required argument.

### Why the reset still succeeded

The reset phase depended only on workflow-level variables (`STORAGE_ACCOUNT` and `STORAGE_CONTAINER`). Both were defined in the workflow's top-level `env` block, so they survived across steps. The missing staging path wasn't accessed until after the deletion loop had reached zero blobs.

### Safety gap

The missing environment handoff caused the immediate failure, but command ordering amplified its impact. Before the fix, the synchronization step didn't verify the upload source before deleting destination data.

The workflow's logical sequence was:

1. Create or reach the destination container.
2. Delete all destination blobs and verify that none remain.
3. Read `CONTENT_STAGE` for the first time while constructing the upload command.
4. Fail because `CONTENT_STAGE` is empty.

A missing, mistyped, deleted, or inaccessible staging directory could therefore trigger the same destructive failure class even after correcting the original variable handoff.

### Contributing factors

| Factor | Contribution |
|---|---|
| Step isolation wasn't accounted for | The implementation treated `$stage` as if it persisted across GitHub Actions steps. |
| Producer and consumer used different variable forms | The producer assigned `$stage`; the consumer expected `$env:CONTENT_STAGE`. |
| No pre-destructive source validation | The workflow reset storage before checking whether upload input existed. |
| Error handling occurred after Azure CLI invocation | The explicit exception improved the final message but couldn't prevent the empty container. |
| Staging validation checked only file count | It proved content existed inside the staging step, not that the next step could locate it. |

### Affected workflows

The confirmed defect is limited to `.github/workflows/deploy-learninghub.yml`. The separate `.github/workflows/deploy-learnweb.yml` application deployment isn't part of this content-upload path.

---

## 🔄 Reproduction steps

1. Run the workflow without exporting `CONTENT_STAGE` through `$GITHUB_ENV`.
2. Let **Stage Markdown content** create `$stage` and finish successfully.
3. Start **Synchronize Markdown content to blob storage** in its separate PowerShell process.
4. Confirm that `$env:CONTENT_STAGE` is empty.
5. Let the reset loop delete all blobs from the destination container.
6. Observe the generated command effectively omit the `--source` value.
7. Observe Azure CLI return `argument --source/-s: expected one argument` and the workflow exit with code 1.

The behavior can be demonstrated without Azure by comparing scopes:

```powershell
# Step A
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"

# Step B runs in a new process
Write-Host "CONTENT_STAGE='$env:CONTENT_STAGE'" # Empty before the fix
```

**Affected code locations:**

- `.github/workflows/deploy-learninghub.yml`, **Stage Markdown content**: creates and validates `$stage`.
- `.github/workflows/deploy-learninghub.yml`, **Synchronize Markdown content to blob storage**: resets the container and consumes `$env:CONTENT_STAGE`.

---

## ✅ Solution implemented

### Persist the staging path across steps (✅ done)

The staging step now writes the absolute directory path to GitHub Actions' environment file:

```powershell
Add-Content -Path $env:GITHUB_ENV -Value "CONTENT_STAGE=$stage" -Encoding utf8
```

GitHub Actions imports this entry into the environment of subsequent steps, so the existing upload command receives a concrete source directory.

### Validate the source before destructive cleanup (✅ done)

The synchronization step now fails before contacting or resetting the container when the variable is empty or the directory doesn't exist:

```powershell
if ([string]::IsNullOrWhiteSpace($env:CONTENT_STAGE) -or
		-not (Test-Path -LiteralPath $env:CONTENT_STAGE -PathType Container)) {
	throw "Staged content directory '$env:CONTENT_STAGE' is unavailable; refusing to reset the container."
}
```

This guard addresses both the observed variable-handoff defect and the broader safety gap. Any future failure to produce or retain the staging directory stops the workflow before blob deletion.

### Resulting synchronization sequence

1. Stage content and verify that at least one Markdown file exists. (✅ done)
2. Export the absolute staging path through `$GITHUB_ENV`. (✅ done)
3. In the next step, verify that the imported path is nonempty and points to a directory. (✅ done)
4. Create or reach the destination container. (✅ done)
5. Reset the destination and verify that no active blobs remain. (✅ done)
6. Upload from the validated source and invalidate the application cache. (🟡 pending end-to-end workflow verification)

---

## 📚 Additional information

### Validation performed

| Check | Result | What it proves |
|---|---|---|
| VS Code diagnostics for `deploy-learninghub.yml` | No errors | The edited workflow has no reported YAML or expression diagnostics. |
| PowerShell `$GITHUB_ENV` handoff simulation | Passed | `CONTENT_STAGE` resolves to the same absolute directory in a simulated later step. |
| Guard evaluation against the simulated directory | Passed | The pre-reset assertion accepts a valid directory. |
| `git diff --check` | Passed | The workflow change has no whitespace errors. |
| Live GitHub Actions workflow run | Pending | Azure authentication, reset, upload, and cache invalidation still need end-to-end confirmation. |

The successful local handoff test reported:

```text
Validated CONTENT_STAGE handoff: C:\Users\darioa\AppData\Local\Temp\learn-content-stage-handoff-test
```

### Testing recommendations

- Manually dispatch **Deploy Learning Hub content to storage** after committing the workflow fix. (🟡 pending)
- Confirm the log prints a nonempty path in `Synchronized <path> to digitoolstestmcstitn01/learn`. (🟡 pending)
- Confirm the container contains the expected Markdown and image blobs after upload. (🟡 pending)
- Open the deployed Learning Hub and verify that navigation and representative articles load. (🟡 pending)
- Confirm the cache-invalidation step reports `App cache flushed`, or document a nonfatal invalidation warning. (🟡 pending)

### Migration considerations

No data-model, infrastructure, or application migration is required. The fix changes only how an existing temporary path is passed between workflow steps and adds a precondition before destructive synchronization.

### Performance impact

The additional work is one environment-file append and one local directory existence check. Its runtime cost is negligible compared with deleting and uploading hundreds of blobs.

### Security impact

The fix doesn't change authentication or authorization. The workflow continues to use GitHub OIDC and Azure role-based access through `--auth-mode login`; no credentials are added to the workflow or logs.

---

## ✔️ Resolution status

**Current status:** The root cause and safety gap are fixed in the working tree. A successful GitHub Actions run is still required before the incident can be marked fully resolved.

### Verification checklist

- Root cause identified as a missing cross-step environment-variable handoff. (✅ done)
- `CONTENT_STAGE` exported through `$GITHUB_ENV`. (✅ done)
- Source path checked before container reset. (✅ done)
- Workflow diagnostics completed without errors. (✅ done)
- Environment handoff and directory guard simulated locally. (✅ done)
- Workflow fix committed and pushed to `main`. (🟡 pending)
- Content deployment rerun successfully in GitHub Actions. (🟡 pending)
- Blob count and deployed Learning Hub behavior verified after the rerun. (🟡 pending)

### Follow-up actions

- Consider staging into a uniquely named directory per run to reduce coupling to residual runner state. (📌 next steps)
- Consider uploading to a temporary container or prefix and switching only after upload validation if stronger atomicity becomes necessary. (📌 next steps)
- Add a lightweight workflow test that verifies every cross-step variable consumer has a corresponding `$GITHUB_ENV` or step-output producer. (📌 next steps)

---

## 🎓 Lessons learned

### What went wrong

- Shell variables are process-local; GitHub Actions steps require explicit state transfer through environment files, outputs, artifacts, or files at known paths.
- The workflow validated staged content in the producing process but didn't validate the source at the destructive consumer boundary.
- The reset-first mirror strategy made a simple argument bug operationally significant.

### What went right

- The reset loop logged its progress and final zero count, making the operation sequence unambiguous.
- Azure CLI's argument parser produced a precise error that pointed directly to the missing source value.
- The workflow already converted native command failures into terminating PowerShell errors, so the job didn't falsely report success.
- The repair remained small: one explicit handoff and one fail-fast guard addressed the root cause and its main risk.

### Improvements for future workflows

- Validate every destructive operation's replacement input immediately before deletion. (📌 next steps)
- Treat each GitHub Actions step as an isolated process during design and review. (📌 next steps)
- Pair producer and consumer variable names explicitly, preferably through named step outputs when values are central to later steps. (📌 next steps)
- Make failure messages state both the missing precondition and the destructive action that was refused. (📌 next steps)

---

## 📎 Appendix

### Failure timeline

| Event | Evidence | Interpretation |
|---|---|---|
| Reset starts | Pass 1 leaves 746 active blobs | The destination initially contains deployed content. |
| Reset progresses | Counts fall through 349, 50, 15, 8, 4, 2, and 1 | Batch deletion is functioning. |
| Reset completes | Pass 9 leaves 0 active blobs | The destructive phase completes successfully. |
| Upload parsing fails | `--source/-s: expected one argument` | The upload source expands to no command-line value. |
| Workflow fails | Explicit `Blob upload ... failed` exception and exit code 1 | Error handling reports the failed restorative phase. |

### Before and after

**Before:**

```powershell
# Stage step
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"

# Synchronization step
az storage blob upload-batch `
	--source $env:CONTENT_STAGE `
	--destination $env:STORAGE_CONTAINER
```

**After:**

```powershell
# Stage step
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
Add-Content -Path $env:GITHUB_ENV -Value "CONTENT_STAGE=$stage" -Encoding utf8

# Synchronization step, before container access or deletion
if ([string]::IsNullOrWhiteSpace($env:CONTENT_STAGE) -or
		-not (Test-Path -LiteralPath $env:CONTENT_STAGE -PathType Container)) {
	throw "Staged content directory '$env:CONTENT_STAGE' is unavailable; refusing to reset the container."
}
```

### Files changed

- `.github/workflows/deploy-learninghub.yml`: exports `CONTENT_STAGE` and validates it before resetting Blob Storage.
- `src/docs/90. Issues/202608/20260813.01-markdowndeploy-fix/overview.md`: records this incident analysis.

---

## 📚 References

- [Failed GitHub Actions job](https://github.com/darioairoldi/Learn/actions/runs/31680419805/job/94385001773#step:6:44) 📘 [Official]
	The job log records the successful container reset, the missing `--source` argument, and the resulting PowerShell exception.
- [GitHub Actions workflow commands: environment files](https://docs.github.com/en/actions/reference/workflow-commands-for-github-actions#environment-files) 📘 [Official]
	GitHub documents `$GITHUB_ENV` as the supported mechanism for making environment variables available to subsequent steps in a job.
- [Azure CLI `az storage blob upload-batch` reference](https://learn.microsoft.com/cli/azure/storage/blob#az-storage-blob-upload-batch) 📘 [Official]
	The command reference defines `--source` as the local directory containing files to upload.
- `.github/workflows/deploy-learninghub.yml`
	This workflow stages Markdown content, resets the `learn` container, uploads the staged files, and invalidates the Learn.Web cache.

<!--
validations:
	conversation_analysis: {status: "passed", last_run: "2026-08-13"}
	workflow_diagnostics: {status: "passed", last_run: "2026-08-13"}
	end_to_end_deployment: {status: "not_run", last_run: null}

article_metadata:
	filename: "overview.md"
	created: "2026-08-13"
	last_updated: "2026-08-13"
	version: "1.0"
	status: "code-resolved-verification-pending"
	issue_type: "ci-cd-deployment-failure"
-->
