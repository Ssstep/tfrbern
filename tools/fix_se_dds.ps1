Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$spritePath = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794531726805_80ab1815.png"
$sprite = [System.Drawing.Bitmap]::FromFile($spritePath)

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

                $r = [Math]::Pow($r, $contrast)
                $g = [Math]::Pow($g, $contrast)
                $b = [Math]::Pow($b, $contrast)

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
    [BitConverter]::GetBytes([int32]-16777216).CopyTo($header, 104)
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

# PROTECTED: Do not overwrite bern_presidency_superevent.dds (Original TV artwork preserved)
# $seBmp = New-Object System.Drawing.Bitmap(556, 320, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
# ... TV Superevent artwork is managed by tools/restore_tv_superevent.py
$sprite.Dispose()
Write-Host "[PROTECTED] bern_presidency_superevent.dds preserved without overwrite."
