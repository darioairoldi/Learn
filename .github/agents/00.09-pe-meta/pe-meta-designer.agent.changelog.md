---
title: "pe-meta-designer.agent — change history"
description: "Per-version change history for pe-meta-designer.agent."
last_updated: "2026-06-12"
status: "living"
---

# Change history — pe-meta-designer.agent

## v2.1.0 — 2026-06-12

Adopted metadata-precedence runtime grounding (vision v15.6.0). Added a single collective grounding directive to CRITICAL BOUNDARIES and removed body entries that restated YAML boundaries verbatim (read-before-modify, layer ordering, rollback-per-change, never-modify-files, never-re-research, current-state verification). Three-tier entries are now additive only. Retired per-boundary bijection (H14).

## v2.0.3 — 2026-06-07

Restored canonical agent section structure (issue 20260607.01 plan 03 R3, human decision A). The pe-meta cluster had self-normalized to `## Persona` + plain boundary headers, diverging from agent.template.md and the 6 non-pe-meta agents (all use `## Your Expertise` + emoji boundary headers). Renamed `## Persona` → `## Your Expertise` and re-applied emoji boundary headers (`## 🚨 CRITICAL BOUNDARIES`, `### ✅ Always Do`, `### ⚠️ Ask First`, `### 🚫 Never Do`). Synced bottom-metadata version/last_updated.

## v2.0.2 — 2026-06-06

Refreshed dimension-range reference D1-D27 to D1-D35 (dimension catalog v1.5.0); synced bottom-metadata version/last_updated to the authoritative frontmatter values (were stale at 1.0 / 2026-03-20).
