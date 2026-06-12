# Enhanced link checker with proper URL decoding

# Workspace root derived from the script's location (scripts/ -> repo root) so the
# checker is portable across clones instead of bound to a hardcoded absolute path.
$workspaceRoot = Split-Path $PSScriptRoot -Parent
$brokenLinks = @()
$validLinks = @()

# Function to decode URL-encoded paths
function Decode-UrlPath {
    param($path)
    # URL decode
    $decoded = [System.Uri]::UnescapeDataString($path)
    return $decoded
}

# Function to check if file exists
function Test-FilePath {
    param($path, $sourceFile)
    
    # Decode URL encoding
    $cleanPath = Decode-UrlPath $path
    
    # Remove anchors ONLY if they appear after a valid file extension or at the end
    # This preserves C# in filenames but removes #section-anchors
    if ($cleanPath -match '\.md#' -or $cleanPath -match '\.qmd#') {
        $cleanPath = $cleanPath -replace '#.*$', ''
    }
    
    # Skip external URLs
    if ($cleanPath -match '^https?://') {
        return $true
    }
    
    # Skip anchors only  
    if ($cleanPath -match '^#') {
        return $true
    }
    
    $fullPath = Join-Path $workspaceRoot $cleanPath
    
    $exists = Test-Path $fullPath
    
    if (-not $exists) {
        Write-Host "BROKEN in $sourceFile : $path" -ForegroundColor Red
        Write-Host "  Decoded: $cleanPath" -ForegroundColor Yellow
        Write-Host "  Full path: $fullPath" -ForegroundColor Yellow
    }
    
    return $exists
}

Write-Host "`n=== Checking _quarto.yml ===" -ForegroundColor Cyan

$quartoContent = Get-Content "$workspaceRoot\_quarto.yml" -Raw
$hrefPattern = 'href:\s*"([^"]+)"'
$quartoMatches = [regex]::Matches($quartoContent, $hrefPattern)

foreach ($match in $quartoMatches) {
    $filePath = $match.Groups[1].Value
    
    if (Test-FilePath $filePath "_quarto.yml") {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "_quarto.yml"
            Path = $filePath
        }
    }
}

Write-Host "`n=== Checking index.qmd ===" -ForegroundColor Cyan

$indexContent = Get-Content "$workspaceRoot\index.qmd" -Raw
$markdownLinkPattern = '\[([^\]]+)\]\(([^)]+)\)'
$indexMatches = [regex]::Matches($indexContent, $markdownLinkPattern)

foreach ($match in $indexMatches) {
    $filePath = $match.Groups[2].Value
    
    if (Test-FilePath $filePath "index.qmd") {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "index.qmd"
            Path = $filePath
        }
    }
}

Write-Host "`n=== Checking PE vision changelog ===" -ForegroundColor Cyan

# The changelog lives in a subfolder, so its relative links resolve from the
# changelog's own directory rather than the workspace root.
$changelogRel = "06.00-idea\self-updating-prompt-engineering\20260531.01-vision.changelog.md"
$changelogPath = Join-Path $workspaceRoot $changelogRel
if (Test-Path $changelogPath) {
    $changelogDir = Split-Path $changelogPath -Parent
    $changelogContent = Get-Content $changelogPath -Raw
    $changelogMatches = [regex]::Matches($changelogContent, $markdownLinkPattern)

    foreach ($match in $changelogMatches) {
        $linkPath = $match.Groups[2].Value
        $decoded = Decode-UrlPath $linkPath

        # Strip section anchors after a markdown/qmd extension
        if ($decoded -match '\.md#' -or $decoded -match '\.qmd#') {
            $decoded = $decoded -replace '#.*$', ''
        }

        # Skip external URLs and pure anchors
        if ($decoded -match '^https?://' -or $decoded -match '^#') {
            $validLinks += $linkPath
            continue
        }

        $resolved = Join-Path $changelogDir $decoded
        if (Test-Path $resolved) {
            $validLinks += $linkPath
        } else {
            Write-Host "BROKEN in changelog : $linkPath" -ForegroundColor Red
            Write-Host "  Resolved: $resolved" -ForegroundColor Yellow
            $brokenLinks += [PSCustomObject]@{
                File = $changelogRel
                Path = $linkPath
            }
        }
    }
} else {
    Write-Host "Changelog not found at $changelogPath" -ForegroundColor Yellow
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Valid links: $($validLinks.Count)" -ForegroundColor Green
Write-Host "Broken links: $($brokenLinks.Count)" -ForegroundColor $(if ($brokenLinks.Count -gt 0) { 'Red' } else { 'Green' })

if ($brokenLinks.Count -gt 0) {
    Write-Host "`n=== Broken Links Details ===" -ForegroundColor Yellow
    $brokenLinks | Format-Table -AutoSize
} else {
    Write-Host "`n✅ All links are valid!" -ForegroundColor Green
}
