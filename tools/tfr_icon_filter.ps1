Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$goalsDir = Join-Path $root "gfx\interface\goals"
$rawDir = Join-Path $goalsDir "raw"
$gfxOut = Join-Path $root "interface\bernkastel_goals.gfx"

if (-not (Test-Path $rawDir)) {
    New-Item -ItemType Directory -Path $rawDir -Force | Out-Null
    # Backup original raw icons
    Get-ChildItem -Path $goalsDir -Filter "focus_bern_*.png" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination (Join-Path $rawDir $_.Name) -Force
    }
    Write-Host "[OK] Backed up original icons to $rawDir"
}

$canvasWidth = 92
$canvasHeight = 92

function Process-TfrIcon($srcPath, $dstPath) {
    $srcImg = [System.Drawing.Bitmap]::FromFile($srcPath)
    $bmp = New-Object System.Drawing.Bitmap($canvasWidth, $canvasHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    # Fit image to 82x82 inside 92x92 canvas, leaving bottom space for tactical badge
    $scale = [Math]::Min(80.0 / $srcImg.Width, 80.0 / $srcImg.Height)
    $drawW = [int]($srcImg.Width * $scale)
    $drawH = [int]($srcImg.Height * $scale)
    $drawX = [int]((92 - $drawW) / 2)
    $drawY = [int]((80 - $drawH) / 2)

    # 1. Draw source image
    $g.DrawImage($srcImg, $drawX, $drawY, $drawW, $drawH)
    $srcImg.Dispose()

    # 2. Apply Chromatic Aberration & Scanlines by manipulating bitmap data
    $rect = New-Object System.Drawing.Rectangle(0, 0, $canvasWidth, $canvasHeight)
    $bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = [Math]::Abs($bmpData.Stride) * $canvasHeight
    $rgbValues = New-Object byte[] $bytes
    [System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $rgbValues, 0, $bytes)

    $stride = $bmpData.Stride
    $tempCopy = [byte[]]$rgbValues.Clone()

    for ($y = 0; $y -lt $canvasHeight; $y++) {
        $isScanline = ($y % 2 -eq 0)
        for ($x = 0; $x -lt $canvasWidth; $x++) {
            $idx = ($y * $stride) + ($x * 4) # B, G, R, A
            $alpha = $tempCopy[$idx + 3]
            if ($alpha -gt 10) {
                # Chromatic aberration: Red channel shifted left (-1px), Blue shifted right (+1px)
                if ($x -gt 0) {
                    $leftIdx = ($y * $stride) + (($x - 1) * 4)
                    $rgbValues[$idx + 2] = [Math]::Min(255, [int]$tempCopy[$idx + 2] * 0.7 + [int]$tempCopy[$leftIdx + 2] * 0.4) # Red
                }
                if ($x -lt ($canvasWidth - 1)) {
                    $rightIdx = ($y * $stride) + (($x + 1) * 4)
                    $rgbValues[$idx + 0] = [Math]::Min(255, [int]$tempCopy[$idx + 0] * 0.7 + [int]$tempCopy[$rightIdx + 0] * 0.4) # Blue
                }

                # Crushed blacks & high-contrast punch
                for ($c = 0; $c -lt 3; $c++) {
                    $val = [double]$rgbValues[$idx + $c] / 255.0
                    if ($val -lt 0.35) { $val = [Math]::Max(0.0, $val * 0.75) } # Crush deep shadows
                    else { $val = [Math]::Min(1.0, 0.35 + ($val - 0.35) * 1.25) } # Boost highlights
                    $rgbValues[$idx + $c] = [byte]($val * 255)
                }

                # 15% opacity scanlines on alternate lines
                if ($isScanline) {
                    $rgbValues[$idx + 0] = [byte]([int]$rgbValues[$idx + 0] * 0.85)
                    $rgbValues[$idx + 1] = [byte]([int]$rgbValues[$idx + 1] * 0.85)
                    $rgbValues[$idx + 2] = [byte]([int]$rgbValues[$idx + 2] * 0.85)
                }
            }
        }
    }

    [System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $bmpData.Scan0, $bytes)
    $bmp.UnlockBits($bmpData)

    # 3. Draw TFR Distressed Metallic Geometric Badge Frame at bottom
    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 26, 28, 34))
    $badgeOutline = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 75, 80, 92), 1)
    $purpleRimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 155, 31, 232), 1.2) # #9B1FE8
    $cyanAccentPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 0, 229, 255), 1.0) # #00E5FF

    $pts = [System.Drawing.Point[]]@(
        (New-Object System.Drawing.Point(14, 88)),
        (New-Object System.Drawing.Point(24, 81)),
        (New-Object System.Drawing.Point(68, 81)),
        (New-Object System.Drawing.Point(78, 88)),
        (New-Object System.Drawing.Point(68, 91)),
        (New-Object System.Drawing.Point(24, 91))
    )
    $g.FillPolygon($badgeBrush, $pts)
    $g.DrawPolygon($badgeOutline, $pts)

    # Rim lighting along badge edges
    $g.DrawLine($purpleRimPen, 24, 81, 68, 81)
    $g.DrawLine($cyanAccentPen, 14, 88, 24, 91)
    $g.DrawLine($cyanAccentPen, 78, 88, 68, 91)

    # Tactical metal screw / rivet accents
    $screwBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 128, 140))
    $g.FillRectangle($screwBrush, 21, 84, 2, 2)
    $g.FillRectangle($screwBrush, 69, 84, 2, 2)

    $badgeBrush.Dispose()
    $badgeOutline.Dispose()
    $purpleRimPen.Dispose()
    $cyanAccentPen.Dispose()
    $screwBrush.Dispose()
    $g.Dispose()

    $bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "[OK] Filtered: $(Split-Path $dstPath -Leaf)"
}

# Process all icons in rawDir
$rawFiles = Get-ChildItem -Path $rawDir -Filter "focus_bern_*.png"
Write-Host "Found $($rawFiles.Count) icons in raw dir to process..."
foreach ($rf in $rawFiles) {
    $outPath = Join-Path $goalsDir $rf.Name
    Process-TfrIcon $rf.FullName $outPath
}

# Auto-generate interface/bernkastel_goals.gfx
$goalsPngs = Get-ChildItem -Path $goalsDir -Filter "focus_bern_*.png" | Sort-Object Name
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("spriteTypes = {")
[void]$sb.AppendLine("`t# =====================================================================")
[void]$sb.AppendLine("`t# 1. STATIC FOCUS ICONS (THE FIRE RISES TFR STYLE - 92x92)")
[void]$sb.AppendLine("`t# =====================================================================")
foreach ($gp in $goalsPngs) {
    $stem = $gp.BaseName
    $spriteName = "GFX_$stem"
    $rel = "gfx/interface/goals/$($gp.Name)".Replace("\", "/")
    [void]$sb.AppendLine("`tspriteType = {")
    [void]$sb.AppendLine("`t`tname = `"$spriteName`"")
    [void]$sb.AppendLine("`t`ttexturefile = `"$rel`"")
    [void]$sb.AppendLine("`t}")
}

[void]$sb.AppendLine("`n`t# =====================================================================")
[void]$sb.AppendLine("`t# 2. GLOWING SHINE ANIMATION SPRITES (LEARNING / ACTIVE FOCUS)")
[void]$sb.AppendLine("`t# =====================================================================")
foreach ($gp in $goalsPngs) {
    $stem = $gp.BaseName
    $spriteName = "GFX_${stem}_shine"
    $rel = "gfx/interface/goals/$($gp.Name)".Replace("\", "/")
    [void]$sb.AppendLine("`tSpriteType = {")
    [void]$sb.AppendLine("`t`tname = `"$spriteName`"")
    [void]$sb.AppendLine("`t`ttexturefile = `"$rel`"")
    [void]$sb.AppendLine("`t`teffectFile = `"gfx/FX/buttonstate.lua`"")
    [void]$sb.AppendLine("`t`tanimation = {")
    [void]$sb.AppendLine("`t`t`tanimationmaskfile = `"$rel`"")
    [void]$sb.AppendLine("`t`t`tanimationtexturefile = `"gfx/interface/goals/shine_overlay.dds`"")
    [void]$sb.AppendLine("`t`t`tanimationrotation = -90.0")
    [void]$sb.AppendLine("`t`t`tanimationlooping = no")
    [void]$sb.AppendLine("`t`t`tanimationtime = 0.75")
    [void]$sb.AppendLine("`t`t`tanimationdelay = 0")
    [void]$sb.AppendLine("`t`t`tanimationblendmode = `"add`"")
    [void]$sb.AppendLine("`t`t`tanimationtype = `"scrolling`"")
    [void]$sb.AppendLine("`t`t`tanimationrotationoffset = { x = 0.0 y = 0.0 }")
    [void]$sb.AppendLine("`t`t`tanimationtexturescale = { x = 1.0 y = 1.0 }")
    [void]$sb.AppendLine("`t`t}")
    [void]$sb.AppendLine("`t`tanimation = {")
    [void]$sb.AppendLine("`t`t`tanimationmaskfile = `"$rel`"")
    [void]$sb.AppendLine("`t`t`tanimationtexturefile = `"gfx/interface/goals/shine_overlay.dds`"")
    [void]$sb.AppendLine("`t`t`tanimationrotation = 90.0")
    [void]$sb.AppendLine("`t`t`tanimationlooping = no")
    [void]$sb.AppendLine("`t`t`tanimationtime = 0.75")
    [void]$sb.AppendLine("`t`t`tanimationdelay = 0")
    [void]$sb.AppendLine("`t`t`tanimationblendmode = `"add`"")
    [void]$sb.AppendLine("`t`t`tanimationtype = `"scrolling`"")
    [void]$sb.AppendLine("`t`t`tanimationrotationoffset = { x = 0.0 y = 0.0 }")
    [void]$sb.AppendLine("`t`t`tanimationtexturescale = { x = 1.0 y = 1.0 }")
    [void]$sb.AppendLine("`t`t}")
    [void]$sb.AppendLine("`t`tlegacy_lazy_load = no")
    [void]$sb.AppendLine("`t}")
}
[void]$sb.AppendLine("}")

[System.IO.File]::WriteAllText($gfxOut, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "[OK] Generated $gfxOut with $($goalsPngs.Count) focuses and shines."
