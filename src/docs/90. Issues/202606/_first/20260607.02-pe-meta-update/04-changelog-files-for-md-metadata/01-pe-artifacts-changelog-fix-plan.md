---
status: done
target_vision_version: v15.7.0
domain: prompt-engineering
created: 2026-06-12
goal: "Make the placement of change-prone tracking metadata (version, last_updated, and the changelog pointer) uniform across articles and all dual-block PE artifacts by moving it out of top frontmatter and into the bottom metadata block — first by stating the rule in the vision and the metadata-contract authority, then by refactoring every PE artifact to conform."
---

# Plan — PE-artifact metadata uniformity (pe-artifacts-changelog-fix-20260612)

## 🎯 Goal

**Verbatim trigger:** *"please use the same metadata attributes for `version`/`last_updated` across articles and prompt engineering artifacts. As this information is subject to change it should be probably put into the bottom metadata. Please make a plan to (1) update the vision document to explain that pe artifacts should be handled with metadata and change metadata attributes should be in the bottom metadata, and (2) refactor all prompt engineering artifacts to conform to the new rules."*

### Why this change

Articles and templates already keep their change-prone tracking fields (`version`, `last_updated`, and now a `changelog:` pointer) in the **bottom** metadata block, separated from the invariant top-frontmatter. PE **agents** and **prompts** do not follow this: they carry `version`/`last_updated` in **top frontmatter** (mandated by `00.03-metadata-contracts.md` as universal top-level fields and by `pe-agents.instructions.md` / `pe-prompts.instructions.md`), while *also* duplicating `version`/`last_updated` in an informal bottom `{type}_metadata` block alongside the `changes:` history. The result is a split, partly-duplicated, inconsistent model.

The user's principle is: **metadata that is subject to change belongs in the bottom block**; invariant discovery/config metadata stays in the top block. Adopting it uniformly removes the duplication, aligns PE artifacts with the article dual-metadata model, and lets a single future component (MetadataWatcher) manage `version`/`last_updated`/changelog the same way everywhere.

The rule applies to **every artifact type**, including the single-block context and instruction files: keeping their `version`/`last_updated` in the top block contradicts the stable-top/variable-bottom principle the user is establishing. Single-block types therefore gain a bottom `{type}_metadata` HTML-comment block holding only the change-prone tracking fields — same field names and position as articles. Stable, machine-read top fields (`description`, `domain`, `applyTo`, `title`, `goal`, `scope`, `boundaries`, `rationales`) stay in the top block.

### What "uniform" means here (placement contract)

| Block | Holds | Modified by |
|---|---|---|
| **Top YAML frontmatter** | *Invariant discovery/config* — `description`, `domain`, `applyTo` (instructions), `agent`/`tools`/`handoffs` (agents/prompts), `name` (prompts/skills), `goal`, `scope`, `boundaries`, `rationales`, `capabilities`, `context_dependencies` | Authors / design changes |
| **Bottom `{type}_metadata` HTML comment** | *Change-prone tracking* — `version`, `last_updated`, `created`, `consumers`/`filename`/`type` (where used), and a `changelog:` pointer to the sibling history file | Validation/review automation + MetadataWatcher |

### Scope boundary (which artifact types move)

| Type | Current `version`/`last_updated` location | Action |
|---|---|---|
| Articles | bottom `article_metadata` | none (already conformant; reference model) |
| Templates | bottom `template_metadata` | verify field-name parity + add `changelog:` pointer convention |
| **Agents** | **top frontmatter + duplicated bottom `agent_metadata`** | **move to bottom-only** |
| **Prompts** | **top frontmatter + duplicated bottom `*_metadata`** | **move to bottom-only** |
| **Context files** | **top frontmatter only (single-block)** | **add bottom `context_metadata` block; move `version`/`last_updated` there** — see Decision D3 |
| **Instruction files** | **top frontmatter only (single-block)** | **add bottom `instruction_metadata` block; move `version`/`last_updated` there** — see Decision D3 |
| Skills (`SKILL.md`) | top frontmatter (often no version) | verify; move only if a tracking field exists — see Decision D4 |
| Hooks (`.json`) | JSON schema | N/A (no YAML metadata) |

### Goal table

| # | Item | Scope tag | Principle impact | Downstream landing | Status |
|---|---|---|---|---|---|
| 1 | **Amend the vision** to state that change-prone tracking metadata (`version`, `last_updated`, changelog pointer) lives in the **bottom** metadata block and invariant discovery/config metadata in the **top** block — a uniform application of structural separation (N-1) across all dual-block artifact types. Add the corresponding line to the vision changelog. | `[in-scope: original]` | preserves: metadata-driven, single-source-of-truth, structural-separation; touches: structural-separation (P0 — *additive clarification only*, no covered topic removed; if confirmed P0, add consent line) | landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md (+ .changelog.md) | ✅ done |
| 2 | **Update the metadata-contract authority** (`00.03-metadata-contracts.md`): change the field-placement rule so `version`/`last_updated` (+ optional `changelog:`) are **bottom-block** fields for **every** artifact type (articles, templates, agents, prompts, context, instruction). Replace the "All fields go in top-level YAML frontmatter" statement with a top-vs-bottom split: stable discovery/config fields top, change-prone tracking fields bottom. | `[in-scope: original]` | preserves: metadata-driven; touches: metadata field-placement contract (the authority the vision delegates to) | landing: .copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md | ✅ done |
| 3 | **Update `pe-agents.instructions.md`:** remove `version`/`last_updated` from the "PE agents add these fields" top-frontmatter spec; add a **Bottom Metadata (REQUIRED)** section specifying the bottom `agent_metadata` block (`version`, `last_updated`, `created`, optional `changelog:` pointer). | `[in-scope: original]` | preserves: metadata-driven; touches: agent metadata spec | landing: .github/instructions/pe-agents.instructions.md | ✅ done |
| 4 | **Update `pe-prompts.instructions.md`:** same treatment — drop `version`/`last_updated` from top-frontmatter requirement (C6), add Bottom Metadata (REQUIRED) section specifying a bottom `prompt_metadata` block. | `[in-scope: original]` | preserves: metadata-driven; touches: prompt metadata spec | landing: .github/instructions/pe-prompts.instructions.md | ✅ done |
| 5 | **Verify/align `pe-templates.instructions.md`:** templates already specify bottom `template_metadata`; confirm field-name parity (`version`, `last_updated`, `created`, `consumers`) and add the `changelog:` pointer convention so all four dual-block types match. | `[in-scope: original]` | preserves: metadata-driven; touches: template metadata spec | landing: .github/instructions/pe-templates.instructions.md | ✅ done |
| 6 | **Update the readers** (validators + cascade-staleness logic) so they read `version`/`last_updated` from the **bottom** block for every artifact type: `pe-meta-validator.agent.md`, `pe-gra-agent-validator.agent.md`, the dimension checklists/catalog in `05.07`/`05.08`, and any cascade-staleness comparison in `pe-context-files.instructions.md` / scheduled-review logic that compares top-frontmatter `last_updated`. | `[in-scope: original]` | preserves: metadata-driven, deterministic-where-possible; touches: validation/cascade readers (must move with the contract or de-duplicated artifacts get re-flagged) | landing: .github/agents/00.09-pe-meta/pe-meta-validator.agent.md, .github/agents/00.02-pe-granular/pe-gra-agent-validator.agent.md, .copilot/context/00.00-prompt-engineering/05.07-*, 05.08-*, .github/instructions/pe-context-files.instructions.md | ✅ done |
| 7 | **Refactor agents (~14):** for every `*.agent.md` carrying top-frontmatter `version`/`last_updated`, remove those two fields from the top block and ensure the bottom `agent_metadata` block carries `version`, `last_updated`, `created` (+ `changelog:` pointer). No history loss — leave existing `changes:`/changelog handling untouched. | `[in-scope: original]` | preserves: metadata-driven; touches: agent artifacts | landing: .github/agents/** | ✅ done |
| 8 | **Refactor prompts (~17):** same as item 7 for `*.prompt.md`, using a bottom `prompt_metadata` block. | `[in-scope: original]` | preserves: metadata-driven; touches: prompt artifacts | landing: .github/prompts/** | ✅ done (version-bearing relocated; 12 version-less prompts back-filled with bottom `prompt_metadata` v1.0.0 / 2026-06-12 per user decision) |
| 9 | **Verify templates (~60):** confirm none carry top-frontmatter `version`/`last_updated`; ensure bottom `template_metadata` field names match the contract; add `changelog:` pointer where a sibling changelog exists. | `[in-scope: original]` | preserves: metadata-driven; touches: template artifacts | landing: .github/templates/** | ✅ done (field-name parity verified; 20 version-less templates back-filled with a distinct bottom `template_metadata` v1.0.0 / 2026-06-12; example `article_metadata` output blocks left untouched) |
| 10 | **Update the pe-instruction-files / pe-context-files instruction specs:** add a **Bottom Metadata (REQUIRED)** section to `pe-instruction-files.instructions.md` and `pe-context-files.instructions.md` specifying the bottom `instruction_metadata` / `context_metadata` block (`version`, `last_updated`, optional `changelog:`); remove `last_updated`/`version` from their top-frontmatter requirement. | `[in-scope: original]` | preserves: metadata-driven; touches: context/instruction metadata spec | landing: .github/instructions/pe-instruction-files.instructions.md, .github/instructions/pe-context-files.instructions.md | ✅ done |
| 11 | **Refactor context files:** for every `.copilot/context/**/*.md` carrying top-frontmatter `version`/`last_updated`, add a bottom `context_metadata` HTML-comment block with those fields and remove them from the top block; leave `title`/`description`/`domain`/`goal`/`scope`/`boundaries`/`rationales` in the top block. | `[in-scope: original]` | preserves: metadata-driven, single-source-of-truth; touches: context artifacts | landing: .copilot/context/** | ✅ done |
| 12 | **Refactor instruction files:** same as item 11 for `.github/instructions/*.instructions.md`, using a bottom `instruction_metadata` block; keep `applyTo`/`description`/`domain` in the top block. **Vision docs follow the uniform article rule** (their `version`/`last_updated` move to the bottom `article_metadata` block per Decision D7); **use-case docs carry no `version`/`last_updated` field**, so they need no change. | `[in-scope: original]` | preserves: metadata-driven; touches: instruction artifacts | landing: .github/instructions/** | ✅ done |
| 13 | **Validate:** run `get_errors` across every touched file; spot-check that cascade-staleness and the metadata-guard post-change reconciliation resolve `version`/`last_updated` from the new location for at least one of each: agent, prompt, context file, instruction file. | `[in-scope: original]` | n/a (verification) | landing: all touched files | ✅ done |

## 📋 Current-state findings (analysis)

- **F1 — Split placement.** Articles/templates track `version`/`last_updated` in the bottom block; agents/prompts track them in top frontmatter. (root inconsistency the user flagged)
- **F2 — Duplication in agents/prompts.** The same `version`/`last_updated` appear in *both* the top frontmatter *and* an informal bottom `{type}_metadata` block — two sources of truth that can drift.
- **F2b — Drift is observed, not hypothetical.** The meta-review log records exactly this defect: `pe-meta-validator` top-frontmatter `version: "2.2.2"` drifted from bottom `agent_metadata.version: "2.2.3"` because a change shipped its bottom-block edit but missed the duplicated frontmatter field ([05.04-meta-review-log.md](../../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) F1). A single bottom-only source eliminates this class of bug.
- **F3 — Authority conflict.** `00.03-metadata-contracts.md` declares `version:` a universal **top-level** field; the target rule makes it a bottom-block field for **all** artifact types. The authority must be updated before artifacts, or validators re-flag conformant files.
- **F4 — Reader coupling.** Cascade-staleness detection and validators read top-frontmatter `last_updated`/`version`; moving the fields without updating readers breaks staleness detection. This now extends to context/instruction readers too.
- **F5 — Single-block types get a bottom block.** Context/instruction files are frontmatter-dominant config with no existing bottom block. To honor the stable-top/variable-bottom rule consistently (user decision), they gain a minimal bottom `{type}_metadata` HTML-comment block carrying only `version`/`last_updated` (+ optional `changelog:`); all stable machine-read fields (`applyTo`, `description`, `domain`, `title`, `goal`, `scope`, `boundaries`) stay in the top block.

## 🧭 Decisions

| ID | Decision | Choice | Rationale |
|---|---|---|---|
| D1 | Placement of change-prone fields | Bottom `{type}_metadata` block | Matches the article model; "subject to change → bottom" per the trigger |
| D2 | Scope of the move | **All artifact types** with a `version`/`last_updated` field: articles (done), templates (done), agents, prompts, context, instruction | The stable-top/variable-bottom rule is universal; applying it everywhere is what makes the model consistent and lets one component manage it uniformly |
| D3 | Context & instruction files | **Move `version`/`last_updated` to a bottom `{type}_metadata` HTML-comment block** (same names/position as articles); add the bottom block since they lack one | *User decision:* keeping them on top contradicts the stable-top/variable-bottom rule. Stable machine-read fields (`applyTo`, `description`, `domain`) stay top; only change-prone tracking fields move. Readers (cascade staleness, validators) move with them (item 6). |
| D4 | Skills | Move only if a tracking field is present | Skills are discovery-by-description; most carry no `version`. Verify per file. |
| D5 | History (`changes:`) | Out of scope for this plan beyond adding the `changelog:` pointer | History externalization to sibling `*.changelog.md` is the related effort tracked in the sibling `04-changelog-files-for-md-metadata/overview.md`; this plan only relocates `version`/`last_updated` + the pointer |
| D6 | Sequencing | Authority/rules (items 1–6, 10) MUST land before artifacts (items 7–9, 11–12) | Otherwise validators re-flag conformant artifacts under the old top-frontmatter rule |
| D7 | Vision & use-case docs | **In scope (uniform), not an exception** | A vision document **is an article**: by the article dual-metadata rule (the model this whole effort aligns to), its `version`/`last_updated` belong in the bottom `article_metadata` block, not top frontmatter. Keeping them top was the very contradiction this plan removes — so the vision is brought into compliance (version/last_updated relocated to its bottom `article_metadata`), and `vision-frontmatter.instructions.md` gains an explicit placement rule. **Use-case docs carry no `version`/`last_updated` field at all** (their schema is Group/Priority/Order/Vision anchor/Default breadth), so there is nothing to move. The `scope.covers:`/`principles:` governance blocks stay in vision top frontmatter because the amendment gate reads them there — those are *not* tracking fields and are untouched. |

## 📋 Things to do (ordered)

1. Vision amendment + vision changelog — item 1. (follow `vision-frontmatter.instructions.md` for the `principles:`/`scope.covers` edit) — ✅ done
2. Metadata-contract authority — item 2. — ✅ done
3. Instruction-layer specs — items 3, 4, 5, 10. — ✅ done
4. Reader/validator alignment — item 6. — ✅ done
5. Agent refactor — item 7. — ✅ done
6. Prompt refactor — item 8. — ✅ done (12 version-less prompts back-filled)
7. Template verification — item 9. — ✅ done (20 version-less templates back-filled)
8. Context-file refactor — item 11. — ✅ done
9. Instruction-file refactor — item 12. — ✅ done
10. Validation pass — item 13. — ✅ done

## 🅿️ Park lot

- **Version-less artifacts back-filled (32 files: 12 prompts + 20 templates).** ✅ resolved — per the user's decision (2026-06-12), each version-less in-scope file received a fresh bottom `{type}_metadata` block with `version: "1.0.0"` and `last_updated: "2026-06-12"`. Prompts → `prompt_metadata`; templates → a distinct `template_metadata` block appended after (never merged into) any example `article_metadata` output block. `→ closed: back-filled`.
- **Externalize PE `changes:` history to sibling `*.changelog.md`** across the 91 artifacts → `→ closed: done by 02-changelog-externalization-plan.md` (98 in-scope files migrated — PE artifacts + active articles; this plan added only the `changelog:` pointer, the sibling plan moved the history).
- **MetadataWatcher unified changelog/version management** (the "single future component") → `→ defer` (the .NET source is not in this checkout; flipping automation on is a later, additive step).
- **Move vision/use-case-doc `version` to a bottom block** — ✅ resolved: the active vision's `version`/`last_updated` were relocated to its bottom `article_metadata` block (uniform with all articles), and `vision-frontmatter.instructions.md` gained an explicit placement rule (+ checklist item). Use-case docs carry no `version`/`last_updated` field, so no change was needed. `→ closed: made uniform (D7 revised)`.
- **Skills/hooks version tracking convention** if a broader versioning need emerges → `→ defer`.

## ✅ Exit criteria

- Vision states the bottom-vs-top placement rule for change-prone tracking metadata, and the vision changelog records it.
- `00.03-metadata-contracts.md`, `pe-agents.instructions.md`, `pe-prompts.instructions.md`, `pe-templates.instructions.md`, `pe-context-files.instructions.md`, and `pe-instruction-files.instructions.md` agree on the placement contract: stable fields top, change-prone tracking fields bottom, for every artifact type.
- No agent, prompt, context file, or instruction file carries `version`/`last_updated` in top frontmatter; every one carries them in its bottom `{type}_metadata` block exactly once (no duplication). The active vision document follows the same article rule (`version`/`last_updated` in its bottom `article_metadata` block); use-case docs carry no such field.
- Validators and cascade-staleness logic read `version`/`last_updated` from the new location; a spot-check on one of each type (agent, prompt, context, instruction) passes.
- `get_errors` is clean across all touched files.

## 📚 Related

- Sibling analysis (article changelog externalization): [overview.md](overview.md)
- Vision: [20260531.01-vision.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)
- Metadata authority: [00.03-metadata-contracts.md](../../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md)
- Article dual-metadata model: [02-dual-yaml-metadata.md](../../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md)
