# Fix lossy encoding corruption (? = 0x3F) in prompt-engineering series
# Handles code blocks (box-drawing), prose arrows, em dashes, heading emojis

param(
    [string[]]$Files,
    [hashtable]$HeadingMap = @{}
)

$emdash = [string][char]0x2014      # em dash
$arrow = [string][char]0x2192       # right arrow
$vert = [string][char]0x2502        # box vertical bar
$bullet = [string][char]0x2022      # bullet

foreach ($filePath in $Files) {
    if (-not (Test-Path $filePath)) {
        Write-Warning "SKIP (not found): $filePath"
        continue
    }

    $lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)
    $inCode = $false
    $inYaml = $false
    $yamlCount = 0
    $changes = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $original = $lines[$i]

        # Track YAML frontmatter
        if ($lines[$i] -eq '---' -and -not $inCode) {
            $yamlCount++
            if ($yamlCount -eq 1) { $inYaml = $true }
            elseif ($yamlCount -eq 2) { $inYaml = $false }
            continue
        }

        # Track code blocks
        if ($lines[$i] -match '^```') {
            $inCode = -not $inCode
            continue
        }

        if (-not $lines[$i].Contains('?')) { continue }

        if ($inYaml) {
            # YAML: " ? " -> " --- "
            $repl = " $emdash "
            $lines[$i] = $lines[$i] -replace ' \? ', $repl
        }
        elseif ($inCode) {
            $line = $lines[$i]

            # Check if separator line (only contains +, -, ?, whitespace, =)
            $testLine = $line -replace '[+\-?=\s]', ''

            if ($testLine -eq '' -and $line.Contains('?')) {
                # Separator line: all ? -> +
                $lines[$i] = $line -replace '\?', '+'
            }
            else {
                # Content line: all ? -> vertical bar
                $lines[$i] = $line -replace '\?', $vert

                # Fix bullets: vert vert X -> vert bullet X
                $bpat = [regex]::Escape($vert) + ' ' + [regex]::Escape($vert) + ' ([A-Z"' + "'" + '/\[(])'
                $brepl = "$vert $bullet " + '$1'
                $lines[$i] = [regex]::Replace($lines[$i], $bpat, $brepl)        $lines[$i] = [regex]::Replace($lines[$i], $bpat, $brepl)
            }
        }
        else {
            else {
                # Prose (outside code blocks and YAML)
            
                # Em dash: </mark>? -> </mark>---       # Em dash: </mark>? -> </mark>---
                $lines[$i] = $lines[$i] -replace '(</mark>)\?', "`$1$emdash"        $lines[$i] = $lines[$i] -replace '(</mark>)\?', "`$1$emdash"

                # Em dash: letter?letter -> letter---letter           # Em dash: letter?letter -> letter---letter
                $lines[$i] = $lines[$i] -replace '([a-zA-Z])\?([a-zA-Z])', "`$1$emdash`$2"            $lines[$i] = $lines[$i] -replace '([a-zA-Z])\?([a-zA-Z])', "`$1$emdash`$2"

                # Arrows: " ? " -> " -> " (general case)
                $arepl = " $arrow "
                $lines[$i] = $lines[$i] -replace ' \? ', $areple ' \? ', $arepl

                # Heading emojis from mapg emojis from map
                foreach ($pattern in $HeadingMap.Keys) {
                    ach ($pattern in $HeadingMap.Keys) {
                        $emoji = $HeadingMap[$pattern]tern]
                        $lines[$i] = $lines[$i] -replace $pattern, $emoji[$i] -replace $pattern, $emoji
                    }
                }

                if ($lines[$i] -ne $original) { $changes++ }       if ($lines[$i] -ne $original) { $changes++ }
            }

            # Write back with UTF-8 BOM
            $utf8Bom = New-Object System.Text.UTF8Encoding $true8Bom = New-Object System.Text.UTF8Encoding $true
            [System.IO.File]::WriteAllLines($filePath, $lines, $utf8Bom)tf8Bom)

        $fname = Split-Path $filePath -Leaf
        Write-Host "`n=== $fname ==="
        Write-Host "  Fixed $changes lines"

        # Report remaining ?
        $remaining = @()
        for ($j = 0; $j -lt $lines.Count; $j++) {
            if ($lines[$j].Contains('?')) {
                $ctx = $lines[$j].Substring(0, [Math]::Min(100, $lines[$j].Length))
                $remaining += "  L$($j+1): $ctx"
            }
        }
        if ($remaining.Count -gt 0) {
            Write-Host "  Remaining ? ($($remaining.Count) lines):"
            $remaining | ForEach-Object { Write-Host $_ }
        }
        else {
            Write-Host "  No remaining ? characters!"
        }
    }
    $fname = Split-Path $filePath -Leaf
    Write-Host "`n=== $fname ==="
    Write-Host "  Fixed $changes lines"

    # Report remaining ?
    $remaining = @()
    for ($j = 0; $j -lt $lines.Count; $j++) {
        if ($lines[$j].Contains('?')) {
            $ctx = $lines[$j].Substring(0, [Math]::Min(100, $lines[$j].Length))
            $remaining += "  L$($j+1): $ctx"
        }
    }
    if ($remaining.Count -gt 0) {
        Write-Host "  Remaining ? ($($remaining.Count) lines):"
        $remaining | ForEach-Object { Write-Host $_ }
    }
    else {
        Write-Host "  No remaining ? characters!"
    }
}
