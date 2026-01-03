---
description: Instructions for documentation and article content
applyTo: '*.md,_**/*.md,a**/*.md,A**/*.md,b**/*.md,B**/*.md,c**/*.md,C**/*.md,d**/*.md,D**/*.md,e**/*.md,E**/*.md,f**/*.md,F**/*.md,g**/*.md,G**/*.md,h**/*.md,H**/*.md,i**/*.md,I**/*.md,j**/*.md,J**/*.md,k**/*.md,K**/*.md,l**/*.md,L**/*.md,m**/*.md,M**/*.md,n**/*.md,N**/*.md,o**/*.md,O**/*.md,p**/*.md,P**/*.md,q**/*.md,Q**/*.md,r**/*.md,R**/*.md,s**/*.md,S**/*.md,t**/*.md,T**/*.md,u**/*.md,U**/*.md,v**/*.md,V**/*.md,w**/*.md,W**/*.md,x**/*.md,X**/*.md,y**/*.md,Y**/*.md,z**/*.md,Z**/*.md,0**/*.md,1**/*.md,2**/*.md,3**/*.md,4**/*.md,5**/*.md,6**/*.md,7**/*.md,8**/*.md,9**/*.md'
---

# Documentation Content Instructions

## Apply To
These instructions apply to all <mark>Markdown files</mark> in content areas (excludes folders starting with `.` like `.github/`, `.copilot/`), including:
- Articles in subject folders (tech/, howto/, projects/, etc.)
- README files
- Learning guides and tutorials

## Writing Style
- Use active voice whenever possible
- Keep sentences concise (aim for 15-25 words)
- Break complex ideas into digestible paragraphs (3-5 sentences)
- Use bullet points for lists and steps
- Include code examples with explanations

## Structure Requirements
Every article must include:
- **Title** (H1 heading)
- **Table of Contents** (for articles > 500 words)
- **Introduction** explaining the topic and what readers will learn
- **Body** with clear section headings (H2, H3)
- **Conclusion** summarizing key points
- **References** section with all sources cited and properly classified (see Reference Classification below)

## Reference Classification

All references must include emoji markers indicating source reliability:

| Marker | Type | Examples |
|--------|------|----------|
| 📘 | Official | `*.microsoft.com`, `docs.github.com`, `learn.microsoft.com` |
| 📗 | Verified Community | `github.blog`, `devblogs.microsoft.com`, academic sources |
| 📒 | Community | `medium.com`, `dev.to`, personal blogs, tutorials |
| 📕 | Unverified | Broken links, unknown sources (fix before publishing) |

**Format:** `**[Title](url)** `[📘 Official]`  
Description (2-4 sentences): what it covers, why valuable, when to use it.

**Organization:** Group as Official Documentation, Session Materials, Community Resources, or Product-Specific. Order by authority and relevance.

📖 **Complete classification rules and examples:** `.copilot/context/reference-classification.md`

## Formatting Standards
- Use semantic Markdown (proper heading hierarchy)
- Include language identifiers for code blocks
- Use `backticks` for inline code, filenames, and commands
- Use **bold** for emphasis, *italic* for definitions
- <mark>Mark text</mark> with mark tags for relevant terms and concepts  
- Include alt text for all images
- Use descriptive link text (not "click here")

## Metadata Requirements

### Dual YAML Blocks
Articles use **two metadata blocks** - never confuse them:
- **Top YAML** (file start): Quarto rendering metadata (title, author, date, categories). Authors edit manually. **❌ Never modify from validation prompts.**
- **Bottom HTML comment** (file end): Validation metadata (status, timestamps). Updated by automation only.

**Validation Rules:**
- Check bottom metadata `last_run` timestamp before validation
- Skip if `< 7 days` AND content unchanged
- Update only your validation section in bottom metadata
- Never touch top YAML from validation prompts

📖 **Complete guidelines:** `.copilot/context/dual-yaml-helpers.md`  
🔧 **Validation prompts:** `.github/prompts/` (grammar, readability, structure, fact-checking, logic, publish-ready)

## Content Validation
Before considering an article complete:
- Run grammar-review prompt
- Run readability-review prompt
- Run structure-validation prompt
- Run fact-checking prompt for technical claims
- Verify all links are working
- Check that examples are tested and functional
