Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$srcPath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794531726805_80ab1815.png"
$dstPath = Join-Path $root "gfx\leaders\USA\portrait_frederica_bernkastel.png"
$backupDir = Join-Path $root "gfx\leaders\USA\raw"

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}
if (Test-Path $dstPath) {
    Copy-Item -Path $dstPath -Destination (Join-Path $backupDir "portrait_frederica_bernkastel_old.png") -Force
}

$W = 156
$H = 210

$bmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# 1. GENERATE TFR STUDIO GRADIENT BACKGROUND
# Vertical linear gradient from dusty lavender-slate (#75638A) to dark charcoal-plum (#1E1728)
$topColor = [System.Drawing.Color]::FromArgb(255, 120, 102, 142)
$bottomColor = [System.Drawing.Color]::FromArgb(255, 28, 22, 38)
$gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(0, 0)),
    (New-Object System.Drawing.Point(0, $H)),
    $topColor,
    $bottomColor
)
$g.FillRectangle($gradBrush, 0, 0, $W, $H)
$gradBrush.Dispose()

# Radial studio spotlight centered behind Bernkastel's head (X=78, Y=70)
$spotPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$spotPath.AddEllipse(-20, -10, 196, 170)
$spotBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($spotPath)
$spotBrush.CenterColor = [System.Drawing.Color]::FromArgb(140, 195, 175, 215) # Soft lavender spotlight
$spotBrush.SurroundColors = [System.Drawing.Color[]]@([System.Drawing.Color]::FromArgb(0, 28, 22, 38))
$g.FillPath($spotBrush, $spotPath)
$spotPath.Dispose()
$spotBrush.Dispose()

# Faint geometric / geopolitical watermark lines in background
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(25, 255, 255, 255), 1)
for ($y = 20; $y -lt $H; $y += 30) {
    $g.DrawLine($gridPen, 0, $y, $W, $y)
}
for ($x = 20; $x -lt $W; $x += 30) {
    $g.DrawLine($gridPen, $x, 0, $x, $H)
}
$gridPen.Dispose()

# 2. LOAD & POSITION BERNKASTEL SPRITE
$srcImg = [System.Drawing.Bitmap]::FromFile($srcPath)
$scale = 0.468
$drawW = [int]($srcImg.Width * $scale)  # ~234px
$drawH = [int]($srcImg.Height * $scale) # ~202px
$drawX = -50
$drawY = 10

# Draw ambient drop shadow behind Bernkastel
$shadowBmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$sg = [System.Drawing.Graphics]::FromImage($shadowBmp)
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$cm = New-Object System.Drawing.Imaging.ColorMatrix
$cm.Matrix00 = 0; $cm.Matrix11 = 0; $cm.Matrix22 = 0; $cm.Matrix33 = 0.6 # 60% black shadow
$ia = New-Object System.Drawing.Imaging.ImageAttributes
$ia.SetColorMatrix($cm)
$shadowRect = New-Object System.Drawing.Rectangle([int]($drawX + 3), [int]($drawY + 4), [int]$drawW, [int]$drawH)
$sg.DrawImage($srcImg, $shadowRect, 0, 0, $srcImg.Width, $srcImg.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)
$sg.Dispose()

# Fast blur shadow horizontally and vertically
$g.DrawImage($shadowBmp, 0, 0)
$shadowBmp.Dispose()

# Draw Bernkastel herself
$g.DrawImage($srcImg, $drawX, $drawY, $drawW, $drawH)
$srcImg.Dispose()
$g.Dispose()

# 3. APPLY TFR POST-PROCESSING (CONTRAST PUNCH, MOODY COLOR GRADING, CRUSHED BLACKS, VIGNETTE, GRAIN)
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bytes = [Math]::Abs($bmpData.Stride) * $H
$rgbValues = New-Object byte[] $bytes
[System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $rgbValues, 0, $bytes)
$stride = $bmpData.Stride

$rnd = New-Object System.Random(1337)

for ($y = 0; $y -lt $H; $y++) {
    $normY = ($y - 105.0) / 105.0
    for ($x = 0; $x -lt $W; $x++) {
        $idx = ($y * $stride) + ($x * 4) # B, G, R, A
        
        $b = [double]$rgbValues[$idx + 0] / 255.0
        $gVal = [double]$rgbValues[$idx + 1] / 255.0
        $r = [double]$rgbValues[$idx + 2] / 255.0

        # Contrast curve with crushed blacks for dark TFR aesthetic
        # Shadow compression
        if ($r -lt 0.25) { $r = [Math]::Max(0.0, $r * 0.75) } else { $r = [Math]::Min(1.0, 0.25 + ($r - 0.25) * 1.20) }
        if ($gVal -lt 0.25) { $gVal = [Math]::Max(0.0, $gVal * 0.75) } else { $gVal = [Math]::Min(1.0, 0.25 + ($gVal - 0.25) * 1.20) }
        if ($b -lt 0.25) { $b = [Math]::Max(0.0, $b * 0.75) } else { $b = [Math]::Min(1.0, 0.25 + ($b - 0.25) * 1.20) }

        # TFR Cinematic Vignette (darken corners)
        $normX = ($x - 78.0) / 78.0
        $dist = [Math]::Sqrt($normX * $normX + $normY * $normY)
        if ($dist -gt 0.7) {
            $vignette = [Math]::Max(0.45, 1.0 - ($dist - 0.7) * 0.9)
            $r *= $vignette
            $gVal *= $vignette
            $b *= $vignette
        }

        # Subtle Analog Film Grain (±3% noise)
        $noise = ($rnd.NextDouble() - 0.5) * 0.05
        $r = [Math]::Max(0.0, [Math]::Min(1.0, $r + $noise))
        $gVal = [Math]::Max(0.0, [Math]::Min(1.0, $gVal + $noise))
        $b = [Math]::Max(0.0, [Math]::Min(1.0, $b + $noise))

        # TFR Subtle Cool Tint (+2% Blue/Indigo, slightly cooler highlights)
        $b = [Math]::Min(1.0, $b * 1.04)

        $rgbValues[$idx + 0] = [byte]($b * 255.0)
        $rgbValues[$idx + 1] = [byte]($gVal * 255.0)
        $rgbValues[$idx + 2] = [byte]($r * 255.0)
        $rgbValues[$idx + 3] = 255 # Fully opaque leader portrait
    }
}

[System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $bmpData.Scan0, $bytes)
$bmp.UnlockBits($bmpData)

# Save as 32-bit PNG
$bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "[OK] Successfully created TFR Frederica Bernkastel leader portrait at $dstPath (156x210 ARGB PNG)"
