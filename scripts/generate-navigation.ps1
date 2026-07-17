# Generate navigation.json from _quarto.yml (only when needed)
Write-Host "Checking navigation.json status..."

# Check if navigation.json exists and compare timestamps
$shouldGenerate = $false
$quartoFile = "_quarto.yml"
$navFile = "navigation.json"

if (-not (Test-Path $quartoFile)) {
    Write-Warning "_quarto.yml not found - cannot generate navigation.json"
    exit 1
}

if (-not (Test-Path $navFile)) {
    Write-Host "navigation.json does not exist - will generate"
    $shouldGenerate = $true
} else {
    $quartoModified = (Get-Item $quartoFile).LastWriteTime
    $navModified = (Get-Item $navFile).LastWriteTime
    
    if ($quartoModified -gt $navModified) {
        Write-Host "navigation.json is older than _quarto.yml - will regenerate"
        $shouldGenerate = $true
    } else {
        Write-Host "navigation.json is up to date - skipping generation"
        $shouldGenerate = $false
    }
}

if (-not $shouldGenerate) {
    Write-Host "? navigation.json is current, no action needed"
    exit 0
}

Write-Host "Generating navigation.json..."

# Check if yq is available
$yqPath = Get-Command yq -ErrorAction SilentlyContinue
if (-not $yqPath) {
    # Download yq if not available
    $yqVersion = "v4.40.5"
    $yqUrl = "https://github.com/mikefarah/yq/releases/download/$yqVersion/yq_windows_amd64.exe"
    
    Write-Host "Downloading yq..."
    try {
        Invoke-WebRequest -Uri $yqUrl -OutFile "yq.exe" -UseBasicParsing
        $yqExecutable = ".\yq.exe"
    } catch {
        Write-Error "Failed to download yq: $_"
        exit 1
    }
} else {
    $yqExecutable = "yq"
}

# Generate navigation.json with correct structure.
# Quarto sidebar entries may use GLOB contents (e.g. "path/**/*.md"). Quarto expands those
# at build time, but the markdown-first Learn.Web app reads navigation.json directly and
# needs explicit child arrays. So after extracting the sidebar we expand every glob-string
# `contents` into concrete { text, href } children (title taken from each file's frontmatter
# `title:`, else its first H1, else a prettified file name).
Write-Host "Extracting navigation structure from _quarto.yml..."

$repoRoot = (Get-Location).Path

function Get-DocTitle([string]$fullPath) {
    try { $text = [System.IO.File]::ReadAllText($fullPath) } catch { return $null }
    if ($text -match '(?s)^\s*---\s*\r?\n(.*?)\r?\n---') {
        $fm = $Matches[1]
        if ($fm -match '(?m)^\s*title\s*:\s*(.+?)\s*$') {
            $t = $Matches[1].Trim().Trim('"').Trim("'")
            if ($t) { return $t }
        }
    }
    if ($text -match '(?m)^\#\s+(.+?)\s*$') { return $Matches[1].Trim() }
    return $null
}

function Get-PrettyName([string]$fileName) {
    $n = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $n = $n -replace '^[0-9][0-9.]*[._-]*', ''
    $n = ($n -replace '[-_]', ' ').Trim()
    if (-not $n) { $n = [System.IO.Path]::GetFileNameWithoutExtension($fileName) }
    return (Get-Culture).TextInfo.ToTitleCase($n)
}

# Build a nested node tree for a folder: .md files become links; subfolders (for recursive
# globs) become sub-sections, mirroring Quarto's auto-sidebar. Returns [ordered] hashtables.
function Build-Tree([string]$baseDir, [bool]$recurse, [string]$parentHref) {
    $nodes = @()
    $files = Get-ChildItem -LiteralPath $baseDir -File -Filter *.md -ErrorAction SilentlyContinue | Sort-Object Name
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($repoRoot.Length).TrimStart('\', '/') -replace '\\', '/'
        if ($parentHref -and ($rel -ieq ($parentHref -replace '\\', '/'))) { continue }
        $title = Get-DocTitle $f.FullName
        if (-not $title) { $title = Get-PrettyName $f.Name }
        $nodes += [ordered]@{ text = $title; href = $rel }
    }
    if ($recurse) {
        $subdirs = Get-ChildItem -LiteralPath $baseDir -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -ne 'images' } | Sort-Object Name
        foreach ($d in $subdirs) {
            $children = Build-Tree $d.FullName $true $null
            if ($children -and $children.Count -gt 0) {
                $nodes += [ordered]@{ section = (Get-PrettyName $d.Name); contents = $children }
            }
        }
    }
    return , $nodes
}

# Serialize one node to JSON. Objects are emitted individually (arrays built by string join),
# which avoids PowerShell 5.1's single-element-array collapsing.
function Emit-Node($node) {
    if ($node.Contains('contents')) {
        $childJson = @($node.contents | ForEach-Object { Emit-Node $_ }) -join ','
        $sec = ($node.section | ConvertTo-Json -Compress)
        return '{"section":' + $sec + ',"contents":[' + $childJson + ']}'
    }
    $t = ($node.text | ConvertTo-Json -Compress)
    $h = ($node.href | ConvertTo-Json -Compress)
    return '{"text":' + $t + ',"href":' + $h + '}'
}

function Expand-GlobJson([string]$glob, [string]$parentHref) {
    $recurse = $glob -match '\*\*'
    $dir = $glob -replace '/\*\*/\*\.md$', '' -replace '/\*\.md$', ''
    $dir = $dir.TrimEnd('/')
    if (-not (Test-Path -LiteralPath $dir)) { return '[]' }
    $tree = Build-Tree $dir $recurse $parentHref
    if (-not $tree -or $tree.Count -eq 0) { return '[]' }
    return '[' + (@($tree | ForEach-Object { Emit-Node $_ }) -join ',') + ']'
}

# Collect every glob-string `contents` in the parsed tree (with its parent href, so we can
# avoid listing the section's own landing page twice).
function Find-Globs($nodeList, $sink) {
    foreach ($n in $nodeList) {
        if ($n.PSObject.Properties.Name -contains 'contents') {
            if ($n.contents -is [string]) {
                [void]$sink.Add([pscustomobject]@{ glob = $n.contents; href = $n.href })
            } elseif ($n.contents) {
                Find-Globs $n.contents $sink
            }
        }
    }
}

try {
    # Extract the sidebar contents as JSON using yq (returns an array of text lines).
    $sidebarJson = & $yqExecutable eval '.website.sidebar.contents' $quartoFile --output-format=json
    $sidebarText = ($sidebarJson -join "`n")

    if (-not $sidebarText -or $sidebarText.Trim() -eq "null") {
        Write-Warning "No sidebar contents found in _quarto.yml"
        '{"contents": []}' | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
        exit 1
    }

    $fullText = '{"contents": ' + $sidebarText + '}'

    # Parse only to discover the glob strings, then surgically replace each glob value in the
    # original (array-correct) JSON text with its expanded child array. Each child object is
    # serialized individually, which sidesteps PowerShell 5.1's single-element-array quirk.
    $parsed = $fullText | ConvertFrom-Json
    $globs = New-Object System.Collections.ArrayList
    Find-Globs $parsed.contents $globs

    foreach ($g in $globs) {
        $arrayJson = Expand-GlobJson $g.glob $g.href
        $fullText = $fullText.Replace('"' + $g.glob + '"', $arrayJson)
    }

    # Write BOM-less UTF-8 so System.Text.Json parses it cleanly.
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Join-Path $repoRoot $navFile), $fullText, $utf8)

    # Validate JSON by parsing it, and confirm no glob strings remain.
    try {
        $testContent = Get-Content $navFile -Raw | ConvertFrom-Json
        $itemCount = if ($testContent.contents -is [array]) { $testContent.contents.Count } else { 0 }
        $remainingGlobs = 0
        function Count-Globs($list) { foreach ($x in $list) { if ($x.contents -is [string]) { $script:remainingGlobs++ } elseif ($x.contents) { Count-Globs $x.contents } } }
        Count-Globs $testContent.contents
        Write-Host "OK navigation.json generated with $itemCount top-level sections; unexpanded globs remaining: $remainingGlobs"
    } catch {
        Write-Warning "JSON validation failed: $_"
    }

    # Set the modification time to match _quarto.yml to avoid unnecessary regeneration
    $quartoTime = (Get-Item $quartoFile).LastWriteTime
    (Get-Item $navFile).LastWriteTime = $quartoTime

    Write-Host "OK navigation.json is ready and versioned for commit"

} catch {
    Write-Warning "Failed to generate or validate navigation.json: $_"
    Write-Host "Creating fallback navigation.json..."
    '{"contents": []}' | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
    exit 1
}