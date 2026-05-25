# G-03 scope fidelity validation prompt

Validate G-03 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Checks:

1. Body behavior matches declared `goal`.
2. Main process steps are within `scope.covers`.
3. No behavior conflicts with `scope.excludes`.
4. No obvious out-of-scope expansion.

Output:

- Case: G-03
- Result: pass|fail|blocked
- Evidence:
- Scope mismatch list (if any)
- Minimal fix plan (if fail)
