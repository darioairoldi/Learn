---
status: done
domain: "prompt-engineering"
goal: "Modernize the PE capability map (00.02) so every Category 1–4 use-case row references the canonical /pe-meta-* command surface and a real on-disk agent chain — replacing the retired /pe-gra-* granular entry points and the bare *-researcher/builder/validator agent names that do not resolve on disk."
scope: "Edit target = .copilot/context/00.00-prompt-engineering/00.02-capability-map.md ONLY (plus the run-log append to 05.04-meta-review-log.md). Re-point Categories 2–4 entry points and chains; fix two pre-existing Category 1 defects (row 1.4 naming, row 1.5 chain); update the Referenced-by line and the Quick-Verification prose; replace the dated Modernization note; bump version + version history. OUT OF SCOPE: editing prompt/agent files, deprecating the on-disk /pe-gra-* tier, and any vision edit (human-only)."
motivation: "Realizes park-lot item PL-6-capability-map-modernization from 01-pe-meta-design-review-improvement-plan.md (done). DSC-6 surfaced that Category 1/2/3 rows cite a retired /pe-gra-* series with bare *-researcher/builder/validator agents absent on disk; the 2026-06-24 scoped fix only re-pointed Category-1 Creation rows. The vision (v15.10) `scope.covers` P2 capability `per-artifact-prompt-matrix` mandates the `/pe-meta-{type}-{review|create-update|design}` dispatch surface, making /pe-meta-* canonical and /pe-gra-* legacy. The coverage-gap guard (Deep Verification rule 5) requires every named chain artifact to resolve on disk — today the stale rows fail that guard."
authority: "Vision 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md (v15.10) is the rule-5 source of truth for the canonical dispatch surface. The capability map is governed by 00.01-governance-and-capability-baseline.md; the boundary 'MUST NOT remove capability entries without explicit approval' is honored — this plan re-points entries, it removes none."
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# Capability-map modernization (PL-6)

This plan modernizes [00.02-capability-map.md](.copilot/context/00.00-prompt-engineering/00.02-capability-map.md)
so every use-case row points at the canonical `/pe-meta-*` command surface and a chain whose
agents resolve on disk. It realizes park-lot item **PL-6-capability-map-modernization** from
[01-pe-meta-design-review-improvement-plan.md](01-pe-meta-design-review-improvement-plan.md)
(that plan is `done` and is left untouched — terminal).

> **Readiness status (actionable — executing 2026-06-25).** Readiness closed via read-only evidence:
> every `/pe-meta-{type}-{review|design|create-update}` prompt and the consolidated `pe-meta-*`
> and `pe-con-*` agents were confirmed on disk (§ Discovery); the real prompt handoffs were read
> (§ Evidence-grounded decision); § Open decisions holds only the parked cost/value question, which
> is explicitly NON-blocking for this reconciliation. The 8-check Actionability Gate passed
> (§ Actionability Gate result).

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Evidence-grounded decision *(analysis)*
- § 🔎 Discovery — on-disk resolution *(readiness)*
- § ⚙️ Edit mapping (things to do)
- § ❓ Open decisions *(readiness)*
- § 🧪 Exit criteria
- § 📥 Park lot
- § 🔎 Actionability Gate result *(readiness)*

## 🎯 Objective

Bring Categories 1–4 of the capability map to a single canonical surface:

- **Entry points** use `/pe-meta-{type}-{design|review|create-update}` (short type tokens:
  `instruction`, `context`, `snippet` — NOT the granular long tokens `instruction-file`,
  `context-information`, `prompt-snippet`).
- **Agent chains** name only agents that resolve on disk: the `pe-meta-*` orchestration tier
  (`00.09-pe-meta/`) and the `pe-con-*` consolidated tier (`00.01-pe-consolidated/`).
- The legacy `/pe-gra-*` series and the bare unprefixed `*-researcher/builder/validator` names
  are removed from the map (the `/pe-gra-*` files stay on disk — deprecating them is out of scope).

## 🧭 Scope and non-goals

**In scope:** `00.02-capability-map.md` edits + a run-log entry in `05.04-meta-review-log.md`.

**Non-goals:** editing any prompt/agent file; deprecating or deleting the `/pe-gra-*` tier;
any vision edit (the vision is human-only). Category 5 (skills) needs no change — skill names
are unchanged.

## 🔎 Evidence-grounded decision *(analysis)*

The A/B choice (granular vs meta surface) was **dissolved by evidence**, not preference:

- The vision (v15.10) `scope.covers` P2 capability `per-artifact-prompt-matrix` mandates the
  `/pe-meta-{type}-{review|create-update|design}` dispatch surface. Rule 5 keys off the vision's
  `scope.covers`, so `/pe-meta-*` is canonical and `/pe-gra-*` is legacy. → **Option B confirmed.**
- The **real prompt handoffs** were read (not assumed) and are **uniform across types**:
  - design (`/pe-meta-{type}-design`) → `pe-meta-researcher → pe-meta-builder → pe-meta-validator`
  - review (`/pe-meta-{type}-review`) → `pe-meta-validator → pe-con-builder`
  - create-update (`/pe-meta-{type}-create-update`) → `pe-meta-builder → pe-meta-validator`
- This evidence also exposed **two pre-existing Category-1 defects** the 2026-06-24 edit left behind:
  row 1.4 carried the granular token (`/pe-meta-instruction-file-design`), and row 1.5's chain
  dropped the researcher (`pe-meta-context-design` actually uses the full triad).

## 🔎 Discovery — on-disk resolution *(readiness)*

All resolved (read-only), satisfying rule 5's "every artifact named must resolve on disk":

- `00.09-pe-meta/`: `pe-meta-{researcher,builder,validator,designer,optimizer}` — present. (✅ done)
- `00.01-pe-consolidated/`: `pe-con-{researcher,builder,validator}` — present. (✅ done)
- `.github/prompts/00.09-pe-meta/`: all `pe-meta-{type}-{design,review,create-update}` for the 8
  types (`prompt, agent, skill, instruction, context, hook, snippet, template`) — present. (✅ done)

## ⚙️ Edit mapping (things to do)

| Row(s) | Current (stale/defective) | Target |
|---|---|---|
| 1.4 entry | `/pe-meta-instruction-file-design` | `/pe-meta-instruction-design` (✅ done) |
| 1.5 chain | `pe-meta-builder → pe-meta-validator` | `pe-meta-researcher → pe-meta-builder → pe-meta-validator` (✅ done) |
| 1.6 | `@hook-builder` / `hook-researcher → hook-builder → hook-validator` | `/pe-meta-hook-design` / `pe-meta-researcher → pe-meta-builder → pe-meta-validator` (✅ done) |
| 1.7 | `@prompt-snippet-builder` / `prompt-snippet-*` chain | `/pe-meta-snippet-design` / `pe-meta-researcher → pe-meta-builder → pe-meta-validator` (✅ done) |
| 2.1–2.5 entry | `/pe-gra-{type}-review` (long tokens) | `/pe-meta-{type}-review` (short tokens) (✅ done) |
| 2.1–2.5 chain | bare `*-researcher → *-builder → *-validator` / `context-validator ↔ context-builder` | `pe-meta-validator → pe-con-builder` (✅ done) |
| 3.1–3.5 entry | `/pe-gra-{type}-create-update` (long tokens) | `/pe-meta-{type}-create-update` (short tokens) (✅ done) |
| 4.1–4.3 chains | bare `meta-researcher/meta-designer/meta-validator/meta-optimizer` + per-type `{type}-*` | `pe-meta-*` equivalents (✅ done) |
| Referenced-by | `meta-validator`, `meta-designer` | `pe-meta-validator`, `pe-meta-designer` (✅ done) |
| Quick Verification | "all researcher→builder→validator chains resolve" | "all documented agent chains resolve" (✅ done) |
| Modernization note | dated 2026-06-24, parks PL-6 | replaced with completed note dated 2026-06-25 (✅ done) |
| Version | 1.1.0 / 2026-06-07 | 1.2.0 / 2026-06-25 + history row (✅ done) |

## ❓ Open decisions *(readiness)*

- **OD-1 — Is the coverage-gap guard (rule 5) worth its cost? (📌 next steps, NON-blocking).**
  Owner's parked question, verbatim: *"we'll understand afterwards whether this is an effective
  non regression check or a similar validation can be done in a better way to achieve the vision
  (francly it seem to me an expensive step that is not even serving the vision goal very much)."*
  This reconciliation makes the map pass rule 5 today; whether rule 5 itself is the right mechanism
  (vs. a per-artifact `implements:` back-reference, a generated map, or dropping the check) is a
  **separate design question** to revisit after this lands. Routed to § Park lot.

## 🧪 Exit criteria

- Every Category 1–4 row uses a `/pe-meta-*` entry point and a chain whose agents resolve on disk. (✅ done)
- Row 1.4 and row 1.5 defects corrected. (✅ done)
- Referenced-by and Quick-Verification prose use resolvable `pe-meta-*` names. (✅ done)
- Modernization note replaced; version bumped to 1.2.0 with a 2026-06-25 history row. (✅ done)
- `get_errors` clean on `00.02`; run logged (prepended) in `05.04-meta-review-log.md`. (✅ done)

## 📥 Park lot

- **OD-1 cost/value review of the coverage-gap guard (rule 5).** → `→ defer (own follow-up)`.
  Re-evaluate whether the central capability→implementer map + runtime rule-5 check is the most
  effective non-regression mechanism for the vision, or whether a cheaper/better validation exists.

## 🔎 Actionability Gate result *(readiness)*

1. **Single edit target** — `00.02` (+ log append). ✅
2. **Exact current text captured** — full file read; verbatim strings in hand. ✅
3. **Every target name resolves on disk** — verified (§ Discovery). ✅
4. **No open blocking decision** — OD-1 is explicitly non-blocking. ✅
5. **Governance boundary honored** — re-points entries, removes none; no vision edit. ✅
6. **Reversible** — content edit, version-tracked. ✅
7. **Verification defined** — `get_errors` + re-read tables + run log. ✅
8. **Owner intent captured** — approved Option B; cost question parked (OD-1). ✅

→ **PASS.** Executing.
