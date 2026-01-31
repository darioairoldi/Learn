# Broken Link Detection and Fix Scripts

Comprehensive PowerShell scripts to detect, analyze, and fix broken internal markdown links across the repository.

## Overview

These scripts follow the workflow defined in the [learnhub-update-pages-broken-internal-links.prompt.md](../../.github/prompts/learnhub/learnhub-update-pages-broken-internal-links.prompt.md):

1. **Extract links** - Find all internal markdown links in the repository
2. **Build inventory** - Catalog all markdown files with metadata
3. **Identify broken links** - Reconcile links with actual files using intelligent matching
4. **Fix broken links** - Apply corrections automatically or with review

## Quick Start

### Run Complete Pipeline (Dry Run)
```powershell
.\run-all.ps1 -DryRun
```

### Run Complete Pipeline (Auto-Fix HIGH confidence)
```powershell
.\run-all.ps1 -AutoFix
```

### Run Complete Pipeline (Auto-Fix MEDIUM+ confidence)
```powershell
.\run-all.ps1 -AutoFix -Confidence MEDIUM
```

## Individual Scripts

### 1. Extract All Links
```powershell
.\01-extract-all-links.ps1
```

Scans all markdown files and extracts internal links (links to `.md` or `.qmd` files).

**Output:** `_output/all-links.json`

### 2. Build File Inventory
```powershell
.\02-build-file-inventory.ps1
```

Creates comprehensive inventory of all markdown files with paths, folder structure, and metadata.

**Output:** `_output/file-inventory.json`

### 3. Identify Broken Links
```powershell
.\03-identify-broken-links.ps1
```

Validates each link and attempts to reconcile broken links using intelligent matching strategies:

- **Exact match** - Direct path match
- **Filename match** - Same filename, different path
- **Numbered prefix** - Missing folder number prefixes (e.g., `tech/` → `03.00-tech/`)
- **Fuzzy folder match** - Similar folder structure with context

**Output:** `_output/broken-links-analysis.json`

### 4. Fix Broken Links
```powershell
# Preview fixes
.\04-fix-broken-links.ps1 -DryRun

# Apply HIGH confidence fixes
.\04-fix-broken-links.ps1 -AutoFix -Confidence HIGH

# Apply MEDIUM+ confidence fixes
.\04-fix-broken-links.ps1 -AutoFix -Confidence MEDIUM

# Apply ALL fixes (use with caution)
.\04-fix-broken-links.ps1 -AutoFix -Confidence ALL
```

Applies fixes to broken links based on confidence level.

## Common Issues Fixed

### Missing Numbered Folder Prefixes
- `news/` → `01.00%20news/`
- `events/` → `02.00%20events/`
- `tech/` → `03.00%20tech/`
- `issues/` → `05.00%20issues/`
- `idea/` → `06.00%20idea/`

### Incorrect File Paths
- Root-level date folders moved to subfolders
- Missing subfolder structure (e.g., `tech/Azure/` → `03.00%20tech/02.01%20Azure/`)
- Incorrect file names or extensions

### URL Encoding
- Automatically URL-encodes spaces (`%20`)
- Normalizes path separators

## Output Files

All output files are saved to `_output/` directory:

| File | Description |
|------|-------------|
| `all-links.json` | All internal links with source files and line numbers |
| `file-inventory.json` | Complete inventory of markdown files |
| `broken-links-analysis.json` | Analysis results with fix recommendations |

## Confidence Levels

| Level | Description | When to Use |
|-------|-------------|-------------|
| **HIGH** | Exact match or clear numbered prefix fix | ✅ Recommended for automatic fixes |
| **MEDIUM** | Fuzzy folder match with context | ⚠️ Review recommended |
| **ALL** | Includes uncertain matches | ❌ Manual review required |

## Example Workflow

```powershell
# 1. Analyze and preview (no changes)
.\run-all.ps1 -DryRun

# 2. Review output/_output/broken-links-analysis.json

# 3. Apply high-confidence fixes
.\run-all.ps1 -AutoFix

# 4. Review changes in git
git diff

# 5. Commit if satisfied
git add .
git commit -m "fix: correct broken internal markdown links"
```

## Integration with Prompt

These scripts implement the methodology defined in:
- [learnhub-update-pages-broken-internal-links.prompt.md](../../.github/prompts/learnhub/learnhub-update-pages-broken-internal-links.prompt.md)

They can be used standalone or invoked by AI agents following that prompt.

## Requirements

- PowerShell 7+ (Core)
- Windows, macOS, or Linux
- Git repository access

## Troubleshooting

### No broken links found
Check if files have already been fixed or if exclusion patterns are too broad.

### Fix not applied
- Ensure exact link text match in source file
- Check for special characters or encoding issues
- Review line numbers in analysis output

### Performance
For large repositories (1000+ files):
- Scripts process in batches
- JSON files cached between runs
- Re-run individual steps as needed

## Contributing

To improve matching strategies, edit `03-identify-broken-links.ps1` and add new logic to `Find-MatchingFile` function.
