4. **`--skip approval` is forbidden for mutation-class findings.** Approval gating is the contract between the orchestrator and the user; bypassing it for mutations breaks the autonomy-gradient invariant (R-G1-autonomy-gradient).
5. **`--skip apply` is equivalent to `--mode plan`** — the orchestrator accepts both and reports the equivalence in the echoed invocation string.
6. **`--skip regression` is forbidden when Phase 6 ran.** Multi-pass validation (R-S3-validation-caching, R-S6-tier-blast-radius) requires regression after every apply; the orchestrator rejects this combination with a deterministic error.

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

#### Mode elimination from scheduled review
