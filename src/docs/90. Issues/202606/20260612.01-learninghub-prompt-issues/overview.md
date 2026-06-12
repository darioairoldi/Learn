---
# Quarto Metadata
title: "Issue: Reliability and consistency defects in the Learning Hub menu and kebab-case prompts"
author: "Dario Airoldi"
date: "2026-06-12"
categories: [issue, prompt-engineering, quarto, learning-hub, tooling]
description: "Analysis of two Learning Hub prompt files — learninghub-createorupdate-quarto-menu and learninghub-ensure-kebab-notation. The menu prompt blocks the agent by running 'quarto preview' synchronously and has a name/version mismatch; the kebab prompt has a no-op test scenario, omits root dated folders from its scan, and misses underscores in its infrastructure filter. Both lack the required 'domain' YAML field."
draft: true
---

# Issue Report

**Issue Title:** Reliability and consistency defects in the Learning Hub menu and kebab-case prompts

**Date Reported:** 2026-06-12
**Reporter:** Dario Airoldi
**Status:** Resolved — fixes applied to both prompts

| Field | Value |
|---|---|
| **Severity** | Medium (one reliability blocker, several correctness/consistency defects) |
| **Component** | `.github/prompts/90.00-learning-hub/` prompt files |
| **Framework / Tooling** | GitHub Copilot prompt files · Quarto · PowerShell |
| **Symptom surface** | Running the menu-validation prompt; running the kebab-case enforcement prompt |
| **Affected branch** | `main` |

---

## 📑 Table of Contents

- [📝 Observation](#-observation)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [✅ Solution proposed](#-solution-proposed)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)

---

## 📝 Observation

While reviewing the two Learning Hub prompts for goal and scope, several defects surfaced that
either block execution or cause the prompt to miss the very violations it is meant to fix.

Files reviewed:

- [learninghub-createorupdate-quarto-menu.prompt.md](../../../../../.github/prompts/90.00-learning-hub/learninghub-createorupdate-quarto-menu.prompt.md)
- [learninghub-ensure-kebab-notation.prompt.md](../../../../../.github/prompts/90.00-learning-hub/learninghub-ensure-kebab-notation.prompt.md)

Both prompts are otherwise well-scoped and align with the context rules in
[06-folder-organization-and-navigation.md](../../../../../.copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md)
and
[07-sidebar-menu-rules.md](../../../../../.copilot/context/90.00-learning-hub/07-sidebar-menu-rules.md).

---

## 🔍 Context information

| Prompt | Stated goal | Role |
|---|---|---|
| `learninghub-createorupdate-quarto-menu` | Validate `_quarto.yml` by comparing `project.render` paths against files on disk; remove dangling refs, add missing articles, enforce news newest-first | Validator |
| `learninghub-ensure-kebab-notation` | Enforce 100% kebab-case across content + infrastructure folders, rename deepest-first, update references, validate via `quarto render` loop | Naming enforcer |

The applicable authoring rules come from
[pe-prompts.instructions.md](../../../../../.github/instructions/pe-prompts.instructions.md),
which requires the YAML frontmatter to include a `domain` field (severity **[C6]**).

---

## 🔬 Analysis

### Menu prompt (`learninghub-createorupdate-quarto-menu`)

| # | Severity | Defect | Detail |
|---|---|---|---|
| 1 | **High (reliability)** | `quarto preview` blocks the agent | Phase 4.1 runs `quarto preview` synchronously via `run_in_terminal`. Preview starts a long-running dev server that never returns, so the agent blocks or times out. The v10.1 change ("removed `--no-browser` to enable visual verification") made this worse. Validation should use `quarto render` (build-only, returns). |
| 2 | Medium | `name` / filename / version mismatch | Frontmatter `name: learnhub-sidebar-menu-v3` does not match the filename (`learninghub-createorupdate-quarto-menu`) and embeds "v3", while the footer reports `version: 10.1`. Violates naming guidance **[M6]** and is internally confusing. |
| 3 | Medium | Missing required `domain` field | YAML frontmatter omits `domain:`, required by **[C6]**. |

### Kebab-notation prompt (`learninghub-ensure-kebab-notation`)

| # | Severity | Defect | Detail |
|---|---|---|---|
| 4 | Medium | No-op test scenario | Test Scenario 2 shows `.github/prompts/00.00-prompt-engineering/` → `.github/prompts/00.00-prompt-engineering/` — input equals output, demonstrating nothing. It should show a real transformation (e.g. `.github/prompts/00.00 Prompt Engineering/` → `…/00.00-prompt-engineering/`). |
| 5 | **High (correctness)** | Scan omits root dated folders | "Always Do #2" lists `root dated folders (20250815-diy-*/)`, but the Phase 1 PowerShell `Get-ChildItem -Path …` list does not include them, so `20250815-diy-battery-pack/` etc. are never scanned. |
| 6 | Medium | Infra scan misses underscores | The content scan filters `'\s|[A-Z]|_'`, but the infrastructure scan filters only `'\s|[A-Z]'`, even though underscore → hyphen is a mandatory transformation. Infra folders with underscores are missed. |
| 7 | Low | Case-only renames on Windows | `Rename-Item BRK-Sessions → brk-sessions` is a case-only change on a case-insensitive filesystem; it can be a silent no-op that git does not track. A two-step rename is needed. |
| 8 | Medium | Missing `domain` field + no footer | YAML omits `domain:` (**[C6]**); the prompt also lacks the `prompt_metadata` footer the menu prompt has — a minor consistency gap. |

**Root cause.** The two highest-impact defects (1 and 5) stem from the same pattern: the prompt
text describes the correct intent in prose, but the executable step (the terminal command in #1,
the PowerShell path list in #5) diverges from that intent. The remaining items are
metadata/consistency drift accumulated across versions.

**Impact.**

- Defect 1 makes the menu prompt effectively unrunnable end-to-end (the agent stalls at Phase 4).
- Defect 5 produces false "all clean" results because non-scanned folders are never checked.
- Defects 2, 3, 6, 8 reduce discoverability and convention compliance; 4 and 7 reduce robustness.

---

## ✅ Solution proposed

### Menu prompt

- Replace synchronous `quarto preview` in Phase 4 with `quarto render` (build-only, returns).
  Keep `quarto preview` as an **optional, background** step for manual visual verification only.
- Set `name: learninghub-createorupdate-quarto-menu` to match the filename; drop the embedded
  "v3" so the footer `version` is the single source of truth.
- Add `domain: "learning-hub"` to the YAML frontmatter.

### Kebab-notation prompt

- Fix Test Scenario 2 to show a real transformation, e.g.
  `.github/prompts/00.00 Prompt Engineering/` → `.github/prompts/00.00-prompt-engineering/`.
- Add root dated folders (`20250815-diy-*/` and siblings) to the Phase 1 `Get-ChildItem -Path`
  list, or scan the repository root for `YYYYMMDD-*` folders.
- Add `_` to the infrastructure scan filter so it reads `'\s|[A-Z]|_'`, matching the content scan.
- Add an Error Recovery entry for case-only renames: rename via a temporary name first
  (`X → X-tmp → x`) so the change is tracked on case-insensitive filesystems.
- Add `domain: "learning-hub"` to the YAML frontmatter and a `prompt_metadata` footer for parity.

---

## 📚 Additional information

- **Testing recommendation:** After fixing the menu prompt, run it against a known dangling ref
  and a freshly added article to confirm Phase 2 detects both and Phase 4 completes without
  stalling.
- **Testing recommendation:** After fixing the kebab prompt, run a `full scan` and confirm the
  root `20250815-diy-*` folders appear in the Phase 1 violation list.
- **Convention reference:** `domain` field semantics are defined in the prompt instructions
  ([pe-prompts.instructions.md](../../../../../.github/instructions/pe-prompts.instructions.md), **[C6]**).

---

## ✔️ Resolution status

**Status:** Resolved — fixes applied to both prompts

- [x] Both prompts reviewed against context rules and prompt instructions
- [x] Defects catalogued with severity
- [x] Fixes proposed for each defect
- [x] Menu prompt: `quarto preview` → `quarto render` applied
- [x] Menu prompt: `name` / `domain` corrected
- [x] Kebab prompt: Test Scenario 2, root-folder scan, underscore filter fixed
- [x] Kebab prompt: `domain` + footer added
- [ ] Both prompts re-tested on real repository content

---

## 🎓 Lessons learned

- **Keep prose intent and executable steps in sync.** The most serious defects appeared where the
  description was correct but the actual command or path list drifted from it. Test scenarios
  should exercise the executable step, not the prose.
- **Test scenarios must show change.** A scenario whose input equals its output validates nothing
  and hides regressions.
- **Validation prompts must not run blocking servers.** Prefer build-only commands
  (`quarto render`) in automated phases; reserve long-running servers (`quarto preview`) for
  explicit, optional, background verification.
- **Metadata drifts across versions.** Embedding version numbers in `name` and hard-coding paths
  in scan commands invites mismatch; derive names from filenames and keep one source of truth.
