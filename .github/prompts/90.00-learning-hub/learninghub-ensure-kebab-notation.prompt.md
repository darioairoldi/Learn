---
name: learninghub-ensure-kebab-notation
description: "Enforce full kebab-case naming repo-wide with quarto render validation loop"
agent: agent
model: claude-opus-4.6
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

Enforce **100% kebab-case** for ALL content folders/files, update `_quarto.yml` and all references, and iteratively fix broken links via `quarto render`.

## Your Role

You are a **naming convention enforcer** responsible for ensuring ALL folders and files use lowercase kebab-case with NO spaces. You MUST scan systematically, rename deepest-first to avoid path breaks, and validate with `quarto render` until clean.

## 🚨 CRITICAL BOUNDARIES

### ✅ Always Do (Mandatory)

1. **CONVERT TO FULL KEBAB-CASE** — Apply these transformations:
   - Space → hyphen: `01.00 news/` → `01.00-news/`
   - Uppercase → lowercase: `BRK Sessions/` → `brk-sessions/`
   - Multiple spaces → single hyphen: `Topic  Name/` → `topic-name/`
   - PascalCase → kebab: `PromptEngineering/` → `prompt-engineering/`
   - Underscore → hyphen: `snake_case/` → `snake-case/`

2. **SCAN ALL APPLICABLE FOLDERS RECURSIVELY**:
   - Content folders: `01.00-news/`, `02.00-events/`, `03.00-tech/`, `04.00-howto/`, `05.00-issues/`, `06.00-idea/`, `90.00-travel/`, root dated folders (`20250815-diy-*/`)
   - Infrastructure folders: `.github/prompts/`, `.github/templates/`, `.github/skills/`, `.copilot/context/`

3. **RENAME DEEPEST FIRST** — Avoid breaking parent paths during rename

4. **UPDATE ALL REFERENCES** — Fix paths in `_quarto.yml`, instruction files, prompt files, and markdown files referencing renamed paths

5. **RUN quarto render VALIDATION LOOP** — Parse warnings, fix broken links, repeat until clean

### ⚠️ Ask First

- Before renaming >30 items (show list, get confirmation)
- If folder contains code projects (e.g., `sample/ModernWebApi/`)
- Before modifying files outside the workspace root

### 🚫 Never Do

- **NEVER** rename ROOT-LEVEL infrastructure folders: `.github/`, `.copilot/`, `.vscode/`, `docs/`, `src/`, `scripts/`
- **NEVER** rename these special folders anywhere: `images/`, `bin/`, `obj/`, `node_modules/`
- **NEVER** preserve spaces anywhere in folder or file names
- **NEVER** modify markdown file **content** (only rename files and update path references)

## Process

### Phase 1: Scan Violations

```powershell
# Content folders
Get-ChildItem -Path "01.00-news", "02.00-events", "03.00-tech", "04.00-howto", "05.00-issues", "06.00-idea", "90.00-travel" -Recurse |
Where-Object { $_.Name -match '\s|[A-Z]|_' -and $_.Name -notmatch '^(bin|obj|images|\.vs|node_modules)$' } |
Sort-Object { $_.FullName.Split('\').Count } -Descending |
Select-Object FullName

# Infrastructure subfolders (prompts, context, etc.)
Get-ChildItem -Path ".github/prompts", ".github/templates", ".github/skills", ".copilot/context" -Recurse -Directory |
Where-Object { $_.Name -match '\s|[A-Z]' } |
Sort-Object { $_.FullName.Split('\').Count } -Descending |
Select-Object FullName
```

**Output required:** List violations with proposed new names. If >30, ask to proceed.

### Phase 2: Rename (Deepest First)

Execute renames using `Rename-Item`. Process deepest paths first to avoid breaking parent paths.

### Phase 3: Update References

1. **Search for old paths:** Use `grep_search` to find all files referencing old folder names
2. **Update paths:** Use `multi_replace_string_in_file` to batch update references
3. **Priority files:** `_quarto.yml`, `.github/instructions/*.md`, `.github/prompts/**/*.md`, `.copilot/context/**/*.md`

### Phase 4: Quarto Render Validation Loop

```powershell
$output = quarto render 2>&1
$warnings = $output | Select-String "WARN.*Unable to resolve|ERROR"
```

**For each broken link:** Identify correct path → Update source file → Re-run render.

**Repeat until:** No warnings remain.

### Phase 5: Summary

Report: folders renamed, files renamed, reference updates, link fixes, final render status.

## Response Management

| Scenario | Action |
|----------|--------|
| **Rename fails** | Report file in use, wait 2 seconds, retry once |
| **Target exists** | Report conflict, ask user for resolution |
| **Broken link in render** | Auto-fix if path is clear, else ask user |
| **>30 items** | Present full list, get explicit confirmation |
| **Reference not found** | Log warning, continue with other references |
| **Unknown folder type** | Ask user if folder should be renamed |

## Error Recovery

| Tool Failure | Recovery Action |
|--------------|-----------------|
| `run_in_terminal` fails | Check path exists, retry with escaped paths |
| `grep_search` returns no results | Verify folder names, try broader pattern |
| `replace_string_in_file` fails | Read file to verify content, retry with exact match |
| `quarto render` hangs | Kill process after 5 min, report partial results |

## Test Scenarios

1. **Content folder with space:** `01.00-news/20251224 vscode Release/` → `01.00-news/20251224-vscode-release/`
2. **Infrastructure subfolder:** `.github/prompts/00.00-prompt-engineering/` → `.github/prompts/00.00-prompt-engineering/`
3. **Nested uppercase:** `02.00-events/202506-build-2025/BRK - Sessions/` → `02.00-events/202506-build-2025/brk-sessions/`
4. **Already valid:** `05.02-prompt-engineering/` → No changes
5. **Reference update:** Update `applyTo` in instruction files after rename
6. **Quarto link recovery:** Parse `WARN: Unable to resolve`, fix path, re-render
7. **Skip root infrastructure:** `.github/` folder itself → NOT renamed (only subfolders)
