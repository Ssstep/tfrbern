$locFile = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\localisation\russian\bernkastel_l_russian.yml"
$content = [System.IO.File]::ReadAllText($locFile, [System.Text.Encoding]::UTF8)

$tumblerLoc = @"

 # =========================================================================
 # АКТИВНЫЕ ТУМБЛЕРЫ И МАТРИЦА УМИНЕКО (INTERACTIVE LEVERS & GAUGES)
 # =========================================================================
 BERN_TUMBLER_TAPE:0 "СКОТЧ"
 BERN_TUMBLER_TAPE_TT:0 "§CТумблер РЭБ и цензуры (47 U.S.C. § 606)§!\nКликните для переключения режима радиоэлектронного подавления."
 BERN_TUMBLER_KNOX:0 "НОКС"
 BERN_TUMBLER_KNOX_TT:0 "§RТумблер Декалога Нокс§!\nКликните для переключения боевого режима приговоров Инквизиции."
 BERN_TUMBLER_AUDIT:0 "АУДИТ"
 BERN_TUMBLER_AUDIT_TT:0 "§YТумблер Ревизии Ван Дайна§!\nКликните для переключения протоколов надзора SSVD."
 BERN_TUMBLER_FURNITURE:0 "МЕБЕЛЬ"
 BERN_TUMBLER_FURNITURE_TT:0 "§0Тумблер Селекции Мебели Schedule F§!\nКликните для переключения автоматической селекции бюрократов в безмолвные пешки."
 BERN_TUMBLER_CORE:0 "MAIN CORE"
 BERN_TUMBLER_CORE_TT:0 "§CТумблер Орбитального Паноптикума MAIN CORE (АНБ)§!\nКликните для переключения глубокого анализа цифровых досье граждан."
 BERN_TUMBLER_PEAD:0 "PEADs"
 BERN_TUMBLER_PEAD_TT:0 "§RТумблер Секретных Директив PEADs§!\nКликните для ввода чрезвычайных президентских ордеров военного положения."
 BERN_TUMBLER_MINT:0 "$1T МОНЕТА"
 BERN_TUMBLER_MINT_TT:0 "§YТумблер Монетного Двора ($1T Сеньораж)§!\nКликните для переключения режима штамповки платиновых триллионных монет."
 BERN_TUMBLER_IMPOUND:0 "ICA АРЕСТ"
 BERN_TUMBLER_IMPOUND_TT:0 "§0Тумблер Заморозки Ассигнований Конгресса (ICA § 683)§!\nКликните для перехвата и удержания бюджетных траншей законодателей."
 BERN_TUMBLER_SCHELLING:0 "ШЕЛЛИНГ"
 BERN_TUMBLER_SCHELLING_TT:0 "§RТумблер Асимметричной Эскалации Шеллинга§!\nКликните для переключения контура принудительного ядерного шантажа (риск 1 к 2 578 917)."

 BERN_TEL_PLATINUM_COMBINED_TEXT:0 "§Y$1T МОНЕТ:§! [BERN_GetPlatinumBar] §Y$[?BERN_minted_platinum_trillions|0]T§! | §RИнфляция:§! §R[?BERN_seigniorage_inflation|0]%§!"
 BERN_TEL_IMPOUND_COMBINED_TEXT:0 "§0ICA АРЕСТ:§! [BERN_GetImpoundBar] §0$[?BERN_impounded_appropriations_b|0]B§! | §WДелегир.:§! §W[?BERN_non_exclusive_delegation|0]%§!"
"@

$updated = $content + $tumblerLoc
$utf8BOM = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($locFile, $updated, $utf8BOM)
Write-Host "Appended tumbler localization with UTF-8 BOM"
