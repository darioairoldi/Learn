# UC-33: Mode-vs-risk decoupling check

> **Group:** 05-reliability
> **Priority:** P2
> **Order in group:** 11
> **Vision anchor:** R12 — Goal § Low-risk autonomy rule: "command identity MUST NOT be interpreted as a permission ceiling that overrides risk classification"

## 🎯 Purpose

Verify that **a command's default mode never silently gates a low-risk change**. The vision is explicit: `--mode plan` vs `--mode apply` is a UX convenience for the user, not a permission level. If a low-risk, high-confidence change is found by a Review command running in default mode, it MUST be applied autonomously (or with notification), regardless of which command found it.

## ⚙️ Invocation

**Command family:** Review (audit on the engine itself)
**Primary entry point:** `/pe-meta-review .github/prompts/00.09-pe-meta/ --dim reliability --mode plan`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages mode-vs-risk decoupling audit |
| `--scope path` | Recommended — scope to the prompts and the applicability matrix |
| `--mode plan` | Default — reports defects; fix is a prompt-author edit |

## 🔬 Behavior

### Audit 1: Prompt instruction text

For each pe-meta prompt file, parse the body for language that conflates mode and permission:

- Patterns like "in `plan` mode we never apply autonomous changes" → **HIGH** (contradicts low-risk autonomy rule)
- Patterns like "skip risk classification when mode = plan" → **CRITICAL**
- Patterns like "if mode = apply then proceed without risk check" → **CRITICAL**

### Audit 2: Outcome-log evidence

Walk recent `autonomy_level: human_required` entries. For each entry:

1. If the human approved with no change AND the change classification is low-risk + high-confidence → **MEDIUM** finding (likely false escalation).
2. If the false-escalation pattern correlates with `invoking_command` running in `--mode plan` (i.e., command identity blocked the autonomous path) → **HIGH** finding: mode acted as a permission ceiling.

### Audit 3: Applicability matrix consistency

Verify the option-applicability matrix's `--mode` rules do not couple mode to autonomy in any command family. The applicability matrix's `--mode` column governs availability of the option, not the resulting autonomy.

## 📐 Dimensions covered

D34 (autonomy-calibration) — adjacent
D33 (boundary-actionability) — adjacent (the rule's actionability is what this UC tests)
Reliability group — primary

## 🚦 Reliability analysis

The low-risk autonomy rule is a *vision-level invariant*. If the engine has even one prompt that contradicts it, that prompt silently downgrades the autonomy gradient for any work it touches. The defect class is invisible at single-prompt review; only a cross-prompt audit catches it. This UC is the audit.

## 💰 Cost & efficiency

Audit 1 is grep-grade (near-zero cost). Audit 2 is log-scan + LLM judgment on borderline cases. Audit 3 is YAML parse. Total: low cost.

## 🔗 Related use cases

- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit.md) — false-escalation rate computed there feeds this UC's audit 2
- [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam.md) — both audit how vision invariants survive in artifact text
- [p2-03-portability-boundary-scan](p2-03-portability-boundary-scan.md) — both audit invariants declared in the vision's option model
