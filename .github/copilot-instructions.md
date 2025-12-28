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

## Key Files for Reference
- `.github/copilot-instructions.md` - This file (global AI agent guidance)
- `.github/STRUCTURE-README.md` - Complete repository structure documentation
- `.github/templates/article-template.md` - New article template with both YAML blocks
- `.copilot/context/dual-yaml-helpers.md` - Metadata parsing guidelines
- `.copilot/scripts/validate-metadata.ps1` - PowerShell validation script

**Model Preference:** Claude Sonnet 4.5 for complex analysis and generation
