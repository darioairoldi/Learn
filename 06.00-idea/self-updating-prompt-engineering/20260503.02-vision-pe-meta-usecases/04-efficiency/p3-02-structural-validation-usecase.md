# UC-01: Structural validation

> **Group:** D - Efficiency and operating economics  
> **Priority:** P3  
> **Order in group:** 8 (run after UC-09)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-review <path> --dim structural --skip research,consistency,content`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim structural` (agent structure validation)
- `/pe-meta-context-review <path> --dim metadata` (metadata check)
- `/pe-meta-update --mode plan --skip research --dim structural` (system-wide structural baseline)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim structural` | Focus on `D1-metadata` through `D4-tool-alignment` (metadata, references, tokens, tools) |
| `--dim metadata` | `D1-metadata` only (YAML validation) |
| `--dim references` | `D2-references` only (reference integrity) |
| `--scope agents` | Validate agent artifacts |
| `--scope context` | Validate context file metadata |
| `--scope prompts` | Validate prompt artifacts |
| `--deps none` | Structural validation is per-artifact |
| `--skip research,consistency,content` | Deterministic checks only |

## Behavior

Validates deterministic structural properties of any PE artifact: YAML metadata presence, reference integrity, tool alignment, and token budget compliance. No LLM reasoning required — all checks are boolean pass/fail.

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim structural
/pe-meta-context-review 01.04-tool-composition-guide.md --dim metadata
/pe-meta-prompt-review pe-meta-review.prompt.md --dim references
```

**Dimensions covered:** `D1-metadata`, `D2-references`, `D3-token-budget`, `D4-tool-alignment`

**Checks performed:**
- `D1-metadata`: Are `goal:`, `scope:`, `boundaries:`, `rationales:`, `version:` present in YAML?
- `D2-references`: Do all `📖` references, markdown `[text](path)` links, and `/slash-command` references resolve to existing files?
- `D3-token-budget`: Is the artifact within its type-specific token budget (from 01.06)?
- `D4-tool-alignment`: Does `agent: plan` have only read-only tools? Does `agent: agent` include write tools? Is tool count 3-7?

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ✅ Fully deterministic — same input always produces same result |
| **False positives** | Near-zero — checks are boolean (field exists or doesn't, file resolves or doesn't) |
| **False negatives** | Near-zero for `D1-metadata` through `D4-tool-alignment`; possible for `D2-references` if a reference uses an unexpected pattern |
| **Consistency** | ✅ Results identical across consecutive runs |

**Reliability score: HIGH** — deterministic checks are the most reliable review type. No LLM judgment involved.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches broken references (174 in the slash-command incident), missing metadata, tool misalignment |
| **Misses** | Cannot detect semantic issues (contradictions, ambiguity, staleness of logic) |
| **Scope** | Structural correctness only — necessary but not sufficient for quality |

**Effectiveness score: MEDIUM** — catches infrastructure-level issues reliably but misses content-level problems. Best used as a first pass before semantic dimensions.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | Near-zero — can be done with deterministic tools (YAML parsing, file existence checks, line counting) |
| **Model routing** | Small model or no model — `grep_search`, `file_search`, `read_file` with YAML parsing |
| **Time** | Seconds per artifact |
| **Recommended frequency** | On every change; on every review (always included as baseline) |

**Efficiency score: HIGH** — cheapest useful review dimension. Should always be included even in targeted reviews.
