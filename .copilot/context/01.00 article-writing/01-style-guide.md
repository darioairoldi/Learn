# Style Guide for Learning Documentation Site

This style guide ensures consistency across all content in this repository.

## Voice and Tone

### General Principles

- **Educational and Supportive**: Help readers learn, never talk down to them
- **Clear and Direct**: Get to the point, avoid unnecessary preamble
- **Active Voice**: "Click the button" not "The button should be clicked"
- **Professional but Approachable**: Technical accuracy without stuffiness

### Person and Perspective

- **Second Person for Instructions**: "You should configure..." (HowTo/Tutorial)
- **Third Person for Concepts**: "The system processes..." (Articles)
- **First Person Sparingly**: "I recommend..." (only when sharing personal experience)
- **Avoid "We"**: Don't use "we" unless representing an organization

## Language and Word Choice

### Simplicity

- Use common words over complex synonyms
- Target Grade 9-10 reading level for general content
- Allow higher complexity for advanced technical topics
- Define jargon on first use

### Precision

- Be specific: "Click the Submit button" not "Click the button"
- Use exact names: "Visual Studio Code" not "VS Code" on first reference
- Specify versions: "Node.js 18.x or higher"
- Include units: "10 seconds" not "10"

### Inclusive Language

- Avoid gendered pronouns for hypothetical users
- Use "they/them" as singular neutral pronoun
- Use "allowlist/denylist" not "whitelist/blacklist"
- Avoid idioms that don't translate well

## Formatting Standards

### Headings

- **H1 (#)**: Article title only, one per document
- **H2 (##)**: Major sections
- **H3 (###)**: Subsections
- **H4 (####)**: Rarely needed, use sparingly

Heading Rules:
- Use sentence case: "How to configure the system"
- Not title case: "How To Configure The System"
- Be descriptive and scannable
- Don't skip levels (H2 → H4)

### Lists

**Bulleted Lists** for unordered items:
- Start each item with capital letter
- End with period only if items are complete sentences
- Keep grammatical structure parallel

**Numbered Lists** for sequential steps:
1. Start with verb: "Click," "Configure," "Run"
2. Include expected results when relevant
3. Keep steps atomic (one action per step)

### Emphasis

- **Bold** for UI elements and emphasis: Click **Submit**
- *Italic* for introducing new terms: A *webhook* is...
- `Code font` for code, commands, filenames: Run `npm install`
- Don't overuse: Emphasis loses impact

### Code Blocks

Always specify language for syntax highlighting:

```javascript
// Good: Language specified
const example = "code";
```

Never omit language:
````
```
// Bad: No language
const example = "code";
```
````

Rules for code:
- Include comments for non-obvious logic
- Show complete, runnable examples when possible
- Use consistent indentation (2 or 4 spaces)
- Avoid overly long lines (wrap at ~80-100 characters)

### Links

**Descriptive link text** (not "click here"):
- Good: "See the [GitHub documentation](URL) for details"
- Bad: "Click [here](URL) for more information"

**External links**: Full reference in References section
**Internal links**: Relative paths to other articles
**Link format**: `[Link Text](URL)` for inline, `[URL]` for references

## Structure Standards

### Every Article Must Have

1. **Title** (H1): Clear, descriptive, engaging
2. **Introduction**: What, why, what you'll learn
3. **Table of Contents**: For articles > 500 words
4. **Body**: Organized with clear sections
5. **Conclusion**: Summary and next steps
6. **References**: All sources cited

### Optional but Recommended

- **Prerequisites section**: What readers need to know first
- **Code examples**: Real, tested examples
- **Images/diagrams**: Visual explanations when helpful
- **Troubleshooting**: Common issues and solutions
- **Next steps**: What to explore next

## Content Guidelines

### Introductions

Good introductions:
- State the topic clearly in first sentence
- Explain why it matters (motivate the reader)
- Preview what will be covered
- Note prerequisites if any
- Are 2-4 paragraphs

### Paragraphs

- Keep paragraphs short: 3-5 sentences ideal
- One main idea per paragraph
- Use topic sentences (main point first)
- Connect paragraphs with transitions

### Sentences

- Average 15-25 words per sentence
- Vary sentence length for readability
- Break complex ideas into multiple sentences
- Front-load important information

### Examples

- Include examples for abstract concepts
- Show before/after comparisons
- Provide both simple and complex examples
- Explain what the example demonstrates

## Technical Writing Specifics

### Instructions

**Action-oriented**:
- Start steps with verbs: "Click," "Open," "Type"
- Be specific: "Click the blue **Submit** button in the top right"
- Show expected results: "You should see a success message"

**Context when needed**:
- Explain why a step is necessary
- Note when multiple approaches exist
- Warn about consequences: "⚠️ This will delete all data"

### Code Documentation

- Comment your code examples
- Explain the logic, not just what the code does
- Show error handling
- Include setup/teardown if needed

### Version Information

- Specify versions: "Python 3.9+"
- Note breaking changes: "Changed in v2.0"
- Link to official changelogs
- Update when versions change

## References and Citations

### When to Cite

- Factual claims ("X is faster than Y")
- Statistics or data
- Quotes or paraphrases
- Technical specifications
- Best practices you didn't originate

### How to Cite

**In-line reference** (preferred):
> According to the [official documentation](URL), the default timeout is 30 seconds.

**Footnote style** (for multiple citations):
> The system uses webhooks[1] for real-time notifications[2].

Then in References:
```markdown
## References
1. [Webhooks Overview](URL) - Official documentation
2. [Real-time Systems](URL) - Academic paper
```

### Credible Sources

Prioritize:
1. Official documentation
2. Source code/repositories (for open source)
3. Academic papers
4. Well-maintained blogs (with author credentials)
5. Stack Overflow (for common issues, but verify)

Avoid:
- Outdated content (check dates)
- Unverified forums
- Paid/sponsored content (without disclosure)

## Special Elements

### Warnings and Notes

Use consistently:

**Note** (informative):
> **Note:** This feature requires Node.js 18+

**Warning** (caution):
> ⚠️ **Warning:** This operation cannot be undone

**Tip** (helpful hint):
> 💡 **Tip:** Use keyboard shortcuts to speed up your workflow

### Tables

- Use tables for structured comparisons
- Include header row
- Keep columns narrow (wrap text if needed)
- Align numbers right, text left

| Feature | Version | Status |
|---------|---------|--------|
| Hooks | 2.0+ | Stable |
| Plugins | 1.5+ | Beta |

### Quotes

> Use blockquotes for extended quotes or callouts

Cite source after quote:
> "The best code is no code at all." - Jeff Atwood

## Consistency Checklist

- [ ] Terminology consistent throughout
- [ ] Heading hierarchy logical
- [ ] Code formatting consistent
- [ ] List formatting parallel
- [ ] Voice/person consistent
- [ ] Version numbers specified
- [ ] Links all working
- [ ] Images have alt text
- [ ] References complete

## Common Mistakes to Avoid

❌ "You can do X or Y" (ambiguous)  
✅ "You can do either X or Y, depending on..."

❌ "Click here for more info" (vague link)  
✅ "See the [configuration guide](URL) for details"

❌ "It's really easy to..." (patronizing)  
✅ "To configure X, follow these steps..."

❌ Using jargon without definition  
✅ Define terms on first use or link to definitions

❌ Walls of text without breaks  
✅ Short paragraphs with white space

❌ "Just do X" (dismissive of complexity)  
✅ "To do X, you'll need to..." (acknowledges steps)

## Review Checklist

Before publishing, verify:
- [ ] Spell check passed
- [ ] Grammar correct
- [ ] Links working
- [ ] Code tested
- [ ] Images display
- [ ] Structure matches template
- [ ] Style guide followed
- [ ] Metadata complete
