# UC-15: Deterministic-first optimization

> **Group:** D - Efficiency and operating economics  
> **Priority:** P2  
> **Order in group:** 6 (run after UC-18)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-review --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim deterministic-first` (single artifact analysis)
- `/pe-meta-prompt-review <path> --dim deterministic-first` (prompt decomposition check)
- `/pe-meta-review --mode plan --skip research --dim efficiency` (broader efficiency sweep)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim deterministic-first` | Focus on `D21-deterministic-first` specifically |
| `--dim optimize` | Broader efficiency group including `D21-deterministic-first` |
| `--scope agents,prompts` | Artifacts with process phases to decompose |
| `--deps none` | Decomposition assessed per-artifact |
| `--skip research,structure,consistency` | Focus on deterministic-first analysis only |

## Behavior

Analyzes an artifact's process phases to identify steps where deterministic pre-processing can accelerate LLM reasoning — without reducing processing scope. Every step that currently uses LLM reasoning is assessed: can part of it be done deterministically first, with the LLM then reasoning over the structured output?

**Critical constraint**: Deterministic processing AUGMENTS reasoning — it never replaces it. Whatever the deterministic portion doesn't cover, LLM reasoning still handles at full scope. `D21-deterministic-first` proposes splits, not removals.

**Invocation examples:**
```
/pe-meta-agent-review pe-gra-agent-validator.agent.md --dim deterministic-first
/pe-meta-prompt-review pe-meta-review.prompt.md --dim deterministic-first
/pe-meta-review --mode plan --skip research --dim efficiency
```

**Dimensions covered:** `D21-deterministic-first`

**Checks performed:**
1. Read each process phase's step descriptions
2. For each step that implies LLM judgment, assess:
   - Does the step involve data extraction? (YAML parsing, grep, file listing) → deterministic
   - Does the step involve comparison against known patterns? (regex, template matching) → deterministic
   - Does the step involve counting or measuring? (token count, boundary count, tool count) → deterministic
   - Does the step involve semantic assessment? (quality judgment, contradiction detection, clarity evaluation) → LLM reasoning
3. For steps with mixed work: propose a **split** — deterministic extraction feeds structured data to the reasoning step
4. For steps already using deterministic tools: report as "already optimized"
5. For steps that are purely semantic: report as "reasoning required — no deterministic opportunity"

**Example output:**
```markdown
## D21-deterministic-first: Deterministic-first optimization report

| Phase | Step | Current approach | Deterministic portion | Reasoning remainder | Savings estimate |
|---|---|---|---|---|---|
| Phase 0 | Load artifact | `read_file` | ✅ Already deterministic | — | None needed |
| Phase 1 | Check tool alignment | Single LLM step | Parse `tools:` + `agent:` from YAML; compare tool list against 01.04 allowed sets | "Is tool X semantically appropriate for this agent's declared purpose?" | ~60% of step |
| Phase 0.5 | Classify change | LLM for all types | Diff analysis: whitespace-only → COSMETIC (deterministic). Removed/renamed sections → STRUCTURAL (deterministic) | VOCABULARY vs BEHAVIORAL distinction for content changes | ~30% of step |
| Phase 3 | Boundary assessment | LLM evaluates quality | Count items per tier (deterministic ≥5/2/3 check) | "Are boundaries actionable and testable?" | ~40% of step |
| Phase 5 | Production readiness | LLM evaluates 5 requirements | Count test scenarios (deterministic ≥3). Check Response Management section exists (deterministic) | "Are test scenarios covering the right edge cases?" | ~30% of step |
```

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ The analysis itself requires LLM reasoning (identifying what's deterministic requires understanding the step's semantics) |
| **False positives** | LOW — proposing a split that isn't useful is low-impact (the reasoning step still runs at full scope) |
| **False negatives** | MEDIUM — may miss deterministic opportunities in complex process descriptions |
| **Consistency** | ⚠️ Depends on LLM's ability to parse process phase descriptions accurately |

**Reliability score: MEDIUM** — the output is advisory (proposes optimizations), not blocking (doesn't change pass/fail). False positives are harmless — a proposed split that doesn't help is simply not implemented.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Identifies process phases where LLM tokens are consumed on work that deterministic tools could do faster and more reliably |
| **Real-world example** | Tool alignment check: parsing `tools: [read_file, grep_search]` from YAML is deterministic. Only "is grep_search appropriate for a validator?" needs LLM. Currently the entire step is LLM-driven |
| **Unique value** | Only dimension that optimizes the PROCESSING PIPELINE itself, not the artifact's content |
| **Safety** | ✅ Never reduces scope — the reasoning step always covers everything the deterministic step doesn't |

**Effectiveness score: MEDIUM-HIGH** — finds real optimization opportunities. Each applied split reduces token cost of that step by 30-60% while maintaining full quality coverage.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM — reads artifact process phases + reasons about each step |
| **Model routing** | Reasoning model (must understand process semantics to identify deterministic portions) |
| **Time** | 20-40s per artifact |
| **Recommended frequency** | After creating new agents/prompts; during efficiency-focused reviews (`--dim efficiency`) |
| **ROI** | HIGH — each finding, when implemented, saves tokens on every future invocation of the optimized artifact |

**Efficiency score: MEDIUM** — moderate cost to run, but findings have compounding returns (optimization applies to every future invocation).
