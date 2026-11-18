$root = "c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
$gfxPath = Join-Path $root "interface\bernkastel_graphics.gfx"
$goalsGfxPath = Join-Path $root "interface\bernkastel_goals.gfx"

# 1. Clean bernkastel_graphics.gfx
$graphicsGfx = @"
spriteTypes = {
	# Leader and Advisor Portraits (156x210 PNG)
	spriteType = {
		name = "GFX_portrait_frederica_bernkastel"
		texturefile = "gfx/leaders/USA/portrait_frederica_bernkastel.png"
		legacy_lazy_load = no
	}
	spriteType = {
		name = "GFX_portrait_erika_furudo"
		texturefile = "gfx/leaders/USA/portrait_erika_furudo.png"
		legacy_lazy_load = no
	}
	spriteType = {
		name = "GFX_portrait_dlanor_a_knox"
		texturefile = "gfx/leaders/USA/portrait_dlanor_a_knox.png"
		legacy_lazy_load = no
	}
	spriteType = {
		name = "GFX_portrait_willard_h_wright"
		texturefile = "gfx/leaders/USA/portrait_willard_h_wright.png"
		legacy_lazy_load = no
	}
	spriteType = {
		name = "GFX_portrait_clair_vaux_bernardus"
		texturefile = "gfx/leaders/USA/portrait_clair_vaux_bernardus.png"
		legacy_lazy_load = no
	}

	# Cabinet Minister / Idea Icons (62x67 PNG)
	spriteType = {
		name = "GFX_idea_erika_furudo"
		texturefile = "gfx/interface/ideas/idea_erika_furudo.png"
	}
	spriteType = {
		name = "GFX_idea_dlanor_a_knox"
		texturefile = "gfx/interface/ideas/idea_dlanor_a_knox.png"
	}
	spriteType = {
		name = "GFX_idea_willard_h_wright"
		texturefile = "gfx/interface/ideas/idea_willard_h_wright.png"
	}
	spriteType = {
		name = "GFX_idea_clair_vaux_bernardus"
		texturefile = "gfx/interface/ideas/idea_clair_vaux_bernardus.png"
	}

	# National Spirits (64x64 PNG)
	spriteType = {
		name = "GFX_idea_catbox_republic"
		texturefile = "gfx/interface/ideas/idea_catbox_republic.png"
	}
	spriteType = {
		name = "GFX_idea_gameboard_administration"
		texturefile = "gfx/interface/ideas/idea_gameboard_administration.png"
	}
	spriteType = {
		name = "GFX_idea_schedule_policy_furniture"
		texturefile = "gfx/interface/ideas/idea_schedule_policy_furniture.png"
	}
	spriteType = {
		name = "GFX_idea_red_truth_monopoly"
		texturefile = "gfx/interface/ideas/idea_red_truth_monopoly.png"
	}
	spriteType = {
		name = "GFX_idea_platinum_seigniorage"
		texturefile = "gfx/interface/ideas/idea_platinum_seigniorage.png"
	}
	spriteType = {
		name = "GFX_idea_pocket_rescissions"
		texturefile = "gfx/interface/ideas/idea_pocket_rescissions.png"
	}
	spriteType = {
		name = "GFX_idea_the_threat_that_leaves_chance"
		texturefile = "gfx/interface/ideas/idea_the_threat_that_leaves_chance.png"
	}
	spriteType = {
		name = "GFX_idea_existential_boredom"
		texturefile = "gfx/interface/ideas/idea_existential_boredom.png"
	}
	spriteType = {
		name = "GFX_idea_knox_inquisition"
		texturefile = "gfx/interface/ideas/idea_knox_inquisition.png"
	}
	spriteType = {
		name = "GFX_idea_willard_golden_rule"
		texturefile = "gfx/interface/ideas/idea_willard_golden_rule.png"
	}
	spriteType = {
		name = "GFX_idea_glorious_ambiguity_nato"
		texturefile = "gfx/interface/ideas/idea_glorious_ambiguity_nato.png"
	}
	spriteType = {
		name = "GFX_idea_acting_substitute"
		texturefile = "gfx/interface/ideas/idea_acting_substitute.png"
	}

	# Balance of Power (78x88 PNG)
	spriteType = {
		name = "GFX_bop_BERN_planned_harmony"
		texturefile = "gfx/interface/bop/bop_BERN_planned_harmony.png"
	}
	spriteType = {
		name = "GFX_bop_BERN_logic_error"
		texturefile = "gfx/interface/bop/bop_BERN_logic_error.png"
	}

	# Decision Category and Decision Icons
	spriteType = {
		name = "GFX_decision_category_bernkastel"
		texturefile = "gfx/interface/decisions/decision_category_bernkastel.png"
	}
	spriteType = {
		name = "GFX_decision_cat_picture_bernkastel"
		texturefile = "gfx/interface/decisions/decision_cat_picture_bernkastel.png"
	}
	spriteType = {
		name = "GFX_decision_shard"
		texturefile = "gfx/interface/decisions/decision_shard.png"
	}
	spriteType = {
		name = "GFX_decision_trillion_coin"
		texturefile = "gfx/interface/decisions/decision_trillion_coin.png"
	}
	spriteType = {
		name = "GFX_decision_erika_tape"
		texturefile = "gfx/interface/decisions/decision_erika_tape.png"
	}
	spriteType = {
		name = "GFX_decision_void_ab_initio"
		texturefile = "gfx/interface/decisions/decision_void_ab_initio.png"
	}
	spriteType = {
		name = "GFX_decision_purple_truth"
		texturefile = "gfx/interface/decisions/decision_purple_truth.png"
	}
	spriteType = {
		name = "GFX_decision_pead"
		texturefile = "gfx/interface/decisions/decision_pead.png"
	}
	spriteType = {
		name = "GFX_decision_boredom"
		texturefile = "gfx/interface/decisions/decision_boredom.png"
	}

	# Report Event Pictures (500x250 PNG)
	spriteType = {
		name = "GFX_report_event_bernkastel_inauguration"
		texturefile = "gfx/event_pictures/report_event_bernkastel_inauguration.png"
	}
	spriteType = {
		name = "GFX_report_event_trillion_coin"
		texturefile = "gfx/event_pictures/report_event_trillion_coin.png"
	}
	spriteType = {
		name = "GFX_report_event_tea_and_plums"
		texturefile = "gfx/event_pictures/report_event_tea_and_plums.png"
	}
	spriteType = {
		name = "GFX_report_event_willard_confrontation"
		texturefile = "gfx/event_pictures/report_event_willard_confrontation.png"
	}
	spriteType = {
		name = "GFX_report_event_logic_error"
		texturefile = "gfx/event_pictures/report_event_logic_error.png"
	}
}
"@

# 2. Build bernkastel_goals.gfx for all 30 Focuses + Shines
$focusNames = @(
    "focus_bern_amendment_25",
    "focus_bern_article_5",
    "focus_bern_ashcroft_memo",
    "focus_bern_burn_appropriations",
    "focus_bern_clair_vessel",
    "focus_bern_comm_killswitch",
    "focus_bern_dlanor_ag",
    "focus_bern_fvra_loophole",
    "focus_bern_gameboard",
    "focus_bern_golden_truth",
    "focus_bern_knox_verdicts",
    "focus_bern_logic_error",
    "focus_bern_main_core",
    "focus_bern_navy_v_egan",
    "focus_bern_nea_136",
    "focus_bern_no_planned_harmony",
    "focus_bern_one_in_two_million",
    "focus_bern_peads_blackbox",
    "focus_bern_pocket_rescission",
    "focus_bern_purple_truth",
    "focus_bern_purse_shatter",
    "focus_bern_schedule_policy",
    "focus_bern_schelling_inversion",
    "focus_bern_sealed_room",
    "focus_bern_senate_bypass",
    "focus_bern_tea_and_plums",
    "focus_bern_trillion_coin",
    "focus_bern_void_ab_initio",
    "focus_bern_willard_audit",
    "focus_bern_willard_rebellion"
)

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("spriteTypes = {")
[void]$sb.AppendLine("	# Static Focus Icons (160x140 PNG)")

foreach ($fn in $focusNames) {
    [void]$sb.AppendLine("	spriteType = {")
    [void]$sb.AppendLine("		name = `"GFX_$fn`"")
    [void]$sb.AppendLine("		texturefile = `"gfx/interface/goals/$fn.png`"")
    [void]$sb.AppendLine("	}")
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("	# Focus Shine Sprites (for learning / active animation in GUI)")

foreach ($fn in $focusNames) {
    [void]$sb.AppendLine("	spriteType = {")
    [void]$sb.AppendLine("		name = `"GFX_${fn}_shine`"")
    [void]$sb.AppendLine("		texturefile = `"gfx/interface/goals/$fn.png`"")
    [void]$sb.AppendLine("	}")
}

[void]$sb.AppendLine("}")
$goalsGfx = $sb.ToString()

# Write files strictly without BOM as UTF-8
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($gfxPath, $graphicsGfx, $utf8NoBom)
[System.IO.File]::WriteAllText($goalsGfxPath, $goalsGfx, $utf8NoBom)

Write-Host "[OK] Saved $gfxPath WITHOUT BOM"
Write-Host "[OK] Saved $goalsGfxPath WITHOUT BOM"
