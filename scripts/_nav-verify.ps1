# Quarto navigation validator: compares project.render paths against disk.
$ErrorActionPreference = 'Stop'
$root = 'e:\dev.darioa.live\darioairoldi\Learn'
$yml  = Join-Path $root '_quarto.yml'

$lines = Get-Content $yml
# Extract project.render list: lines that are quoted paths under render: before 'website:'
$renderPaths = New-Object System.Collections.Generic.List[string]
$inRender = $false
foreach ($ln in $lines) {
    if ($ln -match '^\s*render:\s*$') { $inRender = $true; continue }
    if ($inRender) {
        if ($ln -match '^website:') { break }
        if ($ln -match '^\s*-\s*"([^"]+)"\s*$') {
            $renderPaths.Add($Matches[1])
        }
    }
}

Write-Host "=== project.render entries: $($renderPaths.Count) ==="

# Test each path
$dangling = New-Object System.Collections.Generic.List[string]
foreach ($p in $renderPaths) {
    $full = Join-Path $root ($p -replace '/','\')
    if (-not (Test-Path -LiteralPath $full)) {
        $dangling.Add($p)
    }
}

Write-Host ""
Write-Host "=== DANGLING (in render, not on disk): $($dangling.Count) ==="
$dangling | ForEach-Object { Write-Host "  $_" }
$dangling | Set-Content (Join-Path $root 'scripts\_nav-dangling.txt')

# Build actual content inventory (.md) under content roots
$contentRoots = '01.00-news','02.00-events','03.00-tech','04.00-howto','05.00-issues','06.00-idea','90.00-travel','20250815-diy-battery-pack','20250815-diy-ebike'
$actual = New-Object System.Collections.Generic.List[string]
foreach ($cr in $contentRoots) {
    $base = Join-Path $root $cr
    if (Test-Path $base) {
        Get-ChildItem -LiteralPath $base -Recurse -File -Filter *.md | ForEach-Object {
            $rel = $_.FullName.Substring($root.Length+1) -replace '\\','/'
            $actual.Add($rel)
        }
    }
}
# Root-level docs
Get-ChildItem -LiteralPath $root -File -Filter *.md | ForEach-Object {
    $actual.Add(($_.Name))
}

# Exclusions: sample dirs, node_modules, bin/obj, _files, .github, .copilot, docs, README_files
$excl = '/(bin|obj|node_modules)/|/_files/|README_files|/\.github/|/\.copilot/|/docs/'
$renderSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$renderPaths,[System.StringComparer]::OrdinalIgnoreCase)
$missing = New-Object System.Collections.Generic.List[string]
foreach ($a in $actual) {
    if ($a -match $excl) { continue }
    if (-not $renderSet.Contains($a)) { $missing.Add($a) }
}

Write-Host ""
Write-Host "=== MISSING (on disk, not in render): $($missing.Count) ==="
$missing | Sort-Object | ForEach-Object { Write-Host "  $_" }
$missing | Sort-Object | Set-Content (Join-Path $root 'scripts\_nav-missing.txt')
