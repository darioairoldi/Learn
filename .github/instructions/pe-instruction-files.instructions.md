---
description: Rules for creating and maintaining instruction files that provide path-specific AI guidance via applyTo patterns
applyTo: '.github/instructions/*.instructions.md'
version: "1.7.0"
last_updated: "2026-05-21"
goal: "Enforce that instruction files provide path-specific enforcement rules with unique, non-overlapping applyTo scopes"
rationales:
  - "Overlapping applyTo patterns cause unpredictable rule precedence"
  - "A single designated shared-baseline instruction file may overlap multiple artifact types when its precedence and scope are explicit"
  - "Instructions must contain enforcement rules, not knowledge (which belongs in context files)"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# Instruction File Rules

## Purpose

Instruction files provide **path-specific AI guidance** auto-injected via `applyTo` glob patterns. They contain enforcement rules — not knowledge or embeddable content. Each file MUST have a unique, non-overlapping `applyTo` scope, except for a single explicitly designated shared-baseline instruction file.

## Severity Index

**CRITICAL** — block on failure:
- **[C3]** Token budget: instruction files ≤1,500 tokens
- **[C6]** YAML frontmatter: all required fields present and valid

**HIGH** — fix before use:
- **[H8]** Imperative language: MUST/NEVER/ALWAYS — no suggestions
- **[H9]** Required sections: H1 title, Purpose, at least one Rules section
- **[H10]** `applyTo` conflict-free: no overlap with other instruction files, except an explicitly designated shared-baseline file

**MEDIUM** — fix when convenient:
- **[M1]** Template externalization: no knowledge blocks >10 lines
- **[M6]** Naming: kebab-case `{domain}.instructions.md`

**📖 Full priority matrix:** see `validation-rules` in `.copilot/context/00.00-prompt-engineering/` (00.00-context-structure-index.md → Functional Categories)

## Required YAML Frontmatter

```yaml
---
description: "One-sentence description of what these instructions enforce"
applyTo: '{glob pattern targeting specific file types}'
version: "1.0.0"
last_updated: "YYYY-MM-DD"
domain: "prompt-engineering"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---
```

| Field | Required | Criteria |
|-------|----------|----------|
| `description` | ✅ MUST | Non-empty, one sentence, describes the rules enforced |
| `applyTo` | ✅ MUST | Valid glob pattern matching ONLY the intended file types |
| `version` | ✅ MUST | Semantic version (`major.minor.patch`). Increment on every change. |
| `last_updated` | ✅ MUST | ISO date (`YYYY-MM-DD`). Update on every change. Enables staleness detection. |
| `domain` | ✅ MUST | Single scalar identifying the semantic domain the instructions target (e.g. `"prompt-engineering"`, `"article-writing"`). 📖 See `00.03-metadata-contracts.md` § `domain:` field semantics. |
| `context_dependencies` | ✅ MUST | Folder paths of referenced context files. Enables cascade staleness detection. Required for ALL instruction files that reference context files via `📖`. |

### Shared-Baseline Exception

One instruction file MAY intentionally overlap multiple artifact-type instruction files when ALL of the following are true:

- It is explicitly described as the **shared baseline** for those artifact types
- It contains only cross-artifact rules that apply equally across those artifact types
- It documents precedence: type-specific instruction files override the shared baseline on conflicts
- Consuming instruction files reference it as the shared baseline
- No second overlapping shared-baseline file exists

### Cascade Validation Rule

When ANY context file in a listed `context_dependencies` folder has a `last_updated` newer than the instruction file's `last_updated`, the instruction file MUST be re-validated within 7 days.

## Rules

- MUST be placed in `.github/instructions/` root — **no subfolders**
- MUST use imperative language: **MUST**, **WILL**, **NEVER**, **ALWAYS**
- MUST stay within **1,500-token budget**
- MUST NOT embed knowledge blocks >10 lines — reference context files via `📖`
- MUST NOT duplicate rules from other instruction/context files
- `applyTo` MUST NOT overlap with other instruction files — verify before committing
- The only allowed overlap is a single documented shared-baseline instruction file meeting the exception criteria above
- **Rules** (MUST/MUST NOT) → instruction files. **Knowledge** (why/how) → context files.
- MUST be aware that VS Code also discovers instructions from `.claude/rules` (uses `paths` instead of `applyTo`) and configurable locations via `chat.instructionsFilesLocations` setting — verify no conflicts with these alternate paths

## Quality Checklist

- [ ] YAML: all required fields present and valid (C6)
- [ ] Token budget ≤1,500 (C3)
- [ ] `applyTo` verified conflict-free, or documented as the single shared-baseline exception (H10)
- [ ] Imperative language throughout (H8)
- [ ] No knowledge blocks >10 lines (M1)
- [ ] References section with `📖` markers
- [ ] `context_dependencies` covers all `📖` context folder references

## References

- **📖** Context engineering: see `validation-rules` in `.copilot/context/00.00-prompt-engineering/` (00.00-context-structure-index.md → Functional Categories)
- **📖** File type decisions: see `file-type-guide` in `.copilot/context/00.00-prompt-engineering/` (00.00-context-structure-index.md → Functional Categories)
- **📖** Token budgets: see `token-optimization` in `.copilot/context/00.00-prompt-engineering/` (00.00-context-structure-index.md → Functional Categories)
