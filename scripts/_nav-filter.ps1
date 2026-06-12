$m = Get-Content 'e:\dev.darioa.live\darioairoldi\Learn\scripts\_nav-missing.txt'
$noise = 'self-updating|autonomous streams|Prompt Engineering & Azure|/\.iqpilot/|202606-build-2026|\.prompt\.md$|/templates/|/agents/|/skills/|/instructions/|/prompts/|/context/|improvement-plan|runbook|validation-status|park-lot|/plans?/|/park/'
$filtered = $m | Where-Object { $_ -notmatch $noise }
$filtered | Set-Content 'e:\dev.darioa.live\darioairoldi\Learn\scripts\_nav-missing-filtered.txt'
Write-Host ("FILTERED COUNT: " + $filtered.Count)
Write-Host '--- FILTERED MISSING ---'
$filtered | ForEach-Object { Write-Host $_ }
