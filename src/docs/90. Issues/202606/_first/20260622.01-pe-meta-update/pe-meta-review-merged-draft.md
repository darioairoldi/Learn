# DRAFT: Merged `pe-meta-review` Specification

## Executive Summary

Consolidates `pe-meta-review` (strategic validation) and `pe-meta-update` (9-phase ecosystem optimization) into a **single unified command** while maintaining the vision v15's core principles:

- **Predictability** — First-line `Resolved invocation:` log always shows what will execute
- **Minimal-consistent-option-surface** — The canonical **eight parameters** (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`, `--plan-file`) + `bundle=accept` — **no new flags**. Strategic vs. comprehensive is expressed entirely through `--dim` (the canonical groups in [05.07-pe-meta-dimension-catalog.md](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)); there is **no `--strategy` flag**
- **Default-full invocation contract** — Parameter-less = full sweep; trigger-fired = incremental
- **Risk-calibrated autonomy** — Non-breaking changes proceed autonomously; breaking escalate
- **Design/review parity** — Same quality objective; role differs by process & permission

---

## YAML Frontmatter (Merged Prompt)

```yaml
---
name: pe-meta-review
description: "Unified PE artifact validation and optimization — strategic, structural, consistency, content, freshness, and reliability assessment selected via the canonical --dim groups (05.07 dimension catalog). Single file/folder/multifile scope via --scope; defaults to comprehensive full sweep (--dim full --deps full --mode apply). Phase 0a conversational pre-parser resolves intent to canonical parameters; Phase 0b domain-coherence gate; Phases 1-4 audits (research/organizational/structure/consistency/content); Phase 4.5 strategic validation when --dim includes strategic dimensions (D15-D19); Phases 5-7 risk-classified execution; Phase 8 report. First-line Resolved invocation: log emitted before Phase 1; plan always materialized on mutating runs."
agent: agent
model: claude-opus-4.6
tools:
  - semantic_search
  - read_file
  - file_search
  - grep_search
  - list_dir
  - replace_string_in_file
  - create_file
handoffs:
  - label: "Research & Analysis"
    agent: pe-meta-researcher
    send: true
  - label: "Structural Validation"
    agent: pe-con-validator
    send: true
  - label: "Ecosystem Coherence"
    agent: pe-meta-validator
    send: true
  - label: "Fix Non-breaking Issues"
    agent: pe-con-builder
    send: true
  - label: "Optimize Complex Scope"
    agent: pe-meta-optimizer
    send: true
argument-hint: '[--mode plan|apply] [--scope <artifact-type-token>|<path>[,<path>...]] [--source <source-id>|<url>[,...]] [--dim <group|D#-readable-id>[,...]] [--start <date|version>] [--end <date|version>] [--deps none|direct|full|<N>] [--skip <stage>[,...]] [--plan-file <path>] [bundle=accept]'
goal: "Produce a unified validation & optimization report covering strategic alignment, structural correctness, consistency, and content quality — with optional research-driven ecosystem integration — under risk-calibrated autonomy that preserves design/review parity and honors the vision v15 default-full invocation contract"
scope:
  covers:
    - "Single file OR folder (ends /) OR multifile (comma-separated) via --scope; expands to full dependency tree when --deps full specified"
    - "Dimension selection via the canonical --dim parameter ONLY (no --strategy flag): groups (full, structural, quality, strategic, freshness, efficiency, adherence, reliability, optimize, model, context-full, context-health) or specific D#-readable-id dimensions, per 05.07-pe-meta-dimension-catalog.md. 'Strategic validation' = --dim strategic; 'comprehensive optimization' = --dim full (the default)"
    - "The canonical eight parameters per vision v15.4 — --mode, --scope, --source, --dim, --start/--end, --deps, --skip, --plan-file — plus bundle=accept consent; NO additional flags (no --strategy)"
    - "Phase 0a conversational pre-parser: free-form scoping intent (subjects, concerns) resolved to canonical parameters BEFORE strict parsing"
    - "Phase 0b domain-coherence gate: metadata-first 3-tier domain resolution; seed-vs-deps footprint computation; multi-domain gating with bundle=accept consent"
    - "Phase 1 research (gated by --dim freshness / --skip research): monitor authoritative sources per domain_profile:; scan external ecosystem; analyze outcome history; produce change digest"
    - "Phase 1.5 organizational pass (optional, --skip organizational): assess structural clarity, layer correctness, dependency organization, coverage gaps"
    - "Phases 2-4 audit suite mapped from --dim: Phase 2 structure (--dim structural: D1-metadata..D5-boundaries, D14-craftsmanship); Phase 3 consistency + Phase 4 content (--dim quality: D6-consistency..D11-actionability, D27-model-adherence)"
    - "Phase 4.5 strategic validation (when --dim includes strategic dimensions D15-vision-alignment, D16-adherence, D17-cross-coherence, D19-artifact-structure): vision alignment, category reference compliance, PE quality bar, N-1 separation audit, self-update readiness, ecosystem-impact scoring"
    - "Phases 5-7 risk-classified execution: non-breaking changes proceed autonomously per risk-assessment; breaking changes + high-risk low-confidence findings escalate for human approval"
    - "Phase 8 consolidated report: first-line Resolved invocation: log + severity-ranked findings + plan materialization + spillover markers"
    - "First-line Resolved invocation: log ALWAYS emitted before Phase 1 runs; echoed in Phase 8 report; format: --mode=… --scope=… --source=… --dim=… --start=… --end=… --deps=… --skip=… --plan-file=… | breadth=… | caller=… | bundle=… | spillover=…"
    - "Always plan-then-execute (vision v15.4): --mode apply materializes/reconciles plan (Phases 1-4) then executes it (Phases 5-7); --mode plan stops after plan materialization"
    - "Model-routing seam: Phases 1-4 on reasoning-grade model; Phases 5-7 on standard-grade model (per delegated agent's model:)"
    - "Default-full invocation contract: parameter-less manual invocation = full sweep (--dim full, all deps); trigger-fired = incremental (changed artifacts + direct dependents); --start/--end = bounded-delta"
  excludes:
    - "Vision document modifications (human-only, per v15.4 boundaries)"
    - "Individual artifact creation (per-artifact pe-meta-{type}-create-update prompts handle this)"
    - "Domain artifacts (article-writing, documentation — use /pe-con-review)"
boundaries:
  - "MUST emit first-line Resolved invocation: log before Phase 1 runs, echoing it in Phase 8 report"
  - "MUST parse the canonical eight parameters (--mode, --scope, --source, --dim, --start/--end, --deps, --skip, --plan-file); REJECT any other --* flag (including any --strategy) with CF-05 deprecation notice"
  - "MUST derive breadth (full|incremental|bounded-delta) per vision v14 rule #2 and emit it in Resolved invocation: log"
  - "MUST run Phase 0a (conversational pre-parser) when non-canonical tokens appear; canonical resolution MUST be echoed before Phase 1"
  - "MUST run Phase 0b (domain-coherence check) between Phase 0a and Phase 1 on every invocation; NOT skippable"
  - "MUST compute seed footprint (resolved --scope) and dependency footprint (seed + --deps closure) SEPARATELY in Phase 0b; emit bundle=… marker"
  - "MUST accept bundle=accept ONLY (closed set); REJECT all other bundle=… values with CF-05"
  - "MUST resolve --dim against the 05.07 dimension catalog ONLY; REJECT --dim aliases that span disjoint dimension sets with CF-05 (per catalog boundary); bare D# input resolves to its D#-readable-id"
  - "MUST NOT treat --dim as domain override — domain footprint always computed from per-file domain: metadata regardless of --dim"
  - "MUST treat structural findings (--dim structural) as PASS or FAIL (blocks Phase 4.5 if structural FAIL and --dim includes strategic dimensions D15-D19); strategic findings as advisory-only (separate severity channel)"
  - "MUST classify every proposed change as breaking|non-breaking and assess confidence (machine-verifiable|validated|LLM-judgment) BEFORE execution decision"
  - "MUST NOT execute breaking changes or low-confidence changes without human approval, regardless of --mode identity"
  - "MUST delegate structural validation to pe-con-validator; strategic validation to pe-meta-validator (if high-impact); execution to pe-con-builder / pe-meta-optimizer"
  - "MUST honor risk-calibrated autonomy: non-breaking + high-confidence changes proceed autonomously in --mode apply; all other changes proposed for human review"
  - "MUST materialize plan on every mutating run (both --mode plan and --mode apply); --mode apply additionally executes via one execution engine"
  - "MUST emit spillover plan when per-cycle iteration budget exceeded, per vision v15.4 § Iteration budget"
  - "Design/review parity contract: Both validate against the same six guidance-quality properties (clarity, non-redundancy, non-contradiction, completeness, prioritization, actionability). Role differs by process and mutation permissions, not quality ambition."
rationales:
  - "One command eliminates cognitive overhead — users learn pe-meta-review; intent expressed entirely through the canonical --dim groups, with no parallel --strategy flag to remember"
  - "Composition via --dim preserves flexibility while honoring minimal-consistent-option-surface — no special flags for special cases; strategic vs comprehensive is just --dim strategic vs --dim full"
  - "--dim resolves against the single authoritative 05.07 dimension catalog, so the same group names mean the same thing across every /pe-meta-* command and every use-case document"
  - "Default --dim full --deps full --mode apply reflects comprehensive intent; users who want strategic-only use --dim strategic"
  - "Risk-calibrated autonomy honors vision P0 safe-by-default while enabling efficiency — non-breaking changes don't wait for approval"
  - "Strategic validation runs AFTER structural passes (Phase 4.5) so structural findings are available for context; separate severity channel so structural FAIL ≠ strategic advisory block"
  - "First-line Resolved invocation: log is the observable proxy for default-full contract — predictability is the foundation"
---

# Unified PE Artifact Review & Optimization

One command, composable by dimension, preserving design/review parity under risk-calibrated autonomy. Handles strategic validation (is this artifact PE-standards compliant?) and comprehensive optimization (improve this artifact + ecosystem) in a single unified flow, with defaults tuned to the comprehensive workflow.

## Quick Reference

| Task | Command |
|---|---|
| "Is this artifact PE-compliant?" | `pe-meta-review --scope file.md --dim strategic --mode plan` |
| "Optimize this artifact" | `pe-meta-review --scope file.md --mode apply` (comprehensive, default) |
| "Only check structure/consistency, skip research" | `pe-meta-review --scope file.md --dim structural,quality --skip research` |
| "Full ecosystem audit" | `pe-meta-review --mode plan` (all artifacts, --dim full, plan-only) |
| "Bounded-delta check (last 7 days)" | `pe-meta-review --start 2026-06-15 --end 2026-06-22` |
| "Specific dimensions composable" | `pe-meta-review --scope folder/ --dim strategic,freshness --mode apply` |

## Invocation Parameters (Canonical Eight + bundle consent)

### `--scope <path|type|comma-list>` (default: all)

| Value shape | Meaning | Example |
|---|---|---|
| `.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md` | Single file | Target one artifact |
| `.github/prompts/` | Folder (ends /) | All prompts in folder |
| `prompts` | Artifact-type token | All prompts in the system |
| `prompts,context,agents` | Comma-separated types | Multiple artifact types |
| `.github/prompts/file.md,.github/agents/agent.md` | Comma-separated paths | Specific multifile set |
| (omitted) | All artifacts | Full ecosystem sweep (default-full) |

### `--dim <group|D#-readable-id>[,...]` (composable audit dimensions, default: `full`)

Dimensions are defined **authoritatively** in [05.07-pe-meta-dimension-catalog.md](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) (35 dimensions, `D1-metadata` … `D35-portability-boundary`). `--dim` selects which dimensions the audit phases exercise. There is **no `--strategy` flag** — "strategic" and "comprehensive" are simply two `--dim` values.

| `--dim` group | Catalog dimensions (summary) | Maps to phase(s) |
|---|---|---|
| `full` *(default)* | All 35 | 1, 1.5, 2, 3, 4, 4.5 |
| `structural` | `D1-metadata`–`D5-boundaries`, `D14-craftsmanship` | 2 |
| `quality` | `D6-consistency`–`D11-actionability`, `D27-model-adherence` | 3, 4 |
| `strategic` | `D15-vision-alignment`, `D16-adherence`, `D17-cross-coherence`, `D19-artifact-structure` | 4.5 |
| `freshness` | `D12-staleness`, `D13-source-verification` | 1 |
| `efficiency` | `D3`, `D4`, `D7`, `D9`, `D11`, `D20`, `D21`, `D23`–`D26` | 1.5, 4 |
| `adherence` | `D5-boundaries`, `D6-consistency`, `D16-adherence`, `D18-coverage` | 3, 4, 4.5 |
| `reliability` | `D28-reproducibility`–`D35-portability-boundary` | 4.5 |
| `optimize` | efficiency subset; delegates apply to `@pe-meta-optimizer` | 4, 5–7 |
| `model` | `D26-model-routing`, `D27-model-adherence` | 4 |
| `context-full` / `context-health` | context-file dimension sets | 2, 3, 4 |

**Composition:** `--dim strategic,freshness` runs vision-alignment + staleness only. Bare `D#` is accepted as input (`--dim D6` → `D6-consistency`). Per the catalog boundary, `--dim` aliases that resolve across **disjoint** dimension sets are rejected with CF-05 — the caller must pick a canonical group explicitly.

### `--mode plan | apply` (default: apply)

| Value | Behavior | Plan materialized? | Execution? |
|---|---|---|---|
| `apply` | **Assess → materialize plan → execute** (default) | ✅ Yes (always) | ✅ Yes (risk-classified) |
| `plan` | **Assess → materialize plan → stop** | ✅ Yes (always) | ❌ No |

Both modes materialize the same plan. The only difference is whether execution happens. See [pe-meta-plan-file-contract.md](...) for plan output format.

### `--deps none | direct | full | <N>` (default: full)

| Value | Meaning |
|---|---|
| `none` | Only the resolved --scope artifacts; no dependency expansion |
| `direct` | Resolved scope + their immediate dependents only |
| `full` | Resolved scope + entire transitive closure (default, comprehensive-intent) |
| `3` | Resolved scope + up to 3 levels of cascade depth |

### `--skip research,organizational,domain-coherence,...` (optional)

Comma-separated phases to skip. **Only skippable phases:**

| Phase | Skippable | Effect if skipped |
|---|---|---|
| research | ✅ Yes (rule #2 applies) | No external-source monitoring; local-only assessment |
| organizational | ✅ Yes | Skip layer-correctness & dependency-organization audit |
| structure | ❌ No (structural is baseline) | Rejected with CF-05 |
| consistency | ✅ Yes | Skip non-redundancy/non-contradiction audit |
| content | ✅ Yes | Skip guidance-quality assessment |
| domain-coherence | ❌ No (baseline gate) | Rejected with CF-05 |

**Rule #2 (from vision v14):** `--skip research` is incompatible with derived `breadth=full` UNLESS `--plan-file` references a validated baseline plan. If present, the baseline substitutes for research (trust-mode), but the cross-run drift guard is REQUIRED.

### `--start DATE | VERSION` and `--end DATE | VERSION` (bounded-delta)

Limits assessment to artifacts/changes within a date or version window. Triggers `breadth=bounded-delta`. Window semantics:

- `--start 2026-06-15` = from this date onward (typically now)
- `--end 2026-06-22` = up to this date
- Both together = inclusive range
- Either one = bounded-delta breadth

### `--source SOURCE_ID | URL,...` (research scope)

Comma-separated list of authoritative source identifiers or URLs to monitor. Defaults to per-domain sources from `domain_profile:` manifests.

Examples:
- `--source external-knowledge` = use all sources declared in vision § External knowledge
- `--source https://learn.microsoft.com/en-us/docs/vscode` = monitor this URL
- `--source vscode-release-notes,copilot-docs,community-ecosystem` = specific sources

### `--plan-file <path>` (plan location/identity)

Sets plan file location ONLY; never decides regenerate-vs-trust. Supplied → baseline; reconciles with assessment if running Phase 1, trusts if `--skip research` + same-conversation prior baseline exists. Default auto-name: `.copilot/temp/pe-meta-state/plans/YYYYMMDD-HHMMSS-<kebab-name>.plan.md`.

### `bundle=accept` (multi-domain consent token)

**Closed set:** only valid value is `accept`. Used to bypass multi-domain gating when Phase 0b detects cross-domain scope. Recorded on first-line `Resolved invocation:` log as `bundle=accepted-bundle`.

---

## Process: Nine Phases (Vision v15.4 Compliant)

### Phase 0a: Conversational Pre-Parser

**Goal:** Resolve free-form scoping intent to canonical parameters BEFORE strict parsing.

**Input:** Any non-canonical token or free-form text (e.g., "review my agents", "check the last update", "validate context files").

**Process:**
1. LLM reads the free-form input
2. Infer intended --scope, --dim, --deps, --start/--end, --mode from context
3. Echo resolved parameters back to user: "Resolved: --scope agents --dim strategic --deps none --mode plan"
4. Proceed to Phase 0b with resolved parameters

**Output:** Canonical parameters ready for Phase 0b.

### Phase 0b: Domain-Coherence Gate (Non-skippable)

**Goal:** Compute seed footprint (resolved --scope) and dependency footprint (seed + --deps closure) separately; emit bundle=… marker; gate multi-domain scope per vision v15.4 § Domain-coherent batching.

**Process:**
1. Resolve per-file `domain:` metadata (Tier 1 declared domain, Tier 2 path heuristic, Tier 3 unknown fallback)
2. Compute seed footprint domain set: files directly matched by --scope
3. Compute dependency footprint domain set: files in --deps closure
4. Apply decision matrix:
   - seed=1 ∧ deps adds 0 → `bundle=single-domain`
   - seed=1 ∧ deps adds ≥1 → `bundle=cross-domain-deps` (one review, per-dep-domain lenses, no split)
   - seed≥2 → `bundle=multi-domain-gated` (split proposal, or bypass via bundle=accept)
5. If multi-domain and no `bundle=accept`: emit split proposal; halt until user selects per-domain split OR supplies `bundle=accept`
6. If bypass: record `bundle=accepted-bundle` on first-line log

**Output:** Resolved artifact set, bundle marker, first-line `Resolved invocation:` log emitted here (before Phase 1 runs).

---

### Phase 1: Research (Optional, Skippable)

**Goal:** Monitor authoritative sources; scan external ecosystem; produce change digest that informs all downstream phases.

**Triggers:** Manual (no --skip), or inherited from flag defaults.

**Process:**
1. Load `pe-domain-map.yaml` and each target artifact's declared `domain:` + corresponding `domain_profile:` (authoritative sources per domain)
2. Query each authoritative source for changes since last baseline (or since --start if bounded-delta)
3. Scan ecosystem (GitHub, community) for relevant work
4. Analyze outcome history (prior invocation reports, success/failure patterns)
5. Produce structured change digest: {source, relevance_score, claim, confidence, category}
6. Emit Phase 1 change digest report (severity-ranked; max 2000 tokens)

**Output:** Change digest fed to Phase 1.5 (organizational) and Phases 2-4 (audits).

**Execution modes:**
- Fresh: Research runs; findings fed to Phases 2-4
- Reconcile: Research runs; findings compared with prior baseline plan; drift guard runs if differences detected
- Trust (--skip research + --plan-file baseline): Baseline substitutes for research; cross-run drift guard REQUIRED

---

### Phase 1.5: Organizational Pass (Optional, Skippable)

**Goal:** Assess structural clarity, layer correctness, dependency organization, coverage gaps — at the inter-artifact level.

**Triggers:** Only when derived `breadth=full` AND resolved --scope spans multiple files; OR explicit `--dim organizational`.

**Process:**
1. Load dependency graph: artifact → immediate dependents, artifact → immediate dependencies
2. Check layer correctness: does each artifact type appear at the expected level (context < instructions < agents < prompts)?
3. Assess coherence: are related artifacts co-located or scattered? Coverage: are all expected artifact types present?
4. Identify orphaned, redundant, or overcomplicated relationships
5. Emit organizational findings (severity-ranked; max 1000 tokens)

**Output:** Organizational findings; escalate high-impact reorganization proposals for human confirmation.

---

### Phase 2: Structure Audit

**Goal:** Deterministic structural validation — YAML parse, reference existence, metadata completeness, hash consistency.

**Process:**
1. For each file in resolved scope:
   a. Parse YAML frontmatter; validate against artifact-type schema
   b. Check all cross-artifact references resolve (links, agent invocations, context includes)
   c. Validate metadata fields: name, description, goal, scope, boundaries, domain
   d. Check file hash against prior baseline; flag if modified
2. Emit severity-ranked structural findings; group by artifact

**Output:** Structural PASS/FAIL verdict + finding details.

**Delegates to:** pe-con-validator (if complex validation needed; handoff if findings exceed 1000 tokens or require expert structural judgment).

---

### Phase 3: Consistency Audit

**Goal:** Rule non-redundancy, non-contradiction, coherence across the artifact set.

**Process:**
1. Extract all declared rules (from Rule blocks, rationales, boundaries) from each artifact
2. Scan for duplicates: identical rule text in multiple files → flag as redundancy
3. Scan for contradictions: rules that conflict (e.g., one says "always use X", another says "never use X")
4. Check metadata consistency: same concept referred to with consistent names across files
5. Validate cross-artifact reference coherence: if artifact A references artifact B's rule, confirm B's rule is publicly stated (not internal detail)
6. Emit severity-ranked consistency findings

**Output:** Consistency PASS/FAIL + finding details.

**Delegates to:** pe-meta-validator if findings cross 3+ artifacts or reveal structural contradictions.

---

### Phase 4: Content Audit

**Goal:** Assess guidance-quality properties: clarity, non-redundancy, completeness, prioritization, actionability.

**Process:**

For each artifact in resolved scope:
1. **Clarity:** Can the declared rules be understood unambiguously by both humans and LLMs? (LLM agreement test: two independent passes produce same interpretation)
2. **Non-redundancy:** Is each rule defined in exactly one canonical location? (check for duplication with other rule blocks)
3. **Non-contradiction:** Do rules within the artifact conflict? Do they conflict with Phase 3 findings?
4. **Completeness:** Are there gaps where guidance is needed but absent? (scan agent behaviors; check against declared scope)
5. **Prioritization:** When rules could conflict, is precedence explicit? (check critical-rules-priority-matrix coverage)
6. **Actionability:** Can an agent act on the rule without additional interpretation? (translate rule to boolean check; verify scope boundaries are enforceable)
7. Emit severity-ranked content findings; categorize by quality property

**Output:** Content PASS/FAIL + finding details (severity-ranked).

**Delegates to:** pe-meta-validator (if 5+ quality gaps or affect multiple rules).

---

### Phase 4.5: Strategic Validation (Conditional, When --dim Includes Strategic Dimensions)

**Goal:** Vision alignment, category compliance, PE quality bar, N-1 separation, self-update readiness, ecosystem impact scoring.

**Trigger:** Runs when `--dim` includes any strategic dimension — `D15-vision-alignment`, `D16-adherence`, `D17-cross-coherence`, or `D19-artifact-structure` (i.e. `--dim strategic`, `--dim full`, or an explicit D15–D19 list).

**Precondition:** Phases 2-4 must complete with PASS verdict; if any structure/consistency/content fails, Phase 4.5 is SKIPPED and findings are marked advisory-only (separate severity channel).

**Process:**

1. **Vision alignment:** Load current vision document + vision rationales. For each target artifact, check whether it complies with applicable rationales. Flag any rationale contradiction.
2. **Category reference compliance:** Audit all `.copilot/context/` references. Are they using Level 1.5 (category-level) references, or Level 2+ (file-specific) without justification? Flag unnecessary file-specificity.
3. **PE quality bar:** Compare against vision § Guidance quality table (exemplary column). Report gaps between standard and exemplary; recommend specific improvements.
4. **N-1 separation audit:** Check N-1 adoption table for artifact type. If N-1 applicable, verify rule-bearing sections use `**Rule**:` / `**Rationale**:` / `**Example**:` block labels. Missing labels block deterministic classification, escalating all diffs to LLM judgment.
5. **Self-update readiness:** Determine rollout phase for artifact type. Check readiness criteria per phase. Report gaps.
6. **Ecosystem-impact scoring:** Check dependency map for this artifact's dependents. Count blast radius (3+ = high impact). Record impact score.
7. Emit strategic findings; separate severity channel from structural (advisory, not blocking).

**Output:** Strategic verdict (PASS / PASS-with-improvements / ADVISORY / FAIL) + finding details.

**Delegates to:** pe-meta-validator (if high-impact, 6+ dependents, or cross-artifact review needed).

---

### Phases 5-7: Risk-Classified Execution (Optional, When --mode apply)

**Goal:** Implement proposed changes from Phases 2-4 per risk-calibrated autonomy: non-breaking + high-confidence → autonomous; breaking or low-confidence → escalate for approval.

**Execution modes (determined by baseline-available? × research-runs?):**

| baseline? | research? | Mode | Behavior | Drift guard |
|---|---|---|---|---|
| no | yes | **fresh** | Execute from research findings | skipped (back-to-back) |
| yes | yes | **reconcile** | Compare findings with baseline; preserve human decisions; escalate deltas | REQUIRED |
| yes | no (`--skip research`) | **trust** | Execute baseline plan; run drift guard to detect cross-run inconsistencies | REQUIRED (mandatory) |

**Process (per Phase 5-7 execution engine):**

1. For each proposed change in the consolidated plan:
   a. Classify: breaking vs non-breaking (per vision § Change classification — checks N-1 labels; structural separation determines if deterministic or LLM judgment required)
   b. Assess confidence: machine-verifiable | validated | LLM-judgment
   c. Combine: impact × confidence → autonomy level (autonomous | autonomous-with-notification | human-approval | human-only)

2. Apply rules per risk-calibration:
   - **Autonomous:** Non-breaking + high-confidence (machine-verifiable or multi-pass validated) → apply immediately
   - **Autonomous with notification:** Non-breaking + medium-confidence → apply + notify user
   - **Human approval required:** Breaking change OR low-confidence → propose + await confirmation before applying
   - **Human-only:** Architectural/strategic → escalate; do not apply

3. For each applied change: update artifact via `replace_string_in_file` or `create_file`

4. Run Phase 8 verification: re-validate consistency of applied changes; report actual changes vs plan intent

**Output:** Execution log (applied changes, escalated changes, drift-guard results).

**Delegates to:** pe-con-builder (non-breaking syntax/reference fixes), pe-meta-optimizer (high-complexity multi-file refactors).

---

### Phase 8: Consolidated Report

**Goal:** Merge Phases 2-7 findings into one report; emit first-line `Resolved invocation:` log (echoing the one emitted at end of Phase 0b); materialize plan file; emit spillover markers.

**Process:**

1. Emit first-line `Resolved invocation:` log (as computed in Phase 0b, echoed again here):
   ```
   Resolved invocation: --mode=… --scope=… --source=… --dim=… --start=… --end=… --deps=… --skip=… --plan-file=… | breadth=… | caller=… | bundle=… | spillover=…
   ```

2. Merge findings from Phases 2-7 into severity-ranked tables:
   - Structural findings (Phase 2)
   - Consistency findings (Phase 3)
   - Content findings (Phase 4)
   - Strategic findings (Phase 4.5, advisory channel)
   - Organizational findings (Phase 1.5, if applicable)

3. Emit combined verdict:
   - **PASS** (all checks pass; no action needed)
   - **PASS with improvements** (findings exist but all non-breaking; applied autonomously in --mode apply)
   - **PLAN READY** (all findings assessed; plan materialized; awaiting human review for breaking/escalated changes in --mode apply)
   - **PLAN ONLY** (--mode plan specified; all findings in plan; no execution)
   - **FAIL** (structural or critical findings block execution)

4. Materialize plan file at location specified by `--plan-file` (or auto-name per pe-meta-plan-file-contract.md). Plan includes:
   - Per-finding severity, classification (breaking/non-breaking), confidence level, proposed action
   - Approval gate for breaking changes (awaits bundle=accept or specific confirmation per finding)
   - Spillover marker (if per-cycle iteration cap exceeded)

5. If execution occurred (--mode apply): emit execution log (applied changes, time stamps, delegated handoffs).

**Output:** Consolidated report + plan file + spillover marker (if applicable).

---

## Risk Classification & Autonomy Model

### Change Classification Matrix

**Breaking vs Non-breaking decision (per vision § Change classification mechanics):**

With **N-1 structural separation labels** (Rule/Rationale/Example blocks):
- Diffs touching **Example** blocks only → non-breaking (confidence: machine-verifiable ✅)
- Diffs touching **Rationale** blocks only → non-breaking (confidence: machine-verifiable ✅)
- Diffs touching **Rule** blocks → gates on goal/scope/boundary preservation (LLM judgment, confidence: requires validation ⚠️)

Without structural separation labels:
- All diffs → LLM judgment required (confidence: validated-only or LLM-judgment)

**Impact assessment (multi-dimensional):**

| Dimension | Low impact | Medium impact | High impact |
|---|---|---|---|
| **Consistency** | Single artifact | Related artifact set | Cross-domain cascade |
| **Efficiency** | Token count ≤5% | Token count 5-15% | Token count >15% |
| **Compatibility** | No dependents affected | Direct dependents affected | Transitive dependents affected |
| **Effectiveness** | Guidance clarity only | Logic/scope change | Goal redefinition |

**Highest-risk dimension governs the overall autonomy level.**

### Autonomy Levels

| Level | Condition | Action | Example |
|---|---|---|---|
| **Autonomous** | non-breaking AND (machine-verifiable OR multi-pass validated) | Apply immediately in --mode apply | Stale timestamp update, reference fix |
| **Autonomous with notification** | non-breaking AND validated (once passed) | Apply + notify user | Redundancy removal after validation pass |
| **Human approval required** | breaking OR (low-confidence LLM-judgment) | Propose + await confirmation | Restructuring, rule change, new artifact |
| **Human-only** | strategic/architectural | Escalate; do not apply | Vision alignment, principle modification |

### Confidence Levels

| Confidence | Evidence | Cost | Examples |
|---|---|---|---|
| **Machine-verifiable** | Deterministic check passed (reference resolves, hash matches, YAML valid) | ✅ 0 tokens | File exists check, metadata parsing |
| **Validated** | Rule/Rationale/Example labels present (structural separation enables deterministic classification) | ✅ ~50 tokens | N-1 audit pass |
| **LLM-judgment** | No labels; reasoning required | ⚠️ ~300-500 tokens per diff | Content clarity assessment, vision alignment |

---

## Handoff Data Contracts

| Transition | Recipient | Strategy | Include | Exclude | Max tokens |
|---|---|---|---|---|---|
| Orchestrator → pe-meta-researcher (Phase 1) | pe-meta-researcher | send: true | Resolved scope, domain set, change digest request, time window | Full artifacts | ≤500 |
| Orchestrator → pe-con-validator (Phase 2) | pe-con-validator | send: true | File paths, artifact types, "structural audit" intent | Strategic analysis, content audits | ≤300 |
| Phase 2 findings → Phase 3 input | (internal) | load | Structural findings summary (reference failures, metadata gaps) | Passing checks | ≤500 |
| Phase 3 findings → Phase 4 input | (internal) | load | Consistency findings (duplicates, contradictions) | Passing checks | ≤500 |
| Orchestrator → pe-meta-validator (Phase 3/4 escalation) | pe-meta-validator | send: true | File paths, consistency/content findings, scope | Full artifacts | ≤1000 |
| Phase 4 findings → Phase 4.5 input | (internal) | load | Content findings (clarity, completeness gaps) | Passing checks | ≤500 |
| Orchestrator → pe-meta-optimizer (Phase 5-7, complex edits) | pe-meta-optimizer | send: true | Plan file, identified changes, "execute per risk classification" | Strategic findings, full artifacts | ≤2000 |

---

## Default Behaviors (Vision v15.4 Default-Full Contract)

| Scenario | Resolved breadth | Resolved scope | --deps | Behavior |
|---|---|---|---|---|
| User runs `pe-meta-review` (parameter-less, manual) | `full` | all artifacts | full | Complete ecosystem sweep (9 phases, all dims) |
| Trigger-fired (e.g., commit hook) | `incremental` | changed artifacts | direct | Changed files + immediate dependents only |
| User supplies `--start 2026-06-15` (any mode) | `bounded-delta` | all artifacts | full | All artifacts modified within window |
| User supplies `--scope file.md --dim strategic` | `full` (for this scope) | single file | none | Strategic validation only, no dependents |
| User supplies `--scope file.md --mode apply` (no other flags) | `full` | single file + deps | full | Comprehensive optimization: file + full deps, apply mode |

---

## Embedded Test Scenarios

| # | Scenario | Expected Behavior |
|---|---|---|
| 1 | Happy path: `pe-meta-review --scope file.md --dim strategic --mode plan` on one artifact | Phase 0b single-domain → Phase 1 research (freshness only if requested) → Phases 2-4 limited to strategic-adjacent dims → Phase 4.5 strategic (D15-D19) → Phase 8 report + plan (no execution) |
| 2 | Default comprehensive: `pe-meta-review --scope folder/ --mode apply` | Phase 0a / Phase 0b multi-domain gating (likely) → Phase 1 research → Phase 1.5 organizational → Phases 2-4 all → Phase 4.5 strategic → Phase 5-7 risk-classified execution → Phase 8 report |
| 3 | Bounded-delta: `pe-meta-review --start 2026-06-15 --end 2026-06-22` | breadth=bounded-delta; all artifacts assessed but findings filtered to changes within window; Phase 1 research scopes to window |
| 4 | Skip research (trust-mode): `pe-meta-review --skip research --plan-file prior-plan.md` | Rule #2 checks: prior plan exists (baseline) → trust-mode → drift-guard runs → cross-run consistency verified; Phase 1 skipped |
| 5 | Composable dims: `pe-meta-review --scope agents --dim structural,quality --skip research` | Structure + consistency/content audits only; strategic (D15-D19) skipped; Phase 1 skipped (--skip research + direct-scope, not full breadth = no Rule #2 violation) |
| 6 | Multi-domain scope with bypass: `pe-meta-review bundle=accept` | Phase 0b detects multi-domain → emits split proposal; user supplies bundle=accept → Phase 0b records bundle=accepted-bundle → processing continues with full scope |
| 7 | Non-breaking changes in --mode apply | Risk classification marks findings as non-breaking + machine-verifiable → autonomously applied; user notified in Phase 8 report |
| 8 | Breaking change in --mode apply | Risk classification marks as breaking → escalated for human approval → plan materialized with approval gate → user must confirm before execution |

---

## Design/Review Parity Contract

**Shared quality objective:** Six properties that both design AND review validate:

1. **Clarity** — unambiguous interpretation (LLM agreement test)
2. **Non-redundancy** — no duplicate rule definitions
3. **Non-contradiction** — rules don't conflict
4. **Completeness** — no gaps where guidance is needed
5. **Prioritization** — precedence is explicit when rules could conflict
6. **Actionability** — agents can act without additional interpretation

**Role differences:**

| Aspect | Design | Review |
|---|---|---|
| **Directive** | Synthesize requirements & construct to reach quality target | Analyze, verify & improve to keep at quality target |
| **Scope** | Create new artifacts or comprehensive redesigns | Validate existing, refactor for drift |
| **Mutation permission** | Full authority (within governance rules) | Risk-calibrated: non-breaking autonomous, breaking escalated |
| **Quality bar** | Same six properties | Same six properties |

This ensures that autonomous review improvements don't lower quality, and that new designs don't ship if they'd fail the same review checks.

---

## Known Tensions & Resolution Rules

| Tension | Competing values | Resolution (priority order) |
|---|---|---|
| Autonomy vs Safety | Efficiency (autonomous) vs Risk containment | Safety wins: non-breaking only for autonomous execution |
| Depth vs Cost | Thoroughness (full assessment) vs Cost (bounded) | Progressive depth: research → screening → deep; escalate on findings |
| Predictability vs Flexibility | Rigid contract (predictable) vs Composability (flexible) | Predictability wins: default-full contract is immutable; flexibility via --dim composition within that contract |
| Research frequency vs Staleness | Always-on monitoring (catch all drift) vs Cost | Research Phase 1 runs by default (full breadth); trigger-fired uses incremental breadth; --skip research possible but requires baseline trust mode |

---

## Scope: What This Unified Command Covers

✅ **In scope:**
- Single file, folder, multifile, artifact-type selection via --scope
- Strategic validation (vision alignment, quality bar, ecosystem impact)
- Structural, consistency, content audits
- Research-driven optimization (external source monitoring)
- Risk-calibrated autonomous execution
- Composable dimension selection via --dim
- Default-full invocation contract honored
- Metadata-driven automation with N-1 structural separation
- Plan materialization + spillover on iteration overflow
- Phase 0b domain-coherence gating
- First-line Resolved invocation: log predictability

❌ **Out of scope:**
- Vision document changes (human-only)
- Individual artifact creation (use pe-meta-create-update)
- Domain artifacts (use /pe-con-review)
- Cross-repo federation (single-repo focus)

---

## Next Steps for Implementation

1. **YAML frontmatter** — Update pe-meta-review.prompt.md with merged frontmatter (model, tools, handoffs, parameters, goal, scope, boundaries)
2. **Phase definitions** — Expand each phase with LLM-delegated logic (e.g., Phase 1 research: what sources to query, Phase 4.5 strategic: which 6 criteria to check)
3. **Parameter parser** — Implement Phase 0a conversational pre-parser + 0b domain-coherence gate (reuse from pe-meta-update, adapt for unified scope)
4. **Audit engines** — Phases 2-4 logic (structure/consistency/content validation) — mostly from pe-con-validator; adapt to emit severity-ranked findings
5. **Risk classification** — Implement breaking/non-breaking + confidence assessment per § Risk Classification section
6. **Execution engine** — Phases 5-7: apply non-breaking + high-confidence changes; escalate others
7. **Report generation** — Phase 8: consolidated report + plan materialization + spillover markers
8. **Test scenarios** — Validate against § Embedded Test Scenarios

---

## Differences from Current State

| Current | Merged |
|---|---|
| Two commands (`pe-meta-review`, `pe-meta-update`) | One command (`pe-meta-review`) |
| `pe-meta-review` = strategic gate (single artifact) | `pe-meta-review --scope file.md --dim strategic` = strategic gate |
| `pe-meta-update` = 9-phase optimization | `pe-meta-review --dim full --mode apply` (or just `pe-meta-review` with defaults) = 9-phase optimization |
| No dimension composability | `--dim strategic,freshness` = precise audit scope (canonical 05.07 groups) |
| Strategic & structural findings mixed | Strategic findings in separate advisory channel (don't block if structural fails) |
| No first-line predictability log | `Resolved invocation:` always emitted before Phase 1 |
| Naming breaks pattern | Naming follows `pe-{meta|type}-{review|design|create-update}` pattern |

