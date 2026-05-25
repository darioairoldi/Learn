# Issue: Review prompts "MUST stay read-only" contradicts the vision parity contract

> **Status:** Analysis complete — fix plan ready  
> **Severity:** HIGH — systemic inconsistency across all review prompts  
> **Date:** 2026-05-24

---

## The contradiction

The vision (v13) defines a **Design and review parity contract**:

> Design and review share one destination: the same quality objective and the same scope intent, filtered only by artifact applicability.
>
> 1. **Design** performs requirements synthesis and construction to reach the quality target.
> 2. **Review** performs analysis, verification, and **improvement** to keep artifacts at that same target.

The word "improvement" explicitly requires mutation capability. Yet every review prompt implements:

```yaml
boundaries:
  - "MUST stay read-only"
```

This makes it impossible for review to fulfill its stated role of "improvement."

---

## Evidence of the contradiction (vision vs implementation)

### Vision option applicability matrix (v13 § Command families)

| Option | Creation | Review | Guidance-first | Scheduled | Update | Release-diff |
|---|---|---|---|---|---|---|
| `--mode` | ❌ | **✅** | ✅ | ❌ | ❌ | ❌ |

> Default: `plan` for Review/Guidance-first; `apply` for Update/Release-diff

### Implementation option applicability matrix (`pe-meta-option-applicability-matrix.md`)

| Option | Review | Design | Create-update | Scheduled-review | Update | Release-monitor |
|---|---|---|---|---|---|---|
| `--mode` | **❌** | ❌ | ❌ | ❌ | ✅ | ✅ |

**The implementation contradicts its own vision.** The vision says Review supports `--mode plan|apply` (defaulting to `plan`). The implementation locks Review to read-only with no mode option.

### Vision command families table (internal inconsistency)

| Family | Mutation posture |
|---|---|
| Review | Read-only |

This label in the command families table contradicts the option matrix in the same document. The table says "Read-only" but the matrix says `--mode ✅` (meaning write is available via `--mode apply`).

### Use case UC-12 already lists `--mode plan`

```markdown
| `--mode plan` | Assessment only (default for review) |
```

This confirms the vision intends review to support `--mode` — the use case even documents it as a supported option.

---

## Affected artifacts (9 review prompts + 1 matrix)

All share the identical pattern: `agent: plan`, read-only tools only, "MUST stay read-only" boundary.

| # | File | Boundary text |
|---|---|---|
| 1 | `pe-meta-agent-review.prompt.md` | "MUST stay read-only" |
| 2 | `pe-meta-context-review.prompt.md` | "MUST stay read-only" |
| 3 | `pe-meta-prompt-review.prompt.md` | "MUST stay read-only" |
| 4 | `pe-meta-instruction-review.prompt.md` | "MUST stay read-only" |
| 5 | `pe-meta-skill-review.prompt.md` | "MUST stay read-only" |
| 6 | `pe-meta-hook-review.prompt.md` | "MUST stay read-only" |
| 7 | `pe-meta-template-review.prompt.md` | "MUST stay read-only" |
| 8 | `pe-meta-snippet-review.prompt.md` | "MUST stay read-only" |
| 9 | `pe-meta-review.prompt.md` (generic) | "MUST stay read-only — plan mode" |
| 10 | `pe-meta-option-applicability-matrix.md` | `--mode` ❌ for Review |

---

## Root cause analysis

The implementation was built from the command families table's "Read-only" mutation posture label. It hardcoded that constraint into every review prompt, ignoring:

1. The vision's option applicability matrix (which says `--mode ✅` for Review)
2. The parity contract (which says review performs "improvement")
3. The use cases (which list `--mode plan` as a supported option)
4. The vision's `--mode` definition: `plan` = findings only, `apply` = findings + changes

**The three-command split per type was over-separated:**

| Command | Current role | Problem |
|---|---|---|
| `{type}-design` | Create new (agent mode, write tools) | Fine |
| `{type}-review` | Assess existing (plan mode, read-only) | **Can only diagnose, cannot improve** |
| `{type}-create-update` | Modify existing (agent mode, write tools) | Requires separate invocation after review |

The user's natural workflow — investigate → reason → validate → plan → apply — is broken across two commands. The parity contract says this should be one continuous workflow with an approval gate (not a command boundary).

---

## Fix plan

### 1. Vision (v13) — resolve internal inconsistency

**File:** `06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md`

**Change:** Update the command families table to clarify Review's mutation posture:

| Before | After |
|---|---|
| `Review \| Read-only` | `Review \| Assessment-first (write via --mode apply)` |

**Rationale:** The option matrix already says `--mode ✅`. The table label should match. "Assessment-first" preserves the default read-only behavior while acknowledging that write is available when explicitly requested.

### 2. Use cases — confirm `--mode apply` in review use cases

**Files:** `03-consumer-correctness/p0-01-dependency-aware-full-review.md` and any other review use cases that reference `--mode`

**Change:** Add explicit `--mode apply` row to the supported options table:

```markdown
| `--mode apply` | Assessment + apply improvements (requires confirmation) |
```

**Rationale:** Make it explicit that review can culminate in applied changes, not just reports.

### 3. Implementation — add `--mode plan|apply` to all review prompts

**Scope:** All 9 review prompt files + option applicability matrix

#### 3a. Option applicability matrix

**File:** `pe-meta-option-applicability-matrix.md`

**Change:** `--mode` for Review: ❌ → ✅

#### 3b. All 9 review prompts — structural changes

For each review prompt:

1. **YAML frontmatter** — conditional on `--mode`:
   - Default (`--mode plan`): keep `agent: plan`, read-only tools
   - With `--mode apply`: switch to `agent: agent`, add write tools + builder handoff

   Since YAML can't be conditional, the solution is:
   - Change `agent:` to `agent` (agent mode — supports both)
   - Include write tools in the tool list
   - Add builder handoff
   - The prompt body enforces `--mode plan` as default behavior (assess only, present plan, stop)

2. **Boundaries** — replace:
   ```yaml
   - "MUST stay read-only"
   ```
   With:
   ```yaml
   - "MUST default to assessment-only (--mode plan); supports --mode apply with confirmation gate"
   - "MUST present change plan and require confirmation before applying (--mode apply)"
   ```

3. **Phase ordering section** — replace:
   ```
   2. Review is always read-only — `--mode` is not supported (review never applies changes).
   ```
   With:
   ```
   2. Default mode is `plan` (assessment + findings report). With `--mode apply`, review proceeds to implement improvements after presenting a change plan and receiving confirmation.
   ```

4. **Process section** — add final steps:
   ```
   N. Present severity-ranked findings with proposed changes
   N+1. If `--mode apply` AND user confirms: apply changes via `@pe-meta-builder`
   ```

5. **Handoffs** — add builder handoff:
   ```yaml
   - {label: "Apply Changes", agent: pe-meta-builder, send: true}
   ```

6. **Tools** — add write tools:
   ```yaml
   tools: [semantic_search, read_file, file_search, grep_search, list_dir, replace_string_in_file, multi_replace_string_in_file, create_file]
   ```

#### 3c. Eliminate redundant `{type}-create-update` prompts (optional, Phase 2)

Once review prompts support `--mode apply`, the `create-update` prompts become largely redundant for the "update" case. They remain useful only for the "create from scratch" scenario — which is already covered by `{type}-design`.

**Recommendation:** After fixing review prompts, evaluate whether `create-update` should be:
- Merged into `design` (create path) + `review` (update path)
- Or kept for backward compatibility with a deprecation note

---

## Implementation priority

| Phase | What | Risk | Effort |
|---|---|---|---|
| **Phase 1** | Fix option applicability matrix + vision table | Low | Small |
| **Phase 2** | Update all 9 review prompts with `--mode` support | Medium | Medium |
| **Phase 3** | Update use cases to document `--mode apply` | Low | Small |
| **Phase 4** | Evaluate `create-update` redundancy | Medium | Future |

---

## Design principle preserved

The fix preserves safety through defaults:
- **No `--mode` specified** → behaves exactly as today (read-only assessment)
- **`--mode plan`** → explicit read-only (same as today)
- **`--mode apply`** → review + implement, with confirmation gate before mutation

This matches the vision's "maximum autonomy that assessed risk allows" — the user opts in to write behavior explicitly, and a confirmation gate provides the safety check.
