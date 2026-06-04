#requires -Version 7.0
# One-shot repair: decode corrupted pipeline-table rows + skip rule #2 + the
# 7800-char crushed line that contains skip rules 4-6, Reference, Phase 0a section,
# per-artifact prompt invocation matrix; insert Phase 0b row, new skip rule #7,
# and the new § Domain detection subsection. Per user Option A.

$ErrorActionPreference = 'Stop'
$visionPath = 'c:\dev\darioairoldi\Learn\06.00-idea\self-updating-prompt-engineering\20260529.01-vision.v14.md'

$lines = [System.IO.File]::ReadAllLines($visionPath, [System.Text.Encoding]::UTF8)

function Find-LineIndex($needle, $startFrom = 0) {
    for ($i = $startFrom; $i -lt $lines.Length; $i++) {
        if ($lines[$i].Contains($needle)) { return $i }
    }
    throw "Needle not found: $needle"
}

# --- Repair 1: pipeline-table em-dash decoding (rows 1, 1.5, 2, 3, 4, 5, 6, 7) ---
$pipelineRowsStart = Find-LineIndex '| **1** | `research` |'
$pipelineRowsEnd   = Find-LineIndex '| **8** | `report` |' $pipelineRowsStart

$emDash = [string][char]0x2014
for ($i = $pipelineRowsStart; $i -le $pipelineRowsEnd; $i++) {
    $lines[$i] = $lines[$i].Replace('\u2014', $emDash)
}

# --- Repair 2: insert Phase 0b row between row 0a and row 1 ---
$phase0bRow = '| **0b** | `domain-coherence` | Compute per-file domain footprint via the metadata-first 3-tier resolution algorithm (declared `domain:` frontmatter → optional per-repo `pe-domain-map.yaml` heuristic → `unknown`); produce per-domain split proposal when ≥ 2 distinct domain-ids appear in the seed footprint; emit `bundle=cross-domain-deps` carve-out when seed=1 domain and `--deps` adds further domains | NOT skippable; `--skip domain-coherence` is REJECTED with CF-05 |'

$row0aIdx = Find-LineIndex '| **0a** | `pre-parser` |'
$lines = $lines[0..$row0aIdx] + @($phase0bRow) + $lines[($row0aIdx + 1)..($lines.Length - 1)]

# --- Repair 3: skip-rules intro count + skip rule #2 em-dash ---
$skipIntroIdx = Find-LineIndex '**Six per-phase skip semantic rules.**'
$lines[$skipIntroIdx] = $lines[$skipIntroIdx].Replace('Six per-phase skip', 'Seven per-phase skip')

$skipRule2Idx = Find-LineIndex '2. **`--skip research`'
$lines[$skipRule2Idx] = $lines[$skipRule2Idx].Replace('\u2014', $emDash)

# --- Repair 4: the giant crushed line containing rules 4-6, Reference, Phase 0a, invocation matrix ---
# Locate by start: "4. **`--skip approval`" (this line is the corrupted one).
$crushedIdx = Find-LineIndex '4. **`--skip approval`'

# Build the replacement: decoded rules 4-6 + new rule #7 + Reference + Phase 0a + invocation matrix + NEW § Domain detection
$replacement = @'
4. **`--skip approval` is forbidden for mutation-class findings.** Approval gating is the contract between the orchestrator and the user; bypassing it for mutations breaks the autonomy-gradient invariant (R-G1-autonomy-gradient).
5. **`--skip apply` is equivalent to `--mode plan`** — the orchestrator accepts both and reports the equivalence in the echoed invocation string.
6. **`--skip regression` is forbidden when Phase 6 ran.** Multi-pass validation (R-S3-validation-caching, R-S6-tier-blast-radius) requires regression after every apply; the orchestrator rejects this combination with a deterministic error.
7. **`--skip domain-coherence` is forbidden (R-P10-domain-coherent-batching).** Phase 0b is never skippable. `--skip domain-coherence` (or `--skip 0b`) MUST be rejected with CF-05; the only way past the domain-coherence gate is (a) a single-domain footprint (auto-pass), (b) explicit `bundle=accept` on the invocation, (c) accepting a proposed per-domain split, or (d) the `bundle=cross-domain-deps` carve-out when seed=1 domain and `--deps` adds further domains.

Reference: the same eight-phase pipeline appears in the use-cases catalog (`05-reliability/`) keyed off resolved-invocation signatures.

### Conversational pre-parser (Phase 0a)

**Purpose.** Free-form user input (`"check my agents"`, `"look at the prompts that read context for adherence"`, `"run a fast structural pass on the last week"`) is normalized into the seven canonical parameters before strict parsing begins. The pre-parser is an LLM-driven phase — the only phase where natural language is the input. Phases 1–8 only ever consume the resolved canonical invocation.

**Inputs and outputs.**

| Input | Output |
|---|---|
| Raw user input (CLI args, chat message, or trigger payload) | Resolved canonical invocation string `--mode … --scope … --source … --dim … [--start … --end …] --deps … --skip …` |
| Active workspace context (artifact inventory, configured sources) | Confidence score per resolved parameter |
| Caller-type (interactive human vs trigger-fired) | Resolved breadth (`full` \| `incremental` \| `bounded-delta`) per R-P8-default-full-investigation |

**Six resolution rules.** The pre-parser MUST apply these rules in order:

1. **Default to full when ambiguous.** Per R-P8-default-full-investigation, absent slicers resolve to *do everything*. The pre-parser MUST NOT silently narrow scope to save tokens.
2. **Echo, then execute.** The resolved canonical invocation MUST be presented to the caller before Phase 1 runs. For interactive callers this is an explicit echo; for trigger-fired callers it is logged as the first line of the Phase 8 report (criterion #12).
3. **Subject / concern / consumer keywords resolve to `--scope`.** Subject and concern keywords (e.g., `"adherence rules"`, `"naming conventions"`) resolve to a comma-separated `--scope` enumeration of concrete artifact paths. Consumer chains (e.g., `"prompts that read the context-structure-index"`) resolve to `--scope <consumer> --deps full`.
4. **Window phrases resolve to `--start` / `--end`.** Phrases like `"the last week"`, `"since the v1.107 release"`, `"between June 1 and now"` resolve to `--start` / `--end` values. Ambiguity raises a clarification prompt; the pre-parser never invents a window.
5. **Single confirmation round.** The pre-parser MAY ask exactly one clarification question per invocation when confidence is below threshold. After the answer (or a timeout), it commits to the canonical resolution and proceeds.
6. **No silent invention.** When a parameter cannot be resolved from input + context, the pre-parser MUST surface the gap rather than invent a value. The only auto-defaulted parameter is the seven defaults defined in the option taxonomy.

**Worked examples.**

| Free-form input | Resolved canonical invocation |
|---|---|
| (parameter-less `/pe-meta-update`) | `--mode apply --scope all --source all --dim full --deps direct --skip <none>` (breadth = full) |
| `"check my agents"` | `--mode apply --scope agents --source all --dim full --deps direct --skip <none>` (breadth = full) |
| `"run a structural pass on the last 7 days"` | `--mode plan --scope all --source all --dim structural --start -7d --end now --deps direct --skip <none>` (breadth = bounded-delta) |
| `"audit adherence of the agents that read pe-common.instructions.md"` | `--mode plan --scope pe-common.instructions.md --source all --dim adherence --deps full --skip <none>` (breadth = full) |
| `"reconcile against the latest VS Code release notes"` | `--mode apply --scope all --source vscode-release-notes --dim freshness --deps direct --skip <none>` (breadth = incremental) |

### Per-artifact prompt invocation matrix

**Purpose.** Once `--scope` resolves to one or more artifact types (or to specific artifacts whose types are inferred), the orchestrator dispatches each artifact through a per-type, per-mode prompt. The matrix is the single source of truth for `(--scope artifact-type, --dim) → pe-meta-{type}-{review\|create-update\|design}` dispatch.

**Prompt naming convention.**

- `pe-meta-{type}-review` — reviews an existing artifact (assess + propose changes; risk-proportional apply)
- `pe-meta-{type}-create-update` — creates a new artifact or makes an additive update to an existing one
- `pe-meta-{type}-design` — designs the structure/shape of a new artifact category or a major refactor

where `{type}` is one of the eight artifact-type tokens (`context`, `instructions`, `agents`, `prompts`, `skills`, `hooks`, `snippets`, `templates`).

**Per-artifact dispatch matrix.** Given a resolved `(--scope artifact-type, --dim)`, the orchestrator selects the prompt as follows:

| Artifact type | Default review prompt | Triggered when |
|---|---|---|
| `context` | `pe-meta-context-review` | `--dim` ⊆ `{full, structural, quality, strategic, freshness, context-full, context-health}` |
| `instructions` | `pe-meta-instructions-review` | `--dim` ⊆ `{full, structural, quality, adherence, freshness}` |
| `agents` | `pe-meta-agents-review` | `--dim` ⊆ `{full, structural, quality, adherence, efficiency, model, reliability}` |
| `prompts` | `pe-meta-prompts-review` | `--dim` ⊆ `{full, structural, quality, adherence, efficiency, optimize, reliability}` |
| `skills` | `pe-meta-skills-review` | `--dim` ⊆ `{full, structural, strategic, freshness}` |
| `hooks` | `pe-meta-hooks-review` | `--dim` ⊆ `{full, structural, reliability}` |
| `snippets` | `pe-meta-snippets-review` | `--dim` ⊆ `{full, structural}` |
| `templates` | `pe-meta-templates-review` | `--dim` ⊆ `{full, structural}` |

**Create-update vs design dispatch.**

| Caller intent | Resolved dispatch |
|---|---|
| Resolved `--scope` references a non-existent path (create flow) | `pe-meta-{type}-create-update` for the inferred type |
| Resolved `--scope` references an existing artifact AND `--mode apply` AND `--deps direct` | `pe-meta-{type}-review` (assess + apply per risk classification) |
| Resolved invocation requests a structural rework (e.g., `--dim strategic` + `--mode apply` on an artifact-type token) | `pe-meta-{type}-design` for the targeted type |
| Resolved invocation requests an additive update to a known artifact (e.g., “add missing section” resolved by Phase 0a) | `pe-meta-{type}-create-update` for the inferred type |

**Worked examples.**

| Resolved canonical invocation | Dispatch |
|---|---|
| `--mode plan --scope agents --dim adherence` | `pe-meta-agents-review` over every agent in scope |
| `--mode apply --scope context --dim structural,quality` | `pe-meta-context-review` over every context file in scope |
| `--mode apply --scope .copilot/context/00.00-prompt-engineering/05.04-pipeline-phases-and-skip-mapping.md --dim full` | `pe-meta-context-create-update` (file does not yet exist) |
| `--mode apply --scope .github/instructions/pe-instruction-files.instructions.md --dim adherence --deps full` | `pe-meta-instructions-review` for the file; recursive dispatch to every consumer per `--deps full` |

### Domain detection — metadata-first resolution

**Purpose.** Phase 0b (Domain coherence check) computes the **domain footprint** of the resolved scope and gates Phase 1 per R-P10-domain-coherent-batching. Domain is a **content property declared in artifact metadata**, NOT a path property. This subsection specifies the artifact-type root / semantic-domain distinction, the 3-tier metadata-first resolution algorithm, the per-invocation-type scope-extraction matrix, the CF-05 artifact-type/path consistency check, the seed-footprint vs dependency-footprint distinction (with the `bundle=cross-domain-deps` specialized-lens branch), and cross-repo portability.

#### Artifact-type root vs. semantic domain

**Two distinct concepts; conflating them produces silent misclassification.**

| Concept | Source | Decidable from path alone? | What it drives |
|---|---|---|---|
| **Artifact-type root** | The structural prefix of the file path matched against the 8 canonical roots listed below | **Yes** — deterministic | Scope expansion when `--scope <token>` is used; CF-05 prompt-name/path consistency check |
| **Semantic domain** | The `domain:` field declared in the artifact's YAML frontmatter | **No** — declared, not derived | Phase 0b footprint and bundle gating |

Path slugs like `00.09-pe-meta/`, `00.00-prompt-engineering/`, `pe-granular/` denote *housekeeping/infrastructure* groupings. A prompt under `.github/prompts/00.09-pe-meta/` may target ANY semantic domain because pe-meta prompts are PE customization tooling — their CONTENT determines the domain. A pe-meta prompt that designs agents for the `article-writing` domain may legitimately live under `.github/prompts/00.09-pe-meta/` and declare `domain: article-writing` in its frontmatter.

#### Eight canonical artifact-type roots (for scope expansion and CF-05)

These roots are used for (a) expanding `--scope <token>` to a file set and (b) the CF-05 prompt-name/path consistency check. They are NOT a semantic-domain partitioning.

| # | Artifact-type root | Scope-expansion glob |
|---|---|---|
| 1 | `.copilot/context/` | `.copilot/context/**/*.md` |
| 2 | `.github/prompts/` | `.github/prompts/**/*.prompt.md` |
| 3 | `.github/instructions/` | `.github/instructions/*.instructions.md` |
| 4 | `.github/agents/` | `.github/agents/**/*.agent.md` |
| 5 | `.github/templates/` | `.github/templates/**/*.md` |
| 6 | `.github/skills/` | `.github/skills/*/SKILL.md` |
| 7 | `.github/hooks/` | `.github/hooks/*` |
| 8 | `.github/prompt-snippets/` | `.github/prompt-snippets/**/*.md` |

#### Domain resolution algorithm — metadata-first (3 tiers, deterministic)

Applied **per file** to every artifact in the resolved scope (and every file pulled in by `--deps`).

1. **Tier 1 — declared metadata (authoritative).** Open the artifact's YAML frontmatter and read the `domain:` field. When present, the field value is the domain-id. Record `domain-source=declared-metadata`. Stop.
2. **Tier 2 — optional per-repo path-slug heuristic (fallback).** When `domain:` is absent AND the repository root contains `pe-domain-map.yaml` (or equivalent config registered with the orchestrator), apply path-prefix → domain-id mappings from that map. Record `domain-source=path-heuristic`. The presence of any `domain-source=path-heuristic` assignment in the footprint MUST be flagged in the Phase 8 report ("N files lacked declared `domain:` and were classified by heuristic; consider adding `domain:` to their frontmatter"). Stop.
3. **Tier 3 — `unknown` (final fallback).** When neither tier resolves, assign domain-id `unknown` and emit a per-file warning. `unknown` is a real domain-id for footprint purposes (3 files all `unknown` = single-domain footprint; 1 `unknown` + 1 `prompt-engineering` = 2-domain footprint, gate fires).

**Worked examples.**

| Artifact path | `domain:` frontmatter | `pe-domain-map.yaml`? | Resolved domain-id | `domain-source` |
|---|---|---|---|---|
| `.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md` | `prompt-engineering` | n/a | `prompt-engineering` | `declared-metadata` |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md` (declared domain matches housekeeping slug) | `prompt-engineering` | n/a | `prompt-engineering` | `declared-metadata` |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md` (designs an agent for article-writing) | `article-writing` | n/a | `article-writing` | `declared-metadata` |
| `.github/instructions/legacy-instruction.instructions.md` (older file, no `domain:` declared) | absent | yes; map says `.github/instructions/legacy-* → legacy` | `legacy` | `path-heuristic` (flagged in report) |
| `.github/instructions/legacy-instruction.instructions.md` (same file, different repo without the map) | absent | no | `unknown` | `unknown` (per-file warning) |
| `articles/foo.md` (hypothetical other-repo layout) | `articles` | yes; map says `articles/ → articles` | `articles` | `path-heuristic` |

**Repo-portability property.** The algorithm makes no assumption about subfolder naming. A repo that doesn't use `<NN>.<NN>-<slug>/` and doesn't ship `pe-domain-map.yaml` still works correctly — every file declaring `domain:` in its frontmatter resolves deterministically at Tier 1; files without the declaration fall to `unknown` (recoverable by adding the field).

#### Per-invocation-type scope-extraction matrix

Scope extraction (producing the FILE SET for Phase 0b) is **orthogonal** to domain resolution (producing the DOMAIN-ID per file). Every row below feeds the same 3-tier metadata-first algorithm above.

| Invocation shape | Example | `scope-source` marker | How files are resolved |
|---|---|---|---|
| **Artifact-type token** | `/pe-meta-update --scope context` | `token` | Expand token to all files under the matching artifact-type root (per the 8-root scope-expansion table) |
| **Path-set (single)** | `/pe-meta-update --scope .copilot/context/00.00-prompt-engineering/` | `path-set` | Glob the single path |
| **Path-set (multi)** | `/pe-meta-update --scope .copilot/context/00.00-prompt-engineering/,.copilot/context/01.00-article-writing/` | `path-set` | Glob each comma-separated path; union the file set |
| **Positional `<file-path>`** | `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md' --deps full` | `positional` | The positional path IS the file (or with `--deps`, the file + its dependency set) |
| **No scope (default-all)** | `/pe-meta-update --mode plan` | `default-all` | Per R-P8 default-full, expand to every file under every artifact-type root the invoked command supports |

**Phase 0b applies identically across all five rows.** After the file set is resolved, each file's `domain:` frontmatter (or fallback) is read; the resulting domain-id set is the footprint; the gate behavior is decided by footprint size and `--mode`. Per-artifact prompts typically use the **positional** row when invoked directly; a single-file positional invocation produces a one-file file set whose footprint is whatever that single file declares (Tier 1) or `unknown` (Tier 3). With `--deps full`, the traversal set MAY be multi-domain because consumers/dependencies declare their own `domain:` independently.

#### Artifact-type/path consistency check (CF-05, Phase 0a precondition)

**This check operates on artifact-type ROOT (deterministic from path), NOT on semantic domain.**

Per-artifact prompts have a name-encoded artifact-type expectation:

| Prompt-name prefix | Expected artifact-type root |
|---|---|
| `pe-meta-context-*` | `.copilot/context/` |
| `pe-meta-prompt-*` | `.github/prompts/` |
| `pe-meta-instruction-*` | `.github/instructions/` |
| `pe-meta-agent-*` | `.github/agents/` |
| `pe-meta-template-*` | `.github/templates/` |
| `pe-meta-skill-*` | `.github/skills/` |
| `pe-meta-hook-*` | `.github/hooks/` |
| `pe-meta-snippet-*` | `.github/prompt-snippets/` |

**Rule.** When the positional path's artifact-type root does NOT match the expected root for the invoked prompt's prefix, Phase 0a MUST reject the invocation with CF-05 BEFORE Phase 0b runs. The error message MUST identify both the supplied artifact-type root and the expected root, and SHOULD suggest the canonically-correct prompt name.

**Worked rejection example.** `/pe-meta-context-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full` is REJECTED with CF-05: supplied path is under `.github/prompts/`, but `pe-meta-context-review` expects `.copilot/context/`. Canonical replacement: `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full`.

**Orchestrator-level prompts** (`pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`) are artifact-type-agnostic and skip this check.

#### Single-domain shortcut

When every file in the resolved file set resolves to the SAME domain-id (regardless of which tier produced the resolution, regardless of invocation shape, regardless of whether the domain is `unknown`), Phase 0b emits `bundle=single-domain` in the log and Phase 1 proceeds without any prompt.

#### Seed footprint vs dependency footprint — the specialized-lens branch

Phase 0b computes the domain footprint **separately for the seed scope and for the dependency closure**, then combines them through the following decision matrix:

| Seed footprint | Deps footprint (additional domains beyond seed) | Bundle disposition | Phase 1 behavior |
|---|---|---|---|
| 1 domain | 0 (same single domain, or `--deps off`) | `bundle=single-domain` | Proceed without prompt |
| ≥ 2 domains | any | `bundle=multi-domain-gated` | Propose per-domain split (R-P10) |
| 1 domain | ≥ 1 additional domain (from `--deps direct`/`full`) | `bundle=cross-domain-deps` | Proceed as ONE review against the union, with per-dependency-domain specialized analysis lenses |

**Definitions.**

- **Seed footprint** = set of distinct `domain:` values across files explicitly scoped by the invocation BEFORE any `--deps` traversal runs:
  - positional invocation → seed = the positional path(s) (single file or single token-expansion set)
  - `--scope <artifact-type-token>` → seed = all files under that artifact-type root (e.g. `--scope context` → all `.copilot/context/**`)
  - `--scope <path-set>` → seed = the listed paths
  - no `--scope` → seed = all artifacts under all eight canonical artifact-type roots
- **Dependency footprint** = set of distinct `domain:` values across files added by `--deps direct` (one hop) or `--deps full` (transitive closure) traversal from the seed.
- **Additional domain** = a domain that appears in the dependency footprint but NOT in the seed footprint.

**Why `bundle=cross-domain-deps` is not a split.** A consumer artifact NEEDS all its declared dependencies to be reviewable. Splitting a single-seed cross-domain-deps invocation by dep-domain would produce **incomplete reviews**: either each split reviews the seed against a subset of its context (the seed cannot be evaluated correctly because rules it inherits are missing), or each split drops the seed (the user's actual review request is silently ignored). Neither outcome is acceptable. The right behavior is to keep the union together and apply **per-dependency-domain specialized analysis lenses** during Phase 2–4 audits.

**What "specialized analysis lenses" means concretely.** Phase 2–4 audits run ONCE on the seed, but the rule-adherence and context-comparison checks within each audit are evaluated **per dependency-domain**, using domain-specific expectations:

- When comparing the seed against `article-writing` dependencies → exercise Microsoft Writing Style Guide voice rules, Diátaxis type validation, accessibility (alt text, inclusive language), readability targets, emoji-H2 rule.
- When comparing the seed against `prompt-engineering` dependencies → exercise the PE rationale set (R-P1…R-P10), boundary-actionability redteam pattern, three-layer rule architecture, tool-restriction-as-strict-allowlist, dimension scope contract.
- When comparing the seed against `learning-hub` dependencies → exercise dual-metadata system (top YAML / bottom HTML comment), reference-classification emoji markers, kebab-case naming.

The Phase 8 report MUST section findings **per dependency-domain** (one subsection per distinct dep-domain) so reviewers can see which lens produced which findings and trace each finding back to the rules that triggered it.

**Worked example — `bundle=cross-domain-deps`.**

`/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full`

1. **Seed footprint computation.** The positional path is one file. Open it, read `domain:` → `article-writing`. **Seed footprint = { article-writing }**.
2. **Deps full closure.** Walk the prompt's references, file links, and `#file:` snippet inclusions. Closure yields:
   - 6 files under `.copilot/context/01.00-article-writing/` → all declare `domain: article-writing`
   - 4 files under `.copilot/context/00.00-prompt-engineering/` → all declare `domain: prompt-engineering`
   - 2 instruction files (`article-writing.instructions.md`, `documentation.instructions.md`) → declare `domain: article-writing`
3. **Deps footprint = { article-writing, prompt-engineering }**. Additional domains beyond seed = `{ prompt-engineering }` (one).
4. **Decision matrix lookup.** seed = 1, deps adds ≥ 1 → `bundle=cross-domain-deps`. Phase 1 proceeds against the union without prompting for a split.
5. **Phase 8 report sections findings per dep-domain.** One subsection "Findings vs `article-writing` context" applying MWSG/Diátaxis lenses; another "Findings vs `prompt-engineering` context" applying R-P* and boundary-actionability lenses.

**Contrast with `bundle=multi-domain-gated`.** The same closure under `--scope context` (no positional seed) would produce **seed footprint = { article-writing, prompt-engineering, … }** because the user explicitly asked for the whole context-files artifact-type root. There R-P10 fires — splitting is appropriate because each split is independently meaningful (an article-writing review of the article-writing context subset; a PE review of the PE context subset).

**Why R-P10 still applies.** R-P10 governs the seed-multi-domain case, not the seed-single-domain case. The new `bundle=cross-domain-deps` branch is NOT a bypass of R-P10 — it's a different case that R-P10 was never the right tool for. R-P10's rationale (per-domain reviewer attention, scoped rollback boundaries, single-domain context windows) all assume the user's intent spans multiple domains. When the user named ONE artifact, the cross-domain deps are infrastructure the seed requires, not separate review targets.

#### `--deps full` and the metadata-first payoff

This is the case where path-based domain extraction silently misclassifies entire runs and the metadata-first model pays off.

**Worked example.** `/pe-meta-update '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full`:

1. **Phase 0a.** Orchestrator-level prompt (`pe-meta-update`), so CF-05 prompt-name/path check is skipped. `--dim context-quality-lifecycle` parsed and validated against the dimension-group enumeration.
2. **Phase 0b scope extraction.** Positional path → file set = { seed } ∪ deps-full-closure(seed). Suppose closure yields 12 files spanning `.github/prompts/00.09-pe-meta/`, `.copilot/context/00.00-prompt-engineering/`, `.copilot/context/01.00-article-writing/`, `.github/skills/pe-context-file-creation/`.
3. **Phase 0b domain resolution (per file, metadata-first).** Each of the 12 files is opened and its `domain:` field is read:
   - 8 files declare `domain: prompt-engineering`
   - 3 files declare `domain: article-writing`
   - 1 file has no `domain:` field and the repo has no `pe-domain-map.yaml` → `unknown`
4. **Footprint = 3 domains** (`prompt-engineering`, `article-writing`, `unknown`). Gate fires per R-P10.
5. **Phase 0b output.** Numbered split proposal showing 3 canonical per-domain invocations. `bundle=multi-domain-gated` recorded on the log. User selects split 1 OR `bundle=accept`.

**Why path-walk fails this case.** A path-walk algorithm would read the seed file's path (`.github/prompts/00.09-pe-meta/`), derive `pe-meta` as the domain, and either (a) silently classify the entire 12-file traversal as `pe-meta` (false-negative; gate doesn't fire on a genuinely multi-domain bundle) or (b) classify each file by its own path-walk and produce a footprint based on housekeeping slugs (`pe-meta`, `prompt-engineering`, `article-writing`, `pe-context-file-creation`) that doesn't match what the FILES actually claim to be about.

**Note on `--dim` orthogonality.** `--dim context-quality-lifecycle` filters which dimensions Phase 2–4 audit — it does NOT declare or override the semantic domain of any artifact. Domain footprint is computed entirely from per-file `domain:` metadata.

#### Cross-repo portability

The vision specifies WHAT to read (the `domain:` field) and HOW to fall back (optional path-slug map, then `unknown`). It does NOT mandate any folder-naming convention.

**Optional config schema** (`pe-domain-map.yaml` at repo root):

```yaml
# Per-repo path-slug heuristic for files lacking declared `domain:` metadata.
# Used at Tier 2 of the domain resolution algorithm. Optional.
mappings:
  - path-prefix: .copilot/context/00.00-prompt-engineering/
    domain: prompt-engineering
  - path-prefix: .copilot/context/01.00-article-writing/
    domain: article-writing
  - path-prefix: .github/prompts/00.09-pe-meta/
    domain: prompt-engineering    # Note: housekeeping slug ≠ semantic domain
```

**Migration guidance for repos adopting v15:** the recommended path is to declare `domain:` in every PE artifact's frontmatter (so Tier 1 always resolves). Shipping `pe-domain-map.yaml` is a transitional convenience for legacy/unannotated files only; it is NOT required for the algorithm to work.

#### Mode elimination from scheduled review
'@

$replacementLines = $replacement -split "`r?`n"

# Now also remove the "#### Mode elimination from scheduled review" heading from its old location
# (the crushed line ends with that heading — which is followed by body text on next line)
# Strategy: replace crushedIdx with $replacementLines (which includes the heading already)
$beforeCrushed = $lines[0..($crushedIdx - 1)]
$afterCrushed  = $lines[($crushedIdx + 1)..($lines.Length - 1)]

# The next line after crushed should be empty or the body paragraph; we keep $afterCrushed intact.
# But check: the original line right after crushedIdx may be a blank line then "The scheduled review command..."
# Since the replacement ends with "#### Mode elimination from scheduled review", we need to ensure
# the next line in afterCrushed is NOT another duplicate heading. Inspect:
if ($afterCrushed.Length -gt 0 -and $afterCrushed[0].Trim() -eq '') {
    # blank line preserved
} elseif ($afterCrushed.Length -gt 0 -and $afterCrushed[0].StartsWith('#### Mode elimination')) {
    # duplicate heading - skip it
    $afterCrushed = $afterCrushed[1..($afterCrushed.Length - 1)]
}

$lines = $beforeCrushed + $replacementLines + $afterCrushed

[System.IO.File]::WriteAllLines($visionPath, $lines, [System.Text.UTF8Encoding]::new($false))

# Verification: scan for any remaining \uXXXX escapes
$content = [System.IO.File]::ReadAllText($visionPath, [System.Text.Encoding]::UTF8)
$residual = [regex]::Matches($content, '\\u[0-9a-fA-F]{4}')
if ($residual.Count -gt 0) {
    Write-Host "RESIDUAL ESCAPES FOUND: $($residual.Count)" -ForegroundColor Red
    $residual | Select-Object -First 10 | ForEach-Object { Write-Host "  - $($_.Value)" }
} else {
    Write-Host "OK: no residual \uXXXX escapes" -ForegroundColor Green
}

# Verify no lines > 1200 chars (legitimate changelog line is ~2100 chars and on the changelog file, not this one)
$longLines = @()
$idx = 0
foreach ($l in $lines) {
    if ($l.Length -gt 1200) { $longLines += "Line $($idx + 1): $($l.Length) chars" }
    $idx++
}
if ($longLines.Count -gt 0) {
    Write-Host "LONG LINES (>1200 chars):" -ForegroundColor Yellow
    $longLines | ForEach-Object { Write-Host "  $_" }
} else {
    Write-Host "OK: no lines > 1200 chars" -ForegroundColor Green
}

Write-Host "Total lines now: $($lines.Length)"
