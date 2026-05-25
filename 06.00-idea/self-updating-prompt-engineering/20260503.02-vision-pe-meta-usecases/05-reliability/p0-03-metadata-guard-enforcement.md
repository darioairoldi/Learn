# UC-25: Metadata-guard enforcement

> **Group:** 05-reliability
> **Priority:** P0
> **Order in group:** 3
> **Vision anchors:** R5 — Boundary "MUST trigger post-change metadata reconciliation"; R6 — Boundary "Self-update infrastructure staleness is CRITICAL severity, never cached, never skipped"

## 🎯 Purpose

Verify the **closed feedback loop** the vision relies on: every artifact change is preceded by a pre-change guard (block-by-default on metadata contradictions) and followed by post-change metadata reconciliation. Additionally verify the **fail-closed boundary** on self-update infrastructure staleness — it MUST actually block, not be silently bypassed.

## ⚙️ Invocation

**Command family:** Review / Scheduled
**Primary entry point:** `/pe-meta-review <path> --dim reliability --deps full`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation; audits the outcome-log window)
- `/pe-meta-update --mode plan --skip research --dim reliability --scope context` (foundation-layer focus)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages metadata-guard audit (D30) |
| `--scope <type\|path>` | Narrow to a foundation tier (e.g., `context`) or a specific artifact |
| `--deps full` | Recommended — guard verification follows the dependency chain |
| `--mode plan` | Default — this UC reports; remediation is delegated to specific update flows |
| `--skip cache` | Force fresh check on infra-staleness boundary (the boundary requires no-cache anyway) |

## 🔬 Behavior

### Audit 1: Pre/post-change protocol presence

For every `autonomy_level: autonomous | notify` entry in the outcome log within the window:

1. Look for `pre_change_guard` field with a non-null verdict and rationale.
2. Look for `post_change_reconciliation` field with a non-null reconciliation summary.
3. If either is missing → **CRITICAL** finding: closed-loop broken.

### Audit 2: Guard accuracy

For each guard verdict in the window, re-run the pre-change check against the recorded before-snapshot:

1. If the re-run verdict differs from the recorded verdict → **HIGH** finding: guard implementation drifted.
2. If the recorded verdict is `pass` but the re-run finds a metadata contradiction → **CRITICAL** finding: guard false negative.

### Audit 3: Infrastructure-staleness fail-closed boundary

1. Mark a pe-meta infrastructure component (vision, dimension catalog, applicability matrix) as `staleness: stale` in a test fixture.
2. Attempt to run any `--dim` command against an in-scope artifact.
3. Expected: deterministic refusal with the CRITICAL-severity message.
4. If the command proceeds → **CRITICAL** finding: fail-closed boundary breached. This is a release-blocker.

## 📐 Dimensions covered

D30 (metadata-guard-enforcement) — primary.
D29 (regression-protection-coverage) — secondary (the snapshot pair lives in metadata-guard entries).

## 🚦 Reliability analysis

The metadata-guard protocol IS the closed loop that makes the system self-correcting. If it can be bypassed — silently or by configuration — the entire autonomy gradient collapses to "trust the LLM." This UC is the most important reliability check in the catalog.

The infrastructure-staleness audit is intentionally adversarial: it injects a known-stale state and verifies the system refuses to proceed. Passing this audit is a release gate for any change to the pe-meta engine.

## 💰 Cost & efficiency

Audit 1 is near-zero cost (log scan). Audit 2 is medium (re-runs guards). Audit 3 is small but disruptive (requires a test fixture; should run in a sandboxed branch or feature flag).

## 🔗 Related use cases

- [p0-02-regression-protection](p0-02-regression-protection.md) — relies on the metadata-guard entries this UC validates
- [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam.md) — verifies the runtime *expression* of boundaries; this UC verifies the *change-time gates*
- [03-consumer-correctness/p0-01-dependency-aware-full-review](../03-consumer-correctness/p0-01-dependency-aware-full-review.md) — adherence audit assumes guards are working
