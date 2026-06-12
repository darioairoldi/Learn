<#
.SYNOPSIS
    Generates original Build-style session title banners for Build 2025 sessions,
    removes the old (copied) screenshot images, and rewrites markdown references.

.DESCRIPTION
    Build 2025 sessions differ from 2026: the session code + title come from the
    folder name (e.g. "dem581-transforming-microsoft-learn-with-ai"), images are
    stored at the session-folder root (image.png, image-1.png, ...), and several
    markdown renderings may exist (summary.md, readme.sonnet4.md, ...).

    For each target session the script:
      1. Derives the session code (first slug token) and a title-cased title.
      2. Renders an original 1280x720 banner to images/001.01-session-title.png.
         (Black background, color mosaic on the right kept clear of the title,
          readable monospace title on the left, dynamic code badge, no MS logo.)
      3. Removes every old raster image at the session-folder root (unless -KeepOld).
      4. Rewrites every .md file in the folder: the first standalone image line
         becomes the banner (kept in place); any other standalone image lines and
         inline image tokens are removed; files with no image get the banner at top.

    Nothing is copied from Microsoft source slides; every banner is drawn from scratch.

.PARAMETER Root
    Root folder containing the Build 2025 category folders.

.PARAMETER Folder
    Optional single session folder to process instead of all sessions.

.PARAMETER KeepOld
    Keep the old root-level images instead of deleting them.

.EXAMPLE
    ./generate-session-title-2025.ps1 -Folder '...\dem581-transforming-microsoft-learn-with-ai'

.EXAMPLE
    ./generate-session-title-2025.ps1
    Process every Build 2025 session.
#>
[CmdletBinding()]
param(
    [string]$Root = (Join-Path $PSScriptRoot '..\02.00-events\202506-build-2025'),
    [string]$Folder,
    [switch]$KeepOld
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$Palette = @(
    [System.Drawing.Color]::FromArgb(91, 197, 0),    # green
    [System.Drawing.Color]::FromArgb(0, 164, 239),   # blue
    [System.Drawing.Color]::FromArgb(242, 80, 34),   # orange-red
    [System.Drawing.Color]::FromArgb(255, 185, 0),   # yellow
    [System.Drawing.Color]::FromArgb(232, 17, 35),   # red
    [System.Drawing.Color]::FromArgb(134, 97, 197),  # purple
    [System.Drawing.Color]::FromArgb(0, 183, 195),   # teal
    [System.Drawing.Color]::FromArgb(0, 120, 212)    # dark blue
)

# Slug tokens that map to a fixed display form.
$Special = @{
    'ai' = 'AI'; 'api' = 'API'; 'apis' = 'APIs'; 'sdk' = 'SDK'; 'mcp' = 'MCP';
    'ml' = 'ML'; 'rag' = 'RAG'; 'ux' = 'UX'; 'ui' = 'UI'; 'vs' = 'VS';
    'ide' = 'IDE'; 'llm' = 'LLM'; 'llms' = 'LLMs'; 'dotnet' = '.NET';
    'csharp' = 'C#'; 'cs' = 'C#'; 'm365' = 'M365'; '365' = '365';
    'powertoys' = 'PowerToys'; 'copilot' = 'Copilot'; 'github' = 'GitHub';
    'microsoft' = 'Microsoft'; 'azure' = 'Azure'; 'windows' = 'Windows';
    'foundry' = 'Foundry'; 'aspire' = 'Aspire'; 'playwright' = 'Playwright';
    'git' = 'Git'; 'sentry' = 'Sentry'; 'qa' = 'Q&A'
}
# Small words kept lowercase unless first.
$Small = @('a', 'an', 'the', 'and', 'but', 'or', 'nor', 'for', 'on', 'at',
    'to', 'by', 'of', 'in', 'with', 'as', 'from', 'into')

function Convert-SlugToTitle {
    param([Parameter(Mandatory)][string]$Slug)
    $tokens = $Slug -split '-'
    $out = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        $t = $tokens[$i]
        if ($t -eq '') { continue }
        $low = $t.ToLower()
        if ($Special.ContainsKey($low)) { $out.Add($Special[$low]); continue }
        if (($i -gt 0) -and ($Small -contains $low)) { $out.Add($low); continue }
        $out.Add($t.Substring(0, 1).ToUpper() + $t.Substring(1).ToLower())
    }
    return ($out -join ' ')
}

function New-TitleImage {
    param(
        [Parameter(Mandatory)][string]$Code,
        [Parameter(Mandatory)][string]$Title,
        [string]$Speakers = '',
        [Parameter(Mandatory)][string]$OutPath
    )

    $W = 1280; $H = 720
    $bmp = New-Object System.Drawing.Bitmap($W, $H)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # --- Warm brown -> amber diagonal gradient background ---
    $bgRect = New-Object System.Drawing.Rectangle 0, 0, $W, $H
    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $bgRect,
        [System.Drawing.Color]::FromArgb(24, 12, 7),
        [System.Drawing.Color]::FromArgb(120, 52, 18),
        20.0)
    $g.FillRectangle($grad, $bgRect)
    $grad.Dispose()

    # --- Warm glow concentrated on the right (thin band, keeps left dark) ---
    $glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $glowPath.AddEllipse(920, 70, 520, 600)
    $pgb = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
    $pgb.CenterPoint = New-Object System.Drawing.PointF(1160, 370)
    $pgb.CenterColor = [System.Drawing.Color]::FromArgb(200, 250, 155, 65)
    $pgb.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 250, 155, 65))
    $g.FillPath($pgb, $glowPath)
    $pgb.Dispose(); $glowPath.Dispose()

    # --- Abstract translucent crystalline shapes on the right ---
    $shapeRand = New-Object System.Random 20250519
    $warm = @(
        [System.Drawing.Color]::FromArgb(120, 255, 170, 80),
        [System.Drawing.Color]::FromArgb(110, 230, 120, 40),
        [System.Drawing.Color]::FromArgb(100, 180, 70, 30),
        [System.Drawing.Color]::FromArgb(90, 255, 210, 140),
        [System.Drawing.Color]::FromArgb(110, 200, 90, 35)
    )
    for ($i = 0; $i -lt 16; $i++) {
        $cx = $shapeRand.Next(900, 1240)
        $cy = $shapeRand.Next(40, 680)
        $size = $shapeRand.Next(70, 230)
        $sides = $shapeRand.Next(3, 5)
        $pts = New-Object System.Collections.Generic.List[System.Drawing.PointF]
        for ($k = 0; $k -lt $sides; $k++) {
            $px = $cx + $shapeRand.Next(-$size, $size)
            $py = $cy + $shapeRand.Next(-$size, $size)
            $pts.Add((New-Object System.Drawing.PointF($px, $py)))
        }
        $col = $warm[$shapeRand.Next(0, $warm.Count)]
        $sb = New-Object System.Drawing.SolidBrush $col
        $g.FillPolygon($sb, $pts.ToArray())
        $sb.Dispose()
    }

    # --- Adaptive word-wrap for the title ---
    $marginX = 66
    $maxTextWidth = 660
    $fontSizes = 46, 40, 36, 32, 28, 24, 22, 20
    $titleFont = $null
    $lines = $null
    foreach ($fs in $fontSizes) {
        $f = New-Object System.Drawing.Font('Consolas', $fs, [System.Drawing.FontStyle]::Bold)
        $words = $Title -split '\s+'
        $cur = ''
        $wrapped = New-Object System.Collections.Generic.List[string]
        foreach ($word in $words) {
            $candidate = if ($cur -eq '') { $word } else { "$cur $word" }
            if ($g.MeasureString($candidate, $f).Width -le $maxTextWidth) {
                $cur = $candidate
            }
            else {
                if ($cur -ne '') { $wrapped.Add($cur) }
                $cur = $word
            }
        }
        if ($cur -ne '') { $wrapped.Add($cur) }
        if ($wrapped.Count -le 6) { $titleFont = $f; $lines = $wrapped; break }
        $f.Dispose()
    }
    if ($null -eq $titleFont) {
        $titleFont = New-Object System.Drawing.Font('Consolas', 20, [System.Drawing.FontStyle]::Bold)
        $lines = $wrapped
    }

    $lineHeight = [int]($titleFont.GetHeight($g) * 1.12)
    $titleBlockHeight = $lineHeight * $lines.Count

    # --- Wrap speakers (max 2 lines) ---
    $spkFont = New-Object System.Drawing.Font('Segoe UI', 21, [System.Drawing.FontStyle]::Regular)
    $spkLines = New-Object System.Collections.Generic.List[string]
    if ($Speakers -and $Speakers.Trim() -ne '') {
        $words = $Speakers -split '\s+'
        $cur = ''
        foreach ($word in $words) {
            $candidate = if ($cur -eq '') { $word } else { "$cur $word" }
            if ($g.MeasureString($candidate, $spkFont).Width -le $maxTextWidth) {
                $cur = $candidate
            }
            else {
                if ($cur -ne '') { $spkLines.Add($cur) }
                $cur = $word
            }
        }
        if ($cur -ne '') { $spkLines.Add($cur) }
        while ($spkLines.Count -gt 2) {
            $spkLines[1] = ($spkLines[1].TrimEnd('.', ' ') + '…')
            $spkLines.RemoveAt($spkLines.Count - 1)
        }
    }
    $spkLineHeight = [int]($spkFont.GetHeight($g) * 1.15)
    $spkGap = if ($spkLines.Count -gt 0) { 28 } else { 0 }
    $spkBlockHeight = $spkLineHeight * $spkLines.Count

    $blockHeight = $titleBlockHeight + $spkGap + $spkBlockHeight
    $regionTop = 175; $regionBottom = 560
    $blockTop = [int](($regionTop + $regionBottom) / 2 - $blockHeight / 2)
    if ($blockTop -lt $regionTop) { $blockTop = $regionTop }

    # --- Session code (plain text, top-right) ---
    $codeFont = New-Object System.Drawing.Font('Consolas', 22, [System.Drawing.FontStyle]::Bold)
    $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $codeW = $g.MeasureString($Code, $codeFont).Width
    $g.DrawString($Code, $codeFont, $white, ($W - $marginX - $codeW), 44)

    # --- Title text (white, readable on the dark-brown left) ---
    $titleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 248, 248))
    $y = $blockTop
    foreach ($ln in $lines) {
        $g.DrawString($ln, $titleFont, $titleBrush, $marginX, $y)
        $y += $lineHeight
    }

    # --- Speakers (under the title) ---
    if ($spkLines.Count -gt 0) {
        $y += $spkGap
        $spkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 214, 170))
        foreach ($ln in $spkLines) {
            $g.DrawString($ln, $spkFont, $spkBrush, $marginX, $y)
            $y += $spkLineHeight
        }
    }

    # --- Event caption (plain text, no logo) ---
    $capFont = New-Object System.Drawing.Font('Segoe UI', 20, [System.Drawing.FontStyle]::Bold)
    $capBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235, 235, 235))
    $g.DrawString('Microsoft Build', $capFont, $capBrush, $marginX, 618)

    $dir = Split-Path $OutPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}

function Update-Markdown {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$BannerMd
    )
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    $raw = [System.IO.File]::ReadAllText($Path)
    $nl = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
    $lines = $raw -split "`r?`n"

    $imgLine = '^\s*!\[[^\]]*\]\([^)]+\)\s*$'
    $inlineImg = '!\[[^\]]*\]\([^)]+\)'

    # 1) Strip every existing image (standalone lines and inline tokens).
    $stripped = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match $imgLine) { continue }
        if ($line -match $inlineImg) { $line = [regex]::Replace($line, $inlineImg, '') }
        $stripped.Add($line)
    }
    # Trim leading blank lines left behind by a stripped top image.
    while ($stripped.Count -gt 0 -and $stripped[0].Trim() -eq '') { $stripped.RemoveAt(0) }
    # Collapse runs of blank lines (artifacts of stripped images) into one.
    $collapsed = New-Object System.Collections.Generic.List[string]
    $prevBlank = $false
    foreach ($l in $stripped) {
        $isBlank = ($l.Trim() -eq '')
        if ($isBlank -and $prevBlank) { continue }
        $collapsed.Add($l)
        $prevBlank = $isBlank
    }
    $stripped = $collapsed

    # 2) Find the end of the session-metadata block so the banner can go
    #    UNDER the metadata and BEFORE the Table of Contents / first section.
    $h1 = -1
    for ($i = 0; $i -lt $stripped.Count; $i++) {
        if ($stripped[$i] -match '^#\s+\S') { $h1 = $i; break }
    }

    $result = New-Object System.Collections.Generic.List[string]
    if ($h1 -lt 0) {
        # No H1: place the banner at the very top.
        $result.Add($BannerMd)
        $result.Add('')
        foreach ($l in $stripped) { $result.Add($l) }
        [System.IO.File]::WriteAllText($Path, ($result -join $nl), $utf8NoBom)
        return
    }

    $metaHeading = '^#{1,6}\s+.*(overview|session\s+details|session\s+info)'
    $field = '^\s*\*\*[^*]+:\*\*'
    $bullet = '^\s*[-*]\s+\S'
    $lastMeta = $h1
    $seenField = $false
    for ($k = $h1 + 1; $k -lt $stripped.Count; $k++) {
        $t = $stripped[$k].Trim()
        if ($t -eq '') { continue }                              # blank: keep scanning
        if ($t -match $field) { $seenField = $true; $lastMeta = $k; continue }
        if ($seenField -and ($t -match $bullet)) { $lastMeta = $k; continue }
        if (-not $seenField -and ($stripped[$k] -match $metaHeading)) { $lastMeta = $k; continue }
        break                                                    # first body line: stop
    }

    # 3) Rebuild: head (through metadata) + banner + remaining body.
    for ($i = 0; $i -le $lastMeta; $i++) { $result.Add($stripped[$i]) }
    $result.Add('')
    $result.Add($BannerMd)

    # Skip leading blank lines of the tail to avoid a double gap.
    $j = $lastMeta + 1
    while ($j -lt $stripped.Count -and $stripped[$j].Trim() -eq '') { $j++ }
    if ($j -lt $stripped.Count) {
        $result.Add('')
        for ($i = $j; $i -lt $stripped.Count; $i++) { $result.Add($stripped[$i]) }
    }

    [System.IO.File]::WriteAllText($Path, ($result -join $nl), $utf8NoBom)
}

function Get-SessionSpeakers {
    param([Parameter(Mandatory)][string]$FolderPath)

    # Prefer readme*.md, then summary.md.
    $files = @()
    $files += Get-ChildItem -Path $FolderPath -Filter 'readme*.md' -ErrorAction SilentlyContinue
    $files += Get-ChildItem -Path $FolderPath -Filter 'summary.md' -ErrorAction SilentlyContinue

    foreach ($f in $files) {
        $lines = Get-Content $f.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $m = [regex]::Match($lines[$i], '^\s*\*\*Speakers?:\*\*\s*(.*)$')
            if (-not $m.Success) { continue }

            $raw = $m.Groups[1].Value.Trim()
            $entries = New-Object System.Collections.Generic.List[string]

            if ($raw -ne '') {
                # Inline: "Name (role), Name (role)". Strip parentheticals first
                # (roles can contain commas), then split on commas / ampersands.
                $clean = [regex]::Replace($raw, '\([^)]*\)', '')
                foreach ($part in ($clean -split '\s*,\s*|\s+&\s+|\s+and\s+')) { $entries.Add($part) }
            }
            else {
                # Bullet list on following lines.
                for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                    $b = [regex]::Match($lines[$j], '^\s*[-*]\s+(.+)$')
                    if ($b.Success) { $entries.Add($b.Groups[1].Value); continue }
                    if ($lines[$j].Trim() -eq '') { continue }
                    break
                }
            }

            # Clean each entry down to a person name.
            $names = New-Object System.Collections.Generic.List[string]
            foreach ($e in $entries) {
                $n = $e
                $n = [regex]::Replace($n, '\([^)]*\)', '')  # drop "(role)"
                $n = ($n -split ' - ')[0]     # drop " - Moderator"
                $n = ($n -split ' – ')[0]     # en dash variant
                $n = $n -replace '[*_`]', ''  # strip markdown
                $n = $n.Trim().TrimEnd(',', ' ')
                if ($n -ne '') { $names.Add($n) }
            }

            # Dedupe, preserve order.
            $seen = @{}
            $uniq = New-Object System.Collections.Generic.List[string]
            foreach ($n in $names) {
                if (-not $seen.ContainsKey($n.ToLower())) { $seen[$n.ToLower()] = $true; $uniq.Add($n) }
            }
            if ($uniq.Count -eq 0) { continue }

            if ($uniq.Count -le 3) { return ($uniq -join ', ') }
            return (($uniq[0..1] -join ', ') + ', and ' + ($uniq.Count - 2) + ' more')
        }
    }
    return ''
}

# --- Enumerate target session folders ---
if ($Folder) {
    $sessions = @(Get-Item $Folder)
}
else {
    $sessions = Get-ChildItem -Path $Root -Directory |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Directory }
}

$count = 0
foreach ($sess in $sessions) {
    $slug = $sess.Name
    $code = (($slug -split '-')[0]).ToUpper()
    $titleSlug = $slug.Substring($slug.IndexOf('-') + 1)
    $title = Convert-SlugToTitle -Slug $titleSlug
    $speakers = Get-SessionSpeakers -FolderPath $sess.FullName

    $imgDir = Join-Path $sess.FullName 'images'
    $outPng = Join-Path $imgDir 'session-banner.png'
    New-TitleImage -Code $code -Title $title -Speakers $speakers -OutPath $outPng

    $banner = '![{0}](images/session-banner.png)' -f $title

    foreach ($md in Get-ChildItem -Path $sess.FullName -Filter '*.md') {
        Update-Markdown -Path $md.FullName -BannerMd $banner
    }

    if (-not $KeepOld) {
        # Remove root-level raster images.
        Get-ChildItem -Path $sess.FullName -File |
            Where-Object { $_.Extension -in '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp' } |
            Remove-Item -Force
        # Remove every image in images/ except the new shared banner.
        if (Test-Path $imgDir) {
            Get-ChildItem -Path $imgDir -File |
                Where-Object { ($_.Name -ne 'session-banner.png') -and ($_.Extension -in '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp') } |
                Remove-Item -Force
        }
    }

    Write-Host ("[{0}] {1}" -f $code, $title)
    $count++
}

Write-Host "Processed $count Build 2025 session(s)."
