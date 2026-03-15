$file = 'e:\dev.darioa.live\darioairoldi\Learn\03.00-tech\05.02-prompt-engineering\06-reference\01.10-customization_decision_framework_reference.md'
$lines = [System.IO.File]::ReadAllLines($file, [System.Text.Encoding]::UTF8)
$inCodeBlock = $false
$changes = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    $original = $line

    if ($line -match '^```') {
        $inCodeBlock = !$inCodeBlock
        continue
    }
    if ($inCodeBlock) { continue }

    # === TOC entries ===
    if ($line -match '^\- \[') {
        $line = $line -replace '\[\?\? Mechanism comparison', '[📊 Mechanism comparison'
        $line = $line -replace '\[\?\? Quick-reference', '[🔍 Quick-reference'
        $line = $line -replace '\[\?\? Written customizations', '[✏️ Written customizations'
        $line = $line -replace '\[\?\? Identity and capabilities', '[🤖 Identity and capabilities'
        $line = $line -replace '\[\?\? Enforcement', '[⚖️ Enforcement'
        $line = $line -replace '\[\?\? Tool sources', '[🔌 Tool sources'
        $line = $line -replace '\[\?\? Persistent context', '[🧠 Persistent context'
        $line = $line -replace '\[\?\? Specialized decision', '[🌳 Specialized decision'
        $line = $line -replace '\[\?\? Master decision', '[🗺️ Master decision'
        $line = $line -replace '\[\?\? Conclusion', '[🎯 Conclusion'
        $line = $line -replace '\[\?\? References', '[📚 References'
        $line = $line -replace '\(#\?-', '(#-'
    }

    # === Section headings ===
    if ($line -match '^## \?') {
        $line = $line -replace '^## \?\? Mechanism comparison', '## 📊 Mechanism comparison'
        $line = $line -replace '^## \?\? Quick-reference', '## 🔍 Quick-reference'
        $line = $line -replace '^## \?\? Written customizations', '## ✏️ Written customizations'
        $line = $line -replace '^## \?\? Identity and capabilities', '## 🤖 Identity and capabilities'
        $line = $line -replace '^## \?\? Enforcement', '## ⚖️ Enforcement'
        $line = $line -replace '^## \?\? Tool sources', '## 🔌 Tool sources'
        $line = $line -replace '^## \?\? Persistent context', '## 🧠 Persistent context'
        $line = $line -replace '^## \?\? Specialized decision', '## 🌳 Specialized decision'
        $line = $line -replace '^## \?\? Master decision', '## 🗺️ Master decision'
        $line = $line -replace '^## \?\? Conclusion', '## 🎯 Conclusion'
        $line = $line -replace '^## \?\? References', '## 📚 References'
    }

    # === Blockquote cross-ref callouts ===
    if ($line -match '^>') {
        $line = $line -replace '\?\?', '📖'
    }

    # === Table lines: indicators BEFORE generic em-dashes ===
    if ($line -match '^\|') {
        # Status indicators (longer/more specific first)
        $line = $line -replace '\? None', '❌ None'
        $line = $line -replace '\? Not supported', '❌ Not supported'
        $line = $line -replace '\? Not available', '❌ Not available'
        $line = $line -replace '\? Not applicable', '➖ Not applicable'
        $line = $line -replace '\? Full', '✅ Full'
        $line = $line -replace '\? Limited', '⚠️ Limited'
        $line = $line -replace '\? Yes', '✅ Yes'
        $line = $line -replace '\? No\b', '❌ No'
        $line = $line -replace '\? N/A', '➖ N/A'
        $line = $line -replace '\? Via tools', '✅ Via tools'
        $line = $line -replace '\? Via resources', '✅ Via resources'
        $line = $line -replace '\? Via Git', '✅ Via Git'
        $line = $line -replace '\? Via GitHub', '✅ Via GitHub'
        $line = $line -replace '\? Templates', '✅ Templates'
        # Platform indicators
        $line = $line -replace '\?\? VS Code \+ GitHub', '✅ VS Code + GitHub'
        $line = $line -replace '\? VS Code only', '❌ VS Code only'
        $line = $line -replace '\? VS Code \+ VS', '✅ VS Code + VS'
        $line = $line -replace '\? VS Code, CLI, coding', '✅ VS Code, CLI, coding'
        $line = $line -replace '\? VS Code, CLI, Claude', '✅ VS Code, CLI, Claude'
        $line = $line -replace '\? Any MCP client', '✅ Any MCP client'
        $line = $line -replace '\? IDE, CLI, code', '✅ IDE, CLI, code'
        $line = $line -replace '\? GitHub-hosted', '❌ GitHub-hosted'
        $line = $line -replace '\? Any platform', '✅ Any platform'
        # Persistent context table
        $line = $line -replace '\? Personal only', '❌ Personal only'
        $line = $line -replace '\? Follows you', '✅ Follows you'
        $line = $line -replace '\? Per repository', '❌ Per repository'
        $line = $line -replace '\? Multi-repo', '✅ Multi-repo'
        $line = $line -replace '\? Orchestration', '✅ Orchestration'
        # Model routing
        $line = $line -replace '\? `model:`', '✅ `model:`'
        # Winner indicators  
        $line = $line -replace 'Hook \?', 'Hook ✅'
        $line = $line -replace 'Instruction \?', 'Instruction ✅'
        # En-dash ranges (digit?digit)
        $line = $line -replace '(\d+)\?(\d)', '$1–$2'
        # Progression arrows: ) ? → ) →
        $line = $line -replace '\) \? ', ') → '
    }

    # === Generic em-dashes (all non-code-block lines) ===
    $line = $line -replace ' \? ', ' — '

    if ($line -ne $original) {
        $lines[$i] = $line
        $changes++
    }
}

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($file, $lines, $utf8NoBom)
Write-Output "Phase 1 complete: $changes lines changed"
