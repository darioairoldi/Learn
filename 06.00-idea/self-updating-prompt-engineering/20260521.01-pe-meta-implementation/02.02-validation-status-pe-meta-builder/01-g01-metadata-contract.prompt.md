# G-01 metadata contract validation prompt

Validate G-01 for this file only:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Checks:

1. File exists.
2. YAML frontmatter is present and parseable.
3. Required fields exist and are non-empty:
- `description`
- `version`
- `last_updated`
- `goal`
- `scope`
- `boundaries`
- `rationales`
4. `version` is SemVer-like (`N.N.N`).

Output:

- Case: G-01
- Result: pass|fail|blocked
- Evidence:
- Missing fields (if any)
- Minimal fix plan (if fail)
