Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794919123575_a63d416c.jpg"
$dstPath = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\interface\decisions\bern_gui_architecture_art.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Source: $($src.Width)x$($src.Height)"

$targetW = 500
$targetH = 275

$dst = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$g.Clear([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
$g.DrawImage($src, 0, 0, $targetW, $targetH)
$g.Dispose()
$src.Dispose()

# Flood-fill BFS from the corners to only erase the external white background
$visited = New-Object 'bool[,]' $targetW, $targetH
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

# Enqueue all border pixels that are near white
for ($x = 0; $x -lt $targetW; $x++) {
    $c1 = $dst.GetPixel($x, 0)
    if ($c1.R -gt 225 -and $c1.G -gt 225 -and $c1.B -gt 225) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, 0)))
        $visited[$x, 0] = $true
    }
    $c2 = $dst.GetPixel($x, $targetH - 1)
    if ($c2.R -gt 225 -and $c2.G -gt 225 -and $c2.B -gt 225) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, $targetH - 1)))
        $visited[$x, $targetH - 1] = $true
    }
}
for ($y = 0; $y -lt $targetH; $y++) {
    $c1 = $dst.GetPixel(0, $y)
    if ($c1.R -gt 225 -and $c1.G -gt 225 -and $c1.B -gt 225) {
        $queue.Enqueue((New-Object System.Drawing.Point(0, $y)))
        $visited[0, $y] = $true
    }
    $c2 = $dst.GetPixel($targetW - 1, $y)
    if ($c2.R -gt 225 -and $c2.G -gt 225 -and $c2.B -gt 225) {
        $queue.Enqueue((New-Object System.Drawing.Point($targetW - 1, $y)))
        $visited[$targetW - 1, $y] = $true
    }
}

$dx = @(1, -1, 0, 0)
$dy = @(0, 0, 1, -1)

while ($queue.Count -gt 0) {
    $pt = $queue.Dequeue()
    $dst.SetPixel($pt.X, $pt.Y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))

    for ($i = 0; $i -lt 4; $i++) {
        $nx = $pt.X + $dx[$i]
        $ny = $pt.Y + $dy[$i]

        if ($nx -ge 0 -and $nx -lt $targetW -and $ny -ge 0 -and $ny -lt $targetH) {
            if (-not $visited[$nx, $ny]) {
                $nc = $dst.GetPixel($nx, $ny)
                if ($nc.R -gt 220 -and $nc.G -gt 220 -and $nc.B -gt 220) {
                    $visited[$nx, $ny] = $true
                    $queue.Enqueue((New-Object System.Drawing.Point($nx, $ny)))
                }
            }
        }
    }
}

$dst.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
$dst.Dispose()

Write-Host "[OK] Clean transparent flood-fill saved to bern_gui_architecture_art.png"
