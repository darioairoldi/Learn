---
name: pe-meta-adherence
description: "Generate a guidance-first adherence matrix — for a given guidance file, check which consumers implement which rules"
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
argument-hint: '<guidance-file-path> [--mode plan|apply] — e.g., ".copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md"'
version: "1.3.0"
last_updated: "2026-05-22"
goal: "Produce an adherence matrix showing which consumers implement which rules from the target guidance file, with gap severity and recommendations"
scope:
  covers:
    - "Guidance-first review mode implementation"
    - "Consumer discovery for target guidance file"
    - "Rule extraction from guidance"
    - "Adherence verification per consumer per rule"
    - "Adherence matrix with gap severity classification"
  excludes:
    - "Individual artifact review (use /pe-meta-{type}-review)"
    - "Domain artifacts (use /pe-con-review)"
boundaries:
  - "Default mode: apply — implements non-breaking improvements autonomously; proposes breaking changes for human confirmation. Use `--mode plan` to opt into assess-only output (findings report without changes)"
  - "Risk classification determines execution, not command identity — low-risk findings are applied without gating"
  - "Write tools (`replace_string_in_file`, `create_file`) are active by default (`--mode apply`). Suppressed ONLY when `--mode plan` is explicitly specified OR when the finding is classified as breaking"
  - "MUST verify target is PE guidance before proceeding"
  - "MUST discover ALL consumers, not just obvious ones"
  - "MUST classify gaps by severity"
  - "MUST produce machine-readable adherence matrix"
  - "MUST enforce option applicability from pe-meta-option-applicability-matrix.md"
  - "MUST be the canonical command for guidance-first behavior"
handoffs:
  - {label: "Apply complex improvements", agent: pe-con-builder, send: true}
rationales:
  - "Guidance-first review catches rules that no consumer implements (dead guidance)"
  - "Adherence matrices enable systematic gap tracking across the PE system"
  - "Severity classification prioritizes remediation effort"
  - "This prompt is the canonical owner of guidance-first adherence capability"
---

# Guidance-First Adherence Matrix

For a given guidance file, extract all rules, discover all consumers, and check adherence per consumer per rule. Produces a gap-severity matrix.

## Option applicability contract

Load `.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md` before parsing options.

1. This command accepts only a guidance target path as primary input.
2. If unsupported options are provided, reject using deterministic corrective guidance from the matrix.
3. Guidance-first requests MUST resolve to this prompt's behavior.

**When to use**: When you want to verify that a guidance file's rules are actually implemented by its consumers. Complements individual artifact review (which checks one consumer against all guidance) with the inverse perspective (one guidance against all consumers).

## Process

### Phase 1: Read and Extract Rules

1. **Read target guidance file** completely
2. **Extract rules** — identify all prescriptive statements:
   - `**Rule**:` blocks (N-1 labeled)
   - `MUST` / `NEVER` / `ALWAYS` statements
   - Table rows with requirement columns
   - Boundary items (Always Do / Never Do)
3. **Number rules** sequentially (R1, R2, R3, ...)
4. **Report**: "[N] rules extracted from [file]"

### Phase 2: Discover Consumers

Find all artifacts that reference or should reference this guidance file:

1. **Direct references** — grep for file name, category name, or `📖` references
2. **Category consumers** — check STRUCTURE-README for which artifacts list this file's category in `context_dependencies`
3. **Implicit consumers** — artifacts whose scope overlaps with the guidance topic (discovered via `semantic_search`)

**Report**: "[N] consumers discovered: [list with discovery method]"

### Phase 3: Verify Adherence

For each consumer × each rule:

| Status | Meaning |
|---|---|
| ✅ FULL | Rule fully implemented |
| ⚠️ PARTIAL | Rule partially implemented or paraphrased with lost nuance |
| ❌ MISSING | Rule not implemented |
| ➖ N/A | Rule not applicable to this consumer type |

### Phase 4: Generate Adherence Matrix

**📖 Output format**: `.github/templates/00.00-prompt-engineering/output-adherence-matrix.template.md`

```markdown
## Adherence Matrix: [guidance file]

| Rule | Description | Consumer 1 | Consumer 2 | ... | Coverage |
|---|---|---|---|---|---|
| R1 | [brief] | ✅ | ❌ | ... | X/Y |
| R2 | [brief] | ⚠️ | ✅ | ... | X/Y |
```

### Phase 5: Gap Analysis

Classify gaps by severity:

| Severity | Criteria |
|---|---|
| **CRITICAL** | Core rule (top 5 priority) missing from 50%+ consumers |
| **HIGH** | Any rule missing from a Tier 1 consumer (6+ dependents) |
| **MEDIUM** | Rule partially implemented or missing from 1-2 consumers |
| **LOW** | Minor nuance lost in paraphrase |

**Report**: Severity-ranked gap list with recommended remediation (which consumer needs what change).

## Response Management

- **Not a guidance file** → "This file doesn't contain prescriptive rules. Use `/pe-meta-review` for individual artifact review."
- **Zero consumers found** → "No consumers reference this guidance. Either the guidance is orphaned or consumers use it implicitly without declaration."
- **100% adherence** → "Full adherence — all [N] rules implemented across [M] consumers."

## Embedded Test Scenarios

| # | Scenario | Expected |
|---|---|---|
| 1 | Critical rules file with many consumers | Extract rules → discover 10+ consumers → matrix with coverage % → severity-ranked gaps |
| 2 | Orphaned guidance (no consumers) | Discover 0 consumers → report orphaned status |
| 3 | Full adherence | All cells ✅ → report full adherence, no gaps |
| 4 | Non-guidance file | Redirect to /pe-meta-review → STOP |

## Risk Classification

#file:.github/prompt-snippets/pe-meta-risk-classification.md
