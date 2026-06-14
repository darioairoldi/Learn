param(
    [string]$Root = 'e:\dev.darioa.live\darioairoldi\Learn',
    [switch]$WhatIfOnly
)

$ErrorActionPreference = 'Stop'
$internal = Join-Path (Split-Path $Root -Parent) 'Learn.internal'
$srcRoot  = Join-Path $Root '02.00-events'

if (-not (Test-Path $internal)) { throw "Internal repo not found: $internal" }
if (-not (Test-Path $srcRoot))  { throw "Source folder not found: $srcRoot" }

$files = Get-ChildItem -Path $srcRoot -Recurse -File -Filter 'transcript*'
$log = [System.Collections.Generic.List[object]]::new()
$moved = 0; $skipped = 0; $failed = 0

foreach ($f in $files) {
    $rel    = $f.FullName.Substring($Root.Length).TrimStart('\')   # e.g. 02.00-events\...\transcript.txt
    $target = Join-Path $internal $rel
    $tdir   = Split-Path $target -Parent
    $status = ''
    try {
        if (-not (Test-Path $tdir)) { New-Item -ItemType Directory -Path $tdir -Force | Out-Null }
        if (Test-Path $target) {
            $status = 'skipped-exists'; $skipped++
        }
        elseif ($WhatIfOnly) {
            $status = 'would-move'
        }
        else {
            Move-Item -LiteralPath $f.FullName -Destination $target
            $status = 'moved'; $moved++
        }
    }
    catch { $status = "FAILED: $($_.Exception.Message)"; $failed++ }
    $log.Add([pscustomobject]@{ rel = $rel; status = $status })
}

$log | ConvertTo-Json -Depth 3 | Set-Content -Path (Join-Path $Root '99.00-temp\move-transcripts-log.json') -Encoding UTF8
"total=$($files.Count) moved=$moved skipped=$skipped failed=$failed whatIf=$WhatIfOnly"
$log | Where-Object { $_.status -notin @('moved','would-move') } | Format-Table -AutoSize
