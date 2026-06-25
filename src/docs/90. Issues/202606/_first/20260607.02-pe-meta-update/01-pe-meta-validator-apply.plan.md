---
status: done
target_vision_version: v15.4.0
domain: prompt-engineering
created: 2026-06-11
goal: "Apply the single body-level finding from /pe-meta-update on pe-meta-validator.agent.md (--mode apply --deps full): repair the merged D14-craftsmanship heading at L85."
---

# Plan — pe-meta-validator apply (validator-apply-20260611)

**Resolved invocation:** `--mode=apply --scope=.github/agents/00.09-pe-meta/pe-meta-validator.agent.md --source=(all) --dim=full --start=none --end=none --deps=full --skip=(none) | breadth=full | caller=manual | bundle=single-domain`

**Execution mode:** fresh (no baseline plan for this scope; research ran on internal distilled context). `--deps all` normalized to `--deps full` at Phase 0a.

## Goal table

| # | Finding | Dim | Severity | Scope tag | Principle impact | Downstream landing | Edit | Status |
|---|---|---|---|---|---|---|---|---|
| 1 | H2 heading `## Knowledge Loading Contract` is merged with its body sentence `Load from …` on one line (L85), rendering a broken heading | `D14-craftsmanship` | LOW | in-scope | none (cosmetic/structural; no rule or capability change) | none (read-only validator; no consumers depend on this heading text) | Split L85 into `## Knowledge Loading Contract` + blank line + `Load from \`.copilot/context/00.00-prompt-engineering/\` by category:` | (✅ done) |

## Park lot

- **Cohort-wide observation (NOT a validator finding, not actioned):** none of the 5 pe-meta agents declare a frontmatter `model:` field, while the orchestrator's model-routing seam says routing is "realized via each delegated meta-agent's own `model:` field." This is cohort-uniform, so it is out of scope for a single-file validator run; surface for a future `--scope agents` sweep if model routing must be explicit per agent.

## Exit criteria

- [x] L85 heading split; `get_errors` clean on the file.
- [x] `version:` bumped 2.3.0 → 2.3.1 (frontmatter AND bottom block in sync), `last_updated` → 2026-06-11, changelog entry added.
- [x] Phase 7b version-sync check passes (frontmatter == bottom).
- [x] Phase 7d independent coverage audit reconciles (no anchor violations).
