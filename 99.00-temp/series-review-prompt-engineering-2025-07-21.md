# Prompt engineering series — consistency, gaps, and extensions review

**Date:** 2025-07-21  
**Series:** Prompt Engineering for GitHub Copilot  
**Location:** `03.00-tech/05.02-prompt-engineering/`  
**Articles reviewed:** 29 (across 6 Diátaxis folders + ROADMAP)  
**Compliance baseline:** `40.00-technical-writing` rules + `article-writing.instructions.md`

---

## Executive summary

The series has **strong conceptual architecture** with proper Diátaxis organization and consistent topic coverage. However, **structural compliance with the technical writing rules is uneven** — the concept articles (01.xx) are well-formed, while the how-to articles (03.00–14.00) and analysis articles (20–22) had significant heading hierarchy violations, missing required sections, and severe size overruns.

### Health scores

| Category | Score | Notes |
|----------|:-----:|-------|
| **Architecture** | 8/10 | Diátaxis mapping is sound; folder structure matches purpose |
| **Heading hierarchy** | 10/10 | ✅ Fixed — all 29 articles now have exactly 1 H1, proper H2/H3 structure |
| **Size compliance** | 4/10 | 12 articles exceed 1000-line limit; 8 articles under 400 lines |
| **Required sections** | 6/10 | 6 articles missing Conclusion; 3 missing References |
| **Terminology consistency** | 7/10 | Generally good; some variations noted |
| **Cross-references** | 7/10 | Most articles link to related content; some gaps |

---

## Changes applied during this review

### Heading hierarchy fixes (20 articles)

All articles in the series used `# H1` for section headings instead of `## H2`, violating the "only ONE H1 per article" rule. Applied systematic fix: H1→H2 for sections, H2→H3 for subsections, preserving code block headings and `## Table of contents`.

**Articles fixed:**

| Folder | Articles |
|--------|----------|
| 01-overview | 01.01 |
| 02-getting-started | 02.00 |
| 04-howto | 03.00, 04.00, 05.00, 06.00, 07.00, 08.00, 08.01, 08.02, 08.03, 09.00, 09.50, 10.00, 11.00, 12.00, 13.00, 14.00 |
| 05-analysis | 20, 21.1 |

### Duplicate file removed

- **Deleted:** `02-getting-started/01.01-appendix_copilot_spaces.md`
- **Canonical:** `01-overview/01.01-appendix_copilot_spaces.md`
- **Reason:** Byte-for-byte duplicate (SHA256 confirmed identical)

### ROADMAP.md updated

- Moved 01.01 entry from `02-getting-started` to `01-overview` section
- Updated total count: 30 → 29 articles
- Updated last-modified date and change notes

---

## Remaining issues requiring action

### Priority 1 — Missing required sections

These articles lack required Conclusion and/or References sections per the writing rules:

| Article | Lines | Missing | Recommended action |
|---------|------:|---------|-------------------|
| **03.00** — Prompt file structure | 1,874 | Conclusion | Add `## 🎯 Conclusion` with key takeaways. Consider splitting first (see P2). |
| **06.00** — Skill file structure | 1,188 | Conclusion, References | Add both sections. Conclusion summarizing when/how to use skills, References with official docs. |
| **08.01** — OpenAI prompting guide | 743 | Conclusion | Add summary of key OpenAI-specific patterns. |
| **08.02** — Anthropic prompting guide | 888 | Conclusion | Add summary of key Claude-specific patterns. |
| **08.03** — Google prompting guide | 870 | Conclusion | Add summary of key Gemini-specific patterns. |
| **20** — Multi-agent prompt creation | 2,335 | References | Add `## 📚 References` with official documentation links. |
| **21.1** — Multi-agent plan V2 | 2,404 | Conclusion, References | Add both. This is an implementation plan — conclusion should summarize approach and outcomes. |
| **22** — Prompts and markdown structure | 327 | Conclusion | Add brief conclusion summarizing the site structure approach. |

### Priority 2 — Oversized articles (splitting candidates)

Per writing rules: >1,000 lines = splitting candidate. 12 articles exceed this limit.

| Article | Lines | Severity | Splitting recommendation |
|---------|------:|:--------:|------------------------|
| **21.1** — Multi-agent plan V2 | 2,404 | 🔴 Critical | Split into plan overview + detailed implementation phases |
| **20** — Multi-agent prompt creation | 2,335 | 🔴 Critical | Split into conceptual guide + worked example |
| **03.00** — Prompt file structure | 1,874 | 🔴 Critical | Split: core structure guide + advanced patterns + tools appendix |
| **04.00** — Agent file structure | 1,830 | 🔴 Critical | Split: core agent guide + advanced patterns + appendix |
| **13.00** — Token consumption | 1,478 | 🟠 High | Split: measurement/analysis + optimization strategies |
| **07.00** — MCP servers for Copilot | 1,410 | 🟠 High | Split: MCP fundamentals + server implementation patterns |
| **06.00** — Skill file structure | 1,188 | 🟡 Medium | Split: core skill guide + advanced patterns |
| **12.00** — Information flow | 1,175 | 🟡 Medium | Split: flow concepts + practical patterns |
| **09.00** — Agent hooks | 1,064 | 🟡 Medium | Could remain as-is with tighter editing |
| **09.50** — Tools in orchestrations | 1,059 | 🟡 Medium | Could remain as-is with tighter editing |
| **05.00** — Instruction file structure | 1,028 | ⚪ Low | Just over threshold; tighten prose |
| **02.00** — Naming and organizing files | 1,027 | ⚪ Low | Just over threshold; tighten prose |

### Priority 3 — Thin articles

These articles are under the 400-line "thin" threshold. Acceptable for their Diátaxis type (orientation, concept, reference) but could benefit from expansion:

| Article | Lines | Type | Notes |
|---------|------:|------|-------|
| 01.09 — Settings reference | 300 | Reference | Thin but typical for reference tables |
| 01.02 — Prompt assembly | 322 | Concept | Could expand with more diagrams/examples |
| 01.01 — Copilot Spaces | 325 | Appendix | Acceptable for appendix |
| 22 — Markdown structure | 327 | Analysis | Very thin for analysis; needs more depth |
| 01.08 — Chat modes | 354 | Concept | Could expand execution context details |
| 01.03 — Prompt files and instructions | 371 | Concept | Could expand layering examples |
| 01.00 — Customization stack | 374 | Orientation | Acceptable as entry point |
| 01.05 — Skills and hooks | 380 | Concept | Could expand hook lifecycle |

---

## Consistency analysis

### Structural pattern compliance

| Pattern | Concept (7) | How-to (16) | Analysis (3) | Reference (1) | Overview (2) | Getting-started (1) |
|---------|:-----------:|:-----------:|:------------:|:--------------:|:------------:|:-------------------:|
| Has TOC | 7/7 ✅ | 16/16 ✅ | 3/3 ✅ | 1/1 ✅ | 2/2 ✅ | 1/1 ✅ |
| Has Conclusion | 7/7 ✅ | 11/16 ⚠️ | 1/3 ⚠️ | 1/1 ✅ | 2/2 ✅ | 1/1 ✅ |
| Has References | 7/7 ✅ | 14/16 ⚠️ | 1/3 ⚠️ | 1/1 ✅ | 2/2 ✅ | 1/1 ✅ |
| Single H1 | 7/7 ✅ | 16/16 ✅ | 3/3 ✅ | 1/1 ✅ | 2/2 ✅ | 1/1 ✅ |
| In size range | 5/7 | 5/16 | 0/3 | 0/1 | 0/2 | 0/1 |

### Terminology observations

- **"prompt files"** vs **"prompt file"** — generally consistent  
- **"instruction files"** vs **"instructions"** — some variation  
- **"GitHub Copilot"** — consistently used (not "Copilot" alone)  
- **"YAML frontmatter"** vs **"YAML metadata"** — the former is standard across the series  
- **"Diátaxis"** — consistently spelled with accent  

### Cross-reference quality

Concept articles (01.xx) have strong internal cross-referencing via `## 🔎 Related articles in this series` sections. How-to articles generally link to prerequisites. The `ROADMAP.md` serves as a comprehensive index. Some analysis articles (20, 22) lack back-links to the main series.

---

## Coverage gaps and extension opportunities

### Existing gaps

1. **Testing and iteration** — Planned as 15.00 but not yet written. No article covers how to validate prompt effectiveness or run regression tests.

2. **Version control and maintenance** — Planned as 16.00 but not yet written. No guidance on prompt library versioning or deprecation.

3. **Team collaboration patterns** — No article addresses multi-author prompt management, review workflows, or conflict resolution.

4. **Performance benchmarking** — No article covers measuring prompt quality metrics, response latency impact, or A/B testing approaches.

5. **Security and guardrails** — Only lightly touched in hooks (09.00). No dedicated article on prompt injection defense, content filtering, or secure prompt patterns.

### Extension topics (not in ROADMAP)

6. **Debugging and troubleshooting prompts** — Common failure modes, diagnostic approaches, using Chat output panel for debugging.

7. **Migration guide** — How to upgrade from older Copilot customization patterns (e.g., `.github/copilot-instructions.md` only) to the full stack.

8. **Cross-IDE compatibility** — Article 01.09 covers settings, but a practical guide for maintaining prompts that work across VS Code, Visual Studio, JetBrains, and Neovim would be valuable.

9. **Enterprise deployment patterns** — Scaling prompt libraries across teams and organizations.

---

## Recommendations summary

### Immediate actions (no user input needed)

| Action | Status |
|--------|--------|
| Fix heading hierarchy across 20 articles | ✅ Done |
| Remove duplicate `01.01` file | ✅ Done |
| Update `ROADMAP.md` | ✅ Done |

### User-required actions

| Priority | Action | Effort |
|----------|--------|--------|
| 🔴 P1 | Add Conclusion sections to 6 articles (03.00, 06.00, 08.01–08.03, 22) | ~30 min each |
| 🔴 P1 | Add References sections to 3 articles (06.00, 20, 21.1) | ~15 min each |
| 🟠 P2 | Split 4 critically oversized articles (03.00, 04.00, 20, 21.1) | ~2 hr each |
| 🟡 P3 | Split 4 high/medium oversized articles (07.00, 13.00, 06.00, 12.00) | ~1 hr each |
| 🟡 P3 | Write planned articles 15.00 and 16.00 | ~4 hr each |
| ⚪ P4 | Expand thin concept articles with more examples | ~1 hr each |
| ⚪ P4 | Add validation metadata to all 29 articles | Automation via IQPilot |
| ⚪ P4 | Add emoji prefixes to remaining H2 headings missing them | ~15 min per article |

---

*Report generated by series review prompt. All heading hierarchy fixes were applied automatically. Splitting recommendations, missing sections, and extension topics require author decision.*
