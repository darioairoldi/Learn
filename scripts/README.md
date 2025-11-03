# 📜 PowerShell Scripts Reference

Utility scripts for maintaining and validating the Quarto-based learning repository.

## Table of Contents

- [📋 Overview](#-overview)
- [🔍 Additional Details](#-additional-details)
  - [check-links.ps1](#check-linksps1)
  - [check-links-enhanced.ps1](#check-links-enhancedps1)
  - [find-correct-paths.ps1](#find-correct-pathsps1)
  - [generate-navigation.ps1](#generate-navigationps1)
- [⚙️ Configuration](#️-configuration)
  - [Workspace Root Configuration](#workspace-root-configuration)
  - [File Patterns and Matching](#file-patterns-and-matching)
  - [External Dependencies](#external-dependencies)
- [🔧 Troubleshooting](#-troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Mode](#debug-mode)
  - [Path Resolution Problems](#path-resolution-problems)
- [📚 Reference](#-reference)

---

## 📋 Overview

This folder contains PowerShell automation scripts designed to maintain the integrity and structure of a Quarto documentation website. Each script serves a specific purpose in the validation and build pipeline.

### Script Files

| Script | Description |
|--------|-------------|
| **check-links.ps1** | Basic link validator that checks all file references in `_quarto.yml` and `index.qmd` for broken links. Exports broken links to CSV for review. |
| **check-links-enhanced.ps1** | Enhanced version with URL decoding support, handles special characters and C# in filenames, provides detailed diagnostics with color-coded output. |
| **find-correct-paths.ps1** | Diagnostic tool that analyzes broken links and searches the workspace for correct file paths, generates correction suggestions in CSV format. |
| **generate-navigation.ps1** | Build automation script that generates `navigation.json` from `_quarto.yml`, includes timestamp checking to avoid unnecessary regeneration, downloads `yq` tool if needed. |

---

## 🔍 Additional Details

### check-links.ps1

**Purpose**: Basic link validation for Quarto configuration files.

**Implementation Details**:
- Parses `_quarto.yml` using regex pattern `href:\s*"([^"]+)"`
- Extracts markdown links from `index.qmd` using pattern `\[([^\]]+)\]\(([^)]+)\)`
- Validates file existence for each extracted path
- Handles URL encoding by replacing `%20` with spaces
- Filters out external URLs (http/https) and anchor-only links

**Example Usage**:
```powershell
# Run from repository root
.\scripts\check-links.ps1

# Output example:
# === Checking _quarto.yml ===
# BROKEN: events/202506 Build 2025/DEM515 Write better C# code/README.md
# 
# === Summary ===
# Valid links: 145
# Broken links: 3
```

**Key Features**:
- Exports broken links to `broken-links.csv` for further analysis
- Color-coded console output (Red for broken, Green for valid)
- Automatic path normalization
- Separates validation by source file (_quarto.yml vs index.qmd)

---

### check-links-enhanced.ps1

**Purpose**: Advanced link validation with comprehensive URL decoding and special character support.

**Implementation Details**:
- Uses `[System.Uri]::UnescapeDataString()` for proper URL decoding
- Intelligently handles anchor removal (preserves C# in filenames)
- Anchor removal pattern: `\.md#` or `\.qmd#` ensures only valid anchors are stripped
- Provides multi-level diagnostic output with decoded paths and full system paths

**Example Usage**:
```powershell
.\scripts\check-links-enhanced.ps1

# Detailed output:
# BROKEN in _quarto.yml : 20251005%20Feeds/04.%20C%23%20Reference.md
#   Decoded: 20251005 Feeds/04. C# Reference.md
#   Full path: e:\dev.darioa.live\darioairoldi\Learn\20251005 Feeds/04. C# Reference.md
```

**Advanced Features**:
- **URL Decoding**: Handles `%20`, `%23` (C#), and other encoded characters
- **Smart Anchor Handling**: Only removes anchors after file extensions, preserving special characters in filenames
- **Diagnostic Levels**: Shows original path, decoded path, and resolved full system path
- **External URL Filtering**: Skips http/https URLs and anchor-only links

**Decode-UrlPath Function**:
```powershell
function Decode-UrlPath {
    param($path)
    $decoded = [System.Uri]::UnescapeDataString($path)
    return $decoded
}
```

**Test-FilePath Function**:
- Decodes URL encoding
- Preserves C# and other special characters
- Removes only valid section anchors
- Reports detailed diagnostics on failure

---

### find-correct-paths.ps1

**Purpose**: Diagnostic tool to locate correct paths for broken links and generate correction suggestions.

**Implementation Details**:
- Maintains hardcoded list of known broken links from validation runs
- Extracts filename or directory name from broken path
- Performs recursive file system search with wildcards
- Generates correction mappings in CSV format

**Example Usage**:
```powershell
.\scripts\find-correct-paths.ps1

# Output:
# Searching for correct paths...
# 
# Broken: 20250713 Use http files/01. Using HTTP Files (VSCode).md
# Searching for: **\01. Using HTTP Files (VSCode).md
# Found:
#   -> _ISSUES/20250713 Use http files/01. Using HTTP Files (VSCode).md
```

**Search Strategy**:
1. Parse broken link to extract last path component
2. Determine if it's a file (has extension) or directory
3. Build appropriate wildcard search pattern
4. Recursively search workspace with `Get-ChildItem`
5. Return up to 3 matching candidates
6. Export corrections to `link-corrections.csv`

**Output Format** (CSV):
```csv
Broken,Correct
"events/202506 Build 2025/README.md","_ISSUES/202506 Build 2025/README.md"
"20250713 Use http files/01. File.md","_ISSUES/20250713 Use http files/01. File.md"
```

---

### generate-navigation.ps1

**Purpose**: Automated generation of `navigation.json` from Quarto configuration for optimized client-side navigation.

**Implementation Details**:
- Checks file timestamps to avoid unnecessary regeneration
- Downloads `yq` tool automatically if not present (v4.40.5 from GitHub releases)
- Extracts sidebar structure using `yq` YAML parser
- Validates generated JSON by parsing it back
- Synchronizes file modification timestamps

**Example Usage**:
```powershell
.\scripts\generate-navigation.ps1

# Output when up-to-date:
# Checking navigation.json status...
# navigation.json is up to date - skipping generation
# ✓ navigation.json is current, no action needed

# Output when regenerating:
# navigation.json is older than _quarto.yml - will regenerate
# Generating navigation.json...
# Extracting navigation structure from _quarto.yml...
# ✓ navigation.json generated successfully with 8 sections
# ✓ Contents structure: Direct Array ✓
```

**Build Process**:
1. **Timestamp Check**: Compare `_quarto.yml` and `navigation.json` modification times
2. **Dependency Check**: Verify `yq` is available, download if needed
3. **Extraction**: Use `yq eval '.website.sidebar.contents' _quarto.yml --output-format=json`
4. **Wrapping**: Wrap JSON in `{"contents": [...]}` structure
5. **Validation**: Parse generated JSON to ensure validity
6. **Timestamp Sync**: Set `navigation.json` timestamp to match source file

**YQ Tool Management**:
```powershell
$yqVersion = "v4.40.5"
$yqUrl = "https://github.com/mikefarah/yq/releases/download/$yqVersion/yq_windows_amd64.exe"
Invoke-WebRequest -Uri $yqUrl -OutFile "yq.exe" -UseBasicParsing
```

**Generated Structure**:
```json
{
  "contents": [
    {"section": "Events", "contents": [...]},
    {"section": "Projects", "contents": [...]}
  ]
}
```

---

## ⚙️ Configuration

### Workspace Root Configuration

All scripts rely on a hardcoded workspace root path that must be updated if the repository is cloned to a different location.

**Default Configuration**:
```powershell
$workspaceRoot = "e:\dev.darioa.live\darioairoldi\Learn"
```

**To Update**:
Edit each script and modify the `$workspaceRoot` variable to match your local repository path.

**Affected Scripts**:
- `check-links.ps1`
- `check-links-enhanced.ps1`
- `find-correct-paths.ps1`

**Note**: `generate-navigation.ps1` uses relative paths and doesn't require workspace root configuration.

---

### File Patterns and Matching

**Link Extraction Patterns**:

1. **YAML href Pattern** (used in _quarto.yml):
   ```powershell
   $hrefPattern = 'href:\s*"([^"]+)"'
   ```

2. **Markdown Link Pattern** (used in index.qmd):
   ```powershell
   $markdownLinkPattern = '\[([^\]]+)\]\(([^)]+)\)'
   ```

**Anchor Removal Patterns**:

- **Basic** (`check-links.ps1`):
  ```powershell
  $cleanPath = $cleanPath -replace '#.*$', ''
  ```

- **Enhanced** (`check-links-enhanced.ps1`):
  ```powershell
  if ($cleanPath -match '\.md#' -or $cleanPath -match '\.qmd#') {
      $cleanPath = $cleanPath -replace '#.*$', ''
  }
  ```

---

### External Dependencies

**yq (YAML Processor)**:
- **Version**: v4.40.5
- **Platform**: Windows AMD64
- **Source**: https://github.com/mikefarah/yq/releases
- **Auto-download**: Yes (by `generate-navigation.ps1`)
- **Installation Path**: `.\yq.exe` (current directory)

**PowerShell Version**:
- Minimum: PowerShell 5.1 (Windows PowerShell)
- Recommended: PowerShell 7+ (PowerShell Core)

**Required Modules**:
- None (uses built-in cmdlets only)

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "Access Denied" or Permission Errors

**Symptom**: Scripts fail to download `yq` or write output files.

**Solution**:
```powershell
# Run PowerShell as Administrator
# Or adjust execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 2. Incorrect Workspace Root

**Symptom**: All files reported as broken even though they exist.

**Diagnosis**:
```powershell
# Check current workspace root setting
Select-String -Path .\scripts\check-links.ps1 -Pattern 'workspaceRoot'
```

**Solution**: Update `$workspaceRoot` variable in affected scripts to match your repository location.

#### 3. URL Decoding Issues with Special Characters

**Symptom**: Files with `#`, `%`, or spaces in names incorrectly flagged as broken.

**Solution**: Use `check-links-enhanced.ps1` instead of `check-links.ps1`. The enhanced version properly handles URL-encoded paths.

#### 4. navigation.json Not Regenerating

**Symptom**: Changes to `_quarto.yml` not reflected in `navigation.json`.

**Diagnosis**:
```powershell
# Check file timestamps
Get-Item _quarto.yml, navigation.json | Format-Table Name, LastWriteTime
```

**Solution**:
```powershell
# Force regeneration by deleting navigation.json
Remove-Item navigation.json
.\scripts\generate-navigation.ps1
```

#### 5. yq Download Failures

**Symptom**: `generate-navigation.ps1` fails with web request errors.

**Solution**:
```powershell
# Manually download yq
$yqUrl = "https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_windows_amd64.exe"
Invoke-WebRequest -Uri $yqUrl -OutFile "yq.exe" -UseBasicParsing

# Verify download
.\yq.exe --version
```

---

### Debug Mode

Enable detailed output by adding `-Verbose` or modifying scripts:

```powershell
# Add at the beginning of any script
$VerbosePreference = "Continue"

# Or run with verbose flag
.\scripts\check-links.ps1 -Verbose
```

**Custom Debug Output**:
```powershell
# Add debug statements
Write-Host "DEBUG: Processing file: $filePath" -ForegroundColor Magenta
Write-Host "DEBUG: Cleaned path: $cleanPath" -ForegroundColor Magenta
```

---

### Path Resolution Problems

**Issue**: Links with special characters or encodings not resolving correctly.

**Debugging Steps**:

1. **Check Raw Path**:
   ```powershell
   $rawPath = "20251005%20Feeds/04.%20C%23%20Reference.md"
   Write-Host "Raw: $rawPath"
   ```

2. **Test URL Decoding**:
   ```powershell
   $decoded = [System.Uri]::UnescapeDataString($rawPath)
   Write-Host "Decoded: $decoded"
   ```

3. **Verify File Existence**:
   ```powershell
   $fullPath = Join-Path $workspaceRoot $decoded
   Test-Path $fullPath
   Get-Item $fullPath -ErrorAction SilentlyContinue
   ```

4. **Check for Case Sensitivity Issues**:
   ```powershell
   # Windows is case-insensitive but Git is case-sensitive
   Get-ChildItem -Path (Split-Path $fullPath) | Where-Object { $_.Name -ieq (Split-Path $fullPath -Leaf) }
   ```

---

## 📚 Reference

### PowerShell Documentation

- **[PowerShell Regular Expressions](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions)**  
  Essential for understanding the regex patterns used in link extraction. This documentation covers the `[regex]::Matches()` method and pattern syntax used throughout the validation scripts.

- **[PowerShell File System Operations](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/)**  
  Reference for `Test-Path`, `Get-Item`, `Get-Content`, and `Get-ChildItem` cmdlets used extensively in these scripts for file validation and searching.

- **[System.Uri Class (.NET)](https://learn.microsoft.com/en-us/dotnet/api/system.uri)**  
  Documentation for the `UnescapeDataString()` method used in `check-links-enhanced.ps1` to properly decode URL-encoded paths, crucial for handling special characters like `%20` and `%23`.

### Quarto Documentation

- **[Quarto Website Navigation](https://quarto.org/docs/websites/website-navigation.html)**  
  Explains the structure of `_quarto.yml` and the `sidebar.contents` configuration that `generate-navigation.ps1` extracts. Understanding this structure is essential for maintaining the navigation generation logic.

- **[Quarto YAML Configuration](https://quarto.org/docs/reference/formats/html.html)**  
  Complete reference for Quarto configuration options, including the `href` attribute pattern matched by the link validation scripts.

### YAML Tools

- **[yq - YAML Processor](https://github.com/mikefarah/yq)**  
  The YAML processing tool used by `generate-navigation.ps1`. This reference includes command syntax, installation options, and usage examples for extracting and manipulating YAML data.

- **[yq Releases](https://github.com/mikefarah/yq/releases)**  
  Download page for yq binaries. The scripts reference version v4.40.5 specifically for compatibility and stability.

### URL Encoding Standards

- **[RFC 3986 - URI Generic Syntax](https://datatracker.ietf.org/doc/html/rfc3986)**  
  Official specification for URL encoding. Relevant for understanding why characters like spaces and `#` need to be encoded/decoded in file paths used as URLs.

- **[Percent-Encoding (Wikipedia)](https://en.wikipedia.org/wiki/Percent-encoding)**  
  Comprehensive explanation of URL encoding schemes, including the `%20` (space) and `%23` (#) encodings handled by the enhanced link checker.

### CSV Export and Data Processing

- **[Export-Csv Cmdlet](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv)**  
  Documentation for the CSV export functionality used to generate `broken-links.csv` and `link-corrections.csv` for further analysis in Excel or other tools.

### Git and Version Control

- **[Git Timestamp Handling](https://git-scm.com/docs/git-commit)**  
  Relevant for understanding why `generate-navigation.ps1` synchronizes file modification times - Git tracks these timestamps and synchronizing them prevents unnecessary commits.
