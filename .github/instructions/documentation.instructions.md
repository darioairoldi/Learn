---
description: Instructions for documentation and article content
applyTo: '**/*.md'
---

# Documentation Content Instructions

## Apply To
These instructions apply to all <mark>Markdown files</mark> in the documentation areas, including:
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

All URLs in the **References** section must be classified with emoji markers based on domain and source type. This ensures readers can quickly assess source reliability and authority.

### Classification Rules (Domain-Based)

Apply these rules to each reference URL:

| Classification | Domain Patterns | Examples |
|---------------|-----------------|----------|
| `📘 Official` | `*.microsoft.com`, `docs.github.com`, `learn.microsoft.com`, `code.visualstudio.com/docs`, `azure.microsoft.com/docs` | Official product documentation, Microsoft Learn |
| `📗 Verified Community` | `github.blog`, `devblogs.microsoft.com`, recognized expert domains, academic sources | Official blogs, peer-reviewed content |
| `📒 Community` | `medium.com`, `dev.to`, personal blogs, `stackoverflow.com`, tutorials, YouTube channels | General community content |
| `📕 Unverified` | Broken links, unknown domains, questionable sources | Inaccessible or unreliable |

### Special Cases

- **GitHub repositories**: Official repos (microsoft/*, github/*) = `📘 Official`, community repos = `📒 Community`
- **Recording links**: Session recordings on official channels (MS Build, Ignite) = `📘 Official`, community recordings = `📒 Community`
- **Redirected links**: Use final destination domain for classification
- **Mixed content**: Classify by context and authority (e.g., official tutorial on community site = `📗 Verified Community`)
- **Broken links**: Always `📕 Unverified` - fix or remove before publishing

### Reference Organization

Group references by category:

1. **Official Documentation** (`📘` sources only) - Product docs, official guides, authoritative specifications
2. **Session Materials** (for recordings/events) - Recording links, slides, repos - classified based on host
3. **Community Resources** (`📗` `📒` sources) - Blogs, tutorials, community content
4. **Product-Specific** (optional) - When article covers multiple products (e.g., "VS Code Features", "Visual Studio Support")

### Reference Format

Each reference must include:
- **Full title** with clickable URL
- **Classification marker** (📘/📗/📒/📕)
- **Description** (2-4 sentences) explaining:
  - What the reference covers
  - Why it's valuable/relevant
  - When readers should reference it

**Format:**
```markdown
**[Title](url)** `[📘 Official]`  
Brief description explaining content and why it's valuable (2-4 sentences). Include what topics it covers and when readers should reference it.
```

### Classification Examples

**Official Documentation:**
```markdown
**[VS Code Release Notes](https://code.visualstudio.com/updates/)** `[📘 Official]`  
Official Visual Studio Code monthly release notes with complete changelog including all features, bug fixes, and breaking changes. Essential reading for understanding new capabilities and staying current with VS Code evolution.

**[GitHub Copilot Documentation](https://docs.github.com/copilot/)** `[📘 Official]`  
Comprehensive official GitHub Copilot documentation covering setup, customization, bring-your-own-key configuration, and agent features. The authoritative source for all Copilot capabilities and best practices.
```

**Verified Community:**
```markdown
**[How to Write Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)** `[📗 Verified Community]`  
Official GitHub blog post analyzing patterns from 2,500+ repositories to identify best practices for agent file creation. Provides data-driven insights into what makes agent files effective and actionable recommendations.
```

**Community Resources:**
```markdown
**[Building Custom VS Code Agents Tutorial](https://dev.to/example/custom-agents)** `[📒 Community]`  
Community tutorial walking through custom agent creation with practical examples and code samples. Useful for developers getting started with agent customization beyond official documentation.
```

**Session Materials (Mixed Classifications):**
```markdown
### Session Materials

**[AI Dev Days Recording](https://youtube.com/microsoft/...)** `[📘 Official]`  
Full session recording from Microsoft AI Dev Days covering unified agent architecture. Includes all demos and Q&A segments referenced in this summary.

**[HuggingFace Inference Provider Extension](https://marketplace.visualstudio.com/items?itemName=huggingface.huggingface-vscode)** `[📘 Official]`  
Official extension for using HuggingFace models in VS Code Copilot Chat. Provides access to open-weights models via multiple inference providers with automatic cost/speed optimization.

**[Community Implementation Example](https://github.com/community-user/agent-example)** `[📒 Community]`  
Community repository demonstrating custom agent patterns discussed in the session. Useful reference for practical implementation approaches.
```

### Quality Checklist for References

Before completing any article, verify:
- [ ] All URLs have emoji classification markers (📘/📗/📒/📕)
- [ ] References are grouped by category (Official / Session Materials / Community / Product-Specific)
- [ ] Each reference has 2-4 sentence description
- [ ] Descriptions explain what content covers AND when to use it
- [ ] Official sources (`📘`) are listed before community sources
- [ ] Most relevant/comprehensive sources listed first within each category
- [ ] No broken links (`📕 Unverified`) in published articles
- [ ] All references mentioned in article text are included in References section

## Formatting Standards
- Use semantic Markdown (proper heading hierarchy)
- Include language identifiers for code blocks
- Use `backticks` for inline code, filenames, and commands
- Use **bold** for emphasis, *italic* for definitions
- <mark>Mark text</mark> with mark tags for relevant terms and concepts  
- Include alt text for all images
- Use descriptive link text (not "click here")

## Metadata Requirements
Each article must have Bottom HTML Comment Block with (YAML) Article additional metadata.
Article additional metadata could include: 
- Validation history
- Cross-references
- Analytics data

## Content Validation
Before considering an article complete:
- Run grammar-review prompt
- Run readability-review prompt
- Run structure-validation prompt
- Run fact-checking prompt for technical claims
- Verify all links are working
- Check that examples are tested and functional
