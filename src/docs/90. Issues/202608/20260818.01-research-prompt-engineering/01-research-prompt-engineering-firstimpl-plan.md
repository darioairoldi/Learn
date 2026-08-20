---
title: "Agentic SDLC frameworks — landscape research and PE artifact first implementation"
author: "Dario Airoldi"
date: "2026-08-18"
status: "actionable"
domain: "prompt-engineering"
description: "Thin-slice plan to research the spec-driven and agentic-SDLC framework landscape, publish a new Learn section, and extend the documentation agent triad with landscape-research and comparison capabilities."
goal: "Extend the existing documentation agent triad with a landscape-research phase and a comparison mode, prove both by researching the spec-driven / agentic-SDLC framework landscape, and publish the result as a new Learn section at 03.00-tech/05.04-agentic-development-frameworks/"
scope:
  covers:
    - "Landscape research contract (enumerate → gate sources → compare on fixed dimensions)"
    - "Extension of documentation-researcher, documentation-builder, and documentation-design"
    - "Greenfield subject-area scaffolding (folder + metadata.yml + roadmap.md + taxonomy)"
    - "Pilot subject: Spec Kit, HVE Core, Squad, loop engineering, and the SDD tool landscape"
    - "Friction harvest that folds pilot findings back into the artifacts"
  excludes:
    - "General-purpose multi-agent runtimes and SDKs (Agent Framework, AutoGen, CrewAI, LangGraph)"
    - "Session-scoped guided-tutor learning modes"
    - "Adoption of any framework into this repository's own workflow"
    - "Disposition of the existing empty 03.00-tech/05.03-ai-frameworks/ folder"
---

# Agentic SDLC frameworks — landscape research and PE artifact first implementation

## Table of contents

- 🎯 [Objective](#objective)
- 🧭 [Motivation](#motivation)
- 📋 [Decisions locked](#decisions-locked)
- 🔎 [Analysis A — the subject landscape](#analysis-a--the-subject-landscape)
- 🔎 [Analysis B — how current PE artifacts face this use case](#analysis-b--how-current-pe-artifacts-face-this-use-case)
- 🔎 [Analysis C — approach comparison and recommended structure](#analysis-c--approach-comparison-and-recommended-structure)
- ⚙️ [Things to do — WS-A-landscape-research-contract](#things-to-do--ws-a-landscape-research-contract)
- ⚙️ [Things to do — WS-B-triad-extension](#things-to-do--ws-b-triad-extension)
- ⚙️ [Things to do — WS-C-pilot-scaffold-and-research](#things-to-do--ws-c-pilot-scaffold-and-research)
- ⚙️ [Things to do — WS-D-pilot-article-slice](#things-to-do--ws-d-pilot-article-slice)
- ⚙️ [Things to do — WS-E-harvest-and-widen](#things-to-do--ws-e-harvest-and-widen)
- 🧪 [Exit criteria](#exit-criteria)
- 🧩 [Open decisions](#open-decisions)
- 🔦 [Discovery](#discovery)
- 🅿️ [Park lot](#park-lot)
- 📚 [References](#references)

---

## 🎯 Objective

Make "learn a new external subject and turn it into a Learn section" a **repeatable, artifact-supported workflow**, and prove it on one real subject in the same pass.

Concretely, this plan delivers three things at once, in a single vertical slice:

1. A reusable **landscape-research contract** — how to enumerate a tool/framework landscape, gate its sources, and compare entries on a fixed dimension set.
2. A **minimal extension of the existing documentation agent triad** so it can start from an empty folder and an external subject, not only from an existing article set.
3. A **published Learn section** at `03.00-tech/05.04-agentic-development-frameworks/` covering the spec-driven and agentic-SDLC framework landscape, built by running (1) and (2).

The subject research is not a side effect — it is the **acceptance test** for the artifact work.

---

## 🧭 Motivation

The triggering need was a learning need: understand Squad, Spec Kit, HVE-Core, loop engineering, and the surrounding spec-driven tooling well enough to have an opinion about them.

Answering that once by hand is cheap. Answering it *every time a new landscape appears* is not — and landscapes now appear monthly. The repository already automates most of the pipeline, but it has a specific shape mismatch:

- Every research artifact assumes **a subject already inside the corpus**. `documentation-researcher` opens with `list_dir` on the target folder and assesses the articles it finds. Given an empty folder it degrades to "recommend creating initial documentation set. Provide subject area to research topics" — it hands the hard part back to the user.
- Nothing produces a **side-by-side comparison** as a first-class output. Comparison exists only as a by-product ("document alternatives in an appendix").
- Nothing **scaffolds a new subject area** — folder, `metadata.yml`, taxonomy bands, `roadmap.md` — before articles are written.

So the pipeline is strong from *"here is a research report"* onward, and weak from *"here is a subject I know nothing about"* up to that point. This plan closes exactly that head-end gap and nothing more.

---

## 📋 Decisions locked

Resolved with the requester before this body was authored. These are inputs, not proposals.

| Id | Decision | Chosen | Consequence |
|---|---|---|---|
| **D1-slice-sequencing** | How to sequence artifact work vs content work | Interleaved thin slice — build minimum → prove → iterate | No artifact is generalized before one real use validates it |
| **D2-section-location** | Where the Learn section lives | New folder `03.00-tech/05.04-agentic-development-frameworks/` | Fresh taxonomy; `05.03-ai-frameworks` untouched |
| **D3-scope-breadth** | How wide the subject is | Medium — the three named tools + loop engineering + the full SDD tool landscape | Multi-agent runtimes and SDKs are out |
| **D4-artifact-strategy** | How to close the PE gap | Extend existing artifacts (landscape-research phase + comparison mode on the documentation triad) | No new agent domain; no new triad |

**Taxonomy band naming** is resolved from evidence rather than preference: `08-observation-to-integration-workflow.md` mandates deriving folders from the subject-folder template `00-overview · 01-getting-started · 02-concepts · 03-how-to · 04-analysis · 05-reference · 06-resources`, matching a *local* convention only where one already exists. `05.04-` is greenfield, so the generic template applies verbatim.

---

## 🔎 Analysis A — the subject landscape (✅ done)

Establishes what the pilot has to cover, and answers the "do you know others?" question that triggered this work. Verified against primary sources on 2026-08-18.

### The three named entries

| Entry | What it actually is | Shape | Signal |
|---|---|---|---|
| **Spec Kit** (`github/spec-kit`) | A spec-driven development *process toolkit*. `specify` CLI installs slash commands into 30+ agents: `constitution → specify → clarify → plan → tasks → analyze → implement`, plus `converge` and `checklist`. Customization layers: project overrides → presets → extensions → core; `bundles` package role-based setups | Process + templates, agent-agnostic | 130k ★, v0.16.4, very high velocity |
| **HVE Core** (`microsoft/hve-core`) | Microsoft ISE's **Hypervelocity Engineering** library: agents, prompts, instructions and skills packaged as a VS Code extension / Copilot CLI plugin. Core methodology is **RPI — Research, Plan, Implement, Review** | Opinionated agentic SDLC component library | 1.3k ★; ships an explicit "treat as patterns, not a platform" caution |
| **Squad** (`bradygaster/squad`) | A **multi-agent runtime** for Copilot. `squad init` casts a team of named specialists persisted as files in `.squad/` (charters, histories, decisions, routing); coordinator fans out work in parallel; "Ralph" watch mode polls issues and dispatches agents | Runtime + durable team state | 3.1k ★, alpha, v0.12.0; MS Agent Framework adapter in preview |

The three are **not competitors** — they occupy different layers. Spec Kit governs *what gets built*, HVE Core governs *how a single agent proceeds through the SDLC*, Squad governs *who does the work and how they coordinate*. That layering is the single most useful insight for a reader, and should be the spine of the overview article.

### The wider SDD landscape (in scope per D3)

| Tool | Distinguishing position |
|---|---|
| **Kiro** (AWS) | Spec-driven *IDE*; ships a fixed three-file spec (`requirements` / `design` / `tasks`) |
| **Tessl** | Spec as the durable source of truth with a spec registry — code becomes the derived artifact |
| **OpenSpec** | Open, lightweight spec workflow; positions explicitly against Spec Kit/BMAD/Kiro |
| **BMAD-METHOD** | Agile-role-based AI development (analyst/PM/architect/dev personas) |
| **Agent OS** (Builder Methods) | Standards + product-context layer for agent coding |
| **GSD, Hermes, BrainGrid, CodeMySpec** | Smaller/commercial entrants; useful for market-shape framing, not deep coverage |

### Adjacent framing already in the corpus

**Loop engineering** is already covered by `01.00-news/20260710.01-loop-engineering/overview.md`, which frames the prompt → context → loop progression and Osmani's six primitives (automations, worktrees, skills, connectors, sub-agents, state). The new section must **cross-link to it, not restate it** — loop engineering is the *why* behind these frameworks; the frameworks are the *what*.

### Dimensions that make the comparison decision-useful

Derived from what actually differs across the entries above. This set becomes the fixed comparison contract in WS-A.

`layer` · `unit of work` · `artifact surface` · `state/memory model` · `agent coupling` · `human gate` · `extensibility model` · `maturity & governance` · `adoption cost` · `exit cost`

---

## 🔎 Analysis B — how current PE artifacts face this use case (✅ done)

Assessed against the pipeline this use case actually needs: **enumerate a landscape → gate sources → compare → scaffold an area → write → validate**.

| Stage | Coverage | Closest existing artifact | Verdict |
|---|---|---|---|
| Investigate one external thing | ✅ strong | `lh-observation-investigator` + `08-observation-to-integration-workflow.md` | Reuse as-is |
| Judge whether a source is trustworthy | ✅ strong | `09-source-soundness-gate.md` (six dimensions, gating verdict) | Reuse as-is |
| Enumerate an unknown **landscape** of N candidates | ❌ absent | — | **Gap 1** |
| Compare N entries side-by-side as a first-class output | ❌ absent | comparison exists only as "alternatives in an appendix" | **Gap 2** |
| Scaffold a **new** subject area (folder + metadata + taxonomy + roadmap) | ❌ absent | `lh-observation-investigator` places into *existing* taxonomy only | **Gap 3** |
| Plan an article set with Diátaxis coverage | ✅ strong | `documentation-design` Phases 3–5 | Reuse as-is |
| Write and validate articles | ✅ strong | `documentation-builder`, `documentation-validator`, `article-review` skill | Reuse as-is |
| Deep single-topic investigation | ✅ strong | `task-researcher`, `research-technical-spike` | Reuse; do not duplicate |

**The head-end assumption is the whole problem.** `documentation-researcher` Phase 1 is "list folder contents → catalog articles → map relationships → assess Diátaxis coverage". Every step presumes local content exists. Its own documented empty-folder response confirms it: it asks the user to supply the topics. That is precisely the work this use case needs automated.

**Everything downstream is already right.** The triad's contracts — handoff token budgets, summarization protocol, phase gates, 7-dimension validation, series-level checks — are exactly what a landscape build needs. Replacing them would be waste.

Conclusion: this is a **three-gap head-end problem**, not a missing-pipeline problem. That is what makes D4 (extend) the correct strategy rather than a new domain.

---

## 🔎 Analysis C — approach comparison and recommended structure (✅ done)

### The three candidate structures

| | **Option 1 — new `02.00-subject-research/` domain triad** | **Option 2 — extend the documentation triad** (chosen) | **Option 3 — single orchestrator prompt only** |
|---|---|---|---|
| **New artifacts** | 3 agents + 1–2 prompts + context files | 1 context file | 1 prompt |
| **Touched artifacts** | 0 | 3 (researcher, builder, orchestrator) | 0 |
| **Duplication risk** | High — new researcher re-implements inventory, gating, handoff and summarization contracts | Low — the three gaps are additive; downstream contracts reused verbatim | None |
| **Handoff integrity** | New contracts must be written and validated from scratch | Existing contracts extended, already validated | Prompt must re-specify orchestration each invocation |
| **Discoverability** | Clear — a dedicated `/subject-research` surface | Good — same entry point, wider input domain | Good |
| **Failure mode** | Two overlapping research families drift apart | Researcher agent grows a second mode and gets heavier | No agent-level enforcement; behaviour varies per run |
| **Maintenance** | Highest | Moderate | Lowest, but weakest guarantees |
| **Effective when** | Research diverges structurally from documentation | Research is a *front-end phase* of documentation | The workflow is used rarely and ad hoc |

### Why Option 2 wins on this repository's own evidence

- **The gaps are additive, not structural.** All three are pre-Phase-2 concerns. Nothing about writing, validating, or sequencing articles changes. A new domain would fork a pipeline that does not diverge.
- **Duplication is the documented failure mode here.** `pe-artifact-coherence-check` exists specifically to catch rule duplication and drift between artifacts, and `plan-execution.instructions.md` itself was authored to stop a duplicated-rules problem. A parallel researcher would recreate the exact condition the system already guards against.
- **The repo's own idiom is contract-in-context, thin-reference-in-artifact.** `documentation-researcher` loads its rules from a five-row context table; `lh-observation-investigator` defers wholesale to `08-observation-to-integration-workflow.md`. One new context file plus three short references matches the established shape; inlining the contract three times would violate it.
- **Option 3 is too weak for the stated goal.** "Full and comprehensive support" implies enforceable boundaries and gates. A prompt with no agent-level `Always/Never` cannot enforce the source-soundness gate or the comparison contract.

### Recommended artifact structure

```
.copilot/context/01.00-article-writing/
└── 04-subject-landscape-research.md      ← NEW: the reusable contract
       · landscape enumeration protocol (seed → expand → saturate → freeze)
       · comparison dimension catalog + matrix output shape
       · greenfield subject-area scaffolding contract
       · source-soundness gate reuse (delegates to 09-source-soundness-gate.md)

.github/agents/01.00-article-writing/
├── documentation-researcher.agent.md     ← EXTEND: Phase 1B "Landscape survey"
│                                            (branch taken when target folder is
│                                             empty/absent) + matrix output contract
├── documentation-builder.agent.md        ← EXTEND: comparison-article mode
│                                            (matrix → 04-analysis article with a
│                                             source-provenance callout per entry)
└── documentation-validator.agent.md      ← UNCHANGED

.github/prompts/01.00-article-writing/
└── documentation-design.prompt.md        ← EXTEND: Phase 0 "Subject-area scaffolding"
                                             + greenfield branch in Phase 1 gate
```

Four files touched, one file created, zero artifacts retired. Every extension is a **branch on an existing phase**, never a rewrite — which keeps the token cost of the non-greenfield path unchanged.

---

## ⚙️ Things to do — WS-A-landscape-research-contract (🟡 todo)

Author the reusable contract first, so the artifact extensions in WS-B are thin references rather than inline rules.

1. Create `.copilot/context/01.00-article-writing/04-subject-landscape-research.md` with frontmatter following the pattern of `08-observation-to-integration-workflow.md` (`description`, `domain`, `goal`, `scope.covers`, `scope.excludes`, `boundaries`, `rationales`). (🟡 todo)
2. Write the **landscape enumeration protocol** as four named steps with explicit stop conditions: `seed` (named entries from the request), `expand` (comparison articles, awesome-lists, "alternatives to X" pages, topic tags), `saturate` (stop when two consecutive expansion passes surface no new entry passing the seed relevance test), `freeze` (record the enumeration date and the queries used). (🟡 todo)
3. Define the **comparison dimension catalog** as a fixed table, seeded with the ten dimensions from Analysis A, each with a one-line "what a reader decides with this" justification. Declare the rule that a comparison MUST use every catalog dimension or explicitly record why one is not applicable to the landscape. (🟡 todo)
4. Define the **matrix output shape**: one row per entry, one column per dimension, cells constrained to a short phrase; plus a mandatory `layer` grouping so entries occupying different layers are never presented as substitutes. (🟡 todo)
5. Define the **greenfield subject-area scaffolding contract**: target folder path rule, `metadata.yml` fields (`label`, `short`, `icon`, `order`), the taxonomy bands `00-overview · 01-getting-started · 02-concepts · 03-how-to · 04-analysis · 05-reference · 06-resources`, the fractional `XX.YY-` rule for extra articles in one band, and a `roadmap.md` seeded from the planned article list. (🟡 todo)
6. Delegate source trust wholesale to `09-source-soundness-gate.md` with a `📖` reference — restate no gate dimension inline. Add the one landscape-specific rule the gate does not cover: an entry failing the gate is listed in the landscape table with a `not-assessed` marker and excluded from the comparison matrix. (🟡 todo)
7. Register the new file in `.copilot/context/00.00-context-folder-index.md` and in the `01.00-article-writing` domain listing. (🟡 todo)

**Done when:** the file exists, carries all six sections above, and every rule it states is absent from the three artifacts WS-B touches (no duplication).

---

## ⚙️ Things to do — WS-B-triad-extension (🟡 todo)

Minimum viable extension only. Anything not required by the WS-C/WS-D pilot is deferred to WS-E.

1. In `documentation-researcher.agent.md`, add `04-subject-landscape-research.md` to the **Domain Context** table with a one-line "contains" description. (🟡 todo)
2. In the same file, add **Phase 1B — Landscape survey**, entered when Phase 1's `list_dir` finds an empty or absent target folder. Steps: run the enumeration protocol → run the source-soundness gate per entry → emit the landscape table and the comparison matrix → emit proposed Diátaxis coverage. Phase 1A (existing inventory) remains the branch taken when the folder has content. (🟡 todo)
3. Replace the researcher's current empty-folder response (which asks the user for topics) with a pointer into Phase 1B, so an empty folder now triggers work instead of a question. (🟡 todo)
4. Extend the **Phase 4 research-report** structure with two greenfield-only sections: `Landscape inventory` and `Comparison matrix`. Keep both out of the report when Phase 1A ran. (🟡 todo)
5. In `documentation-builder.agent.md`, add a **comparison-article mode**: input is the matrix, output is a `04-analysis` article whose spine is the `layer` grouping, with a source-provenance callout per entry (representative snapshot adjacent to the classified canonical link plus a one-line description) as required by `08-observation-to-integration-workflow.md`. (🟡 todo)
6. In `documentation-design.prompt.md`, add **Phase 0 — Subject-area scaffolding**, run only when the target folder does not exist: create the folder, `metadata.yml`, the taxonomy band folders, and a stub `roadmap.md`. Add its outcome as a row in the Gate 1 check. (🟡 todo)
7. In the same prompt, extend the **Gate 1 check** with a `Mode: [greenfield / extend existing]` row, and route Phase 2's researcher handoff to state which mode applies. (🟡 todo)
8. Add the greenfield path to the prompt's **Handoff Data Contracts** and **Summarization Protocol** tables — the landscape matrix must have a declared token ceiling like every other handoff payload. (🟡 todo)
9. Bump `version` and `last_updated` in each touched artifact's metadata block, and add an entry to each sibling `*.changelog.md`. (🟡 todo)

**Done when:** all four files validate against `pe-agents.instructions.md` / `pe-prompts.instructions.md` / `pe-context-files.instructions.md`, and `pe-artifact-coherence-check` reports no rule duplicated between the new context file and the three artifacts.

---

## ⚙️ Things to do — WS-C-pilot-scaffold-and-research (🟡 todo)

First real exercise of WS-A and WS-B. Any friction here is a WS-B defect, not a workaround opportunity.

1. Run `documentation-design` in greenfield mode against `03.00-tech/05.04-agentic-development-frameworks/` with the D3 scope statement, letting Phase 0 create the folder, `metadata.yml`, taxonomy bands, and `roadmap.md`. (🟡 todo)
2. Confirm the created `metadata.yml` places the section correctly in the sidebar next to `05.03-ai-frameworks` — if the `order` value collides or the label renders wrong, fix `metadata.yml` and record the cause in WS-E. (🟡 todo)
3. Run Phase 1B landscape enumeration seeded with Spec Kit, HVE Core, Squad, and loop engineering; expand across the SDD landscape listed in Analysis A. (🟡 todo)
4. Apply the source-soundness gate to every enumerated entry; record each verdict in the landscape table. (🟡 todo)
5. Produce the comparison matrix over the ten catalog dimensions, grouped by `layer`. (🟡 todo)
6. Record the enumeration date and the exact queries used, per the `freeze` step. (🟡 todo)

**Done when:** `03.00-tech/05.04-agentic-development-frameworks/` exists with taxonomy bands and a `roadmap.md`, and a research report carrying a gated landscape table plus a fully populated comparison matrix has been produced.

---

## ⚙️ Things to do — WS-D-pilot-article-slice (🟡 todo)

Two articles only. The slice proves the path end-to-end; breadth is WS-E's decision, not this workstream's.

1. Build `00-overview/00.00-the-agentic-sdlc-framework-landscape.md` (Diátaxis: explanation) whose spine is the **layer model** from Analysis A — what gets built (Spec Kit) vs how one agent proceeds (HVE Core) vs who does the work (Squad) — and which explicitly states that the entries are not substitutes. (🟡 todo)
2. Cross-link the overview to `01.00-news/20260710.01-loop-engineering/overview.md` as the conceptual origin, and to `03.00-tech/05.02-prompt-engineering/` as the customization-mechanism prerequisite. Restate neither. (🟡 todo)
3. Build `04-analysis/04.00-comparing-spec-driven-and-agentic-sdlc-frameworks.md` (Diátaxis: explanation/analysis) from the matrix using the builder's comparison mode, including a source-provenance callout per entry. (🟡 todo)
4. Populate `roadmap.md` with the remaining planned articles per band, each carrying a Diátaxis type and a priority — published rows marked, planned rows listed as planned. (🟡 todo)
5. Run `documentation-validator` on both articles (7 dimensions) and on the pair as a series (architecture, coverage, progression, echo). Resolve every CRITICAL and HIGH finding before WS-E; record MEDIUM and LOW findings in WS-E's harvest. (🟡 todo)
6. Rewrite `src/docs/90. Issues/202608/20260818.01-research-prompt-engineering/overview.md` as a concise issue summary that references only published content and external sources — no links to working artifacts, no duplicated content. (🟡 todo)

**Done when:** both articles pass validation with zero CRITICAL/HIGH findings, `roadmap.md` reflects them as published, and the issue `overview.md` is a summary rather than a workspace.

---

## ⚙️ Things to do — WS-E-harvest-and-widen (🟡 todo)

The iterate half of the thin slice. Runs only after WS-D closes.

1. Write a friction log listing every point in WS-C/WS-D where the operator had to supply a judgement the artifacts should have made, or where an artifact produced an output the next stage could not consume directly. (🟡 todo)
2. For each friction item, decide one of: fix in `04-subject-landscape-research.md` (contract defect), fix in the touched artifact (implementation defect), or park (out of scope). Apply the contract and implementation fixes. (🟡 todo)
3. Fold the MEDIUM and LOW validator findings from WS-D into either an article fix or a builder-mode fix, whichever the finding's cause indicates. (🟡 todo)
4. Re-run `pe-artifact-coherence-check` across the four touched/created files after the fixes. (🟡 todo)
5. Decide the widening step and record it as a sibling plan id: which remaining `roadmap.md` bands get filled next, and in what order. Do not execute the widening under this plan. (🟡 todo)

**Done when:** the friction log is written, every item has a disposition, coherence check is clean, and a sibling plan id exists for the widening.

---

## 🧪 Exit criteria (🟡 todo)

- `.copilot/context/01.00-article-writing/04-subject-landscape-research.md` exists, is indexed, and duplicates no rule held by another artifact. (🟡 todo)
- `documentation-researcher` takes a landscape branch on an empty folder instead of asking the user for topics. (🟡 todo)
- `documentation-builder` can emit a comparison article directly from a matrix. (🟡 todo)
- `documentation-design` scaffolds a new subject area without manual folder creation. (🟡 todo)
- `03.00-tech/05.04-agentic-development-frameworks/` is live with two validated articles and a populated `roadmap.md`. (🟡 todo)
- Every landscape entry in the published comparison carries a gate verdict, and no entry that failed the gate appears in the matrix. (🟡 todo)
- The friction log exists and each entry has a disposition. (🟡 todo)
- The issue `overview.md` is a summary referencing published content only. (🟡 todo)

---

## 🧩 Open decisions

None. `D1-slice-sequencing`, `D2-section-location`, `D3-scope-breadth`, and `D4-artifact-strategy` were all closed with the requester before this body was authored; the taxonomy band naming was resolved from `08-observation-to-integration-workflow.md`.

---

## 🔦 Discovery

Items undecidable until execution. Each carries its negative branch.

| Id | Question | Resolves during | Negative branch |
|---|---|---|---|
| **DS-1-gate-failures** | Which enumerated entries lack a primary source strong enough to pass the source-soundness gate | WS-C step 4 | List the entry in the landscape table with a `not-assessed` marker and exclude it from the comparison matrix — never infer its cells |
| **DS-2-source-drift** | Whether Spec Kit, HVE Core, or Squad ship a materially changed version between the WS-C research pass and WS-D writing | WS-D steps 1 and 3 | Re-fetch that entry's primary source before writing the section citing it; if the change invalidates a matrix cell, re-run that row |
| **DS-3-sidebar-order** | Whether `order` in the new `metadata.yml` collides with `05.03-ai-frameworks` in the runtime sidebar | WS-C step 2 | Assign the next free `order` value and record the collision cause in the WS-E friction log |
| **DS-4-dimension-fit** | Whether all ten catalog dimensions apply to this landscape | WS-C step 5 | Record the non-applicable dimension with an explicit reason in the matrix preamble; do not silently drop a column |
| **DS-5-loop-engineering-overlap** | How much of the overview's conceptual framing the existing loop-engineering article already carries | WS-D step 2 | Cross-link and reference; if overlap exceeds a section's worth, cut that section from the overview rather than restating it |

---

## 🅿️ Park lot

Out of scope for this plan. Not to be executed here.

| Id | Item | Disposition |
|---|---|---|
| **PL-1-multi-agent-runtimes** | Coverage of Agent Framework, AutoGen, CrewAI, LangGraph, Claude Code subagents | → defer — excluded by D3; candidate content for `05.03-ai-frameworks` |
| **PL-2-session-tutor-mode** | Wiring a `microsoft-study-mode`-style guided-learning surface to LearnHub content | → defer |
| **PL-3-ai-frameworks-disposition** | Whether the empty `03.00-tech/05.03-ai-frameworks/` gets filled, merged, or renamed | → defer |
| **PL-4-research-domain-triad** | A dedicated `02.00-subject-research/` agent triad | → closed: superseded by D4 and by Analysis C |
| **PL-5-loop-engineering-promotion** | Promoting `01.00-news/20260710.01-loop-engineering/` content into the new section | → defer — cross-link first (WS-D step 2), reassess after |
| **PL-6-framework-adoption** | Adopting Spec Kit, HVE Core, or Squad into this repository's own workflow | → defer — a decision the published comparison should inform, not precede |
| **PL-7-comparison-refresh-loop** | Automatic staleness detection and refresh of the published comparison matrix | → defer — natural successor once the manual path is proven |

---

## 📚 References

**[Spec Kit](https://github.com/github/spec-kit)** 📘 [Official]  
GitHub's spec-driven development toolkit. Primary source for the `constitution → specify → clarify → plan → tasks → analyze → implement` workflow and the overrides/presets/extensions/bundles customization stack.

**[HVE Core](https://github.com/microsoft/hve-core)** 📘 [Official]  
Microsoft's Hypervelocity Engineering component library for Copilot. Primary source for the RPI (Research, Plan, Implement, Review) methodology and its agents/prompts/instructions/skills packaging.

**[Squad](https://github.com/bradygaster/squad)** 📗 [Verified Community]  
Multi-agent runtime for Copilot by Brady Gaster. Primary source for the `.squad/` durable team-state model, coordinator fan-out, and Ralph watch mode.

**[Squad documentation](https://bradygaster.github.io/squad/)** 📗 [Verified Community]  
Companion docs site covering team casting, routing, and interface choices in more depth than the repository README.

**[Building agent teams with Agent Framework, GitHub Copilot CLI and Squad](https://devblogs.microsoft.com/agent-framework/building-agent-teams-with-agent-framework-github-copilot-cli-and-squad/)** 📗 [Verified Community]  
Microsoft DevBlogs post on the Agent Framework ↔ Squad integration. Useful for positioning Squad against general-purpose orchestration SDKs.

**[Introducing Loop Engineering](https://valentinaalto.medium.com/introducing-loop-engineering-ac7a6098bb10)** 📒 [Community]  
Valentina Alto's framing of loop engineering as successor to prompt and context engineering. Already the anchor source of the existing loop-engineering article.

**Repository — `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`**  
Authoritative observation-to-integration contract. Source of the taxonomy band template, the source-provenance callout requirement, and the one-way information-flow rule.

**Repository — `.copilot/context/90.00-learning-hub/09-source-soundness-gate.md`**  
Six-dimension source verification rubric. Delegated to wholesale by WS-A step 6.

**Repository — `.github/agents/01.00-article-writing/`**  
The documentation agent triad extended by WS-B: `documentation-researcher`, `documentation-builder`, `documentation-validator`.

**Repository — `01.00-news/20260710.01-loop-engineering/overview.md`**  
Existing loop-engineering coverage. Cross-link target for WS-D step 2 and the overlap subject of DS-5.
