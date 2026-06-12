---
title: "pe-meta-optimizer.agent — change history"
description: "Per-version change history for pe-meta-optimizer.agent."
last_updated: "2026-06-12"
status: "living"
---

# Change history — pe-meta-optimizer.agent

## v1.2.0 — 2026-06-12

Adopted metadata-precedence runtime grounding (vision v15.6.0). Added a single collective grounding directive to CRITICAL BOUNDARIES and removed body entries that restated YAML boundaries verbatim (one-file-at-a-time, preserve-rules, remove-canonical, files-outside-scope, skip-revalidation, 3-iteration cap). Three-tier entries are now additive only. Retired per-boundary bijection (H14).

## v1.1.4 — 2026-06-07

Restored canonical agent section structure (issue 20260607.01 plan 03 R3, human decision A) — reverted the pe-meta-cluster self-normalization that diverged from agent.template.md and the 6 non-pe-meta agents. Renamed `## Persona` → `## Your Expertise` and re-applied emoji boundary headers (`## 🚨 CRITICAL BOUNDARIES`, `### ✅ Always Do`, `### ⚠️ Ask First`, `### 🚫 Never Do`). Synced bottom-metadata version/last_updated.

## v1.1.3 — 2026-06-07

Restored four `→` arrows corrupted to `?` (CP1252) in the Test Scenarios table (R2, D14-craftsmanship). Reconciled Phase 1.5 from bespoke `.copilot/temp/rollback/` snapshots to git-history-based rollback so the rollback strategy is consistent with sibling pe-meta mutating agents (R3) — the designer-supplied per-change rollback strategy plus git is now the single deliberate path across all steps. Found by the 2026-06-07 follow-up re-audit.

## v1.1.2 — 2026-06-06

Synced bottom-metadata version/last_updated to the authoritative frontmatter values (were stale at 1.0 / 2026-03-20).
