<#
.SYNOPSIS
  Move leading emoji(s) on Markdown headings to the end of the heading line.

  Turns:   ## 🏗️ How the stack fits together
  Into:    ## How the stack fits together 🏗️

  This improves left-edge alignment of the auto-generated "On this page" TOC
  and the docked sidebar, which derive their entries from heading text.

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

# Leading-emoji heading matcher.
# Group 1: "## " (hashes + spaces)
# Group 2: one-or-more emoji code units (symbols, surrogates, variation
#          selectors, ZWJ, skin-tone modifiers, common pictographic ranges)
# Group 3: the heading text
$emojiClass = '[\p{Cs}\p{So}\uFE0F\u200D\u2190-\u21FF\u2300-\u27BF\u2B00-\u2BFF\u2122\u2139\u24C2\u3030\u303D\u3297\u3299]'
$pattern = [regex]"^(#{1,6}[ \t]+)((?:$emojiClass)+)[ \t]+(\S.*?)[ \t]*$"

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
            $emoji  = $m.Groups[2].Value.Trim()
            $title  = $m.Groups[3].Value
            $new = "$hashes$title $emoji"
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
