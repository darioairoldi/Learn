# UC-02 guidance quality hardening rerun for 01.07 (D9/D11 focus)

## Scope

- Invocation target: /pe-meta-context-review 01.07-critical-rules-priority-matrix.md --dim quality
- Edited file: .copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md
- Date: 2026-05-21

## Hardening applied

- Clarified C7 scope to remove cross-file ambiguity:
  - "For article Markdown files only..."
- Tightened actionability in HIGH checks:
  - H4 now requires all three explicit data-gap elements
  - H5 now requires explicit fallback per critical tool failure mode in scope
  - H7 now requires exactly one primary goal and scope alignment
  - H8 now includes an explicit weak-phrasing denylist
  - H11 now requires one declared role with no mixed-role mandate

## Deterministic verification snapshot

- Version updated to 1.2.4 in frontmatter and version history.
- Local links in 01.07: pass (BROKEN_LINKS_01_07=0)
- Recursive context links: pass (BROKEN_LINKS_RECURSIVE_COUNT=0)
- Recursive context budget: pass (OVER_BUDGET_RECURSIVE_COUNT=0)

## Notes

- This rerun captures deterministic hardening evidence for D9/D11-oriented checks.
- If needed, run the full command pipeline in chat mode to refresh formal dimension scoring labels.

## Sources

- .copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md
- .copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md
- .copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md
- .copilot/context/00.00-prompt-engineering/04.01-validation-caching-pattern.md
