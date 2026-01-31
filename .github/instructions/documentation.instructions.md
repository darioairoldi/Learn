---
description: Base instructions for all Markdown files—essential structure, formatting, and validation rules. See article-writing.instructions.md for comprehensive writing guidance.
applyTo: '*.md,_**/*.md,a**/*.md,A**/*.md,b**/*.md,B**/*.md,c**/*.md,C**/*.md,d**/*.md,D**/*.md,e**/*.md,E**/*.md,f**/*.md,F**/*.md,g**/*.md,G**/*.md,h**/*.md,H**/*.md,i**/*.md,I**/*.md,j**/*.md,J**/*.md,k**/*.md,K**/*.md,l**/*.md,L**/*.md,m**/*.md,M**/*.md,n**/*.md,N**/*.md,o**/*.md,O**/*.md,p**/*.md,P**/*.md,q**/*.md,Q**/*.md,r**/*.md,R**/*.md,s**/*.md,S**/*.md,t**/*.md,T**/*.md,u**/*.md,U**/*.md,v**/*.md,V**/*.md,w**/*.md,W**/*.md,x**/*.md,X**/*.md,y**/*.md,Y**/*.md,z**/*.md,Z**/*.md,0**/*.md,1**/*.md,2**/*.md,3**/*.md,4**/*.md,5**/*.md,6**/*.md,7**/*.md,8**/*.md,9**/*.md'
---

# Documentation Base Instructions

> **This is the base layer** for all Markdown files. It covers essential structure, formatting, metadata, and validation requirements.
>
> 📖 **For comprehensive writing guidance** (voice, tone, Diátaxis patterns, accessibility): See `article-writing.instructions.md`
>
> **Scope:** All Markdown files in content areas (excludes folders starting with `.` like `.github/`, `.copilot/`)

---

## Essential Structure Requirements

Every article MUST include:

| Element | Requirement |
|---------|-------------|
| **Title** | H1 heading, sentence-style capitalization |
| **Table of Contents** | Required for articles > 500 words |
| **Introduction** | What readers will learn, prerequisites |
| **Body** | Clear section headings (H2, H3), logical flow |
| **Conclusion** | Key takeaways, next steps |
| **References** | All sources cited and classified |

---

## Reference Classification (REQUIRED)

All references MUST include emoji markers indicating source reliability:

| Marker | Type | Examples |
|--------|------|----------|
| 📘 | Official | `*.microsoft.com`, `docs.github.com`, `learn.microsoft.com` |
| 📗 | Verified Community | `github.blog`, `devblogs.microsoft.com`, academic sources |
| 📒 | Community | `medium.com`, `dev.to`, personal blogs, tutorials |
| 📕 | Unverified | Broken links, unknown sources (fix before publishing) |

**Format:**
```markdown
**[Title](url)** 📘 [Official]  
Description (2-4 sentences): what it covers, why valuable, when to use it.
```

📖 **Complete classification rules:** `.copilot/context/90.00-learning-hub/04-reference-classification.md`

---

## Dual Metadata System (CRITICAL)

Articles use **two metadata blocks**—never confuse them:

### Top YAML (File Start)
**Purpose:** Quarto rendering metadata  
**Who edits:** Authors manually  
**❌ NEVER modify from validation prompts**

```yaml
---
title: "Article title in sentence case"
author: "Author Name"
date: "YYYY-MM-DD"
categories: [category1, category2]
description: "One-sentence summary (120-160 chars)"
---
```

### Bottom HTML Comment (File End)
**Purpose:** Validation tracking metadata  
**Who edits:** Automation only

```html
<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  
article_metadata:
  filename: "article-name.md"
-->
```

**Validation Rules:**
1. Check bottom metadata `last_run` timestamp before validation
2. Skip if `< 7 days` AND content unchanged
3. Update only your validation section in bottom metadata
4. **Never touch top YAML from validation prompts**

📖 **Complete guidelines:** `.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md`

---

## Essential Formatting Standards

| Element | Rule |
|---------|------|
| **Headings** | Sentence-style capitalization (never Title Case) |
| **Code blocks** | Always specify language identifier |
| **Inline code** | Use `backticks` for code, filenames, commands |
| **Emphasis** | **Bold** for emphasis, *italic* for definitions, <mark>mark</mark> for key concepts |
| **Links** | Descriptive text (never "click here") |
| **Images** | Always include alt text |

---

## Content Validation Checklist

Before considering an article complete:

- [ ] Run grammar-review prompt
- [ ] Run readability-review prompt  
- [ ] Run structure-validation prompt
- [ ] Run fact-checking prompt for technical claims
- [ ] Verify all links are working
- [ ] Check that code examples are tested

🔧 **Validation prompts:** `.github/prompts/` (grammar, readability, structure, fact-checking, logic, publish-ready)

---

## Related Instruction Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `article-writing.instructions.md` | Comprehensive writing guidance | Creating/editing articles |
| `prompts.instructions.md` | Prompt file creation | Creating `.prompt.md` files |
| `agents.instructions.md` | Agent file creation | Creating `.agent.md` files |
| `context-files.instructions.md` | Context file creation | Creating context documentation |
| `skills.instructions.md` | Skill file creation | Creating `SKILL.md` files |
