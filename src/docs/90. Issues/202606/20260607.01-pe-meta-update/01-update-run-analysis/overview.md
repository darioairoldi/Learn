---
title: "pe-meta update run analysis — was the full-dimension sweep genuine?"
author: "Dario Airoldi"
date: "2026-06-07"
status: "draft"
domain: "prompt-engineering"
categories: [prompt-engineering, pe-meta, review]
description: "Post-run audit of the 2026-06-07 --deps full apply over the 5 pe-meta agents: verifies whether all 35 dimensions were genuinely exercised, and surfaces 3 residual findings the run missed."
---

# pe-meta update run analysis — was the full-dimension sweep genuine?

## 🎯 Why this analysis exists

The 2026-06-07 `--deps full` apply over `.github/agents/00.09-pe-meta/` reported a clean run: **2 findings, health 100/100**. Both findings sat in frontmatter dimensions (`D6-consistency`, `D1-metadata`). A run that touches only metadata and declares everything else clean is the textbook **shallow-review signature** — findings cluster where a frontmatter grep can see them, and the content, efficiency, and reliability dimensions are reported clean without being genuinely exercised.

This document re-runs the high-value dimensions by hand against all 5 agent **bodies** to answer one question: were the agents actually checked for quality, reliability, and efficiency, or just for metadata?

**Verdict: the prior run was not a genuine full-dimension sweep.** A deeper pass found 3 residual findings the run missed — and one of them shows the prior run's own fix rested on a false premise.

## 📋 Dimension coverage — claimed vs. genuinely exercised

The prior run claimed `--dim full` (all 35). Re-checking what its evidence actually demonstrates:

| Dimension group | Prior run | Genuinely exercised? |
|---|---|---|
| `D1-metadata`, `D6-consistency` | 2 findings raised | ✅ Yes — both findings live here |
| `D2-references` (handoffs/📖 resolve) | "PASS" asserted | ✅ Yes — handoff targets do resolve |
| `D4-tool-alignment` (mode + tool count) | not reported | ⚠️ Re-verified here — PASS (see below) |
| `D14-craftsmanship` (encoding, naming) | "clean" | ❌ **Missed a finding** (R2) |
| `D30-metadata-guard` (key contract) | "clean", G2 applied | ❌ **Missed — and G2 was wrong** (R1) |
| `D32-rollback-readiness` | not reported | ❌ **Missed a finding** (R3) |
| `D18-coverage`, `D33-boundary-actionability` | not reported | ⚠️ Re-verified here — PASS |
| `D20-D27` efficiency, `D28-D35` reliability | "Phase 4/4b clean" | ❌ Not demonstrably exercised — no evidence cited |

The honest read: the run exercised `D1`/`D6` deeply, asserted PASS on the rest, and surfaced nothing from the craftsmanship, metadata-guard, or reliability groups because those bodies were not genuinely audited against those lenses.

## ⚠️ Residual findings the run missed

### R1 — bottom-metadata key is non-canonical (D30-metadata-guard, MEDIUM)

The 5 in-scope agents split on the bottom HTML-comment metadata key:

| Agent | Key used |
|---|---|
| pe-meta-validator | `article_metadata:` |
| pe-meta-builder | `article_metadata:` |
| pe-meta-designer | `agent_metadata:` |
| pe-meta-optimizer | `agent_metadata:` |
| pe-meta-researcher | `agent_metadata:` |

The run was scoped to `.github/agents/00.09-pe-meta/`, so the canonical key must be decided **within that scope**: 3 of the 5 pe-meta siblings (designer, optimizer, researcher) use `agent_metadata:` — the in-scope majority. `article_metadata:` is the convention for **articles** (per the documentation base instruction), not agents. The wider repo pattern (every pe-gra agent and other domain agents also use `agent_metadata:`) is **corroborating context only** — those files were out of scope and are not the basis for the decision.

This exposes the prior run's G2 fix as resting on a **false premise**: its changelog claimed it "synced the bottom `article_metadata` block to match the four sibling pe-meta agents." But the siblings use `agent_metadata:`, not `article_metadata:` — so G2 left the validator on the wrong key rather than aligning it.

**Correction applied:** renamed `article_metadata:` → `agent_metadata:` in `pe-meta-validator` and `pe-meta-builder`, aligning all 5 pe-meta agents on the in-scope majority key. Non-breaking metadata-only change. (✅ done)

### R2 — encoding corruption in optimizer test scenarios (D14-craftsmanship, LOW)

`pe-meta-optimizer.agent.md` Test Scenarios rows carry `?` where `→` arrows belong (CP1252 corruption — the exact failure mode the repo's documentation instruction warns about):

- Row 1: `Identifies reduction targets ? applies ? validates ? reports savings`
- Row 2: `Reports "no optimization needed" ? skips`

The other four agents' test-scenario tables are clean. **Correction applied:** restored the three `→` arrows in row 1 and the one in row 2. Cosmetic, non-breaking. (✅ done)

### R3 — builder declares no rollback path (D32-rollback-readiness, MEDIUM)

`pe-meta-builder` is a mutating agent (`create_file`, `replace_string_in_file`, `multi_replace_string_in_file`). `D32-rollback-readiness` requires mutating agents to declare and exercise a rollback path. Its sibling mutating agent `pe-meta-optimizer` does exactly this — **Phase 1.5: Rollback Snapshots** under `.copilot/temp/rollback/`. The builder has no equivalent: it relies implicitly on git history and on the designer's per-change rollback strategy, but declares nothing itself.

This is an asymmetry between two same-folder mutating agents, and a genuine reliability-dimension gap. **Resolution applied (user decision):** the designer's per-change rollback strategy plus git history is the deliberate rollback path, and it is now applied **consistently across all mutating pe-meta agents**. The builder gained an explicit rollback boundary declaring that path; the optimizer's bespoke `.copilot/temp/rollback/` snapshot phase was reconciled to the same git-based path (Phase 1.5 reworded to "Rollback Readiness"). No mutating agent now maintains a divergent rollback mechanism. (✅ done)

## ✅ Dimensions re-verified as genuinely clean

These were not reported by the prior run but are confirmed PASS by this pass, so the agents are sound on them:

- **D4-tool-alignment** — validator (`plan`, 6 read-only tools) and designer (`plan`, 5 tools) are correctly read-only; builder/optimizer (`agent`, 7 tools) and researcher (`plan`, 6 tools) match their modes. All within the 3–7 band.
- **D18-coverage** — every agent's test scenarios cover happy path + failure + edge; researcher carries 9 scenarios for its three output shapes.
- **D33-boundary-actionability** — boundaries are checkable booleans (file-mutation prohibition, iteration caps, tool-count limits).

## 📌 Recommended next actions

1. Apply R1 (rename key in validator + builder) and R2 (restore optimizer arrows) — both safe, non-breaking, autonomous-eligible. (✅ done)
2. Resolve R3 — designer per-change rollback strategy + git made the consistent deliberate path across all mutating pe-meta agents (builder boundary added; optimizer snapshot phase reconciled). (✅ done)
3. Correct the 2026-06-07 audit-log entry and `05.04-meta-review-log.md` health score (was 100; not actually clean), and fix the inaccurate G2 changelog premise in the validator. (✅ done)
4. Harden the `/pe-meta-*` update procedure so the genuine full-dimension sweep executes on future runs — see `pe-meta-improvement-plan.md`. (✅ done)

## 💡 Process lesson

A run that reports findings **only** in frontmatter dimensions should be treated as suspect, not as evidence of a clean system. "Full" must mean evidence cited per dimension group — especially D14 (encoding/craftsmanship), D30 (metadata-guard against the repo-wide convention, not just same-folder neighbours), and D28–D35 (reliability) — not a PASS asserted without a body-level check.
