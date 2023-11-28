#define SOUND_BEEP(sound) add_queue(##sound, 20)
#define MORPHINE_INJECTION_DELAY (30 SECONDS)

//Suit
/obj/item/clothing/suit/space/hev
	name = "\improper hazardous environment suit"
	desc = "The Mark IV HEV suit protects the user from a number of hazardous environments and has in build ballistic protection."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "hev"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "hev"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF | STOPSPRESSUREDMAGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	armor = list(MELEE = 35, BULLET = 30, LASER = 20, ENERGY = 25, BOMB = 30, RAD = 100, FIRE = 80, ACID = 50)
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/gun/energy,
		/obj/item/gun/projectile,
		/obj/item/crowbar,
	)
	slowdown = 0.25

	var/static/list/funny_signals = list(
		COMSIG_MOB_SAY = PROC_REF(handle_speech),
		COMSIG_MOB_DEATH = PROC_REF(handle_death),
		COMSIG_LIVING_IGNITED = PROC_REF(handle_ignite),
		COMSIG_LIVING_ELECTROCUTE_ACT = PROC_REF(handle_shock),
	//	COMSIG_MOB_APPLY_DAMAGE= PROC_REF(handle_damage),
	)


	var/list/sound_queue = list()

	var/emag_doses_left = 5

	var/mob/living/carbon/owner

	var/obj/item/geiger_counter/GC

	COOLDOWN_DECLARE(next_damage_notify)
	COOLDOWN_DECLARE(next_morphine)

/obj/item/clothing/suit/space/hev/Initialize(mapload)
	. = ..()
	GC = new(src)
	GC.scanning = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/clothing/suit/space/hev/Destroy()
	QDEL_NULL(GC)
	owner = null
	return ..()

/obj/item/clothing/suit/space/hev/proc/process_sound_queue()

	var/list/sound_data = sound_queue[1]
	var/sound_file = sound_data[1]
	var/sound_delay = sound_data[2]

	playsound(src, sound_file, 50)

	sound_queue.Cut(1,2)

	if(!length(sound_queue))
		return

	addtimer(CALLBACK(src, PROC_REF(process_sound_queue)), sound_delay)

/obj/item/clothing/suit/space/hev/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(flags & emagged)
		return FALSE
	if(owner)
		to_chat(owner, span_warning("You need to take off \the [name] before emagging it."))
		return FALSE
	flags |= emagged
	do_sparks(8, FALSE, get_turf(src))
	return TRUE

/obj/item/clothing/suit/space/hev/proc/add_queue(desired_file, desired_delay, purge_queue=FALSE)

	var/was_empty_sound_queue = !length(sound_queue)

	if(purge_queue)
		sound_queue.Cut()

	sound_queue += list(list(desired_file,desired_delay)) //BYOND is fucking weird so you have to do this bullshit if you want to add a list to a list.

	if(was_empty_sound_queue)
		addtimer(CALLBACK(src, PROC_REF(process_sound_queue)), 1 SECONDS)

	return TRUE

//Signal handling.
/obj/item/clothing/suit/space/hev/equipped(mob/M, slot)
	..()
	if(slot == SLOT_HUD_OUTER_SUIT && iscarbon(M))
		for(var/voice in funny_signals)
			RegisterSignal(M, voice, funny_signals[voice])
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/blip.ogg', 2 SECONDS, purge_queue=TRUE)
			owner = M
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/01_hev_logon.ogg', 11 SECONDS)
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/03_atmospherics_on.ogg', 6 SECONDS)
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/08_communications_on.ogg', 5 SECONDS)
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/04_vitalsigns_on.ogg', 5 SECONDS)
			add_queue('modular_ss220/aesthetics_sounds/sound/hev/09_safe_day.ogg', 8 SECONDS)
	else
		for(var/voice in funny_signals)
			UnregisterSignal(M, voice)

/obj/item/clothing/suit/space/hev/dropped(mob/M)
	..()
	for(var/voice in funny_signals)
		UnregisterSignal(M, voice)

//Death
/obj/item/clothing/suit/space/hev/proc/handle_death(gibbed)
	SIGNAL_HANDLER
	add_queue('modular_ss220/aesthetics_sounds/sound/hev/death.ogg', 5 SECONDS, purge_queue=TRUE)

//Mute
/obj/item/clothing/suit/space/hev/proc/handle_speech(datum/source, mob/speech_args)
	SIGNAL_HANDLER
	if(!(flags & emagged))
		var/static/list/cancel_messages = list(
			"Вам трудно говорить, когда костюм туго сдавливает ваше горло...",
			"Ваши связки ощущаются сдавленными, что пресекает любую попытку выдавить хоть какой-то звук...",
			"Вы пытаетесь что-то сказать, но костюм сдавливает вам гортань..."
		)

		speech_args[SPEECH_MESSAGE] = "..."
		to_chat(source, span_warning(pick(cancel_messages)))

//Fire
/obj/item/clothing/suit/space/hev/proc/handle_ignite(mob/living)
	SIGNAL_HANDLER
	SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
	add_queue('modular_ss220/aesthetics_sounds/sound/hev/heat.ogg', 3 SECONDS)

//Shock
/obj/item/clothing/suit/space/hev/proc/handle_shock(mob/living)
	SIGNAL_HANDLER
	SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
	add_queue('modular_ss220/aesthetics_sounds/sound/hev/shok.ogg', 3 SECONDS)

// //Morphine
// /obj/item/clothing/suit/space/hev/proc/administer_morphine()
// 	if(!owner.reagents)
// 		return
// 	if(!COOLDOWN_FINISHED(src, next_morphine))
// 		return

// 	if((flags & emagged) && emag_doses_left < 0)
// 		owner.reagents.add_reagent(/datum/reagent/medicine/morphine, 1.5)
// 		owner.reagents.add_reagent(/datum/reagent/medicine/epinephrine 1.5)
// 		SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
// 		add_queue('modular_ss220/aesthetics_sounds/sound/hev/morphine_shot.ogg',2 SECONDS)
// 	else
// 		owner.reagents.add_reagent(/datum/reagent/medicine/stimulants, 5)
// 		SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
// 		add_queue('modular_ss220/aesthetics_sounds/sound/hev/wound_sterilized.ogg',2 SECONDS)
// 		emag_doses_left--
// 		if(emag_doses_left <= 0)
// 			to_chat(owner, span_warning("\The [name] seems to have run out of stimulants..."))

// 	COOLDOWN_START(src, next_morphine, MORPHINE_INJECTION_DELAY)
// 	return TRUE

// /obj/item/clothing/suit/space/hev/proc/handle_damage(mob/M, damage, damagetype, def_zone)

// 	var/health_percent = owner.health / owner.maxHealth

// 	if(!COOLDOWN_FINISHED(src, next_damage_notify))
// 		return

// 	if(damage < 5 || owner.maxHealth <= 0)
// 		return

// 	for(var/k in funny_signals)
// 		RegisterSignal(M, k, funny_signals[k])
// 		if(health_percent > 0.50 && !prob(damage * 4))
// 			switch(health_percent)
// 				if(0.76 to INFINITY)
// 					return
// 				if(0.51 to 0.75)
// 					SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_2.ogg')
// 					add_queue('modular_ss220/aesthetics_sounds/sound/hev/health_dropping2.ogg',2 SECONDS)
// 					COOLDOWN_START(src, next_damage_notify, 5 SECONDS)
// 				if(0.26 to 0.50)
// 					SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
// 					add_queue('modular_ss220/aesthetics_sounds/sound/hev/health_critical.ogg',3 SECONDS)
// 					COOLDOWN_START(src, next_damage_notify, 5 SECONDS)
// 				else
// 					SOUND_BEEP('modular_ss220/aesthetics_sounds/sound/hev/beep_3.ogg')
// 					add_queue('modular_ss220/aesthetics_sounds/sound/hev/near_death.ogg',3 SECONDS)
// 					COOLDOWN_START(src, next_damage_notify, 5 SECONDS)
// 					administer_morphine()

//Helmet
/obj/item/clothing/head/helmet/hev_helmet
	name = "hazardous environment suit helmet"
	desc = "The Mark IV HEV suit helmet."
	icon = 'modular_ss220/clothing/icons/object/helmet.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/helmet.dmi'
	item_state = "hev_helmet"
	icon_state = "hev0"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	armor = list(MELEE = 10, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 5, RAD = 100, FIRE = 15, ACID = 20)
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE | THICKMATERIAL
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	visor_flags = STOPSPRESSUREDMAGE
	flash_protect = FLASH_PROTECTION_WELDER
	dog_fashion = null
	var/on = FALSE
	var/brightness_on = 4
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	var/hud_types = DATA_HUD_MEDICAL_ADVANCED

/obj/item/clothing/head/helmet/hev_helmet/Initialize(mapload)
	. = ..()
	if(!islist(hud_types) && hud_types)
		hud_types = list(hud_types)

/obj/item/clothing/head/helmet/hev_helmet/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot != SLOT_HUD_HEAD)
		return
	for(var/new_hud in hud_types)
		var/datum/atom_hud/H = GLOB.huds[new_hud]
		H.add_hud_to(user)

/obj/item/clothing/head/helmet/hev_helmet/dropped(mob/living/carbon/human/user)
	..()
	for(var/new_hud in hud_types)
		var/datum/atom_hud/H = GLOB.huds[new_hud]
		H.remove_hud_from(user)

/obj/item/clothing/head/helmet/hev_helmet/ui_action_click(mob/user, toggle_helmet_light)
	light_toggle(user)

/obj/item/clothing/head/helmet/hev_helmet/proc/light_toggle(mob/user)
	on = !on
	icon_state = "hev[on]"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

	if(on)
		set_light(brightness_on)
	else
		set_light(0)

/obj/item/clothing/head/helmet/hev_helmet/extinguish_light(force = FALSE)
	if(on)
		light_toggle()
		visible_message("<span class='danger'>[src]'s light fades and turns off.</span>")

#undef MORPHINE_INJECTION_DELAY
#undef SOUND_BEEP
