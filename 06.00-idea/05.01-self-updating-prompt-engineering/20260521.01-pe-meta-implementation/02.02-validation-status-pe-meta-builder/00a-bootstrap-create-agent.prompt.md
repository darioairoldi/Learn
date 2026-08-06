# Bootstrap prompt - create missing pe-meta-builder agent

You are validating one agent artifact.

Target file:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`

Task:

1. Check whether the target file exists.
2. If it exists, stop and report `already exists`.
3. If it does not exist, create a minimal compliant agent file with:
- valid YAML frontmatter
- required metadata fields (`description`, `version`, `last_updated`, `goal`, `scope`, `boundaries`, `rationales`)
- `agent: agent`
- a tool list suitable for a builder role (read + write)
- explicit Always/Ask/Never boundary sections
- a simple handoff contract section
- response management and test scenarios sections
4. Keep the file concise and structurally valid.
5. Return what was created and a short next-step note: `run G-01 next`.

Do not validate all rules in this run. Bootstrap only.
