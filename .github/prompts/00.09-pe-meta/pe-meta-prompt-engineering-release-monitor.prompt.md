---
name: meta-prompt-engineering-release-monitor
description: "Track VS Code and GitHub Copilot releases — fetch latest release notes, diff against last processed version, run targeted fullcheck on affected PE artifact types, and update the review log."
agent: agent
model: claude-opus-4.6
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - fetch_webpage
  - replace_string_in_file
handoffs:
  - label: "Research PE Impact"
    agent: pe-meta-researcher
    send: true
  - label: "Design Changes"
    agent: pe-meta-designer
    send: true
  - label: "Validate Ecosystem"
    agent: pe-meta-validator
    send: true
  - label: "Apply Optimizations"
    agent: pe-meta-optimizer
    send: true
agents: ['*']
argument-hint: 'Optional: URL to specific release notes. Default: auto-fetch latest VS Code and Copilot release notes. Flags: --plan (preview only, don'"'"'t apply changes)'
goal: "Track VS Code and Copilot releases and run targeted PE impact analysis"
version: "1.0.0"
scope:
  covers:
    - "VS Code and GitHub Copilot release note fetching and diffing"
    - "Targeted fullcheck scoped to affected PE artifact types"
    - "Review log version tracking updates"
  excludes:
    - "Scheduled staleness detection (pe-meta-prompt-engineering-scheduled-review handles this)"
    - "Full system audits (pe-meta-prompt-engineering-update handles this)"
boundaries:
  - "MUST diff against last processed version from review log"
  - "MUST scope fullcheck to only affected artifact types"
  - "MUST update review log with processed version after completion"
rationales:
  - "Event-driven monitoring catches platform changes that time-based reviews miss"
  - "Targeted fullcheck scope prevents re-auditing unaffected artifacts"
---

# VS Code / Copilot Release Monitor

Fetches the latest VS Code and GitHub Copilot release notes, diffs them against the last processed version recorded in the review log, and runs a targeted fullcheck only on PE artifact types affected by new features.

**When to run**: After a new VS Code or GitHub Copilot release. Complement to `/meta-prompt-engineering-scheduled-review` (staleness-based) — this prompt is event-driven (release-based).

## Handoff Data Contracts

| Transition | Strategy | Include | Exclude | Max tokens |
|---|---|---|---|---|
| **Orchestrator → meta-researcher** (Phase 3) | send: true | Release diff summary, affected artifact types, scope | Full release notes text | ≤1,500 |
| **Orchestrator → meta-prompt-engineering-update** (Phase 4) | Delegated fullcheck | Mode, source (extracted changes), scope (affected types), --plan flag | Raw release notes, version comparison | ≤1,000 |
| **Orchestrator → builders** (Phase 6) | Approved changes | Per-file change specification | Rejected proposals, impact analysis | ≤500/file |

## Summarization Protocol

| After Phase | Summarize to | Max tokens | Discard |
|---|---|---|---|
| Phase 1 (Load versions) | Last processed versions table | ≤200 | Raw log file content |
| Phase 2 (Fetch releases) | Release diff: new features affecting PE | ≤1,000 | Full release notes text |
| Phase 3 (Impact analysis) | Impact matrix: artifact type → affected files | ≤500 | Classification analysis |
| Phase 4 (Targeted fullcheck) | Change proposals per artifact type | ≤1,000 | Fullcheck analysis details |
| Phase 5 (Approval) | Approved change list | ≤500 | Rejected items, discussion |

**Trigger**: Before EVERY handoff, estimate accumulated context. If >8,000 tokens: MUST summarize all prior phases to their "Summarize to" format before proceeding.

**📖 Full strategies:** `.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md`

## Phase 1: Load last processed versions

Read `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md` and extract the "Last Processed Versions" table.

Record the current state:
- VS Code release notes: last processed version
- GitHub Copilot changelog: last processed version
- VS Code Insiders preview: last processed version

## Phase 2: Fetch latest release notes

Fetch the latest release notes from these standard sources (skip any that fail with a warning):

| Source | URL |
|---|---|
| VS Code release notes | `https://code.visualstudio.com/updates` |
| GitHub Copilot changelog | `https://code.visualstudio.com/docs/copilot/copilot-customization` |

**Additionally**, load the "Authoritative Sources (curated)" table from `05.04-meta-review-log.md` and fetch any curated sources not already covered by the standard sources above. This supplements standard monitoring with community-maintained high-trust sources (vendor guides, specs, expert resources).

If the user provided a specific URL as input, fetch that URL instead and skip automatic fetching.

**Extract from each source**:
- Version number or date identifier
- Changes relevant to Copilot customization (prompts, agents, instructions, skills, hooks, MCP, tools, context)

**Compare** each version against the last processed version from Phase 1. If the version matches → report "Already processed" and skip that source.

**Output to user**: Summary of new changes found (or "No new releases since last check").

```markdown
### Release diff

| Source | Last processed | Current | New changes |
|---|---|---|---|
| VS Code | [old version] | [new version] | [count] relevant changes |
| Copilot | [old version] | [new version] | [count] relevant changes |

**New features affecting PE artifacts:**
- [feature 1]: affects [artifact types]
- [feature 2]: affects [artifact types]
```

If no new releases → update the review log with "no changes found" entry and stop.

## Phase 3: Impact analysis

For each new feature or change identified in Phase 2:

1. **Classify the change type**: new capability, modified behavior, deprecated feature, or documentation-only
2. **Map to affected PE artifact types** using the governance baseline (`00.01-governance-and-capability-baseline.md`) and the `dependency-tracking` file (see STRUCTURE-README.md → Functional Categories in `.copilot/context/00.00-prompt-engineering/`)
3. **Determine affected scope**: `context`, `instructions`, `agents`, `prompts`, `skills`, `hooks`, `templates`, or `snippets`

**Output**: Impact matrix showing which artifact types need updating and why.

## Phase 4: Targeted fullcheck

For each affected artifact type identified in Phase 3, delegate to the `meta-prompt-engineering-update` workflow:

- **Mode**: `fullcheck`
- **Source**: The extracted release notes content (not the URL — pass the relevant changes as a description)
- **Scope**: Only the affected artifact types
- **Flag**: Inherit `--plan` if the user specified it

If `--plan` is set → produce the change plan without applying and stop after this phase.

**Sequence**: Process one artifact type at a time so findings from earlier types can inform later ones.

## Phase 5: User approval

Present the consolidated change plan from all targeted fullchecks:

```markdown
### Proposed changes from release [version]

| # | Artifact type | File | Change | Reason |
|---|---|---|---|---|
| 1 | [type] | [file] | [change description] | [release feature] |

Apply all changes? (yes/no/select)
```

**Wait for user approval before proceeding.**

## Phase 6: Apply changes

Apply approved changes via the appropriate builder agents. Validate after each change — max 3 files between validation checkpoints.

## Phase 7: Update review log

**Always runs**, even if no changes were needed.

Update `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md`:

1. Update the "Last Processed Versions" table with the new version numbers and today's date
2. Append a new entry under "Fullcheck runs" with:
   - Source: "VS Code [version] / Copilot [version] release notes"
   - Dimensions: artifact types that were checked
   - Findings and changes applied
3. Update the `last_updated` date in the YAML frontmatter to today

## CRITICAL BOUNDARIES

### Always Do
- Check the review log for last processed versions BEFORE fetching
- Present impact analysis and change proposals before applying
- Update the review log after every run (even if no new releases found)
- Map changes to specific PE artifact types — don't run system-wide fullcheck

### Ask First
- Applying changes to files with 6+ dependents
- Processing releases from unofficial or preview sources
- Changing governance baseline capabilities

### Never Do
- **NEVER apply changes without user approval**
- **NEVER skip the version diff** (re-processing releases wastes tokens and risks duplicate changes)
- **NEVER remove capabilities** — only extend, refine, or deprecate
- **NEVER modify top YAML frontmatter** in article files

---

## 🔄 Error Recovery Workflows

**📖 Recovery pattern:** [04.03-production-readiness-patterns.md](.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md)

Release-monitor-specific recovery:
- **fetch_webpage fails for release notes** → Warn user, ask for manual release notes paste
- **Version parsing fails** → Ask user to confirm version numbers manually
- **Targeted fullcheck finds no issues** → Log "no changes needed", update version table
- **Impact analysis unclear** → Default to broader scope, inform user

---

## 📋 Response Management

**📖 Response patterns:** [04.03-production-readiness-patterns.md](.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md)

Release-monitor-specific scenarios:
- **No new releases** → "No new releases since [version]. Review log updated."
- **Release changes not PE-relevant** → "New release found but no PE-relevant changes. Versions updated in log."
- **URL unreachable** → "Can't reach [url]. Try providing release notes manually or retry later."

---

## 🧪 Embedded Test Scenarios

| # | Scenario | Expected Behavior |
|---|---|---|
| 1 | New VS Code release (happy path) | Fetches → diffs → impact analysis → targeted fullcheck → apply → log |
| 2 | No new releases | Reports "already processed" → updates log timestamp → stops |
| 3 | --plan flag | Generates change plan without applying → plan-only report |
