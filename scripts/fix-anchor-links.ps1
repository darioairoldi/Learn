<#
.SYNOPSIS
  Repair same-page anchor links after heading emojis were moved to end-of-line.

  Heading slugs changed from e.g.  #️-how-the-stack-fits-together
  to the clean Quarto slug         #how-the-stack-fits-together

  For every SAME-PAGE link [text](#anchor):
    * strip leading non-letter characters from the anchor
      (emoji artifacts, variation selectors, stray hyphens, leading digits)
      -> this reproduces Quarto's clean slug exactly
    * if the link text starts with emoji, move that emoji to the end

  External links (http...#...) and cross-file links (file#...) are left alone.

.PARAMETER Apply
  Without this switch the script only previews changes (dry run).
#>
[CmdletBinding()]
param(
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

$excludeDirs = @(
    'docs', '.git', '.github', '.copilot', 'node_modules', '.quarto',
    '_site', '_freeze', 'site_libs', 'src', 'scripts', 'deploy',
    'index_files', 'README_files', '99.00-temp'
)

$emojiClass = '[\p{Cs}\p{So}\uFE0F\u200D\u2190-\u21FF\u2300-\u27BF\u2B00-\u2BFF\u2122\u2139\u24C2\u3030\u303D\u3297\u3299]'
# Same-page markdown link: [text](#anchor)
$linkPattern  = [regex]"\[([^\]]*)\]\(#([^)]+)\)"
$textEmoji    = [regex]"^((?:$emojiClass)+)[ \t]+(\S.*)$"
$leadingJunk  = [regex]'^[^A-Za-z]+'

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File |
    Where-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\','/')
        $top = ($rel -split '[\\/]')[0]
        $excludeDirs -notcontains $top
    }

$totalChanges = 0
$changedFiles = 0

foreach ($file in $files) {
    $text   = [System.IO.File]::ReadAllText($file.FullName)
    $hasBom = $text.Length -gt 0 -and $text[0] -eq [char]0xFEFF
    $lines  = $text -split "\r?\n"
    $fileChanged = $false
    $inFence = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*(```|~~~)') { $inFence = -not $inFence; continue }
        if ($inFence) { continue }

        $orig = $lines[$i]
        $new = $linkPattern.Replace($orig, {
            param($m)
            $t = $m.Groups[1].Value
            $a = $m.Groups[2].Value

            $newAnchor = $leadingJunk.Replace($a, '')
            if ([string]::IsNullOrEmpty($newAnchor)) { $newAnchor = $a }

            $newText = $t
            $tm = $textEmoji.Match($t)
            if ($tm.Success) {
                $newText = "$($tm.Groups[2].Value) $($tm.Groups[1].Value.Trim())"
            }
            "[$newText](#$newAnchor)"
        })

        if ($new -ne $orig) {
            $rel = $file.FullName.Substring($root.Length).TrimStart('\','/')
            Write-Host "[$rel]:$($i+1)" -ForegroundColor Cyan
            Write-Host "  - $orig" -ForegroundColor Red
            Write-Host "  + $new" -ForegroundColor Green
            $lines[$i] = $new
            $fileChanged = $true
            $totalChanges++
        }
    }

    if ($fileChanged) {
        $changedFiles++
        if ($Apply) {
            $nl = if ($text -match "`r`n") { "`r`n" } else { "`n" }
            $out = ($lines -join $nl)
            $enc = New-Object System.Text.UTF8Encoding($hasBom)
            [System.IO.File]::WriteAllText($file.FullName, $out, $enc)
        }
    }
}

Write-Host ""
Write-Host "Links changed: $totalChanges in $changedFiles file(s)." -ForegroundColor Yellow
if (-not $Apply) { Write-Host "Dry run only. Re-run with -Apply to write changes." -ForegroundColor Yellow }
