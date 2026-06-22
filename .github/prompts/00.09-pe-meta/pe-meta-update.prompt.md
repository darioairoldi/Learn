---
name: pe-meta-update
description: "DEPRECATED — merged into /pe-meta-review at v3.0.0. The full nine-phase canonical engine now lives in pe-meta-review.prompt.md. This stub redirects callers; it performs no work."
agent: agent
model: claude-opus-4.6
tools:
  - read_file
argument-hint: '[--mode plan|apply] [--scope ...] [--source ...] [--dim ...] [--start ...] [--end ...] [--deps ...] [--skip ...] [--plan-file <path>] [bundle=accept]'
goal: "Redirect deprecated /pe-meta-update invocations to the unified /pe-meta-review command without performing any artifact work"
scope:
  covers:
    - "Deprecation redirect only — echo the canonical replacement and stop"
  excludes:
    - "All PE artifact review/optimization work (now owned by /pe-meta-review)"
boundaries:
  - "MUST NOT perform any audit, research, or mutation; this command is a redirect stub"
  - "MUST echo the equivalent /pe-meta-review invocation (same arguments, verbatim) and instruct the caller to re-run it"
  - "MUST NOT be cited by other artifacts as an active capability — references are historical only"
rationales:
  - "Keeping the command name resolvable (rather than 404) preserves muscle memory and any stale references while steering callers to the unified command"
---

# pe-meta-update — DEPRECATED (use `/pe-meta-review`)

> **This command was merged into `/pe-meta-review` at v3.0.0** (issue 20260622.01). The full nine-phase canonical engine — Phase 0a conversational pre-parser, Phase 0b domain-coherence gate, Phases 1–4 audits, Phase 4.5 strategic validation, Phases 5–7 risk-classified execution, Phase 8 report — now lives in [pe-meta-review.prompt.md](pe-meta-review.prompt.md). Its change history continues in [pe-meta-review.prompt.changelog.md](pe-meta-review.prompt.changelog.md).

## What to do

`/pe-meta-update` and `/pe-meta-review` are now the **same command**. Re-run your invocation against `/pe-meta-review` with the identical arguments — the canonical eight-parameter surface (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`, `--plan-file`) and the `bundle=accept` consent token are unchanged.

| You typed | Run instead |
|---|---|
| `/pe-meta-update <args>` | `/pe-meta-review <args>` (arguments unchanged) |
| `/pe-meta-update --mode plan ...` | `/pe-meta-review --mode plan ...` |
| `/pe-meta-update --mode apply ...` | `/pe-meta-review --mode apply ...` |

There is no behavioral difference: the defaults (`--mode apply`, `--dim full`, `--deps full`, default-full sweep for parameter-less manual invocations) are identical in `/pe-meta-review`.

## Behavior of this stub

When invoked, echo the equivalent `/pe-meta-review` invocation (same arguments, verbatim) and stop. Perform no research, audit, or mutation.

<!--
prompt_metadata:
  filename: "pe-meta-update.prompt.md"
  version: "3.0.0"
  last_updated: "2026-06-22"
  changelog: "pe-meta-review.prompt.changelog.md"
-->
