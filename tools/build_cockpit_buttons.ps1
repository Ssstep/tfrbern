Add-Type -AssemblyName System.Drawing

$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"
$fmt = [System.Drawing.Imaging.ImageFormat]::Png

function Build-Cockpit-Button($fileName, $primaryColor, $glowColor) {
    # 2 frames: 236x30 each -> total 472x30
    $w = 472
    $h = 30
    $fw = 236
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

    # --- FRAME 1: NORMAL ---
    $pS1 = [System.Drawing.PointF]::new(0.0, 0.0)
    $pE1 = [System.Drawing.PointF]::new(0.0, [float]$h)
    $f1Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $pS1, $pE1,
        [System.Drawing.Color]::FromArgb(240, 25, 32, 45),
        [System.Drawing.Color]::FromArgb(255, 14, 18, 26)
    )
    $g.FillRectangle($f1Bg, 1, 1, $fw - 2, $h - 2)
    # Edge accent line
    $f1EdgePen = New-Object System.Drawing.Pen($primaryColor, 2)
    $g.DrawLine($f1EdgePen, 1, 2, 8, 2)
    $g.DrawLine($f1EdgePen, 1, 2, 1, 8)
    $g.DrawLine($f1EdgePen, $fw - 2, $h - 3, $fw - 9, $h - 3)
    $g.DrawLine($f1EdgePen, $fw - 2, $h - 3, $fw - 2, $h - 9)
    # Border
    $f1Border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 50, 65, 90), 1)
    $g.DrawRectangle($f1Border, 1, 1, $fw - 3, $h - 3)

    # --- FRAME 2: HOVER / PRESSED (Glow) ---
    $pS2 = [System.Drawing.PointF]::new([float]$fw, 0.0)
    $pE2 = [System.Drawing.PointF]::new([float]$fw, [float]$h)
    $f2Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $pS2, $pE2,
        $primaryColor,
        [System.Drawing.Color]::FromArgb(255, 18, 24, 35)
    )
    $g.FillRectangle($f2Bg, $fw + 1, 1, $fw - 2, $h - 2)
    # Bright glow border
    $f2Border = New-Object System.Drawing.Pen($glowColor, 1)
    $g.DrawRectangle($f2Border, $fw + 1, 1, $fw - 3, $h - 3)
    # Top highlight
    $topPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 255, 255, 255), 1)
    $g.DrawLine($topPen, $fw + 2, 2, $fw + $fw - 3, 2)

    $bmp.Save("$decDir\$fileName", $fmt)
    $bmp.Dispose()
    Write-Host "Created $fileName (472x30, 2 frames)"
}

Build-Cockpit-Button "bern_cockpit_btn_blue.png"   ([System.Drawing.Color]::FromArgb(220, 20, 75, 140))  ([System.Drawing.Color]::FromArgb(255, 0, 210, 255))
Build-Cockpit-Button "bern_cockpit_btn_red.png"    ([System.Drawing.Color]::FromArgb(220, 140, 25, 35))  ([System.Drawing.Color]::FromArgb(255, 255, 75, 75))
Build-Cockpit-Button "bern_cockpit_btn_grey.png"   ([System.Drawing.Color]::FromArgb(220, 90, 85, 45))   ([System.Drawing.Color]::FromArgb(255, 245, 200, 50))
Build-Cockpit-Button "bern_cockpit_btn_purple.png" ([System.Drawing.Color]::FromArgb(220, 105, 30, 140)) ([System.Drawing.Color]::FromArgb(255, 215, 100, 255))
