# UC-32: Portability boundary scan

> **Group:** 05-reliability
> **Priority:** P2
> **Order in group:** 10
> **Vision anchor:** R11 — Boundary: "Artifacts MUST use a namespace prefix… generic names are not portable"

## 🎯 Purpose

Verify the **portability boundary** is held: every PE-meta artifact carries the `pe-` (or designated namespace) prefix on its public identifier (filename, agent name, prompt command, skill name). A drift here is a portability defect that breaks once the engine is delivered via the standard packaging mechanisms (MCP, SDK, extensions — R-S7-portable-packaging) into hosts where naming collisions matter.

## ⚙️ Invocation

**Command family:** Review
**Primary entry point:** `/pe-meta-review --dim reliability --mode plan`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages portability-boundary scan (`D35-portability-boundary`) |
| `--scope <type\|path>` | Narrow to a specific artifact type or folder |
| `--mode plan` | Default — proposes renames; rename is a breaking change and is human-only |

## 🔬 Behavior

1. **Inventory.** Enumerate all PE-meta artifacts:
   - `.github/prompts/00.09-pe-meta/*.md`
   - `.github/agents/00.*pe-meta*/*.agent.md`
   - `.github/skills/pe-*/SKILL.md`
   - `.copilot/context/00.00-prompt-engineering/**`
2. **Public-identifier extraction.** Per artifact:
   - Filename
   - YAML `name:` field
   - Slash-command (for prompts: `/<command>`)
   - Skill ID (for skills: top-level skill name)
3. **Prefix check.** Verify each public identifier starts with the declared namespace prefix (default: `pe-`).
4. **Severity:**
   - Public identifier missing prefix → **HIGH** (portability defect; rename is breaking)
   - Filename missing prefix but YAML `name:` correct → **MEDIUM** (cosmetic; rename advised at next major)
   - Internal-only identifier missing prefix → **INFO**
5. **Output.** Defect list with proposed renames AND the dependency impact (file moves, references to update). Because rename is breaking, this UC always outputs `--mode plan`; the actual rename is a human-approved Update flow.

## 📐 Dimensions covered

`D35-portability-boundary` — primary.

## 🚦 Reliability analysis

The vision treats portability as a *boundary*, not a *preference*. Generic names work today only because there are no host clashes — at the moment the engine is delivered into a richer host environment, every unprefixed identifier becomes a runtime collision. This UC catches drift before that delivery event.

This UC's findings are also a strong signal for R-S7-portable-packaging readiness — full PASS is a prerequisite for declaring the engine "package-ready."

## 💰 Cost & efficiency

Pure filesystem + YAML scan — near-zero cost. Should run on every scheduled review cycle (the cost is trivial, and the defect class is silent until the breaking moment).

## 🔗 Related use cases

- [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) — both depend on YAML metadata integrity
- [p2-04-mode-vs-risk-decoupling-check](p2-04-mode-vs-risk-decoupling-check-usecase.md) — both audit invariants declared in the vision's option model
