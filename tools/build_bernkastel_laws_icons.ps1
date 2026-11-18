Add-Type -AssemblyName System.Drawing

$dstDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas"

function Build-Tfr-Law-Icon($srcPath, $dstPath, $neonColor, $badgeShape = "circle") {
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
                $r = $r * 0.85
                $gc = $gc * 0.85
                $b = $b * 0.85
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
    Write-Host "Created law icon: $dstPath"
}

$items = @(
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_platinum_seigniorage.png"
        Dst = "$dstDir\idea_BERN_law_platinum_seigniorage.png"
        Color = [System.Drawing.Color]::FromArgb(210, 220, 240)
        Shape = "circle"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_catbox_republic.png"
        Dst = "$dstDir\idea_BERN_law_sealed_catbox_trade.png"
        Color = [System.Drawing.Color]::FromArgb(60, 160, 240)
        Shape = "circle"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\goals\raw\focus_bern_main_core.png"
        Dst = "$dstDir\idea_BERN_law_main_core_conscription.png"
        Color = [System.Drawing.Color]::FromArgb(240, 140, 40)
        Shape = "shield"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_knox_inquisition.png"
        Dst = "$dstDir\idea_BERN_law_knox_military_inquisition.png"
        Color = [System.Drawing.Color]::FromArgb(240, 45, 65)
        Shape = "shield"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\goals\raw\focus_bern_comm_killswitch.png"
        Dst = "$dstDir\idea_BERN_law_erika_606_censorship.png"
        Color = [System.Drawing.Color]::FromArgb(160, 80, 230)
        Shape = "circle"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_schedule_policy_furniture.png"
        Dst = "$dstDir\idea_BERN_law_schedule_f_furniture_state.png"
        Color = [System.Drawing.Color]::FromArgb(120, 140, 170)
        Shape = "shield"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_willard_golden_rule.png"
        Dst = "$dstDir\idea_BERN_law_van_dine_fair_play.png"
        Color = [System.Drawing.Color]::FromArgb(245, 205, 50)
        Shape = "circle"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\ideas\idea_the_threat_that_leaves_chance.png"
        Dst = "$dstDir\idea_BERN_dev_shard_probability_science.png"
        Color = [System.Drawing.Color]::FromArgb(170, 100, 255)
        Shape = "circle"
    },
    @{
        Src = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\goals\raw\focus_bern_gameboard.png"
        Dst = "$dstDir\idea_BERN_dev_hermetic_gameboard_society.png"
        Color = [System.Drawing.Color]::FromArgb(190, 120, 245)
        Shape = "circle"
    }
)

foreach ($item in $items) {
    Build-Tfr-Law-Icon -srcPath $item.Src -dstPath $item.Dst -neonColor $item.Color -badgeShape $item.Shape
}
