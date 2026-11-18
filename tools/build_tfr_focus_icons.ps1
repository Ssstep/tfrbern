Add-Type -AssemblyName System.Drawing

$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$brainDir = "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265"
$tfrGoals = "C:\Program Files (x86)\Steam\steamapps\workshop\content\394360\3350890356\gfx\interface\goals"
$outDir = Join-Path $root "gfx\interface\goals"

$icons = @(
    # Branch I: Gameboard & Sealed Room & Secret PEADs
    @{ Name = "focus_bern_gameboard"; Source = (Join-Path $brainDir "focus_bern_gameboard_1794530495425.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_sealed_room"; Source = (Join-Path $brainDir "focus_bern_sealed_room_1794530506372.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_comm_killswitch"; Source = (Join-Path $tfrGoals "ATW\ATW_Broadcast_Our_Terror.png"); Tint = "cyan" },
    @{ Name = "focus_bern_nea_136"; Source = (Join-Path $tfrGoals "USA\USA_emergency_measures.png"); Tint = "crimson" },
    @{ Name = "focus_bern_peads_blackbox"; Source = (Join-Path $tfrGoals "USA\USA_shadow_presidency.png"); Tint = "purple" },
    @{ Name = "focus_bern_main_core"; Source = (Join-Path $tfrGoals "ATW\ATW_open_their_eyes.png"); Tint = "cyan" },

    # Branch II: Figure Tray & Schedule Policy & Clear Vessel
    @{ Name = "focus_bern_fvra_loophole"; Source = (Join-Path $brainDir "focus_bern_fvra_loophole_1794530426914.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_senate_bypass"; Source = (Join-Path $brainDir "focus_bern_senate_bypass_1794530437358.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_amendment_25"; Source = (Join-Path $brainDir "focus_bern_amendment_25_1794530448702.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_schedule_policy"; Source = (Join-Path $brainDir "focus_bern_schedule_policy_1794530472915.jpg"); Tint = "crimson" },
    @{ Name = "focus_bern_clair_vessel"; Source = (Join-Path $brainDir "focus_bern_clair_vessel_1794530495789.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_void_ab_initio"; Source = (Join-Path $brainDir "focus_bern_void_ab_initio_1794530508503.jpg"); Tint = "crimson" },

    # Branch III: Judicial Fundamentalism & Sentences
    @{ Name = "focus_bern_dlanor_ag"; Source = (Join-Path $brainDir "focus_bern_dlanor_ag_1794530424884.jpg"); Tint = "crimson" },
    @{ Name = "focus_bern_ashcroft_memo"; Source = (Join-Path $brainDir "focus_bern_ashcroft_memo_1794530441288.jpg"); Tint = "crimson" },
    @{ Name = "focus_bern_navy_v_egan"; Source = (Join-Path $brainDir "focus_bern_navy_v_egan_1794530493240.jpg"); Tint = "crimson" },
    @{ Name = "focus_bern_purple_truth"; Source = (Join-Path $tfrGoals "USA\USA_the_third_impeachment.png"); Tint = "purple" },
    @{ Name = "focus_bern_willard_audit"; Source = (Join-Path $tfrGoals "USA\USA_purge_the_pentagon.png"); Tint = "gold" },
    @{ Name = "focus_bern_knox_verdicts"; Source = (Join-Path $tfrGoals "FRA\FAF_Judge_Jury_Executioner.png"); Tint = "crimson" },
    @{ Name = "focus_bern_willard_rebellion"; Source = (Join-Path $brainDir "hoi4_tfr_event_dossier_confrontation_1794356436461.jpg"); Tint = "gold" },

    # Branch IV: Monetary Sorcery & Budget
    @{ Name = "focus_bern_purse_shatter"; Source = (Join-Path $brainDir "focus_bern_purse_shatter_1794530504353.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_trillion_coin"; Source = (Join-Path $brainDir "tfr_platinum_coin_event_1794356429983.jpg"); Tint = "gold" },
    @{ Name = "focus_bern_pocket_rescission"; Source = (Join-Path $tfrGoals "USB\USB_race_against_the_clock.png"); Tint = "purple" },
    @{ Name = "focus_bern_burn_appropriations"; Source = (Join-Path $tfrGoals "ATW\ATW_forges_of_hatred.png"); Tint = "crimson" },

    # Branch V & Finales: NATO, Schelling Inversion & Final Paths
    @{ Name = "focus_bern_article_5"; Source = (Join-Path $brainDir "focus_bern_article_5_1794530495990.jpg"); Tint = "cyan" },
    @{ Name = "focus_bern_tea_and_plums"; Source = (Join-Path $brainDir "tfr_bernkastel_diplomatic_crate_1794356435018.jpg"); Tint = "purple" },
    @{ Name = "focus_bern_schelling_inversion"; Source = (Join-Path $brainDir "tfr_bernkastel_crisis_event_1794356435578.jpg"); Tint = "cyan" },
    @{ Name = "focus_bern_one_in_two_million"; Source = (Join-Path $tfrGoals "ATW\ATW_the_nuclear_congress.png"); Tint = "gold" },
    @{ Name = "focus_bern_no_planned_harmony"; Source = (Join-Path $tfrGoals "USA\USA_the_fire_rises.png"); Tint = "purple" },
    @{ Name = "focus_bern_golden_truth"; Source = (Join-Path $brainDir "tfr_oval_office_bernkastel_1794356429775.jpg"); Tint = "gold" },
    @{ Name = "focus_bern_logic_error"; Source = (Join-Path $brainDir "hoi4_decision_banner_bernkastel_1794356438004.jpg"); Tint = "purple" }
)

$targetW = 160
$targetH = 140

function Convert-TfrFocusIconSeamless($srcPath, $dstPath, $tint) {
    $srcImg = [System.Drawing.Bitmap]::FromFile($srcPath)
    $bmp = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Tight center-crop of source to focus on the key subject and avoid square padding
    $cropMarginX = [int]($srcImg.Width * 0.08)
    $cropMarginY = [int]($srcImg.Height * 0.08)
    $cropW = $srcImg.Width - ($cropMarginX * 2)
    $cropH = $srcImg.Height - ($cropMarginY * 2)
    $cropRect = New-Object System.Drawing.Rectangle($cropMarginX, $cropMarginY, $cropW, $cropH)

    # Destination filling the upper 120px cleanly
    $destRect = New-Object System.Drawing.Rectangle(4, 2, 152, 118)
    $g.DrawImage($srcImg, $destRect, $cropRect, [System.Drawing.GraphicsUnit]::Pixel)
    $srcImg.Dispose()
    $g.Dispose()

    # Pixel processing: edge-to-alpha vignette falloff, black crush to transparency, CRT scanlines, chromatic aberration
    $rect = New-Object System.Drawing.Rectangle(0, 0, $targetW, $targetH)
    $bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = [Math]::Abs($bmpData.Stride) * $targetH
    $rgbValues = New-Object byte[] $bytes
    [System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $rgbValues, 0, $bytes)

    $stride = $bmpData.Stride
    $tempCopy = [byte[]]$rgbValues.Clone()

    for ($y = 0; $y -lt $targetH; $y++) {
        $isScanline = ($y % 2 -eq 0)

        # Bottom safe zone fade factor for focus title text
        $bottomFade = 1.0
        if ($y -gt 105) {
            $bottomFade = [Math]::Max(0.0, [double](140 - $y) / 35.0)
            $bottomFade = $bottomFade * $bottomFade
        }

        # Horizontal edge falloff (distance from nearest side)
        for ($x = 0; $x -lt $targetW; $x++) {
            $idx = ($y * $stride) + ($x * 4) # B, G, R, A
            $origA = $tempCopy[$idx + 3]

            if ($origA -gt 5) {
                # 1. Chromatic aberration: Red -1px, Blue +1px
                $r = $tempCopy[$idx + 2]
                $b = $tempCopy[$idx + 0]
                $gVal = $tempCopy[$idx + 1]

                if ($x -gt 0) {
                    $leftIdx = ($y * $stride) + (($x - 1) * 4)
                    $r = [byte][Math]::Min(255, [int]$r * 0.75 + [int]$tempCopy[$leftIdx + 2] * 0.35)
                }
                if ($x -lt ($targetW - 1)) {
                    $rightIdx = ($y * $stride) + (($x + 1) * 4)
                    $b = [byte][Math]::Min(255, [int]$b * 0.75 + [int]$tempCopy[$rightIdx + 0] * 0.35)
                }

                # 2. Contrast & color pop
                $valR = [double]$r / 255.0
                $valG = [double]$gVal / 255.0
                $valB = [double]$b / 255.0

                if ($valR -lt 0.22) { $valR = [Math]::Max(0.0, $valR * 0.6) } else { $valR = [Math]::Min(1.0, 0.22 + ($valR - 0.22) * 1.25) }
                if ($valG -lt 0.22) { $valG = [Math]::Max(0.0, $valG * 0.6) } else { $valG = [Math]::Min(1.0, 0.22 + ($valG - 0.22) * 1.25) }
                if ($valB -lt 0.22) { $valB = [Math]::Max(0.0, $valB * 0.6) } else { $valB = [Math]::Min(1.0, 0.22 + ($valB - 0.22) * 1.25) }

                # 3. Branch Tint
                switch ($tint) {
                    "purple" {
                        $valR = [Math]::Min(1.0, $valR * 1.08 + 0.04)
                        $valB = [Math]::Min(1.0, $valB * 1.15 + 0.07)
                    }
                    "crimson" {
                        $valR = [Math]::Min(1.0, $valR * 1.20 + 0.08)
                        $valG = [Math]::Max(0.0, $valG * 0.92)
                        $valB = [Math]::Max(0.0, $valB * 0.92)
                    }
                    "cyan" {
                        $valG = [Math]::Min(1.0, $valG * 1.08 + 0.04)
                        $valB = [Math]::Min(1.0, $valB * 1.20 + 0.08)
                    }
                    "gold" {
                        $valR = [Math]::Min(1.0, $valR * 1.18 + 0.06)
                        $valG = [Math]::Min(1.0, $valG * 1.10 + 0.03)
                        $valB = [Math]::Max(0.0, $valB * 0.88)
                    }
                }

                # 4. Subtle Scanline
                if ($isScanline) {
                    $valR *= 0.88; $valG *= 0.88; $valB *= 0.88
                }

                $rgbValues[$idx + 0] = [byte]($valB * 255.0)
                $rgbValues[$idx + 1] = [byte]($valG * 255.0)
                $rgbValues[$idx + 2] = [byte]($valR * 255.0)

                # 5. Seamless Edge Falloff (no rectangular box edges!)
                $distX = [Math]::Min($x, ($targetW - 1) - $x)
                $edgeFactor = 1.0
                if ($distX -lt 18) {
                    $edgeFactor *= [Math]::Min(1.0, [double]$distX / 18.0)
                }
                if ($y -lt 10) {
                    $edgeFactor *= [Math]::Min(1.0, [double]$y / 10.0)
                }
                $edgeFactor *= $bottomFade

                # 6. Black floor threshold (crushes dark background to true transparency)
                $maxC = [Math]::Max($r, [Math]::Max($gVal, $b))
                $darkFade = 1.0
                if ($maxC -lt 24) {
                    $darkFade = 0.0
                } elseif ($maxC -lt 55) {
                    $darkFade = [double]($maxC - 24) / 31.0
                }

                $finalA = [int]($origA * $edgeFactor * $darkFade)
                $rgbValues[$idx + 3] = [byte][Math]::Max(0, [Math]::Min(255, $finalA))
            } else {
                $rgbValues[$idx + 3] = 0
            }
        }
    }

    [System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $bmpData.Scan0, $bytes)
    $bmp.UnlockBits($bmpData)

    $bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Write-Host "=========================================================="
Write-Host "CROP & SEAMLESS RE-RENDER OF ALL 30 TFR FOCUS ICONS"
Write-Host "=========================================================="

$c = 0
foreach ($item in $icons) {
    $dst = Join-Path $outDir "$($item.Name).png"
    Write-Host -NoNewline "Cropping & rendering $($item.Name)... "
    Convert-TfrFocusIconSeamless -srcPath $item.Source -dstPath $dst -tint $item.Tint
    $c++
    Write-Host "OK ($c/30)"
}

Write-Host "=========================================================="
Write-Host "SUCCESS: All $c focus icons cropped and rendered seamlessly!"
Write-Host "=========================================================="
