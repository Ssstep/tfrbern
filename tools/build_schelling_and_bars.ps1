Add-Type -AssemblyName System.Drawing

$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"
$fmt = [System.Drawing.Imaging.ImageFormat]::Png

# 1. bern_schelling_bg.png (500x410) - High-tech USSTRATCOM DEFCON War Room CRT screen
$w = 500
$h = 410
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Dark metallic background
$bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 12, 16, 24))
$g.FillRectangle($bgBrush, 0, 0, $w, $h)

# Outer metallic bezel
$bezelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 45, 60, 85), 2)
$g.DrawRectangle($bezelPen, 2, 2, $w - 5, $h - 5)
$innerBezelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 25, 35, 52), 1)
$g.DrawRectangle($innerBezelPen, 5, 5, $w - 11, $h - 11)

# Subtle tactical grid
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 0, 180, 220), 1)
for ($x = 20; $x -lt $w - 20; $x += 40) {
    $g.DrawLine($gridPen, $x, 15, $x, $h - 15)
}
for ($y = 20; $y -lt $h - 20; $y += 35) {
    $g.DrawLine($gridPen, 15, $y, $w - 15, $y)
}

# Radar Circles in center-right
$radarPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 160, 50, 200), 1)
$g.DrawEllipse($radarPen, 280, 100, 180, 180)
$g.DrawEllipse($radarPen, 320, 140, 100, 100)
$g.DrawEllipse($radarPen, 350, 170, 40, 40)
$g.DrawLine($radarPen, 270, 190, 470, 190)
$g.DrawLine($radarPen, 370, 90, 370, 290)

# CRT Scanlines
for ($y = 0; $y -lt $h; $y += 2) {
    $scanPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 0, 0, 0), 1)
    $g.DrawLine($scanPen, 0, $y, $w, $y)
}

# Top header strip
$headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 18, 26, 40))
$g.FillRectangle($headerBrush, 6, 6, $w - 12, 30)
$headerBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 200, 240), 1)
$g.DrawLine($headerBorderPen, 6, 36, $w - 6, 36)

# Terminal Corner Accents
$cornerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 200, 140, 255), 2)
$g.DrawLine($cornerPen, 8, 8, 25, 8)
$g.DrawLine($cornerPen, 8, 8, 8, 25)
$g.DrawLine($cornerPen, $w - 9, 8, $w - 26, 8)
$g.DrawLine($cornerPen, $w - 9, 8, $w - 9, 25)
$g.DrawLine($cornerPen, 8, $h - 9, 25, $h - 9)
$g.DrawLine($cornerPen, 8, $h - 9, 8, $h - 26)
$g.DrawLine($cornerPen, $w - 9, $h - 9, $w - 26, $h - 9)
$g.DrawLine($cornerPen, $w - 9, $h - 9, $w - 9, $h - 26)

$bmp.Save("$decDir\bern_schelling_bg.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_schelling_bg.png"

# 2. bern_golden_sliver_icon.png (16x32) - Golden Chevron Pointer
$w = 16
$h = 32
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Draw golden needle
$pts = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(8.0, 0.0),
    [System.Drawing.PointF]::new(15.0, 10.0),
    [System.Drawing.PointF]::new(11.0, 10.0),
    [System.Drawing.PointF]::new(11.0, 31.0),
    [System.Drawing.PointF]::new(5.0, 31.0),
    [System.Drawing.PointF]::new(5.0, 10.0),
    [System.Drawing.PointF]::new(1.0, 10.0)
)
$pStart = [System.Drawing.PointF]::new(0.0, 0.0)
$pEnd = [System.Drawing.PointF]::new(16.0, 32.0)
$goldBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $pStart, $pEnd,
    [System.Drawing.Color]::FromArgb(255, 255, 235, 120),
    [System.Drawing.Color]::FromArgb(255, 200, 140, 20)
)
$g.FillPolygon($goldBrush, $pts)
$outlinePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 255, 200), 1)
$g.DrawPolygon($outlinePen, $pts)

$bmp.Save("$decDir\bern_golden_sliver_icon.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_golden_sliver_icon.png"

# 3. bern_purple_bar_empty.png (470x26)
$w = 470
$h = 26
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
# Recessed channel
$bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 14, 16, 24))
$g.FillRectangle($bgBrush, 0, 0, $w, $h)
# Bevel border
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 50, 60, 85), 1)
$g.DrawRectangle($borderPen, 0, 0, $w - 1, $h - 1)
# Grid ticks
$tickPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 28, 34, 48), 1)
for ($x = 10; $x -lt $w; $x += 10) {
    $g.DrawLine($tickPen, $x, 2, $x, $h - 3)
}
$bmp.Save("$decDir\bern_purple_bar_empty.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_purple_bar_empty.png"

# 4. bern_purple_bar_full.png (470x26) - Vibrant Glowing Purple Segments
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
# Base gradient
$pStart = [System.Drawing.PointF]::new(0.0, 0.0)
$pEnd = [System.Drawing.PointF]::new(0.0, [float]$h)
$purpBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $pStart, $pEnd,
    [System.Drawing.Color]::FromArgb(255, 195, 75, 255),
    [System.Drawing.Color]::FromArgb(255, 110, 20, 175)
)
$g.FillRectangle($purpBrush, 1, 1, $w - 2, $h - 2)
# LED segments dividers
$segPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 15, 10, 30), 1)
for ($x = 8; $x -lt $w; $x += 8) {
    $g.DrawLine($segPen, $x, 1, $x, $h - 2)
}
# Specular top highlight
$specBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(90, 255, 255, 255))
$g.FillRectangle($specBrush, 1, 1, $w - 2, 4)
# Border
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 230, 160, 255), 1)
$g.DrawRectangle($borderPen, 0, 0, $w - 1, $h - 1)
$bmp.Save("$decDir\bern_purple_bar_full.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_purple_bar_full.png"

# 5. bern_rand_5_percent_bar.png (470x26) - 5% Red Danger Zone + 95% Cyan Peace Zone
$bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
# 5% width = 24 pixels
$dangerBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $pStart, $pEnd,
    [System.Drawing.Color]::FromArgb(255, 255, 60, 60),
    [System.Drawing.Color]::FromArgb(255, 170, 10, 20)
)
$g.FillRectangle($dangerBrush, 1, 1, 24, $h - 2)

$peaceBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $pStart, $pEnd,
    [System.Drawing.Color]::FromArgb(255, 30, 180, 210),
    [System.Drawing.Color]::FromArgb(255, 10, 85, 115)
)
$g.FillRectangle($peaceBrush, 26, 1, $w - 28, $h - 2)

# Segments
for ($x = 8; $x -lt $w; $x += 8) {
    $segPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 10, 15, 25), 1)
    $g.DrawLine($segPen, $x, 1, $x, $h - 2)
}
# Divider line at 5% mark
$divPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 255, 100), 2)
$g.DrawLine($divPen, 25, 0, 25, $h)

# Border
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 80, 120, 160), 1)
$g.DrawRectangle($borderPen, 0, 0, $w - 1, $h - 1)
$bmp.Save("$decDir\bern_rand_5_percent_bar.png", $fmt)
$bmp.Dispose()
Write-Host "Created bern_rand_5_percent_bar.png"

# 6. Status LEDs (16x16) for Cockpit Telemetry
$leds = @{
    "bern_led_cyan.png"   = @([System.Drawing.Color]::FromArgb(255, 0, 230, 255),   [System.Drawing.Color]::FromArgb(255, 0, 120, 160));
    "bern_led_purple.png" = @([System.Drawing.Color]::FromArgb(255, 220, 90, 255),  [System.Drawing.Color]::FromArgb(255, 130, 20, 180));
    "bern_led_amber.png"  = @([System.Drawing.Color]::FromArgb(255, 255, 190, 30),  [System.Drawing.Color]::FromArgb(255, 190, 100, 10));
    "bern_led_red.png"    = @([System.Drawing.Color]::FromArgb(255, 255, 60, 60),   [System.Drawing.Color]::FromArgb(255, 160, 15, 20));
    "bern_led_green.png"  = @([System.Drawing.Color]::FromArgb(255, 60, 255, 120),  [System.Drawing.Color]::FromArgb(255, 15, 140, 50))
}

foreach ($entry in $leds.GetEnumerator()) {
    $name = $entry.Key
    $colors = $entry.Value
    $lbmp = New-Object System.Drawing.Bitmap(16, 16, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $lg = [System.Drawing.Graphics]::FromImage($lbmp)
    $lg.Clear([System.Drawing.Color]::Transparent)
    $lg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    
    # Outer dark rim
    $rimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 30, 40, 55), 1)
    $lg.DrawEllipse($rimPen, 1, 1, 13, 13)
    
    # Glowing diode
    $pS = [System.Drawing.PointF]::new(2.0, 2.0)
    $pE = [System.Drawing.PointF]::new(14.0, 14.0)
    $lbrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $pS, $pE,
        $colors[0],
        $colors[1]
    )
    $lg.FillEllipse($lbrush, 2, 2, 11, 11)
    
    # Specular glint
    $glintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 255, 255, 255))
    $lg.FillEllipse($glintBrush, 4, 4, 3, 3)
    
    $lbmp.Save("$decDir\$name", $fmt)
    $lbmp.Dispose()
    Write-Host "Created $name"
}
