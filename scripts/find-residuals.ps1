$pattern = '\bD(3[0-5]|[12][0-9]|[1-9])\b(?!-[a-z])'
$paths = @(
    '06.00-idea\self-updating-prompt-engineering\20260503.02-vision-pe-meta-usecases',
    '.github\agents\00.09-pe-meta',
    '.github\templates\00.00-prompt-engineering',
    '.github\prompts\00.09-pe-meta'
)
$total = 0
foreach ($p in $paths) {
    Get-ChildItem $p -Recurse -File -Include *.md | ForEach-Object {
        $hits = Select-String -Path $_.FullName -Pattern $pattern -AllMatches | Where-Object {
            $_.Line -notmatch '<group\|D#>' -and
            $_.Line -notmatch '^\| v\d' -and
            $_.Line -notmatch '"v\d+\.\d+' -and
            $_.Line -notmatch '^>\s*\*\*Most recent' -and
            $_.Line -notmatch '<code>D'
        }
        foreach ($h in $hits) {
            $total++
            Write-Host ("  {0}:L{1}: {2}" -f $_.FullName.Replace($PWD.Path + '\', ''), $h.LineNumber, $h.Line.Substring(0, [Math]::Min(140, $h.Line.Length)))
        }
    }
}
Write-Host "RESIDUAL: $total"
