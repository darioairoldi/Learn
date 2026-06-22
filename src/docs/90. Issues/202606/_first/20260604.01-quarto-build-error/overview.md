---
# Quarto Metadata
title: "Issue: Quarto CI build fails — header-includes.html missing on runner"
author: "Dario Airoldi"
date: "2026-06-04"
categories: [issue, quarto, ci-cd, github-actions, theming]
description: "A full-project Quarto render failed on every nested document with a FATAL 'Error resolving header-includes' because header-includes.html (the runtime theme switcher) was not versioned and got wiped by the self-hosted runner's git clean. The About-menu theme options disappeared as a result."
draft: true
---

# Issue Report

**Issue Title:** Quarto CI build fails with `Error resolving header-includes` — `header-includes.html` not versioned

**Date Reported:** 2026-06-04
**Reporter:** Dario Airoldi
**Status:** Resolved

| Field | Value |
|---|---|
| **Severity** | High |
| **Component** | Quarto site build · `header-includes.html` · `.github/workflows/quarto-publish.direct.yml` |
| **Framework / Tooling** | Quarto 1.6.42 (CI) / 1.5.56 (local) · GitHub Actions self-hosted runner |
| **Symptom surface** | Every nested document (247 files) · missing About-menu theme switcher |
| **Affected branch** | `main` |

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Implemented](#-solution-implemented)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

A site deploy via the `Quarto Site Deploy (Direct Push - No Artifacts)` workflow produced a
`docs/` output that *looked* built (pages rendered, links resolved), but the **About menu was
missing its theme options** and the build log was flooded with a repeating fatal error.

**Error message (repeated for nearly every document):**

```text
FATAL (C:/Program Files/Quarto/share/filters/main.lua:3949) An error occurred:
Error resolving header-includes- unable to open file header-includes.html
```

**Impact points**

- The runtime **Bootswatch theme switcher** (25 themes) injected by `header-includes.html` was
  dropped from every page — so the **About → theme options never appeared**.
- The nested-submenu CSS/JS that the same include provides (the About dropdown's submenu support)
  was also absent.
- The render emitted `FATAL` for ~238 of 247 documents while still producing partial HTML output,
  masking the failure as a "successful-looking" deploy.

---

## 🔍 Context Information

**Environment**

| Item | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Workflow | [.github/workflows/quarto-publish.direct.yml](.github/workflows/quarto-publish.direct.yml) |
| Runner | `self-hosted` (Windows), persistent state across runs |
| Quarto (CI) | 1.6.42 (pinned in workflow) |
| Quarto (local) | 1.5.56 |
| Config reference | [_quarto.yml](_quarto.yml#L728) → `include-in-header: header-includes.html` |
| Missing file | `header-includes.html` (repo root) |

**Where the include is wired**

```yaml
# _quarto.yml (format.html)
format:
  html:
    theme:
      light: [cosmo, theme-light.scss]
      dark:  [cosmo, theme-dark.scss]
    css: styles.css
    include-in-header: header-includes.html   # ← runtime theme switcher + About submenu
```

**Runner state-reset steps that triggered the loss**

```powershell
git fetch origin main --force
git checkout -B main origin/main --force
git clean -fdx          # ← wipes ALL untracked files, including header-includes.html
```

---

## 🔬 Analysis

### Root cause

`header-includes.html` was **not versioned** (untracked in git). It existed only in the local
working tree, so:

- **Local renders succeeded** — the file was present on disk.
- **CI renders failed** — the self-hosted runner performs `git fetch` + `git checkout --force` +
  `git clean -fdx`, which deletes every untracked file. With `header-includes.html` gone, Quarto's
  `include-in-header` directive could not resolve, raising a `FATAL` for each document that the
  project-level `format.html` config applied to.

Because the include is declared at the project level, the failure fanned out across **all 247
documents** rather than a single page.

### Why "the site looked built"

Quarto continued past each per-document FATAL and still emitted HTML, so `docs/` populated and the
deploy step pushed it to `gh-pages`. The output was structurally present but **stripped of the
theme switcher**, which is exactly the user-visible symptom (no theme options under About).

### Contributing factor — version skew (secondary)

Local Quarto (1.5.56) vs CI (1.6.42) initially suggested a version-specific path-resolution
regression. Investigation ruled this out: a single-file render on 1.5.56 injected the switcher
correctly, and the decisive evidence was that the file was simply **absent on the runner**. The
version difference was a red herring; the missing artifact was the true cause.

### Impact assessment

| Surface | Effect |
|---|---|
| Theme switcher (About menu) | Not rendered on any page |
| About dropdown submenu | Missing supporting CSS/JS |
| Build log | ~238 FATAL lines, obscuring real status |
| Deploy gate | None — broken output still shipped |

---

## 🔄 Reproduction Steps

1. Ensure `header-includes.html` exists locally but is **untracked** (`git status` shows `??`).
2. Trigger the deploy workflow (push to `main`) on the self-hosted runner.
3. The runner runs `git clean -fdx`, deleting the untracked `header-includes.html`.
4. `quarto render --to html` emits, for each nested document:
   `FATAL ... Error resolving header-includes- unable to open file header-includes.html`.
5. Observe the published site: pages render, but the About-menu theme options are gone.

**Affected code locations**

- [_quarto.yml](_quarto.yml#L728) — `include-in-header: header-includes.html`
- [header-includes.html](header-includes.html) — the (previously untracked) theme switcher
- [.github/workflows/quarto-publish.direct.yml](.github/workflows/quarto-publish.direct.yml) — `git clean -fdx` + render step

---

## ✅ Solution Implemented

**Fix overview:** Commit the missing artifact, then add a fail-fast guard so a future missing
include aborts the build instead of shipping a degraded site.

**F1 — Version the artifact**

`header-includes.html` is now committed and present on `origin/main` (`8e6f46b`). The next
runner checkout includes it, so `git clean -fdx` no longer removes it and the include resolves.

```text
git cat-file -e origin/main:header-includes.html  → OK (8e6f46b)
```

**F2 — Fail-fast guard in the workflow**

Added a `Verify required Quarto includes` step before the render that aborts if any
config-referenced asset is missing:

```powershell
$required = @("header-includes.html","theme-light.scss","theme-dark.scss","styles.css")
$missing  = $required | Where-Object { -not (Test-Path $_) }
if ($missing) {
  Write-Error "Required Quarto include(s) missing from checkout: $($missing -join ', ')"
  exit 1
}
```

**Solution features**

- ✅ Root cause removed — the include is now part of the repo, immune to `git clean -fdx`.
- ✅ Future regressions fail loudly **before** a broken site is published.
- ✅ No change to the theme switcher itself; behavior restored on next deploy.

---

## 📚 Additional Information

**Testing recommendations**

- Re-run the deploy workflow and confirm zero `Error resolving header-includes` lines in the log.
- Open a nested published page (e.g. `01.00-news/20260214.4-burke-holland-mcp-apps/summary.html`)
  and verify the About-menu theme picker is present and switches themes.
- Optionally align local Quarto to 1.6.42 to keep local/CI behavior identical.

**Hardening ideas (optional, not yet applied)**

- Treat per-document FATALs as a build failure (fail the step if the render log contains `FATAL`).
- Add a `.gitignore` review so build-critical assets are never accidentally ignored.

**Performance impact:** None — the fix restores existing behavior and adds one lightweight check.

---

## ✔️ Resolution Status

**Status:** Resolved (artifact committed `8e6f46b`; guard added 2026-06-04)

**Verification checklist**

- [x] `header-includes.html` confirmed tracked in HEAD and present on `origin/main`
- [x] Single-file local render injects the theme switcher
- [x] Fail-fast guard added to the render workflow
- [ ] Full deploy re-run confirmed clean (no FATAL lines) — pending next push
- [ ] About-menu theme options verified on the live site — pending next deploy

**Follow-up actions**

- [ ] Re-run the deploy workflow on `main` and inspect the log for FATALs.
- [ ] Consider failing the build on any `FATAL` in the Quarto render output.

---

## 🎓 Lessons Learned

**What went wrong**

- A build-critical asset referenced by `_quarto.yml` was never committed, so it existed only on the
  author's machine.
- The self-hosted runner's `git clean -fdx` silently removed the untracked file.
- Quarto's per-document FATAL did not stop the build, so a degraded site shipped unnoticed.

**What went right**

- The repeating, identical error message pointed straight at the missing include.
- Comparing local (working) vs CI (failing) behavior quickly isolated "present locally, absent on runner".

**Improvements for the future**

- Any file referenced from `_quarto.yml` (includes, themes, CSS) must be committed — verified by a
  pre-render guard.
- Prefer failing fast on missing assets over publishing partial output.
- When local and CI diverge on a self-hosted runner, suspect untracked/cleaned files before tooling versions.

---

## 📎 Appendix

**A. Representative build-log excerpt**

```text
[ 17/247] 01.00-news\20260214.4-burke-holland-mcp-apps\summary.md
FATAL (C:/Program Files/Quarto/share/filters/main.lua:3949) An error occurred:
Error resolving header-includes- unable to open file header-includes.html

[ 18/247] 02.00-events\202506-build-2025\readme.md
FATAL (C:/Program Files/Quarto/share/filters/main.lua:3949) An error occurred:
Error resolving header-includes- unable to open file header-includes.html
```

(The same two-line FATAL block repeated for ~238 of 247 documents.)

**B. Diagnostic commands used**

```powershell
git ls-files --error-unmatch header-includes.html   # tracked?
git check-ignore -v header-includes.html            # ignored?
git cat-file -e HEAD:header-includes.html           # in HEAD?
git cat-file -e origin/main:header-includes.html    # on remote tip?
quarto --version                                    # 1.5.56 local vs 1.6.42 CI
```

**C. Related references**

- [Quarto customization analysis](../20260603.04-Quarto-customization-analysis/overview.md) — describes the `header-includes.html` switcher layer.
- [_quarto.yml](_quarto.yml#L728) — the `include-in-header` declaration.
- [.github/workflows/quarto-publish.direct.yml](.github/workflows/quarto-publish.direct.yml) — runner reset + render + new guard.
