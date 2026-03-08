$file = 'e:\dev.darioa.live\darioairoldi\Learn\03.00-tech\05.02-prompt-engineering\05-analysis\21.2-appendix_orchestration_plan_specifications.md'
$lines = [System.IO.File]::ReadAllLines($file, [System.Text.Encoding]::UTF8)
$inCodeBlock = $false
$changes = 0

# Define all emoji replacements using Unicode escape sequences
$warn = "$([char]0x26A0)$([char]0xFE0F)"   # warning sign
$check = "$([char]0x2705)"                    # check mark
$cross = "$([char]0x274C)"                    # cross mark
$cycle = [char]::ConvertFromUtf32(0x1F504)    # cycle arrows
$spark = "$([char]0x2728)"                    # sparkles
$chart = [char]::ConvertFromUtf32(0x1F4CA)    # bar chart
$noent = [char]::ConvertFromUtf32(0x1F6AB)    # no entry / prohibited
$sqwht = "$([char]0x2B1C)"                    # white square
$vert = "$([char]0x2502)"                    # box vertical
$branch = "$([char]0x251C)"                    # box branch T
$horiz = "$([char]0x2500)"                    # box horizontal
$darrow = "$([char]0x2193)"                    # down arrow
$rarrow = "$([char]0x2192)"                    # right arrow
$emdash = "$([char]0x2014)"                    # em dash

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    $original = $line

    if ($line -match '^```') {
        $inCodeBlock = !$inCodeBlock
        $lines[$i] = $line
        continue
    }

    if ($inCodeBlock) {
        # ========= CODE BLOCK PATTERNS (flow diagrams) =========

        # 1. Box corners: G?? at top-right corners of boxes
        $line = $line -replace 'G\?\?', '+'

        # 2. Arrows inside boxes: --? at end of horizontal lines
        $line = $line -replace '--\?', "--$rarrow"

        # 3. Warning indicators inside code blocks
        $line = $line -replace '\?\? GATE', "$warn GATE"
        $line = $line -replace '\?\? CRITICAL', "$warn CRITICAL"
        $line = $line -replace '\?\? Preserve', "$warn Preserve"
        $line = $line -replace '\?\? Maintain', "$warn Maintain"
        $line = $line -replace '\?\? Max recursion', "$warn Max recursion"

        # 4. Branch junctions: ??- before dashes
        $line = $line -replace '\?\?-', "$branch$($horiz)$($horiz)"

        # 5. Down arrows: standalone ? on whitespace-only lines (between boxes)
        if ($line -match '^\s+\?\s*$') {
            $line = $line -replace '\?', $darrow
        }

        # 6. Remaining ? in code blocks: box-drawing vertical
        $line = $line -replace '\?', $vert
    }
    else {
        # ========= NON-CODE-BLOCK PATTERNS =========

        # --- Section headings ---
        if ($line -match '^###? ') {
            $line = $line -replace '^\#\# \?\? CRITICAL', "## $warn CRITICAL"
            $line = $line -replace '^\#\#\# \?\? Never Do', "### $noent Never Do"
            $line = $line -replace '^\#\#\# \?\? Ask First', "### $warn Ask First"
            $line = $line -replace '^\#\#\# \? Always Do', "### $check Always Do"
            $line = $line -replace '^\#\#\# \?\? Data Exchange', "### $chart Data Exchange"
        }

        # --- Validation triplets (exact patterns, before individual indicators) ---
        $line = $line -replace '\[\? PASSED / \?\? WARNINGS / \? FAILED\]', "[$check PASSED / $warn WARNINGS / $cross FAILED]"
        $line = $line -replace '\[\?/\?\?/\?\]', "[$check/$warn/$cross]"
        $line = $line -replace '\[\?/\?\]', "[$check/$cross]"

        # --- Status indicators ---
        $line = $line -replace '\?\? UPDATE', "$cycle UPDATE"
        $line = $line -replace '\? CREATE NEW', "$spark CREATE NEW"
        $line = $line -replace '\? NO CHANGES NEEDED', "$check NO CHANGES NEEDED"
        $line = $line -replace '\? NO CHANGES', "$check NO CHANGES"

        # --- PASS/FAIL/WARN (must come before generic arrows) ---
        $line = $line -replace '\?\? <3 tools', "$warn <3 tools"
        $line = $line -replace '\?\? WARN', "$warn WARN"
        $line = $line -replace '\?\? Warning', "$warn Warning"
        $line = $line -replace '\?\? Summary only', "$warn Summary only"
        $line = $line -replace '\?\? Summary', "$warn Summary"
        $line = $line -replace '\? FAIL', "$cross FAIL"
        $line = $line -replace '\? PASS', "$check PASS"
        $line = $line -replace '\? 3-7 tools', "$check 3-7 tools"
        $line = $line -replace '\? >7 tools', "$cross >7 tools"

        # --- Token markers ---
        $line = $line -replace '# \? Token-Heavy', "# $cross Token-Heavy"
        $line = $line -replace '# \? Token-Efficient', "# $check Token-Efficient"

        # --- Table-specific indicators ---
        if ($line -match '^\|') {
            $line = $line -replace '\? Always', "$check Always"
            $line = $line -replace '\? Never', "$cross Never"
            $line = $line -replace '\? References', "$check References"
            $line = $line -replace '\? Key decisions', "$check Key decisions"
            $line = $line -replace '\? Full content', "$check Full content"
            $line = $line -replace '\? Full details', "$check Full details"
            # Implementation plan status cells: ?? | before pipe
            $line = $line -replace '\?\? \|', "$cycle |"
        }

        # --- Checksum markers ---
        $line = $line -replace '\?/\?', "$check/$cross"

        # --- Action items: numbered lists ---
        $line = $line -replace '^(\d+\.) \? ', "`$1 $sqwht "

        # --- Specific em-dashes (no space around ?) ---
        $line = $line -replace 'files\?you', "files${emdash}you"
        $line = $line -replace 'Phase 7\?8', "Phase 7${rarrow}8"

        # --- Generic arrow (remaining ? with spaces) ---
        $line = $line -replace ' \? ', " $rarrow "
    }

    if ($line -ne $original) {
        $lines[$i] = $line
        $changes++
    }
}

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($file, $lines, $utf8NoBom)
Write-Output "Fix complete: $changes lines changed"
