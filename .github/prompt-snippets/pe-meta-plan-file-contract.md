## Plan-mode output contract (when `--mode plan` is active)

Every `--mode plan` invocation MUST emit one actionable Markdown plan file on disk. This is non-skippable; `--skip plan-emission` is REJECTED with CF-05.

### 1. Path resolution (canonical algorithm)

`<run-folder>/<NN>-<kebab-name>.plan.md`

- **`<run-folder>`** — the conversation's current working folder when one obviously applies (e.g. a `src/docs/.../<run>` folder the user is already operating in); otherwise `.copilot/temp/pe-meta-state/plans/YYYYMMDD-HHMMSS/` (created on demand).
- **`<NN>`** — next available two-digit prefix in `<run-folder>` (e.g. `01`, `02`); ensures sortable ordering when multiple plans land in the same folder.
- **`<kebab-name>`** — derived from the resolved invocation, e.g. `pe-meta-update-context-freshness` for `/pe-meta-update --scope context --dim freshness`.

The same algorithm produces the spillover-plan path with `-spillover` appended: `<run-folder>/<NN>-<kebab-name>-spillover.plan.md` (see [pe-meta-iteration-budget.md](pe-meta-iteration-budget.md)).

### 2. Required plan content

The plan MUST conform to `plan-execution.instructions.md`:

- Frontmatter: `status: draft`, `target_vision_version`, `domain`, `created`, `goal`.
- Clear goal statement (1 sentence).
- One goal-table row per validated finding from Phases 1–4 carrying `scope tag`, `principle impact`, `downstream landing` (per `vision-amendment.instructions.md`).
- Items decomposed to actionability-gate-ready granularity (each item maps to one editable artifact + one verifiable change).
- Park lot section for surfaced edge cases that do not block promotion.
- Exit criteria.

### 3. First-line marker

The Phase 8 `Resolved invocation:` first-line log MUST include:

```text
plan-file=<absolute-or-workspace-relative-path>
```

The linter rejects `--mode plan` reports that omit the marker (vision success criterion #12 v15.1 marker extension).

### 4. Why on-disk, not chat-only

A chat-only findings report disappears with the conversation. A plan file landed in the run folder is reviewable later, version-controlled, and promotable to `actionable` through the same gate that governs human-authored plans — closing the human-handoff loop that `human-governance-autonomous-execution` (P1) requires.

### 5. Forward references

- Vision § Plan-mode output contract — authoritative rule.
- Vision § Iteration budget — overflow spillover plan (uses the same path algorithm).
- `plan-execution.instructions.md` — plan file lifecycle and actionability gate.
