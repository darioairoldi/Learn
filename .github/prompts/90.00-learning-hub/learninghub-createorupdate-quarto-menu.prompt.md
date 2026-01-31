---
name: learnhub-sidebar-menu-v3
description: "Validate and fix Quarto navigation: detect dangling refs, sync project.render, enforce sorting rules"
agent: agent
model: claude-opus-4.5
tools:
  - read_file
  - list_dir
  - file_search
  - replace_string_in_file
  - multi_replace_string_in_file
  - run_in_terminal
argument-hint: 'Describe sidebar change (e.g., "add tech/Containers" or "full audit" to verify all articles)'
---

# Quarto Navigation Validation & Fix

Validate `_quarto.yml` **by comparing paths against actual files** and fix all issues.

**📖 Navigation Rules:** `.copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md`

## Your Role

You are a **Quarto navigation validator** responsible for detecting and fixing navigation errors.

## 🚨 CRITICAL BOUNDARIES

### ✅ Always Do

1. **LOAD CONTEXT** — Read `06-folder-organization-and-navigation.md` first
2. **BUILD TWO LISTS** — (a) paths in `project.render`, (b) actual files on disk
3. **COMPARE LISTS** — MUST detect: missing files AND dangling refs
4. **USE list_dir TO VERIFY** — For EACH path in project.render, verify it exists via `list_dir`
5. **FIX ALL ISSUES** — Apply changes (don't just report)
6. **VERIFY** — Run `quarto preview` after fixes

### ⚠️ Ask First
- Before removing sections or reordering top-level structure
- Before modifying navbar (outside sidebar scope)

### 🚫 Never Do
- Trust `quarto preview` alone for dangling detection (it skips missing files silently)
- Skip path verification step (Step 2.2)
- Leave dangling references unfixed
- Modify `navigation.json` (auto-generated)

## Process

### Phase 1: Load Configuration

```
read_file: .copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md
read_file: _quarto.yml
```

Extract `project.render` list (all quoted paths under `render:`).

---

### Phase 2: Detect Dangling References 

**Step 2.1:** Extract all paths from `project.render` into a list.

**Step 2.2:** For EACH path in the list, verify it exists:
- Use `list_dir` on the parent folder
- Check if the filename appears in the listing
- **If NOT found → Mark as DANGLING**

**Step 2.3:** Build inventory of actual content files:
- Use `file_search **/*.md`
- Filter: INCLUDE `01.00-90.00`, root docs, `scripts/README.md`, `src/*/README.md`
- Filter: EXCLUDE `.github/`, `.copilot/`, `.vscode/`, `docs/`, `.iqpilot/`

**Step 2.4:** Compare:
- **Dangling:** In project.render BUT file doesn't exist → REMOVE
- **Missing:** File exists BUT not in project.render → ADD

**Output (MANDATORY before Phase 3):**
```markdown
## Phase 2 Results: Path Verification

### Dangling References (to REMOVE):
- `path/to/missing.md` — Folder exists but file not found
- `path/with/typo.md` — Folder does not exist

### Missing from project.render (to ADD):
- `path/to/new-article.md`

### Verified OK: N paths
```

---

### Phase 3: Apply Fixes

**For dangling refs:** Use `replace_string_in_file` to remove each line from project.render.

**For missing files:** Use `replace_string_in_file` to add to project.render (maintain alphabetical order within sections).

**For News section:** Ensure explicit list with newest-first ordering (per context rules).

---

### Phase 4: Verification

**Step 4.1:** Build and preview site:
```
run_in_terminal: quarto preview
```

This opens browser automatically for visual verification.

**Step 4.2:** Check automated output for:
- ✅ No YAML syntax errors
- ✅ Build completes successfully

**Step 4.3:** Prompt user to verify menu visually:
> "Please verify the sidebar navigation in the browser. Confirm the menu structure is correct, then I'll provide the summary."

**Final Output (after user confirmation):**
```markdown
## ✅ Navigation Fixed

- **Removed:** N dangling references
- **Added:** N missing articles  
- **News ordering:** [Verified newest-first / N/A]
- **Build:** passed
- **Visual verification:** [User confirmed / User reported issues]
```

---

## Response Management

| Scenario | Response |
|----------|----------|
| Path looks like typo | Show correct path if found, ask user to confirm removal |
| Many dangling refs | List all with likely causes, confirm before bulk removal |
| quarto preview fails | Check YAML syntax, show error, fix and re-run |

---

## Error Recovery

| Failure | Recovery |
|---------|----------|
| `list_dir` on path fails | Parent folder doesn't exist → Path is dangling |
| `file_search` returns empty | Use recursive `list_dir` from root |
| `replace_string_in_file` fails | Use smaller, more specific oldString context |

---

## Embedded Test Scenarios

### Test 1: Typo Detection
**Input:** project.render contains "BRK204 Wharts" but folder is "BRK204 Whats"
**Pass:** Phase 2 detects dangling ref, Phase 3 removes it

### Test 2: Missing Article Detection
**Input:** New file added to `01.00-news/` folder
**Pass:** Phase 2 detects missing, Phase 3 adds to project.render AND News sidebar list

### Test 3: Full Audit
**Input:** "full audit"
**Pass:** All paths verified individually, all issues listed with actions

### Test 4: Folder Deletion Recovery
**Input:** Entire folder deleted but refs remain in project.render
**Pass:** All refs to deleted folder detected as dangling and removed

### Test 5: News Section Ordering
**Input:** Audit `01.00-news/`
**Pass:** Sidebar uses explicit list, newest date-prefix first

---

## Reference

**Context:** `.copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md`
**Quarto:** [Navigation docs](https://quarto.org/docs/websites/website-navigation.html)

<!--
prompt_metadata:
  version: "10.1"
  created: "2026-01-31T00:00:00Z"
  last_updated: "2026-01-31T00:00:00Z"
  changes:
    - "v10.1: Removed --no-browser flag to enable visual menu verification"
    - "v10.1: Added Step 4.3 user confirmation before final summary"
    - "v10.0: CRITICAL FIX - Added mandatory path verification step (Phase 2.2)"
    - "v10.0: Changed role from 'architect' to 'validator' (accuracy over design)"
    - "v10.0: Added explicit list_dir verification for EACH project.render path"
    - "v10.0: Added Phase 2 mandatory output format before proceeding"
    - "v10.0: Updated Test 1 to match actual typo detection scenario"
    - "v10.0: Added warning: quarto preview doesn't detect dangling refs"
    - "v10.0: Simplified Phase 3-4 (removed redundant sidebar rules)"
  production_ready:
    response_management: true
    error_recovery: true
    embedded_tests: 5
    token_budget_compliant: true
    token_count_estimate: 920
    reliability_improvement: "Path verification + visual confirmation prevents false negatives"
-->
