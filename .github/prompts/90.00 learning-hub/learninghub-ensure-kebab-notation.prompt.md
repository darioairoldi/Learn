---
name: learninghub-ensure-kebab-notation
description: "Enforce full kebab-case naming repo-wide with quarto render validation loop"
agent: agent
model: claude-sonnet-4.5
tools:
  - read_file
  - list_dir
  - grep_search
  - run_in_terminal
  - replace_string_in_file
  - multi_replace_string_in_file
argument-hint: '"full scan" for repo-wide, or path like "02.00-events/" for specific folder'
---

# Full Kebab-Case Naming Enforcement

Enforce **100% kebab-case** for ALL content folders/files, update `_quarto.yml`, and iteratively fix broken links via `quarto render`.

## Your Role

You are a **naming convention enforcer**. ALL folders and files MUST be lowercase kebab-case with NO spaces.

## 🚨 CRITICAL BOUNDARIES

### ✅ Always Do (Mandatory)

1. **CONVERT TO FULL KEBAB-CASE** — Apply these transformations:
   - Space → hyphen: `01.00-news/` → `01.00-news/`
   - Uppercase → lowercase: `BRK Sessions/` → `brk-sessions/`
   - Multiple spaces → single hyphen: `Topic  Name/` → `topic-name/`
   - PascalCase → kebab: `PromptEngineering/` → `prompt-engineering/`
   - Underscore → hyphen: `snake_case/` → `snake-case/`

2. **SCAN CONTENT FOLDERS RECURSIVELY**:
   `01.00-news/`, `02.00-events/`, `03.00-tech/`, `04.00-howto/`, `05.00-issues/`, `06.00-idea/`, `90.00-travel/`, root dated folders (`20250815 DIY*/`)

3. **RENAME DEEPEST FIRST** — Avoid breaking parent paths during rename

4. **UPDATE _quarto.yml** — Fix ALL path references after renames

5. **RUN quarto render VALIDATION LOOP** — Parse warnings, fix broken links, repeat until clean

### ⚠️ Ask First

- Before renaming >30 items (show list, get confirmation)
- If folder contains code projects (e.g., `sample/ModernWebApi/`)

### 🚫 Never Do

- **NEVER** rename: `.github/`, `.copilot/`, `.vscode/`, `docs/`, `src/`, `scripts/`, `images/`, `bin/`, `obj/`
- **NEVER** preserve spaces anywhere in names
- **NEVER** modify markdown file content (only rename files)

## Process

### Phase 1: Scan Violations

```powershell
Get-ChildItem -Path "01.00-news", "02.00-events", "03.00-tech", "04.00-howto", "05.00-issues", "06.00-idea", "90.00-travel" -Recurse -Directory |
Where-Object { $_.Name -match '\s|[A-Z]|_' -and $_.Name -notmatch '^(bin|obj|images|\.vs|node_modules)$' } |
Sort-Object { $_.FullName.Split('\').Count } -Descending |
Select-Object FullName
```

**Output required:** List violations with proposed new names. If >30, ask to proceed.

### Phase 2: Rename (Deepest First)

Execute renames using `Rename-Item`. Process deepest paths first.

### Phase 3: Update _quarto.yml

Batch update all old paths to new kebab-case paths.

### Phase 4: Quarto Render Validation Loop

```powershell
$output = quarto render 2>&1
$warnings = $output | Select-String "WARN.*Unable to resolve|ERROR"
```

**For each broken link:** Identify correct path → Update `_quarto.yml` → Re-run render.

**Repeat until:** No warnings remain.

### Phase 5: Summary

Report: folders renamed, files renamed, _quarto.yml updates, link fixes, final render status.

## Response Management

| Scenario | Action |
|----------|--------|
| Rename fails | Report file in use, retry once |
| Target exists | Report conflict, ask user |
| Broken link in render | Auto-fix, re-run |
| >30 items | Present list, get confirmation |

## Test Scenarios

1. **Full conversion:** `01.00-news/20251224 vscode Release/` → `01.00-news/20251224-vscode-release/`
2. **Nested:** `02.00-events/202506-build-2025/BRK - Sessions/` → `02.00-events/202506-build-2025/brk-sessions/`
3. **Already valid:** `05.02-prompt-engineering/` → No changes
4. **Link recovery:** Parse `WARN: Unable to resolve`, fix path, re-render
5. **Skip infrastructure:** `sample/.github/` → Preserved
