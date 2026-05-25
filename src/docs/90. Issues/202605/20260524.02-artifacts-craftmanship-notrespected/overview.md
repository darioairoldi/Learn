# Issue: YAML metadata serves validation tooling but lacks runtime grounding

> **Status:** Analysis complete — fix plan ready  
> **Severity:** HIGH — systemic gap across all PE artifacts  
> **Date:** 2026-05-24

---

## The gap

The PE system's metadata contracts (`00.03-metadata-contracts.md`) define `goal:`, `scope:`, and `boundaries:` as YAML frontmatter fields on every artifact. These fields enable:

- ✅ Deterministic breaking/non-breaking change classification (pre-change guard)
- ✅ Handoff reliability checksums (inter-agent scope preservation)
- ✅ Drift detection during pe-meta validation

But they **do NOT** ensure the executing model respects those constraints at runtime.

When Copilot processes a prompt or agent, it receives the full file (YAML + body). The model *can* read the YAML, but:

1. No instruction tells it to enforce its declared boundaries during execution
2. No body pattern explicitly references YAML metadata for self-constraint
3. No global rule bridges "metadata exists" → "metadata is enforced at runtime"

---

## Why this matters

| Risk | Example |
|---|---|
| **Silent scope creep** | A prompt with `scope.excludes: ["Domain agents"]` has no body-level rejection mechanism |
| **Boundary drift** | YAML says "MUST always check tool alignment" but process steps may skip it |
| **Autonomy confidence** | Can't machine-verify "does the model respect its scope?" without explicit grounding |
| **Metadata investment waste** | goal/scope/boundaries are defined but only consumed during modification, not execution |

---

## Root cause analysis

The metadata contracts define a **single audience**: pe-meta validation tooling. The design implicitly assumes the model will "naturally" respect YAML fields it can see. This assumption fails because:

1. LLMs prioritize body instructions over frontmatter unless told otherwise
2. YAML fields have no imperative force — they're declarative, not instructional
3. The body contains operational workflow steps that compete for attention

The system needs **dual-purpose metadata**: validation-time AND runtime.

---

## Affected layers (3 workstreams)

| # | Layer | File | Change needed |
|---|---|---|---|
| 1 | Vision | `20260523.01-vision.v13.md` | Acknowledge dual-purpose metadata (tooling + runtime) |
| 2 | Metadata contracts | `00.03-metadata-contracts.md` | Add "Runtime grounding protocol" alongside existing "Metadata-guarded change protocol" |
| 3 | Instruction baseline | `pe-common.instructions.md` | Add runtime grounding rule requiring body-level enforcement |

---

## Design decision: body pattern (not duplication)

The fix is NOT to duplicate goal/scope/boundaries in the body. The fix is to add a **grounding instruction** that tells the model to reference its own YAML during execution.

**Pattern:** A brief body section (or inline instruction) that says:
- "Before proceeding, verify request falls within declared `scope.covers`"
- "Reject requests matching `scope.excludes`"
- "Enforce all `boundaries:` constraints throughout execution"

This keeps YAML as single source of truth while bridging the gap to runtime enforcement.

---

## Plan files

1. [01.01 — Vision update plan](01.01-pe-meta-improvemnt-visionupdate-plan.md)
2. [01.02 — Metadata contracts update plan](01.02-pe-meta-improvemnt-metadatacontractsupdate-plan.md)
3. [01.03 — pe-common instructions update plan](01.03-pe-meta-improvemnt-pecommonupdate-plan.md)
