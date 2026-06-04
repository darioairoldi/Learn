$path = 'c:\dev\darioairoldi\Learn\06.00-idea\self-updating-prompt-engineering\20260529.01-vision.v14.md'
$lines = [System.IO.File]::ReadAllLines($path, [System.Text.Encoding]::UTF8)
$i = 0
foreach ($l in $lines) {
    $i++
    $m = [regex]::Matches($l, '\\u[0-9a-fA-F]{4}')
    if ($m.Count -gt 0) {
        $vals = ($m | ForEach-Object { $_.Value }) -join ', '
        Write-Host "Line ${i}: $vals  (len=$($l.Length))"
        Write-Host "  preview: $($l.Substring(0, [Math]::Min(200, $l.Length)))"
    }
}
