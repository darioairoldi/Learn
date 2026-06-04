$paths = @(
  'c:\dev\darioairoldi\Learn\06.00-idea\self-updating-prompt-engineering\20260529.01-vision.v14.md',
  'c:\dev\darioairoldi\Learn\06.00-idea\self-updating-prompt-engineering\20260529.01-vision.v14.changelog.md',
  'c:\dev\darioairoldi\Learn\src\docs\90. Issues\202605\20260525.03-staleness-review\03-pe-meta-update-applied-to-all-pe-contexts\01-vision-update-plan.md'
)
foreach ($p in $paths) {
  $content = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
  $totalEscapes = [regex]::Matches($content, '\\u[0-9a-fA-F]{4}').Count
  $stripped = [regex]::Replace($content, '`[^`]*`', '')
  $bareEscapes = [regex]::Matches($stripped, '\\u[0-9a-fA-F]{4}').Count
  $name = Split-Path -Leaf $p
  Write-Host "${name}: total=$totalEscapes outside-backticks=$bareEscapes"
}
