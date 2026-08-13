---
title: "Markdown deployment fails after resetting Azure Blob Storage"
author: "Dario Airoldi"
date: "2026-08-13"
categories: [issue, github-actions, azure-storage, ci-cd, powershell]
description: "The Learning Hub content workflow emptied its Azure Blob container and then failed because the staging path wasn't passed between GitHub Actions steps."
publish: false
---

# Markdown deployment fails after resetting Azure Blob Storage

| Field | Value |
|---|---|
| Date reported | August 13, 2026 |
| Reporter | Dario Airoldi |
| Status | Code resolved; end-to-end workflow verification pending |
| Severity | High |
| Component | `.github/workflows/deploy-learninghub.yml` |
| Framework | GitHub Actions on a self-hosted Windows runner, PowerShell 7 (`pwsh`), and Azure CLI Blob Storage commands |

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

The **Deploy Learning Hub content to storage** workflow failed during its Azure Blob Storage synchronization step. The reset phase completed successfully, leaving zero active blobs in the `learn` container. The following `az storage blob upload-batch` command then failed because its `--source` option received no value.

The decisive error was:

```text
Container reset pass 1 left 0 active blobs
ERROR: argument --source/-s: expected one argument
Blob upload to 'digitoolstestmcstitn01/learn' failed (see errors above).
Error: Process completed with exit code 1.
```

The workflow therefore completed the destructive half of its mirror operation but couldn't complete the restorative half. The log proves that the container reached zero active blobs. It doesn't include a site probe, so the exact user-visible outage duration isn't established by this conversation.

### Expected behavior

The workflow should stage Markdown and image files, verify that the staging directory is available to the synchronization step, reset the destination container, upload the staged files, and invalidate the Learn.Web cache.

### Actual behavior

The staging step populated a local directory. At the Azure CLI boundary, the upload command received no usable value for `--source` and failed after the container reset.

### Impact

- The content deployment failed with exit code 1.
- The `digitoolstestmcstitn01/learn` container was left with zero active blobs at the point recorded in the log.
- Learn.Web's Blob content source could no longer enumerate the expected Markdown content until a successful upload restored it.
- Cache invalidation didn't run because the synchronization step failed first.
- Re-running the failed workflow revision could reset the container again before the upload command fails.

The severity is **High** because the bug occurs after destructive cleanup and can remove all currently deployed content. It isn't classified as Critical because the affected environment uses test-oriented resource names, and the conversation doesn't establish irreversible data loss or a production outage.

---

## 🔍 Context information

### Deployment environment

| Property | Value |
|---|---|
| Repository | `darioairoldi/Learn` |
| Workflow | `.github/workflows/deploy-learninghub.yml` |
| Workflow run | `31680419805` |
| Job | `94390095603` |
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
| `$stage` | Local to each PowerShell step | Recomputed from `RUNNER_TEMP` after the fix | Absolute staging-directory path |
| `$env:RUNNER_TEMP` | Job environment | Available | Parent location used to create the staging directory |
| `$env:CONTENT_STAGE` | Written through `$GITHUB_ENV` by the failed revision | The job log doesn't expose its value at native-command invocation | Former value consumed by `upload-batch --source` |
| `$env:STORAGE_ACCOUNT` | Workflow environment | `digitoolstestmcstitn01` | Destination storage account |
| `$env:STORAGE_CONTAINER` | Workflow environment | `learn` | Destination container |
| `$env:GITHUB_ENV` | GitHub Actions environment file | No longer used for this path | Former cross-step handoff mechanism |

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

The observed fault is that Azure CLI received no usable argument after `--source`. The failed workflow version created `$stage` in **Stage Markdown content**, wrote `CONTENT_STAGE=$stage` to `$GITHUB_ENV`, and later consumed `$env:CONTENT_STAGE` in **Synchronize Markdown content to blob storage**.

The job log proves the Azure CLI argument was missing, but it doesn't expose the value expanded by PowerShell or explain why the preceding directory guard did not reject it. It therefore doesn't prove that `$GITHUB_ENV` was absent, malformed, or ignored. The defensible conclusion is that a cross-step environment handoff became unreliable at the native-command boundary.

The repair removes that boundary. Both steps derive the same path from the job-scoped `RUNNER_TEMP` value:

```powershell
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
```

The synchronization step validates that computed directory before the reset, then passes the local `$stage` variable directly to Azure CLI:

```powershell
az storage blob upload-batch `
	--account-name $env:STORAGE_ACCOUNT --destination $env:STORAGE_CONTAINER `
	--source $stage --overwrite true --auth-mode login --only-show-errors
```

### Why the reset still succeeded

The reset phase depended only on workflow-level variables (`STORAGE_ACCOUNT` and `STORAGE_CONTAINER`). Both were defined in the workflow's top-level `env` block, so they survived across steps. The missing staging path wasn't accessed until after the deletion loop had reached zero blobs.

### Remaining safety consideration

The workflow validates the staged directory before deleting destination blobs, and the fix preserves that guard. However, the deployment still deletes the live container before the replacement upload completes. A later network, authorization, Azure CLI, or upload failure can therefore leave the container empty. This is a separate availability risk from the missing `--source` argument.

### Contributing factors

| Factor | Contribution |
|---|---|
| Cross-step state transfer | The source path moved from a local variable to `$GITHUB_ENV`, then back into a PowerShell variable for a native command. |
| Limited job diagnostics | The log didn't print the resolved source path immediately before invoking Azure CLI. |
| Reset-first mirror strategy | The container was empty before the upload command was attempted. |
| Failure handling after deletion | The explicit exception reported the failed upload but couldn't restore the deleted blobs. |

### Affected workflows

The confirmed defect is limited to `.github/workflows/deploy-learninghub.yml`. The separate `.github/workflows/deploy-learnweb.yml` application deployment isn't part of this content-upload path.

---

## 🔄 Reproduction steps

The exact failed handoff cannot be reproduced locally from the available log because the resolved environment value wasn't recorded. Reproduce the observed behavior on the failed revision by running the workflow and observing the following sequence:

1. **Stage Markdown content** completes and reports staged Markdown files. (✅ done)
2. **Synchronize Markdown content to blob storage** resets the `learn` container. (✅ done)
3. The log reports `Container reset pass 1 left 0 active blobs`. (✅ done)
4. Azure CLI reports `argument --source/-s: expected one argument`. (✅ done)
5. PowerShell throws the workflow's `Blob upload ... failed` exception. (✅ done)

The current fix avoids an environment-file handoff by recomputing the path in the consumer step:

```powershell
# Stage and synchronization steps
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
if (-not (Test-Path -LiteralPath $stage -PathType Container)) {
	throw "Staged content directory '$stage' is unavailable; refusing to reset the container."
}
```

**Affected code locations:**

- `.github/workflows/deploy-learninghub.yml`, **Stage Markdown content**: creates and validates `$stage`.
- `.github/workflows/deploy-learninghub.yml`, **Synchronize Markdown content to blob storage**: resets the container and consumes `$env:CONTENT_STAGE`.

---

## ✅ Solution implemented

### Derive the staging path in the consumer step (✅ done)

The synchronization step now independently derives the known path from the job's `RUNNER_TEMP` directory. It no longer depends on `CONTENT_STAGE` or `$GITHUB_ENV`.

### Validate the computed source before destructive cleanup (✅ done)

The synchronization step validates the computed path before contacting or resetting the container:

```powershell
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
if (-not (Test-Path -LiteralPath $stage -PathType Container)) {
	throw "Staged content directory '$stage' is unavailable; refusing to reset the container."
}
```

This guard addresses both the observed variable-handoff defect and the broader safety gap. Any future failure to produce or retain the staging directory stops the workflow before blob deletion.

### Resulting synchronization sequence

1. Stage content and verify that at least one Markdown file exists. (✅ done)
2. Recompute the absolute staging path from `RUNNER_TEMP` in the synchronization step. (✅ done)
3. In the synchronization step, verify that the computed path points to a directory. (✅ done)
4. Create or reach the destination container. (✅ done)
5. Reset the destination and verify that no active blobs remain. (✅ done)
6. Upload from the validated source and invalidate the application cache. (🟡 pending end-to-end workflow verification)

---

## 📚 Additional information

### Validation performed

| Check | Result | What it proves |
|---|---|---|
| VS Code diagnostics for `deploy-learninghub.yml` | No errors | The edited workflow has no reported YAML or expression diagnostics. |
| `git diff --check` | Passed | The workflow change has no whitespace errors. |
| Live GitHub Actions workflow run | Pending | Azure authentication, reset, upload, and cache invalidation still need end-to-end confirmation. |


### Testing recommendations

- Manually dispatch **Deploy Learning Hub content to storage** after committing the workflow fix. (🟡 todo)
- Confirm the log prints a nonempty path in `Synchronized <path> to digitoolstestmcstitn01/learn`. (🟡 todo)
- Confirm the container contains the expected Markdown and image blobs after upload. (🟡 todo)
- Open the deployed Learning Hub and verify that navigation and representative articles load. (🟡 todo)
- Confirm the cache-invalidation step reports `App cache flushed`, or document a nonfatal invalidation warning. (🟡 todo)

### Migration considerations

No data-model, infrastructure, or application migration is required. The fix changes only how an existing temporary path is passed between workflow steps and adds a precondition before destructive synchronization.

### Performance impact

The additional work is one environment-file append and one local directory existence check. Its runtime cost is negligible compared with deleting and uploading hundreds of blobs.

### Security impact

The fix doesn't change authentication or authorization. The workflow continues to use GitHub OIDC and Azure role-based access through `--auth-mode login`; no credentials are added to the workflow or logs.

---

## ✔️ Resolution status

**Current status:** The source-argument failure is addressed in the working tree. A successful GitHub Actions run is still required before the incident can be marked fully resolved.

### Verification checklist

- Azure CLI source-argument failure identified from the workflow log. (✅ done)
- Cross-step `CONTENT_STAGE` dependency removed. (✅ done)
- Computed source path checked before container reset. (✅ done)
- Workflow diagnostics completed without errors. (✅ done)
- Workflow fix committed and pushed to `main`. (🟡 pending)
- Content deployment rerun successfully in GitHub Actions. (🟡 pending)
- Blob count and deployed Learning Hub behavior verified after the rerun. (🟡 pending)

### Follow-up actions

- Consider staging into a uniquely named directory per run to reduce coupling to residual runner state. (📌 next steps)
- Consider uploading to a temporary container or prefix and switching only after upload validation if stronger atomicity becomes necessary. (📌 next steps)
- Add a log statement that records the resolved source directory immediately before upload. (📌 next steps)

---

## 🎓 Lessons learned

### What went wrong

- GitHub Actions environment-file handoffs can be avoided when both steps can deterministically derive the same job-scoped path.
- Log the resolved values used by native commands when a failure can occur after destructive work.
- The reset-first mirror strategy made a source-argument failure operationally significant.

### What went right

- The reset loop logged its progress and final zero count, making the operation sequence unambiguous.
- Azure CLI's argument parser produced a precise error that pointed directly to the missing source value.
- The workflow already converted native command failures into terminating PowerShell errors, so the job didn't falsely report success.
- The repair remained small: derive the staging path locally in the consumer step, preserve its guard, and pass the local value to Azure CLI.

### Improvements for future workflows

- Validate every destructive operation's replacement input immediately before deletion. (📌 next steps)
- Prefer deterministic job-scoped paths over environment handoffs when no data must be dynamically transferred. (📌 next steps)
- Add pre-upload logging for the resolved source path without exposing secrets. (📌 next steps)
- Make failure messages state both the missing precondition and the destructive action that was refused. (📌 next steps)

---

## 📎 Appendix

### Failure timeline

| Event | Evidence | Interpretation |
|---|---|---|
| Reset completes | Pass 1 leaves 0 active blobs | The destructive phase completes successfully. |
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

# Synchronization step, before container access or deletion
$stage = Join-Path $env:RUNNER_TEMP "learn-content-stage"
if (-not (Test-Path -LiteralPath $stage -PathType Container)) {
	throw "Staged content directory '$stage' is unavailable; refusing to reset the container."
}
```

### Files changed

- `.github/workflows/deploy-learninghub.yml`: derives the staging path from `RUNNER_TEMP` in the upload step and validates it before resetting Blob Storage.
- `src/docs/90. Issues/202608/20260813.01-markdowndeploy-fix/overview.md`: records this incident analysis.

---

## 📚 References

- [Failed GitHub Actions job](https://github.com/darioairoldi/Learn/actions/runs/31680419805/job/94390095603#step:6:45) 📘 [Official]
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
	version: "1.1"
	status: "code-resolved-verification-pending"
	issue_type: "ci-cd-deployment-failure"
-->
