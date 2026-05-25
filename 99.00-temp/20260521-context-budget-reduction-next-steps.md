# Context budget reduction next steps (2026-05-21)

Target scope: `.copilot/context/00.00-prompt-engineering/`

Oversized files identified:
- `05.01-artifact-dependency-map.md` (~4,156 estimated tokens; 426 lines)
- `STRUCTURE-README.md` (~3,963 estimated tokens)

Execution plan:
1. Split dependency-map content into one index file plus generated per-layer appendices.
2. Keep `05.01-artifact-dependency-map.md` as the stable entry point with concise summary tables and links.
3. Move long dependency tables into appendices under `.copilot/context/00.00-prompt-engineering/dependency-map/`.
4. Split `STRUCTURE-README.md` into:
- `STRUCTURE-README.md` (navigation, contracts, quick rules)
- `STRUCTURE-CATEGORIES.md` (full category catalog)
- `STRUCTURE-MAINTENANCE.md` (procedures and change workflow)
5. Update all local links and run deterministic broken-link checks after the split.
6. Re-run token-budget audit and stop only when every context file is <= 2,500 estimated tokens and <= 375 lines.

Acceptance criteria:
- No broken local links in context files and sampled consumers.
- All split files have required metadata fields (`goal`, `scope`, `boundaries`, `version`, `last_updated`).
- Budget compliance achieved for both previously oversized files.
