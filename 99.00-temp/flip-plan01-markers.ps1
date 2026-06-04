$path = 'c:\dev\darioairoldi\Learn\src\docs\90. Issues\202605\20260525.03-staleness-review\03-pe-meta-update-applied-to-all-pe-contexts\01-vision-update-plan.md'
$content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Flip markers
$content = $content.Replace('(🟡 todo)', '(✅ done)')

# Frontmatter updates
$content = $content.Replace('status: "todo"', 'status: "done"')
$content = $content -replace 'last_updated: "2026-05-29"', 'last_updated: "2026-05-30"'

# Replace inline "Status: Todo" line under H1
$content = $content -replace '\*\*Status:\*\* Todo', '**Status:** Done'

[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))

# Verify
$verify = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
$remaining = [regex]::Matches($verify, '\(🟡 todo\)').Count
Write-Host "Remaining (🟡 todo) markers: $remaining"
$done = [regex]::Matches($verify, '\(✅ done\)').Count
Write-Host "(✅ done) markers: $done"
