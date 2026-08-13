[CmdletBinding()]
param(
    [switch]$Execute
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $repositoryRoot

$contentRoots = @(
    '01.00-news', '02.00-events', '03.00-tech', '04.00-howto',
    '05.00-issues', '06.00-idea', '85.00-other', '90.00-travel'
)
$excludedSegments = @('bin', 'obj', 'node_modules', '.vs', 'sample')
$supportedTextExtensions = @('.md', '.qmd', '.yml', '.yaml', '.json', '.txt', '.html', '.cs', '.razor', '.css', '.js', '.ts', '.ps1')

function ConvertTo-AsciiKebabName {
    param([string]$Name, [bool]$IsDirectory)

    $extension = ''
    $baseName = $Name
    if (-not $IsDirectory) {
        $extensionCandidate = [System.IO.Path]::GetExtension($Name)
        if ($extensionCandidate -match '^\.[A-Za-z0-9]{1,10}$') {
            $extension = $extensionCandidate.ToLowerInvariant()
            $baseName = $Name.Substring(0, $Name.Length - $extension.Length)
        }
    }

    $baseName = $baseName.Replace('æ', 'ae').Replace('Æ', 'ae').Replace('œ', 'oe').Replace('Œ', 'oe')
    $baseName = $baseName.Replace('ß', 'ss').Replace('ø', 'o').Replace('Ø', 'o').Replace('ł', 'l').Replace('Ł', 'l')
    $baseName = $baseName.Normalize([System.Text.NormalizationForm]::FormD)
    $baseName = -join ($baseName.ToCharArray() | Where-Object {
            [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark
        })
    $baseName = $baseName.ToLowerInvariant() -replace '[^a-z0-9.]+', '-'
    $baseName = ($baseName -replace '-{2,}', '-').Trim('-')

    return $baseName + $extension
}

function Test-GitTracked {
    param([string]$RelativePath)

    git ls-files --error-unmatch -- $RelativePath 2>$null | Out-Null
    return $LASTEXITCODE -eq 0
}

$codeProjectRoots = Get-ChildItem -Path $contentRoots -Recurse -File -Include *.sln, *.csproj, *.fsproj, *.vbproj, package.json, pyproject.toml |
ForEach-Object { Split-Path -Path $_.FullName -Parent } |
Sort-Object -Unique

$candidates = foreach ($root in $contentRoots) {
    Get-ChildItem -LiteralPath $root -Recurse -Force | Where-Object {
        $name = $_.Name
        $fullName = $_.FullName
        $segments = $fullName.Substring($repositoryRoot.Length).TrimStart('\').Split('\')
        $isExcluded = $segments | Where-Object {
            $_ -match '^[._]' -or $_ -in $excludedSegments -or $_ -match '_files$'
        }
        $isInCodeProject = $codeProjectRoots | Where-Object {
            [string]::Equals($fullName, $_, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullName.StartsWith($_ + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
        }

        ($name -match '\s' -or $name -cmatch '[A-Z]' -or $name -match '_' -or $name -match '[^\x00-\x7F]') -and
        -not $isExcluded -and -not $isInCodeProject
    }
}

$renames = @($candidates | ForEach-Object {
        $oldFullPath = $_.FullName
        $newName = ConvertTo-AsciiKebabName -Name $_.Name -IsDirectory ([bool]$_.PSIsContainer)
        $newFullPath = Join-Path -Path (Split-Path -Path $oldFullPath -Parent) -ChildPath $newName
        [pscustomobject]@{
            OldFullPath     = $oldFullPath
            NewFullPath     = $newFullPath
            OldRelativePath = $oldFullPath.Substring($repositoryRoot.Length).TrimStart('\')
            NewRelativePath = $newFullPath.Substring($repositoryRoot.Length).TrimStart('\')
            OldName         = $_.Name
            NewName         = $newName
            Depth           = $oldFullPath.Split('\').Count
        }
    } | Sort-Object Depth -Descending)

$mappingCollisions = @($renames | Group-Object NewRelativePath | Where-Object Count -gt 1)
$targetCollisions = @($renames | Where-Object {
        -not [string]::Equals($_.OldFullPath, $_.NewFullPath, [System.StringComparison]::OrdinalIgnoreCase) -and
        (Test-Path -LiteralPath $_.NewFullPath)
    })

Write-Host "Rename candidates: $($renames.Count)"
if ($mappingCollisions -or $targetCollisions) {
    $mappingCollisions | ForEach-Object { $_.Group | Format-Table OldRelativePath, NewRelativePath -AutoSize }
    $targetCollisions | Format-Table OldRelativePath, NewRelativePath -AutoSize
    throw 'Rename collisions detected. No changes were applied.'
}

if (-not $Execute) {
    $renames | Format-Table OldRelativePath, NewRelativePath -AutoSize
    Write-Host 'Dry run complete. Re-run with -Execute to apply changes.'
    return
}

foreach ($rename in $renames) {
    $tracked = Test-GitTracked -RelativePath $rename.OldRelativePath
    $isCaseOnly = $rename.OldName -ieq $rename.NewName -and $rename.OldName -cne $rename.NewName

    if ($isCaseOnly) {
        $temporaryPath = Join-Path -Path (Split-Path -Path $rename.OldFullPath -Parent) -ChildPath "$($rename.NewName).ascii-kebab-tmp"
        if ($tracked) {
            git mv -- $rename.OldFullPath $temporaryPath
            if ($LASTEXITCODE -ne 0) { throw "Temporary Git rename failed: $($rename.OldRelativePath)" }
            git mv -- $temporaryPath $rename.NewFullPath
            if ($LASTEXITCODE -ne 0) { throw "Final Git rename failed: $($rename.OldRelativePath)" }
        }
        else {
            Move-Item -LiteralPath $rename.OldFullPath -Destination $temporaryPath
            Move-Item -LiteralPath $temporaryPath -Destination $rename.NewFullPath
        }
    }
    elseif ($tracked) {
        git mv -- $rename.OldFullPath $rename.NewFullPath
        if ($LASTEXITCODE -ne 0) { throw "Git rename failed: $($rename.OldRelativePath)" }
    }
    else {
        Move-Item -LiteralPath $rename.OldFullPath -Destination $rename.NewFullPath
    }

    if (-not (Test-Path -LiteralPath $rename.NewFullPath)) {
        throw "Rename target was not created: $($rename.NewRelativePath)"
    }
}

$textFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File | Where-Object {
    $_.Extension -in $supportedTextExtensions -and $_.FullName -notmatch '[\\/](\.git|bin|obj|node_modules)[\\/]'
}
$fullPathMaps = $renames | Sort-Object { $_.OldRelativePath.Length } -Descending
$uniqueLeafMaps = $renames | Group-Object OldName | Where-Object Count -eq 1 | ForEach-Object { $_.Group[0] }
$updatedFiles = 0

foreach ($file in $textFiles) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191
    $text = [System.IO.File]::ReadAllText($file.FullName)
    $originalText = $text

    foreach ($rename in $fullPathMaps) {
        $oldSlashPath = $rename.OldRelativePath -replace '\\', '/'
        $newSlashPath = $rename.NewRelativePath -replace '\\', '/'
        $oldUrlPath = (($oldSlashPath -split '/' | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/')
        $newUrlPath = (($newSlashPath -split '/' | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/')
        $text = $text.Replace($rename.OldRelativePath, $rename.NewRelativePath)
        $text = $text.Replace($oldSlashPath, $newSlashPath)
        $text = $text.Replace($oldUrlPath, $newUrlPath)
    }

    foreach ($rename in $uniqueLeafMaps) {
        $pattern = '(?<=[/\\\("' + "'" + '])' + [regex]::Escape($rename.OldName) + '(?=$|[?#\)"' + "'" + '<>\s])'
        $text = [regex]::Replace($text, $pattern, [System.Text.RegularExpressions.MatchEvaluator] { param($match) $rename.NewName })
    }

    if ($text -ne $originalText) {
        [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.UTF8Encoding]::new($hasBom))
        $updatedFiles++
    }
}

Write-Host "Renamed $($renames.Count) article path(s); updated $updatedFiles reference file(s)."