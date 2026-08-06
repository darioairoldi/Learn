# UC-35: Domain-coherent batching

> **Group:** 05-reliability
> **Priority:** P0
> **Order in group:** 4
> **Dimensions:** `D33-boundary-actionability`, `D31-multipass-validation-invariant`, `D5-boundaries`, `D28-reproducibility`
> **Vision anchors:** domain-coherent-batching; § Domain-coherent batching; § Domain detection — metadata-first resolution; Phase 0a CF-05 artifact-type/path consistency check; Phase 0b — Domain coherence check
> **Command family:** Review / Update / Create / Scheduled (artifact-type-agnostic — applies to every `/pe-meta-*` command)
> **Primary entry point:** `/pe-meta-review --mode apply --scope <type-token|path-set>` (gated by Phase 0b)
> **Allowed option classes:** `mode`, `scope`, `source`, `dim`, `start`, `end`, `deps`, `skip`
> **Default breadth:** full
> **Bundle disposition:** `single-domain` (this use case's primary invocations are per-domain by construction)
> **Scope mechanism:** `path-set`

## 🎯 Goal

Prevent silent heterogeneous-bundle execution. Whenever a resolved `--scope` (regardless of invocation shape) covers ≥ 2 semantic domains, surface the domain footprint and propose canonical per-domain split commands **before any mutation runs**. Bundle execution requires explicit consent (`bundle=accept`). When a single-seed positional invocation pulls cross-domain dependencies via `--deps`, run ONE review against the union with per-dependency-domain specialized analysis lenses (no split — consumer artifacts need ALL their declared dependencies present to be evaluated correctly).

## ⚙️ Trigger conditions

- Any `/pe-meta-*` invocation whose resolved `--scope` seed covers ≥ 2 semantic domains.
- `pe-meta-scheduled-review` auto-rotation when the rotation lands on a cross-domain target.
- User-issued bundle audit (e.g. `/pe-meta-review --mode plan --scope all --dim reliability`).
- Per-artifact prompt invoked with a positional `<file-path>` whose `--deps full` closure pulls in additional semantic domains.

## ⚙️ Primary invocations

Three canonical per-domain commands derived from the originating incident (heterogeneous `--scope context` split into one run per domain):

```text
/pe-meta-review --mode apply --scope .copilot/context/00.00-prompt-engineering/
/pe-meta-review --mode apply --scope .copilot/context/01.00-article-writing/
/pe-meta-review --mode apply --scope .copilot/context/90.00-learning-hub/
```

Bundle-accept variant for callers who genuinely want one atomic run:

```text
/pe-meta-review --mode apply --scope context bundle=accept
```

## 🧭 Phase 0a precondition — artifact-type/path consistency check

Per-artifact prompts encode an expected artifact-type root in their name (e.g. `pe-meta-context-*` ⇒ `.copilot/context/`). When the positional path or `--scope` value resolves to a different root, Phase 0a **rejects with CF-05 before Phase 0b runs**.

**Worked rejection example:**

```text
/pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full
```

⇒ CF-05: supplied path is under `.github/prompts/`, but `pe-meta-context-review` expects `.copilot/context/`.

**Canonical replacement:**

```text
/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full
```

Orchestrator-level prompts (`pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`) are artifact-type-agnostic and skip this check.

## 🧭 Phase 0b flow — all five invocation shapes

Phase 0b applies identically to each invocation shape; only the **file set** differs by shape. The domain footprint is computed by reading each in-scope file's `domain:` YAML frontmatter (Tier 1), falling back to an optional per-repo `pe-domain-map.yaml` heuristic (Tier 2), and finally to `unknown` (Tier 3) per vision § Domain detection.

| Resolved scope | Invocation shape (`scope-source=`) | Domain footprint (read from per-file `domain:` metadata) | Phase 0b output | Gate behavior in `--mode apply` |
|---|---|---|---|---|
| `.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md` | `path-set` (single path) | 1 (whatever the file's `domain:` declares; typically `prompt-engineering`) | `bundle=single-domain` | Proceeds; no prompt |
| `--scope context` | `token` | Typically 3+ (each file under `.copilot/context/` is read for its `domain:` value; the count is the number of distinct declared domains) | Numbered split proposal (one entry per distinct domain) | Hard gate; awaits selection or `bundle=accept` |
| `--scope .copilot/context/01.00-article-writing/,.copilot/context/90.00-learning-hub/` | `path-set` (multi) | Typically 2 (assuming files in each subfolder declare matching `domain:` values; the count is N distinct domains found, NOT the number of path-set entries) | Numbered split proposal (N entries) | Hard gate; awaits selection or `bundle=accept` |
| `--scope .github/prompts/00.09-pe-meta/` | `path-set` (single) | Depends on what each pe-meta prompt declares in its `domain:` field — may be 1 (`prompt-engineering`) if homogeneous, or N if some pe-meta prompts target other domains | `bundle=single-domain` iff all declared domains match; otherwise numbered split proposal | Hard gate iff N ≥ 2 |
| `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md'` (no `--deps`) | `positional` | 1 (whatever the file's `domain:` declares) | `bundle=single-domain` | Proceeds; no prompt (single-file positional is single-domain by construction) |
| `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md' --deps full` | `positional` (with `--deps` traversal) | **Seed footprint = 1** (the file's own `domain:`); **deps footprint** = N distinct domains read from each file in the closure | If deps adds 0 additional domains → `bundle=single-domain`. If seed=1 AND deps adds ≥ 1 additional domain → **`bundle=cross-domain-deps`** (ONE review, per-dep-domain specialized lenses; NO split). | Proceeds; no gate/split for `bundle=cross-domain-deps` |
| `/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full` | `positional` (with `--deps` traversal) | **Seed footprint = 1** (`article-writing`); **deps closure** typically pulls in `article-writing` context files AND `prompt-engineering` context files → deps adds `{ prompt-engineering }` | `bundle=cross-domain-deps`: ONE review against the union; Phase 2–4 apply per-dep-domain specialized analysis lenses (MWSG/Diátaxis for `article-writing` deps; R-P* rationales for `prompt-engineering` deps); Phase 8 report sections findings per dep-domain | Proceeds; no gate |
| `/pe-meta-review --mode apply` (no scope) | `default-all` (per default-full-investigation) | All distinct declared domains across every artifact-type root | Numbered split proposal (one entry per distinct domain) | Hard gate; awaits selection or `bundle=accept` |

**Note 1.** Positional `<file-path>` invocations are the canonical entry point for the per-artifact prompt family (`pe-meta-context-*`, `pe-meta-prompt-*`, etc.). Phase 0b applies to them identically — only the scope-extraction step differs (the positional path IS the file; with `--deps`, it expands to the traversal set).

**Note 2.** The footprint columns above describe TYPICAL outcomes assuming each file declares its `domain:` field correctly. When `domain:` is absent, the orchestrator falls back to Tier 2 (per-repo `pe-domain-map.yaml` heuristic, if shipped) or Tier 3 (`unknown`). The Phase 8 report calls out every file resolved at Tier 2 or Tier 3 so authors can backfill the field. `unknown` counts as a distinct domain-id for footprint and gate purposes.

**Note 3 — seed footprint vs dependency footprint.** Phase 0b computes the domain footprint **separately for the seed scope** (files explicitly named by `--scope` or positional path, BEFORE `--deps` traversal) and **for the dependency closure** (files added by `--deps direct`/`--deps full`). Three dispositions follow from a small decision matrix: (a) seed=1 AND deps=0 → `bundle=single-domain`; (b) seed≥2 (regardless of deps) → `bundle=multi-domain-gated` and propose split per domain-coherent-batching; (c) seed=1 AND deps adds ≥ 1 additional domain → `bundle=cross-domain-deps`, run ONE review against the union with per-dependency-domain specialized analysis lenses (no split). Splitting a single-seed cross-domain-deps invocation would produce **incomplete reviews** because a consumer artifact needs ALL its declared dependencies present to be evaluated correctly — see § Specialized lens (cross-domain-deps) below.

## 🔬 Specialized lens (cross-domain-deps)

When Phase 0b emits `bundle=cross-domain-deps`, Phase 2–4 audits run **ONCE on the seed**; only the rule-adherence and context-comparison sub-checks within each audit are evaluated per dependency-domain:

| Dep-domain | Specialized lens applied when comparing seed against this dep | Findings sectioned in Phase 8 report under |
|---|---|---|
| `article-writing` | Microsoft Writing Style Guide voice rules, Diátaxis type validation, accessibility (alt text, inclusive language), readability targets (Flesch 50–70, sentences 15–25 words), emoji-H2 rule | "Findings vs `article-writing` context" |
| `prompt-engineering` | PE rationale set (deterministic-processing…domain-coherent-batching), boundary-actionability redteam pattern, three-layer rule architecture, tool-restriction-as-strict-allowlist, dimension scope contract | "Findings vs `prompt-engineering` context" |
| `learning-hub` | Dual-metadata system (top YAML / bottom HTML comment), reference-classification emoji markers (📘/📗/📒/📕), kebab-case naming | "Findings vs `learning-hub` context" |
| other | The dep-domain's own context-file rules (look up the dep-domain's instruction files in its declared artifact-type root) | "Findings vs `<dep-domain>` context" |

**Worked example — `/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full`:**

1. **Phase 0a.** CF-05 passes (`pe-meta-prompt-*` ⇒ `.github/prompts/` root; supplied path matches).
2. **Phase 0b seed extraction.** Positional single file. Read `domain:` from the prompt's frontmatter → `article-writing`. **Seed footprint = { article-writing }**.
3. **Phase 0b deps full closure.** Walk references and file links; closure yields 6 files under `.copilot/context/01.00-article-writing/`, 4 files under `.copilot/context/00.00-prompt-engineering/`, 2 instruction files in `.github/instructions/`. Read each file's `domain:`. **Deps footprint = { article-writing, prompt-engineering }**. Additional domains beyond seed = `{ prompt-engineering }`.
4. **Phase 0b decision.** seed=1 AND deps adds ≥ 1 → `bundle=cross-domain-deps`. NO split proposal. Log marker: `bundle=cross-domain-deps`. Phase 1 proceeds.
5. **Phase 2–4 audits.** Run ONCE on the seed prompt. Comparison sub-checks apply per dep-domain: PE rationale checks against the PE dependencies; MWSG/Diátaxis checks against the article-writing dependencies.
6. **Phase 8 report.** Two subsections: "Findings vs `article-writing` context" and "Findings vs `prompt-engineering` context". Each finding is labeled with the lens that produced it.

**Why this is not a bypass of domain-coherent-batching.** domain-coherent-batching governs the seed-multi-domain case (the user explicitly asked for broad scope). The cross-domain-deps branch handles a case domain-coherent-batching was never the right tool for: the user named ONE artifact, and the cross-domain deps are infrastructure that artifact requires, not separate review targets. Splitting would produce incomplete reviews, which is the opposite of domain-coherent-batching's intent.

## 📤 Expected outputs

- Per-run report with `bundle=` (one of `single-domain | multi-domain-gated | accepted-bundle | split-N | cross-domain-deps`) AND `scope-source=` markers on the first line.
- Per-domain `outcome-log.jsonl` entries when the bundle is split.
- Granular rollback bundle per domain when one run regresses without affecting the others.
- When `bundle=cross-domain-deps`, the Phase 8 report sections findings under one subsection per distinct dep-domain (one lens per subsection).
- Tier-2 (`domain-source=path-heuristic`) and Tier-3 (`domain-source=unknown`) assignments are flagged per-file in the Phase 8 report so authors can backfill missing `domain:` fields.

## 📐 Dimensions exercised

`D33-boundary-actionability`, `D31-multipass-validation-invariant`, `D5-boundaries`, `D28-reproducibility`.

## 🔗 Cross-references

- Vision § Domain-coherent batching — the canonical rule statement.
- Vision § Domain detection — artifact-type root vs. semantic domain; metadata-first 3-tier resolution algorithm; per-invocation-type scope-extraction matrix; artifact-type/path consistency check; **seed footprint vs dependency footprint — the specialized-lens branch**; `--deps full` and the metadata-first payoff; cross-repo portability.
- Rationale domain-coherent-batching.
- [`p0-01-process-reproducibility`](p0-01-process-reproducibility-usecase.md) — reproducibility audit MUST exercise this gate to verify the gate itself.
- [`p0-02-regression-protection`](p0-02-regression-protection-usecase.md) — per-domain rollback granularity depends on this gate.
- [`p0-03-metadata-guard-enforcement`](p0-03-metadata-guard-enforcement-usecase.md) — metadata-guard checks run cross-domain on broad sweeps and inherit Phase 0b.
- [`../../../src/docs/90.%20Issues/202605/20260525.03-staleness-review/03-pe-meta-update-applied-to-all-pe-contexts/overview.md`](../../../../src/docs/90.%20Issues/202605/20260525.03-staleness-review/03-pe-meta-update-applied-to-all-pe-contexts/overview.md) — originating incident analysis.
- [`../../../src/docs/90.%20Issues/202605/20260525.03-staleness-review/03-pe-meta-update-applied-to-all-pe-contexts/03-pe-meta-update-plan.md`](../../../../src/docs/90.%20Issues/202605/20260525.03-staleness-review/03-pe-meta-update-applied-to-all-pe-contexts/03-pe-meta-update-plan.md) — orchestrator and per-artifact prompt updates that implement this gate.
