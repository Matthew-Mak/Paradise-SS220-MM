/datum/spell/shadowling/veil
	name = "Пелена"
	desc = "Вы отключаете большинство источников освещения в радиусе 5-и клеток"
	action_icon_state = "vampire_glare"
	base_cooldown = 15 SECONDS
	stat_allowed = UNCONSCIOUS
	create_attack_logs = FALSE	// Required to stop turf spam to logs

/datum/spell/shadowling/veil/create_new_targeting()
	var/datum/spell_targeting/aoe/turf/T = new
	T.range = 5
	return T

/datum/spell/shadowling/veil/cast(list/targets, mob/user = usr)
	add_attack_logs(user, user, "cast the spell [name]", ATKLOG_ALL)
	to_chat(user, span_purple("Вы бесшумно отключаете источники света поблизости."))
	for(var/turf/T in targets)
		T.extinguish_light()
		for(var/atom/A in T.contents)
			A.extinguish_light()
