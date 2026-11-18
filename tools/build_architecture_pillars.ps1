Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794919123575_a63d416c.jpg"
$decDir = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Source image size: $($src.Width)x$($src.Height)"

# Function to crop, resize, and save with dark TFR background
function Crop-Resize-Save($x, $y, $w, $h, $targetW, $targetH, $outFile) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $cropped = $src.Clone($rect, $src.PixelFormat)
    
    $dst = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dst)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Fill background with dark slate (#12141a)
    $g.Clear([System.Drawing.Color]::FromArgb(255, 18, 20, 26))
    $g.DrawImage($cropped, 0, 0, $targetW, $targetH)
    
    $g.Dispose()
    $cropped.Dispose()
    
    # Replace white pixels (> 230) on edges with dark slate
    for ($py = 0; $py -lt $targetH; $py++) {
        for ($px = 0; $px -lt $targetW; $px++) {
            $c = $dst.GetPixel($px, $py)
            if ($c.R -gt 230 -and $c.G -gt 230 -and $c.B -gt 230) {
                # replace with semi-dark tone matching UI
                $dst.SetPixel($px, $py, [System.Drawing.Color]::FromArgb(255, 20, 22, 28))
            }
        }
    }
    
    $outPath = Join-Path $decDir $outFile
    $dst.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $dst.Dispose()
    Write-Host "[OK] Saved $outFile ($targetW x $targetH)"
}

# 1. Erika Pillar: blue building
# in 1024x563, Erika facade is around x=155, y=260, w=245, h=185
Crop-Resize-Save 155 260 245 185 156 225 "bern_pillar_blue.png"

# 2. Dlanor Pillar: crimson building
# in 1024x563, Dlanor facade is around x=400, y=260, w=245, h=185
Crop-Resize-Save 400 260 245 185 156 225 "bern_pillar_red.png"

# 3. Willard Pillar: grey building
# in 1024x563, Willard facade is around x=645, y=260, w=245, h=185
Crop-Resize-Save 645 260 245 185 156 225 "bern_pillar_grey.png"

# 4. Chessboard Tray: bottom chessboard with pawns
# in 1024x563, chessboard is around x=80, y=440, w=864, h=120
Crop-Resize-Save 80 440 864 120 486 145 "bern_chessboard_tray.png"

# 5. Top Architecture Header: Capitol dome & Bernkastel banner
# in 1024x563, Dome & banner is around x=200, y=30, w=624, h=230
Crop-Resize-Save 200 30 624 230 500 140 "bern_gui_architecture_header.png"

# 6. Full composite background (500x530)
# Complete architecture background
Crop-Resize-Save 60 25 904 535 500 530 "bern_gui_architecture_bg.png"

$src.Dispose()
Write-Host "ALL GRAPHICS COMPILED SUCCESSFULLY!"
