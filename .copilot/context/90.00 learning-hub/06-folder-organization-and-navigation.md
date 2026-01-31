# Folder Organization and Navigation Rules

This document defines folder naming conventions, organization patterns, and sidebar menu rules for the Learning Hub documentation site.

## Folder Naming Conventions

### Numeric Prefix Patterns

Folders use numeric prefixes for ordering. The format is `XX.YY` where both parts can have varying digit counts:

| Pattern | Example | Purpose |
|---------|---------|---------|
| `XX.00 Category/` | `01.00 news/` | Top-level category |
| `XX.YY Subcategory/` | `05.02 PromptEngineering/` | Nested subcategory |
| `XXX.YYY Subcategory/` | `120.345 Advanced/` | Extended numbering |

**Rules:**
- Integer part (`XX`) determines primary sort order
- Fractional part (`.YY`) determines secondary sort order
- Both parts can have 1-3+ digits
- Space separates prefix from readable name
- Use kebab-case for multi-word names: `05.02 prompt-engineering/`

### Date Prefix Patterns

Time-sensitive content uses date prefixes:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `YYYYMMDD Topic/` | `20251224 vscode v1.107 Release/` | Daily content (news, releases) |
| `YYYYMM Event/` | `202506 Build 2025/` | Monthly content (events, conferences) |

**Rules:**
- Keep date in menu item name for context
- Space separates date from topic name

---

### ⚠️ CRITICAL: Glob Sorting Behavior (Quarto Limitation)

**Fundamental fact:** Quarto glob patterns (`**/*.md`) sort **ALPHABETICALLY**, which produces **OLDEST-FIRST** for YYYYMMDD prefixes:

```
Glob order (alphabetical):
20251111...  ← First (oldest)
20251224...
20260130...  ← Last (newest)
```

**Globs CANNOT produce newest-first ordering.** This is a Quarto limitation, not a configuration option.

#### Decision Table: Glob vs Explicit List

| Requirement | Use Glob | Use Explicit List |
|-------------|----------|-------------------|
| Auto-discover new content | ✅ YES | ❌ NO (manual maintenance) |
| Newest-first ordering | ❌ NO (impossible) | ✅ YES |
| Oldest-first acceptable | ✅ YES | ✅ YES |
| Non-date prefixed folders | ✅ YES (sorts correctly) | Optional |

#### Recommended Approach by Section

| Section | Recommended | Rationale |
|---------|-------------|----------|
| `01.00 news/` | **Explicit list** | News requires newest-first; manual maintenance is acceptable |
| `02.00 events/` | **Glob** | Events sorted by session ID (alphabetical is fine) |
| `03.00 tech/` | **Glob** | Alphabetical by topic is appropriate |
| `04.00 howto/` | **Glob** | Alphabetical is appropriate |
| `05.00 issues/` | **Glob** | Alphabetical is appropriate |

### Kebab-Case Preference

**Always prefer kebab-case** for folder and file names:

```
✅ Good: 05.02 prompt-engineering/
✅ Good: 20251224-vscode-release/
✅ Good: azure-functions-tutorial.md

❌ Bad: 05.02 Prompt Engineering/  (spaces)
❌ Bad: PromptEngineering/          (no spaces, hard to read in URLs)
```

**Rationale:** Quarto compiles paths to URLs. Kebab-case produces clean, SEO-friendly addresses.

## Folder Organization Patterns

### Learning Hub Subject Folder Template

For technology topics, follow this structure:

```
XX.YY Subject/
├── 00-overview.md           # Overview (first-touch orientation)
├── 01-getting-started.md    # Getting Started (quickstart + tutorial)
├── 02-concepts.md           # Concepts (mental model)
├── 03-how-to-*.md           # How-to guides (task-oriented)
├── 04-analysis-*.md         # Analysis (evaluations, comparisons)
├── 05-reference.md          # Reference (specifications)
├── 06-resources.md          # Resources (curated links, FAQs)
└── images/                  # Supporting images
```

### News and Events Folders

For time-sensitive content:

```
01.00 news/
├── 20260131 Topic A/        # Newest first
│   ├── session-summary.md   # Short article title (folder has context)
│   └── session-analysis.md
├── 20260124 Topic B/
└── 20260111 Topic C/
```

### Single-Article Folders

When a folder contains only one meaningful article, the folder provides context and the article title should be minimal:

| Folder Name | Article Title | ✅/❌ |
|-------------|---------------|-------|
| `20251224 vscode v1.107 Release/` | `Session Summary` | ✅ |
| `20251224 vscode v1.107 Release/` | `Recording Summary: VS Code v1.107 Release Live Stream` | ❌ Redundant |

## Sidebar Menu Rules

### Folder-to-Menu-Item Mapping

**Rule 1: Remove numeric prefixes from menu item names**

| Folder | Menu Item |
|--------|-----------|
| `01.00 news/` | "News & Updates" |
| `05.02 PromptEngineering/` | "Prompt Engineering" |
| `03.00 tech/` | "Technologies" |

**Rule 2: Keep date prefixes in menu item names**

| Folder | Menu Item |
|--------|-----------|
| `20251224 vscode v1.107 Release/` | "20251224 vscode v1.107 Release" |
| `202506 Build 2025/` | "Build 2025" (month can be omitted if obvious) |

**Rule 3: Display date-prefixed items newest-first (requires explicit list)**

Date-prefixed folders and articles SHOULD display in reverse chronological order. **This requires using explicit lists**—globs produce oldest-first.

### Menu Item Naming Rules

**Shortest possible name** — avoid redundancy with folder context:

| Folder | Article File | Menu Item | Rationale |
|--------|--------------|-----------|-----------|
| `20251224 vscode v1.107 Release/` | `session-summary.md` | "Session Summary" | Folder provides topic context |
| `20251224 vscode v1.107 Release/` | `session-analysis.md` | "Session Analysis" | Folder provides topic context |
| `03.00 tech/02.01 Azure/` | `functions-overview.md` | "Functions Overview" | Parent provides "Azure" context |

**Title Resolution Order:**
1. YAML frontmatter `title:` field (preferred)
2. First H1 heading in article content
3. Filename (converted from kebab-case)
4. Parent folder name (if file is index.md or similar)

### Glob Pattern Implementation

**Glob patterns auto-discover content but sort alphabetically:**

```yaml
# ✅ Use glob when alphabetical order is acceptable
contents: "03.00 tech/**/*.md"
```

**Explicit lists achieve newest-first but require maintenance:**

```yaml
# ✅ Use explicit list when newest-first is required
contents:
  - "01.00 news/20260130 topic/article.md"  # newest
  - "01.00 news/20260124 topic/article.md"
  - "01.00 news/20260111 topic/article.md"
  - "01.00 news/20251224 topic/article.md"  # oldest
```

**When adding new content to explicit-list sections:**
1. Add new entry at TOP of list
2. Run `quarto preview` to verify
3. Commit with navigation changes

### Single-Article Folder Handling

When a date-prefixed folder contains only one article, **collapse to single menu entry**:

```yaml
# Folder: 20251224 vscode v1.107 Release/summary.md
# Instead of nested structure, show as single item:
- href: "01.00 news/20251224 vscode v1.107 Release/summary.md"
  text: "20251224 VS Code v1.107 Release"
```

### Icon Selection

Choose Bootstrap Icons semantically:

| Category | Recommended Icons |
|----------|-------------------|
| News/Updates | `newspaper`, `megaphone` |
| Events | `calendar-event`, `calendar3` |
| Technologies | `cpu`, `code-slash`, `terminal` |
| How-to/Guides | `tools`, `wrench-adjustable` |
| Ideas/Projects | `lightbulb`, `briefcase` |
| Analysis | `graph-up`, `bar-chart` |
| Reference | `book`, `journal-code` |

## Summary: Key Rules

### Content Naming
1. **Numeric prefixes** (`XX.YY`) — Remove from menu item names
2. **Date prefixes** (`YYYYMMDD`) — Keep in menu item names
3. **Kebab-case** — Preferred for all folder/file names
4. **Shortest name** — Avoid redundancy with folder context
5. **Title from metadata** — Prefer YAML title over filename

### Navigation Strategy (CRITICAL)
6. **Globs sort ALPHABETICALLY** — This produces oldest-first for YYYYMMDD prefixes
7. **Newest-first REQUIRES explicit lists** — Globs cannot achieve this
8. **Use explicit lists for News** — Newest-first display is required
9. **Use globs for Tech/How-To/Events** — Alphabetical order is acceptable

### Structure
10. **Single-article folders** — Collapse to single menu entry
