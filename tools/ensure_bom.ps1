$path = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\localisation\russian\bernkastel_l_russian.yml"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
$bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($path, $text, $bom)
Write-Host "Ensured UTF-8 BOM"
