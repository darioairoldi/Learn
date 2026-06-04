# PE-meta command semantics and alignment gaps

Date: 2026-05-22
Status: Open
Priority: High

## 🎯 Executive summary

The current PE-meta review experience has a contract mismatch between vision, use cases, and executable prompt definitions. The mismatch affects three user-critical questions:

1. Whether `--dim full` is valid together with `--with-deps`.
2. Whether dependency-aware review validates dependencies individually and recursively.
3. Whether one command invocation can review multiple target prompts.

Today, the documented behavior is partially contradictory across files. This issue proposes a single canonical contract and concrete implementation steps.

Decision added in this issue:

- `--with-deps` means full dependency-aware review.
- `--with-deps-shallow` means first-level dependency review only (individual checks on direct dependencies).

## 🔍 Findings (severity ordered)

### 1. High: `--dim full` was not consistently defined for type-specific review commands

Evidence:

- [pe-meta-prompt-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-prompt-review.prompt.md) accepts `--dim <group|D#>` but does not define `full` as a group.
- [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) defines explicit groups (`structural`, `quality`, `strategic`, `efficiency`, `context-full`, `context-health`) and D-codes, but not a generic `full` token.
- [pe-meta-scheduled-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md) mentions monthly `--dim full`, creating ambiguity.

Impact:

- User intent is unclear at invocation time.
- Implementations can silently diverge.

Implementation status (2026-05-22):

- `--dim full` is now explicitly accepted as an alias for all applicable dimensions in PE-meta review command grammar.
- Review prompt argument hints were normalized to `--dim <group|D#|full>`.
- The review orchestrator now defines an explicit invalid-combinations matrix with deterministic corrective error messages.
- Core review command parameters are now explicitly separated from orchestration-command controls.

### 2. High: dependency-aware direction and depth are inconsistent

Evidence:

- [p0-01-dependency-aware-full-review.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md) defines target + dependencies individually, recursive to depth 2, plus cross-dependency checks.
- [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) describes dependency-aware mode as target + immediate dependents.
- Type-specific review prompts use narrow `--with-deps` checks (for example handoff contracts or spot-checks), not a shared recursive dependency protocol.

Impact:

- Different prompts can produce different results for the same `--with-deps` expectation.
- UC-12 behavior is not reliably executable.

Proposed resolution:

- Canonicalize `--with-deps` as full dependency-aware review.
- Introduce `--with-deps-shallow` for cost-bounded first-level checks.

### 3. Medium: multi-target review is implied but not cleanly exposed

Evidence:

- [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) includes a system-level multi-artifact mode.
- The same file’s `argument-hint` is still single-target (`<file-path> ...`), so discoverability is weak.

Impact:

- Users can miss multi-target capability.
- Command ergonomics remain inconsistent.

## ❓ Answers to requested command semantics

1. Is `--dim full` supported with `--with-deps`?
Yes. `--dim full` is now explicitly supported as an alias for all applicable dimensions and can be combined with `--with-deps` or `--with-deps-shallow`.

2. Are all dependencies validated individually?
Expected by UC-12: yes.
Current implementation: partially. Some prompts perform only focused dependency checks.

3. Are dependencies reviewed recursively with `--with-deps`?
Yes by contract under this issue decision: `--with-deps` is full dependency-aware review.
Implementation target: recursive traversal with bounded depth (default depth 2 unless overridden by future contract updates).

4. Can the commander run for more than one prompt?
Yes at orchestrator level in [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md), but argument contract and discoverability should be improved.

## 🧭 Alignment analysis: vision, use cases, implementation

### Vision

The vision in [20260515.02-vision.v12.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md) is clear on review modes and selective dimensions, but command-token canonicalization is under-specified for day-to-day invocation.

### Use cases

Use case quality is good, especially UC-12. The gap is translation from use-case behavior into prompt-level executable contracts.

### Implementation

Implementation is close but fragmented:

- Orchestrator semantics and type-specific semantics are not fully normalized.
- `--with-deps` behavior is specialized per type without a shared mandatory core protocol.
- Multi-target mode exists but isn’t first-class in argument hints.

## ⚙️ Remediation plan

### Canonical semantics decision (approved target)

1. `--with-deps`: full dependency-aware review.
2. `--with-deps-shallow`: direct dependencies only, each reviewed individually, no recursive expansion.
3. Both flags are mutually exclusive in a single invocation.
4. If neither flag is present, run individual mode.

### Phase 1: establish canonical command contract

1. Define canonical `--dim` tokens in one source of truth.
2. Decide `full` policy:
	- Option A: support `full` as alias for all applicable dimensions.
	- Option B: reject `full` and require omission or explicit groups.
3. Define canonical dependency flag behavior:
- `--with-deps`: full dependency chain (bounded recursion),
- `--with-deps-shallow`: first level only (individual checks),
- direction (`dependencies`, `dependents`, or both),
- cross-coherence checks for full mode.
4. Publish command grammar for single and multi-target invocation.

### Phase 2: align orchestrator and type-specific prompts

1. Update [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) to match canonical contract.
2. Update all `pe-meta-*-review.prompt.md` files to consume the same contract.
3. Keep type-specific checks as extensions, not replacements, of base dependency-aware protocol.
4. Enforce mutual exclusivity validation for `--with-deps` and `--with-deps-shallow`.

### Phase 3: enforce deterministically

1. Add deterministic parser tests for:
	- `--dim` accepted/rejected values,
	- `--with-deps` full-mode direction and recursion behavior,
	- `--with-deps-shallow` first-level-only behavior,
	- mutual exclusivity between dependency flags,
	- multi-target input.
2. Add embedded test scenarios in each relevant prompt.
3. Add regression checks in scheduled-review flows.

### Phase 4: improve UX discoverability

1. Update argument hints to show multi-target examples.
2. Add two or three canonical examples for common intents.
3. Ensure help text returns corrective suggestions on invalid flags.

## ✅ Definition of done

1. A single command contract is documented and referenced by all review prompts.
2. `--dim full` behavior is explicit and tested.
3. `--with-deps` behavior is explicit, depth-bounded, and consistently executed as full dependency review.
4. `--with-deps-shallow` behavior is explicit and consistently executed as first-level-only individual review.
5. Multi-target invocation is documented, discoverable, and tested.
6. UC-12 expected behavior maps 1:1 to executable prompt behavior.

## 📚 References

- [20260515.02-vision.v12.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md) — Vision and rationale for review modes and selective dimensions.
- [README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) — Use-case catalog and group map.
- [p0-01-dependency-aware-full-review.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md) — Expected dependency-aware semantics.
- [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) — Current orchestrator behavior.
- [pe-meta-prompt-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-prompt-review.prompt.md) — Current type-specific prompt review behavior.
- [pe-meta-scheduled-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md) — Current mention of `--dim full` in scheduled flow.





