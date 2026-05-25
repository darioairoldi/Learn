# UC-16: Context file optimization

> **Group:** A - Source-grounded freshness and lifecycle  
> **Priority:** P1  
> **Order in group:** 4 (run after UC-05)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-context-review <path> --dim context-optimization`  
**Alternative entry points:**
- `/pe-meta-update --mode plan --skip research --dim optimize --scope context` (optimization-focused health check)
- `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope context` (apply efficiency changes)
- `/pe-meta-scheduled-review --dim optimize --deps none` (periodic context efficiency sweep)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim context-optimization` | D22 context-specific optimization |
| `--dim context-health` | Combined D6–D11 + D22 for full context layer assessment |
| `--scope context` | Target context files (implicit for context-review) |
| `--deps none` | Assess targets in isolation (no consumer traversal) |
| `--skip research,consistency` | Focus on structural optimization only |

## Behavior

Reviews the context file SET as a system — checking organizational health, layer correctness, granularity, category mapping integrity, consumer load patterns, and topic coherence. This is distinct from D6-D11 which check individual file quality; D22 checks whether the files are optimally organized for their consumers.

Boundary note: this use case is optimization-scoped (D22) and does not replace full context quality lifecycle analysis. Full lifecycle handling of consistency, redundancy, staleness/source verification, completeness, and integration decisions is defined in UC-22.

**Invocation examples:**
```
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-optimization
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-health
/pe-meta-update --mode plan --skip research --dim context-optimization
```

**Dimensions covered:** D22 (context-optimization). Often combined with D6-D11 via `--dim context-health` for full context layer assessment.

**Checks performed:**

### 1. Layer correctness
For each rule in each context file:
- Is this a testable/mechanical rule (boolean pass/fail)? → Should be in an instruction file (R-S8)
- Is this behavioral/strategic guidance? → Correct in context file ✅
- Is this type-specific process logic? → Should be in an agent body

**Example findings:**
- "Rule 'YAML MUST have goal: field' in 01.01-context-engineering-principles.md is testable → candidate for instruction file pe-context-files.instructions.md"
- "Rule 'Use warm, conversational tone' in 01.01 is behavioral → correct in context file ✅"

### 2. Granularity assessment
- Count total files in the context folder
- Flag: >12 files (high reference overhead — consumers must load many files)
- Flag: <3 files (consolidated too aggressively — context rot risk per file)
- Flag individual files: >2,500 tokens (budget violation) or <200 tokens (too small — merge candidate)
- Compare file sizes: flag high variance (some files 2,400 tokens, others 150 tokens → rebalance)

### 3. Category mapping integrity
Read STRUCTURE-README.md → Functional Categories:
- For each category: do ALL mapped files exist? (missing file → broken reference)
- For each file: is it in at least one category? (unmapped file → orphan)
- Are there categories with 0 mapped files? (empty category → stale index)
- Are category IDs used by consumers? `grep_search` for each category ID across agents/prompts

### 4. Consumer load analysis
For each agent and prompt in the PE system:
- Which context files does it reference (`📖`, `context_dependencies:`, category references)?
- Total token cost of the referenced set
- Files referenced by >10 consumers (high-value — quality investment priority)
- Files referenced by 0 consumers (orphan — candidate for removal or merge)
- Consumers referencing >5 context files (heavy chain — simplification candidate)

### 5. Topic coherence
For each context file:
- Does `scope.covers:` match the actual section headings?
- Does the file cover one coherent topic, or does it mix unrelated concerns?
- For files covering multiple topics: propose split with topic-per-file
- For small files covering fragments of a topic: propose merge with the main topic file

### 6. Freshness distribution
- Compare `last_updated:` across all context files
- Flag files >6 months older than the set median
- Identify freshness clusters: "These 5 files were all last updated in March; these 12 haven't been touched since January"

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Granularity (file count, token count), category mapping, consumer count are deterministic. Layer correctness and topic coherence require LLM judgment |
| **False positives** | MEDIUM — granularity thresholds (12 files, 200 tokens) are guidelines, not hard rules; some legitimate cases exceed them |
| **False negatives** | LOW — deterministic checks (category mapping, orphan detection) have near-zero false negatives |
| **Consistency** | ✅ Deterministic portions are fully consistent. LLM portions (layer correctness) are mostly consistent |

**Reliability score: MEDIUM-HIGH** — the mix of deterministic + LLM checks provides good overall reliability. Deterministic portions (categories, orphans, token counts) are the anchors.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches organizational problems that individual file checks miss |
| **Real-world example** | 33 context files in one folder — some loaded by 20+ consumers, others by zero. Consumer load is unevenly distributed, and orphan files consume maintenance effort without value |
| **Unique value** | Only dimension that assesses the context layer AS A SYSTEM — file count, organization, consumer patterns |
| **Directly prevents** | Context rot from unmanaged growth, orphan files that nobody reads, consumer overload from too-heavy guidance chains |

**Effectiveness score: HIGH** — organizational issues have compounding effects. A poorly organized context layer degrades every consumer that loads from it.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM-HIGH — must read ALL context files + STRUCTURE-README + consumer references |
| **Model routing** | Deterministic for granularity/mapping/orphan checks. Standard model for layer correctness. Reasoning for topic coherence |
| **Time** | 2-5 minutes for a 33-file context folder |
| **Recommended frequency** | After adding/removing/splitting context files; during scheduled reviews; at phase transitions |

**Efficiency score: MEDIUM** — expensive but runs infrequently. Most valuable when the context folder has grown since the last review. The deterministic portions (category mapping, orphan detection, token counts) can run cheaply on every review; the LLM portions (layer correctness, topic coherence) should run only during scheduled reviews.

## Relationship to other dimensions

| Dimension | Scope | Overlaps with D22? |
|---|---|---|
| D6 (consistency) | Within-file contradictions | No — D22 checks organization, not rule consistency |
| D7 (non-redundancy) | Rule duplication across files | Partial — D22's topic coherence may detect overlap, but D7 checks at rule level |
| D10 (completeness) | Missing rules | No — D22 checks file-level gaps, D10 checks rule-level gaps |
| D12 (staleness) | Timestamp freshness | Partial — D22's freshness distribution uses the same timestamps but looks at the set pattern |
| D20 (token-chain) | Consumer loading cost | Partial — D22's consumer load analysis overlaps with D20 but adds orphan detection and consumer count |

**Key distinction**: D6-D11 answer "is this file's CONTENT good?" D22 answers "is this file's ORGANIZATION good?" Both are needed — a well-written file in the wrong layer or with zero consumers is still a problem.
