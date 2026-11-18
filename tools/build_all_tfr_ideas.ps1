Add-Type -AssemblyName System.Drawing

$brain = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265"
$dstDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas"

function Build-Tfr-Idea-Icon($srcPath, $dstPath, $neonColor, $badgeShape = "circle") {
    $src = [System.Drawing.Bitmap]::FromFile($srcPath)
    $targetSize = 64
    
    $cropDim = [Math]::Min($src.Width, $src.Height)
    $cropX = [int](($src.Width - $cropDim) / 2)
    $cropY = [int](($src.Height - $cropDim) / 2)
    if ($cropX + $cropDim -gt $src.Width) { $cropDim = $src.Width - $cropX }
    if ($cropY + $cropDim -gt $src.Height) { $cropDim = $src.Height - $cropY }
    
    $rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropDim, $cropDim)
    $cropped = $src.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $src.Dispose()
    
    $dst = New-Object System.Drawing.Bitmap($targetSize, $targetSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dst)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    
    $g.DrawImage($cropped, 0, 0, $targetSize, $targetSize)
    $cropped.Dispose()
    
    for ($y = 0; $y -lt $targetSize; $y++) {
        for ($x = 0; $x -lt $targetSize; $x++) {
            $p = $dst.GetPixel($x, $y)
            if ($p.A -eq 0) { continue }
            
            $cx = $x - 31.5
            $cy = $y - 31.5
            $dist = [Math]::Sqrt($cx * $cx + $cy * $cy)
            
            if ($badgeShape -eq "circle" -and $dist -gt 31.0) {
                $dst.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
                continue
            }
            if ($badgeShape -eq "shield" -and ($x -lt 2 -or $x -gt 61 -or ($y -lt 2 -and ($x -lt 5 -or $x -gt 58)) -or ($y -gt 50 -and $dist -gt 31.0))) {
                $dst.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
                continue
            }
            
            # S-curve Contrast boost
            $r = $p.R / 255.0
            $gc = $p.G / 255.0
            $b = $p.B / 255.0
            
            $r = [Math]::Pow($r, 1.25)
            $gc = [Math]::Pow($gc, 1.25)
            $b = [Math]::Pow($b, 1.25)
            
            # Alternate CRT scanline
            if ($y % 2 -eq 0) {
                $r = $r * 0.82
                $gc = $gc * 0.82
                $b = $b * 0.82
            }
            
            # Neon rim lighting
            if ($dist -ge 27.0 -and $dist -le 30.5) {
                $rimFactor = ($dist - 27.0) / 3.5
                $r = $r * (1.0 - $rimFactor * 0.5) + ($neonColor.R / 255.0) * ($rimFactor * 0.5)
                $gc = $gc * (1.0 - $rimFactor * 0.5) + ($neonColor.G / 255.0) * ($rimFactor * 0.5)
                $b = $b * (1.0 - $rimFactor * 0.5) + ($neonColor.B / 255.0) * ($rimFactor * 0.5)
            }
            
            $ir = [Math]::Min(255, [Math]::Max(0, [int]($r * 255.0)))
            $ig = [Math]::Min(255, [Math]::Max(0, [int]($gc * 255.0)))
            $ib = [Math]::Min(255, [Math]::Max(0, [int]($b * 255.0)))
            
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $ir, $ig, $ib))
        }
    }
    
    if ($badgeShape -eq "circle") {
        $outerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 48, 52, 64), 2.0)
        $g.DrawEllipse($outerPen, 1, 1, 61, 61)
        $outerPen.Dispose()
        
        $neonPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(190, $neonColor.R, $neonColor.G, $neonColor.B), 1.0)
        $g.DrawEllipse($neonPen, 2, 2, 59, 59)
        $neonPen.Dispose()
    } else {
        $outerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 48, 52, 64), 2.0)
        $g.DrawRectangle($outerPen, 2, 2, 59, 59)
        $outerPen.Dispose()
        
        $neonPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(190, $neonColor.R, $neonColor.G, $neonColor.B), 1.0)
        $g.DrawRectangle($neonPen, 3, 3, 57, 57)
        $neonPen.Dispose()
    }
    
    $g.Dispose()
    $dst.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $dst.Dispose()
    Write-Host "[OK] Saved TFR Idea: $(Split-Path $dstPath -Leaf) (64x64)"
}

function Build-Tfr-Minister-Icon($srcPath, $dstPath, $neonColor) {
    $src = [System.Drawing.Bitmap]::FromFile($srcPath)
    $targetW = 62
    $targetH = 67
    
    $cropW = [int]($src.Width * 0.85)
    $cropH = [int]($cropW * ($targetH / $targetW))
    if ($cropH -gt $src.Height) {
        $cropH = $src.Height
        $cropW = [int]($cropH * ($targetW / $targetH))
    }
    $cropX = [int](($src.Width - $cropW) / 2)
    $cropY = [int]($src.Height * 0.05)
    if ($cropX + $cropW -gt $src.Width) { $cropW = $src.Width - $cropX }
    if ($cropY + $cropH -gt $src.Height) { $cropH = $src.Height - $cropY }
    
    $rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
    $cropped = $src.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $src.Dispose()
    
    $dst = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dst)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    
    $g.DrawImage($cropped, 0, 0, $targetW, $targetH)
    $cropped.Dispose()
    
    for ($y = 0; $y -lt $targetH; $y++) {
        for ($x = 0; $x -lt $targetW; $x++) {
            $p = $dst.GetPixel($x, $y)
            $r = $p.R / 255.0
            $gc = $p.G / 255.0
            $b = $p.B / 255.0
            
            $r = [Math]::Pow($r, 1.20)
            $gc = [Math]::Pow($gc, 1.20)
            $b = [Math]::Pow($b, 1.20)
            
            if ($y % 2 -eq 0) {
                $r = $r * 0.85
                $gc = $gc * 0.85
                $b = $b * 0.85
            }
            
            $ir = [Math]::Min(255, [Math]::Max(0, [int]($r * 255.0)))
            $ig = [Math]::Min(255, [Math]::Max(0, [int]($gc * 255.0)))
            $ib = [Math]::Min(255, [Math]::Max(0, [int]($b * 255.0)))
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $ir, $ig, $ib))
        }
    }
    
    $framePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 36, 40, 52), 2.0)
    $g.DrawRectangle($framePen, 1, 1, $targetW - 2, $targetH - 2)
    $framePen.Dispose()
    
    $neonPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, $neonColor.R, $neonColor.G, $neonColor.B), 1.0)
    $g.DrawRectangle($neonPen, 2, 2, $targetW - 5, $targetH - 5)
    $neonPen.Dispose()
    
    $g.Dispose()
    $dst.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $dst.Dispose()
    Write-Host "[OK] Saved TFR Minister: $(Split-Path $dstPath -Leaf) ($targetW x $targetH)"
}

$colorPurple = [System.Drawing.Color]::FromArgb(255, 155, 31, 232)
$colorRed    = [System.Drawing.Color]::FromArgb(255, 230, 0, 38)
$colorCyan   = [System.Drawing.Color]::FromArgb(255, 0, 229, 255)
$colorAmber  = [System.Drawing.Color]::FromArgb(255, 255, 176, 32)

# 1. Catbox Republic
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_catbox_republic_1794923451992.jpg") (Join-Path $dstDir "idea_catbox_republic.png") $colorPurple "circle"

# 2. Gameboard Administration
Build-Tfr-Idea-Icon (Join-Path $brain "focus_bern_gameboard_1794530495425.jpg") (Join-Path $dstDir "idea_gameboard_administration.png") $colorCyan "circle"

# 3. Schedule Policy Furniture
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_schedule_policy_furniture_1794923618648.jpg") (Join-Path $dstDir "idea_schedule_policy_furniture.png") $colorPurple "shield"

# 4. Red Truth Monopoly
Build-Tfr-Idea-Icon (Join-Path $brain "focus_bern_navy_v_egan_1794530493240.jpg") (Join-Path $dstDir "idea_red_truth_monopoly.png") $colorRed "circle"

# 5. Platinum Seigniorage
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_platinum_seigniorage_1794923557540.jpg") (Join-Path $dstDir "idea_platinum_seigniorage.png") $colorCyan "circle"

# 6. Pocket Rescissions
Build-Tfr-Idea-Icon (Join-Path $brain "focus_bern_purse_shatter_1794530504353.jpg") (Join-Path $dstDir "idea_pocket_rescissions.png") $colorAmber "circle"

# 7. The Threat That Leaves Something To Chance
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_threat_leaves_chance_1794923529590.jpg") (Join-Path $dstDir "idea_the_threat_that_leaves_chance.png") $colorRed "shield"

# 8. Existential Boredom
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_existential_boredom_1794923602016.jpg") (Join-Path $dstDir "idea_existential_boredom.png") $colorPurple "circle"

# 9. Knox Inquisition
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_knox_inquisition_1794923661948.jpg") (Join-Path $dstDir "idea_knox_inquisition.png") $colorRed "shield"

# 10. Willard Golden Rule
Build-Tfr-Idea-Icon (Join-Path $brain "tfr_idea_willard_golden_rule_1794923480512.jpg") (Join-Path $dstDir "idea_willard_golden_rule.png") $colorAmber "circle"

# 11. Glorious Ambiguity of Article 5
Build-Tfr-Idea-Icon (Join-Path $brain "focus_bern_article_5_1794530495990.jpg") (Join-Path $dstDir "idea_glorious_ambiguity_nato.png") $colorCyan "circle"

# 12. Erika Furudo (Head of Gov / Intel)
Build-Tfr-Minister-Icon (Join-Path $brain "erika_furudo_hoi4_portrait_1794356312312.jpg") (Join-Path $dstDir "idea_erika_furudo.png") $colorCyan

# 13. Dlanor A. Knox (Attorney General / Interior)
Build-Tfr-Minister-Icon (Join-Path $brain "dlanor_a_knox_portrait_1794356310558.jpg") (Join-Path $dstDir "idea_dlanor_a_knox.png") $colorRed

# 14. Willard H. Wright (Inspector General / Theorist)
Build-Tfr-Minister-Icon (Join-Path $brain "willard_h_wright_portrait_1794356312867.jpg") (Join-Path $dstDir "idea_willard_h_wright.png") $colorAmber

# 15. Clair Vaux Bernardus (Press Sec / Foreign)
Build-Tfr-Minister-Icon (Join-Path $brain "clair_vaux_bernardus_portrait_1794356311636.jpg") (Join-Path $dstDir "idea_clair_vaux_bernardus.png") $colorPurple

# 16. Acting Substitute (FVRA 5 U.S.C. 3345)
Build-Tfr-Minister-Icon (Join-Path $brain "focus_bern_fvra_loophole_1794530426914.jpg") (Join-Path $dstDir "idea_acting_substitute.png") $colorAmber

Write-Host "`nALL 16 TFR NATIONAL SPIRIT AND MINISTER ICONS COMPILED 100% PERFECTLY!"
