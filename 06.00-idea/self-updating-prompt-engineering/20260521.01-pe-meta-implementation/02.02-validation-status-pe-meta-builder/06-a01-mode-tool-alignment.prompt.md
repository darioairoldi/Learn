# A-01 agent mode and tool alignment validation prompt

Validate A-01 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Checks:

1. Agent mode is declared (`plan` or `agent`).
2. Tool list aligns with mode:
- `plan` -> read-only toolset
- `agent` -> may include write tools
3. Tool list is not self-contradictory.
4. Tool count is reasonable for role complexity.

Output:

- Case: A-01
- Result: pass|fail|blocked
- Evidence:
- Misalignment list (if any)
- Minimal fix plan (if fail)
