Add-Type -AssemblyName System.Drawing

$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"
$fmt = [System.Drawing.Imaging.ImageFormat]::Png

function Build-Tab-Button($fileName, $tabText, $accentColor) {
    # 2 frames side-by-side: 240x26 each -> total 480x26
    $w = 480
    $h = 26
    $fw = 240
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    # --- FRAME 1: INACTIVE ---
    $f1Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new(0.0, 0.0),
        [System.Drawing.PointF]::new(0.0, [float]$h),
        [System.Drawing.Color]::FromArgb(255, 24, 30, 42),
        [System.Drawing.Color]::FromArgb(255, 12, 16, 24)
    )
    $g.FillRectangle($f1Bg, 1, 1, $fw - 2, $h - 2)
    $f1Border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 55, 70, 95), 1)
    $g.DrawRectangle($f1Border, 1, 1, $fw - 3, $h - 3)
    $f1TextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 160, 180, 205))
    $rect1 = [System.Drawing.RectangleF]::new(0, 0, $fw, $h)
    $g.DrawString($tabText, $font, $f1TextBrush, $rect1, $sf)

    # --- FRAME 2: ACTIVE / HOVER (Glowing) ---
    $f2Bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.PointF]::new([float]$fw, 0.0),
        [System.Drawing.PointF]::new([float]$fw, [float]$h),
        [System.Drawing.Color]::FromArgb(255, 40, 55, 80),
        [System.Drawing.Color]::FromArgb(255, 20, 30, 48)
    )
    $g.FillRectangle($f2Bg, $fw + 1, 1, $fw - 2, $h - 2)
    # Glowing top line
    $f2TopPen = New-Object System.Drawing.Pen($accentColor, 2)
    $g.DrawLine($f2TopPen, $fw + 1, 2, $fw + $fw - 2, 2)
    $f2Border = New-Object System.Drawing.Pen($accentColor, 1)
    $g.DrawRectangle($f2Border, $fw + 1, 1, $fw - 3, $h - 3)
    $f2TextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $rect2 = [System.Drawing.RectangleF]::new($fw, 0, $fw, $h)
    $g.DrawString($tabText, $font, $f2TextBrush, $rect2, $sf)

    $bmp.Save("$decDir\$fileName", $fmt)
    $bmp.Dispose()
    Write-Host "Created $fileName (480x26, 2 frames)"
}

Build-Tab-Button "bern_gui_tab_arch.png" "[ I. АРХИТЕКТУРА ВЛАСТИ ]" ([System.Drawing.Color]::FromArgb(255, 215, 140, 255))
Build-Tab-Button "bern_gui_tab_cockpit.png" "[ II. ТЕЛЕМЕТРИЯ МОСТИКА ]" ([System.Drawing.Color]::FromArgb(255, 0, 230, 255))
