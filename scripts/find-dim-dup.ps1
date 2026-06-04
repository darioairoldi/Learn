$names = @(
    'metadata', 'references', 'token-budget', 'tool-alignment', 'boundaries', 'consistency', 'non-redundancy', 'prioritization', 'clarity', 'completeness',
    'actionability', 'staleness', 'source-verification', 'craftsmanship', 'vision-alignment', 'adherence', 'cross-coherence', 'coverage', 'artifact-structure', 'token-chain',
    'deterministic-first', 'context-optimization', 'reference-efficiency', 'handoff-efficiency', 'processing-efficiency', 'model-routing', 'model-adherence', 'reproducibility', 'regression-protection', 'metadata-guard',
    'multipass-validation-invariant', 'rollback-readiness', 'boundary-actionability', 'autonomy-calibration', 'portability-boundary'
)
$total = 0
$files = @()
$files += Get-ChildItem '06.00-idea\self-updating-prompt-engineering\20260503.02-vision-pe-meta-usecases' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\agents\00.09-pe-meta' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\templates\00.00-prompt-engineering' -Recurse -File -Include *.md
$files += Get-ChildItem '.github\prompts\00.09-pe-meta' -Recurse -File -Include *.md
foreach ($f in $files) {
    $hit = 0
    $lines = @()
    foreach ($n in $names) {
        $pat = '`D\d+-' + $n + '`\s+' + $n + '\b'
        $matches = Select-String -Path $f.FullName -Pattern $pat -AllMatches
        foreach ($m in $matches) {
            $hit += $m.Matches.Count
            $lines += "L$($m.LineNumber): $($m.Line.Substring(0,[Math]::Min(120,$m.Line.Length)))"
        }
    }
    if ($hit -gt 0) {
        $total += $hit
        Write-Host ("  {0,4}  {1}" -f $hit, $f.FullName.Replace($PWD.Path + '\', ''))
        foreach ($l in ($lines | Select-Object -First 3)) { Write-Host "        $l" }
    }
}
Write-Host "TOTAL DUP: $total"
