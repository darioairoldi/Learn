$ErrorActionPreference='Stop'
$root = 'c:/dev/darioairoldi/Learn/06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation'
$statuses = Get-ChildItem -Path $root -Filter '02.*-validation-status-*.md' | Where-Object { $_.Name -notin @('02.01-validation-status-context-files.md','02.02-validation-status-pe-meta-builder.md') } | Sort-Object Name

function Get-FrontmatterValue([string[]]$lines, [string]$key) {
  $pattern = '^' + [regex]::Escape($key) + ':\s*"?(.*?)"?\s*$'
  foreach($line in $lines){ if($line -match $pattern){ return $matches[1] } }
  return ''
}

function Get-CaseLines([string[]]$lines, [string]$headerRegex){
  $startHit = $lines | Select-String -Pattern $headerRegex | Select-Object -First 1
  if(-not $startHit){ return @() }
  $start = $startHit.LineNumber
  $slice = $lines[($start)..($lines.Length-1)]
  $out = @()
  foreach($l in $slice){
    if($l -match '^## '){ break }
    if($l -match '^- \[ \] '){ $out += $l }
  }
  return $out
}

$globalFilenameMap = @{
  'G-01'='01-g01-metadata-contract.prompt.md';
  'G-02'='02-g02-reference-integrity.prompt.md';
  'G-03'='03-g03-scope-fidelity.prompt.md';
  'G-04'='04-g04-boundary-compliance.prompt.md';
  'G-05'='05-g05-versioning-discipline.prompt.md';
}
$agentFilenameMap = @{
  'A-01'='06-a01-mode-tool-alignment.prompt.md';
  'A-02'='07-a02-boundary-completeness.prompt.md';
  'A-03'='08-a03-handoff-contract-integrity.prompt.md';
  'A-04'='09-a04-guidance-adherence.prompt.md';
  'A-05'='10-a05-deterministic-first-efficiency.prompt.md';
}
$promptFilenameMap = @{
  'P-01'='06-p01-argument-parsing.prompt.md';
  'P-02'='07-p02-type-dispatch-correctness.prompt.md';
  'P-03'='08-p03-phase-ordering-mode-behavior.prompt.md';
  'P-04'='09-p04-delegation-handoff-correctness.prompt.md';
  'P-05'='10-p05-scope-boundary-safety.prompt.md';
}

$today = Get-Date -Format 'yyyy-MM-dd'

foreach($sf in $statuses){
  $content = Get-Content -Path $sf.FullName
  $artifactPath = Get-FrontmatterValue $content 'artifact_path'
  $artifactType = (Get-FrontmatterValue $content 'artifact_type').ToLowerInvariant()
  $statusBase = [System.IO.Path]::GetFileNameWithoutExtension($sf.Name)
  $artifactName = $statusBase -replace '^\d+\.\d+-validation-status-',''
  $folder = Join-Path $root $statusBase
  if(-not (Test-Path $folder)){ New-Item -ItemType Directory -Path $folder | Out-Null }

  $globalCases = Get-CaseLines $content '^## Global validation cases'
  $typeCases = Get-CaseLines $content '^## Type-specific validation cases'

  $typeLabel = if($artifactType -eq 'agent'){'agent'} else {'prompt'}
  $bootstrapFile = if($artifactType -eq 'agent'){'00a-bootstrap-create-agent.prompt.md'} else {'00a-bootstrap-create-prompt.prompt.md'}

  $runbookLines = @(
'---',
  ('title: "' + $artifactName + ' validation runbook"'),
'author: "Dario Airoldi"',
  ('date: "' + $today + '"'),
'version: "1.0.0"',
'status: "draft"',
'domain: "prompt-engineering"',
'validation_scope: "individual"',
'---',
'',
"# $artifactName validation runbook",
'',
'Use this runbook when pe-meta orchestration commands are unavailable.',
'',
'## 🎯 Goal',
'',
'Run all global cases and type-specific cases as independent prompt executions, with traceable evidence per case.',
'',
'## 📋 Target artifact',
'',
('- Path: `' + $artifactPath + '`'),
('- Status file: `../' + $sf.Name + '`'),
'',
'## ⚙️ Execution modes',
'',
'1. Preferred: invoke each local prompt file in this folder from Copilot Chat (copy-paste prompt content).',
'2. Do not depend on pe-meta slash commands for completion of this runbook.',
'',
'## ✅ Step-by-step',
'',
'1. Check if the target file exists.',
('2. If missing, run `' + $bootstrapFile + '` first.'),
'3. Run each case prompt file in numeric order.',
'4. Capture result as `pass`, `fail`, or `blocked` with one-line evidence.',
('5. Update checkboxes in `../' + $sf.Name + '`.'),
'6. Add an execution-log row with date, runner, result, and residual blockers.',
'',
'## 🔢 Case order',
''
  )

  $caseOrder = @()
  foreach($g in $globalCases){ if($g -match '^- \[ \] (G-\d\d)'){ $id=$matches[1]; if($globalFilenameMap.ContainsKey($id)){ $caseOrder += $globalFilenameMap[$id] } } }
  foreach($t in $typeCases){
    if($t -match '^- \[ \] ((A|P)-\d\d)'){
      $id=$matches[1]
      if($artifactType -eq 'agent' -and $agentFilenameMap.ContainsKey($id)){ $caseOrder += $agentFilenameMap[$id] }
      if($artifactType -eq 'prompt' -and $promptFilenameMap.ContainsKey($id)){ $caseOrder += $promptFilenameMap[$id] }
    }
  }

  $i=1
  foreach($f in $caseOrder){ $runbookLines += ($i.ToString() + '. `' + $f + '`'); $i++ }

  $runbookLines += @(
'',
'## 📌 Output contract for each case run',
'',
'Use this compact output shape:',
'',
'- Case: G-01|G-02|G-03|G-04|G-05|A-01|A-02|A-03|A-04|A-05|P-01|P-02|P-03|P-04|P-05',
'- Result: pass|fail|blocked',
'- Evidence: 1-3 bullet points',
'- Suggested fix: only when fail or blocked'
  )
  Set-Content -Path (Join-Path $folder '00-runbook.md') -Value $runbookLines -Encoding utf8

  $bootstrapTitle = if($artifactType -eq 'agent'){'create missing agent'} else {'create missing prompt'}
  $bootstrapLines = @(
"# Bootstrap prompt - $bootstrapTitle",
'',
"You are validating one $typeLabel artifact.",
'',
'Target file:',
('`' + $artifactPath + '`'),
'',
'Task:',
'',
'1. Check whether the target file exists.',
'2. If it exists, stop and report `already exists`.',
"3. If it does not exist, create a minimal compliant $typeLabel file with:",
'- valid YAML frontmatter',
'- required metadata fields (`description`, `version`, `last_updated`, `goal`, `scope`, `boundaries`, `rationales`)',
"- the correct file type marker for $typeLabel artifacts",
'- explicit Always/Ask/Never boundary sections (if applicable)',
'- concise structure aligned with repository conventions',
'4. Keep the file concise and structurally valid.',
'5. Return what was created and a short next-step note: `run G-01 next`.',
'',
'Do not validate all rules in this run. Bootstrap only.'
  )
  Set-Content -Path (Join-Path $folder $bootstrapFile) -Value $bootstrapLines -Encoding utf8

  foreach($g in $globalCases){
    if($g -match '^- \[ \] (G-\d\d) (.+)$'){
      $id=$matches[1]; $label=$matches[2]; if(-not $globalFilenameMap.ContainsKey($id)){ continue }
      $fname = $globalFilenameMap[$id]
      $txt = @(
"# $id $label validation prompt",
'',
"Validate $id for this file only:",
('`' + $artifactPath + '`'),
'',
'Checks:',
'',
'1. Evaluate only this case and avoid running other cases.',
('2. Enforce the exact requirement implied by: `' + $id + ' ' + $label + '`.'),
'3. Return concrete, file-grounded evidence (quotes or section references).',
'4. If failed, include the smallest possible fix plan.',
'',
'Output:',
'',
"- Case: $id",
'- Result: pass|fail|blocked',
'- Evidence:',
'- Minimal fix plan (if fail)'
      )
      Set-Content -Path (Join-Path $folder $fname) -Value $txt -Encoding utf8
    }
  }

  foreach($t in $typeCases){
    if($t -match '^- \[ \] ((A|P)-\d\d) (.+)$'){
      $id=$matches[1]; $label=$matches[3]
      $fname = $null
      if($artifactType -eq 'agent' -and $agentFilenameMap.ContainsKey($id)){ $fname = $agentFilenameMap[$id] }
      if($artifactType -eq 'prompt' -and $promptFilenameMap.ContainsKey($id)){ $fname = $promptFilenameMap[$id] }
      if(-not $fname){ continue }
      $txt = @(
"# $id $label validation prompt",
'',
"Validate $id for this file only:",
('`' + $artifactPath + '`'),
'',
'Checks:',
'',
'1. Evaluate only this case and avoid running other cases.',
('2. Enforce the exact requirement implied by: `' + $id + ' ' + $label + '`.'),
('3. Ensure the check is specific to artifact type `' + $artifactType + '`.'),
'4. Return concrete, file-grounded evidence (quotes or section references).',
'5. If failed, include the smallest possible fix plan.',
'',
'Output:',
'',
"- Case: $id",
'- Result: pass|fail|blocked',
'- Evidence:',
'- Minimal fix plan (if fail)'
      )
      Set-Content -Path (Join-Path $folder $fname) -Value $txt -Encoding utf8
    }
  }

  $raw = Get-Content -Path $sf.FullName -Raw
  $bootstrapLine = "Bootstrap runbook (no pe-meta required): [$statusBase/00-runbook.md]($statusBase/00-runbook.md)"
  if($raw -notmatch [regex]::Escape('Bootstrap runbook (no pe-meta required):')){
    $insertAfter = "Artifact type: $artifactType"
    if($raw -match [regex]::Escape($insertAfter)){
      $raw = $raw -replace ([regex]::Escape($insertAfter)), "$insertAfter`r`n`r`n$bootstrapLine"
    }
  }

  if($raw -notmatch '### Bootstrap when pe-meta is not available'){
    $section = @(
'',
'### Bootstrap when pe-meta is not available',
'',
'Run validations from local prompt files in this folder:',
'',
"1. [00-runbook.md]($statusBase/00-runbook.md)",
"2. If artifact is missing: [$bootstrapFile]($statusBase/$bootstrapFile)",
'3. Run each case prompt file in order (`01`..`10`)',
'',
'### Status marking rule when file is initially missing',
'',
'- Mark all cases as `blocked (artifact missing)` in notes before bootstrap.',
'- After bootstrap creation, rerun each case prompt and update checkboxes from those results only.',
''
    ) -join "`r`n"
    $raw = $raw -replace "## Execution log", ($section + "## Execution log")
  }

  Set-Content -Path $sf.FullName -Value $raw -Encoding utf8
}

"DONE: generated runbook sets for $($statuses.Count) status files"
