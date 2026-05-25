# PE-meta option parser test evidence

Deterministic test scenarios documenting expected parser behavior for all PE-meta commands. Each row defines an input invocation and the expected system response — either acceptance with parsed values or rejection with corrective message.

**Normative reference:** `pe-meta-option-applicability-matrix.md`

## Accepted combinations by command family

### Review family

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-R01 | `/pe-meta-review path.md` | dim=full, deps=none, scope=all | All defaults |
| A-R02 | `/pe-meta-review path.md --dim structural` | dim=structural, deps=none, scope=all | Dimension filter |
| A-R03 | `/pe-meta-review path.md --deps full` | dim=full, deps=full (depth 5), scope=all | Full dep traversal |
| A-R04 | `/pe-meta-review path.md --deps direct` | dim=full, deps=direct (depth 1), scope=all | First-level deps |
| A-R05 | `/pe-meta-review path.md --deps 3` | dim=full, deps=3, scope=all | Explicit numeric depth |
| A-R06 | `/pe-meta-review path.md --scope context --deps full` | dim=full, deps=full, scope=context | Scope+deps compose: traverse full depth, focus on context deps |
| A-R07 | `/pe-meta-prompt-review path.md --scope context --deps direct` | dim=full, deps=direct, scope=context | Type-specific: filter to context deps, first-level only |
| A-R08 | `/pe-meta-agent-review path.md --scope instructions --deps full` | dim=full, deps=full, scope=instructions | Focus on instruction deps |
| A-R09 | `/pe-meta-review path.md --skip research` | dim=full, deps=none, scope=all, skip=[research] | Skip Phase 1 (type-specific: research valid) |
| A-R10 | `/pe-meta-review path.md --skip external` | dim=full, deps=none, scope=all, skip=[external] | No internet fetching |
| A-R11 | `/pe-meta-review path.md --dim quality --deps full --scope prompts --skip research` | dim=quality, deps=full, scope=prompts, skip=[research] | All options combined |
| A-R12 | `/pe-meta-review path.md --dim reliability` | dim=reliability (D28-D35), deps=none, scope=all | Reliability group resolves to system-reliability dimensions |
| A-R13 | `/pe-meta-review path.md --dim adherence` | dim=adherence (D5, D6, D16, D18), deps=none, scope=all | Canonical adherence group |
| A-R14 | `/pe-meta-review path.md --dim robustness` | dim=adherence (D5, D6, D16, D18) + deprecation notice | Deprecated alias: parser emits notice and resolves to `--dim adherence` |
| A-R15 | `/pe-meta-review path.md --dim invented-name` | _rejected_ | Unknown `--dim` value — see CF-05 |

### Creation family (design + create-update)

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-C01 | `/pe-meta-design "description"` | dim=full, scope=all | Defaults |
| A-C02 | `/pe-meta-prompt-design "description" --dim structural` | dim=structural, scope=all | Dimension filter only |
| A-C03 | `/pe-meta-create-update path.md` | dim=full, scope=all | Defaults |
| A-C04 | `/pe-meta-context-create-update path.md --scope instructions` | dim=full, scope=instructions | Scope filter |

### Guidance-first family (adherence)

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-G01 | `/pe-meta-adherence path.md` | deps=none, scope=all | Defaults (no --dim) |
| A-G02 | `/pe-meta-adherence path.md --deps full` | deps=full, scope=all | Full dep-chain adherence |
| A-G03 | `/pe-meta-adherence path.md --scope context --deps direct` | deps=direct, scope=context | Focus on context adherence |

### Scheduled-review family

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-S01 | `/pe-meta-scheduled-review` | dim=auto, deps=auto-rotation, scope=all | All auto (rotation selects) |
| A-S02 | `/pe-meta-scheduled-review --dim freshness` | dim=freshness, deps=auto-rotation, scope=all | Dim override, deps from rotation |
| A-S03 | `/pe-meta-scheduled-review --deps full` | dim=auto, deps=full, scope=all | Override rotation depth |
| A-S04 | `/pe-meta-scheduled-review --scope context --deps direct` | dim=auto, deps=direct, scope=context | Scope + depth override |
| A-S05 | `/pe-meta-scheduled-review --skip research` | dim=auto, deps=auto-rotation, scope=all, skip=[research] | Skip Phase 1 |
| A-S06 | `/pe-meta-scheduled-review --skip external` | dim=auto, deps=auto-rotation, scope=all, skip=[external] | No internet fetching |

### Update family

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-U01 | `/pe-meta-update` | mode=apply, dim=full, scope=all, skip=[] | All defaults |
| A-U02 | `/pe-meta-update --mode plan --skip research` | mode=plan, dim=full, scope=all, skip=[research] | Canonical assessment-only invocation (former `healthcheck` preset) |
| A-U03 | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency` | mode=apply, dim=optimize, scope=all, skip=[research,structure,consistency] | Canonical optimization invocation (former `performancecheck` preset); delegates apply to `@meta-optimizer` |
| A-U04 | `/pe-meta-update --mode plan` | mode=plan, dim=full, scope=all, skip=[] | Plan-only with full pipeline |
| A-U05 | `/pe-meta-update --scope context --dim freshness` | mode=apply, dim=freshness, scope=context, skip=[] | Scope + dim filter |
| A-U06 | `/pe-meta-update --mode apply --skip research,structure` | mode=apply, dim=full, scope=all, skip=[research,structure] | Multi-stage skip |
| A-U07 | `/pe-meta-update --mode plan --skip research --scope prompts --dim quality` | mode=plan, dim=quality, scope=prompts, skip=[research] | Plan + scope + dim composition |
| A-U08 | `/pe-meta-update --incremental --scope agents` | mode=apply, dim=full, scope=agents, skip=[], incremental=true | Incremental flag |

### Release-monitor family

| # | Invocation | Parsed options | Notes |
|---|---|---|---|
| A-RM01 | `/pe-meta-release-monitor <url>` | mode=apply, dim=full, scope=all | Defaults |
| A-RM02 | `/pe-meta-release-monitor <url> --mode plan` | mode=plan, dim=full, scope=all | Preview only |
| A-RM03 | `/pe-meta-release-monitor <url> --scope prompts --dim freshness` | mode=apply, dim=freshness, scope=prompts | Filter scope/dims |
| A-RM04 | `/pe-meta-release-monitor <url> --skip external` | mode=apply, dim=full, scope=all, skip=[external] | No additional URL fetching |

## Rejected combinations with corrective messages

| # | Invalid invocation | Rejection | Corrective action |
|---|---|---|---|
| R-01 | `/pe-meta-review path.md --mode apply` | `--mode is not supported by pe-meta-review because review is read-only.` | Remove --mode or use /pe-meta-update for apply workflows. |
| R-02 | `/pe-meta-design desc --deps full` | `--deps is not supported by pe-meta-design because design does not traverse dependencies.` | Remove --deps or use /pe-meta-review for dependency analysis. |
| R-03 | `/pe-meta-adherence path.md --dim full` | `--dim is not supported by pe-meta-adherence because adherence uses a fixed dimension set.` | Remove --dim. |
| R-04 | `/pe-meta-review path.md --skip structure` | `--skip structure is not supported in type-specific review because phase-level skipping requires the orchestration pipeline.` | Use --skip research or --skip external, or use /pe-meta-update for phase control. |
| R-05 | `/pe-meta-review path.md --skip consistency` | `--skip consistency is not supported in type-specific review because phase-level skipping requires the orchestration pipeline.` | Use --skip research or --skip external, or use /pe-meta-update for phase control. |
| R-06 | `/pe-meta-design desc --skip research` | `--skip is not supported by pe-meta-design because design has no pipeline phases.` | Remove --skip. |
| R-07 | `/pe-meta-adherence path.md --mode plan` | `--mode is not supported by pe-meta-adherence because adherence is always read-only.` | Remove --mode. |
| R-08 | `/pe-meta-adherence path.md --skip external` | `--skip is not supported by pe-meta-adherence because adherence has no pipeline phases.` | Remove --skip. |
| R-09 | `/pe-meta-scheduled-review --mode apply` | `--mode is not supported by pe-meta-scheduled-review because scheduled-review delegates execution to sub-commands.` | Remove --mode. For apply control, configure the scheduled-review delegation target. |
| R-10 | `/pe-meta-scheduled-review --skip structure` | `--skip structure is not supported in scheduled-review because phase-level skipping requires the update pipeline.` | Use --skip research or --skip external, or invoke /pe-meta-update directly for phase control. |
| R-11 | `/pe-meta-create-update path.md --deps direct` | `--deps is not supported by pe-meta-create-update because create-update does not traverse dependencies.` | Remove --deps. |
| R-12 | `/pe-meta-create-update path.md --mode plan` | `--mode is not supported by pe-meta-create-update because create-update always writes.` | Remove --mode. |

## Alias routing behavior

| # | Input (legacy syntax) | Routed to (canonical) | Verification |
|---|---|---|---|
| AL-01 | `/pe-meta-review path.md --with-deps` | `--deps full` | Full bounded traversal (depth 5) |
| AL-02 | `/pe-meta-review path.md --with-deps-shallow` | `--deps direct` | First-level only (depth 1) |
| AL-03 | `/pe-meta-update --plan` | `--mode plan` | Preview without apply |
| AL-04 | `/pe-meta-update --no-external` | `--skip external` | No URL fetching |
| AL-05 | `/pe-meta-update --no-research` | `--skip research` | Skip Phase 1 |
| AL-06 | `/pe-meta-update --skip-source` | `--skip research` | Skip Phase 1 |
| AL-07 | `/pe-meta-update --skip-structure` | `--skip structure` | Skip Phase 2 |
| AL-08 | `/pe-meta-update --skip-consistency` | `--skip consistency` | Skip Phase 3 |
| AL-09 | `/pe-meta-update --skip-content` | `--skip content` | Skip Phase 4 |

## Scope + deps composition behavior

### Orchestration context (update, scheduled-review)

| # | Invocation | Scope effect | Deps effect | Combined behavior |
|---|---|---|---|---|
| SC-01 | `/pe-meta-update --scope context` | Iterate context files only | N/A (update doesn't use deps) | Batch processes only context artifacts |
| SC-02 | `/pe-meta-scheduled-review --scope agents --deps full` | Iterate agent files only | Full chain per agent | Reviews each agent with full dependency traversal |
| SC-03 | `/pe-meta-update --scope prompts,skills` | Iterate prompts and skills | N/A | Batch processes prompts + skills only |

### Type-specific context (review, adherence)

| # | Invocation | Scope effect | Deps effect | Combined behavior |
|---|---|---|---|---|
| SC-04 | `/pe-meta-prompt-review p.md --scope context --deps full` | Filter deps to context type | Full depth (5) | Follow full chain, examine only context file dependencies |
| SC-05 | `/pe-meta-agent-review a.md --scope instructions --deps direct` | Filter deps to instructions | First-level only | Check only direct instruction dependencies |
| SC-06 | `/pe-meta-context-review c.md --scope prompts --deps direct` | Filter deps to prompts | First-level | Find prompts that directly consume this context |
| SC-07 | `/pe-meta-review path.md --deps full` (no scope) | All dep types | Full depth | Traverse all dependency types (default behavior) |

## Skip stage validation

### Valid stages per command context

| # | Context | Valid skip stages | Invalid skip stages |
|---|---|---|---|
| SV-01 | Orchestrators (update) | research, external, structure, consistency, content | Any other value |
| SV-02 | Type-specific review | research, external | structure, consistency, content |
| SV-03 | Scheduled-review | research, external | structure, consistency, content |
| SV-04 | Release-monitor | research, external | structure, consistency, content |
| SV-05 | Creation (design, create-update) | _(none — --skip not supported)_ | All values |
| SV-06 | Adherence | _(none — --skip not supported)_ | All values |

### Invalid stage name rejection

| # | Invalid invocation | Rejection |
|---|---|---|
| SV-07 | `/pe-meta-update --skip validation` | `Unknown skip stage 'validation'. Valid stages: research, external, structure, consistency, content.` |
| SV-08 | `/pe-meta-update --skip apply` | `Unknown skip stage 'apply'. Valid stages: research, external, structure, consistency, content.` |
| SV-09 | `/pe-meta-update --skip ` (empty) | `--skip requires at least one stage name. Valid stages: research, external, structure, consistency, content.` |

## Conflicting option detection

| # | Invalid invocation | Rejection |
|---|---|---|
| CF-01 | `/pe-meta-review path.md --deps full --deps direct` | `Conflicting --deps values. Specify one: --deps none, --deps direct, --deps full, or --deps <N>.` |
| CF-02 | `/pe-meta-update --mode plan --mode apply` | `Conflicting --mode values. Specify one: --mode plan or --mode apply.` |
| CF-03 | `/pe-meta-update healthcheck` | `"healthcheck" is no longer a supported preset. Use the canonical options per the v13 taxonomy. See pe-meta-update.prompt.md § Invocation options for the mapping.` |
| CF-04 | `/pe-meta-update performancecheck --dim structural` | `"performancecheck" is no longer a supported preset. Use the canonical options per the v13 taxonomy. See pe-meta-update.prompt.md § Invocation options for the mapping.` |
| CF-05 | `/pe-meta-review path.md --dim invented-name` | `Unknown --dim value 'invented-name'. Valid groups: full, structural, quality, strategic, freshness, efficiency, adherence, context-full, context-health, model, optimize, reliability. Or use a specific dimension ID (D1-D35). Deprecated alias: 'robustness' → 'adherence'.` |
| CF-06 | `/pe-meta-review path.md --dim robustness` | _accepted with notice_ — `[DEPRECATION] --dim robustness is deprecated; resolving to --dim adherence. Update invocations to --dim adherence before the next release.` |
| CF-07 | `/pe-meta-update fullcheck` | `"fullcheck" is no longer a supported preset. Use the canonical options per the v13 taxonomy. See pe-meta-update.prompt.md § Invocation options for the mapping.` |
