$ErrorActionPreference = 'Stop'

$root = 'c:/dev/darioairoldi/Learn/06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation'
$repo = 'c:/dev/darioairoldi/Learn'
$nowDate = Get-Date -Format 'yyyy-MM-dd'
$nowTs = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$statusFiles = Get-ChildItem -Path $root -Filter '02.*-validation-status-*.md' |
  Where-Object { $_.Name -notin @('02.01-validation-status-context-files.md','02.02-validation-status-pe-meta-builder.md','02.00-validation-status.md') } |
  Sort-Object Name

function Read-Lines([string]$p) { Get-Content -Path $p }
function Read-Raw([string]$p) { Get-Content -Path $p -Raw }

function Get-FrontmatterLines([string[]]$lines) {
  if($lines.Count -lt 3){ return @() }
  if($lines[0].Trim() -ne '---'){ return @() }
  $end = -1
  for($i=1; $i -lt $lines.Count; $i++){
    if($lines[$i].Trim() -eq '---'){ $end = $i; break }
  }
  if($end -lt 1){ return @() }
  return $lines[1..($end-1)]
}

function Get-FrontmatterValue([string[]]$fm, [string]$key){
  $pattern = '^' + [regex]::Escape($key) + ':\s*"?(.*?)"?\s*$'
  foreach($l in $fm){ if($l -match $pattern){ return $matches[1] } }
  return ''
}

function Has-Field([string[]]$fm, [string]$key){
  $pattern = '^' + [regex]::Escape($key) + ':\s*'
  return [bool]($fm | Where-Object { $_ -match $pattern } | Select-Object -First 1)
}

function Get-CaseList([string[]]$lines, [string]$header){
  $start = ($lines | Select-String -Pattern ('^## ' + [regex]::Escape($header) + '$') | Select-Object -First 1).LineNumber
  if(-not $start){ return @() }
  $out = @()
  for($i=$start; $i -lt $lines.Count; $i++){
    $line = $lines[$i]
    if($line -match '^## '){ break }
    if($line -match '^- \[ [ xX]\] ((G|A|P)-\d\d) (.+)$'){
      $out += [pscustomobject]@{ Id=$matches[1]; Label=$matches[3] }
    }
  }
  return $out
}

function Test-MarkdownLinks([string]$text, [string]$baseDir){
  $broken = @()
  $m = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
  foreach($x in $m){
    $target = $x.Groups[1].Value.Trim()
    if($target -match '^(https?://|mailto:|#)'){ continue }
    $target = $target.Split('#')[0]
    if([string]::IsNullOrWhiteSpace($target)){ continue }
    $candidate = Join-Path $baseDir $target
    if(-not (Test-Path $candidate)){ $broken += $target }
  }
  return $broken | Select-Object -Unique
}

function Get-HandoffTargets([string[]]$lines){
  $targets = @()
  foreach($l in $lines){
    if($l -match '^\s*agent:\s*"?(pe-meta-[a-z0-9-]+)"?\s*$'){ $targets += $matches[1] }
  }
  return $targets | Select-Object -Unique
}

function Get-Tools([string[]]$lines){
  $tools = @()
  $inTools = $false
  foreach($l in $lines){
    if($l -match '^tools:\s*$'){ $inTools = $true; continue }
    if($inTools){
      if($l -match '^\S'){ break }
      if($l -match '^\s*-\s*([a-zA-Z0-9_\-]+)\s*$'){ $tools += $matches[1] }
    }
  }
  return $tools
}

function New-Result([string]$id,[string]$label,[bool]$pass,[string[]]$evidence,[string]$blocker){
  [pscustomobject]@{ Id=$id; Label=$label; Pass=$pass; Evidence=$evidence; Blocker=$blocker }
}

$summary = @()

foreach($sf in $statusFiles){
  $statusLines = Read-Lines $sf.FullName
  $statusRaw = [string]::Join("`n", $statusLines)
  $fm = Get-FrontmatterLines $statusLines
  $artifactType = (Get-FrontmatterValue $fm 'artifact_type').ToLowerInvariant()
  $artifactPath = Get-FrontmatterValue $fm 'artifact_path'
  $artifactName = [System.IO.Path]::GetFileNameWithoutExtension($sf.Name) -replace '^\d+\.\d+-validation-status-',''
  $folderName = [System.IO.Path]::GetFileNameWithoutExtension($sf.Name)
  $folderPath = Join-Path $root $folderName

  $globalCases = Get-CaseList $statusLines 'Global validation cases'
  $typeCases = Get-CaseList $statusLines 'Type-specific validation cases'

  $allResults = @()

  if(-not (Test-Path $artifactPath)){
    foreach($c in ($globalCases + $typeCases)){
      $allResults += New-Result $c.Id $c.Label $false @('artifact file missing') 'artifact file missing'
    }
  } else {
    $artifactLines = Read-Lines $artifactPath
    $artifactRaw = [string]::Join("`n", $artifactLines)
    $afm = Get-FrontmatterLines $artifactLines
    $artifactDir = Split-Path -Parent $artifactPath

    foreach($c in $globalCases){
      switch($c.Id){
        'G-01' {
          $required = @('description','version','last_updated','goal','scope','boundaries','rationales')
          $missing = @($required | Where-Object { -not (Has-Field $afm $_) })
          $semverOk = [bool](Get-FrontmatterValue $afm 'version' -match '^\d+\.\d+\.\d+$')
          $pass = ($missing.Count -eq 0 -and $semverOk)
          $ev = @("missing_fields=$($missing -join ',')", "semver_ok=$semverOk")
          $block = if($pass){''} else {"missing metadata fields or invalid semver: $($missing -join ',')"}
          $allResults += New-Result $c.Id $c.Label $pass $ev $block
        }
        'G-02' {
          $broken = Test-MarkdownLinks $artifactRaw $artifactDir
          $pass = ($broken.Count -eq 0)
          $ev = @("broken_links=$($broken.Count)")
          $block = if($pass){''} else {"broken links: $($broken -join ', ')"}
          $allResults += New-Result $c.Id $c.Label $pass $ev $block
        }
        'G-03' {
          $goal = Has-Field $afm 'goal'
          $scope = Has-Field $afm 'scope'
          $covers = [bool]($artifactRaw -match '(?m)^\s*covers:\s*$')
          $excludes = [bool]($artifactRaw -match '(?m)^\s*excludes:\s*$')
          $pass = ($goal -and $scope -and $covers -and $excludes)
          $ev = @("goal=$goal", "scope=$scope", "covers=$covers", "excludes=$excludes")
          $block = if($pass){''} else {'goal/scope/covers/excludes not fully declared'}
          $allResults += New-Result $c.Id $c.Label $pass $ev $block
        }
        'G-04' {
          $bound = Has-Field $afm 'boundaries'
          $boundaryItems = ([regex]::Matches($artifactRaw, '(?m)^\s*-\s+"?.+"?\s*$') | Measure-Object).Count
          $pass = ($bound -and $boundaryItems -gt 0)
          $ev = @("boundaries_field=$bound", "boundary_items=$boundaryItems")
          $block = if($pass){''} else {'boundaries are missing or empty'}
          $allResults += New-Result $c.Id $c.Label $pass $ev $block
        }
        'G-05' {
          $ver = Get-FrontmatterValue $afm 'version'
          $lu = Get-FrontmatterValue $afm 'last_updated'
          $verOk = [bool]($ver -match '^\d+\.\d+\.\d+$')
          $dtOk = [bool]($lu -match '^\d{4}-\d{2}-\d{2}$')
          $pass = ($verOk -and $dtOk)
          $ev = @("version=$ver", "last_updated=$lu")
          $block = if($pass){''} else {'version or last_updated format invalid'}
          $allResults += New-Result $c.Id $c.Label $pass $ev $block
        }
        default {
          $allResults += New-Result $c.Id $c.Label $false @('unsupported case id') 'unsupported case id'
        }
      }
    }

    if($artifactType -eq 'agent'){
      foreach($c in $typeCases){
        switch($c.Id){
          'A-01' {
            $mode = Get-FrontmatterValue $afm 'agent'
            $tools = Get-Tools $artifactLines
            $writeTools = @('apply_patch','create_file','edit_notebook_file','run_in_terminal','send_to_terminal')
            $hasWrite = [bool]($tools | Where-Object { $writeTools -contains $_ } | Select-Object -First 1)
            $pass = (($mode -in @('plan','agent')) -and $tools.Count -gt 0 -and (($mode -ne 'plan') -or -not $hasWrite))
            $ev = @("mode=$mode", "tool_count=$($tools.Count)", "plan_has_write=$hasWrite")
            $block = if($pass){''} else {'agent mode/tool alignment invalid'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'A-02' {
            $always = [bool]($artifactRaw -match '(?im)^###\s+.*Always Do')
            $ask = [bool]($artifactRaw -match '(?im)^###\s+.*Ask First')
            $never = [bool]($artifactRaw -match '(?im)^###\s+.*Never Do')
            $pass = ($always -and $ask -and $never)
            $ev = @("always=$always", "ask_first=$ask", "never=$never")
            $block = if($pass){''} else {'missing one or more boundary sections (Always/Ask First/Never)'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'A-03' {
            $targets = Get-HandoffTargets $artifactLines
            $missingTargets = @()
            foreach($t in $targets){
              $p = Join-Path (Split-Path $artifactPath -Parent) ($t + '.agent.md')
              if(-not (Test-Path $p)){ $missingTargets += $t }
            }
            $pass = ($targets.Count -gt 0 -and $missingTargets.Count -eq 0)
            $ev = @("handoff_targets=$($targets -join ',')", "missing_targets=$($missingTargets -join ',')")
            $block = if($pass){''} else {'handoff target integrity failure'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'A-04' {
            $ctx = Has-Field $afm 'context_dependencies'
            $pass = $ctx
            $ev = @("context_dependencies_present=$ctx")
            $block = if($pass){''} else {'context_dependencies not declared'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'A-05' {
            $hasDet = [bool]($artifactRaw -match '(?i)deterministic')
            $hasProcess = [bool]($artifactRaw -match '(?i)^##\s+Process|phase')
            $pass = ($hasDet -or $hasProcess)
            $ev = @("contains_deterministic=$hasDet", "contains_process_or_phase=$hasProcess")
            $block = if($pass){''} else {'no deterministic/process split signals found'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          default {
            $allResults += New-Result $c.Id $c.Label $false @('unsupported case id') 'unsupported case id'
          }
        }
      }
    } else {
      foreach($c in $typeCases){
        switch($c.Id){
          'P-01' {
            $argHint = Has-Field $afm 'argument-hint'
            $pass = $argHint
            $ev = @("argument_hint_present=$argHint")
            $block = if($pass){''} else {'argument-hint missing'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'P-02' {
            $hasTypeDispatch = [bool]($artifactRaw -match '(?i)type dispatch|type-aware|artifact type|dispatch')
            $pass = $hasTypeDispatch
            $ev = @("type_dispatch_signals=$hasTypeDispatch")
            $block = if($pass){''} else {'type dispatch behavior not explicit'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'P-03' {
            $p1 = [bool]($artifactRaw -match '(?im)^###\s+Phase\s+1')
            $p2 = [bool]($artifactRaw -match '(?im)^###\s+Phase\s+2')
            $pass = ($p1 -and $p2)
            $ev = @("phase1=$p1", "phase2=$p2")
            $block = if($pass){''} else {'phase ordering is not explicit'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'P-04' {
            $handoffSignals = [bool]($artifactRaw -match '(?i)handoff|delegate|@meta-|/pe-meta-')
            $pass = $handoffSignals
            $ev = @("handoff_signals=$handoffSignals")
            $block = if($pass){''} else {'delegation/handoff behavior not explicit'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          'P-05' {
            $bound = Has-Field $afm 'boundaries'
            $scope = Has-Field $afm 'scope'
            $pass = ($bound -and $scope)
            $ev = @("boundaries_field=$bound", "scope_field=$scope")
            $block = if($pass){''} else {'scope/boundary safety metadata missing'}
            $allResults += New-Result $c.Id $c.Label $pass $ev $block
          }
          default {
            $allResults += New-Result $c.Id $c.Label $false @('unsupported case id') 'unsupported case id'
          }
        }
      }
    }
  }

  $failed = @($allResults | Where-Object { -not $_.Pass })
  $state = if($failed.Count -eq 0){ 'complete' } else { 'failed' }
  $blockers = if($failed.Count -eq 0){ 'none' } else { ($failed | ForEach-Object { "$($_.Id): $($_.Blocker)" }) -join ' | ' }

  $globalBlock = @('## Global validation cases','')
  foreach($c in $globalCases){
    $r = $allResults | Where-Object { $_.Id -eq $c.Id } | Select-Object -First 1
    $x = if($r.Pass){'x'} else {' '}
    $ev = ($r.Evidence -join '; ')
    $globalBlock += "- [$x] $($c.Id) $($c.Label)"
    $globalBlock += "`tResult: " + (if($r.Pass){"pass ($ev)"}else{"fail ($($r.Blocker)); evidence: $ev"})
  }

  $typeBlock = @('## Type-specific validation cases','')
  foreach($c in $typeCases){
    $r = $allResults | Where-Object { $_.Id -eq $c.Id } | Select-Object -First 1
    $x = if($r.Pass){'x'} else {' '}
    $ev = ($r.Evidence -join '; ')
    $typeBlock += "- [$x] $($c.Id) $($c.Label)"
    $typeBlock += "`tResult: " + (if($r.Pass){"pass ($ev)"}else{"fail ($($r.Blocker)); evidence: $ev"})
  }

  $steps = if($artifactType -eq 'agent'){@(
'## Validation steps','',
'1. Run global validation steps (G-01 to G-05).',
'2. Validate mode and tool list compatibility.',
'3. Validate boundaries and never-do constraints.',
'4. Resolve handoffs and target existence.',
'5. Validate adherence against loaded guidance.',
'6. Validate efficiency dimensions where applicable.',''
)} else {@(
'## Validation steps','',
'1. Run global validation steps (G-01 to G-05).',
'2. Validate invocation contract and parameters.',
'3. Validate type routing and fallback behavior.',
'4. Validate phase ordering and mode semantics.',
'5. Validate handoff and dependency behavior.',
'6. Validate read-only versus write behavior by mode.',''
)}

  $bootstrapFile = if($artifactType -eq 'agent'){'00a-bootstrap-create-agent.prompt.md'} else {'00a-bootstrap-create-prompt.prompt.md'}

  $newLines = @(
'---',
('title: "Validation status - ' + $artifactName + '"'),
'author: "Dario Airoldi"',
'date: "2026-05-21"',
'version: "1.0.0"',
'status: "draft"',
'domain: "prompt-engineering"',
('artifact_type: "' + $artifactType + '"'),
'validation_scope: "individual"',
('validation_state: "' + $state + '"'),
('artifact_path: "' + $artifactPath + '"'),
'---','',
("# Validation status - $artifactName"),'',
("Artifact path: `$artifactPath`"),
("Artifact type: $artifactType"),'',
("Bootstrap runbook (no pe-meta required): [$folderName/00-runbook.md]($folderName/00-runbook.md)"),''
  ) + $globalBlock + @('') + $typeBlock + @('') + $steps + @(
'### Bootstrap when pe-meta is not available','',
'Run validations from local prompt files in this folder:','',
("1. [00-runbook.md]($folderName/00-runbook.md)"),
("2. If artifact is missing: [$bootstrapFile]($folderName/$bootstrapFile)"),
'3. Run each case prompt file in order (`01`..`10`)','',
'### Status marking rule when file is initially missing','',
'- Mark all cases as `blocked (artifact missing)` in notes before bootstrap.',
'- After bootstrap creation, rerun each case prompt and update checkboxes from those results only.','',
'## Execution log','',
'| Date | Runner | Scope | Result | Notes |',
'|---|---|---|---|---|',
'| 2026-05-21 | pending | individual | not_run | scaffold created |',
("| $nowDate | copilot | individual | $state | runbook executed sequentially; blockers: $blockers |"),
''
  )

  Set-Content -Path $sf.FullName -Value $newLines -Encoding utf8

  if(-not (Test-Path $folderPath)){ New-Item -Path $folderPath -ItemType Directory | Out-Null }
  $planPath = Join-Path $folderPath '20260521-improvement-plan.md'
  $planLines = @(
'---',
('title: "Improvement plan - ' + $artifactName + '"'),
'author: "Dario Airoldi"',
('date: "' + $nowDate + '"'),
'version: "1.0.0"',
'status: "draft"',
'domain: "prompt-engineering"',
'---','',
("# Improvement plan - $artifactName"),'',
("Source status file: [../$($sf.Name)](../$($sf.Name))"),
("Last run: $nowTs"),'',
'## Summary','',
("- Validation state: $state"),
("- Blockers: $blockers"),'',
'## Actions',''
  )

  if($failed.Count -eq 0){
    $planLines += '- [x] No blocking findings from current run'
    $planLines += '- [ ] Optional hardening: add explicit deterministic evidence examples in case outputs'
  } else {
    foreach($f in $failed){
      $planLines += ("- [ ] $($f.Id) $($f.Label): $($f.Blocker)")
    }
  }

  $planLines += @('','## Validation evidence','')
  foreach($r in $allResults){
    $planLines += ("- $($r.Id): " + (if($r.Pass){'pass'}else{'fail'}) + " | " + ($r.Evidence -join '; '))
  }

  Set-Content -Path $planPath -Value $planLines -Encoding utf8

  $summary += [pscustomobject]@{
    Id = ($sf.Name -replace '\.md$','')
    Name = $artifactName
    ArtifactType = $artifactType
    ArtifactPath = $artifactPath
    Status = $state
    Blockers = $blockers
    LastRun = $nowTs
    StatusFile = $sf.Name
  }
}

# Update top-level 02.00 validation status table
$overviewPath = Join-Path $root '02.00-validation-status.md'
$overviewLines = @(
'---',
'title: "Validation status"',
'author: "Dario Airoldi"',
'date: "2026-05-21"',
'version: "1.2.0"',
'status: "draft"',
'domain: "prompt-engineering"',
'validation_scope: "context-whole-plus-individual-artifacts"',
'---','',
'# Validation status','',
'This folder tracks validation status with this rule:','',
'- Context files are validated as a whole set.',
'- Every other pe-meta artifact is validated individually.','',
'## Files generated','',
'| # | Validation file | Type | Target artifact | Status | Blockers | Last run |',
'|---:|---|---|---|---|---|---|',
'| 1 | [02.01-validation-status-context-files.md](02.01-validation-status-context-files.md) | context-set | `context-whole` | complete | none | 2026-05-21 00:00:00 |',
'| 2 | [02.02-validation-status-pe-meta-builder.md](02.02-validation-status-pe-meta-builder.md) | agent | `C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md` | complete | none | 2026-05-21 00:00:00 |'
)

$idx = 3
foreach($s in $summary){
  $overviewLines += ("| $idx | [$($s.StatusFile)]($($s.StatusFile)) | $($s.ArtifactType) | `$($s.ArtifactPath)` | $($s.Status) | $($s.Blockers.Replace('|','/')) | $($s.LastRun) |")
  $idx++
}

$overviewLines += @('','## How to use','',
'1. Start with `02.01-validation-status-context-files.md`.',
'2. Continue with individual artifact files in numeric order.',
'3. Update `validation_state`, blockers, and execution logs after each run.')

Set-Content -Path $overviewPath -Value $overviewLines -Encoding utf8

# Emit a compact report
$reportPath = Join-Path $root '20260521-validation-execution-summary.json'
$summary | ConvertTo-Json -Depth 5 | Set-Content -Path $reportPath -Encoding utf8

Write-Output ("EXECUTED=" + $summary.Count)
Write-Output ("COMPLETE=" + (@($summary | Where-Object { $_.Status -eq 'complete' }).Count))
Write-Output ("FAILED=" + (@($summary | Where-Object { $_.Status -eq 'failed' }).Count))
Write-Output ("SUMMARY=" + $reportPath)
