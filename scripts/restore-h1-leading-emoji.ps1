<#
.SYNOPSIS
  Move a trailing emoji on level-1 (H1) Markdown headings back to the front.

  Turns:   # How the stack fits together 🏗️
  Into:     # 🏗️ How the stack fits together

  Rationale: the docked sidebar and the top-of-page title derive from the H1
  (frontmatter `title:` else first H1), so a LEADING emoji on H1 surfaces in the
  sidebar. H2-H6 are intentionally left with TRAILING emojis.

.PARAMETER Apply
  Without this switch the script only previews changes (dry run).
#>
[CmdletBinding()]
param(
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this script's folder
$root = Split-Path -Parent $PSScriptRoot

# Folders to skip (generated output, tooling, PE artifacts, deps)
$excludeDirs = @(
    'docs', '.git', '.github', '.copilot', 'node_modules', '.quarto',
    '_site', '_freeze', 'site_libs', 'src', 'scripts', 'deploy',
    'index_files', 'README_files', '99.00-temp'
)

# Trailing-emoji H1 matcher (exactly one leading '#').
# Group 1: "# " (single hash + spaces)
# Group 2: the heading text (non-greedy)
# Group 3: one-or-more trailing emoji code units
$emojiClass = '[\p{Cs}\p{So}\uFE0F\u200D\u2190-\u21FF\u2300-\u27BF\u2B00-\u2BFF\u2122\u2139\u24C2\u3030\u303D\u3297\u3299]'
$pattern = [regex]"^(#[ \t]+)(\S.*?)[ \t]+((?:$emojiClass)+)[ \t]*$"

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File |
    Where-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\','/')
        $top = ($rel -split '[\\/]')[0]
        $excludeDirs -notcontains $top
    }

$totalChanges = 0
$changedFiles = 0

foreach ($file in $files) {
    $text = [System.IO.File]::ReadAllText($file.FullName)
    $hasBom = $text.Length -gt 0 -and $text[0] -eq [char]0xFEFF

    $lines = $text -split "\r?\n"
    $fileChanged = $false
    $inFence = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        # Track fenced code blocks (``` or ~~~) and skip headings inside them
        if ($lines[$i] -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
            continue
        }
        if ($inFence) { continue }

        $m = $pattern.Match($lines[$i])
        if ($m.Success) {
            $hashes = $m.Groups[1].Value
            $title  = $m.Groups[2].Value
            $emoji  = $m.Groups[3].Value.Trim()
            $new = "$hashes$emoji $title"
            if ($new -ne $lines[$i]) {
                $rel = $file.FullName.Substring($root.Length).TrimStart('\','/')
                Write-Host "[$rel]" -ForegroundColor Cyan
                Write-Host "  - $($lines[$i])" -ForegroundColor Red
                Write-Host "  + $new" -ForegroundColor Green
                $lines[$i] = $new
                $fileChanged = $true
                $totalChanges++
            }
        }
    }

    if ($fileChanged) {
        $changedFiles++
        if ($Apply) {
            # Preserve original newline style (LF vs CRLF) and BOM state
            $nl = if ($text -match "`r`n") { "`r`n" } else { "`n" }
            $out = ($lines -join $nl)
            $enc = New-Object System.Text.UTF8Encoding($hasBom)
            [System.IO.File]::WriteAllText($file.FullName, $out, $enc)
        }
    }
}

Write-Host ""
Write-Host "H1 headings changed: $totalChanges in $changedFiles file(s)." -ForegroundColor Yellow
if (-not $Apply) {
    Write-Host "Dry run only. Re-run with -Apply to write changes." -ForegroundColor Yellow
}
