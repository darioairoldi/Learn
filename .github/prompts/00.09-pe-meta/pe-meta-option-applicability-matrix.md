# PE-meta command option applicability matrix

This matrix defines the canonical option taxonomy for all PE-meta commands. Options are organized into 5 classes with deterministic applicability rules.

## Option classes

| Class | Option | Intent | Applicability |
|---|---|---|---|
| Dimension | `--dim <group\|D#\|full>` | What quality dimensions to evaluate | Universal — all review/update/design/create commands |
| Dependency | `--deps none\|direct\|full\|<N>` | How deep to follow dependency chains | Review + guidance-first + scheduled (pass-through) |
| Scope | `--scope <type>[,<type>...]` | What artifact types to focus on | Universal — all commands |
| Mode | `--mode plan\|apply` | Whether to preview or execute changes | Review + guidance-first + update + release-monitor |
| Skip | `--skip <stage>[,<stage>...]` | Which pipeline phases or resources to bypass | Update (all stages); type-specific review (research, external only) |

## Canonical applicability matrix

| Option | Review | Design | Create-update | Scheduled-review | Update | Release-monitor | Adherence |
|---|---|---|---|---|---|---|---|
| `--dim` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `--deps` | ✅ | ❌ | ❌ | ✅ (pass-through) | ❌ | ❌ | ✅ |
| `--scope` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `--mode` | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| `--skip` | ✅ (research, external) | ❌ | ❌ | ✅ (research, external) | ✅ (all stages) | ✅ (research, external) | ❌ |

## Option detail: `--deps`

| Value | Behavior |
|---|---|
| `none` | No dependency traversal (explicit opt-out) |
| `direct` | First-level dependencies only |
| `full` | Bounded recursive traversal (default depth 5) |
| `<N>` | Explicit numeric depth for fine-grained control |
| _(omitted)_ | Equivalent to `none` in review/adherence; auto-rotation in scheduled-review |

## Option detail: `--scope`

**Universal semantics** — accepted in ALL commands with context-dependent behavior:

| Context | Behavior |
|---|---|
| Orchestrators (`update`, `scheduled-review`) | Selects which artifact types to iterate in the batch |
| Type-specific commands (`{type}-review`, `{type}-design`) | Filters which dependency types to focus on during `--deps` traversal |
| Multi-file review | Selects which file types from the input set to process |

**Valid values:** `all` (default), `context`, `instructions`, `agents`, `prompts`, `skills`, `hooks`, `snippets`, `templates`, or a specific file path.

**Composition with `--deps`:** `--scope` controls WHAT to traverse; `--deps` controls HOW DEEP. They compose orthogonally.

## Option detail: `--mode`

| Value | Behavior |
|---|---|
| `plan` | Full R-B-V analysis but stop before apply; presents designed changes with diffs for review |
| `apply` | Full R-B-V + apply changes (default) |

**Note:** `--mode plan --skip research` is the canonical assessment-only invocation (diagnose without designing or applying changes). It supersedes the former `healthcheck` preset.

## Option detail: `--skip`

Named stages map to pipeline phases and cross-cutting resources:

| Stage | Maps to | Available in |
|---|---|---|
| `research` | Phase 1 (source research) | All commands with skip support |
| `external` | Internet/URL fetching in all phases | All commands with skip support |
| `structure` | Phase 2 (structure audit) | Orchestrators only |
| `consistency` | Phase 3 (consistency audit) | Orchestrators only |
| `content` | Phase 4 (content audit) | Orchestrators only |

Multiple stages: `--skip research,structure` or repeated: `--skip research --skip structure`.

## Preset aliases (removed)

Positional preset tokens (`healthcheck`, `performancecheck`, `fullcheck`) are no longer supported. The parser MUST refuse any invocation that uses them with the deterministic error documented in `pe-meta-update.prompt.md` § Argument parsing → Rejected preset tokens.

The canonical replacements are:

| Removed preset | Canonical invocation |
|---|---|
| `healthcheck` | `--mode plan --skip research` |
| `performancecheck` | `--mode apply --dim optimize --skip research,structure,consistency` |
| `fullcheck` | `--mode apply` (or omit `--mode` — `apply` is the default) |

**Composition rule:** explicit user flags always win; multiple `--skip` lists merge with deduplication.

## Backward-compatible aliases

| Legacy option | Canonical equivalent | Notes |
|---|---|---|
| `--with-deps` | `--deps full` | Retained for compatibility |
| `--with-deps-shallow` | `--deps direct` | Retained for compatibility |
| `--plan` | `--mode plan` | Retained as shorthand |
| `--no-external` | `--skip external` | Retained for compatibility |
| `--no-research` | `--skip research` | Retained for compatibility |
| `--skip-source` | `--skip research` | Retained for compatibility |
| `--skip-structure` | `--skip structure` | Retained for compatibility |
| `--skip-consistency` | `--skip consistency` | Retained for compatibility |
| `--skip-content` | `--skip content` | Retained for compatibility |

## Canonical command ownership for overlap-prone capabilities

| Capability | Canonical command | Compatibility route | Routing rule |
|---|---|---|---|
| Guidance-first adherence matrix | `/pe-meta-adherence` | Scheduled-review guidance-first rotation | Always route to canonical; never accept `--mode guidance-first` in other commands |
| Release-diff driven monitoring | `/pe-meta-release-monitor` | `/pe-meta-update --mode apply <release-url>` | Prefer release-monitor; keep compatibility route for explicit requests |

Orchestration narratives are intentionally preserved in orchestration prompts and are not overlap defects:

1. Scheduling and cadence guidance → `/pe-meta-scheduled-review`
2. Lifecycle rotation guidance → `/pe-meta-scheduled-review`
3. Release-diff guidance → `/pe-meta-release-monitor`
4. Multi-phase orchestration guidance → `/pe-meta-update`

## Deterministic rejection format

When an option is unsupported, respond with:

```
<option> is not supported by <command> because <missing-capability>. <corrective-action>.
```

Corrective action MUST include one of:
1. Remove the option.
2. Use the canonical command that supports the capability.
3. Split the invocation into supported combinations.

### Rejection examples

| Invalid invocation | Rejection message |
|---|---|
| `pe-meta-review target.md --mode apply` | Valid — this is the default behavior. Review assesses and implements non-breaking improvements autonomously. Use `--mode plan` to opt into assessment-only output. |
| `pe-meta-design desc --deps full` | `--deps is not supported by pe-meta-design because design does not traverse dependencies. Remove --deps or use /pe-meta-review for dependency analysis.` |
| `pe-meta-adherence target.md --dim full` | `--dim is not supported by pe-meta-adherence because adherence uses a fixed dimension set. Remove --dim.` |
| `pe-meta-review target.md --skip structure` | `--skip structure is not supported in type-specific review because phase-level skipping requires the orchestration pipeline. Use --skip research or --skip external, or use /pe-meta-update for phase control.` |
| `pe-meta-review target.md --deps full --deps direct` | `Conflicting --deps values. Specify one: --deps none, --deps direct, --deps full, or --deps <N>.` |

## Command examples by option class

### Dimension scoping

```
/pe-meta-review .github/agents/pe-meta-validator.agent.md --dim structural
/pe-meta-update --mode plan --skip research --dim quality --scope context
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim freshness
/pe-meta-review .github/agents/ --dim adherence
/pe-meta-review .github/prompts/ --dim reliability --mode plan
```

> **Dim alias:** `--dim robustness` is a deprecated alias for `--dim adherence` (accepted for one release with a deprecation notice; resolves to `--dim adherence`). `--dim reliability` is the canonical group for system-reliability dimensions D28-D35. See `.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md` for the full dimension group inventory.

### Dependency traversal

```
/pe-meta-review .github/agents/pe-meta-validator.agent.md --deps full
/pe-meta-prompt-review pe-meta-review.prompt.md --deps direct --scope context
/pe-meta-scheduled-review --deps full --scope agents
```

### Scope filtering

```
/pe-meta-update --mode apply --scope context,instructions
/pe-meta-prompt-review pe-meta-review.prompt.md --scope context --deps full
/pe-meta-agent-review pe-meta-validator.agent.md --scope instructions --deps direct
```

### Mode control

```
/pe-meta-update --mode plan --scope agents
/pe-meta-release-monitor <url> --mode plan
```

### Pipeline stage skipping

```
/pe-meta-update --mode apply --skip research,structure --scope prompts
/pe-meta-update --mode apply --skip external --dim quality
/pe-meta-context-review .copilot/context/ --skip research
```

### Canonical invocations replacing removed presets

```
/pe-meta-update --mode plan --skip research --scope context --dim freshness
/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts
/pe-meta-update --mode plan
```