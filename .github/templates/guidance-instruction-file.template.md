# Instruction File Template for Domain Guidance

Use this structure when generating new instruction files:

```markdown
---
description: "{Domain} instructions for GitHub Copilot prompts and agents"
applyTo: '{glob-pattern}'
---

# {Domain} Instructions

## Purpose
[One paragraph explaining what prompts/agents using this guidance should accomplish]

## Scope
**IN SCOPE:** [What this guidance covers]
**OUT OF SCOPE:** [What this guidance does NOT cover]

## Core Principles
[Domain-specific principles extracted from user context, written in MUST/WILL/NEVER language]

### Required Elements
[What MUST be included in outputs]

### Quality Criteria
[How to measure success]

### Anti-Patterns
[What to NEVER do]

## Three-Tier Boundaries
### ✅ Always Do (No Approval Needed)
[Actions prompts/agents can take without asking]

### ⚠️ Ask First (Require Confirmation)
[Actions that require user approval]

### 🚫 Never Do
[Prohibited actions]

## Context References
**📖 Complete guidance:** `.copilot/context/{domain}/*.md`
[Summary of what each context file provides]

## Best Practices
[5-7 actionable items specific to this domain]

## References
[Source links: user-provided URLs, official docs, repository patterns]
```
