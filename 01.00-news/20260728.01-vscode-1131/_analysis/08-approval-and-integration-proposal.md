---
title: "Approval and integration proposal — VS Code 1.131 (Insiders)"
publish: false
---

# Approval and integration proposal

## Autonomy assessment

| Deliverable | Gap | Change type | Target | Decision |
|---|---|---|---|---|
| Release summary `01-summary.md` | Clear — no article for this release | Additive, new file | News | **Autonomous** |
| Concepts article on built-in voice | Clear — coverage `absent`, confirmed by two search passes | Additive, new file | Tech article | **Autonomous** |
| Roadmap row + count | Mechanical bookkeeping for the new article | Additive | Series index | **Autonomous** |
| `overview.md` rewrite | Required by Step 11 | Rewrite of a raw capture, not a published article | News | **Autonomous** |
| `01.08` Agent Host reframing | Known, carried from 1.130 | Overwrite/restructure of a published article | Tech article | **Gated — not performed** |
| `04-howto/03.00` prompt-migration section | Real gap | Overwrite of a stable how-to on Insiders-only evidence | How-to | **Gated — not performed** |

No meta or architecture amendment is involved. No scope conflict was found. Everything in the autonomous column is additive or a rewrite of a raw capture, so integration proceeds without approval.

## Integration order

1. `01.00-news/20260728.01-vscode-1131/01-summary.md`
2. `03.00-tech/05.02-prompt-engineering/03-concepts/01.10-understanding-voice-input-dictation-and-read-aloud.md`
3. `03.00-tech/05.02-prompt-engineering/ROADMAP.md` — add the `01.10` row, bump the `03-concepts` count from 8 to 9
4. `01.00-news/20260728.01-vscode-1131/overview.md` — Step 11 rewrite

## Constraints applied

- **Reader-facing reframing.** No "Problem statement", "Deductions", or "Conclusions" framing crosses into a published article. That vocabulary stays in `_analysis/`.
- **Reference classification.** Every reference in a published file carries a marker and a 2–4 sentence description.
- **Dual metadata.** Published files get renderer frontmatter only. No bottom validation block is written by hand.
- **Insiders labelling.** Both published articles state that 1.131 is an Insiders release whose contents can still change.
- **No unverifiable claims.** Setting IDs are omitted rather than guessed.
- **Encoding.** UTF-8, so the 📘 markers survive.
- **Navigation.** Untouched — `DynamicNavBuilder` picks up new files at request time.

## Gated items — awaiting a decision

Two items remain open. Neither blocks this run.

1. **Reframe `01.08` around the Agent Host process model.** Open since the 1.130 investigation. Worth doing once the Agent Host ships stable.
2. **Add prompt migration and retirement guidance to `04-howto/03.00`.** Worth doing once **Migrate Prompts** reaches a stable release.

## Post-integration verification

| Check | Method |
|---|---|
| New files render | Confirm frontmatter parses and headings are well formed |
| Relative links resolve | Verify each `../` path against the actual folder names |
| Roadmap count matches reality | Count files in `03-concepts/` after the addition |
| No published article overwritten | Only the four files listed above are modified |
