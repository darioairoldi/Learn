$ErrorActionPreference = 'Stop'
$root = 'c:/dev/darioairoldi/Learn'
$impl = Join-Path $root '06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation'
$statusFiles = Get-ChildItem -Path $impl -Filter '02.*-validation-status-*.md' |
  Where-Object { $_.Name -notin @('02.00-validation-status.md','02.01-validation-status-context-files.md','02.02-validation-status-pe-meta-builder.md') } |
  Sort-Object Name

function Get-FrontmatterRaw([string]$text){
  if($text -match '(?s)^---\r?\n(.*?)\r?\n---'){ return $matches[1] }
  return ''
}

function Get-FrontmatterValue([string]$fm, [string]$key){
  $m = [regex]::Match($fm, '(?m)^' + [regex]::Escape($key) + ':\s*"?(.*?)"?\s*$')
  if($m.Success){ return $m.Groups[1].Value.Trim() }
  return ''
}

function Test-Exists([string]$path){
  if([string]::IsNullOrWhiteSpace($path)){ return $false }
  return Test-Path -LiteralPath $path
}

function Is-SemVer([string]$v){ return $v -match '^\d+\.\d+\.\d+$' }
function Is-IsoDate([string]$d){ return $d -match '^\d{4}-\d{2}-\d{2}$' }

function Get-MarkdownBody([string]$text){
  if($text -match '(?s)^---\r?\n.*?\r?\n---\r?\n(.*)$'){ return $matches[1] }
  return $text
}

function Test-ReferenceIntegrity([string]$artifactPath, [string]$content){
  $body = Get-MarkdownBody $content
  $dir = Split-Path -Parent $artifactPath
  $broken = @()

  $linkMatches = [regex]::Matches($body, '\[[^\]]+\]\(([^\)]+)\)')
  foreach($m in $linkMatches){
    $target = $m.Groups[1].Value.Trim()
    if($target -match '^(https?:|mailto:|#)'){ continue }
    $target = $target.Split(' ')[0]
    if($target -match '^<.*>$'){ $target = $target.Trim('<','>') }
    if($target.Contains('#')){ $target = $target.Split('#')[0] }
    if([string]::IsNullOrWhiteSpace($target)){ continue }
    $candidate = $target
    if(-not ([System.IO.Path]::IsPathRooted($candidate))){ $candidate = Join-Path $dir $candidate }
    if(-not (Test-Path -LiteralPath $candidate)){ $broken += $target }
  }

  $slash = [regex]::Matches($body, '/pe-meta-([a-z0-9-]+)')
  foreach($s in $slash){
    $name = 'pe-meta-' + $s.Groups[1].Value
    $pp = Join-Path $root (".github/prompts/00.09-pe-meta/{0}.prompt.md" -f $name)
    if(-not (Test-Path -LiteralPath $pp)){ $broken += ('slash-command:' + $name) }
  }

  return ,@($broken | Select-Object -Unique)
}

function Test-Handoffs([string]$content){
  $targets = @()
  $matches = [regex]::Matches($content, '(?m)^\s*agent:\s*([a-z0-9-]+)\s*$')
  foreach($m in $matches){ $targets += $m.Groups[1].Value }
  $missing = @()
  foreach($t in ($targets | Select-Object -Unique)){
    $af = Join-Path $root (".github/agents/00.09-pe-meta/{0}.agent.md" -f $t)
    if(-not (Test-Path -LiteralPath $af)){ $missing += $t }
  }
  return ,@($missing)
}

function Replace-ValidationSections([string]$text, [string[]]$globalLines, [string[]]$typeLines, [string[]]$blockers){
  $g = ($globalLines -join "`r`n")
  $t = ($typeLines -join "`r`n")
  $section = "## Global validation cases`r`n`r`n$g`r`n`r`n## Type-specific validation cases`r`n`r`n$t`r`n"
  $text = [regex]::Replace($text, '(?s)## Global validation cases\r?\n.*?\r?\n## Type-specific validation cases\r?\n.*?\r?\n## Validation steps', $section + "`r`n## Validation steps")

  $blockerLines = @('### Blockers','')
  if($blockers.Count -eq 0){
    $blockerLines += '- none'
  } else {
    foreach($b in $blockers){ $blockerLines += ('- ' + $b) }
  }
  $blockerText = ($blockerLines -join "`r`n") + "`r`n`r`n"

  if($text -match '(?s)### Blockers\r?\n.*?\r?\n## Execution log'){
    $text = [regex]::Replace($text, '(?s)### Blockers\r?\n.*?\r?\n## Execution log', $blockerText + '## Execution log')
  } else {
    $text = $text -replace '## Execution log', ($blockerText + '## Execution log')
  }

  return $text
}

$summary = @()
$runTs = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$runDate = Get-Date -Format 'yyyy-MM-dd'

foreach($sf in $statusFiles){
  $statusText = Get-Content -Raw -LiteralPath $sf.FullName
  $statusFm = Get-FrontmatterRaw $statusText
  $artifactType = (Get-FrontmatterValue $statusFm 'artifact_type').ToLowerInvariant()
  $artifactPath = Get-FrontmatterValue $statusFm 'artifact_path'
  $artifactExists = Test-Exists $artifactPath

  $results = [ordered]@{}
  $blockers = @()

  $content = ''
  $fm = ''
  $body = ''
  if($artifactExists){
    $content = Get-Content -Raw -LiteralPath $artifactPath
    $fm = Get-FrontmatterRaw $content
    $body = Get-MarkdownBody $content
  }

  # Common checks
  $required = @('description','version','last_updated','goal','scope','boundaries','rationales')
  $missing = @()
  if(-not $artifactExists){
    $results['G-01'] = @{ pass = $false; msg = 'artifact missing' }
  } else {
    foreach($k in $required){ if(-not (Get-FrontmatterValue $fm $k)){ $missing += $k } }
    $ver = Get-FrontmatterValue $fm 'version'
    $lu = Get-FrontmatterValue $fm 'last_updated'
    $invalid = @()
    if(-not (Is-SemVer $ver)){ $invalid += 'version' }
    if(-not (Is-IsoDate $lu)){ $invalid += 'last_updated' }
    $ok = ($missing.Count -eq 0 -and (Is-SemVer $ver) -and (Is-IsoDate $lu))
    $msg = if($ok){ 'required metadata present; semver/date valid' } else { ('missing/invalid: ' + (($missing + $invalid) -join ', ')) }
    $results['G-01'] = @{ pass = $ok; msg = $msg }
  }

  if(-not $artifactExists){
    $results['G-02'] = @{ pass = $false; msg = 'artifact missing' }
  } else {
    $broken = Test-ReferenceIntegrity $artifactPath $content
    $ok = $broken.Count -eq 0
    $msg = if($ok){ 'broken references: 0' } else { 'broken refs: ' + ($broken -join '; ') }
    $results['G-02'] = @{ pass = $ok; msg = $msg }
  }

  if(-not $artifactExists){
    $results['G-03'] = @{ pass = $false; msg = 'artifact missing' }
  } else {
    $goal = Get-FrontmatterValue $fm 'goal'
    $hasCovers = $fm -match '(?ms)^scope:\s*\r?\n\s*covers:\s*\r?\n\s*- '
    $hasExcludes = $fm -match '(?ms)^scope:\s*\r?\n(?:\s*covers:.*?\r?\n)?\s*excludes:\s*\r?\n\s*- '
    $ok = (-not [string]::IsNullOrWhiteSpace($goal)) -and $hasCovers -and $hasExcludes
    $msg = if($ok){ 'goal/scope covers/excludes present' } else { 'missing goal or scope covers/excludes' }
    $results['G-03'] = @{ pass = $ok; msg = $msg }
  }

  if(-not $artifactExists){
    $results['G-04'] = @{ pass = $false; msg = 'artifact missing' }
  } else {
    $hasBoundaries = $fm -match '(?ms)^boundaries:\s*\r?\n\s*- '
    $hasBodyBoundaries = ($body -match '(?im)^###\s+.*Always Do') -and ($body -match '(?im)^###\s+.*Ask First') -and ($body -match '(?im)^###\s+.*Never Do')
    $ok = if($artifactType -eq 'agent'){ $hasBoundaries -and $hasBodyBoundaries } else { $hasBoundaries }
    $msg = if($ok){ 'boundaries present and complete for type' } else { 'boundary sections incomplete' }
    $results['G-04'] = @{ pass = $ok; msg = $msg }
  }

  if(-not $artifactExists){
    $results['G-05'] = @{ pass = $false; msg = 'artifact missing' }
  } else {
    $ok = (Is-SemVer (Get-FrontmatterValue $fm 'version')) -and (Is-IsoDate (Get-FrontmatterValue $fm 'last_updated'))
    $msg = if($ok){ 'version/last_updated valid' } else { 'invalid version or last_updated format' }
    $results['G-05'] = @{ pass = $ok; msg = $msg }
  }

  if($artifactType -eq 'agent'){
    if(-not $artifactExists){ $results['A-01']=@{pass=$false;msg='artifact missing'} } else {
      $mode = Get-FrontmatterValue $fm 'agent'
      $toolsBlock = [regex]::Match($fm, '(?ms)^tools:\s*\r?\n(.*?)(?:\r?\n\w|$)').Groups[1].Value
      $toolCount = ([regex]::Matches($toolsBlock, '(?m)^\s*-\s+')).Count
      $hasWrite = $toolsBlock -match 'apply_patch|create_file|edit_notebook_file|vscode_renameSymbol'
      $ok = (($mode -eq 'plan' -or $mode -eq 'agent') -and $toolCount -gt 0 -and (($mode -eq 'plan' -and -not $hasWrite) -or $mode -eq 'agent'))
      $results['A-01']=@{pass=$ok;msg=$(if($ok){"mode/tool alignment valid ($mode, tools=$toolCount)"}else{"mode/tool misalignment ($mode, tools=$toolCount, hasWrite=$hasWrite)"})}
    }
    if(-not $artifactExists){ $results['A-02']=@{pass=$false;msg='artifact missing'} } else {
      $always = ([regex]::Matches($body, '(?ms)^###\s+.*Always Do\r?\n(.*?)(?=^###\s+|\z)', 'Multiline')).Value
      $ask = ([regex]::Matches($body, '(?ms)^###\s+.*Ask First\r?\n(.*?)(?=^###\s+|\z)', 'Multiline')).Value
      $never = ([regex]::Matches($body, '(?ms)^###\s+.*Never Do\r?\n(.*?)(?=^###\s+|\z)', 'Multiline')).Value
      $ok = ($always.Count -gt 0 -and $ask.Count -gt 0 -and $never.Count -gt 0)
      $results['A-02']=@{pass=$ok;msg=$(if($ok){'Always/Ask/Never sections present'}else{'missing Always/Ask/Never section'})}
    }
    if(-not $artifactExists){ $results['A-03']=@{pass=$false;msg='artifact missing'} } else {
      $missingHandoffs = Test-Handoffs $content
      $ok = $missingHandoffs.Count -eq 0
      $results['A-03']=@{pass=$ok;msg=$(if($ok){'handoff targets resolve'}else{'missing handoff targets: ' + ($missingHandoffs -join ', ')})}
    }
    if(-not $artifactExists){ $results['A-04']=@{pass=$false;msg='artifact missing'} } else {
      $hasContextDeps = $fm -match '(?ms)^context_dependencies:\s*\r?\n\s*- '
      $mentionsGuidance = $body -match 'context|guidance|STRUCTURE-README|dependency map'
      $ok = $hasContextDeps -and $mentionsGuidance
      $results['A-04']=@{pass=$ok;msg=$(if($ok){'context dependencies and guidance usage signals present'}else{'missing context dependency or guidance signal'})}
    }
    if(-not $artifactExists){ $results['A-05']=@{pass=$false;msg='artifact missing'} } else {
      $hasDet = $body -match 'deterministic'
      $hasProcess = $body -match 'Phase|Step|iteration|token budget|process'
      $ok = $hasDet -and $hasProcess
      $results['A-05']=@{pass=$ok;msg=$(if($ok){'deterministic/process split signals present'}else{'missing deterministic-first process signals'})}
    }
  } else {
    if(-not $artifactExists){ $results['P-01']=@{pass=$false;msg='artifact missing'} } else {
      $argHint = Get-FrontmatterValue $fm 'argument-hint'
      $ok = -not [string]::IsNullOrWhiteSpace($argHint)
      $results['P-01']=@{pass=$ok;msg=$(if($ok){'argument-hint present'}else{'missing argument-hint'})}
    }
    if(-not $artifactExists){ $results['P-02']=@{pass=$false;msg='artifact missing'} } else {
      $ok = ($body -match 'type|artifact type|dispatch|route|routing')
      $results['P-02']=@{pass=$ok;msg=$(if($ok){'dispatch/routing signals present'}else{'missing type dispatch/routing guidance'})}
    }
    if(-not $artifactExists){ $results['P-03']=@{pass=$false;msg='artifact missing'} } else {
      $hasPhase = ($body -match 'Phase 1') -or ($body -match 'Step 1')
      $hasMode = ($body -match 'read-only|plan mode|mode')
      $ok = $hasPhase -and $hasMode
      $results['P-03']=@{pass=$ok;msg=$(if($ok){'phase/mode behavior signals present'}else{'missing phase ordering or mode behavior guidance'})}
    }
    if(-not $artifactExists){ $results['P-04']=@{pass=$false;msg='artifact missing'} } else {
      $broken = @()
      $slash = [regex]::Matches($body, '/pe-meta-([a-z0-9-]+)')
      foreach($s in $slash){
        $name = 'pe-meta-' + $s.Groups[1].Value
        $pp = Join-Path $root (".github/prompts/00.09-pe-meta/{0}.prompt.md" -f $name)
        if(-not (Test-Path -LiteralPath $pp)){ $broken += $name }
      }
      $ok = $broken.Count -eq 0
      $results['P-04']=@{pass=$ok;msg=$(if($ok){'delegation/handoff references resolve'}else{'missing delegated targets: ' + ($broken -join ', ')})}
    }
    if(-not $artifactExists){ $results['P-05']=@{pass=$false;msg='artifact missing'} } else {
      $hasBoundaries = $fm -match '(?ms)^boundaries:\s*\r?\n\s*- '
      $hasExcludes = $fm -match '(?ms)^scope:\s*\r?\n(?:\s*covers:.*?\r?\n)?\s*excludes:\s*\r?\n\s*- '
      $ok = $hasBoundaries -and $hasExcludes
      $results['P-05']=@{pass=$ok;msg=$(if($ok){'scope exclusions and boundaries present'}else{'missing scope.excludes or boundaries'})}
    }
  }

  foreach($k in $results.Keys){
    if(-not $results[$k].pass){ $blockers += ($k + ': ' + $results[$k].msg) }
  }

  $globalOrder = @('G-01','G-02','G-03','G-04','G-05')
  $typeOrder = if($artifactType -eq 'agent'){ @('A-01','A-02','A-03','A-04','A-05') } else { @('P-01','P-02','P-03','P-04','P-05') }

  $caseLabelMap = @{
    'G-01'='metadata contract'; 'G-02'='reference integrity'; 'G-03'='scope fidelity'; 'G-04'='boundary compliance'; 'G-05'='versioning discipline';
    'A-01'='agent mode/tool alignment'; 'A-02'='boundary completeness and prohibition compliance'; 'A-03'='handoff contract integrity'; 'A-04'='guidance adherence to loaded context'; 'A-05'='deterministic-first process split and efficiency';
    'P-01'='argument-hint and parameter parsing correctness'; 'P-02'='type dispatch correctness'; 'P-03'='phase ordering and mode behavior correctness'; 'P-04'='delegation/handoff correctness'; 'P-05'='scope and boundary safety'
  }

  $globalLines = @()
  foreach($id in $globalOrder){
    $pass = $results[$id].pass
    $mark = if($pass){'x'} else {' '}
    $globalLines += ('- [' + $mark + '] ' + $id + ' ' + $caseLabelMap[$id])
    $globalLines += ('  Result: ' + $(if($pass){'pass'}else{'fail'}) + ' (' + $results[$id].msg + ')')
  }

  $typeLines = @()
  foreach($id in $typeOrder){
    $pass = $results[$id].pass
    $mark = if($pass){'x'} else {' '}
    $typeLines += ('- [' + $mark + '] ' + $id + ' ' + $caseLabelMap[$id])
    $typeLines += ('  Result: ' + $(if($pass){'pass'}else{'fail'}) + ' (' + $results[$id].msg + ')')
  }

  $state = if($blockers.Count -eq 0){ 'complete' } else { 'failed' }

  # update frontmatter state
  $statusText = [regex]::Replace($statusText, '(?m)^validation_state:\s*"?.*?"?\s*$', 'validation_state: "' + $state + '"')

  # update sections + blockers
  $statusText = Replace-ValidationSections $statusText $globalLines $typeLines $blockers

  # append execution log row
  $note = if($blockers.Count -eq 0){ 'Runbook executed; all cases passed.' } else { 'Runbook executed; blockers: ' + (($blockers | Select-Object -First 3) -join ' | ') }
  $newRow = '| ' + $runDate + ' | copilot | individual | ' + $state + ' | ' + $note + ' |'
  $statusText = [regex]::Replace($statusText, '(?s)(\|---\|---\|---\|---\|---\|\r?\n)(.*)$', ('$1$2' + "`r`n" + $newRow))

  Set-Content -LiteralPath $sf.FullName -Value $statusText -Encoding utf8

  # improvement plan
  $folder = Join-Path $impl ([IO.Path]::GetFileNameWithoutExtension($sf.Name))
  if(-not (Test-Path -LiteralPath $folder)){ New-Item -Path $folder -ItemType Directory | Out-Null }
  $planPath = Join-Path $folder '20260521-improvement-plan.md'
  $planLines = @(
    '---',
    'title: "20260521 improvement plan - ' + ([IO.Path]::GetFileNameWithoutExtension($sf.Name) -replace '^\d+\.\d+-validation-status-','') + '"',
    'author: "Dario Airoldi"',
    'date: "' + $runDate + '"',
    'version: "1.0.0"',
    'status: "draft"',
    'domain: "prompt-engineering"',
    '---',
    '',
    '# Improvement plan',
    '',
    'Validated artifact: `' + $artifactPath + '`',
    'Run timestamp: `' + $runTs + '`',
    'Validation state: `' + $state + '`',
    '',
    '## Findings',
    ''
  )
  if($blockers.Count -eq 0){
    $planLines += '- No blockers detected in this run.'
    $planLines += '- Keep monitoring staleness and rerun after relevant platform or repository changes.'
  } else {
    foreach($b in $blockers){ $planLines += ('- ' + $b) }
  }
  $planLines += @('','## Actions','')
  if($blockers.Count -eq 0){
    $planLines += '- [ ] Re-run this validation in the next scheduled review cycle.'
    $planLines += '- [ ] Re-run immediately if upstream dependencies change.'
  } else {
    foreach($b in $blockers){
      $id = $b.Split(':')[0]
      $planLines += ('- [ ] Fix ' + $id + ' in target artifact and rerun runbook.')
    }
  }
  Set-Content -LiteralPath $planPath -Value $planLines -Encoding utf8

  $summary += [pscustomobject]@{
    File = $sf.Name
    Type = $artifactType
    Artifact = $artifactPath
    State = $state
    Blockers = if($blockers.Count -eq 0){ 'none' } else { ($blockers -join ' | ') }
    LastRun = $runTs
  }
}

# Update master status file table
$masterPath = Join-Path $impl '02.00-validation-status.md'
$masterText = Get-Content -Raw -LiteralPath $masterPath
$masterFm = Get-FrontmatterRaw $masterText

$allRows = @()
$allStatusFiles = Get-ChildItem -Path $impl -Filter '02.*-validation-status-*.md' | Where-Object { $_.Name -ne '02.00-validation-status.md' } | Sort-Object Name
$idx = 1
foreach($f in $allStatusFiles){
  $txt = Get-Content -Raw -LiteralPath $f.FullName
  $fm = Get-FrontmatterRaw $txt
  $type = Get-FrontmatterValue $fm 'artifact_type'
  if([string]::IsNullOrWhiteSpace($type)){ $type = if($f.Name -eq '02.01-validation-status-context-files.md'){'context-set'} else {'unknown'} }
  $artifact = Get-FrontmatterValue $fm 'artifact_path'
  if([string]::IsNullOrWhiteSpace($artifact)){ $artifact = if($f.Name -eq '02.01-validation-status-context-files.md'){'context-whole'} else {'n/a'} }
  $state = Get-FrontmatterValue $fm 'validation_state'
  if([string]::IsNullOrWhiteSpace($state)){ $state = 'not_started' }

  $b = 'none'
  if($txt -match '(?s)### Blockers\r?\n\r?\n(.*?)\r?\n## Execution log'){
    $rawB = $matches[1].Trim()
    if($rawB -and $rawB -ne '- none'){
      $b = ($rawB -replace '\r?\n', ' ')
    }
  }

  $lastRun = 'n/a'
  $rows = [regex]::Matches($txt, '(?m)^\|\s*(\d{4}-\d{2}-\d{2})\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|\s*(.*?)\|\s*$')
  if($rows.Count -gt 0){ $lastRun = $rows[$rows.Count - 1].Groups[1].Value }

  $allRows += ('| ' + $idx + ' | [' + $f.Name + '](' + $f.Name + ') | ' + $type + ' | `' + $artifact + '` | ' + $state + ' | ' + $b + ' | ' + $lastRun + ' |')
  $idx++
}

$table = @(
'| # | Validation file | Type | Target artifact | Status | Blockers | Last run |',
'|---:|---|---|---|---|---|---|'
) + $allRows
$tableText = $table -join "`r`n"

$masterText = [regex]::Replace($masterText, '(?s)\| # \| Validation file \| Type \| Target artifact \| Status \|.*?\r?\n## How to use', $tableText + "`r`n`r`n## How to use")
$masterText = [regex]::Replace($masterText, '(?m)^version:\s*".*"\s*$', 'version: "1.2.0"')
$masterText = [regex]::Replace($masterText, '(?m)^date:\s*".*"\s*$', 'date: "' + $runDate + '"')
Set-Content -LiteralPath $masterPath -Value $masterText -Encoding utf8

# output summary file
$summaryPath = Join-Path $impl 'validation-execution-summary-20260521.json'
$summary | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $summaryPath -Encoding utf8

Write-Output ('Processed artifacts: ' + $summary.Count)
Write-Output ('Master updated: ' + $masterPath)
Write-Output ('Summary: ' + $summaryPath)