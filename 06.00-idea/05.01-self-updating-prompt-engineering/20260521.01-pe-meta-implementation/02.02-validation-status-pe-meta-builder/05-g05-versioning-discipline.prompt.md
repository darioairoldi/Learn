# G-05 versioning discipline validation prompt

Validate G-05 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Checks:

1. `version` exists and is valid SemVer-like format.
2. `last_updated` exists and is a valid date string.
3. Version/update metadata is internally coherent with recent edits.

Output:

- Case: G-05
- Result: pass|fail|blocked
- Evidence:
- Version/date issues (if any)
- Minimal fix plan (if fail)
