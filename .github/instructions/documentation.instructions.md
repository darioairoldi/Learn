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
- **References** section with all sources cited

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
