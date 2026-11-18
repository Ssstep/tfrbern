Add-Type -AssemblyName System.Drawing

$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"
$leadersDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\leaders\USA"
$fmt = [System.Drawing.Imaging.ImageFormat]::Png

Write-Host "=== 1. BUILDING GRAND CATBOX UI BACKGROUND (500x790) ==="

$w = 500
$h = 790
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# 1. Base deep indigo-night gradient
$baseBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.PointF]::new(0.0, 0.0),
    [System.Drawing.PointF]::new(0.0, [float]$h),
    [System.Drawing.Color]::FromArgb(255, 11, 13, 23),
    [System.Drawing.Color]::FromArgb(255, 7, 8, 15)
)
$g.FillRectangle($baseBrush, 0, 0, $w, $h)
$baseBrush.Dispose()

# 2. Draw existing architecture art if present, with heavy dimming (65% darkness + cold indigo tint #0b0d17)
$existingArchPath = "$decDir\bern_gui_architecture_bg.png"
if (Test-Path $existingArchPath) {
    $existing = [System.Drawing.Bitmap]::FromFile($existingArchPath)
    # Draw stretched to cover top dome and pillars
    $g.DrawImage($existing, 0, 0, $w, [Math]::Min(550, $existing.Height))
    $existing.Dispose()

    # Dimming overlay: 65% darkness + cold indigo tint (#0b0d17 at alpha ~185)
    $dimBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(185, 11, 13, 23))
    $g.FillRectangle($dimBrush, 0, 0, $w, 550)
    $dimBrush.Dispose()
}

# 3. Semi-transparent dark terminal panels (#090b12, alpha 225) strictly matching .gui coordinates

$panelFill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(225, 9, 11, 18))
$slotFill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 13, 16, 26))

# Panel 1: Upper Gamemaster & Meta-Indicators (y = 45..232)
# Relative to bg (x = GUI.x - 5): x = 7, y = 45, w = 486, h = 188
$topPanelRect = New-Object System.Drawing.Rectangle(7, 45, 486, 188)
$g.FillRectangle($panelFill, $topPanelRect)
$topBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 65, 45, 105), 1)
$g.DrawRectangle($topBorderPen, $topPanelRect)
$topBorderPen.Dispose()

# Panel 2: Three Inquisition Pillar Cards (y = 240..435, h = 195)
# Erika (Cyan) - GUI: x = 22 -> relative: x = 17, w = 148, h = 195
$erikaRect = New-Object System.Drawing.Rectangle(17, 240, 148, 195)
$g.FillRectangle($panelFill, $erikaRect)
$erikaBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 229, 255), 1)
$g.DrawRectangle($erikaBorderPen, $erikaRect)
$erikaBorderPen.Dispose()

# Dlanor (Crimson) - GUI: x = 186 -> relative: x = 181, w = 148, h = 195
$dlanorRect = New-Object System.Drawing.Rectangle(181, 240, 148, 195)
$g.FillRectangle($panelFill, $dlanorRect)
$dlanorBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 42, 85), 1)
$g.DrawRectangle($dlanorBorderPen, $dlanorRect)
$dlanorBorderPen.Dispose()

# Willard (Amber) - GUI: x = 350 -> relative: x = 345, w = 148, h = 195
$willardRect = New-Object System.Drawing.Rectangle(345, 240, 148, 195)
$g.FillRectangle($panelFill, $willardRect)
$willardBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 176, 32), 1)
$g.DrawRectangle($willardBorderPen, $willardRect)
$willardBorderPen.Dispose()

# Panel 3: Clair Chessboard Tray (y = 442..550, h = 110)
# GUI: x = 12 -> relative: x = 7, w = 486, h = 110
$trayRect = New-Object System.Drawing.Rectangle(7, 442, 486, 110)
$g.FillRectangle($panelFill, $trayRect)
$trayGoldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 212, 165, 75), 1)
$trayPurpPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 168, 56, 208), 1)
$g.DrawRectangle($trayGoldPen, $trayRect)
$g.DrawRectangle($trayPurpPen, 9, 444, 482, 106)
$trayGoldPen.Dispose()
$trayPurpPen.Dispose()

# Panel 4: Grand Gameboard Matrix (y = 558..780, h = 225)
# GUI: x = 10 -> relative: x = 5, w = 490, h = 225
$matrixRect = New-Object System.Drawing.Rectangle(5, 558, 490, 225)
$g.FillRectangle($panelFill, $matrixRect)
$matrixBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 58, 40, 80), 1)
$g.DrawRectangle($matrixBorderPen, $matrixRect)
$matrixBorderPen.Dispose()

# Subtle Chessboard Grid pattern on Matrix background
$chessPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(18, 255, 255, 255), 1)
for ($cx = 15; $cx -lt 485; $cx += 35) {
    $g.DrawLine($chessPen, $cx, 560, $cx, 780)
}
for ($cy = 565; $cy -lt 780; $cy += 35) {
    $g.DrawLine($chessPen, 10, $cy, 485, $cy)
}
$chessPen.Dispose()

# 5 Telemetry Slots inside the Matrix
$slots = @(
    @{ Y = 566; H = 38; Pen = [System.Drawing.Color]::FromArgb(140, 0, 229, 255) },   # Main Core (Cyan)
    @{ Y = 608; H = 38; Pen = [System.Drawing.Color]::FromArgb(140, 180, 48, 224) }, # PEADs (Purple)
    @{ Y = 650; H = 38; Pen = [System.Drawing.Color]::FromArgb(140, 255, 176, 32) }, # Mint (Gold)
    @{ Y = 692; H = 38; Pen = [System.Drawing.Color]::FromArgb(140, 180, 48, 224) }, # Impound (Purple)
    @{ Y = 734; H = 44; Pen = [System.Drawing.Color]::FromArgb(140, 255, 42, 85) }   # Schelling (Red)
)

foreach ($slot in $slots) {
    $sRect = New-Object System.Drawing.Rectangle(9, $slot.Y, 482, $slot.H)
    $g.FillRectangle($slotFill, $sRect)
    $sPen = New-Object System.Drawing.Pen($slot.Pen, 1)
    $g.DrawRectangle($sPen, $sRect)
    $sPen.Dispose()
}

# Outer UI frame bevel (Dark Steel #242834)
$outerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 36, 40, 52), 1.5)
$g.DrawRectangle($outerPen, 1, 1, $w - 2, $h - 2)
$outerPen.Dispose()

$panelFill.Dispose()
$slotFill.Dispose()
$g.Dispose()

$bgOutPath = "$decDir\bern_gui_catbox_grand_bg.png"
$bmp.Save($bgOutPath, $fmt)
$bmp.Dispose()
Write-Host "Created bern_gui_catbox_grand_bg.png (500x790)"


Write-Host "`n=== 2. PROCESSING 5 AUTHENTIC TFR DECISION PORTRAITS ==="

function Process-TFR-Portrait {
    param(
        [string]$srcPath,
        [string]$dstPath,
        [int]$targetW,
        [int]$targetH,
        [System.Drawing.Color]$neonColor,
        [int]$srcCropTop = 10
    )

    $srcBmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

    $cropW = [float]$srcBmp.Width
    $cropH = $cropW * ($targetH / [float]$targetW)
    if ($cropH -gt ($srcBmp.Height - $srcCropTop)) {
        $cropH = $srcBmp.Height - $srcCropTop
        $cropW = $cropH * ($targetW / [float]$targetH)
    }
    $cropX = ($srcBmp.Width - $cropW) / 2.0
    $cropY = [float]$srcCropTop

    $dstBmp = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dstBmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    # Dark studio gradient background (no white or ragged edges)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new(0.0, 0.0),
        [System.Drawing.PointF]::new(0.0, [float]$targetH),
        [System.Drawing.Color]::FromArgb(255, 20, 23, 34),
        [System.Drawing.Color]::FromArgb(255, 8, 9, 14)
    )
    $g.FillRectangle($bgBrush, 0, 0, $targetW, $targetH)
    $bgBrush.Dispose()

    # Draw scaled upper-bust portrait
    $srcRect = [System.Drawing.RectangleF]::new($cropX, $cropY, $cropW, $cropH)
    $dstRect = [System.Drawing.RectangleF]::new(0, 0, $targetW, $targetH)
    $g.DrawImage($srcBmp, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $srcBmp.Dispose()

    # Pixel processing: S-curve contrast, CRT scanlines (15% darken on even rows), vignette
    $cx = ($targetW - 1) / 2.0
    $cy = ($targetH - 1) / 2.0

    $rect = New-Object System.Drawing.Rectangle(0, 0, $targetW, $targetH)
    $bmpData = $dstBmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $stride = $bmpData.Stride
    $ptr = $bmpData.Scan0
    $totalBytes = [Math]::Abs($stride) * $targetH
    $rgbValues = New-Object byte[] $totalBytes
    [System.Runtime.InteropServices.Marshal]::Copy($ptr, $rgbValues, 0, $totalBytes)

    for ($y = 0; $y -lt $targetH; $y++) {
        $rowOffset = $y * $stride
        $isEvenRow = ($y % 2 -eq 0)
        $scanMult = if ($isEvenRow) { 0.85 } else { 1.0 }

        $dy = ($y - $cy) / $cy

        for ($x = 0; $x -lt $targetW; $x++) {
            $idx = $rowOffset + ($x * 4)

            # Vignette factor based on normalized radius
            $dx = ($x - $cx) / $cx
            $rad = [Math]::Sqrt($dx * $dx + $dy * $dy)
            $vig = 1.0
            if ($rad -gt 0.5) {
                $vig = 1.0 - ([Math]::Min(1.0, ($rad - 0.5) / 0.7) * 0.45)
            }

            # S-curve contrast + vignette + scanline
            foreach ($ch in @($idx, $idx + 1, $idx + 2)) {
                $val = $rgbValues[$ch] / 255.0
                # Smoothstep S-curve
                $sval = $val * $val * (3.0 - 2.0 * $val)
                # Blend 60% S-curve, 40% original
                $blended = 0.4 * $val + 0.6 * $sval
                # Apply vignette & scanline
                $finalVal = $blended * $vig * $scanMult * 255.0
                if ($finalVal -lt 0) { $finalVal = 0 }
                if ($finalVal -gt 255) { $finalVal = 255 }
                $rgbValues[$ch] = [byte][Math]::Round($finalVal)
            }
        }
    }

    [System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $ptr, $totalBytes)
    $dstBmp.UnlockBits($bmpData)

    # Double techno frame TFR (outer dark steel #242834 2px + inner neon 1px in character color)
    $g2 = [System.Drawing.Graphics]::FromImage($dstBmp)
    $outerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 36, 40, 52), 2)
    $innerPen = New-Object System.Drawing.Pen($neonColor, 1)

    # Outer 2px dark steel frame
    $g2.DrawRectangle($outerPen, 1, 1, $targetW - 2, $targetH - 2)

    # Inner 1px neon frame
    $g2.DrawRectangle($innerPen, 2, 2, $targetW - 5, $targetH - 5)

    $outerPen.Dispose()
    $innerPen.Dispose()
    $g2.Dispose()

    $dstBmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $dstBmp.Dispose()
    Write-Host "Processed portrait -> $dstPath ($targetW x $targetH)"
}

# 1. Frederica Bernkastel (Small: 80x96, Neon Purple #b840e0)
Process-TFR-Portrait `
    -srcPath "$leadersDir\portrait_frederica_bernkastel.png" `
    -dstPath "$leadersDir\portrait_frederica_bernkastel_small.png" `
    -targetW 80 -targetH 96 `
    -neonColor ([System.Drawing.Color]::FromArgb(255, 184, 64, 224)) `
    -srcCropTop 8

# Also copy to decisions directory if referenced
Copy-Item "$leadersDir\portrait_frederica_bernkastel_small.png" "$decDir\portrait_frederica_bernkastel_small.png" -Force

# 2. Erika Furudo (80x86, Neon Cyan #00e5ff)
Process-TFR-Portrait `
    -srcPath "$leadersDir\portrait_erika_furudo.png" `
    -dstPath "$decDir\bern_portrait_erika.png" `
    -targetW 80 -targetH 86 `
    -neonColor ([System.Drawing.Color]::FromArgb(255, 0, 229, 255)) `
    -srcCropTop 12

# 3. Dlanor A. Knox (80x86, Neon Crimson #ff2a55)
Process-TFR-Portrait `
    -srcPath "$leadersDir\portrait_dlanor_a_knox.png" `
    -dstPath "$decDir\bern_portrait_dlanor.png" `
    -targetW 80 -targetH 86 `
    -neonColor ([System.Drawing.Color]::FromArgb(255, 255, 42, 85)) `
    -srcCropTop 10

# 4. Willard H. Wright (80x86, Neon Amber #ffb020)
Process-TFR-Portrait `
    -srcPath "$leadersDir\portrait_willard_h_wright.png" `
    -dstPath "$decDir\bern_portrait_willard.png" `
    -targetW 80 -targetH 86 `
    -neonColor ([System.Drawing.Color]::FromArgb(255, 255, 176, 32)) `
    -srcCropTop 10

# 5. Clair Vaux Bernardus (76x86, Neon Purple #b840e0)
Process-TFR-Portrait `
    -srcPath "$leadersDir\portrait_clair_vaux_bernardus.png" `
    -dstPath "$decDir\bern_portrait_clair.png" `
    -targetW 76 -targetH 86 `
    -neonColor ([System.Drawing.Color]::FromArgb(255, 184, 64, 224)) `
    -srcCropTop 10


Write-Host "`n=== 3. BUILDING INTERACTIVE TUMBLERS (2 FRAMES: OFF / ON) ==="

function Build-Tumbler($fileName, $glowColor, $labelOff, $labelOn) {
    $tw = 160
    $th = 24
    $fw = 80
    $tbmp = New-Object System.Drawing.Bitmap($tw, $th, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $tg = [System.Drawing.Graphics]::FromImage($tbmp)
    $tg.Clear([System.Drawing.Color]::Transparent)
    $tg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $tg.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $tFont = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)
    $tsf = New-Object System.Drawing.StringFormat
    $tsf.Alignment = [System.Drawing.StringAlignment]::Center
    $tsf.LineAlignment = [System.Drawing.StringAlignment]::Center

    # --- FRAME 1: OFF (Lever Left / Dark) ---
    $f1Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new(0.0, 0.0),
        [System.Drawing.PointF]::new(0.0, [float]$th),
        [System.Drawing.Color]::FromArgb(255, 24, 22, 32),
        [System.Drawing.Color]::FromArgb(255, 12, 10, 18)
    )
    $tg.FillRectangle($f1Bg, 1, 1, $fw - 2, $th - 2)
    $f1Border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 55, 50, 75), 1)
    $tg.DrawRectangle($f1Border, 1, 1, $fw - 3, $th - 3)

    # Lever slot
    $slotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 8, 7, 12))
    $tg.FillRectangle($slotBrush, 4, 6, 20, 12)
    $leverOffBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 80, 75, 90))
    $tg.FillRectangle($leverOffBrush, 6, 8, 8, 8)

    # Text OFF
    $textBrushOff = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 140, 135, 160))
    $tg.DrawString($labelOff, $tFont, $textBrushOff, [System.Drawing.RectangleF]::new(24, 0, $fw - 26, $th), $tsf)

    # --- FRAME 2: ON (Lever Right / Glowing) ---
    $f2Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new([float]$fw, 0.0),
        [System.Drawing.PointF]::new([float]$fw, [float]$th),
        [System.Drawing.Color]::FromArgb(255, 36, 25, 48),
        [System.Drawing.Color]::FromArgb(255, 16, 12, 24)
    )
    $tg.FillRectangle($f2Bg, $fw + 1, 1, $fw - 2, $th - 2)
    $f2Border = New-Object System.Drawing.Pen($glowColor, 1)
    $tg.DrawRectangle($f2Border, $fw + 1, 1, $fw - 3, $th - 3)

    # Lever slot
    $tg.FillRectangle($slotBrush, $fw + 4, 6, 20, 12)
    # Glowing lever handle on right
    $leverOnBrush = New-Object System.Drawing.SolidBrush($glowColor)
    $tg.FillRectangle($leverOnBrush, $fw + 14, 8, 8, 8)
    # Glint
    $glintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $tg.FillRectangle($glintBrush, $fw + 16, 10, 4, 4)

    # Text ON
    $textBrushOn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $tg.DrawString($labelOn, $tFont, $textBrushOn, [System.Drawing.RectangleF]::new($fw + 24, 0, $fw - 26, $th), $tsf)

    $tbmp.Save("$decDir\$fileName", $fmt)
    $tbmp.Dispose()
    Write-Host "Created $fileName"
}

Build-Tumbler -fileName "bern_tumbler_gold.png"   -glowColor ([System.Drawing.Color]::FromArgb(255, 255, 190, 40))  -labelOff "OFF" -labelOn "ACTIVE"
Build-Tumbler -fileName "bern_tumbler_blue.png"   -glowColor ([System.Drawing.Color]::FromArgb(255, 0, 220, 255))   -labelOff "OFF" -labelOn "ACTIVE"
Build-Tumbler -fileName "bern_tumbler_red.png"    -glowColor ([System.Drawing.Color]::FromArgb(255, 255, 50, 70))   -labelOff "OFF" -labelOn "ACTIVE"
Build-Tumbler -fileName "bern_tumbler_purple.png" -glowColor ([System.Drawing.Color]::FromArgb(255, 190, 70, 255))  -labelOff "OFF" -labelOn "ACTIVE"

Write-Host "ALL GRAPHICS GENERATED SUCCESSFULLY!"
