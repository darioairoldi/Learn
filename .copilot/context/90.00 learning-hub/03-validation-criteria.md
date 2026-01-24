# Learning Hub Validation Criteria

This document defines validation criteria and quality thresholds specific to the Learning Hub documentation site. These supplement the general validation criteria found in `.copilot/context/01.00 article-writing/02-validation-criteria.md`.

## Repository-Specific Standards

### Content Lifecycle

**Status Values:**
- **draft**: Initial creation, not validated
- **in-review**: Validations in progress
- **published**: Approved and live
- **archived**: Outdated but kept for reference

```
Draft → In-Review → Published → [Updates/Revisions] → Archived
```

### Metadata Requirements

**Complete Metadata:**
```yaml
✅ Title, author, dates filled
✅ Tags relevant and complete
✅ Status appropriate for content state
✅ Series info (if applicable)
✅ All validation sections updated
✅ Cross-references current
✅ Analytics computed
```

**Validation History:**
- Timestamps recent (< 7 days for critical validations)
- Models used noted
- Outcomes recorded
- Issues documented

### Series-Specific Validation

**Series Consistency:**
- Terminology consistent across articles
- Style and format uniform
- Cross-references working
- Non-redundant (or justified redundancy)
- Logical progression

**Series Completeness:**
- All promised topics covered
- Prerequisites clear
- Navigation functional
- Gaps between articles bridged

## Learning Hub Content Types

### Session Analyses (Event Summaries)

**Required Sections:**
- Session metadata (speaker, date, event)
- Key takeaways (bulleted list)
- Detailed notes
- Related resources
- Classification of all references (📘📗📒📕)

**Validation Focus:**
- Accuracy of session attribution
- Correct speaker information
- Timely publication (within 2 weeks of event)

### Technical Articles

**Required Sections:**
- Introduction with learning objectives
- Prerequisites stated
- Table of contents
- Conclusion with next steps
- References with classification

**Validation Focus:**
- Code examples tested and working
- Version information current
- Official documentation links verified

### HowTo Guides

**Required Sections:**
- Clear objective statement
- Prerequisites checklist
- Numbered steps
- Expected outcomes
- Troubleshooting section

**Validation Focus:**
- Steps complete and reproducible
- No assumed knowledge gaps
- Environment requirements specified

### Project Documentation

**Required Sections:**
- Project overview
- Architecture decisions
- Implementation details
- Future considerations

**Validation Focus:**
- Current with actual codebase
- Links to relevant source files
- Updated when code changes

## Validation Caching Rules

### 7-Day Caching Policy

Skip validation if ALL conditions met:
- Previous validation outcome was "passed"
- Content unchanged since last validation
- Validation timestamp < 7 days old
- Same validation type requested

Re-validate if ANY condition true:
- Content has been modified
- Previous outcome was not "passed"
- Validation older than 7 days
- Technology/version has major update

### Cache Bypass Triggers

Always re-validate:
- `--force` flag specified
- Article status changing to "published"
- External links need verification
- Technology has security update

## Reference Classification (Learning Hub)

All references must use the classification system:

| Marker | Category | Trust Level |
|--------|----------|-------------|
| 📘 | Official | Highest |
| 📗 | Verified Community | High |
| 📒 | Community | Medium |
| 📕 | Unverified | Low/None |

See `.copilot/context/90.00 learning-hub/04-reference-classification.md` for complete rules.

## Quality Maintenance Schedule

### Quarterly Review

For all published content:
- Check fact currency
- Update version information
- Verify external links
- Assess if content needs refresh

### Annual Review

Comprehensive evaluation:
- Full validation run
- Gap analysis
- Audience relevance check
- Consider if content should be archived

### Event-Triggered Review

When external changes occur:
- Technology major version release
- Breaking API changes
- Security vulnerabilities discovered
- Official documentation restructured

## Cross-Reference Standards

### Related Articles

Each article should identify:
- **Prerequisites**: What readers should know first
- **Related**: Topics at similar complexity
- **Advanced**: Next-level concepts building on this

### Series Navigation

Articles in a series must have:
- Series name in metadata
- Previous/next article links
- Series index reference
- Consistent terminology with series

## IQPilot Integration

When IQPilot MCP server is enabled:
- Validation results cached in article metadata
- Automatic 7-day cache expiry
- 16 specialized tools available
- Cross-reference validation automated

See `GETTING-STARTED.md` for IQPilot configuration.
