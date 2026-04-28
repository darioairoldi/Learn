---
description: Shared PE artifact rules — context engineering, tool selection, validation caching, production readiness, uncertainty management
applyTo: '.github/prompts/**/*.md,.github/agents/**/*.agent.md'
version: "1.5.0"
last_updated: "2026-03-19"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# PE Common Instructions

Shared rules for all prompt and agent files. Type-specific rules remain in `prompts.instructions.md` and `agents.instructions.md`.

## Severity Index

**CRITICAL** — block on failure:
- **[C1]** Tool alignment: `plan` = read-only; `agent` = read+write. NEVER mix.
- **[C3]** Token budget compliance per artifact type
- **[C5]** No circular dependencies (context → instructions → agents → prompts)
- **[C7]** ❌ NEVER modify top YAML from validation prompts. ✅ Update bottom metadata only.

**HIGH** — fix before use:
- **[H2]** Tool count: 3–7 per artifact; >7 = decompose
- **[H4]** Response management: data gap scenarios MUST be defined. 📖 See `04.03-production-readiness-patterns.md` for implementation patterns.
- **[H5]** Error recovery: fallback behavior for tool failures MUST be defined. 📖 See `04.03-production-readiness-patterns.md` for implementation patterns.
- **[H6]** Embedded test scenarios (3–5 per prompt, 3 per agent)
- **[H7]** Narrow scope: one primary goal per artifact
- **[H8]** Imperative language: MUST/NEVER/ALWAYS
- **[H12]** Cross-reference integrity: all `📖` links resolve
- **[H13]** Full-filename references: `📖` refs MUST use the full filename (e.g., `📖 \`02.04-agent-shared-patterns.md\``), NEVER bare numeric prefixes (e.g., `📖 \`02.04\``). Prefixes are fragile — files can be renamed or renumbered.

**MEDIUM** — fix when convenient:
- **[M1]** Template externalization: inline blocks >10 lines → template
- **[M2]** Early commands: critical instructions in first 30%
- **[M4]** Group `📖` references preferred over individual file refs

**📖 Full priority matrix:** see `validation-rules` in `.copilot/context/00.00-prompt-engineering/` (STRUCTURE-README.md → Functional Categories)

## Context Engineering Principles

All PE artifacts MUST follow these context engineering principles: narrow scope, early commands, imperative language, template externalization (>10 lines → template), context minimization, uncertainty management, reference-based architecture. Agents additionally require three-tier boundaries (see `agents.instructions.md`).

**📖 Complete guidance:** [01.01-context-engineering-principles.md](.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md)

## Production Readiness

Every PE artifact MUST implement: response management, error recovery, embedded test scenarios (3–5), token budget compliance, context rot prevention, template externalization.

**📖** Full requirements: [04.03-production-readiness-patterns.md](.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md)

## Quality Checklist

- [ ] Tool alignment matches agent mode (C1)
- [ ] Token budget within type-specific limit (C3)
- [ ] No circular dependencies (C5)
- [ ] Response management and "I don't know" scenarios defined (H4)
- [ ] 3–5 embedded test scenarios (H6)
- [ ] All `📖` references resolve (H12)

## References

- **📖** Context engineering principles: see `validation-rules` in `.copilot/context/00.00-prompt-engineering/` (STRUCTURE-README.md → Functional Categories)
- **📖** [01.04-tool-composition-guide.md](.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) — Tool categories, costs
- **📖** [04.01-validation-caching-pattern.md](.copilot/context/00.00-prompt-engineering/04.01-validation-caching-pattern.md) — Validation caching
- **📖** [04.03-production-readiness-patterns.md](.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md) — Production readiness
- **📖** `.github/templates/` — 26+ reusable templates
