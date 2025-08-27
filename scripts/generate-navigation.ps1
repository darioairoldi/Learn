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

# Generate navigation.json with correct yq syntax
Write-Host "Extracting navigation structure from _quarto.yml..."
try {
    # Use the correct yq syntax to extract sidebar contents and format as JSON
    $extractedContent = & $yqExecutable eval '.website.sidebar.contents' $quartoFile --output-format=json
    
    # Wrap in the expected structure
    $navigationStructure = @{
        contents = $extractedContent | ConvertFrom-Json
    }
    
    # Convert to JSON and save
    $navigationStructure | ConvertTo-Json -Depth 20 | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
    
    # Validate JSON
    $content = Get-Content $navFile -Raw | ConvertFrom-Json
    Write-Host "? navigation.json generated successfully with $($content.contents.Count) sections"
    
    # Set the modification time to match _quarto.yml to avoid unnecessary regeneration
    $quartoTime = (Get-Item $quartoFile).LastWriteTime
    (Get-Item $navFile).LastWriteTime = $quartoTime
    
    Write-Host "? navigation.json is ready and versioned for commit"
    
} catch {
    Write-Warning "? Failed to generate or validate navigation.json: $_"
    Write-Host "Creating fallback navigation.json..."
    '{"contents": []}' | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
    exit 1
}