/datum/component/tts_component
	var/datum/tts_seed/tts_seed

/datum/component/tts_component/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_CHANGE_TTS_SEED, PROC_REF(tts_seed_change))
	RegisterSignal(parent, COMSIG_ATOM_CAST_TTS, PROC_REF(cast_tts))

/datum/component/tts_component/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_CHANGE_TTS_SEED)
	UnregisterSignal(parent, COMSIG_ATOM_CAST_TTS)

/datum/component/tts_component/Initialize(datum/tts_seed/new_tts_seed)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(ispath(new_tts_seed) && SStts220.tts_seeds[initial(new_tts_seed.name)])
		new_tts_seed = SStts220.tts_seeds[initial(new_tts_seed.name)]
	if(istype(new_tts_seed))
		tts_seed = new_tts_seed
	if(!tts_seed)
		tts_seed = get_random_tts_seed_by_gender()
	if(!tts_seed) // Something went terribly wrong
		return COMPONENT_INCOMPATIBLE

/datum/component/tts_component/proc/return_tts_seed()
	SIGNAL_HANDLER
	return tts_seed

/datum/component/tts_component/proc/select_tts_seed(mob/chooser, silent_target = FALSE, override = FALSE, fancy_voice_input_tgui = FALSE)
	if(!chooser)
		if(ismob(parent))
			chooser = parent
		else
			return null

	var/atom/being_changed = parent
	var/static/tts_test_str = "Так звучит мой голос."
	var/datum/tts_seed/new_tts_seed

	if(chooser == being_changed)
		var/datum/character_save/active_character = chooser.client?.prefs.active_character
		if(being_changed.gender == active_character.gender)
			if(alert(chooser, "Оставляем голос вашего персонажа [active_character.real_name] - [active_character.tts_seed]?", "Выбор голоса", "Нет", "Да") ==  "Да")
				if(!SStts220.tts_seeds[active_character.tts_seed])
					to_chat(chooser, span_warning("Отсутствует tts_seed для значения \"[active_character.tts_seed]\". Текущий голос - [tts_seed.name]"))
					return null
				new_tts_seed = SStts220.tts_seeds[active_character.tts_seed]
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, chooser, tts_test_str, new_tts_seed, FALSE)
				return new_tts_seed

	var/tts_seeds
	var/tts_gender = get_converted_tts_seed_gender()
	var/list/tts_seeds_by_gender = SStts220.tts_seeds_by_gender[tts_gender]
	if(check_rights(R_ADMIN, FALSE, chooser) || override || !ismob(being_changed))
		tts_seeds = tts_seeds_by_gender
	else
		tts_seeds = tts_seeds_by_gender && SStts220.get_available_seeds(being_changed) // && for lists means intersection

	var/new_tts_seed_key
	if(fancy_voice_input_tgui)
		new_tts_seed_key = tgui_input_list(chooser, "Выберите голос персонажа", "Преобразуем голос", tts_seeds)
	else
		new_tts_seed_key = input(chooser, "Выберите голос персонажа", "Преобразуем голос") as null|anything in tts_seed
	if(!new_tts_seed_key || !SStts220.tts_seeds[new_tts_seed_key])
		to_chat(chooser, span_warning("Что-то пошло не так с выбором голоса. Текущий голос - [tts_seed.name]"))
		return null

	new_tts_seed = SStts220.tts_seeds[new_tts_seed_key]

	if(!silent_target && being_changed != chooser && ismob(being_changed))
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, being_changed, tts_test_str, new_tts_seed, FALSE)

	if(chooser)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, chooser, tts_test_str, new_tts_seed, FALSE)

	return new_tts_seed

/datum/component/tts_component/proc/tts_seed_change(atom/being_changed, mob/chooser, override = FALSE, fancy_voice_input_tgui = FALSE)
	SIGNAL_HANDLER_DOES_SLEEP
	set waitfor = FALSE
	var/datum/tts_seed/new_tts_seed = select_tts_seed(chooser = chooser, override = override, fancy_voice_input_tgui = fancy_voice_input_tgui)
	if(!new_tts_seed)
		return null
	tts_seed = new_tts_seed

/datum/component/tts_component/proc/get_random_tts_seed_by_gender()
	var/tts_gender = get_converted_tts_seed_gender()
	var/tts_random = pick(SStts220.tts_seeds_by_gender[tts_gender])
	var/datum/tts_seed/seed = SStts220.tts_seeds[tts_random]
	if(!seed)
		return null
	return seed

/datum/component/tts_component/proc/get_converted_tts_seed_gender()
	var/atom/being_changed = parent
	switch(being_changed.gender)
		if(MALE)
			return TTS_GENDER_MALE
		if(FEMALE)
			return TTS_GENDER_FEMALE
		else
			return TTS_GENDER_ANY

/datum/component/tts_component/proc/get_effect(effect)
	. = effect
	switch(.)
		if(SOUND_EFFECT_NONE)
			if(isrobot(parent))
				return SOUND_EFFECT_ROBOT
		if(SOUND_EFFECT_RADIO)
			if(isrobot(parent))
				return SOUND_EFFECT_RADIO_ROBOT
		if(SOUND_EFFECT_MEGAPHONE)
			if(isrobot(parent))
				return SOUND_EFFECT_MEGAPHONE_ROBOT
	return .

/datum/component/tts_component/proc/cast_tts(atom/speaker, mob/listener, message, atom/location, is_local = TRUE, effect = SOUND_EFFECT_NONE, traits = TTS_TRAIT_RATE_FASTER, preSFX, postSFX )
	SIGNAL_HANDLER

	if(!message)
		return
	if(!(listener?.client))
		return

	effect = get_effect(effect)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), location, listener, message, tts_seed, is_local, effect, traits, preSFX, postSFX)

// Component usage

/client/create_response_team_part_1(new_gender, new_species, role, turf/spawn_location)
	. = ..()
	var/mob/living/ert_member = .
	ert_member.change_tts_seed(src.mob)

/mob/living/silicon/verb/synth_change_voice()
	set name = "Смена голоса"
	set desc = "Express yourself!"
	set category = "Подсистемы"
	change_tts_seed(src, fancy_voice_input_tgui = TRUE)
