# A-01 agent mode/tool alignment validation prompt

Validate A-01 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-validator.agent.md`

Checks:

1. Evaluate only this case and avoid running other cases.
2. Enforce the exact requirement implied by: `A-01 agent mode/tool alignment`.
3. Ensure the check is specific to artifact type `agent`.
4. Return concrete, file-grounded evidence (quotes or section references).
5. If failed, include the smallest possible fix plan.

Output:

- Case: A-01
- Result: pass|fail|blocked
- Evidence:
- Minimal fix plan (if fail)
