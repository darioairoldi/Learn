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

**Source Mapping:**

| Context Pattern | Source Pattern | Source Type |
|-----------------|----------------|-------------|
| `00.00-prompt-engineering/*.md` | `03.00-tech/05.02-prompt-engineering/**/*.md` | Learning Hub articles (23 files) |
| `00.00-prompt-engineering/*.md` | Semantic search: "GitHub Copilot prompt files agents" | GitHub docs |
| `00.00-prompt-engineering/*.md` | Semantic search: "VS Code Copilot customization" | VS Code docs |
| `00.00-prompt-engineering/*.md` | `https://code.visualstudio.com/docs/copilot/*` | Official VS Code |
| `00.00-prompt-engineering/*.md` | `https://github.blog/ai-and-ml/github-copilot/*` | GitHub Blog |

**File Inventory (16 files):**

| # | File | Purpose | Primary Source Articles |
|---|------|---------|------------------------|
| 01 | `01-context-engineering-principles.md` | Core principles: 7 Rules, context types, assembly pipeline | 01-overview, 03.00, 12.00 |
| 02 | `02-tool-composition-guide.md` | Tool calling patterns, cost hierarchy, result sizes, MCP integration | 09.50, 07.00, 13.00 |
| 03 | `03-progressive-disclosure-pattern.md` | Layered complexity: skill loading, progressive context | 06.00, 11.00 |
| 04 | `04-handoffs-pattern.md` | Orchestration handoffs: send/receive flow, strategy selection, reliability | 10.00, 11.00, 12.00 |
| 05 | `05-validation-caching-pattern.md` | Validation cache to skip redundant checks ⚠️ *LearnHub-specific* | IQPilot architecture |
| 06 | `06-adaptive-validation-patterns.md` | Use case challenge, adaptive depth routing ⚠️ *LearnHub-specific* | 10.00, IQPilot |
| 07 | `07-prompt-assembly-architecture.md` | VS Code assembly pipeline: 7 context types, v1.107+ features | 01-overview, 03.00 |
| 08 | `08-context-window-management.md` | Token budgets, MCP flow, prompt-snippets vs instructions, 5 patterns | 12.00, 13.00, 07.00 |
| 09 | `09-token-optimization-strategies.md` | Cache stacking, batch operations, cost impact, context rot | 13.00, 12.00 |
| 10 | `10-model-specific-optimization.md` | GPT/Claude/Gemini provider-specific techniques and constraints | 08.00, 08.01, 08.02, 08.03 |
| 11 | `11-agent-hooks-reference.md` | Agent lifecycle hooks: events, security patterns, configuration | 09.00 |
| 12 | `12-orchestrator-design-patterns.md` | Orchestrator topologies, 4-specialist pattern, use case challenge | 10.00, 11.00 |
| 13 | `13-file-type-decision-guide.md` | Decision flowchart: prompts vs agents vs instructions vs skills vs Spaces vs SDK | 02.00-06.00, 01.01, 14.00 |
| 14 | `14-mcp-server-design-patterns.md` | MCP server lifecycle, 3 primitives, tool anatomy, transport, errors | 07.00 |
| 15 | `15-copilot-spaces-patterns.md` | Copilot Spaces decision framework, content types, combination patterns | 01.01 |
| 16 | `16-copilot-sdk-integration.md` | SDK integration: VS Code vs SDK comparison, YAML differences, MCP, billing | 14.00 |

> **Note on files 05 and 06:** These files contain patterns specific to the IQPilot/LearnHub validation system. They remain in `00.00-prompt-engineering/` because the underlying patterns (caching, adaptive routing) are general prompt engineering concepts, even though their primary implementation is LearnHub-specific.

**Update Strategy:**
- Re-run semantic searches when VS Code or GitHub Copilot releases new versions
- Check `03.00-tech/05.02-prompt-engineering/` for new articles
- Review GitHub blog for new best practices
- Compare article count against file inventory when articles are added

---

### 01.00-article-writing/

**Purpose:** Generic article writing guidelines applicable to any documentation project. Complements (does not duplicate) the auto-loaded `article-writing.instructions.md`.

**Source Mapping:**

| Context Pattern | Source Pattern | Source Type |
|-----------------|----------------|-------------|
| `01.00-article-writing/*.md` | `03.00-tech/40.00-technical-writing/**/*.md` | Learning Hub articles (18 files) |
| `01.00-article-writing/*.md` | `https://learn.microsoft.com/en-us/style-guide/*` | Microsoft Style Guide |
| `01.00-article-writing/*.md` | `https://diataxis.fr/*` | Diátaxis Framework |
| `01.00-article-writing/*.md` | `https://developers.google.com/style/*` | Google Style Guide |
| `01.00-article-writing/*.md` | `.github/instructions/article-writing.instructions.md` | Repository instructions (auto-loaded) |
| `01.00-article-writing/workflows/*.md` | `.github/templates/*.md` | Repository templates |

**File Inventory (5 files):**

| # | File | Purpose | Primary Source Articles |
|---|------|---------|------------------------|
| 01 | `01-style-guide.md` | Quantitative metrics, replacement tables, visual docs, procedure rules | 40.00 articles 01, 08, 09, 11, 12; MWSG 00–04 |
| 02 | `02-validation-criteria.md` | Quality thresholds, 7 validation dimensions, freshness scoring, automated tools | 40.00 articles 05, 06, 07, 09, 10 |
| W1 | `workflows/01-article-creation-workflow.md` | Phase-based creation from concept to publication | 40.00 articles 00–12 |
| W2 | `workflows/02-review-workflow.md` | Review triggers, process, content stability guide | 40.00 articles 05, 10 |
| W3 | `workflows/03-series-planning-workflow.md` | Series lifecycle, patterns, consistency maintenance | 40.00 articles 08, 10 |

> **Note on instruction layering:** These context files provide quantitative targets, reference tables, and workflow sequences that COMPLEMENT the auto-loaded `article-writing.instructions.md` (833 lines). Rules, formatting standards, Diátaxis structures, and voice principles are in the instructions — not duplicated here.

**Update Strategy:**
- Check `03.00-tech/40.00-technical-writing/` for new articles (primary source)
- Check external style guides annually for updates
- Sync with `article-writing.instructions.md` changes (avoid duplication)
- Update workflows when prompt files or template structure changes
- Compare article count against file inventory when articles are added

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
| `06-folder-organization-and-navigation.md` | Repository folder conventions | Internal conventions |
| `06-folder-organization-and-navigation.md` | Quarto glob behavior documentation | Official docs |
| `07-sidebar-menu-rules.md` | `_quarto.yml` sidebar structure | Repository config |
| `07-sidebar-menu-rules.md` | Quarto navigation documentation | Official docs |
| `07-sidebar-menu-rules.md` | `.github/prompts/**/learninghub-*.prompt.md` | Navigation prompts |

**Update Strategy:**
- Update when repository conventions change
- Sync when templates are modified
- Review when new content patterns emerge
- **Update `06-folder-organization-and-navigation.md`** when folder naming conventions change
- **Update `07-sidebar-menu-rules.md`** when sidebar structure or menu generation logic changes

---

## Article-to-Context Reverse Mapping

This table shows which source articles feed which context files in `00.00-prompt-engineering/`. Use it to identify which context files need updating when an article changes.

| Source Article | Context Files |
|---------------|---------------|
| `01-overview/` (series introduction) | 01, 07, 13 |
| `01.01-appendix_copilot_spaces.md` | 15, 13 |
| `02.00-how_to_name_and_organize_prompt_files.md` | 13 |
| `03.00-how_to_structure_content_for_copilot_prompt_files.md` | 01, 07, 13 |
| `04.00-how_to_structure_content_for_copilot_agent_files.md` | 13 |
| `05.00-how_to_structure_content_for_copilot_instruction_files.md` | 13 |
| `06.00-how_to_structure_content_for_copilot_skills.md` | 03, 13 |
| `07.00-how_to_create_mcp_servers_for_copilot.md` | 02, 08, 14 |
| `08.00-how_to_optimize_prompts_for_specific_models.md` | 10 |
| `08.01–08.03 (provider appendices)` | 10 |
| `09.00-how_to_use_agent_hooks_for_lifecycle_automation.md` | 11 |
| `09.50-how_to_leverage_tools_in_prompt_orchestrations.md` | 02 |
| `10.00-how_to_design_orchestrator_prompts.md` | 04, 06, 12 |
| `11.00-how_to_design_subagent_orchestrations.md` | 03, 04, 12 |
| `12.00-how_to_manage_information_flow_during_prompt_orchestrations.md` | 01, 04, 08, 09 |
| `13.00-how_to_optimize_token_consumption_during_prompt_orchestrations.md` | 02, 08, 09 |
| `14.00-how_to_use_prompts_with_the_github_copilot_sdk.md` | 13, 16 |

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

*Last updated: 2026-02-23*  
*Version: 2.0*
