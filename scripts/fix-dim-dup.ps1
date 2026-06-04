$names = @(
    'metadata', 'references', 'token-budget', 'tool-alignment', 'boundaries', 'consistency', 'non-redundancy', 'prioritization', 'clarity', 'completeness',
    'actionability', 'staleness', 'source-verification', 'craftsmanship', 'vision-alignment', 'adherence', 'cross-coherence', 'coverage', 'artifact-structure', 'token-chain',
    'deterministic-first', 'context-optimization', 'reference-efficiency', 'handoff-efficiency', 'processing-efficiency', 'model-routing', 'model-adherence', 'reproducibility', 'regression-protection', 'metadata-guard',
    'multipass-validation-invariant', 'rollback-readiness', 'boundary-actionability', 'autonomy-calibration', 'portability-boundary'
)
$files = @()
$files += Get-ChildItem '06.00-idea\self-updating-prompt-engineering\20260503.02-vision-pe-meta-usecases' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\agents\00.09-pe-meta' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\templates\00.00-prompt-engineering' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\prompts\00.09-pe-meta' -Recurse -File -Include *.md
$files += Get-ChildItem '06.00-idea\self-updating-prompt-engineering\20260521.01-pe-meta-implementation' -Recurse -File -Include *.md
$totalFiles = 0
$totalReplacements = 0
foreach ($f in $files) {
    $orig = Get-Content -Raw -Path $f.FullName
    $new = $orig
    $fileReplacements = 0
    foreach ($n in $names) {
        $pat = '(`D\d+-' + [regex]::Escape($n) + '`)\s+' + [regex]::Escape($n) + '\b'
        $matches = [regex]::Matches($new, $pat)
        if ($matches.Count -gt 0) {
            $fileReplacements += $matches.Count
            $new = [regex]::Replace($new, $pat, '$1')
        }
    }
    if ($fileReplacements -gt 0) {
        [System.IO.File]::WriteAllText($f.FullName, $new, (New-Object System.Text.UTF8Encoding $false))
        $totalFiles++
        $totalReplacements += $fileReplacements
        Write-Host ("  fixed {0,3} in {1}" -f $fileReplacements, $f.FullName.Replace($PWD.Path + '\', ''))
    }
}
Write-Host "Files changed: $totalFiles; Replacements: $totalReplacements"
