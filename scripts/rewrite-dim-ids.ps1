# Mechanical rewriter: bare D# -> D#-readable-id (per Plan 01-dimids-rename-plan, Phases 5-9)
# Run from repo root. Edits files in place. Reports per-file changes and residuals.

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path

$dimMap = [ordered]@{
    'D1' = 'D1-metadata'; 'D2' = 'D2-references'; 'D3' = 'D3-token-budget'; 'D4' = 'D4-tool-alignment';
    'D5' = 'D5-boundaries'; 'D6' = 'D6-consistency'; 'D7' = 'D7-non-redundancy'; 'D8' = 'D8-prioritization';
    'D9' = 'D9-clarity'; 'D10' = 'D10-completeness'; 'D11' = 'D11-actionability'; 'D12' = 'D12-staleness';
    'D13' = 'D13-source-verification'; 'D14' = 'D14-craftsmanship'; 'D15' = 'D15-vision-alignment';
    'D16' = 'D16-adherence'; 'D17' = 'D17-cross-coherence'; 'D18' = 'D18-coverage';
    'D19' = 'D19-artifact-structure'; 'D20' = 'D20-token-chain'; 'D21' = 'D21-deterministic-first';
    'D22' = 'D22-context-optimization'; 'D23' = 'D23-reference-efficiency'; 'D24' = 'D24-handoff-efficiency';
    'D25' = 'D25-processing-efficiency'; 'D26' = 'D26-model-routing'; 'D27' = 'D27-model-adherence';
    'D28' = 'D28-reproducibility'; 'D29' = 'D29-regression-protection'; 'D30' = 'D30-metadata-guard';
    'D31' = 'D31-multipass-validation-invariant'; 'D32' = 'D32-rollback-readiness';
    'D33' = 'D33-boundary-actionability'; 'D34' = 'D34-autonomy-calibration'; 'D35' = 'D35-portability-boundary'
}

function Get-DimName([string]$key) {
    if ($dimMap.Contains($key)) { return $dimMap[$key] } else { return $key }
}

# Process one line. Returns rewritten line.
function Rewrite-Line([string]$line) {
    # Protect the literal CLI placeholder <group|D#> by swapping to a sentinel
    $sentinel = "__GROUP_DHASH_PLACEHOLDER__"
    $line = $line -replace [regex]::Escape('<group|D#>'), $sentinel

    # Rule B: ranges D{n}-D{m} or D{n}–D{m} (hyphen or en-dash)
    $line = [regex]::Replace($line, '`?D(3[0-5]|[12][0-9]|[1-9])`?\s*[-\u2013]\s*`?D(3[0-5]|[12][0-9]|[1-9])`?', {
            param($m)
            $n = "D$($m.Groups[1].Value)"; $k = "D$($m.Groups[2].Value)"
            "``$(Get-DimName $n)`` through ``$(Get-DimName $k)``"
        })

    # Rule C: slash-separated D#/D#(/D#)*
    $line = [regex]::Replace($line, '`?D(3[0-5]|[12][0-9]|[1-9])`?(?:/`?D(3[0-5]|[12][0-9]|[1-9])`?){1,}', {
            param($m)
            $raw = $m.Value -replace '`', ''
            $tokens = $raw -split '/'
            ($tokens | ForEach-Object { "``$(Get-DimName $_)``" }) -join ' / '
        })

    # Rule D: D# (name) or D# (name, extra)
    $line = [regex]::Replace($line, '\bD(3[0-5]|[12][0-9]|[1-9])\s+\(([a-z][a-z0-9\-]*(?:,\s+[^)]+)?)\)', {
            param($m)
            $dim = "D$($m.Groups[1].Value)"
            $parens = $m.Groups[2].Value
            $canonical = Get-DimName $dim
            if ($parens -match '^[a-z][a-z0-9\-]*,\s*(.+)$') {
                "``$canonical`` ($($matches[1]))"
            }
            else {
                "``$canonical``"
            }
        })

    # Rule E: bare D# (not already followed by -lowercase, not preceded by alphanumeric)
    $line = [regex]::Replace($line, '(?<![A-Za-z0-9_\-])D(3[0-5]|[12][0-9]|[1-9])\b(?!-[a-z])', {
            param($m)
            $dim = "D$($m.Groups[1].Value)"
            "``$(Get-DimName $dim)``"
        })

    # De-duplicate backtick collisions (e.g. `` `D6-consistency` `` inside an existing code span)
    $line = $line -replace '```', '`'   # collapse triple-backticks created by adjacency (rare)

    # Restore sentinel
    $line = $line -replace [regex]::Escape($sentinel), '<group|D#>'

    return $line
}

function Process-File([string]$path) {
    $lines = Get-Content -Path $path -Encoding UTF8
    $inCode = $false
    $changed = $false
    $newLines = @()
    foreach ($line in $lines) {
        # Track fenced code blocks
        if ($line -match '^\s*```') {
            $inCode = -not $inCode
            $newLines += $line
            continue
        }
        if ($inCode) {
            $newLines += $line
            continue
        }
        # Protect changelog entries: lines that begin with "> **Most recent changes" or "> v" or rows starting "| v"
        if ($line -match '^\| v\d' -or $line -match '^>\s*\*\*Most recent changes' -or $line -match '^\s*-\s*"v\d') {
            $newLines += $line
            continue
        }
        $rewritten = Rewrite-Line $line
        if ($rewritten -ne $line) { $changed = $true }
        $newLines += $rewritten
    }
    if ($changed) {
        Set-Content -Path $path -Value $newLines -Encoding UTF8
        return $true
    }
    return $false
}

# Phase definitions
$phases = [ordered]@{
    'Phase 5' = @{
        Files = Get-ChildItem -Path "$root\06.00-idea\self-updating-prompt-engineering\20260503.02-vision-pe-meta-usecases" -Recurse -File -Include *.md
    }
    'Phase 6' = @{
        Files = Get-ChildItem -Path "$root\.github\agents\00.09-pe-meta\*" -File -Include *.agent.md
    }
    'Phase 7' = @{
        Files = Get-ChildItem -Path "$root\.github\templates\00.00-prompt-engineering\*" -File -Include *.template.md
    }
    'Phase 8' = @{
        Files = Get-ChildItem -Path "$root\.github\prompts\00.09-pe-meta\*" -File -Include *.md
    }
    'Phase 9' = @{
        Files = Get-ChildItem -Path "$root\06.00-idea\self-updating-prompt-engineering\20260521.01-pe-meta-implementation" -Recurse -File -Include *.md
    }
}

$report = [ordered]@{}
foreach ($phaseName in $phases.Keys) {
    Write-Host "===== $phaseName =====" -ForegroundColor Yellow
    $changedCount = 0
    $files = $phases[$phaseName].Files
    foreach ($f in $files) {
        if (Process-File $f.FullName) {
            $changedCount++
            Write-Host "  rewrote: $($f.FullName.Replace($root + '\',''))"
        }
    }
    $report[$phaseName] = @{ Total = $files.Count; Changed = $changedCount }
}

# Verification: residual bare-D# hits excluding protected patterns
Write-Host "`n===== VERIFICATION =====" -ForegroundColor Yellow
$allFiles = @()
foreach ($phaseName in $phases.Keys) { $allFiles += $phases[$phaseName].Files }
$residualTotal = 0
foreach ($f in $allFiles) {
    $hits = Select-String -Path $f.FullName -Pattern '\bD([1-9]|[12][0-9]|3[0-5])\b(?!-[a-z])' -AllMatches
    if ($hits) {
        # Filter out allowed residuals
        $filtered = $hits | Where-Object {
            $line = $_.Line
            -not ($line -match '<group\|D#>' -or $line -match '^\| v\d' -or $line -match '\bv\d+\s*\(.*D\d+' -or $line -match '"v\d+\.\d+')
        }
        if ($filtered) {
            $count = ($filtered | Measure-Object).Count
            if ($count -gt 0) {
                $residualTotal += $count
                Write-Host ("  {0,4}  {1}" -f $count, $f.FullName.Replace($root + '\', ''))
                foreach ($h in $filtered) {
                    $snip = $h.Line.Substring(0, [Math]::Min(120, $h.Line.Length))
                    Write-Host "        L$($h.LineNumber): $snip"
                }
            }
        }
    }
}

Write-Host "`n===== SUMMARY =====" -ForegroundColor Cyan
foreach ($phaseName in $report.Keys) {
    Write-Host ("  {0}: {1}/{2} files changed" -f $phaseName, $report[$phaseName].Changed, $report[$phaseName].Total)
}
Write-Host "  Residuals (after protected-filter): $residualTotal"
