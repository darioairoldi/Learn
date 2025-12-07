# Global GitHub Copilot Instructions for Learning Documentation Site

## Repository Architecture
Personal knowledge management system for Microsoft technical content, session notes, and project documentation.

**Folder Structure:**
- `tech/` - Technical articles and guides
- `events/` - Conference/workshop notes (date-prefixed: YYYYMMDD)
- `projects/` - Project documentation and plans
- `meetings/` - Meeting summaries and transcripts
- `issues/` - Issue tracking and resolution notes
- `00.draft/` - Work in progress
- `01.templates/` - Content templates
- `.github/` - Instructions, prompts, templates, workflows
- `.copilot/` - Context files, scripts, MCP servers

## Critical Pattern: Dual YAML Metadata
**ALL articles use two separate metadata blocks - NEVER confuse them:**

### Top YAML Block (Quarto Metadata)
```yaml
---
title: "Article Title"
author: "Author Name"
date: "2025-12-06"
categories: [tech, azure]
description: "Brief description"
---
```
- **Location:** Beginning of file
- **Purpose:** Quarto rendering and site generation
- **Modified by:** Authors manually ONLY
- **❌ NEVER modify from validation prompts or automation**

### Bottom HTML Comment Block (Validation Metadata)
```markdown
<!-- 
---
validations:
  grammar:
    status: "passed"
    last_run: "2025-12-06T10:30:00Z"
    model: "claude-sonnet-4.5"
article_metadata:
  filename: "article.md"
  last_updated: "2025-12-06T10:00:00Z"
---
-->
```
- **Location:** End of file (after References section)
- **Purpose:** Validation history, quality tracking
- **Modified by:** Validation prompts and content tools
- **Visibility:** Hidden in rendered output
- **✅ Only this block gets updated by automation**

**Critical Rules:**
- ❌ Validation prompts must NEVER touch top YAML
- ✅ Update only your validation section in bottom metadata
- ✅ Check `last_run` timestamp before running validations
- ✅ Skip validation if `last_run < 7 days` AND content unchanged

📖 **Complete parsing guidelines:** `.copilot/context/dual-yaml-helpers.md`

## Validation Workflow
**Six validation prompts in `.github/prompts/`:**
1. `grammar-review.prompt.md` - Grammar and spelling
2. `readability-review.prompt.md` - Reading level and clarity
3. `structure-validation.prompt.md` - Article structure compliance
4. `fact-checking.prompt.md` - Accuracy verification
5. `logic-analysis.prompt.md` - Logical flow and connections
6. `publish-ready.prompt.md` - Final pre-publish checklist

**Validation Caching (7-Day Rule):**
```yaml
# Before running validation, check bottom metadata:
if validations.{type}.last_run < 7 days AND content unchanged:
  skip_validation()
else:
  run_validation()
  update_bottom_metadata()
```

**Update Pattern (Bottom Metadata Only):**
```yaml
validations:
  grammar:  # Update only this section
    status: "passed"
    last_run: "2025-12-06T10:30:00Z"
    model: "claude-sonnet-4.5"
    issues_found: 0
```


## Key Files for Reference
- `.github/copilot-instructions.md` - This file (global AI agent guidance)
- `.github/STRUCTURE-README.md` - Complete repository structure documentation
- `.github/templates/article-template.md` - New article template with both YAML blocks
- `.copilot/context/dual-yaml-helpers.md` - Metadata parsing guidelines
- `.copilot/scripts/validate-metadata.ps1` - PowerShell validation script

## Common Mistakes to Avoid
❌ **DON'T:**
- Modify top YAML from validation prompts
- Skip `last_run` check before validating
- Overwrite entire bottom metadata block (update only your section)
- Create articles without both YAML blocks
- Repeat validations within 7 days if content unchanged

✅ **DO:**
- Read `.copilot/context/dual-yaml-helpers.md` before parsing metadata
- Check bottom metadata `last_run` timestamps
- Update only your validation section in bottom metadata
- Use templates from `.github/templates/`
- Verify facts against official sources
- Link to related articles instead of duplicating content

## Quick Start for New Articles
1. Copy `.github/templates/article-template.md`
2. Fill top YAML with title, author, date
3. Write content following structure requirements
4. Add References section
5. Run validation prompts (they'll add bottom metadata)
6. Verify bottom metadata block exists and is in HTML comment

**Model Preference:** Claude Sonnet 4.5 for complex analysis and generation
