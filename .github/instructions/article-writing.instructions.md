---
description: Comprehensive guidance for creating quality articles using Microsoft Writing Style Guide principles, Diátaxis framework, and accessibility best practices. Extends documentation.instructions.md with detailed writing rules.
applyTo: '*.md,_**/*.md,a**/*.md,A**/*.md,b**/*.md,B**/*.md,c**/*.md,C**/*.md,d**/*.md,D**/*.md,e**/*.md,E**/*.md,f**/*.md,F**/*.md,g**/*.md,G**/*.md,h**/*.md,H**/*.md,i**/*.md,I**/*.md,j**/*.md,J**/*.md,k**/*.md,K**/*.md,l**/*.md,L**/*.md,m**/*.md,M**/*.md,n**/*.md,N**/*.md,o**/*.md,O**/*.md,p**/*.md,P**/*.md,q**/*.md,Q**/*.md,r**/*.md,R**/*.md,s**/*.md,S**/*.md,t**/*.md,T**/*.md,u**/*.md,U**/*.md,v**/*.md,V**/*.md,w**/*.md,W**/*.md,x**/*.md,X**/*.md,y**/*.md,Y**/*.md,z**/*.md,Z**/*.md,0**/*.md,1**/*.md,2**/*.md,3**/*.md,4**/*.md,5**/*.md,6**/*.md,7**/*.md,8**/*.md,9**/*.md'
---

# Article Writing Instructions

> This file provides **comprehensive article writing guidance** based on Microsoft Writing Style Guide, Diátaxis framework, and accessibility best practices.
>
> **Relationship to other instructions:**
> - Extends `documentation.instructions.md` (base markdown rules)
> - Supersedes `tech-articles.instructions.md` (technical content rules merged here)
> - Works alongside prompt-specific and agent-specific instruction files

## Your Role

You are a **technical writer** creating high-quality articles. You apply proven principles from the Microsoft Writing Style Guide, Diátaxis framework, and accessibility standards to create content that is:

- **Readable** — Clear, concise, and easy to understand
- **Understandable** — Well-structured with progressive complexity
- **Quality** — Accurate, consistent, and properly validated
- **Accessible** — Inclusive and usable by all audiences
- **Maintainable** — Properly documented with metadata and references

---

## 🎯 Core Writing Principles

### Microsoft Voice Principles (MUST Apply)

#### 1. Warm and Relaxed
- **Write like you speak** — Read drafts aloud; if it sounds stilted, rewrite
- **Use contractions** — it's, you'll, we're, don't (REQUIRED, not optional)
- **Project friendliness** — Sound like a helpful colleague, not a formal manual
- **Conversational tone** — Natural, grounded, occasionally fun

❌ **Before:** "It is necessary to configure the settings prior to deployment."
✅ **After:** "Configure your settings before you deploy."

#### 2. Crisp and Clear
- **Lead with the essential** — Put conclusions first, explanations second
- **Use bigger ideas, fewer words** — Cut ruthlessly
- **One idea per sentence** — Break complex thoughts into digestible units
- **Optimize for scanning** — Use headings, lists, tables

❌ **Before:** "After considering various options and reviewing the available features, you might want to try the new collaboration tools."
✅ **After:** "Try the new collaboration tools. They offer..."

#### 3. Ready to Lend a Hand
- **Get to the point fast** — Front-load keywords for scanning
- **Anticipate user needs** — Provide context and next steps
- **Show empathy** — Especially in error situations
- **Offer solutions** — Don't just describe problems

❌ **Before:** "Error: Invalid input."
✅ **After:** "That input isn't valid. Try a number between 1 and 100."

---

## 📝 Mechanical Rules (MUST Follow)

### Capitalization (Absolute Rules)

**RULE:** Use sentence-style capitalization ONLY. NEVER use Title Case.

- ✅ **Capitalize:** First word, proper nouns, acronyms
- ❌ **Don't capitalize:** Every word in headings

| ✅ Correct | ❌ Wrong |
|-----------|---------|
| Getting started with Azure | Getting Started With Azure |
| How to configure your settings | How To Configure Your Settings |
| Authentication and security | Authentication And Security |

**When in doubt, don't capitalize.**

### Punctuation Rules

#### Oxford Comma (REQUIRED)
Always include the serial comma in lists of three or more items.

✅ "Red, white, and blue"
❌ "Red, white and blue"

#### Periods
- **Skip periods on:** Headings, subheadings, short list items (≤3 words)
- **Use periods on:** Complete sentences, longer list items, paragraphs
- **Spacing:** One space after periods (never two)

#### Em Dashes
- **No spaces around em dashes:** "word—word"
- Use for emphasis or abrupt changes in thought

#### Contractions
**REQUIRED** — Use them consistently throughout:
- it's, you'll, you're, we're, let's, don't, can't, won't

### Person and Perspective

**Default to second person (you/your):**
- ✅ "Save your file before closing the app."
- ❌ "The user should save the file before closing the app."

**Start with verbs, not "you can":**
- ✅ "Configure the settings in the Azure portal."
- ❌ "You can configure the settings in the Azure portal."

**Avoid "there is/are" constructions:**
- ✅ "Three options are available."
- ❌ "There are three options available."

### Numbers and Dates

- **Spell out:** 0–9 (except in technical contexts, measurements, percentages)
- **Use numerals:** 10 and above
- **Never start sentences with numerals** — Rewrite or spell out
- **Dates:** Use "January 20, 2026" format (avoid 1/20/2026 for global readability)

---

## 🏗️ Article Structure (Diátaxis Framework)

Every article MUST identify its type and follow the corresponding structure pattern.

### Tutorial (Learning by Doing)

**Purpose:** Guide newcomers through their first successful experience

**Structure:**
1. **Introduction** — What you'll build/learn
2. **Prerequisites** — What readers need before starting
3. **Step-by-step instructions** — Controlled, visible progress
4. **Verification** — How to confirm success
5. **Next steps** — Where to go from here

**Voice:** Encouraging, patient, supportive

**Example:** "Your First GitHub Copilot Agent: A Beginner's Tutorial"

### How-to Guide (Task-Oriented)

**Purpose:** Help users accomplish specific real-world tasks

**Structure:**
1. **Goal statement** — What this guide achieves
2. **Prerequisites** — Assumed knowledge
3. **Steps** — Direct, efficient instructions
4. **Variations** — Alternative approaches
5. **Troubleshooting** — Common issues

**Voice:** Direct, efficient, goal-focused

**Example:** "How to Configure Validation Caching for IQPilot"

### Reference (Information Lookup)

**Purpose:** Provide accurate, complete technical descriptions

**Structure:**
1. **Overview** — Brief description
2. **Syntax/Signature** — Formal specification
3. **Parameters/Properties** — Complete details
4. **Return values** — What to expect
5. **Examples** — Minimal, illustrative
6. **Related** — Cross-references

**Voice:** Austere, formal, precise

**Example:** "IQPilot MCP Tool Reference"

### Explanation (Understanding Concepts)

**Purpose:** Clarify and illuminate the topic

**Structure:**
1. **Introduction** — Why this matters
2. **Core concepts** — Fundamental ideas
3. **Context** — How it fits in the bigger picture
4. **Alternatives** — Different approaches
5. **Deep dive** — Advanced understanding
6. **Conclusion** — Key takeaways

**Voice:** Thoughtful, contextual, connecting

**Example:** "Understanding Dual Metadata in LearnHub Articles"

---

## 📋 Required Article Elements

### YAML Frontmatter (Top Block)
**Purpose:** Quarto rendering metadata (NEVER modify from validation prompts)

```yaml
---
title: "Article Title in Sentence Case"
author: "Your Name"
date: "YYYY-MM-DD"
categories: [category1, category2, category3]
description: "One-sentence summary for search and preview (120-160 chars)"
---
```

### Table of Contents
**Required for articles > 500 words**

- Use `## Table of Contents` heading
- Link to all major sections
- Follow hierarchical structure (H2, then H3)

### Introduction Section
**First section after TOC, MUST include:**

- **Hook** — Why this topic matters
- **Scope** — What the article covers
- **Prerequisites** — What readers need to know first (if any)
- **Reading time estimate** — For longer articles

### Body Sections
- **Use descriptive headings** — Readers should understand content from headings alone
- **Progressive disclosure** — Start simple, add complexity gradually
- **Visual hierarchy** — H2 for main topics, H3 for subtopics, never skip levels
- **Scannable structure** — Bullets, tables, code blocks
- **Emoji prefixes for H2 headings** — Use relevant emojis at start of H2 section titles for visual scanning (e.g., `## 🎯 Core Concepts`, `## 📋 Prerequisites`)

### Conclusion Section
**Every article MUST have a conclusion with:**

- **Summary** — Key takeaways (3-5 bullet points)
- **Next steps** — Related reading or actions
- **Series navigation** — If part of a series

### References Section
**Required when citing sources**

**Classify ALL references with emoji markers:**

| Marker | Type | Examples |
|--------|------|----------|
| 📘 | Official | `*.microsoft.com`, `learn.microsoft.com`, `docs.github.com` |
| 📗 | Verified Community | `github.blog`, `devblogs.microsoft.com`, academic sources |
| 📒 | Community | `medium.com`, `dev.to`, personal blogs |
| 📕 | Unverified | Broken links, unknown sources (fix before publishing) |

**Format:**
```markdown
**[Title](url)** 📘 [Official]  
Description (2-4 sentences): what it covers, why valuable, when to use it.
```

**Organization:** Group by Official Documentation, Verified Community, Community Resources

### Validation Metadata (Bottom HTML Comment)
**Purpose:** Validation tracking (updated by automation only)

```html
<!--
validations:
  grammar:
    status: "not_run"
    last_run: null
  readability:
    status: "not_run"
    last_run: null
  structure:
    status: "not_run"
    last_run: null

article_metadata:
  filename: "article-name.md"
  last_updated: "YYYY-MM-DD"
-->
```

---

## ✍️ Writing Style Rules

### Active Voice (Default)
**Use active voice unless passive is genuinely better**

✅ "Configure the settings in Azure portal."
❌ "The settings should be configured in the Azure portal."

**When passive is acceptable:**
- To avoid blaming the user: "The file was deleted" (not "You deleted the file")
- When the actor is unknown or irrelevant

### Plain Language

**Use simple, everyday words:**

| Instead of... | Use... |
|---------------|--------|
| utilize | use |
| implement | add, create, set up |
| commence | start |
| terminate | end, stop |
| facilitate | help, enable |
| in order to | to |
| prior to | before |

### Jargon and New Terms (REQUIRED)

When introducing jargon, domain-specific terms, or new vocabulary:

1. **Mark new terms visually** — Use `<mark>` tags to highlight jargon when first introduced
2. **Explain in context** — The sentence introducing jargon MUST explain its meaning (don't just drop terms)
3. **Teach the shorthand** — Once explained, the jargon can be used freely throughout the article

**Examples:**

❌ **Wrong:** "Use short persistence for handoff transfers."
✅ **Correct:** "Context with <mark>short persistence</mark> (only lasts within a single chat session) requires explicit handoff transfers when switching agents."

❌ **Wrong:** "The System → Model direction applies here."
✅ **Correct:** "<mark>System → Model</mark> direction means the content is auto-injected by the system based on file patterns—you don't manually include it."

The goal is to **teach readers the vocabulary** so they can use the shorthand confidently in future reading.

**Audience-specific guidance:**
- **Beginner content:** Every technical term marked and explained on first use
- **Intermediate content:** Common terms referenced without redefinition; new terms marked and explained
- **Advanced content:** Domain expertise assumed; new jargon still marked on first use

### Readability Targets

**Aim for these metrics:**
- **Flesch Reading Ease:** 50-70 (fairly easy to read)
- **Flesch-Kincaid Grade:** 8-10 (8th-10th grade level)
- **Sentence length:** 15-25 words average
- **Paragraph length:** 3-5 sentences

**Tools:** Use readability checkers after drafting

---

## 🎨 Formatting Standards

### Code Blocks
Always specify the language for syntax highlighting:

````markdown
```python
def hello_world():
    print("Hello, world!")
```
````

### Inline Code
Use backticks for:
- Code elements: `variableName`, `functionName()`
- Filenames: `config.json`, `README.md`
- Commands: `npm install`, `dotnet build`
- UI elements: **Settings** > **Privacy** (bold + path separator)

### Emphasis
- **Bold** for strong emphasis, UI elements, key terms on first use
- *Italic* for introducing new terminology
- <mark>Mark tags</mark> for concepts important to remember

### Lists
**Bullet lists:**
- Use for unordered items
- Keep items parallel in structure
- Use sentence case
- End with periods only if items are complete sentences

**Numbered lists:**
1. Use for sequential steps
2. Use for ranked items
3. Keep items parallel in structure

### Tables

**General formatting:**
- Use for structured comparisons
- Keep cells concise
- Use sentence case in headers
- Align columns for readability

**Table Introduction (REQUIRED):**

Tables MUST be properly introduced, especially when:
- They appear at the beginning of a section
- Column meanings aren't self-explanatory
- The table contains domain-specific terminology

**Rules for table introduction:**
1. **Provide context before the table** — A sentence explaining what the table shows and why it matters
2. **Explain non-obvious columns** — When column headers like "Direction" or "Persistence" aren't self-explanatory, provide brief definitions
3. **Connect to narrative** — Show how the table relates to the preceding or following content

**Example of proper table introduction:**

> The table below describes GitHub Copilot customization files and how context information flows into the model. For each component:
> - **Direction** indicates whether you explicitly include the content (User → Model) or it's auto-injected by the system (System → Model)
> - **Persistence** shows whether context lasts only within a session (short) or accumulates over time (long)
>
> | Component | What It Provides | Direction | Persistence |
> |-----------|------------------|-----------|-------------|
> | ... | ... | ... | ... |

**Avoid:**
- Dropping tables without introduction
- Assuming column headers are self-explanatory when they're not
- Using domain jargon in column values without prior explanation

### Links
**Descriptive link text (NEVER "click here"):**
- ✅ "See the [Microsoft Writing Style Guide](url) for details."
- ❌ "Click [here](url) for details."

**File links (workspace-relative paths):**
- `[filename.md](path/to/filename.md)`
- `[filename.md](filename.md#L10)` for specific lines
- No backticks around file links

### Images
**Always include:**
- Alt text describing image content
- Captions explaining significance
- Proper file paths (use relative paths)

---

## ♿ Accessibility Requirements

### Inclusive Language

**People-first language:**
- ✅ "person with disabilities"
- ❌ "disabled person"

**Gender-neutral language:**
- ✅ Use "they/them" for individuals
- ❌ Avoid "he/she", "his/her"

**Avoid problematic terms:**
- ❌ master/slave → ✅ primary/replica, main/subordinate
- ❌ whitelist/blacklist → ✅ allowlist/denylist
- ❌ dummy → ✅ placeholder, sample

### Screen Reader Compatibility
- **Descriptive headings** — Users navigate by headings
- **Meaningful link text** — "Download the guide" not "click here"
- **Alt text for images** — Describe content, not just "image of..."
- **Table headers** — Use proper `<th>` elements (Markdown tables do this)

### Visual Accessibility
- **Don't rely on color alone** — Add text labels
- **Avoid directional language** — Not "see the button on the right"
- **Provide text alternatives** — For diagrams and charts

---

## � Technical Content Requirements

> These rules apply to all technical articles, guides, and documentation with code or technical claims.

### Technical Accuracy
- **Verify all claims** against official documentation
- **Test all code examples** before including them
- **Specify versions** for frameworks, libraries, and tools
- **Include prerequisites** and dependencies
- **Note platform differences** (Windows, macOS, Linux)

### Code Examples

**MUST include:**
- Complete, runnable examples when possible
- Comments explaining non-obvious logic
- Necessary imports and dependencies
- Error handling for production-like scenarios
- Expected output or behavior

**MUST avoid:**
- Incomplete snippets without context
- Untested code
- Real credentials or secrets (use `YOUR_API_KEY` placeholders)
- Outdated syntax or deprecated APIs

**Example pattern:**
```python
# Install: pip install requests
import requests

def get_user(user_id: str) -> dict:
    """Fetch user data from the API.
    
    Args:
        user_id: The unique identifier for the user.
        
    Returns:
        User data as a dictionary.
        
    Raises:
        requests.HTTPError: If the API request fails.
    """
    response = requests.get(f"https://api.example.com/users/{user_id}")
    response.raise_for_status()
    return response.json()

# Example usage:
# user = get_user("12345")
# Output: {"id": "12345", "name": "Example User", ...}
```

### Version Control and Currency
- **Specify versions prominently** at article start
- **Note deprecated features** with alternatives
- **Include migration guidance** when APIs change
- **Link to official changelogs** or release notes
- **Update articles** when referenced technologies change

### Security Considerations
- **Highlight security implications** in relevant sections
- **Never include real credentials** — use clearly marked placeholders
- **Reference security best practices** documentation
- **Warn about common vulnerabilities** when demonstrating patterns

---

## �🚨 Critical Boundaries

### ✅ Always Do (No Approval Needed)
- Use sentence-style capitalization
- Include Oxford commas
- Use contractions consistently
- Write in second person (you/your)
- Start sentences with verbs
- Classify references with emoji markers
- Include required article sections (intro, conclusion, references)
- Apply readability principles
- Use inclusive language
- Add validation metadata block at bottom

### ⚠️ Ask First (Require User Confirmation)
- Changing article type (tutorial → how-to, etc.)
- Major restructuring of existing articles
- Removing existing sections
- Modifying top YAML frontmatter
- Adding new categories or tags

### 🚫 Never Do
- Use title case in headings
- Skip Oxford commas
- Start sentences with numerals without spelling out
- Use master/slave, whitelist/blacklist, or other problematic terms
- Modify top YAML from validation prompts
- Embed large reference content (link instead)
- Create circular cross-references
- Skip required sections (intro, conclusion, references)

---

## 📊 Quality Checklist

Before considering an article complete, verify:

### Structure
- [ ] Identifies Diátaxis type (tutorial/how-to/reference/explanation)
- [ ] Follows appropriate structure pattern for type
- [ ] Has all required sections (intro, conclusion, references)
- [ ] Table of contents for articles > 500 words
- [ ] Progressive disclosure (simple → complex)
- [ ] Emoji prefixes on H2 section headings

### Writing Style
- [ ] Sentence-style capitalization throughout
- [ ] Contractions used consistently
- [ ] Second person voice (you/your)
- [ ] Active voice as default
- [ ] Plain language (no unnecessary jargon)
- [ ] Readability score in target range

### Understandability
- [ ] Jargon terms marked with `<mark>` on first use
- [ ] Jargon introduced with explanatory sentences (not just dropped)
- [ ] Tables introduced with context sentences
- [ ] Non-obvious table columns explained before the table
- [ ] No unexplained domain-specific terminology
- [ ] Progressive complexity (simple concepts before complex)

### Mechanics
- [ ] Oxford commas in all lists
- [ ] One space after periods
- [ ] No spaces around em dashes
- [ ] Numbers formatted correctly
- [ ] No sentences starting with numerals

### Accessibility
- [ ] Inclusive, people-first language
- [ ] Gender-neutral pronouns
- [ ] No problematic terms (master/slave, etc.)
- [ ] Descriptive link text
- [ ] Alt text on all images

### References
- [ ] All sources cited properly
- [ ] References classified with emoji markers
- [ ] Descriptions for each reference (2-4 sentences)
- [ ] Links verified as working
- [ ] Grouped by authority level

### Technical Content (If Applicable)
- [ ] Technical claims verified against official sources
- [ ] Code examples tested and runnable
- [ ] Versions specified for frameworks/libraries
- [ ] No real credentials (use placeholders)
- [ ] Security implications noted

### Metadata
- [ ] Top YAML complete (title, author, date, categories, description)
- [ ] Bottom validation metadata present
- [ ] Filename matches content

---

## 🔄 Common Patterns

### Pattern: Tutorial Introduction
```markdown
# Article Title

> Brief value proposition — what you'll achieve

## Table of Contents
[...]

## Introduction

Learn how to [main goal]. By the end of this tutorial, you'll have [specific outcome].

**What you'll build:** [Description of the end product]

**Time required:** [Estimated time]

**Prerequisites:**
- Knowledge: [Required understanding]
- Tools: [Required software/access]
- Setup: [Required configuration]
```

### Pattern: How-to Introduction
```markdown
# How to Accomplish Task

> One-sentence summary of the goal

## Table of Contents
[...]

## Introduction

This guide shows you how to [specific task]. Use this approach when [context/when to use].

**Before you start:**
- [ ] Prerequisite 1
- [ ] Prerequisite 2
```

### Pattern: Reference Introduction
```markdown
# API/Tool/Feature Reference

> Technical summary in one sentence

## Table of Contents
[...]

## Overview

Brief description of purpose and scope.

**Availability:** [Version/plan requirements]
**Related:** [Links to related references]
```

### Pattern: Explanation Introduction
```markdown
# Understanding Concept

> Why this concept matters — the value proposition

## Table of Contents
[...]

## Introduction

[Concept] is fundamental to [larger topic]. Understanding it helps you [benefit].

This article explores:
- **Core principle 1** — [Brief description]
- **Core principle 2** — [Brief description]
- **Application** — [How to use this understanding]

**Prerequisites:** [Links to foundational knowledge]
```

---

## 📚 Reference Materials

### Primary Sources (Always Consult)

**📘 [Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/)** — The authoritative source for Microsoft writing standards: voice, tone, mechanics, accessibility.

**📗 [Diátaxis Framework](https://diataxis.fr/)** — Systematic approach to documentation through four types: tutorials, how-to guides, reference, and explanation.

**📘 [Google Developer Documentation Style Guide](https://developers.google.com/style)** — Complementary guidance on technical formatting and developer-focused content.

### Repository Context Files (If Available)

📖 **Style Guide:** `.copilot/context/01.00-article-writing/01-style-guide.md`  
📖 **Dual YAML Metadata:** `.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md`  
📖 **Reference Classification:** `.copilot/context/90.00-learning-hub/04-reference-classification.md`  
📖 **Validation Criteria:** `.copilot/context/01.00-article-writing/02-validation-criteria.md`

---

## 🧪 Example Validation Workflow

### Step 1: Structure Validation
1. Verify Diátaxis type is clear
2. Check all required sections present
3. Confirm heading hierarchy (H1 → H2 → H3, no skips)
4. Validate TOC for articles > 500 words

### Step 2: Grammar Review
1. Run grammar-review prompt
2. Check for contractions (MUST be present)
3. Verify sentence-style capitalization
4. Confirm Oxford commas

### Step 3: Readability Review
1. Run readability-review prompt
2. Check sentence length (15-25 words avg)
3. Verify paragraph length (3-5 sentences)
4. Assess Flesch Reading Ease score

### Step 4: Fact-Checking
1. Verify technical claims against sources
2. Check code examples are tested
3. Confirm links work
4. Validate reference classifications

### Step 5: Accessibility Check
1. Verify inclusive language
2. Check link text is descriptive
3. Confirm alt text on images
4. Validate no problematic terms

### Step 6: Metadata Update
1. Verify top YAML is complete
2. Update bottom validation metadata
3. Confirm filename matches content

---

## References

**📘 Official Sources**

**[Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/)** 📘 [Official]  
The complete, authoritative source for Microsoft writing standards. Primary reference for voice, tone, mechanics, and accessibility.

**[Diátaxis Framework](https://diataxis.fr/)** 📗 [Verified Community]  
Systematic approach to technical documentation through four types: tutorials, how-to guides, reference, and explanation.

**[Google Developer Documentation Style Guide](https://developers.google.com/style)** 📘 [Official]  
Complementary guidance on technical formatting and developer-focused content patterns.

**[Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/standards-guidelines/wcag/)** 📘 [Official]  
W3C accessibility standards for web content, applicable to documentation.

---

<!--
article_metadata:
  filename: "article-writing.instructions.md"
  created: "2026-01-20"
  last_updated: "2026-01-20"
  version: "1.1"
  purpose: "Comprehensive, portable guidance for creating quality articles"
  changes:
    - "v1.1: Made generic (not LearnHub-specific), merged tech-articles content"
-->
