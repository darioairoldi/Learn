<#
  Kebab-case enforcement for selected categories (C images, D source .md, E content dirs, F misc).
  Excludes: .NET sample code, bin/obj, generated .html, *_files asset folders.
  Default is dry-run; pass -Execute to actually rename + update references.
#>
[CmdletBinding()]
param(
    [switch]$Execute
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $repo

function ConvertTo-Kebab {
    param([string]$Name, [bool]$IsDir)
    if ($IsDir) { $base = $Name; $ext = '' }
    else {
        $ext = [System.IO.Path]::GetExtension($Name)
        $base = $Name.Substring(0, $Name.Length - $ext.Length)
    }
    $base = $base -replace '&', 'and'
    $base = $base.ToLower()
    $base = $base -replace '_', '-'
    $base = $base -replace '\s+', '-'
    $base = $base -replace '-{2,}', '-'
    $base = $base.Trim('-', ' ')
    return $base + $ext.ToLower()
}

$flt = { $_.Name -match '\s' -or $_.Name -cmatch '[A-Z]' -or $_.Name -match '_' }

# Exclusions: code projects, build outputs, generated html, generated asset folders, special dirs
$excludePath = '\\(bin|obj)\\|\\sample\\|Qwen25-Aspire-Sample|Qwen25-FoundryLocal-Sample|_files(\\|$)'
$excludeSpecialDir = '^(bin|obj|images|\.vs|node_modules)$'

$roots = "01.00-news", "02.00-events", "03.00-tech", "04.00-howto", "05.00-issues", "06.00-idea", "90.00-travel"

$items = Get-ChildItem -Path $roots -Recurse | Where-Object {
    (& $flt) -and
    $_.Name -notmatch $excludeSpecialDir -and
    ($_.FullName -notmatch $excludePath) -and
    -not ($_.Extension -eq '.html') -and
    -not ($_.Name -eq 'README_files')
}

# Build rename list, deepest first
$renames = foreach ($it in $items) {
    $newName = ConvertTo-Kebab -Name $it.Name -IsDir $it.PSIsContainer
    if ($newName -ceq $it.Name) { continue }
    [pscustomobject]@{
        Item    = $it
        OldName = $it.Name
        NewName = $newName
        Depth   = ($it.FullName.Split('\').Count)
        IsDir   = [bool]$it.PSIsContainer
        Rel     = ($it.FullName.Substring($repo.Length + 1))
    }
}
$renames = $renames | Sort-Object Depth -Descending

Write-Host "=== RENAME MAP ($($renames.Count) items) ===" -ForegroundColor Cyan
foreach ($r in $renames) {
    $tag = if ($r.IsDir) { 'DIR ' } else { 'FILE' }
    Write-Host ("  [{0}] {1}" -f $tag, $r.Rel)
    Write-Host ("         -> {0}" -f $r.NewName)
}

# Collision detection within same parent
$collisions = $renames | Group-Object { (Split-Path $_.Item.FullName -Parent) + '|' + $_.NewName } |
    Where-Object { $_.Count -gt 1 }
if ($collisions) {
    Write-Host "`n=== COLLISIONS (same target in same folder) ===" -ForegroundColor Red
    foreach ($c in $collisions) { $c.Group | ForEach-Object { Write-Host "  $($_.Rel) -> $($_.NewName)" } }
}

if (-not $Execute) {
    Write-Host "`nDRY RUN. Re-run with -Execute to apply." -ForegroundColor Yellow
    return
}

# ---- EXECUTE ----
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Rename deepest-first; two-step for case-only changes
foreach ($r in $renames) {
    $parent = Split-Path $r.Item.FullName -Parent
    $target = Join-Path $parent $r.NewName
    if ($r.OldName -ieq $r.NewName -and $r.OldName -cne $r.NewName) {
        $tmp = Join-Path $parent ($r.NewName + '.kebabtmp')
        Rename-Item -LiteralPath $r.Item.FullName -NewName ($r.NewName + '.kebabtmp') -Force
        Rename-Item -LiteralPath $tmp -NewName $r.NewName -Force
    }
    else {
        if (Test-Path -LiteralPath $target) { Write-Host "  SKIP (target exists): $($r.Rel)" -ForegroundColor Red; continue }
        Rename-Item -LiteralPath $r.Item.FullName -NewName $r.NewName -Force
    }
}
Write-Host "Renamed $($renames.Count) items." -ForegroundColor Green

# ---- UPDATE REFERENCES ----
$textFiles = Get-ChildItem -Path $repo -Recurse -Include '*.md', '*.qmd', '*.yml', '*.yaml', '*.tex' |
    Where-Object { $_.FullName -notmatch '\\(bin|obj|node_modules|\.git)\\' }

# Separate file vs dir leaf maps (dirs must be followed by a path separator to qualify as a path segment)
$fileLeaf = @{}
$dirLeaf = @{}
foreach ($r in $renames) {
    if ($r.IsDir) { if (-not $dirLeaf.ContainsKey($r.OldName)) { $dirLeaf[$r.OldName] = $r.NewName } }
    else { if (-not $fileLeaf.ContainsKey($r.OldName)) { $fileLeaf[$r.OldName] = $r.NewName } }
}

$refUpdates = 0
foreach ($f in $textFiles) {
    $text = [System.IO.File]::ReadAllText($f.FullName)
    $orig = $text
    # Files: bounded on the left by a path/link/quote delimiter
    foreach ($old in $fileLeaf.Keys) {
        $new = $fileLeaf[$old]
        $variants = @($old)
        if ($old.Contains(' ')) { $variants += $old.Replace(' ', '%20') }
        foreach ($v in $variants) {
            $pattern = '(?<=[/\\("' + "'" + '])' + [regex]::Escape($v)
            $text = [regex]::Replace($text, $pattern, { param($m) $new })
        }
    }
    # Dirs: must be a path segment (left delimiter AND trailing separator) to avoid matching titles
    foreach ($old in $dirLeaf.Keys) {
        $new = $dirLeaf[$old]
        $variants = @($old)
        if ($old.Contains(' ')) { $variants += $old.Replace(' ', '%20') }
        foreach ($v in $variants) {
            $pattern = '(?<=[/\\("' + "'" + '])' + [regex]::Escape($v) + '(?=[/\\])'
            $text = [regex]::Replace($text, $pattern, { param($m) $new })
        }
    }
    if ($text -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
        $refUpdates++
    }
}
Write-Host "Updated references in $refUpdates file(s)." -ForegroundColor Green
