# G-02 reference integrity validation prompt

Validate G-02 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Checks:

1. Markdown links resolve (local links and anchors).
2. Referenced local files exist.
3. Mentioned handoff targets (agents/prompts/templates) exist when declared as concrete paths.
4. No obviously stale path patterns (renamed files, wrong relative level).

Output:

- Case: G-02
- Result: pass|fail|blocked
- Evidence:
- Broken references list (if any)
- Minimal fix plan (if fail)
