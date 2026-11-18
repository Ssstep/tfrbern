Add-Type -AssemblyName System.Drawing

$files = @(
    "C:\Users\ssste\.gemini\antigravity\brain\1c6de0ea-f058-4842-96c5-0b3f82aea265\.user_uploaded\media_1794531726805_80ab1815.png",
    "gfx/leaders/USA/portrait_frederica_bernkastel.png",
    "gfx/leaders/USA/portrait_frederica_bernkastel_small.png",
    "gfx/interface/decisions/bern_duel_bernkastel.png",
    "gfx/event_pictures/report_event_bernkastel_inauguration.png",
    "gfx/event_pictures/report_event_tea_and_plums.png",
    "gfx/event_pictures/report_event_logic_error.png"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $img = [System.Drawing.Image]::FromFile((Resolve-Path $f).Path)
        Write-Host "$f`: $($img.Width)x$($img.Height)"
        $img.Dispose()
    } else {
        Write-Host "NOT FOUND: $f"
    }
}
