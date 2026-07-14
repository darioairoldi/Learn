<#
.SYNOPSIS
  Downscale and re-encode large JPEG images in place to shrink a static-site
  deploy package.

.DESCRIPTION
  Intended to run against the rendered Quarto output (docs/) AFTER render and
  BEFORE deploy. Source images are never touched - only the disposable build
  artifact is compressed, so full-resolution originals remain in the repo.

  Uses System.Drawing, which is available out of the box under Windows
  PowerShell 5.1 (run this script with `shell: powershell`, not `pwsh`).
  EXIF orientation is applied before resizing so phone photos are not rotated.

.PARAMETER Path
  Root folder to process recursively (e.g. "docs").

.PARAMETER MaxDimension
  Maximum length (px) of the longest side. Larger images are downscaled,
  preserving aspect ratio. Smaller images keep their dimensions.

.PARAMETER Quality
  JPEG encoder quality (1-100).

.PARAMETER MinSizeKB
  Only process JPEGs larger than this. Small images are left alone.

.EXAMPLE
  powershell -File scripts/compress-images.ps1 -Path docs -MaxDimension 2000 -Quality 82 -MinSizeKB 400
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [int]$MaxDimension = 2000,
    [int]$Quality = 82,
    [int]$MinSizeKB = 400
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $Path)) {
    Write-Error "Path not found: $Path"
    exit 1
}

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [int64]$Quality)

# EXIF orientation (tag 0x0112) -> GDI+ RotateFlip operation.
$orientationMap = @{
    2 = [System.Drawing.RotateFlipType]::RotateNoneFlipX
    3 = [System.Drawing.RotateFlipType]::Rotate180FlipNone
    4 = [System.Drawing.RotateFlipType]::Rotate180FlipX
    5 = [System.Drawing.RotateFlipType]::Rotate90FlipX
    6 = [System.Drawing.RotateFlipType]::Rotate90FlipNone
    7 = [System.Drawing.RotateFlipType]::Rotate270FlipX
    8 = [System.Drawing.RotateFlipType]::Rotate270FlipNone
}

$files = Get-ChildItem -Path $Path -Recurse -File -Include *.jpg, *.jpeg |
Where-Object { $_.Length -gt ($MinSizeKB * 1KB) }

if (-not $files) {
    Write-Host "No JPEGs larger than ${MinSizeKB}KB under '$Path' - nothing to do."
    exit 0
}

$before = 0L
$after = 0L
$processed = 0
$skipped = 0

foreach ($f in $files) {
    $originalLength = $f.Length
    $before += $originalLength
    $img = $null; $bmp = $null; $ms = $null; $out = $null
    try {
        # Read fully into memory so the file on disk is not locked and can be
        # overwritten with the compressed result.
        $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
        $ms = New-Object System.IO.MemoryStream(, $bytes)
        $img = [System.Drawing.Image]::FromStream($ms)

        # Apply EXIF orientation, then drop the tag (pixels are now upright).
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

        # Only overwrite when we actually saved bytes.
        if ($out.Length -lt $originalLength) {
            [System.IO.File]::WriteAllBytes($f.FullName, $out.ToArray())
            $after += $out.Length
            $processed++
        }
        else {
            $after += $originalLength
            $skipped++
        }
    }
    catch {
        Write-Warning "Skipped (error) $($f.FullName): $($_.Exception.Message)"
        $after += $originalLength
        $skipped++
    }
    finally {
        if ($out) { $out.Dispose() }
        if ($bmp) { $bmp.Dispose() }
        if ($img) { $img.Dispose() }
        if ($ms) { $ms.Dispose() }
    }
}

$savedMB = ($before - $after) / 1MB
"Images: {0} compressed, {1} skipped." -f $processed, $skipped
"Before: {0:N1} MB  After: {1:N1} MB  Saved: {2:N1} MB" -f ($before / 1MB), ($after / 1MB), $savedMB
