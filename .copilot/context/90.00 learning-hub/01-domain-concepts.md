# Domain Concepts for Learning Documentation Site

This document defines core concepts, principles, and terminology used throughout this learning and documentation repository.

## Repository Purpose

This is a **personal learning and development documentation site** focused on:
- Technical skill development
- Knowledge capture and retention
- Best practices documentation and development
- Idea exploration and development

## Core Concepts

### Content Types

**Articles**: Deep-dive explanatory content covering concepts, technologies, or methodologies  
**HowTo Guides**: Step-by-step procedural instructions to accomplish specific tasks  
**Tutorials**: Hands-on learning experiences with progressive complexity  
**Summaries**: Condensed information from recordings, presentations, or research  
**Analyses**: Critical evaluation and deep examination of topics
**Session Analyses**: Critical evaluation and deep examination of a session's content or outcomes

### Quality Dimensions

**Accuracy**: Information is factually correct and verified against authoritative sources  
**Currency**: Content is up-to-date with latest versions, standards, and best practices  
**Clarity**: Ideas are expressed clearly for the target audience  
**Completeness**: Coverage is comprehensive without unnecessary gaps  
**Consistency**: Terminology, style, and structure are uniform across content

### Validation Framework

**Grammar Validation**: Spelling, grammar, punctuation correctness  
**Readability Validation**: Appropriate complexity level, flow, and structure  
**Structure Validation**: Required sections present, proper formatting, template compliance  
**Logic Validation**: Ideas flow logically, concepts properly connected  
**Fact-Checking**: Claims verified against authoritative sources  
**Gap Analysis**: Missing information identified  
**Understandability**: Content appropriate for target audience  

### Metadata System

**Article Metadata**: Core information about content (title, author, dates, status)  
**Validation History**: Records of quality checks with timestamps and outcomes  
**Cross-References**: Links between related content pieces  
**Analytics**: Metrics about content (word count, reading time, engagement)  

### Content Lifecycle

```
Draft → In-Review → Published → [Updates/Revisions] → Archived
```

**Draft**: Initial creation, not yet validated  
**In-Review**: Validations in progress, being refined  
**Published**: Approved, validated, available to readers  
**Archived**: Outdated or superseded but kept for reference  

### Learning Paths

**Prerequisites**: Foundational knowledge needed before a topic  
**Core Content**: Main learning material  
**Advanced Topics**: Next-level concepts building on foundations  
**Related Topics**: Parallel subjects at similar complexity

### Automation Philosophy

**Validation Caching**: Avoid redundant AI validations when content unchanged  
**Prompt-Driven**: Use reusable prompts for consistent automation  
**Template-Based**: Enforce structure through templates  
**Metadata-Tracked**: Record all operations and outcomes  

## Content Organization

### File Naming Convention

**Always use kebab-case** (lowercase with hyphens) for article filenames:

```
✅ Good: configure-azure-key-vault.md
✅ Good: how-to-setup-mcp-server.md
✅ Good: 20251224-vscode-release-notes.md

❌ Bad: Configure Azure Key Vault.md
❌ Bad: HowTo_Setup_MCP_Server.md
❌ Bad: configureAzureKeyVault.md
```

**Rationale**: When Quarto compiles Markdown to HTML, the filename becomes the URL path. Kebab-case produces readable, SEO-friendly URLs:

- `docs/configure-azure-key-vault.html` → Clean and scannable
- `docs/Configure%20Azure%20Key%20Vault.html` → URL-encoded spaces are ugly

**Rules**:
- Use lowercase letters only
- Replace spaces with hyphens (`-`)
- Avoid underscores, camelCase, or PascalCase
- Date prefixes use format `YYYYMMDD-` (no spaces)
- Keep names concise but descriptive

### Folder Structure

- **Subject Folders** (`tech/`, `howto/`, `projects/`): Organized by topic domain  
- **Series**: Related articles grouped under common theme  
- **Cross-Cutting**: Topics that span multiple domains  

### Navigation Patterns

- Table of contents in long articles
- Series navigation (prev/next)
- Prerequisite links
- Related topic suggestions
- External reference links

## Audience Considerations

### Skill Levels

**Beginner**: New to the topic, needs fundamentals
**Intermediate**: Has basics, building deeper understanding
**Advanced**: Experienced, seeking optimization or edge cases

### Reading Goals

- **Learning**: Acquiring new knowledge or skills
- **Reference**: Looking up specific information
- **Troubleshooting**: Solving a specific problem
- **Exploration**: Discovering new topics

## Quality Standards

### Citation Requirements

- All factual claims must have authoritative sources
- References section required if sources cited
- External links must be to credible, maintained resources
- Version information specified for technology documentation

### Code Standards

- Code examples must be tested and functional
- Syntax highlighting specified
- Comments explain non-obvious logic
- Examples show realistic usage
- Error handling included where relevant

### Accessibility Standards

- Semantic Markdown structure
- Descriptive link text
- Alt text for images
- Proper heading hierarchy
- Clear, concise language

## Continuous Improvement

### Review Cycles

- Grammar/readability: Re-validate if content changes
- Facts: Re-verify quarterly or when technologies update
- Structure: Check with template updates
- Gaps: Revisit when related content added

### Deprecation Strategy

- Mark outdated content clearly
- Provide replacement links
- Keep archived for historical reference
- Update cross-references

## Tools and Automation

### Prompt Files

Located in `.github/prompts/`, these automate common tasks:
- Content creation
- Quality validation
- Gap analysis
- Metadata management

### Templates

Located in `.github/templates/`, these enforce structure:
- Article templates
- HowTo templates
- Tutorial templates
- Metadata schemas

### Scripts

Located in `.copilot/scripts/`, these handle programmatic tasks:
- Metadata validation
- Stale content detection
- Series index generation
- Citation extraction

## Success Metrics

### Content Quality

- Validation pass rates
- Source verification coverage
- Template compliance
- Readability scores

### Coverage

- Topic breadth
- Depth of treatment
- Gap filling over time
- Series completion

### Utility

- Content referenced by other articles
- External reference links
- Practical applicability
- Real-world examples
