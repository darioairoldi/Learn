# UC-14: Platform release impact assessment

> **Group:** A - Source-grounded freshness and lifecycle  
> **Priority:** P0  
> **Order in group:** 2 (run after UC-22)

## Invocation

**Command family:** Release-diff  
**Primary entry point:** `/pe-meta-release-diff <url>`  
**Alternative entry points:**
- `/pe-meta-update --mode apply --scope context` (when release URL unavailable, manual mode)
- `/pe-meta-scheduled-review --dim freshness` (when triggered by recurring cadence after release)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim freshness` | Focus on staleness dimensions (D12, D13) |
| `--scope context` | Limit impact assessment to context files |
| `--scope agents,prompts` | Assess impact on consumer artifacts |
| `--skip structure` | Skip structural audit when only content impact matters |

## Behavior

Analyzes VS Code/Copilot release notes (or other platform changes) to identify which PE artifacts are affected and what changes are needed. This is the primary mechanism for detecting Type B staleness (capability obsolescence).

**Invocation examples:**
```
/pe-meta-release-monitor https://code.visualstudio.com/updates/v1_110
/pe-meta-update --mode plan --skip research --dim freshness
```

**Dimensions covered:** D12 (staleness) + external analysis

**Workflow:**
1. Fetch release notes via `fetch_webpage`
2. Extract PE-relevant changes (new YAML fields, tool behavior changes, deprecations, GA transitions)
3. For each change: identify affected PE artifacts by scope matching (artifact's `scope.covers` vs. release change topic)
4. Classify impact per affected artifact: COSMETIC / STRUCTURAL / BEHAVIORAL
5. For high-impact changes: produce targeted update specifications
6. For low-impact changes: produce batch update recommendations
7. Output: impact report with per-artifact action items

**Example findings:**
- "VS Code 1.110: `tools:` array now supports `run_in_terminal` without async mode → update `01.04-tool-composition-guide.md` tool description"
- "Copilot: new YAML field `capabilities:` is now required → update `00.03-metadata-contracts.md` + all agents missing the field"
- "Copilot Spaces moved from preview to GA → update `03.05-copilot-spaces-patterns.md` to remove preview caveats"

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM reasoning to extract PE-relevant changes from release notes |
| **False positives** | MEDIUM — may flag irrelevant changes as PE-relevant (e.g., editor UI changes that don't affect PE) |
| **False negatives** | MEDIUM — may miss subtle changes (e.g., behavior change not mentioned in release notes) |
| **Consistency** | ⚠️ Depends on release notes format and LLM interpretation |

**Reliability score: MEDIUM** — release notes are human-written and vary in format. Mitigated by (1) structured extraction prompts, (2) scope matching against artifact `scope.covers:` metadata.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Primary mechanism for detecting Type B staleness — the vision's hardest problem |
| **Real-world example** | Copilot Spaces moving from preview to GA while 03.05 still says "public preview" |
| **Unique value** | Only mechanism that connects external platform changes to internal artifact impact |
| **Directly prevents** | Artifacts encoding obsolete guidance about platform capabilities |

**Effectiveness score: VERY HIGH** — addresses the vision's primary motivating concern. Without it, Type B staleness is only detected through scheduled reviews or human observation.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | HIGH — fetches external page + reads multiple PE artifacts for scope matching |
| **Model routing** | Reasoning model for change extraction and scope matching; `fetch_webpage` for source access |
| **Time** | 2-5 minutes per release (depends on release scope) |
| **Recommended frequency** | After every VS Code/Copilot release (monthly); after major model provider updates |

**Efficiency score: LOW-MEDIUM** — expensive but triggered infrequently (monthly). Cost is justified by the high value of early Type B staleness detection. Can be optimized by caching the change digest and reusing it across multiple artifact assessments.
