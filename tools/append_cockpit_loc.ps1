$locFile = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA\localisation\russian\bernkastel_l_russian.yml"
$content = [System.IO.File]::ReadAllText($locFile, [System.Text.Encoding]::UTF8)

$cockpitLoc = @"

 # =========================================================================
 # ТАКТИЧЕСКИЙ МОСТИК: ТЕЛЕМЕТРИЯ СИСТЕМ (TNO / TFR COCKPIT HUD)
 # =========================================================================
 BERN_GUI_TAB_ARCH:0 "§M[ I. АРХИТЕКТУРА ВЛАСТИ ]§!"
 BERN_GUI_TAB_COCKPIT:0 "§C[ II. ТЕЛЕМЕТРИЯ МОСТИКА ]§!"

 BERN_COCKPIT_HUD_TITLE:0 "§CМОСТИК УПРАВЛЕНИЯ: ГИПЕРКОНТУР КОШАЧЬЕГО ЯЩИКА§!"
 BERN_COCKPIT_CALLSIGN:0 "§8[ ТАКТИЧЕСКИЙ ТЕРМИНАЛ: USS CATBOX // SSN-809 // ORBITAL GAMEMASTER ]§!"

 BERN_COCKPIT_SECTOR1_TITLE:0 "§0[ СЕКТОР I: ГИПЕРКОНТУР И РЕАКТОР ВЕДЬМЫ ]§!"
 BERN_COCKPIT_SECTOR2_TITLE:0 "§C[ СЕКТОР II: СЕНСОРНЫЙ ПЕРИМЕТР, РЭБ И ИНКВИЗИЦИЯ ]§!"
 BERN_COCKPIT_SECTOR3_TITLE:0 "§Y[ СЕКТОР III: ЭКИПАЖ, ЛОТОК ДЛЯ ФИГУР И SCHEDULE F ]§!"
 BERN_COCKPIT_SECTOR4_TITLE:0 "§R[ СЕКТОР IV: ОРБИТАЛЬНЫЙ КОМПЛЕКС, ФИНАНСЫ И СУДНЫЙ ДЕНЬ ]§!"
 BERN_COCKPIT_PANEL_ACTIONS_TITLE:0 "§G[ ТАКТИЧЕСКИЙ ПУЛЬТ ОПЕРАТИВНОГО ПЕРЕХВАТА И КОМАНД ]§!"

 BERN_COCKPIT_BTN_ERIKA:0 "47 U.S.C. § 606: Скотч"
 BERN_COCKPIT_BTN_DLANOR:0 "Декалог: Приговор"
 BERN_COCKPIT_BTN_WILLARD:0 "Ревизия Ван Дайна"
 BERN_COCKPIT_BTN_PURGE:0 "Сброс Void Ab Initio"
 BERN_COCKPIT_STATUS_LOG:0 "§8СТАТУС: ГИПЕРКОНТУР АКТИВЕН // СИСТЕМА УПРАВЛЕНИЯ ВЕДЬМЫ В НОРМЕ §C[ONLINE]§!"

 # Телеметрия 17 переменных состояния
 BERN_TEL_BOREDOM_TEXT:0 "§CСКУКА:§!   [BERN_GetBoredomBar] §C[?BERN_existential_boredom|0]%§!"
 BERN_TEL_BOREDOM_TT:0 "§CЭкзистенциальная Скука Ведьмы Чудес§!\nТекущий уровень: §C[?BERN_existential_boredom|0]%§!\nПри достижении §R100%§! (или падении BoP в левый полюс) Бернкастель покинет Белый дом, что приведёт к немедленному крушению администрации."

 BERN_TEL_LOGIC_ERROR_TEXT:0 "§0ОШИБКА:§!  [BERN_GetLogicErrorBar] §0[?BERN_logic_error_progress|0]%§!"
 BERN_TEL_LOGIC_ERROR_TT:0 "§0Логическая Ошибка Кошачьего Ящика§!\nТекущий прогресс замыкания: §0[?BERN_logic_error_progress|0]%§!\nБаффы: §G+25% шифрование§!, §G+20% подчинение§!, §G-20% сопротивление§!. При достижении §C100%§! происходит абсолютная фиксация правления Ведьмы."

 BERN_TEL_TOXIN_TEXT:0 "§OТОКСИН:§!   [BERN_GetToxinBar] §O[?BERN_anti_magic_toxin|0]%§!"
 BERN_TEL_TOXIN_TT:0 "§OАнтимагический Токсин (Здравый смысл и сопротивление)§!\nТекущий уровень: §O[?BERN_anti_magic_toxin|0]%§!\nДебафф: §R-[?BERN_anti_magic_toxin|%1] к полит. власти§!, пассивный саботаж указов и скептицизм судебной системы."

 BERN_TEL_TAPE_TEXT:0 "§CСКОТЧ 47:§! [BERN_GetTapeBar] §C[?BERN_duct_tape_seal_integrity|0]%§!"
 BERN_TEL_TAPE_TT:0 "§CЦелостность скотча Эрики Фурудо (47 U.S.C. § 606)§!\nТекущая целостность: §C[?BERN_duct_tape_seal_integrity|0]%§!\nБафф: §G-[?BERN_duct_tape_seal_integrity|%1] к цели сопротивления§!, §G+50% защита контрразведки§! от утечек."

 BERN_TEL_RED_TRUTH_TEXT:0 "§RИСТИНА:§!   [BERN_GetRedTruthBar] §R[?BERN_red_truth_dossiers|0] ед.§!"
 BERN_TEL_RED_TRUTH_TT:0 "§RДосье Красной Истины Дланор А. Нокс§!\nВ наличии: §R[?BERN_red_truth_dossiers|0] досье§!\nСлужит неопровержимым юридическим оружием для вынесения смертных приговоров Декалога Нокс (ликвидация токсина и укрепление режима)."

 BERN_TEL_CONTRADICTIONS_TEXT:0 "§0ПАРАДОКС:§! [BERN_GetContradictionBar] §0[?BERN_purple_contradictions|0] сенат.§!"
 BERN_TEL_CONTRADICTIONS_TT:0 "§0Пурпурные Противоречия в Конгрессе§!\nЗафиксировано: §0[?BERN_purple_contradictions|0] сенаторов§!\nКонгрессмены пойманы на ложных показаниях по 18 U.S.C. § 1001, обеспечивая полный иммунитет Президента к импичменту."

 BERN_TEL_WILLARD_TEXT:0 "§YАУДИТ:§!    [BERN_GetWillardBar] §Y[?BERN_willard_heart_resistance|0]%§!"
 BERN_TEL_WILLARD_TT:0 "§YАудит Ван Дайна (Инспектор Уиллард Х. Райт)§!\nУгроза внутреннего бунта: §Y[?BERN_willard_heart_resistance|0]%§!\nДебафф: §R-[?BERN_willard_heart_resistance|%1] стабильности§!. При превышении 80% инспектор поднимет бунт против ведьмы."

 BERN_TEL_FURNITURE_TEXT:0 "§YМЕБЕЛЬ F:§! [BERN_GetFurnitureBar] §Y[?BERN_schedule_f_furniture_ratio|0]%§!"
 BERN_TEL_FURNITURE_TT:0 "§YСтатус «Мебели» чиновников (Schedule Policy/Career)§!\nДоля обращённых чиновников: §Y[?BERN_schedule_f_furniture_ratio|0]%§!\nБафф: §G+[?BERN_schedule_f_furniture_ratio|%1] стабильности§!, §G+15% эффективность фабрик§!, ликвидация забастовок."

 BERN_TEL_CABINET_TEXT:0 "§CИО FVRA:§!  [BERN_GetCabinetBar] §C[?BERN_acting_cabinet_slots|0] / 15§!"
 BERN_TEL_CABINET_TT:0 "§CИсполняющие обязанности министров (5 U.S.C. § 3345)§!\nЗанято постов: §C[?BERN_acting_cabinet_slots|0] из 15§!\nПозволяет обходить утверждение Сената и блокировать 25-ю поправку. Каждый ИО ограничен таймером 210 дней."

 BERN_TEL_VOID_TEXT:0 "§0VOID:§!     [BERN_GetVoidBar] §0[?BERN_void_ab_initio_charges|0] орд.§!"
 BERN_TEL_VOID_TT:0 "§0Ордера аннуляции Void Ab Initio (5 U.S.C. § 3348)§!\nВ распоряжении: §0[?BERN_void_ab_initio_charges|0] ордеров§!\nПозволяет моментально сбрасывать чиновников в Лоток фигур, продлевая таймер часов FVRA на +90 дней."

 BERN_TEL_DELEGATION_TEXT:0 "§WДЕЛЕГИР.:§! [BERN_GetDelegationBar] §W[?BERN_non_exclusive_delegation|0]%§!"
 BERN_TEL_DELEGATION_TT:0 "§WНеисключительное делегирование полномочий§!\nУровень дублирования: §W[?BERN_non_exclusive_delegation|0]%§!\nБафф: §G+[?BERN_non_exclusive_delegation|%1] прироста полит. власти§! в обход согласования ведомств."

 BERN_TEL_MAIN_CORE_TEXT:0 "§CАНБ CORE:§! [BERN_GetMainCoreBar] §C[?BERN_main_core_indexed_millions|1]M§!"
 BERN_TEL_MAIN_CORE_TT:0 "§CРеестр цифровой слежки MAIN CORE (АНБ)§!\nИндексировано граждан: §C[?BERN_main_core_indexed_millions|1] млн§!\nБафф: §G+40% обнаружение шпионов§!, §G-35% вражеский саботаж§!, §G+25% расшифровка шифров§!."

 BERN_TEL_PEADS_TEXT:0 "§RPEADs:§!    [BERN_GetPeadsBar] §R[?BERN_active_peads_count|0] дир.§!"
 BERN_TEL_PEADS_TT:0 "§RСекретные Президентские Чрезвычайные Директивы PEADs§!\nАктивировано: §R[?BERN_active_peads_count|0] директив§!\nБафф: неограниченные чрезвычайные полномочия, §G+15% командного ресурса§!, §G+20% скорости мобилизации§!."

 BERN_TEL_PLATINUM_TEXT:0 "§Y$1T МОНЕТ:§![BERN_GetPlatinumBar] §Y$[?BERN_minted_platinum_trillions|0]T§!"
 BERN_TEL_PLATINUM_TT:0 "§YПлатиновый сеньораж (31 U.S.C. § 5112(k))§!\nОтчеканено монет: §Y$[?BERN_minted_platinum_trillions|0] трлн§!\nБафф: прямое финансирование бюджета и строительства (+6% скорости стройки за монету, списание $500 млрд долга)."

 BERN_TEL_INFLATION_TEXT:0 "§RИНФЛЯЦИЯ:§! [BERN_GetInflationBar] §R[?BERN_seigniorage_inflation|0]%§!"
 BERN_TEL_INFLATION_TT:0 "§RИнфляционный перегрев экономики§!\nТекущий уровень: §R[?BERN_seigniorage_inflation|0]%§!\nДебафф: §R-[?BERN_seigniorage_inflation|%1] стабильности§!, падение эффективности гражданских фабрик и удорожание товаров."

 BERN_TEL_IMPOUND_TEXT:0 "§0ICA АРЕСТ:§![BERN_GetImpoundBar] §0$[?BERN_impounded_appropriations_b|0]B§!"
 BERN_TEL_IMPOUND_TT:0 "§0Замороженные ассигнования Конгресса (ICA 2 U.S.C. § 683)§!\nУдержано средств: §0$[?BERN_impounded_appropriations_b|0] млрд§!\nПрезидентский перехват бюджетных потоков для спецпроектов Ведьмы."

 BERN_TEL_SCHELLING_TEXT:0 "§RШЕЛЛИНГ:§!  [BERN_GetSchellingBar] §R[?BERN_schelling_brinkmanship_risk|0]%§!"
 BERN_TEL_SCHELLING_TT:0 "§RЯдерный Пазл Шеллинга (Асимметричный Шантаж)§!\nТекущий риск кризиса: §R[?BERN_schelling_brinkmanship_risk|0]%§!\nБафф: принуждение великих держав к безоговорочной капитуляции с шансом 90% при балансировании на грани апокалипсиса."
"@

$updated = $content + $cockpitLoc
$utf8BOM = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($locFile, $updated, $utf8BOM)
Write-Host "Updated bernkastel_l_russian.yml with UTF-8 BOM"
