---
# Quarto Metadata
title: "Issue: PE context freshness drift — stale SDK/model status references"
author: "Dario Airoldi"
date: "2026-06-03"
categories: [issue, prompt-engineering, freshness, meta-update]
description: "Freshness audit of the prompt-engineering context folder found two stale upstream-status references (Copilot SDK preview vs GA, GPT-4.1 deprecation), corrected via /pe-meta-update apply run."
draft: true
---

# Issue Report

**Issue Title:** PE context freshness drift — stale Copilot SDK and GPT-4.1 status references

**Date Reported:** 2026-06-03
**Reporter:** Dario Airoldi
**Status:** Resolved

| Field | Value |
|---|---|
| **Severity** | Medium |
| **Component** | `.copilot/context/00.00-prompt-engineering/` (PE context folder) |
| **Framework / Tooling** | GitHub Copilot customization · `/pe-meta-update` orchestrator v2.2.0 |
| **Dimensions** | Freshness (D12-staleness, D13-source-verification) |
| **Run ID** | `freshness-20260603` |

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

A scoped freshness run of the `/pe-meta-update` orchestrator against the prompt-engineering
context folder revealed that the recorded source watermarks had fallen **~5 weeks behind**
the live upstream sources, leaving two context files asserting outdated product status.

**Symptoms**

- Recorded watermarks: VS Code release notes `1.117`, GitHub Copilot changelog `2026-04-27`.
- Live world-state at audit time: VS Code `1.123` (released 2026-06-03), Copilot changelog through `2026-06-02`.
- Two context files carried claims invalidated by June 2026 upstream changes.

**Impact points**

- Consumers reading [03.06-copilot-sdk-integration.md](.copilot/context/00.00-prompt-engineering/03.06-copilot-sdk-integration.md) would treat the Copilot SDK as **preview** when it had reached **GA**.
- Consumers reading [03.02-model-specific-optimization.md](.copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md) would treat **GPT-4.1** deprecation as *upcoming* when it had already been **retired**.

---

## 🔍 Context Information

**Environment**

| Item | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Orchestrator | `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` v2.2.0 |
| Invocation | `--mode=apply --scope=.copilot/context/00.00-prompt-engineering/ --dim=freshness` |
| Resolved breadth | `full` (manual caller, no `--start`/`--end` window) |
| Bundle | `single-domain` (all 39 files `domain: prompt-engineering`) |
| Watermark source of truth | `05.04-meta-review-log.md` → "Last Processed Versions" table |

**Monitored sources consulted**

| Source | Recorded watermark | Live at audit |
|---|---|---|
| VS Code release notes (`https://code.visualstudio.com/updates`) | 1.117 (2026-04-27) | **1.123** (2026-06-03) |
| GitHub Copilot changelog (`https://github.blog/changelog/label/copilot/`) | 2026-04-27 | **2026-06-02** |

**Key upstream changes detected (Copilot changelog, June 2026)**

- `JUN.02 RETIRED` — **GPT-4.1 deprecated**.
- `JUN.02 RELEASE` — **Copilot SDK now generally available**.
- Other (out-of-dimension): Gemini models in Copilot, MAI-Code-1-Flash, `/chronicle`, scheduled tasks, cloud/local sandboxes.

---

## 🔬 Analysis

### Root cause

The previous apply-mode freshness run (2026-06-01) updated **file content** but the upstream
**June 2 changelog entries had not yet been published** at the time (or were not captured), so the
recorded watermarks remained at the April 27 baseline. Between April 27 and June 3, two
status-bearing claims in the context corpus became stale:

1. **SDK lifecycle transition** — preview → GA is a status change that PE artifacts encode literally,
   so it does not self-correct.
2. **Model deprecation transition** — an "upcoming deprecation" note describing GPT-4.1 was overtaken
   by the actual retirement event.

### Impact assessment

| Affected file | Stale assertion | Risk |
|---|---|---|
| `03.06-copilot-sdk-integration.md` | "public preview since April 2026" | Consumers under-trust a GA-stable surface; may gate features unnecessarily |
| `03.02-model-specific-optimization.md` | GPT-4.1 listed as *upcoming* deprecation | Consumers may pin a retired model |

### Affected workflows

- Any prompt/agent authoring that references SDK maturity or model selection guidance.
- Staleness-detection hook (`pe-staleness-check`) relies on accurate watermarks to flag overdue reviews.

---

## 🔄 Reproduction Steps

1. Run `/pe-meta-update '.copilot\context\00.00-prompt-engineering' --dim freshness`.
2. Phase 1 fetches the two platform sources and compares against the watermark table in
   `05.04-meta-review-log.md`.
3. Observe watermark gap (VS Code 1.117 → 1.123; Copilot 2026-04-27 → 2026-06-02).
4. Phase 4 screens all 39 files; grep for `preview|GPT-4\.1|generally available` surfaces the two stale claims.

**Affected code locations**

- [03.06-copilot-sdk-integration.md](.copilot/context/00.00-prompt-engineering/03.06-copilot-sdk-integration.md#L39)
- [03.02-model-specific-optimization.md](.copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md#L70)

---

## ✅ Solution Implemented

**Fix overview:** Two MEDIUM-severity staleness corrections applied (user-approved at Phase 5),
plus a Phase 8 ledger advance.

**F1 — `03.06-copilot-sdk-integration.md`** (v1.3.0 → v1.4.0)

```diff
- The **GitHub Copilot SDK** (public preview since April 2026) brings Copilot's agentic loop to any application.
+ The **GitHub Copilot SDK** (generally available since June 2026; public preview April 2026) brings Copilot's agentic loop to any application.
```

**F2 — `03.02-model-specific-optimization.md`** (v1.5.0 → v1.6.0)

```diff
- Upcoming GPT-4.1 (announced 2026-05-07) and GPT-5.2/5.2-Codex (announced 2026-05-01) deprecations — verify current model availability before pinning.
+ GPT-4.1 deprecated 2026-06-02 — migrate off it. Upcoming GPT-5.2/5.2-Codex (announced 2026-05-01) deprecation — verify current model availability before pinning.
```

**F3 — `05.04-meta-review-log.md`** (v1.6.0 → v1.7.0)

- Advanced watermarks: VS Code `1.117 → 1.123`, Copilot `2026-04-27 → 2026-06-02`.
- Updated authoritative-source "Last checked" dates to 2026-06-03.
- Appended the apply-mode review entry and refreshed the file manifest.

**Solution features**

- ✅ Each change includes a version-history row and `last_updated` bump.
- ✅ No capability removed (Phase 7 regression: baseline intact).
- ✅ Watermarks advanced so the next run starts from the correct baseline.

---

## 📚 Additional Information

**Testing recommendations**

- Re-run `/pe-meta-update --dim freshness` and confirm zero new staleness findings (idempotency check).
- Validate that `pe-staleness-check` reads `last_updated: 2026-06-03` and reports the corpus as current.

**Out-of-dimension advisory (deferred)**

The following VS Code 1.123 / Copilot June-2026 features are **coverage gaps**, not staleness, and were
intentionally NOT applied under `--dim freshness`:

- Session sync + `/chronicle` agent session insights
- Agents window (multiple side-by-side sessions)
- Research agent (`/research`, Copilot CLI)
- New models: Gemini in Copilot, MAI-Code-1-Flash

> Recommend a follow-up `--dim quality` (or full) run if these should be documented.

**Performance impact:** None — documentation-only edits.

---

## ✔️ Resolution Status

**Status:** Resolved (applied and logged 2026-06-03)

**Verification checklist**

- [x] F1 applied — SDK status reflects GA
- [x] F2 applied — GPT-4.1 marked deprecated/retired
- [x] F3 applied — watermarks + source dates + review entry updated
- [x] Phase 7 regression — capability baseline intact
- [x] Frontmatter `version` / `last_updated` bumped on all three files
- [ ] Idempotency re-run confirmed (recommended follow-up)

**Follow-up actions**

- [ ] Schedule `--dim quality` run to document 1.123 net-new features.
- [ ] Confirm Copilot Spaces / Gemini / MAI-Code-1-Flash references where relevant.

---

## 🎓 Lessons Learned

**What went wrong**

- Watermark advancement lagged content edits in the prior run, allowing status drift to accumulate.
- Lifecycle transitions (preview→GA, deprecation announced→retired) are literal claims that silently rot.

**What went right**

- The watermark table provided an unambiguous baseline for detecting drift.
- Three-tier classification kept the change set minimal (2 content edits) and scoped strictly to freshness.

**Improvements for the future**

- Always advance watermarks in the same run that consumes the source, even when no content change results.
- Maintain an explicit "lifecycle status" watch-list (SDK maturity, model deprecations) for fast screening.

---

## 📎 Appendix

**Run metadata**

```text
Resolved invocation: --mode=apply --scope=.copilot/context/00.00-prompt-engineering/ --source= --dim=freshness --start=none --end=none --deps=none --skip= | breadth=full | caller=manual | bundle=single-domain
Dimensions: D12-staleness + D13-source-verification
Files screened: 39 · Changes applied: 2 · Health score: 94 (2×MEDIUM)
```

**References**

- Orchestrator: [pe-meta-update.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md)
- Audit log: [05.04-meta-review-log.md](.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)
- VS Code 1.123 release notes: <https://code.visualstudio.com/updates/v1_123>
- Copilot changelog: <https://github.blog/changelog/label/copilot/>
