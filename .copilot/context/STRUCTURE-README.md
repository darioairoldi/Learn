# Context Library Structure

This document maps the context folder structure to its source materials and explains how context files are generated and maintained.

## Purpose

Context files in `.copilot/context/` provide **shared reference documents** that prompts, agents, and instruction files reference. They serve as the single source of truth for principles, patterns, and conventions.

**📖 Context file creation guidelines:** [context-files.instructions.md](../../.github/instructions/context-files.instructions.md)

---

## Folder Structure and Source Mapping

Context folders use **numbered prefixes** for priority ordering. Lower numbers load first and establish foundational context.

This mapping defines **how to find source material** for creating or updating context files—not a static list of what was used at creation time.

### 00.00-prompt-engineering/

**Purpose:** Prompt and agent design patterns, core principles for GitHub Copilot customization.

| Context Pattern | Source Pattern | Source Type |
|-----------------|----------------|-------------|
| `00.00-prompt-engineering/*.md` | `03.00-tech/05.02-promptEngineering/**/*.md` | Learning Hub articles |
| `00.00-prompt-engineering/*.md` | Semantic search: "GitHub Copilot prompt files agents" | GitHub docs |
| `00.00-prompt-engineering/*.md` | Semantic search: "VS Code Copilot customization" | VS Code docs |
| `00.00-prompt-engineering/*.md` | `https://code.visualstudio.com/docs/copilot/*` | Official VS Code |
| `00.00-prompt-engineering/*.md` | `https://github.blog/ai-and-ml/github-copilot/*` | GitHub Blog |
| `01-context-engineering-principles.md` | Semantic search: "GitHub Copilot context engineering principles" | Microsoft/GitHub docs |

**Update Strategy:**
- Re-run semantic searches when VS Code or GitHub Copilot releases new versions
- Check `03.00-tech/05.02-promptEngineering/` for new articles
- Review GitHub blog for new best practices

---

### 01.00-article-writing/

**Purpose:** Generic article writing guidelines applicable to any documentation project.

| Context Pattern | Source Pattern | Source Type |
|-----------------|----------------|-------------|
| `01.00-article-writing/*.md` | `https://learn.microsoft.com/en-us/style-guide/*` | Microsoft Style Guide |
| `01.00-article-writing/*.md` | `https://diataxis.fr/*` | Diátaxis Framework |
| `01.00-article-writing/*.md` | `https://developers.google.com/style/*` | Google Style Guide |
| `01.00-article-writing/*.md` | `.github/instructions/article-writing.instructions.md` | Repository instructions |
| `01.00-article-writing/workflows/*.md` | `.github/templates/*.md` | Repository templates |

**Update Strategy:**
- Check style guides annually for updates
- Sync with instruction file changes
- Update workflows when template structure changes

---

### 90.00-learning-hub/

**Purpose:** Repository-specific conventions and patterns unique to this LearnHub documentation site.

| Context Pattern | Source Pattern | Source Type |
|-----------------|----------------|-------------|
| `90.00-learning-hub/*.md` | `.github/copilot-instructions.md` | Repository global instructions |
| `90.00-learning-hub/*.md` | `.github/templates/*.md` | Repository templates |
| `90.00-learning-hub/*.md` | Repository conventions (observed patterns) | Internal conventions |
| `02-dual-yaml-metadata.md` | Quarto documentation + repository architecture | Mixed |
| `04-reference-classification.md` | `.github/instructions/documentation.instructions.md` | Repository instructions |
| `06-folder-organization-and-navigation.md` | `_quarto.yml` sidebar structure | Repository config |
| `06-folder-organization-and-navigation.md` | Quarto glob behavior documentation | Official docs |
| `06-folder-organization-and-navigation.md` | `.github/prompts/**/learninghub-*.prompt.md` | Navigation prompts |

**Update Strategy:**
- Update when repository conventions change
- Sync when templates are modified
- Review when new content patterns emerge
- **Update `06-folder-organization-and-navigation.md`** when sidebar structure changes or Quarto behavior changes

---

## Context File Generation

### When to Create New Context

Create a new context file when:
- ✅ Same content appears in 3+ prompts/agents/instructions
- ✅ Concept is complex enough to need dedicated documentation
- ✅ Multiple files need to reference the same guidance

### Generation Workflow

1. **Identify source material** — Articles, external docs, repository patterns
2. **Extract key principles** — MUST/SHOULD/NEVER rules
3. **Check for duplicates** — Avoid overlap with existing context files
4. **Create with proper structure** — Purpose, Referenced by, Core content, References
5. **Add folder mapping** — Update this file with source references

**📖 Use prompt:** `prompt-createorupdate-context-information.prompt.md`

---

## Folder Numbering Convention

| Range | Purpose | Examples |
|-------|---------|----------|
| `00.xx` | Core infrastructure (prompts, agents, tools) | `00.00-prompt-engineering/` |
| `01.xx - 79.xx` | Domain-specific content | `01.00-article-writing/` |
| `80.xx - 89.xx` | Reserved for future use | — |
| `90.xx - 99.xx` | Repository-specific (non-portable) | `90.00-learning-hub/` |

---

## Cross-Reference Guidelines

### From Prompts/Agents to Context

```markdown
**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)
```

### From Context to Context

```markdown
**📖 Related guidance:** [tool-composition-guide.md](./02-tool-composition-guide.md)
```

### From Instructions to Context

```markdown
**📖 See:** `.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md`
```

---

## Maintenance

### Keeping Sources in Sync

When source material changes:
1. Review context file for needed updates
2. Update version history in context file
3. Update source mapping in this README
4. Verify referencing files still work

### Adding New Folders

When creating a new context folder:
1. Choose appropriate number range (see convention above)
2. Add folder mapping section to this README
3. Document primary sources
4. Create initial context files following structure

---

## References

- **📖 Context file guidelines:** `.github/instructions/context-files.instructions.md`
- **📖 Context creation prompt:** `.github/prompts/00.00-prompt-engineering/prompt-createorupdate-context-information.prompt.md`
- **📖 Source articles:** `03.00-tech/05.02-promptEngineering/`

---

*Last updated: 2026-01-24*  
*Version: 1.0*
