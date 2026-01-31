---
name: article-review
description: >
  Comprehensive article review workflow for technical documentation following 
  quality standards. Use when reviewing markdown articles, validating structure, 
  checking reference classifications, or preparing content for publication.
---

# Article Review Skill

## Purpose

Perform comprehensive quality reviews of technical documentation articles to ensure they meet publication standards, including proper structure, reference classification, and content quality.

## When to Use

Activate this skill when:
- **Reviewing articles**: "Review this article for publication readiness"
- **Checking structure**: "Validate the structure of this markdown file"
- **Classifying references**: "Check reference classifications in this article"
- **Quality assessment**: "Assess the quality of this technical documentation"

Do NOT use this skill for:
- Grammar checking (use grammar-review prompt instead)
- Code review (use code-review skill/agent instead)
- Creating new articles (use article-template instead)

## Workflow

### Step 1: Structure Validation

Check that the article includes all required sections:

- [ ] **Title** (H1 heading at the start)
- [ ] **Table of Contents** (for articles > 500 words)
- [ ] **Introduction** explaining topic and learning objectives
- [ ] **Body** with clear section headings (H2, H3)
- [ ] **Conclusion** summarizing key points
- [ ] **References** section with classified sources

### Step 2: Metadata Verification

Verify dual YAML blocks are properly formatted:

**Top YAML** (Quarto rendering - at file start):
```yaml
---
title: "Article Title"
author: "Author Name"
date: "YYYY-MM-DD"
categories: [category1, category2]
description: "Brief description"
---
```

**Bottom HTML Comment** (Validation tracking - at file end):
```html
<!-- 
---
validations:
  grammar: {last_run: null, ...}
article_metadata:
  filename: "article-name.md"
  created: "YYYY-MM-DD"
---
-->
```

### Step 3: Reference Classification

Verify all references include proper emoji markers:

| Marker | Type | Examples |
|--------|------|----------|
| 📘 | Official | `*.microsoft.com`, `docs.github.com` |
| 📗 | Verified Community | `github.blog`, `devblogs.microsoft.com` |
| 📒 | Community | `medium.com`, `dev.to`, personal blogs |
| 📕 | Unverified | Broken links, unknown sources |

**Expected format:**
```markdown
**[Title](url)** `[📘 Official]`  
Description (2-4 sentences): what it covers, why valuable.
```

### Step 4: Content Quality Checks

Review for:
- [ ] Active voice usage
- [ ] Concise sentences (15-25 words target)
- [ ] Proper markdown formatting
- [ ] Code examples with language identifiers
- [ ] `<mark>` tags for key terms
- [ ] Descriptive link text (not "click here")

### Step 5: Generate Review Summary

Provide a summary using the [review template](./templates/review-summary.md).

## Templates

- **[Review Summary](./templates/review-summary.md)** - Standard format for review results
- **[Reference Entry](./templates/reference-entry.md)** - Proper reference formatting

## Checklists

See [checklists/publication-ready.md](./checklists/publication-ready.md) for the complete pre-publication checklist.

## Common Issues

### Issue: Missing Reference Classification

**Symptom**: References listed without emoji markers  
**Solution**: Add appropriate marker based on source domain. See reference classification rules in checklist.

### Issue: Top YAML Modified by Validation

**Symptom**: Quarto metadata changed unexpectedly  
**Solution**: Validation should ONLY modify bottom HTML comment metadata. Restore top YAML from git history.

### Issue: Broken Internal Links

**Symptom**: Links to other articles return 404  
**Solution**: Use relative paths. Verify target file exists. Check for renamed files.

## Resources

- [Documentation Instructions](.github/instructions/documentation.instructions.md)
- [Reference Classification Guide](.copilot/context/90.00-learning-hub/04-reference-classification.md)
- [Dual YAML Metadata](.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md)
