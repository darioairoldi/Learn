<#
.SYNOPSIS
  Move trailing emoji(s) on Markdown headings to the leading position.

  Turns:   ## How the stack fits together 🏗️
  Into:    ## 🏗️ How the stack fits together

  Leading emojis form a clean vertical icon rail in the auto-generated
  "On this page" TOC and the docked sidebar (which derive their entries from
  heading text), and they stay attached to the text when a line wraps.

  Rules:
    - Applies to H1-H6. Only relocates emojis that already exist on a heading;
      it never adds or removes emojis.
    - Skips lines inside fenced code blocks (``` or ~~~).

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

# Folders to skip (generated output, tooling, PE artifacts, deps).
# Note: src/docs IS in scope; the rest of src (tooling code) is excluded below.
$excludeDirs = @(
    'docs', '.git', '.github', '.copilot', '.iqpilot', '.vscode',
    'node_modules', '.quarto', '_site', '_freeze', 'site_libs',
    'scripts', 'deploy', 'index_files', 'README_files', '99.00-temp'
)

# Trailing-emoji heading matcher.
# Group 1: "## " (hashes + spaces)
# Group 2: the heading text
# Group 3: one-or-more trailing emoji code units (symbols, surrogates, variation
#          selectors, ZWJ, skin-tone modifiers, common pictographic ranges)
$emojiClass = '[\p{Cs}\uFE0F\u200D\u20E3\u2190-\u21FF\u2300-\u27BF\u2900-\u297F\u2B00-\u2BFF\u2600-\u26FF\u2122\u2139\u24C2\u3030\u303D\u3297\u3299]'
$pattern = [regex]"^(#{1,6}[ \t]+)(\S.*?)[ \t]+((?:$emojiClass)+)[ \t]*$"

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File |
    Where-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\','/')
        $segments = $rel -split '[\\/]'
        $top = $segments[0]
        if ($excludeDirs -contains $top) { return $false }
        # Exclude src/* tooling code, but keep src/docs articles in scope.
        if ($top -eq 'src' -and $segments.Count -gt 1 -and $segments[1] -ne 'docs') { return $false }
        return $true
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
            $title  = $m.Groups[2].Value.TrimEnd()
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
Write-Host "Headings changed: $totalChanges in $changedFiles file(s)." -ForegroundColor Yellow
if (-not $Apply) {
    Write-Host "Dry run only. Re-run with -Apply to write changes." -ForegroundColor Yellow
}
