# UC-05: Staleness and source verification

> **Group:** A - Source-grounded freshness and lifecycle  
> **Priority:** P1  
> **Order in group:** 3 (run after UC-22 and UC-14)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode plan --skip research --dim freshness`  
**Alternative entry points:**
- `/pe-meta-context-review <path> --dim freshness` (single-artifact review)
- `/pe-meta-scheduled-review --dim freshness --deps direct` (recurring freshness sweep)
- `/pe-meta-release-diff <url>` (when triggered by an external release)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim freshness` | Limits to D12 (staleness) and D13 (source-verification) |
| `--scope context` | Focus on context files (most staleness-prone) |
| `--deps direct` | Check immediate consumers of stale artifacts |
| `--skip structure,consistency` | Skip non-relevant audit phases for speed |
| `--skip research` | Local-only mode — no external source fetch |

## Behavior

Checks whether an artifact's content is still current — both its internal timestamps and the external sources it cites. Detects Type B staleness (logic is obsolete even though structure is intact).

**Invocation examples:**
```
/pe-meta-context-review 03.02-model-specific-optimization.md --dim staleness
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim freshness
/pe-meta-update --mode plan --skip research --dim freshness
```

**Dimensions covered:** D12 (staleness), D13 (source-verification)

**Checks performed:**
- D12: Is `last_updated` older than the configurable staleness window (default 90 days)? Have referenced external sources been updated since the artifact was last reviewed? Are there platform changes (from change digest) that affect this artifact's scope?
- D13: Do cited URLs still resolve (HTTP HEAD check)? Do cited sources still support the claims made in the artifact? Has the cited source been updated with content that contradicts the artifact?
- Source intake mode: include authoritative default sources and user-provided sources in one evidence set; apply the same trust and relevance checks to both before integration recommendations.

**Handoff outputs for context lifecycle integration:**
- Stage-1 impact packet: impacted contexts, impacted dimensions, and claim-to-source evidence mapping.
- Stage-2 structure-decision input: recommended structural action (`no-change`, `split`, `merge`, `create`, `retire`, `remap`) with confidence and risk level.
- Integration gate signal: `apply-autonomously`, `require-approval`, or `report-only` based on evidence quality and risk.

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ D12 timestamp checks are deterministic; D13 source content comparison requires LLM |
| **False positives** | MEDIUM — an artifact may be flagged as stale even if its content is still correct (source updated but the relevant section unchanged) |
| **False negatives** | MEDIUM — sources that changed without updating their URL won't be caught by HTTP HEAD alone |
| **Consistency** | ✅ Timestamp checks are consistent; source content comparison depends on source availability |

**Reliability score: MEDIUM** — timestamp staleness is reliable; content staleness detection depends on source accessibility and LLM comparison quality. External source downtime causes false negatives.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches Type B staleness — the vision's primary motivating concern |
| **Real-world example** | Context file references "Copilot Spaces (public preview)" when the feature moved to GA 3 months ago |
| **Unique value** | Only dimension that detects LOGIC staleness (everything else checks structure or consistency) |

**Effectiveness score: HIGH** — this is the dimension that addresses the vision's hardest problem (Type B staleness). Without it, artifacts can pass all structural checks while encoding obsolete guidance.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | D12: LOW (timestamp comparison). D13: MEDIUM-HIGH (requires `fetch_webpage` + LLM comparison per source) |
| **Model routing** | D12: deterministic + standard model. D13: standard model + `fetch_webpage` |
| **Time** | D12: 5-10s. D13: 30-60s (network-dependent) |
| **Recommended frequency** | D12: every review (cheap). D13: monthly or after platform releases (expensive) |

**Efficiency score: MEDIUM** — D12 is cheap and should run frequently; D13 is expensive and should run selectively (triggered by platform events or scheduled reviews, not on every change).
