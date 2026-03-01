# Article Creation Workflow

**Purpose**: Phase-based workflow for creating articles from concept to publication, referencing actual prompt files and validation tools.

**Referenced by**:
- `.github/prompts/01.00-article-writing/article-design-and-create.prompt.md`

---

## Workflow Overview

```
Planning → Research → Drafting → Validation → Review → Publication → Maintenance
```

---

## Phase 1: Planning

### Define Requirements

- **Topic**: Specific, scoped description
- **Audience**: Beginner / intermediate / advanced
- **Learning objectives**: 3–5 measurable outcomes
- **Prerequisites**: Existing knowledge assumed
- **Diátaxis type**: Tutorial / how-to / reference / explanation

### Select Template

Choose from `.github/templates/`:
- `article-template.md` — General explanatory content
- `howto-template.md` — Procedural guides
- `tutorial-template.md` — Hands-on learning

### Check for Existing Content

Search workspace for related articles to avoid duplication and identify linking opportunities.

---

## Phase 2: Research

### Source Discovery

1. **Official documentation** — Microsoft Learn, GitHub Docs, product docs
2. **Community best practices** — GitHub Blog, expert content, popular repos
3. **Adjacent topics** — What related concepts should be mentioned?
4. **Alternatives** — What competing tools/approaches exist?

### Reference Collection

Gather and classify all sources during research:
- 📘 Official | 📗 Verified Community | 📒 Community | 📕 Unverified
- No 📕 references in published content — find replacements

**Automation**: Use `article-design-and-create.prompt.md` — it handles research, source verification, and classification in Phases 2–4 automatically.

---

## Phase 3: Drafting

### Content Creation Options

**Option A — Automated**: Run `article-design-and-create.prompt.md` with topic, outline, and audience parameters. It produces a complete draft with dual YAML metadata, references, and proper structure.

**Option B — Manual**: Copy template structure, write sections according to outline, include code examples, add placeholder references to fill later.

### Draft Requirements

- Both YAML metadata blocks (top: Quarto, bottom: validation)
- Code blocks with language identifiers and explanatory comments
- Tables introduced with context sentences
- Jargon marked with `<mark>` on first use and explained

---

## Phase 4: Validation

Run validations in this order (skip if IQPilot handles automatically):

| # | Dimension | What to Check | Tool/Method |
|---|-----------|---------------|-------------|
| 1 | Structure | Required sections, heading hierarchy, Markdown | IQPilot or manual checklist |
| 2 | Grammar | Spelling, punctuation, contractions, capitalization | IQPilot, LanguageTool, or Vale |
| 3 | Readability | Flesch 50–70, FK 8–10, sentence length 15–25 | IQPilot or textstat |
| 4 | Logic | Concept order, transitions, prerequisites | Manual review |
| 5 | Facts | Claims verified, code tested, links valid, versions current | IQPilot or manual |
| 6 | Completeness | Core aspects covered, examples sufficient | IQPilot or gap analysis |
| 7 | Understandability | Audience-appropriate, jargon explained | Manual review |

**Validation criteria**: See `02-validation-criteria.md` for targets and pass/fail thresholds.

**AI content**: Tag factual claims with `[SPEC]`, `[INFERRED]`, or `[ASSUMED]` provenance markers.

---

## Phase 5: Review

### Self-Review Checklist

- [ ] Read as if you're the target audience
- [ ] All links verified and working
- [ ] Code examples tested
- [ ] Consistent terminology throughout
- [ ] Quality checklist from `article-writing.instructions.md` passed

### Cross-Reference Check

- Identify related articles to link
- Add prerequisite references
- Suggest "Next Steps" content
- If part of series: run `article-review-series-for-consistency-gaps-and-extensions.prompt.md`

---

## Phase 6: Publication

### Final Checks

1. All critical validations passed (grammar, structure, facts)
2. No broken links or placeholders
3. Metadata complete (top YAML + bottom validation HTML comment)
4. Reference classifications finalized

### Deploy

1. Add article to appropriate content folder
2. Update `_quarto.yml` if article should appear in navigation
3. Commit and push
4. Set review schedule: 90 days for technical, annually for concepts

---

## Phase 7: Post-Publication Maintenance

- **Quarterly**: Re-run fact-checking for technical content
- **With version updates**: Update examples, versions, screenshots
- **When links break**: Find replacements immediately (P1 priority)
- **Apply 20% rule**: Improve docs you touch by 20%

**Review trigger**: Use `article-review-for-consistency-gaps-and-extensions.prompt.md` for comprehensive reviews.

**Freshness scoring**: See `02-validation-criteria.md` → Content Freshness Scoring.

---

## Time Estimates

| Phase | Time | Notes |
|-------|------|-------|
| Planning | 30–60 min | Research and outline |
| Research + Drafting | 2–4 hours | Automated draft significantly faster |
| Validation | 30–60 min | Faster with IQPilot automation |
| Review | 30–60 min | Self-review and refinement |
| Publication | 15 min | Metadata and deployment |

---

## References

- **Internal:** `.github/prompts/01.00-article-writing/article-design-and-create.prompt.md`
- **Internal:** `.copilot/context/01.00-article-writing/02-validation-criteria.md`
- **Internal:** `.github/instructions/article-writing.instructions.md`
- **Internal:** `.github/templates/article-template.md`

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 2.0.0 | 2026-02-28 | Complete rewrite: replaced phantom prompt names with actual prompt files; consolidated 491 lines to ~160 lines; added validation dimension table referencing 02-validation-criteria.md; added AI provenance tags; added post-publication maintenance phase with freshness scoring reference. Source: 40.00-technical-writing articles 05, 07, 10 | System |
| 1.0.0 | 2025-12-26 | Initial version | System |
