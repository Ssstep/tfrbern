Add-Type -AssemblyName System.Drawing

$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"
$fmt = [System.Drawing.Imaging.ImageFormat]::Png

# 1. Build Grand Umineko Architecture Background (500x760)
$w = 500
$h = 760
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Dark Umineko Gothic Base Gradient
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.PointF]::new(0.0, 0.0),
    [System.Drawing.PointF]::new(0.0, [float]$h),
    [System.Drawing.Color]::FromArgb(255, 18, 14, 26),
    [System.Drawing.Color]::FromArgb(255, 8, 6, 14)
)
$g.FillRectangle($bgBrush, 0, 0, $w, $h)

# Load existing architecture art if present to maintain visual continuity of Dome and Pillars
$existingArchPath = "$decDir\bern_gui_architecture_bg.png"
if (Test-Path $existingArchPath) {
    $existing = [System.Drawing.Bitmap]::FromFile($existingArchPath)
    # Draw existing dome, pillars, and tray (500x530)
    $g.DrawImage($existing, 0, 0, 500, [Math]::Min(530, $existing.Height))
    $existing.Dispose()
}

# Now decorate the bottom extension (y = 525 to 760): The Grand Umineko Gameboard Matrix
$matrixRect = New-Object System.Drawing.Rectangle(4, 526, 492, 230)
$matrixBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.PointF]::new(0.0, 526.0),
    [System.Drawing.PointF]::new(0.0, 756.0),
    [System.Drawing.Color]::FromArgb(255, 22, 16, 34),
    [System.Drawing.Color]::FromArgb(255, 12, 9, 20)
)
$g.FillRectangle($matrixBrush, $matrixRect)

# Gold and Purple Gothic Trim Border
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 212, 165, 75), 1.5)
$purpPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 155, 45, 215), 1.0)
$g.DrawRectangle($goldPen, 4, 526, 492, 230)
$g.DrawRectangle($purpPen, 6, 528, 488, 226)

# Chessboard Watermark on Matrix
$chessPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(22, 255, 255, 255), 1)
for ($x = 20; $x -lt 490; $x += 35) {
    $g.DrawLine($chessPen, $x, 530, $x, 754)
}
for ($y = 540; $y -lt 754; $y += 35) {
    $g.DrawLine($chessPen, 10, $y, 490, $y)
}

# 5 Instrument Socket Panels (brass-trimmed sub-panels)
$panelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(160, 180, 140, 60), 1)
$panelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 16, 12, 24))

# Sub-panel 1: MAIN CORE (y = 534, h = 38)
$g.FillRectangle($panelBrush, 10, 534, 480, 38)
$g.DrawRectangle($panelPen, 10, 534, 480, 38)

# Sub-panel 2: PEADs & Martial Law (y = 576, h = 38)
$g.FillRectangle($panelBrush, 10, 576, 480, 38)
$g.DrawRectangle($panelPen, 10, 576, 480, 38)

# Sub-panel 3: Platinum Seigniorage & Inflation (y = 618, h = 38)
$g.FillRectangle($panelBrush, 10, 618, 480, 38)
$g.DrawRectangle($panelPen, 10, 618, 480, 38)

# Sub-panel 4: ICA Impounded Appropriations (y = 660, h = 38)
$g.FillRectangle($panelBrush, 10, 660, 480, 38)
$g.DrawRectangle($panelPen, 10, 660, 480, 38)

# Sub-panel 5: Schelling Brinkmanship (y = 702, h = 48)
$g.FillRectangle($panelBrush, 10, 702, 480, 48)
$g.DrawRectangle($panelPen, 10, 702, 480, 48)

# Outer Window Golden Bevel
$outerGold = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 195, 150, 60), 2)
$g.DrawRectangle($outerGold, 1, 1, $w - 3, $h - 3)

$bmp.Save("$decDir\bern_gui_catbox_grand_bg.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_gui_catbox_grand_bg.png (500x760)"

# 2. Build Interactive Tumblers / Levers (80x24 per frame -> 160x24, 2 frames)
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
        [System.Drawing.Color]::FromArgb(255, 30, 24, 38),
        [System.Drawing.Color]::FromArgb(255, 14, 10, 20)
    )
    $tg.FillRectangle($f1Bg, 1, 1, $fw - 2, $th - 2)
    $f1Border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 75, 60, 95), 1)
    $tg.DrawRectangle($f1Border, 1, 1, $fw - 3, $th - 3)
    # Lever handle slot (dim)
    $slotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 10, 8, 14))
    $tg.FillRectangle($slotBrush, 4, 6, 20, 12)
    $leverOffBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 90, 80, 100))
    $tg.FillRectangle($leverOffBrush, 6, 8, 8, 8)
    # Text
    $textBrushOff = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 160, 150, 180))
    $tg.DrawString($labelOff, $tFont, $textBrushOff, [System.Drawing.RectangleF]::new(24, 0, $fw - 26, $th), $tsf)

    # --- FRAME 2: ON (Lever Right / Glowing) ---
    $f2Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new([float]$fw, 0.0),
        [System.Drawing.PointF]::new([float]$fw, [float]$th),
        [System.Drawing.Color]::FromArgb(255, 45, 25, 65),
        [System.Drawing.Color]::FromArgb(255, 20, 12, 32)
    )
    $tg.FillRectangle($f2Bg, $fw + 1, 1, $fw - 2, $th - 2)
    $f2Border = New-Object System.Drawing.Pen($glowColor, 1)
    $tg.DrawRectangle($f2Border, $fw + 1, 1, $fw - 3, $th - 3)
    # Lever handle slot
    $tg.FillRectangle($slotBrush, $fw + 4, 6, 20, 12)
    # Glowing lever handle on the right side of the slot
    $leverOnBrush = New-Object System.Drawing.SolidBrush($glowColor)
    $tg.FillRectangle($leverOnBrush, $fw + 14, 8, 8, 8)
    # Glowing indicator light
    $glintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $tg.FillRectangle($glintBrush, $fw + 16, 10, 4, 4)
    # Text
    $textBrushOn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $tg.DrawString($labelOn, $tFont, $textBrushOn, [System.Drawing.RectangleF]::new($fw + 24, 0, $fw - 26, $th), $tsf)

    $tbmp.Save("$decDir\$fileName", $fmt)
    $tbmp.Dispose()
    Write-Host "Created $fileName"
}

Build-Tumbler "bern_tumbler_gold.png"   ([System.Drawing.Color]::FromArgb(255, 255, 215, 80))  "ВЫКЛ" "АКТИВ"
Build-Tumbler "bern_tumbler_blue.png"   ([System.Drawing.Color]::FromArgb(255, 0, 220, 255))   "ВЫКЛ" "СКОТЧ"
Build-Tumbler "bern_tumbler_red.png"    ([System.Drawing.Color]::FromArgb(255, 255, 65, 65))   "ВЫКЛ" "НОКС"
Build-Tumbler "bern_tumbler_purple.png" ([System.Drawing.Color]::FromArgb(255, 225, 95, 255))  "ВЫКЛ" "VOID"
