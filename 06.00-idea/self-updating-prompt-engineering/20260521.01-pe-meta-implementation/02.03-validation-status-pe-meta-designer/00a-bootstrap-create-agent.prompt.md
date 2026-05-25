# Bootstrap prompt - create missing agent

You are validating one agent artifact.

Target file:
`C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-designer.agent.md`

Task:

1. Check whether the target file exists.
2. If it exists, stop and report `already exists`.
3. If it does not exist, create a minimal compliant agent file with:
- valid YAML frontmatter
- required metadata fields (`description`, `version`, `last_updated`, `goal`, `scope`, `boundaries`, `rationales`)
- the correct file type marker for agent artifacts
- explicit Always/Ask/Never boundary sections (if applicable)
- concise structure aligned with repository conventions
4. Keep the file concise and structurally valid.
5. Return what was created and a short next-step note: `run G-01 next`.

Do not validate all rules in this run. Bootstrap only.
