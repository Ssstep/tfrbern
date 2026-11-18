Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$spritePath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794531726805_80ab1815.png"
$sprite = [System.Drawing.Bitmap]::FromFile($spritePath)

# Color Grading Function (TFR moody purple & contrast)
function Apply-TfrTone($bmp, $isScanline = $true, $contrast = 1.25) {
    $rect = New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)
    $data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = [Math]::Abs($data.Stride) * $bmp.Height
    $buf = New-Object byte[] $bytes
    [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buf, 0, $bytes)
    $stride = $data.Stride

    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $scan = ($isScanline -and ($y % 2 -eq 0))
        for ($x = 0; $x -lt $bmp.Width; $x++) {
            $i = ($y * $stride) + ($x * 4)
            $a = $buf[$i + 3]
            if ($a -gt 15) {
                $b = [double]$buf[$i + 0] / 255.0
                $g = [double]$buf[$i + 1] / 255.0
                $r = [double]$buf[$i + 2] / 255.0

                # Black crush & contrast
                $r = [Math]::Pow($r, $contrast)
                $g = [Math]::Pow($g, $contrast)
                $b = [Math]::Pow($b, $contrast)

                # Cold purple tint
                $r = [Math]::Min(1.0, $r * 1.04 + 0.02)
                $b = [Math]::Min(1.0, $b * 1.12 + 0.04)

                if ($scan) {
                    $r *= 0.85; $g *= 0.85; $b *= 0.85
                }

                $buf[$i + 0] = [byte]([Math]::Min(255.0, $b * 255.0))
                $buf[$i + 1] = [byte]([Math]::Min(255.0, $g * 255.0))
                $buf[$i + 2] = [byte]([Math]::Min(255.0, $r * 255.0))
            }
        }
    }
    [System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $data.Scan0, $bytes)
    $bmp.UnlockBits($data)
}

function Save-Dds-Uncompressed($bmp, $path) {
    $w = $bmp.Width
    $h = $bmp.Height
    $header = New-Object byte[] 128
    $header[0] = 68; $header[1] = 68; $header[2] = 83; $header[3] = 32
    [BitConverter]::GetBytes([uint32]124).CopyTo($header, 4)
    [BitConverter]::GetBytes([uint32]0x0002100F).CopyTo($header, 8)
    [BitConverter]::GetBytes([uint32]$h).CopyTo($header, 12)
    [BitConverter]::GetBytes([uint32]$w).CopyTo($header, 16)
    [BitConverter]::GetBytes([uint32]($w * 4)).CopyTo($header, 20)
    [BitConverter]::GetBytes([uint32]0).CopyTo($header, 24)
    [BitConverter]::GetBytes([uint32]1).CopyTo($header, 28)
    
    [BitConverter]::GetBytes([uint32]32).CopyTo($header, 76)
    [BitConverter]::GetBytes([uint32]0x00000041).CopyTo($header, 80)
    [BitConverter]::GetBytes([uint32]0).CopyTo($header, 84)
    [BitConverter]::GetBytes([uint32]32).CopyTo($header, 88)
    [BitConverter]::GetBytes([uint32]0x00FF0000).CopyTo($header, 92)
    [BitConverter]::GetBytes([uint32]0x0000FF00).CopyTo($header, 96)
    [BitConverter]::GetBytes([uint32]0x000000FF).CopyTo($header, 100)
    [BitConverter]::GetBytes([uint32]0xFF000000).CopyTo($header, 104)
    [BitConverter]::GetBytes([uint32]0x1000).CopyTo($header, 108)

    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = [Math]::Abs($data.Stride) * $h
    $buf = New-Object byte[] $bytes
    [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buf, 0, $bytes)
    $bmp.UnlockBits($data)

    $fs = [System.IO.File]::Create($path)
    $fs.Write($header, 0, 128)
    $fs.Write($buf, 0, $bytes)
    $fs.Dispose()
    Write-Host "[OK] Saved uncompressed DDS: $path ($w x $h)"
}

Write-Host "=== 1. Primary Leader Portrait (156x210) ==="
$port = New-Object System.Drawing.Bitmap(156, 210, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($port)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$pgrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(0.0, 210.0), [System.Drawing.Color]::FromArgb(255, 115, 95, 140), [System.Drawing.Color]::FromArgb(255, 24, 18, 34))
$g.FillRectangle($pgrad, 0, 0, 156, 210)
$pgrad.Dispose()

# Grid lines
$gridP = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(24, 255, 255, 255), 1)
for ($y = 20; $y -lt 210; $y += 30) { $g.DrawLine($gridP, 0, $y, 156, $y) }
for ($x = 20; $x -lt 156; $x += 30) { $g.DrawLine($gridP, $x, 0, $x, 210) }
$gridP.Dispose()

# Draw Bernkastel (scale ~0.47, centered)
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(-48, 10, 234, 202)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()

Apply-TfrTone $port $false 1.2
$port.Save("$root\gfx\leaders\USA\portrait_frederica_bernkastel.png", [System.Drawing.Imaging.ImageFormat]::Png)
$port.Dispose()
Write-Host "[OK] Saved portrait_frederica_bernkastel.png"

Write-Host "=== 2. Small Leader Portrait (80x96) ==="
$portSm = New-Object System.Drawing.Bitmap(80, 96, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($portSm)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$pgradSm = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(0.0, 96.0), [System.Drawing.Color]::FromArgb(255, 115, 95, 140), [System.Drawing.Color]::FromArgb(255, 24, 18, 34))
$g.FillRectangle($pgradSm, 0, 0, 80, 96)
$pgradSm.Dispose()
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(-16, 2, 114, 98)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
Apply-TfrTone $portSm $false 1.2
$portSm.Save("$root\gfx\leaders\USA\portrait_frederica_bernkastel_small.png", [System.Drawing.Imaging.ImageFormat]::Png)
$portSm.Dispose()
Write-Host "[OK] Saved portrait_frederica_bernkastel_small.png"

Write-Host "=== 3. BoP Planned Harmony (78x88) & Duel Card (80x80) ==="
$bop = New-Object System.Drawing.Bitmap(78, 88, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bop)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$bopG = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(0.0, 88.0), [System.Drawing.Color]::FromArgb(255, 65, 45, 90), [System.Drawing.Color]::FromArgb(255, 18, 12, 28))
$g.FillRectangle($bopG, 0, 0, 78, 88)
$bopG.Dispose()
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(-18, 4, 112, 86)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$bopPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 180, 45, 255), 1.5)
$g.DrawRectangle($bopPen, 1, 1, 75, 85)
$bopPen.Dispose()
$g.Dispose()
Apply-TfrTone $bop $true 1.25
$bop.Save("$root\gfx\interface\bop\bop_BERN_planned_harmony.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bop.Dispose()

$duel = New-Object System.Drawing.Bitmap(80, 80, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($duel)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$duelG = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(0.0, 80.0), [System.Drawing.Color]::FromArgb(255, 85, 55, 110), [System.Drawing.Color]::FromArgb(255, 18, 12, 26))
$g.FillRectangle($duelG, 0, 0, 80, 80)
$duelG.Dispose()
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(-15, 0, 108, 82)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$dPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 180, 45, 255), 1.5)
$g.DrawRectangle($dPen, 1, 1, 77, 77)
$dPen.Dispose()
$g.Dispose()
Apply-TfrTone $duel $false 1.25
$duel.Save("$root\gfx\interface\decisions\bern_duel_bernkastel.png", [System.Drawing.Imaging.ImageFormat]::Png)
$duel.Dispose()
Write-Host "[OK] Saved bop and duel icons"

Write-Host "=== 4. Event Pictures (500x250) ==="
# 4a. Tea and Plums Summit
$evTea = New-Object System.Drawing.Bitmap(500, 250, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($evTea)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$tGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(500.0, 250.0), [System.Drawing.Color]::FromArgb(255, 38, 26, 52), [System.Drawing.Color]::FromArgb(255, 14, 10, 22))
$g.FillRectangle($tGrad, 0, 0, 500, 250)
$tGrad.Dispose()
# Gothic Tea Table
$tableBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 32, 60))
$g.FillRectangle($tableBrush, 0, 175, 500, 75)
$tableBrush.Dispose()
# Gold trim on table
$gTrim = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 215, 160, 60), 2)
$g.DrawLine($gTrim, 0, 175, 500, 175)
$gTrim.Dispose()
# Diplomatic Tea Pot & Plums silhouettes on left
$potBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 200, 180, 100))
$g.FillEllipse($potBrush, 60, 140, 55, 45)
$g.FillRectangle($potBrush, 80, 125, 15, 20)
$g.FillEllipse($potBrush, 135, 160, 20, 20)
$g.FillEllipse($potBrush, 155, 162, 18, 18)
$potBrush.Dispose()
# Canonical Bernkastel seated at the tea table (right)
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(200, 15, 270, 235)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
Apply-TfrTone $evTea $true 1.25
$evTea.Save("$root\gfx\event_pictures\report_event_tea_and_plums.png", [System.Drawing.Imaging.ImageFormat]::Png)
$evTea.Dispose()
Write-Host "[OK] Saved report_event_tea_and_plums.png"

# 4b. Logic Error Catbox Event
$evLogic = New-Object System.Drawing.Bitmap(500, 250, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($evLogic)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$lGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(0.0, 250.0), [System.Drawing.Color]::FromArgb(255, 15, 8, 25), [System.Drawing.Color]::FromArgb(255, 55, 20, 85))
$g.FillRectangle($lGrad, 0, 0, 500, 250)
$lGrad.Dispose()
# Purple Glitch / Reality Shatter Lines
$cPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 220, 60, 255), 1.5)
$g.DrawLine($cPen, 30, 20, 140, 120)
$g.DrawLine($cPen, 140, 120, 90, 230)
$g.DrawLine($cPen, 380, 15, 450, 90)
$g.DrawLine($cPen, 450, 90, 420, 240)
$cPen.Dispose()
# Bernkastel centered in the void of the closed Catbox
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(125, 10, 260, 235)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
Apply-TfrTone $evLogic $true 1.3
$evLogic.Save("$root\gfx\event_pictures\report_event_logic_error.png", [System.Drawing.Imaging.ImageFormat]::Png)
$evLogic.Dispose()
Write-Host "[OK] Saved report_event_logic_error.png"

# 4c. Inauguration Event
$evInaug = New-Object System.Drawing.Bitmap(500, 250, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($evInaug)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$inGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush([System.Drawing.PointF]::new(0.0, 0.0), [System.Drawing.PointF]::new(500.0, 250.0), [System.Drawing.Color]::FromArgb(255, 25, 18, 38), [System.Drawing.Color]::FromArgb(255, 45, 32, 65))
$g.FillRectangle($inGrad, 0, 0, 500, 250)
$inGrad.Dispose()
# Oval Office window frame
$deskBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 32, 24, 46))
$g.FillRectangle($deskBrush, 0, 165, 500, 85)
$deskBrush.Dispose()
# Canonical Bernkastel at presidential podium
$g.DrawImage($sprite, (New-Object System.Drawing.Rectangle(145, 20, 255, 225)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
Apply-TfrTone $evInaug $true 1.25
$evInaug.Save("$root\gfx\event_pictures\report_event_bernkastel_inauguration.png", [System.Drawing.Imaging.ImageFormat]::Png)
$evInaug.Dispose()
Write-Host "[OK] Saved report_event_bernkastel_inauguration.png"

Write-Host "=== 5. Superevent DDS Artwork (556x320) ==="
# PROTECTED: Do not overwrite bern_presidency_superevent.dds (Original TV artwork preserved)
Write-Host "[PROTECTED] bern_presidency_superevent.dds preserved without overwrite."

Write-Host "=== 6. Focus Icons with Canonical Bernkastel (160x140) ==="
$focusNames = @(
    "focus_bern_gameboard",
    "focus_bern_tea_and_plums",
    "focus_bern_golden_truth",
    "focus_bern_purple_truth",
    "focus_bern_logic_error",
    "focus_bern_one_in_two_million",
    "focus_bern_schelling_inversion",
    "focus_bern_sealed_room",
    "focus_bern_no_planned_harmony"
)

foreach ($fn in $focusNames) {
    $fbmp = New-Object System.Drawing.Bitmap(160, 140, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $fg = [System.Drawing.Graphics]::FromImage($fbmp)
    $fg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $fg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $fg.Clear([System.Drawing.Color]::Transparent)

    # Base shield/circle background for focus icon
    $basePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $basePath.AddEllipse(15, 5, 130, 130)
    $bGrad = New-Object System.Drawing.Drawing2D.PathGradientBrush($basePath)
    $bGrad.CenterColor = [System.Drawing.Color]::FromArgb(255, 65, 35, 95)
    $bGrad.SurroundColors = [System.Drawing.Color[]]@([System.Drawing.Color]::FromArgb(0, 15, 10, 25))
    $fg.FillPath($bGrad, $basePath)
    $basePath.Dispose()
    $bGrad.Dispose()

    # Draw canonical Bernkastel bust
    $fg.DrawImage($sprite, (New-Object System.Drawing.Rectangle(12, 8, 140, 125)), 0, 0, $sprite.Width, $sprite.Height, [System.Drawing.GraphicsUnit]::Pixel)

    # Thematic icon accessory / glow ring
    $ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(210, 185, 45, 255), 2)
    if ($fn -like "*golden*") {
        $ringPen.Color = [System.Drawing.Color]::FromArgb(240, 255, 215, 60)
    }
    $fg.DrawEllipse($ringPen, 16, 6, 128, 128)
    $ringPen.Dispose()
    $fg.Dispose()

    Apply-TfrTone $fbmp $true 1.25
    $fbmp.Save("$root\gfx\interface\goals\$fn.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $fbmp.Dispose()
    Write-Host "[OK] Saved $fn.png with canonical Bernkastel"
}

$sprite.Dispose()
Write-Host "=== All Visuals Synchronized to Canonical Bernkastel! ==="
