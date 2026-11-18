Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$spritePath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794531726805_80ab1815.png"
$brainDir = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265"
$tfrGoals = "C:\Program Files (x86)\Steam\steamapps\workshop\content\394360\3350890356\gfx\interface\goals"
$goalsDir = Join-Path $root "gfx\interface\goals"

# Helper for TFR color contrast & grain
function Apply-TfrShading($bmp, $isScanline, $tint) {
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
            if ($a -gt 10) {
                $b = [double]$buf[$i + 0] / 255.0
                $g = [double]$buf[$i + 1] / 255.0
                $r = [double]$buf[$i + 2] / 255.0

                # Contrast & black crush
                if ($r -lt 0.22) { $r = [Math]::Max(0.0, $r * 0.7) } else { $r = [Math]::Min(1.0, 0.22 + ($r - 0.22) * 1.25) }
                if ($g -lt 0.22) { $g = [Math]::Max(0.0, $g * 0.7) } else { $g = [Math]::Min(1.0, 0.22 + ($g - 0.22) * 1.25) }
                if ($b -lt 0.22) { $b = [Math]::Max(0.0, $b * 0.7) } else { $b = [Math]::Min(1.0, 0.22 + ($b - 0.22) * 1.25) }

                if ($tint -eq "purple") {
                    $r = [Math]::Min(1.0, $r * 1.05 + 0.03)
                    $b = [Math]::Min(1.0, $b * 1.12 + 0.05)
                }

                if ($scan) {
                    $r *= 0.88; $g *= 0.88; $b *= 0.88
                }

                $buf[$i + 0] = [byte]($b * 255.0)
                $buf[$i + 1] = [byte]($g * 255.0)
                $buf[$i + 2] = [byte]($r * 255.0)
            }
        }
    }
    [System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $data.Scan0, $bytes)
    $bmp.UnlockBits($data)
}

Write-Host "--- 1. Updating Leader Portrait (156x210) ---"
$portBmp = New-Object System.Drawing.Bitmap(156, 210, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$pg = [System.Drawing.Graphics]::FromImage($portBmp)
$pg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$pg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$topC = [System.Drawing.Color]::FromArgb(255, 120, 102, 142)
$botC = [System.Drawing.Color]::FromArgb(255, 28, 22, 38)
$pgrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(0, 210)), $topC, $botC)
$pg.FillRectangle($pgrad, 0, 0, 156, 210)
$pgrad.Dispose()

# Faint grid lines
$pPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(20, 255, 255, 255), 1)
for ($y = 25; $y -lt 210; $y += 35) { $pg.DrawLine($pPen, 0, $y, 156, $y) }
for ($x = 25; $x -lt 156; $x += 35) { $pg.DrawLine($pPen, $x, 0, $x, 210) }
$pPen.Dispose()

$bSprite = [System.Drawing.Bitmap]::FromFile($spritePath)
# Draw Bernkastel centered
$pg.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(-48, 10, 234, 202)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$pg.Dispose()
Apply-TfrShading $portBmp $false "purple"
$portBmp.Save((Join-Path $root "gfx\leaders\USA\portrait_frederica_bernkastel.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$portBmp.Dispose()
Write-Host "[OK] Saved portrait_frederica_bernkastel.png"

Write-Host "--- 2. Updating Small Portrait (80x96) ---"
$sBmp = New-Object System.Drawing.Bitmap(80, 96, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$sg = [System.Drawing.Graphics]::FromImage($sBmp)
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$sgrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(0, 96)), $topC, $botC)
$sg.FillRectangle($sgrad, 0, 0, 80, 96)
$sgrad.Dispose()
# Crop upper torso/face
$sg.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(-16, 2, 114, 98)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$sg.Dispose()
Apply-TfrShading $sBmp $false "purple"
$sBmp.Save((Join-Path $root "gfx\leaders\USA\portrait_frederica_bernkastel_small.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$sBmp.Dispose()
Write-Host "[OK] Saved portrait_frederica_bernkastel_small.png"

Write-Host "--- 3. Updating BoP Planned Harmony Icon (78x88) ---"
$bopBmp = New-Object System.Drawing.Bitmap(78, 88, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bg = [System.Drawing.Graphics]::FromImage($bopBmp)
$bg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$bopGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(0, 88)), [System.Drawing.Color]::FromArgb(255, 60, 45, 80), [System.Drawing.Color]::FromArgb(255, 18, 14, 26))
$bg.FillRectangle($bopGrad, 0, 0, 78, 88)
$bopGrad.Dispose()
# Draw Bernkastel bust
$bg.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(-18, 4, 112, 86)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
# Purple tactical frame border
$bopPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 155, 31, 232), 1.5)
$bg.DrawRectangle($bopPen, 1, 1, 75, 85)
$bopPen.Dispose()
$bg.Dispose()
Apply-TfrShading $bopBmp $true "purple"
$bopBmp.Save((Join-Path $root "gfx\interface\bop\bop_BERN_planned_harmony.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$bopBmp.Dispose()
Write-Host "[OK] Saved bop_BERN_planned_harmony.png"

Write-Host "--- 4. Updating Decision Duel Icon (80x80) ---"
$duelBmp = New-Object System.Drawing.Bitmap(80, 80, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$dg = [System.Drawing.Graphics]::FromImage($duelBmp)
$dg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$duelGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(0, 80)), [System.Drawing.Color]::FromArgb(255, 80, 50, 100), [System.Drawing.Color]::FromArgb(255, 15, 12, 22))
$dg.FillRectangle($duelGrad, 0, 0, 80, 80)
$duelGrad.Dispose()
$dg.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(-15, 0, 108, 82)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$dPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 155, 31, 232), 1.2)
$dg.DrawRectangle($dPen, 1, 1, 77, 77)
$dPen.Dispose()
$dg.Dispose()
Apply-TfrShading $duelBmp $false "purple"
$duelBmp.Save((Join-Path $root "gfx\interface\decisions\bern_duel_bernkastel.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$duelBmp.Dispose()
Write-Host "[OK] Saved bern_duel_bernkastel.png"

Write-Host "--- 5. Updating Decision Category Banner (504x184) ---"
$bannerBmp = New-Object System.Drawing.Bitmap(504, 184, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bng = [System.Drawing.Graphics]::FromImage($bannerBmp)
$bng.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$bnGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(504, 0)), [System.Drawing.Color]::FromArgb(255, 20, 15, 30), [System.Drawing.Color]::FromArgb(255, 45, 30, 65))
$bng.FillRectangle($bnGrad, 0, 0, 504, 184)
$bnGrad.Dispose()

# Faint chessboard grid on left
$gridP = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 155, 31, 232), 1)
for ($y = 0; $y -lt 184; $y += 23) { $bng.DrawLine($gridP, 0, $y, 350, $y) }
for ($x = 0; $x -lt 350; $x += 23) { $bng.DrawLine($gridP, $x, 0, $x, 184) }
$gridP.Dispose()

# Place Bernkastel on the right side
$bng.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(290, 5, 210, 180)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)

# Top & bottom border neon lines
$topLinePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 155, 31, 232), 2)
$bng.DrawLine($topLinePen, 0, 1, 504, 1)
$bng.DrawLine($topLinePen, 0, 182, 504, 182)
$topLinePen.Dispose()
$bng.Dispose()

Apply-TfrShading $bannerBmp $true "purple"
$bannerBmp.Save((Join-Path $root "gfx\interface\decisions\decision_cat_picture_bernkastel.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$bannerBmp.Dispose()
Write-Host "[OK] Saved decision_cat_picture_bernkastel.png"

Write-Host "--- 6. Updating Inauguration Event Picture (500x250) ---"
$inaugBmp = New-Object System.Drawing.Bitmap(500, 250, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$ing = [System.Drawing.Graphics]::FromImage($inaugBmp)
$ing.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Atmospheric Oval Office base
$inGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(500, 250)), [System.Drawing.Color]::FromArgb(255, 25, 20, 35), [System.Drawing.Color]::FromArgb(255, 45, 35, 60))
$ing.FillRectangle($inGrad, 0, 0, 500, 250)
$inGrad.Dispose()

# Background Resolute Desk / Oval Office window silhouette
$deskBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 35, 26, 45))
$ing.FillRectangle($deskBrush, 0, 160, 500, 90)
$deskBrush.Dispose()

# US Flag silhouette on left
$flagPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(50, 180, 150, 210), 2)
$ing.DrawLine($flagPen, 50, 40, 50, 180)
$flagPen.Dispose()

# Bernkastel centered at the presidential desk
$ing.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(150, 25, 260, 225)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$ing.Dispose()

Apply-TfrShading $inaugBmp $true "purple"
$inaugBmp.Save((Join-Path $root "gfx\event_pictures\report_event_bernkastel_inauguration.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$inaugBmp.Dispose()
Write-Host "[OK] Saved report_event_bernkastel_inauguration.png"

Write-Host "--- 7. Updating Willard Confrontation Event Picture (500x250) ---"
$confBmp = New-Object System.Drawing.Bitmap(500, 250, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$cg = [System.Drawing.Graphics]::FromImage($confBmp)
$cg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Dark dramatic meeting room
$cGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, 0)), (New-Object System.Drawing.Point(500, 0)), [System.Drawing.Color]::FromArgb(255, 35, 28, 48), [System.Drawing.Color]::FromArgb(255, 18, 14, 25))
$cg.FillRectangle($cGrad, 0, 0, 500, 250)
$cGrad.Dispose()

# Willard portrait loaded from existing file if available
$wPath = Join-Path $root "gfx\leaders\USA\portrait_willard_h_wright.png"
if (Test-Path $wPath) {
    $wBmp = [System.Drawing.Bitmap]::FromFile($wPath)
    $cg.DrawImage($wBmp, (New-Object System.Drawing.Rectangle(40, 30, 145, 195)), 0, 0, $wBmp.Width, $wBmp.Height, [System.Drawing.GraphicsUnit]::Pixel)
    $wBmp.Dispose()
}

# Bernkastel on the right
$cg.DrawImage($bSprite, (New-Object System.Drawing.Rectangle(260, 25, 250, 225)), 0, 0, $bSprite.Width, $bSprite.Height, [System.Drawing.GraphicsUnit]::Pixel)
$cg.Dispose()

Apply-TfrShading $confBmp $true "purple"
$confBmp.Save((Join-Path $root "gfx\event_pictures\report_event_willard_confrontation.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$confBmp.Dispose()
Write-Host "[OK] Saved report_event_willard_confrontation.png"

$bSprite.Dispose()
Write-Host "--- All Bernkastel images successfully updated! ---"
