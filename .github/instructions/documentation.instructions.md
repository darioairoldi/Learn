---
description: Base instructions for all Markdown files—essential structure, formatting, and validation rules. See article-writing.instructions.md for comprehensive writing guidance.
applyTo: '*.md,[0-9]*/**/*.md,_*/**/*.md,docs/**/*.md,src/docs/**/*.md'
version: "1.10.1"
last_updated: "2026-06-06"
domain: "article-writing"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
  - ".copilot/context/01.00-article-writing/"
  - ".copilot/context/90.00-learning-hub/"
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

## Reference Classification

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

📖 **Complete caching pattern:** `.copilot/context/00.00-prompt-engineering/04.01-validation-caching-pattern.md`

1. Check bottom metadata `last_run` timestamp before validation
2. Skip if `< 7 days` AND content unchanged
3. Update only your validation section in bottom metadata
4. **Never touch top YAML from validation prompts**

📖 **Complete metadata guidelines:** `.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md`

---

## File Encoding (CRITICAL)

All Markdown files and PE artifacts **MUST** be saved as **UTF-8** (with or without BOM).

- **NEVER** use CP1252 (Windows-1252) encoding or CP1252-based conversions — they silently destroy emoji characters (✅, 🚫, ⚠️, 📘, 📗, 📒, 📕, etc.)
- **NEVER** use `[System.Text.Encoding]::GetEncoding(1252)` or equivalent CP1252 conversions when processing Markdown files — multi-byte UTF-8 sequences (especially 4-byte emoji) are irreversibly replaced with `?`
- When reading/writing files programmatically, always specify UTF-8 encoding explicitly
- When fixing encoding issues, use string-level replacement maps rather than encoding round-trips through CP1252

---

## Essential Formatting Standards

| Element | Rule |
|---------|------|
| **Headings** | Sentence-style capitalization (never Title Case); H2 headings MUST start with a relevant emoji (e.g., `## 🎯 Core concepts`) |
| **Code blocks** | Always specify language identifier |
| **Inline code** | Use `backticks` for code, filenames, commands |
| **Emphasis** | **Bold** for emphasis, *italic* for definitions, <mark>mark</mark> for key concepts |
| **Links** | Descriptive text (never "click here") |
| **Images** | Always include alt text |

### Plan status markers (`*plan.md`)

All plan marking rules (status notation, section/item classification, consistency enforcement) are defined in a dedicated instruction file auto-loaded for plan files:

📖 **Full rules:** `.github/instructions/plan-marking.instructions.md` (applyTo: `*plan*`)

**Quick reference:** Use suffix-only notation — `(✅ done)`, `(🟡 todo)`, `(📌 next steps)`. Never use checkbox syntax `[x]`. Mark both section headings and list items. Classify sections as Action/Analysis/Proposal before marking.

### Procedural step markers (executed-work narratives)

Status-suffix marking is NOT limited to `*plan*` files. It also applies to any Markdown document that narrates **discrete units of executed or pending work performed by the author/agent** — typically the Resolution, Remediation, Implementation, Fix, **Verification**, **Acceptance**, or **Follow-up** sections of issue reports, post-mortems, change narratives, and analysis documents.

**Trigger patterns (MUST be marked):**

- Numbered or named **step headings** under Resolution-type sections: `### Step 1 — …`, `### Step 2 — …`, `### Phase N — …`, `### Fix N — …`
- **Any list (numbered OR bulleted)** in the same sections whose items describe an action taken or pending
- **Verification checklists, acceptance checklists, completion checklists, sign-off lists** — regardless of list style
- Section names that match (case-insensitive) any of: `Verification`, `Acceptance criteria`, `Resolution`, `Remediation`, `Implementation`, `Fix`, `Follow-up`, `Next actions`, `Recommendations`, `Sign-off`

**Format:** Same suffix notation as `plan-marking.instructions.md` — `(✅ done)`, `(🟡 todo)`, `(📌 next steps)`. Append to the heading text or list item text.

**Checkbox syntax is FORBIDDEN in any executed-work section** — `- [x]` and `- [ ]` items MUST be rewritten as plain bullets with a status suffix. This applies even when the section is titled "checklist". The Markdown checkbox feature is a reader-interaction widget; it does not encode authoritative status and conflicts with the suffix-only contract.

**Examples (correct):**

```markdown
### Step 1 — Confirm the rule exists in the instruction file (✅ done)
### Step 2 — Apply the cap to v15 (✅ done)
### Step 3 — Add lint enforcement (🟡 todo)

### Verification checklist

- Schema authority file updated to v1.3.0. (✅ done)
- Body principle headings carry priority lines. (🟡 todo)
- Downstream sweep for renamed IDs. (🟡 todo)
```

**Anti-patterns (MUST be rewritten):**

```markdown
<!-- WRONG — checkbox syntax forbidden in executed-work sections -->
- [x] Schema authority file updated.
- [ ] Body priority lines added.

<!-- WRONG — bare bullet with no status suffix -->
- Schema authority file updated.
- Body priority lines added.
```

**Quick conversion recipe (on first edit of any matching section):**

1. Replace every `- [x] …` with `- … (✅ done)`.
2. Replace every `- [ ] …` with `- … (🟡 todo)`.
3. If the bullet describes a deferred follow-up (post-exit), use `(📌 next steps)` instead.

**Exception — instructional content authored FOR THE READER:** Tutorial steps, how-to procedures, and getting-started guides describe work the *reader* will do, not work the author has done. These MUST NOT carry status suffixes (checkbox syntax is acceptable there as a reader-interaction widget).

**Disambiguator:** Is the item describing work YOU (author/agent) did/will do, or work the READER will do? Only the former is markable with status suffixes; only the latter may use `[ ]` checkboxes.

---

## Content Validation Checklist

Before considering an article complete:

- [ ] Run `article-review-for-consistency-gaps-and-extensions.prompt.md` for single articles (covers grammar, readability, structure, facts, gaps, references in 7 phases)
- [ ] Run `article-review-series-for-consistency-gaps-and-extensions.prompt.md` for article series (consistency, terminology, cross-references)
- [ ] Verify all links are working
- [ ] Check that code examples are tested

🔧 **Validation prompts:** `.github/prompts/01.00-article-writing/`
📖 **Quality thresholds:** `.copilot/context/01.00-article-writing/02-validation-criteria.md`

---

## Related Instruction Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `article-writing.instructions.md` | Comprehensive writing guidance | Creating/editing articles |
| `pe-prompts.instructions.md` | Prompt file creation | Creating `.prompt.md` files |
| `pe-agents.instructions.md` | Agent file creation | Creating `.agent.md` files |
| `pe-context-files.instructions.md` | Context file creation | Creating context documentation |
| `pe-skills.instructions.md` | Skill file creation | Creating `SKILL.md` files |
