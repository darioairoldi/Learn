<#
.SYNOPSIS
  Pre-build image optimizer: create web-optimized ".web" JPEG siblings for large
  images and repoint Markdown references at them.

.DESCRIPTION
  Run this before rendering/committing. For every JPEG larger than -MinSizeKB it
  creates "<name>.web.jpg" next to the original:
    - Longest side clamped to -MaxDimension (never upscales).
    - Re-encoded at -Quality.
    - If the re-encoded result is not smaller than the source, the .web copy
      keeps the ORIGINAL bytes (so a .web file always exists to reference).

  Then it rewrites Markdown/Quarto (*.md, *.qmd) image references from the
  original file to the ".web" file - but only where the .web file actually
  exists on disk (resolved relative to the referencing document), so unrelated
  links are never touched.

  Originals are left in place (nothing is deleted). Re-runnable / idempotent:
  a .web file newer than its source is not regenerated, and references already
  pointing at ".web" are skipped.

  Uses System.Drawing -> run under Windows PowerShell 5.1 (this is what
  dev-pre-build.cmd does), NOT pwsh.

.PARAMETER Root
  Repository root to scan. Defaults to the parent of this script's folder.

.PARAMETER MaxDimension
  Maximum length (px) of the longest side. Default 2000.

.PARAMETER Quality
  JPEG encoder quality (1-100). Default 82.

.PARAMETER MinSizeKB
  Only process JPEGs larger than this. Default 512.

.PARAMETER NoMarkdown
  Only generate .web images; do not rewrite Markdown references.

.PARAMETER WhatIf
  Preview: report what would change without writing any file.

.EXAMPLE
  dev-pre-build.cmd
.EXAMPLE
  powershell -File scripts\pre-build-images.ps1 -MinSizeKB 512 -Quality 82 -MaxDimension 2000
#>
[CmdletBinding()]
param(
    [string]$Root,
    [int]$MaxDimension = 2000,
    [int]$Quality = 82,
    [int]$MinSizeKB = 512,
    [switch]$NoMarkdown,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# Resolve the repo root. Prefer an explicit -Root; otherwise derive it from this
# script's location (scripts\..). Guard against an empty $PSScriptRoot.
if ([string]::IsNullOrWhiteSpace($Root)) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $Root = Join-Path $scriptDir '..'
}
$Root = (Resolve-Path -LiteralPath $Root).Path
Write-Host "Root: $Root"
Write-Host "Rules: > ${MinSizeKB}KB, quality ${Quality}, max ${MaxDimension}px (no upscale)"

# Generated / vendored / build folders that must never be scanned or rewritten.
$excludeDirs = '\\(\.git|\.vs|\.quarto|_freeze|_site|node_modules|bin|obj|docs|README_files|site_libs|themes|exampleSite|public|resources)\\'

# --- JPEG encoder setup ----------------------------------------------------
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [int64]$Quality)

# EXIF orientation (tag 0x0112) -> GDI+ RotateFlip so photos are not rotated.
$orientationMap = @{
    2 = [System.Drawing.RotateFlipType]::RotateNoneFlipX
    3 = [System.Drawing.RotateFlipType]::Rotate180FlipNone
    4 = [System.Drawing.RotateFlipType]::Rotate180FlipX
    5 = [System.Drawing.RotateFlipType]::Rotate90FlipX
    6 = [System.Drawing.RotateFlipType]::Rotate90FlipNone
    7 = [System.Drawing.RotateFlipType]::Rotate270FlipX
    8 = [System.Drawing.RotateFlipType]::Rotate270FlipNone
}

function Get-WebPath([string]$originalFullPath) {
    $dir = [System.IO.Path]::GetDirectoryName($originalFullPath)
    $base = [System.IO.Path]::GetFileNameWithoutExtension($originalFullPath)
    $ext = [System.IO.Path]::GetExtension($originalFullPath)
    return [System.IO.Path]::Combine($dir, "$base.web$ext")
}

# --- Stage 1: generate .web images -----------------------------------------
$images = Get-ChildItem -Path $Root -Recurse -File -Include *.jpg, *.jpeg -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -notmatch $excludeDirs -and
        $_.Name -notlike '*.web.*' -and
        $_.Length -gt ($MinSizeKB * 1KB)
    }

$created = 0; $copied = 0; $upToDate = 0; $beforeBytes = 0L; $afterBytes = 0L
# Absolute paths of .web targets that exist or would exist after this run
# (so -WhatIf and already-current images still drive the Markdown rewrite).
$script:WebSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

foreach ($f in $images) {
    $webPath = Get-WebPath $f.FullName
    $beforeBytes += $f.Length
    [void]$script:WebSet.Add([System.IO.Path]::GetFullPath($webPath))

    if ((Test-Path -LiteralPath $webPath) -and
        ((Get-Item -LiteralPath $webPath).LastWriteTimeUtc -ge $f.LastWriteTimeUtc)) {
        $afterBytes += (Get-Item -LiteralPath $webPath).Length
        $upToDate++
        continue
    }

    $img = $null; $bmp = $null; $ms = $null; $out = $null
    try {
        $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
        $ms = New-Object System.IO.MemoryStream(, $bytes)
        $img = [System.Drawing.Image]::FromStream($ms)

        $orientProp = $img.PropertyItems | Where-Object { $_.Id -eq 0x0112 }
        if ($orientProp) {
            $o = [int]$orientProp.Value[0]
            if ($orientationMap.ContainsKey($o)) { $img.RotateFlip($orientationMap[$o]) }
            $img.RemovePropertyItem(0x0112)
        }

        $w = $img.Width; $h = $img.Height
        $scale = [Math]::Min(1.0, $MaxDimension / [Math]::Max($w, $h))
        $nw = [int][Math]::Round($w * $scale)
        $nh = [int][Math]::Round($h * $scale)

        $bmp = New-Object System.Drawing.Bitmap($nw, $nh)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.DrawImage($img, 0, 0, $nw, $nh)
        $g.Dispose()

        $out = New-Object System.IO.MemoryStream
        $bmp.Save($out, $jpegCodec, $encParams)

        $rel = $f.FullName.Substring($Root.Length).TrimStart('\')
        if ($out.Length -lt $f.Length) {
            if (-not $WhatIf) { [System.IO.File]::WriteAllBytes($webPath, $out.ToArray()) }
            $afterBytes += $out.Length
            $created++
            Write-Host ("  compressed  {0}  ({1:N0}KB -> {2:N0}KB)" -f $rel, ($f.Length / 1KB), ($out.Length / 1KB))
        }
        else {
            # Compression did not help: keep the original bytes as the .web copy.
            if (-not $WhatIf) { [System.IO.File]::WriteAllBytes($webPath, $bytes) }
            $afterBytes += $f.Length
            $copied++
            Write-Host ("  kept-orig   {0}  ({1:N0}KB)" -f $rel, ($f.Length / 1KB))
        }
    }
    catch {
        Write-Warning "Skipped (error) $($f.FullName): $($_.Exception.Message)"
        $afterBytes += $f.Length
    }
    finally {
        if ($out) { $out.Dispose() }
        if ($bmp) { $bmp.Dispose() }
        if ($img) { $img.Dispose() }
        if ($ms) { $ms.Dispose() }
    }
}

Write-Host ""
Write-Host ("Images: {0} compressed, {1} kept-original, {2} up-to-date." -f $created, $copied, $upToDate)
if ($beforeBytes -gt 0) {
    Write-Host ("Payload: {0:N1} MB -> {1:N1} MB" -f ($beforeBytes / 1MB), ($afterBytes / 1MB))
}

if ($NoMarkdown) { Write-Host "Markdown rewrite skipped (-NoMarkdown)."; return }

# --- Stage 2: repoint Markdown references at the .web images ----------------

# Resolve a referenced image URL to the ".web" URL, or $null if it should not
# change. Only rewrites when the target .web file exists on disk.
function Get-WebUrl([string]$url, [string]$mdDir) {
    try {
        if ([string]::IsNullOrWhiteSpace($url)) { return $null }
        if ($url -match '^(https?:|//|data:|#|mailto:|tel:)') { return $null }

        # Split off ?query / #fragment (kept and re-appended verbatim).
        $suffix = ''
        $core = $url
        $qi = $core.IndexOfAny([char[]]@('?', '#'))
        if ($qi -ge 0) { $suffix = $core.Substring($qi); $core = $core.Substring(0, $qi) }
        if ($core -eq '') { return $null }

        # Only image references; skip anything with illegal path characters
        # (Markdown "](...)" also matches tables, templates, odd links, etc.).
        if ($core -notmatch '(?i)\.(jpg|jpeg)$') { return $null }
        if ($core.IndexOfAny([System.IO.Path]::GetInvalidPathChars()) -ge 0) { return $null }

        $leafRaw = ($core -split '[\\/]')[-1]
        if ($leafRaw -match '(?i)\.web\.(jpg|jpeg)$') { return $null }   # already .web

        # Resolve to an absolute path to test the .web file exists.
        $decoded = [uri]::UnescapeDataString($core) -replace '/', '\'
        if ($decoded.IndexOfAny([System.IO.Path]::GetInvalidPathChars()) -ge 0) { return $null }
        if ($decoded.StartsWith('\')) {
            $abs = [System.IO.Path]::GetFullPath((Join-Path $script:Root ($decoded.TrimStart('\'))))
        }
        else {
            $abs = [System.IO.Path]::GetFullPath((Join-Path $mdDir $decoded))
        }
        $webAbs = Get-WebPath $abs
        $webAbsFull = [System.IO.Path]::GetFullPath($webAbs)
        if (-not ((Test-Path -LiteralPath $webAbs) -or $script:WebSet.Contains($webAbsFull))) { return $null }

        # Insert ".web" before the extension in the RAW url (preserve separators/encoding).
        $slash = $core.LastIndexOfAny([char[]]@('/', '\'))
        $rawDir = if ($slash -ge 0) { $core.Substring(0, $slash + 1) } else { '' }
        $rawName = if ($slash -ge 0) { $core.Substring($slash + 1) } else { $core }
        $dot = $rawName.LastIndexOf('.')
        $newName = $rawName.Substring(0, $dot) + '.web' + $rawName.Substring($dot)
        return "$rawDir$newName$suffix"
    }
    catch { return $null }
}

$mdFiles = Get-ChildItem -Path $Root -Recurse -File -Include *.md, *.qmd -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludeDirs }

# Markdown link targets, both plain "](url)" and angle-bracketed "](<url>)"
# (CommonMark uses <...> when the path has spaces/special chars), plus HTML src="url".
$mdAnglePattern = '(\]\(\s*)<([^>]+)>'
$mdPlainPattern = '(\]\(\s*)([^)\s<]+)'
$htmlPattern = '((?:src)\s*=\s*["''])([^"''>\s]+)'

$filesChanged = 0; $refsChanged = 0

foreach ($md in $mdFiles) {
    $script:MdDir = $md.DirectoryName
    $bytes = [System.IO.File]::ReadAllBytes($md.FullName)
    $hadBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $text = [System.IO.File]::ReadAllText($md.FullName)
    $localCount = 0

    $mdAngleEval = {
        param($m)
        $nw = Get-WebUrl $m.Groups[2].Value $script:MdDir
        if ($nw) { $script:localRef++; return $m.Groups[1].Value + '<' + $nw + '>' }
        return $m.Value
    }
    $mdPlainEval = {
        param($m)
        $nw = Get-WebUrl $m.Groups[2].Value $script:MdDir
        if ($nw) { $script:localRef++; return $m.Groups[1].Value + $nw }
        return $m.Value
    }
    $htmlEval = {
        param($m)
        $nw = Get-WebUrl $m.Groups[2].Value $script:MdDir
        if ($nw) { $script:localRef++; return $m.Groups[1].Value + $nw }
        return $m.Value
    }

    $script:localRef = 0
    $new = [regex]::Replace($text, $mdAnglePattern, $mdAngleEval)
    $new = [regex]::Replace($new, $mdPlainPattern, $mdPlainEval)
    $new = [regex]::Replace($new, $htmlPattern, $htmlEval)
    $localCount = $script:localRef

    if ($localCount -gt 0 -and $new -ne $text) {
        $rel = $md.FullName.Substring($Root.Length).TrimStart('\')
        if (-not $WhatIf) {
            $enc = New-Object System.Text.UTF8Encoding($hadBom)
            [System.IO.File]::WriteAllText($md.FullName, $new, $enc)
        }
        $filesChanged++
        $refsChanged += $localCount
        Write-Host ("  updated {0} ref(s) in {1}" -f $localCount, $rel)
    }
}

Write-Host ""
Write-Host ("Markdown: {0} reference(s) repointed across {1} file(s)." -f $refsChanged, $filesChanged)
if ($WhatIf) { Write-Host "(-WhatIf: no files were written.)" }
