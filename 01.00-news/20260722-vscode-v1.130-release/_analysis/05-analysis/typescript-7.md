---
title: "TypeScript 7 — analysis"
publish: false
---

# TypeScript 7

## Quick analysis

TypeScript 7.0 is a native port of TypeScript written in Go, delivering:

- **8–12× build speedups** on real-world codebases
- **Parallel type-checking** via `--checkers` flag (default 4 workers)
- **Parallel project-reference builds** via `--builders` flag
- **Rebuilt `--watch` mode** using a Go port of Parcel's file watcher
- **LSP-native language server** — 80% fewer failing commands, 60% fewer crashes vs TS 6
- **Editor startup**: VS Code codebase went from 17.5s to <1.3s for first error

Key production validation: VS Code itself is now compiled with TypeScript 7 (this release). Companies like Slack, Canva, Vanta, and Microsoft teams (Loop, PowerBI, Teams, Xbox) have adopted it.

**Why it matters for AI workflows:** Faster type-checking means tighter agentic feedback loops. When an AI agent runs `tsc` as a validation step in a tool call, the turnaround drops from seconds to sub-second, reducing total agent task time.

**Caveat:** No API in 7.0 — tools like webpack loaders and embedded language servers (Vue, Svelte, Angular) must still use TypeScript 6 via `@typescript/typescript6`. API expected in 7.1.
