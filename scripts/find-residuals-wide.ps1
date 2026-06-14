$pattern = '\bD(3[0-5]|[12][0-9]|[1-9])\b(?!-[a-z])'
# Whitelist of paths/patterns to skip (catalog, vision changelog, plan, legacy)
$whitelist = @(
    'src\docs\90. Issues\202606\20260601.02-dim-readable-ids',
    '06.00-idea\self-updating-prompt-engineering\20260531.01-vision.md',
    '.copilot\context\00.00-prompt-engineering\05.07-pe-meta-dimension-catalog.md',
    '.github\skills\pe-artifact-coherence-check\SKILL.md',
    'old\',
    'docs\',
    '_freeze\',
    '.quarto\'
)
# Search only PE-relevant locations
$roots = @(
    '.github\agents\00.09-pe-meta',
    '.github\prompts\00.09-pe-meta',
    '.github\templates\00.00-prompt-engineering',
    '.github\skills',
    '.copilot\context\00.00-prompt-engineering',
    '06.00-idea\self-updating-prompt-engineering',
    '03.00-tech\05.02-prompt-engineering'
)
$total = 0
foreach ($root in $roots) {
    if (-not (Test-Path $root)) { continue }
    Get-ChildItem $root -Recurse -File -Include *.md | ForEach-Object {
        $rel = $_.FullName.Replace($PWD.Path + '\', '')
        $skip = $false
        foreach ($w in $whitelist) { if ($rel -like "*$w*") { $skip = $true; break } }
        if ($skip) { return }
        $hits = Select-String -Path $_.FullName -Pattern $pattern -AllMatches | Where-Object {
            $_.Line -notmatch '<group\|D#>' -and
            $_.Line -notmatch '^\|\s*v?\d+\.\d+\.\d+\s*\|' -and
            $_.Line -notmatch '"v\d+\.\d+' -and
            $_.Line -notmatch '^>\s*\*\*Most recent' -and
            $_.Line -notmatch '<code>D'
        }
        if ($hits) {
            $c = $hits.Count
            $total += $c
            Write-Host ("  {0,4}  {1}" -f $c, $rel)
            foreach ($h in ($hits | Select-Object -First 3)) {
                Write-Host ("        L{0}: {1}" -f $h.LineNumber, $h.Line.Substring(0, [Math]::Min(120, $h.Line.Length)))
            }
        }
    }
}
Write-Host "TOTAL: $total"
