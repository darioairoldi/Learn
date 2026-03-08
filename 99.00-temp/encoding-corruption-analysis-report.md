# Encoding Corruption Analysis Report

**Date:** 2025-07-24
**Scope:** 8 markdown files with lossy UTF-8 → ASCII `?` (0x3F) corruption
**Location:** `03.00-tech/05.02-prompt-engineering/`
**Purpose:** Research-only analysis for planning fixes

---

## Summary Table

| # | File (relative to `05.02-prompt-engineering/`) | Total `?` | Headings | Em-dash `—` | Arrows `→` | Box/Tree | Status ✅❌⚠️ | Legitimate | Other |
|---|---|---|---|---|---|---|---|---|---|
| 2 | `03-concepts/01.09-understanding_copilot_memory_and_persistent_context.md` | 166 | ~32 | ~40 | ~10 | ~60 | ~6 | ~4 | ~14 (📖 refs) |
| 3 | `04-howto/07.01-appendix_mcp_implementation_examples.md` | 19 | 6 | 2 | 0 | 0 | 0 | 10 | 1 |
| 4 | `04-howto/07.02-appendix_mcp_apps.md` | 20 | 0 | 10 | 4 | 3 | 0 | 1 | 2 |
| 5 | `04-howto/13.01-appendix_token_optimization_patterns.md` | 15 | 4 | 0 | 0 | 0 | 7 | 1 | 3 (×) |
| 6 | `05-analysis/20.01-appendix_orchestration_case_study_details.md` | 57 | 12 | 2 | 3 | 13 | 20 | 4 | 3 |
| 7 | `05-analysis/21.2-appendix_orchestration_plan_specifications.md` | 533 | ~18 | ~8 | ~60 | ~250 | ~120 | ~25 | ~52 |
| 8 | `06-reference/01.10-customization_decision_framework_reference.md` | 320 | ~44 | ~16 | ~50 | ~90 | ~80 | 0 | ~40 (📖, –) |
| 9 | `06-reference/01.11-yaml_frontmatter_reference.md` | 137 | ~40 | ~22 | ~14 | ~5 | ~36 | 0 | ~20 (📖) |
| | **TOTALS** | **1,267** | | | | | | | |

> **Note:** Breakdown counts are estimates based on line-level analysis. The total `?` per file is exact (verified by script).

---

## File 2: `03-concepts/01.09-understanding_copilot_memory_and_persistent_context.md`

**Total `?` count: 166**

### Heading Emoji Map

Based on sibling pattern from `01.02`–`01.08` concept articles (all use: 🎯 intro, 🏗️ architecture, ⚠️ boundaries, 🎯 conclusion, 📚 references):

```powershell
$headingEmojiMap = @{
    # TOC entries (same emojis as corresponding headings)
    '^\- \[\?\? What is Copilot Memory'                                  = '- [🎯 What is Copilot Memory'
    '^\- \[\?\? How Memory fits into the customization stack'            = '- [🏗️ How Memory fits into the customization stack'
    '^\- \[\?\? Shared context surface comparison'                       = '- [📊 Shared context surface comparison'
    '^\- \[\?\? What Copilot remembers'                                  = '- [📋 What Copilot remembers'
    '^\- \[\?\? How Memory impacts prompt assembly'                      = '- [⚙️ How Memory impacts prompt assembly'
    '^\- \[\?\? Boundaries and limitations'                              = '- [⚠️ Boundaries and limitations'
    '^\- \[\?\? Conclusion'                                              = '- [🎯 Conclusion'
    '^\- \[\?\? References'                                              = '- [📚 References'
    # Section headings
    '^## \?\? What is Copilot Memory'                                    = '## 🎯 What is Copilot Memory'
    '^## \?\? How Memory fits into the customization stack'              = '## 🏗️ How Memory fits into the customization stack'
    '^## \?\? Shared context surface comparison'                         = '## 📊 Shared context surface comparison'
    '^## \?\? What Copilot remembers'                                    = '## 📋 What Copilot remembers'
    '^## \?\? How Memory impacts prompt assembly'                        = '## ⚙️ How Memory impacts prompt assembly'
    '^## \?\? Boundaries and limitations'                                = '## ⚠️ Boundaries and limitations'
    '^## \?\? Conclusion'                                                = '## 🎯 Conclusion'
    '^## \?\? References'                                                = '## 📚 References'
}
```

**Confidence:** HIGH for 🎯, 🏗️, ⚠️, 🎯, 📚 (universal pattern). MEDIUM for 📊, 📋, ⚙️ (inferred from sibling article topics).

### Line-by-Line Decode

**YAML / Title:**
| Line | Content | `?` → | Confidence |
|------|---------|-------|------------|
| L11 | `description: "...persistent context ? cross-session..."` | `—` (em dash) | HIGH |
| L13 | `...your preferences ? coding style...` | `—` | HIGH |

**TOC (L17–L24):** Each `??` → heading emoji (see map above)

**Headings (L28, L56, L105, L134, L157, L220, L239, L260):** Each `??` → heading emoji (see map above)

**Prose em-dashes (`?` → `—`):**
| Line | Context | Confidence |
|------|---------|------------|
| L36 | `...remembers your preferences ? your coding style...` | HIGH |
| L38 | `...persistent context ? it survives...` | HIGH |
| L41 | `...automatic ? you don't need...` | HIGH |
| L58 | `...customization stack ? working alongside...` | HIGH |
| L88 | `...instruction files ? for team-shared...` | HIGH |
| L150–L153 | Bullet list items with `?` separators | HIGH |
| L180–L184 | Bullet list items | HIGH |
| L212 | `...context window ? they're always...` | HIGH |
| L216 | `...Memory isn't a replacement ? it's...` | HIGH |
| L224–L235 | Conclusion bullet items | HIGH |
| L241 | `...started learning ? and what it hasn't` | HIGH |
| L245–L250 | Next steps items | HIGH |
| L254–L256 | Reference description separators | HIGH |

**Table arrows (`?` → `→`):**
| Line | Context | Confidence |
|------|---------|------------|
| L47–L50 | `repeat → every session` / `survives → sessions` pattern in comparison table | HIGH |

**Box-drawing diagram: CUSTOMIZATION STACK (L62–L73):**
All `?` on these lines are `│` (U+2502, box-drawing vertical). Pattern:
```
│  Layer 6: Instructions (.instructions.md)  │
│  Layer 5: Prompt/Agent content              │
```
~24 `?` characters (2 per line × ~12 lines)

**Box-drawing diagram: COPILOT MEMORY surfaces (L111–L122):**
- Most `?` → `│` (vertical bar)
- L116: `+---?` → `+---┤` (right junction, U+2524)
- ~20 `?` characters

**Decision tree (L189–L205):**
Tree-drawing characters:
| Character | Maps to | Context |
|-----------|---------|---------|
| `?` at line start | `├` (U+251C) | Branch point |
| `?` between items | `│` (U+2502) | Vertical continuation |
| `?` at last branch | `└` (U+2514) | Bottom branch |

~16 `?` characters

**Reference tags (L262, L265, L268):**
| Line | Content | `?` → | Confidence |
|------|---------|-------|------------|
| L262 | `[?? Official]` | `[📘 Official]` | HIGH (matches repo convention) |
| L265 | `[?? Official]` | `[📘 Official]` | HIGH |
| L268 | `[?? Official]` | `[📘 Official]` | HIGH |

### Special Patterns (File 2)

1. **Box-drawing diagrams** (L62–L73, L111–L122): Need character-by-character reconstruction. The `│` characters are straightforward, but junction characters (`┤`, `┬`, `┼`) need validation against the intended visual layout.
2. **Decision tree** (L189–L205): Mix of `├`, `│`, `└` — requires checking indentation to determine which tree-drawing character is correct at each position.
3. **TOC anchor links**: The anchor `#-section-name` format has the `#-` prefix from the emoji being stripped. After fixing headings, anchors may need regeneration.

### Legitimate `?` (File 2)

None identified — all `?` characters appear to be corruption.

---

## File 3: `04-howto/07.01-appendix_mcp_implementation_examples.md`

**Total `?` count: 19**

### Heading Emoji Map

```powershell
$headingEmojiMap = @{
    '^## \?\? Implementation: TypeScript' = '## 🔧 Implementation: TypeScript'
    '^## \?\? Implementation: C#'         = '## 🔧 Implementation: C#'
    '^## \?\? Implementation: Python'     = '## 🔧 Implementation: Python'
}
```

**Confidence:** MEDIUM. The 🔧 emoji is used in sibling `01.07` for "Model-specific prompting strategies" and in reference article `01.09` for "Language Models Editor and BYOK reference." All three headings use the same emoji (implementation sections). Could also be 💻 (code).

### Line-by-Line Decode

| Line | Content | `?` count | Decode | Confidence |
|------|---------|-----------|--------|------------|
| L6 | `description: "...Python ? project setup, tool definitions..."` | 1 | `—` (em dash) | HIGH |
| L23 | `## ?? Implementation: TypeScript` | 2 | 🔧 (heading emoji + VS) | MEDIUM |
| L93 | `const personName = args?.name as string;` | 1 | **LEGITIMATE** (JS optional chaining `?.`) | HIGH |
| L149 | `## ?? Implementation: C# (.NET)` | 2 | 🔧 (heading emoji + VS) | MEDIUM |
| L204 | `string? message = null)` | 1 | **LEGITIMATE** (C# nullable type `string?`) | HIGH |
| L205 | `=> message ?? $"Goodbye, {name}!..."` | 2 | **LEGITIMATE** (C# null-coalescing `??`) | HIGH |
| L225 | `$"/api/query?q={query}"` | 1 | **LEGITIMATE** (URL query string `?q=`) | HIGH |
| L274 | `request.Params?.Name == "greet"` | 1 | **LEGITIMATE** (C# null-conditional `?.`) | HIGH |
| L276 | `request.Params.Arguments?["name"]?.ToString() ?? "World"` | 3 | **LEGITIMATE** (C# `?.`, `?.`, `??`) | HIGH |
| L282 | `$"Unknown tool: '{request.Params?.Name}'"` | 1 | **LEGITIMATE** (C# null-conditional `?.`) | HIGH |
| L291 | `## ?? Implementation: Python` | 2 | 🔧 (heading emoji + VS) | MEDIUM |
| L307 | `### Basic server structure (FastMCP?recommended)` | 1 | `—` (em dash) | HIGH |

### Special Patterns (File 3)

1. **C# and TypeScript code**: 10 of 19 `?` are **LEGITIMATE** code syntax (`?.`, `??`, `?q=`, `string?`). These MUST NOT be changed.
2. Only 9 `?` are actual corruption (3 headings × 2 + 2 em-dashes + 1 em-dash in subheading).

### Legitimate `?` (File 3)

| Line | Syntax | Language |
|------|--------|----------|
| L93 | `args?.name` | TypeScript optional chaining |
| L204 | `string?` | C# nullable type |
| L205 | `message ??` | C# null-coalescing |
| L225 | `?q=` | URL query parameter |
| L274 | `Params?.Name` | C# null-conditional |
| L276 | `Arguments?[...]?.ToString() ?? "World"` | C# (3 instances) |
| L282 | `Params?.Name` | C# null-conditional |

**Total legitimate: 10** | **Total to fix: 9**

---

## File 4: `04-howto/07.02-appendix_mcp_apps.md`

**Total `?` count: 20**

### Heading Emoji Map

**No heading emojis in this file.** All headings use plain text without emoji prefixes. The `?` characters in headings are em-dashes, not emoji corruption.

### Line-by-Line Decode

| Line | Content | `?` count | Decode | Confidence |
|------|---------|-----------|--------|------------|
| L2 | `title: "Appendix: MCP Apps ? Rich UI in chat (experimental)"` | 1 | `—` | HIGH |
| L6 | `description: "...MCP Apps ? how to return..."` | 1 | `—` | HIGH |
| L9 | `# Appendix: MCP Apps ? Rich UI in Chat (Experimental)` | 1 | `—` | HIGH |
| L17 | `Experimental ? API may change...Settings** ? search "MCP apps" ? toggle on` | 3 | 1st: `—`, 2nd: `→`, 3rd: `→` | HIGH |
| L36 | `?   +-- index.ts` | 1 | `├` (tree branch) | HIGH |
| L37 | `?   +-- mcpapp.html` | 1 | `├` | HIGH |
| L38 | `?   +-- mcpapp.ts` | 1 | `└` (last branch) | HIGH |
| L66 | `...respond back?**bidirectional communication**` | 1 | `—` | HIGH |
| L99 | `document.getElementById("submit")?.addEventListener(...)` | 1 | **LEGITIMATE** (JS optional chaining) | HIGH |
| L106 | `## The promise pattern ? forcing chat to wait` | 1 | `—` | HIGH |
| L108 | `...finishes immediately?it doesn't wait...` | 1 | `—` | HIGH |
| L113 | `...tool handler?the chat blocks` | 1 | `—` | HIGH |
| L121 | `// Tool visible to chat ? shows the form` | 1 | `→` | HIGH |
| L127 | `// Return UI resource ? chat renders the form` | 1 | `→` | HIGH |
| L128 | `// Await the promise ? chat blocks until resolved` | 1 | `→` | HIGH |
| L137 | `// App-only tool ? invisible to chat...` | 1 | `→` | HIGH |
| L169 | `...will appear wherever AI shows up?not just VS Code` | 1 | `—` | HIGH |
| L171 | `...Burke Holland ? MCP Apps` | 1 | `—` | HIGH |

### Special Patterns (File 4)

1. **File tree** (L36–L38): Three `?` are tree-drawing characters (`├`, `├`, `└`). The last entry (L38) should be `└` not `├`.
2. **L17 mixed pattern**: Three `?` on one line with different meanings (em-dash + 2 arrows).
3. **Code comments** (L121, L127, L128, L137): Inside code blocks but NOT code syntax — these are comment text arrows and should be fixed to `→`.

### Legitimate `?` (File 4)

| Line | Syntax | Language |
|------|--------|----------|
| L99 | `getElementById("submit")?.addEventListener` | JavaScript optional chaining |

**Total legitimate: 1** | **Total to fix: 19**

---

## File 5: `04-howto/13.01-appendix_token_optimization_patterns.md`

**Total `?` count: 15**

### Heading Emoji Map

```powershell
$headingEmojiMap = @{
    '^## \?\? Implementation patterns' = '## 🔧 Implementation patterns'
    '^## \?\? Common pitfalls'         = '## ⚠️ Common pitfalls'
}
```

**Confidence:** HIGH for ⚠️ (universal pattern for pitfalls/warnings). MEDIUM for 🔧 (implementation pattern from File 3).

### Line-by-Line Decode

| Line | Content | `?` count | Decode | Confidence |
|------|---------|-----------|--------|------------|
| L15 | `## ?? Implementation patterns` | 2 | 🔧 | MEDIUM |
| L98 | `## ?? Common pitfalls` | 2 | ⚠️ | HIGH |
| L102 | `? **Wrong**: Caching responses...` | 1 | `❌` | HIGH |
| L112 | `? **Right**: Include content hash...` | 1 | `✅` | HIGH |
| L124 | `? **Wrong**: Overly broad cache keys` | 1 | `❌` | HIGH |
| L127 | `cache.store("validate article", result)  # Which article?` | 1 | **LEGITIMATE** (question in comment) | HIGH |
| L130 | `? **Right**: Include all relevant context...` | 1 | `✅` | HIGH |
| L140 | `? **Wrong**: Caching tiny prefixes...` | 1 | `❌` | HIGH |
| L142 | `? **Right**: Only cache prefixes...` | 1 | `✅` | HIGH |
| L146 | `- Cache write: 1.25? base cost` | 1 | `×` (multiplication sign) | HIGH |
| L147 | `- Cache read: 0.1? base cost` | 1 | `×` | HIGH |
| L158 | `? **Wrong**: User input first` | 1 | `❌` | HIGH |

### Special Patterns (File 5)

1. **Wrong/Right pattern**: `? **Wrong**:` → `❌ **Wrong**:`, `? **Right**:` → `✅ **Right**:` — very consistent and automatable.
2. **Multiplication sign**: `1.25?` → `1.25×`, `0.1?` → `0.1×` — these are cost multipliers, NOT question marks.

### Legitimate `?` (File 5)

| Line | Context |
|------|---------|
| L127 | `# Which article?` — question in Python code comment |

**Total legitimate: 1** | **Total to fix: 14**

---

## File 6: `05-analysis/20.01-appendix_orchestration_case_study_details.md`

**Total `?` count: 57**

### Heading Emoji Map

```powershell
$headingEmojiMap = @{
    # TOC entries
    '^\- \[\?\? Real Implementation'   = '- [🔍 Real Implementation'
    '^\- \[\?\? Common Mistakes'       = '- [⚠️ Common Mistakes'
    # Section headings
    '^## \?\? Real Implementation'     = '## 🔍 Real Implementation Case Study'
    '^## \?\? Common Mistakes'         = '## ⚠️ Common Mistakes in Multi-Agent Orchestration'
}
```

**Confidence:** HIGH for ⚠️ (standard mistakes/warning). MEDIUM for 🔍 (analysis/investigation; could be 🏗️ or 📋).

### Line-by-Line Decode

**YAML / Title:**
| Line | Content | Decode | Confidence |
|------|---------|--------|------------|
| L2 | `title: "...orchestration ? implementation details..."` | `—` | HIGH |
| L9 | `# ...orchestration ? implementation details...` | `—` | HIGH |

**TOC (L15–L16):**
| Line | Content | Decode |
|------|---------|--------|
| L15 | `[?? Real Implementation Case Study](#-real...)` | `??` → heading emoji |
| L16 | `[?? Common Mistakes...](#?-common-mistakes...)` | `??` → heading emoji; anchor `#?` → will auto-fix when heading fixed |

**Headings (L29, L79):** See emoji map above.

**Cross-reference (L69):**
| Line | Content | Decode | Confidence |
|------|---------|--------|------------|
| L69 | `**[?? Prompt Creation...](...)** \`[?? Internal]\`` | `📖` + `📎 Internal` or `🔗 Internal` | LOW — "Internal" tag not in standard classification |

**Bad Example / Solution pattern (HIGHLY CONSISTENT):**
| Lines | Pattern | Decode | Confidence |
|-------|---------|--------|------------|
| L87, L157, L194, L243, L284, L320, L354, L388, L416 | `**? Bad example:**` | `❌` | HIGH |
| L110, L170, L221, L253, L300, L327, L360, L395, L425 | `**? Solution:**` or `**? Solution: ...**` | `✅` | HIGH |

**Down-arrow flow diagrams:**
| Lines | Content | Decode | Confidence |
|-------|---------|--------|------------|
| L197, L199, L201, L203, L205, L207, L209, L211 | Single `?` on own line (indented) | `↓` (down arrow in flow diagram) | HIGH |
| L227, L231 | Single `?` on own line | `↓` | HIGH |
| L306, L308, L310 | Single `?` on own line | `↓` | HIGH |

**Arrows:**
| Line | Content | Decode | Confidence |
|------|---------|--------|------------|
| L108 | `...control handoff ? duplicate instructions...` | `→` | HIGH |
| L314 | `...prompt file) ? Multiple execution agents...` | `→` | HIGH |
| L435 | `? USER reviews PR` | `→` | HIGH |

**Warning:**
| Line | Content | Decode | Confidence |
|------|---------|--------|------------|
| L368 | `?? **Review the deployment plan...**` | `⚠️` | HIGH |

**DO/DON'T:**
| Line | Content | Decode | Confidence |
|------|---------|--------|------------|
| L446 | `? **DO:**` | `✅` | HIGH |

### Legitimate `?` (File 6)

| Line | Context |
|------|---------|
| L251 | `What happens if deployment fails?` — legitimate question |
| L390 | `# What should agent continue?` — code comment question |
| L391 | `# What thing?` — code comment question |
| L392 | `# What is the next phase?` — code comment question |

**Total legitimate: 4** | **Total to fix: ~53**

---

## File 7: `05-analysis/21.2-appendix_orchestration_plan_specifications.md`

**Total `?` count: 533** (LARGEST FILE)

### Heading Emoji Map

```powershell
$headingEmojiMap = @{
    # Repeated section pattern (appears 3x for prompt, agent, updater specs)
    '^## \?\? CRITICAL BOUNDARIES'     = '## ⚠️ CRITICAL BOUNDARIES'
    '^### \? Always Do'                = '### ✅ Always Do'
    '^### \?\? Ask First'              = '### ⚠️ Ask First'
    '^### \?\? Never Do'               = '### 🚫 Never Do'
    # Data exchange section
    '^### \?\? Data Exchange'          = '### 📊 Data Exchange Optimization'
}
```

**Confidence:** HIGH for ⚠️, ✅, 🚫 (behavioral boundary pattern). MEDIUM for 📊.

### Pattern Categories

#### 1. Status indicators (`**Status**: ?? / ?`)

| Pattern | Decode | Lines | Count |
|---------|--------|-------|-------|
| `**Status**: ?? UPDATE` | `🔄 UPDATE` | L24, L86, L117, L158 | 4 × 2 = 8 |
| `**Status**: ? CREATE NEW` | `✨ CREATE NEW` | L206, L339, L407, L496 | 4 × 1 = 4 |
| `**Status**: ? NO CHANGES NEEDED` | `✅ NO CHANGES NEEDED` | L595, L606 | 2 × 1 = 2 |

#### 2. Validation status triplets (`[✅/⚠️/❌]`)

| Pattern | Decode | Lines |
|---------|--------|-------|
| `[?/??/?]` | `[✅/⚠️/❌]` | L77, L191, L192, L297, L566–L569 |
| `[? PASSED / ?? WARNINGS / ? FAILED]` | `[✅ PASSED / ⚠️ WARNINGS / ❌ FAILED]` | L561 |
| `[?/?]` | `[✅/❌]` | L192 |

#### 3. Inline validation indicators

| Pattern | Decode | Lines |
|---------|--------|-------|
| `? 3-7 tools: Optimal` | `✅` | L176 |
| `?? <3 tools: May be insufficient` | `⚠️` | L177 |
| `? >7 tools: Tool clash risk` | `❌` | L178 |
| `? FAIL` | `❌` | L181, L524, L532, L542 |
| `?? Warning` / `?? WARN` | `⚠️` | L182, L525, L533 |
| `? PASS` | `✅` | L526, L534 |

#### 4. Arrows (`→`)

| Line | Context | Confidence |
|------|---------|------------|
| L267 | `Map responsibilities ? capabilities ? tools` | HIGH |
| L270 | `` `agent: plan` ? ONLY read-only tools `` | HIGH |
| L271 | `` `agent: agent` ? read + write tools allowed `` | HIGH |
| L317 | `plan ? read-only only` | HIGH |
| L804 | `Phase 2 ? Phase 3 Handoff (Research ? Structure)` | HIGH |
| L858 | `Phase 4 ? Phase 5 Handoff (Build ? Validation)` | HIGH |
| L896–L900 | Table: `Orch ? Researcher`, `Researcher ? Orchestrator`, etc. | HIGH |
| L909 | `Phase {N} ? Phase {N+1}:` | HIGH |
| L932–L939 | Table: `User intent ? plan outline`, `Context ? detailed requirements`, etc. | HIGH |
| L973 | `Phase 2 ? Phase 3 Handoff` | HIGH |
| L1048, L1076 | `Phase {N} ? Phase {N+1}`, `Phase {N} ? Error Recovery` | HIGH |

#### 5. Em-dashes (`—`)

| Line | Context |
|------|---------|
| L236 | `...You NEVER create or modify files?you only research...` |
| L1215 | `Phase 7?8 iterations` — actually this is `→` (arrow between phases) |

#### 6. Token comparison markers

| Line | Pattern | Decode |
|------|---------|--------|
| L948 | `# ? Token-Heavy (passes full content)` | `❌` |
| L955 | `# ? Token-Efficient (passes reference + key sections)` | `✅` |

#### 7. Information forwarding table (L992–L1002)

| Line | Pattern | Decode |
|------|---------|--------|
| L994 | `? Always` | `✅` |
| L995 | `? Always` | `✅` |
| L996 | `? Always` | `✅` |
| L997 | `?? Summary only` | `⚠️` |
| L998 | `? References` | `✅` |
| L999 | `? Never` | `❌` |
| L1000 | `? Key decisions` | `✅` |
| L1001 | `? Full content` | `✅` |
| L1002 | `? Full details` | `✅` |

#### 8. Goal unchanged markers (L1022–L1023)

| Line | Pattern | Decode |
|------|---------|--------|
| L1022 | `Goal text unchanged ?/?` | `✅/❌` |
| L1023 | `Tool count unchanged ?/?` | `✅/❌` |

#### 9. Implementation plan table (L1241–L1276)

| Pattern | Decode | Lines |
|---------|--------|-------|
| `?? \| UPDATE` | `🔄` | L1241, L1242, L1250–L1253 |
| `? \| CREATE NEW` | `✨` | L1243, L1244, L1259–L1262 |
| `? \| NO CHANGES` | `✅` | L1268, L1269 |
| `?? \| ?` (rename arrow) | `🔄 \| →` | L1275, L1276 |

#### 10. Action items (L1284–L1288)

| Line | Pattern | Decode | Confidence |
|------|---------|--------|------------|
| L1284–L1288 | `1. ? **Review this plan**` | ⬜ (pending action) or 📋 | LOW — uncertain which "action item" emoji was used |

#### 11. MASSIVE Box-Drawing Flow Diagram (L623–L778)

**~150+ `?` characters across 156 lines.**

This is the most complex section. Two complete flow diagrams (Prompt flow + Agent flow) using box-drawing characters.

**Character mapping for box borders:**

| Position | Original char | Corrupted as |
|----------|---------------|-------------|
| Left/right box border | `│` (U+2502) | `?` |
| Top corner (right) | `┐` (U+2510) | Appears as `G??` — the `G` may also be corruption |
| Bottom corner | `┘` (U+2518) | `??` or similar |
| Between boxes (vertical) | `↓` (U+2193) | `?` alone on line |
| Horizontal arrow inside | `→` (U+2192) | `?` in `--?` pattern |
| Branch junction | `├` (U+251C) | `??---` pattern (├ + horizontal line) |

**Specific patterns in the diagram:**

```
Pattern: +------------------------------------------------------------G??
Decode:  +------------------------------------------------------------┐   (or ┤)
Issue:   The 'G' before '??' is suspicious — may be a 3-byte UTF-8 corruption artifact

Pattern:  ?                 PHASE 1: Requirements                       ?
Decode:   │                 PHASE 1: Requirements                       │

Pattern:  ?  Orchestrator --? prompt-researcher (challenge with cases) ?
Decode:   │  Orchestrator --> prompt-researcher (challenge with cases)  │
Note:     The '--?' is '--→' (arrow to agent)

Pattern:  ?       ??-------------------+ Requirements Report            ?
Decode:   │       ├────────────────────+ Requirements Report            │
Note:     The '??' before dashes is '├─' (branch junction)

Pattern:      ?
              ?
Decode:       ↓    (down arrow between boxes)
              ↓

Pattern:  ?? GATE: If tools >7, REJECT
Decode:   ⚠️ GATE: If tools >7, REJECT

Pattern:  ?? CRITICAL: Fail if tools >7
Decode:   ⚠️ CRITICAL: Fail if tools >7

Pattern:  ?? Preserve tool alignment
Decode:   ⚠️ Preserve tool alignment

Pattern:  ?? Max recursion depth: 2 levels
Decode:   ⚠️ Max recursion depth: 2 levels
```

**⚠️ MANUAL RECONSTRUCTION REQUIRED**: The flow diagram (L623–L778) needs character-by-character manual reconstruction. The `G??` pattern at box corners may need special handling — the `G` (0x47) could be an artifact of multi-byte UTF-8 corruption where the second byte of a 3-byte sequence happened to be valid ASCII.

### Legitimate `?` (File 7)

| Line | Context |
|------|---------|
| L48 | `Does goal provide clear guidance?` |
| L49 | `What gaps or ambiguities revealed?` |
| L50 | `What tools/boundaries discovered?` |
| L255 | `What specialist persona is needed?` |
| L256 | `What tasks will this agent handle?` |
| L257 | `What mode: read-only analysis (plan) or active modification (agent)?` |
| L261 | `Test each: Can this role handle effectively?` |
| L439 | `Validation report with issues?` |
| L440 | `User-specified changes?` |
| L441 | `Tool realignment needed?` |
| L450 | `Check: Will update break agent/tool alignment?` |
| L451 | `Check: Will update exceed 7-tool limit?` |
| L911 | `Refined goal from Phase 1 intact?` |
| L912 | `IN/OUT scope carried forward?` |
| L913 | `Tool list present in handoff?` |
| L914 | `Boundaries included?` |
| L915 | `Success criteria defined?` |
| L992 | `Pass Forward?` (table header) |

**Total legitimate: ~18** | **Total to fix: ~515**

---

## File 8: `06-reference/01.10-customization_decision_framework_reference.md`

**Total `?` count: 320**

### Heading Emoji Map

Based on the sibling uncorrupted reference article `01.09` (uses ⚙️, ⚠️, 🔧, 🔄, 🖥️, 🎯, 📚) and content analysis:

```powershell
$headingEmojiMap = @{
    # TOC entries (L17-L27) — same emoji as corresponding heading
    '^\- \[\?\? Master decision framework'          = '- [🗺️ Master decision framework'
    '^\- \[\?\? Mechanism comparison matrix'         = '- [📊 Mechanism comparison matrix'
    '^\- \[\?\? Quick-reference lookup'              = '- [🔍 Quick-reference lookup table'
    '^\- \[\?\? Written customizations'              = '- [✏️ Written customizations'
    '^\- \[\?\? Identity and capabilities'           = '- [🤖 Identity and capabilities'
    '^\- \[\?\? Enforcement'                         = '- [⚖️ Enforcement'
    '^\- \[\?\? Tool sources'                        = '- [🔌 Tool sources'
    '^\- \[\?\? Persistent context'                  = '- [🧠 Persistent context'
    '^\- \[\?\? Specialized decision trees'          = '- [🌳 Specialized decision trees'
    '^\- \[\?\? Conclusion'                          = '- [🎯 Conclusion'
    '^\- \[\?\? References'                          = '- [📚 References'
    # Section headings (L31, L81, L125, L154, L189, L228, L255, L291, L327, L376, L393)
    '^## \?\? Master decision framework'             = '## 🗺️ Master decision framework'
    '^## \?\? Mechanism comparison matrix'            = '## 📊 Mechanism comparison matrix'
    '^## \?\? Quick-reference lookup table'           = '## 🔍 Quick-reference lookup table'
    '^## \?\? Written customizations'                = '## ✏️ Written customizations: prompts vs. instructions vs. context files'
    '^## \?\? Identity and capabilities'             = '## 🤖 Identity and capabilities: agents vs. skills'
    '^## \?\? Enforcement'                           = '## ⚖️ Enforcement: hooks vs. instructions'
    '^## \?\? Tool sources'                          = '## 🔌 Tool sources: built-in vs. MCP vs. extensions'
    '^## \?\? Persistent context'                    = '## 🧠 Persistent context: Memory vs. instructions vs. Spaces'
    '^## \?\? Specialized decision trees'            = '## 🌳 Specialized decision trees'
    '^## \?\? Conclusion'                            = '## 🎯 Conclusion'
    '^## \?\? References'                            = '## 📚 References'
}
```

**Confidence:** HIGH for 🎯, 📚 (universal). MEDIUM for 🗺️, 📊, 🔍, ✏️, 🤖, ⚖️, 🔌, 🧠, 🌳 (content-inferred, no uncorrupted equivalent exists).

### Pattern Categories

#### 1. Master Decision Tree (L36–L76)

Each tree line has 1-3 `?` characters mapping to tree-drawing and mechanism-type emojis:

**Tree-drawing characters:**
| Line | Pattern | Decode |
|------|---------|--------|
| L37 | `?` at start | `│` (vertical) |
| L39, L43, L47, L51, L55, L59, L63, L67, L71 | `?   +- ? Description` | First `?` = `│`, second `?` = mechanism emoji |
| L75 | `    +- ? GitHub Copilot SDK` | `?` = mechanism emoji |

**Mechanism-type emojis in tree leaves:**
| Line | Text after `?` | Decode | Confidence |
|------|----------------|--------|------------|
| L39 | `? Instruction file (.instructions.md)` | `📚` | HIGH (matches 01.03) |
| L43 | `? Prompt file (.prompt.md)` | `📝` | HIGH (matches 01.03) |
| L47 | `? Context file (.md)` | `📁` | HIGH (matches 01.03) |
| L51 | `? Agent file (.agent.md)` | `🤖` | HIGH (matches convention) |
| L55 | `? Skill (SKILL.md)` | `📦` | MEDIUM (matches 01.05) |
| L59 | `? Hook (.github/hooks/*.json)` | `🪝` | HIGH (matches 01.05) |
| L63 | `? MCP server (mcp.json)` | `🔌` | HIGH (matches 01.06) |
| L67 | `? Let Copilot Memory learn them` | `🧠` | HIGH (matches topic) |
| L71 | `? Copilot Spaces` | `🌐` | MEDIUM |
| L75 | `? GitHub Copilot SDK` | `💻` | MEDIUM |

**Cross-reference callouts in tree:**
| Lines | Pattern | Decode | Confidence |
|-------|---------|--------|------------|
| L40, L44, L48, L52, L56, L60, L64, L68, L72, L76 | `?? Concept:` / `?? How-to:` | `📖` | MEDIUM — consistent pattern, but no uncorrupted equivalent to verify |

Also: L185, L224, L251, L287, L323, L343, L359, L372 | `> ?? **Deep dive:**` / `> ?? **How-to:**` → `📖`

#### 2. Comparison Matrix Platform Column (L87–L96)

| Line | Pattern | Decode | Confidence |
|------|---------|--------|------------|
| L87 | `? VS Code only` | Single-platform emoji (🖥️ or 📍) | LOW |
| L88 | `?? VS Code + GitHub.com` | Cross-platform emoji (🌐 + VS?) | LOW |
| L89 | `? VS Code + VS` | Platform emoji | LOW |
| L90 | `? VS Code only` | Same as L87 | LOW |
| L91 | `? VS Code, CLI, coding agent` | Wider platform | LOW |
| L92 | `? VS Code, CLI, Claude Code` | Wider platform | LOW |
| L93 | `? Any MCP client` | Widest platform | LOW |
| L94 | `? IDE, CLI, code review` | Wide platform | LOW |
| L95 | `? GitHub-hosted` | Cloud platform | LOW |
| L96 | `? Any platform` | Universal | LOW |

> **⚠️ MANUAL REVIEW NEEDED**: The platform column emojis are uncertain. Each platform reach level might use a different emoji (🖥️ for single, 🌐 for cross-platform) or they might all use the same bullet/indicator emoji. Need to check the author's intent.

#### 3. Capability Matrix (L102–L108)

Each row has 5 `?` indicators. Headers appear to be: Tool control | External resources | Blocking | Deterministic | Handoffs

| Indicator value | Decode |
|----------------|--------|
| `? Full` | `✅ Full` |
| `? None` | `❌ None` |
| `? No` | `❌ No` |
| `? Yes` | `✅ Yes` |
| `? Limited` | `⚠️ Limited` |
| `? N/A` | `➖ N/A` |
| `? Via tools` | `🔧 Via tools` |
| `? Via resources` | `📦 Via resources` |

7 rows × 5 columns = ~35 `?` indicators
**Confidence:** MEDIUM — ✅/❌ pattern is likely, but ➖/🔧/📦 are uncertain.

#### 4. Token Cost Ranges (L114–L118)

| Line | Pattern | Decode |
|------|---------|--------|
| L114 | `200?1,000 tokens` | `–` (en dash) for range |
| L115 | `500?2,000 tokens` | `–` |
| L117 | `200?800 tokens` | `–` |
| L118 | `~50?100 (discovery) ? 500?1,500 (on match) ? variable` | `–` for ranges, `→` for progression arrows |

#### 5. Additional Decision Trees (L170–L182, L207–L221, L258–L270, L308–L320, L332–L356)

Same tree-drawing pattern as master tree:
- `?` at line start → `│`
- `?   +- ?` → `│   +- EMOJI`
- `+- Yes ? result` → `→`
- `+- No  ? result` → `→`

Each tree has ~15-25 `?` characters.

**Mechanism emojis in secondary trees follow the same mapping as the master tree.**

#### 6. Comparison Table Indicators (L163–L164, L198–L201, L235–L247, L279–L285, L301–L302)

| Pattern | Decode |
|---------|--------|
| `? Full` | `✅ Full` |
| `? None` | `❌ None` |
| `? Not available` | `❌ Not available` |
| `? Not applicable` | `➖ Not applicable` |
| `? Full ? defines...` | `✅ Full → defines...` |
| `? Limited` | `⚠️ Limited` |
| `? Yes` | `✅ Yes` |
| `? No` | `❌ No` |
| `? Personal only` | `👤 Personal only` or `🔒 Personal only` |
| `? Via Git` | `🔗 Via Git` or `✅ Via Git` |
| `? Via GitHub` | `🌐 Via GitHub` or `✅ Via GitHub` |
| `? Follows you` | `🔄 Follows you` or `✅ Follows you` |
| `? Per repository` | `📁 Per repository` |
| `? Multi-repo` | `🌐 Multi-repo` |

> **⚠️ MANUAL REVIEW NEEDED**: The sharing/scope table (L301–L302) uses descriptive emojis that vary per cell. These need author intent verification.

#### 7. Enforcement Comparison (L235–L247)

| Line | Pattern | Decode |
|------|---------|--------|
| L235 | `Medium ? model may ignore \| High ? your code runs deterministically` | `—` (em dash separator) × 2 |
| L244 | `Hook ?` | `✅` (winner indicator) |
| L245 | `Hook ?` | `✅` |
| L246 | `Instruction ?` | `✅` |
| L247 | `Instruction ?` | `✅` |

#### 8. Reference Description Arrows (L396–L401)

| Pattern | Decode |
|---------|--------|
| `[link text](url) ? Description` | `→` (em dash more likely: `—`) |

**Confidence:** MEDIUM — could be `→` or `—`. Looking at File 9 which has the same pattern with `—`, these are likely `—`.

### Legitimate `?` (File 8)

| Line | Context |
|------|---------|
| L13 | `...one question: **"which mechanism should I use?"**` — legitimate question in prose |
| L353 | `Long context (>100K)?` — this is "Long context (>100K)?" which could be legitimate or `→`. Context: `+- Long context (>100K)? Claude Sonnet 4` — this is a decision tree leaf, so `?` = `→` |

Actually L353 needs more analysis: `+- Long context (>100K)? Claude Sonnet 4 / Gemini 2.0` — in the decision tree, the pattern is `+- Criterion → Recommendation`. The space before `Claude` suggests this is `→`. NOT LEGITIMATE.

L13: `...answers one question: **"which mechanism should I use?"**` — legitimate question in quoted text.

**Total legitimate: 1** | **Total to fix: ~319**

---

## File 9: `06-reference/01.11-yaml_frontmatter_reference.md`

**Total `?` count: 137**

### Heading Emoji Map

```powershell
$headingEmojiMap = @{
    # TOC entries (L17-L26)
    '^\- \[\?\? Prompt files'              = '- [📝 Prompt files'
    '^\- \[\?\? Agent files'               = '- [🤖 Agent files'
    '^\- \[\?\? Instruction files'         = '- [📚 Instruction files'
    '^\- \[\?\? Skill files'               = '- [📦 Skill files'
    '^\- \[\?\? Hook files'                = '- [🪝 Hook files'
    '^\- \[\?\? Cross-type field'          = '- [📊 Cross-type field comparison'
    '^\- \[\?\? The tools field'           = '- [🔧 The tools field'
    '^\- \[\?\? Complete examples'         = '- [💡 Complete examples'
    '^\- \[\?\? Conclusion'                = '- [🎯 Conclusion'
    '^\- \[\?\? References'                = '- [📚 References'
    # Section headings (L30, L89, L179, L249, L321, L383, L402, L463, L531, L544)
    '^## \?\? Prompt files'                = '## 📝 Prompt files (`.prompt.md`)'
    '^## \?\? Agent files'                 = '## 🤖 Agent files (`.agent.md`)'
    '^## \?\? Instruction files'           = '## 📚 Instruction files (`.instructions.md`)'
    '^## \?\? Skill files'                 = '## 📦 Skill files (`SKILL.md`)'
    '^## \?\? Hook files'                  = '## 🪝 Hook files (`.json`)'
    '^## \?\? Cross-type field comparison' = '## 📊 Cross-type field comparison'
    '^## \?\? The `tools` field'           = '## 🔧 The `tools` field: shared syntax'
    '^## \?\? Complete examples'           = '## 💡 Complete examples'
    '^## \?\? Conclusion'                  = '## 🎯 Conclusion'
    '^## \?\? References'                  = '## 📚 References'
}
```

**Confidence:** HIGH for 📝, 🤖, 🪝, 🎯, 📚 (match concept article conventions). MEDIUM for 📚 (Instructions — same emoji as References, but matches 01.03), 📦 (Skills — could be 🔧; matches 01.05), 📊, 🔧, 💡 (content-inferred).

### Pattern Categories

#### 1. YAML em-dashes (L6)

```
description: "...file types ? prompt files, agent files, instruction files, and skill files ? with field types..."
```
Two `?` → two `—` (em dashes). **Confidence:** HIGH

#### 2. Cross-reference callouts (L85, L175, L245, L317, L379)

| Pattern | Decode | Confidence |
|---------|--------|------------|
| `> ?? **How-to:**` | `📖` | MEDIUM |

#### 3. Prose em-dashes

| Lines | Context | Confidence |
|-------|---------|------------|
| L80 | `...name is omitted: ...prompt.md ? /create-tests` | Could be `→` (arrow showing result) | HIGH |
| L122 | `Removed ? use the two separate fields instead` | `—` | HIGH |
| L128 | `Security review agent ? analyzes code...` | `—` | HIGH |
| L163 | `NEVER edit files ? you plan, you don't implement` | `—` | HIGH |
| L170 | `...restricts the agent to read-only ? it literally can't access...` | `—` | HIGH |
| L186 | `...for path-specific instructions ? without it...` | `—` | HIGH |
| L204 | `All files (use sparingly ? consumes tokens...)` | `—` | HIGH |
| L239 | `...inject into the system prompt ? they carry more weight...` | `—` | HIGH |
| L240 | `...match the same file ? they compose additively...` | `—` | HIGH |
| L241 | `...copilot-instructions.md has no applyTo ? it applies to everything` | `—` | HIGH |
| L259 | `...Copilot uses this for discovery matching ? include action verbs...` | `—` | HIGH |
| L261 | `...only two fields in the skill YAML ? simplicity by design...` | `—` | HIGH |
| L535–L539 | Conclusion bullets: `have 6 fields ?`, `richest schema ?`, `simplest ?`, `2 required fields ? name and description ?`, `use JSON, not YAML ?` | `—` | HIGH |
| L547–L552 | Reference descriptions: `[link] ? Description` | `—` | HIGH |
| L555 | `...**Source for file formats and field specifications` | `—` | HIGH |

#### 4. Arrows (`→`)

| Line | Context | Confidence |
|------|---------|------------|
| L80 | `create-tests.prompt.md ? /create-tests` | `→` (filename → command name) | HIGH |
| L304 | `? webapp-testing ? lowercase, hyphens` | Second `?` = `→` (arrow to description) | HIGH |
| L305 | `? react-scaffolding ? descriptive, valid` | `→` | HIGH |
| L306 | `? WebApp Testing ? no spaces, no uppercase` | `→` | HIGH |
| L307 | `? my_skill ? no underscores` | `→` | HIGH |
| L312 | `1. **Discovery** ? Copilot lists it...` | `→` | HIGH |
| L313 | `2. **Matching** ? Copilot uses it...` | `→` | HIGH |
| L455 | `? overrides` | `→` | HIGH |
| L457 | `? overrides` | `→` | HIGH |

#### 5. Status indicators in naming examples (L304–L307)

| Line | Pattern | Decode |
|------|---------|--------|
| L304 | `- ? webapp-testing` | `✅` (correct naming) |
| L305 | `- ? react-scaffolding` | `✅` |
| L306 | `- ? WebApp Testing` | `❌` (incorrect naming) |
| L307 | `- ? my_skill` | `❌` |

Note: These lines have TWO `?` each — first is ✅/❌, second is → (arrow).

#### 6. Cross-type comparison table (L389–L398)

Each row has 4 indicators (Prompt, Agent, Instruction, Skill columns):

| Indicator value | Decode |
|----------------|--------|
| `? Overrides agent tools` | `✅` |
| `? Defines available tools` | `✅` |
| `? Not available` | `❌` |
| `? Routes to specific LLM` | `✅` |
| `? Not applicable` | `➖` |
| `? Sets preferred model` | `✅` |
| `? Sets chat mode` | `✅` |
| `? Glob matching pattern` | `✅` |
| `? Workflow transitions` | `✅` |
| `? Subagent access control` | `✅` |
| `? Chat input hint` | `✅` |
| `? Controls picker visibility` | `✅` |
| `? Exclude from agents` | `✅` |

10 rows × 4 columns = ~40 `?` indicators
**Confidence:** MEDIUM for ✅/❌ mapping, LOW for ➖.

#### 7. File tree (L269–L273)

| Line | Pattern | Decode |
|------|---------|--------|
| L269 | `?   +-- component.test.js` | `├` |
| L271 | `?   +-- login-form-tests.js` | `├` |
| L273 | `?   +-- setup-test-env.sh` | `└` (last entry) |

#### 8. Hook table (L346 area)

`Can block?` in table header — LEGITIMATE question mark.

Wait, looking at L346: `| Event | When it fires | Can block? |` — this `?` IS the actual question "Can block?" used as a column header. This might be legitimate OR it might be `Can block❓` but that seems unlikely for a table header. **Treat as LEGITIMATE.**

### Legitimate `?` (File 9)

| Line | Context |
|------|---------|
| L13 | `...answers: **"what fields can I put in the YAML header?"**` — quoted question |
| L346 | `Can block?` — table column header |

**Total legitimate: 2** | **Total to fix: ~135**

---

## Cross-File Pattern Summary

### Automatable Patterns (regex-safe)

These patterns are consistent across files and can be scripted:

| Pattern | Replacement | Files |
|---------|-------------|-------|
| `\*\*\? Bad example` | `**❌ Bad example` | 6 |
| `\*\*\? Solution` | `**✅ Solution` | 6 |
| `\? \*\*Wrong\*\*` | `❌ **Wrong**` | 5 |
| `\? \*\*Right\*\*` | `✅ **Right**` | 5 |
| `\*\*Status\*\*: \?\? UPDATE` | `**Status**: 🔄 UPDATE` | 7 |
| `\*\*Status\*\*: \? CREATE NEW` | `**Status**: ✨ CREATE NEW` | 7 |
| `\*\*Status\*\*: \? NO CHANGES` | `**Status**: ✅ NO CHANGES` | 7 |
| `\[\?/\?\?/\?\]` | `[✅/⚠️/❌]` | 7 |
| `\[\?/\?\]` | `[✅/❌]` | 7 |
| `\? FAIL` | `❌ FAIL` | 7 |
| `\?\? WARN` | `⚠️ WARN` | 7 |
| `\? PASS` | `✅ PASS` | 7 |
| `> \?\? \*\*Deep dive` | `> 📖 **Deep dive` | 8 |
| `> \?\? \*\*How-to` | `> 📖 **How-to` | 8, 9 |
| `\?\? Concept:` | `📖 Concept:` | 8 |
| `\?\? How-to:` | `📖 How-to:` | 8 |
| `\?\? Overview:` | `📖 Overview:` | 8 |
| Prose `\?` between words (no space before) | `—` | ALL |
| `--\?` in diagrams | `--→` | 7, 8 |
| Code `\.?\.\w` / `\?\?` / `\?q=` in ` ``` ` blocks | **SKIP** | 3, 4 |

### Manual-Fix-Required Patterns

These require human judgment or context-specific decisions:

1. **Box-drawing diagrams** (Files 2, 7): Character-by-character reconstruction needed for `│`, `├`, `└`, `┤`, `┐`, `┘`, `─` characters. The `G??` border endings in File 7 are especially complex.

2. **Decision trees** (Files 2, 8): Mix of tree-drawing characters (`│`, `├`, `└`) and mechanism-type emojis (📝, 📚, 📁, 🤖, etc.) on the same lines.

3. **Platform reach column** (File 8, L87–L96): Each platform level may use a different emoji. Need author confirmation.

4. **Capability matrix indicators** (Files 8, 9): The `➖`, `🔧`, `📦` indicators for "N/A", "Via tools", "Via resources" need confirmation. ✅/❌ mappings are confident.

5. **Sharing/scope indicators** (File 8, L301–L302): Descriptive emojis per cell (`👤`, `🔗`, `🌐`, `📁`, `🔄`) are uncertain.

6. **Action items** (File 7, L1284–L1288): The `?` before numbered steps could be ⬜, 📋, or another "pending task" emoji.

7. **Internal reference tag** (File 6, L69): `[?? Internal]` — not in the standard 📘📗📒📕 classification system.

8. **Cross-reference emoji** (Files 8, 9): `?? Concept:`, `?? How-to:`, `?? Deep dive:` → `📖` is a best guess. Could also be `👉`, `📎`, or `🔗`.

### Heading Emoji Confidence Summary

| Emoji | Used in heading | Verified from sibling? | Confidence |
|-------|----------------|----------------------|------------|
| 🎯 | Conclusion, What is (intro) | YES — all `01.02`–`01.08` | HIGH |
| 📚 | References | YES — all siblings | HIGH |
| ⚠️ | Boundaries, Common mistakes/pitfalls, Critical | YES — all siblings | HIGH |
| 🏗️ | Architecture/stack | YES — `01.02`, `01.04`, `01.06`, `01.07`, `01.08` | HIGH |
| 📊 | Comparison/matrix | YES — `01.02`, `01.07` | HIGH |
| 📋 | Catalog/checklist | YES — `01.04`, `01.06`, `01.07`, `01.08` | HIGH |
| ⚙️ | Impact/mechanism | YES — `01.06` only | MEDIUM |
| 🔧 | Implementation | YES — `01.07`, `01.09-ref` | MEDIUM |
| 🔍 | Investigation/lookup | Partial — `01.03` uses for scope | MEDIUM |
| 🗺️ | Master framework | NO — unique to `01.10` | LOW-MEDIUM |
| ✏️ | Written customizations | NO — unique to `01.10` | LOW-MEDIUM |
| 🤖 | Agents/identity | Convention-based | MEDIUM |
| ⚖️ | Enforcement | NO — unique to `01.10` | LOW-MEDIUM |
| 🔌 | Tool sources | YES — `01.06` | MEDIUM |
| 🧠 | Memory/persistent context | YES — `01.07` | MEDIUM |
| 🌳 | Decision trees | NO — unique to `01.10` | LOW-MEDIUM |
| 📝 | Prompt files | YES — `01.03` | HIGH |
| 📦 | Skills | YES — `01.05` | MEDIUM |
| 🪝 | Hooks | YES — `01.05` | HIGH |
| 💡 | Examples | NO — unique to `01.11` | LOW-MEDIUM |
| 🚫 | Never Do | Convention-based | MEDIUM |
| ✅ | Always Do | Convention-based | HIGH |
| 📖 | Cross-reference callout | No uncorrupted example available | LOW-MEDIUM |

---

## Recommended Fix Order

1. **File 5** (15 `?`, 1 legitimate) — simplest, all patterns clear
2. **File 3** (19 `?`, 10 legitimate) — simple, but must exclude code syntax
3. **File 4** (20 `?`, 1 legitimate) — simple em-dash/arrow/tree patterns
4. **File 6** (57 `?`, 4 legitimate) — medium complexity, consistent Bad/Solution pattern
5. **File 9** (137 `?`, 2 legitimate) — medium-large, mostly heading + table indicators
6. **File 2** (166 `?`, 0 legitimate) — includes 2 box-drawing diagrams
7. **File 8** (320 `?`, 1 legitimate) — large, many decision trees and capability matrices
8. **File 7** (533 `?`, 18 legitimate) — largest, massive flow diagrams need manual reconstruction
