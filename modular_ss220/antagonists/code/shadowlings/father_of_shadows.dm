/mob/living/simple_animal/demon/shadow_father	// Can't inherit from demon/shadow because of 'initialize' proc
	name = "отец теней"
	desc = "Крупное демоническое существо, сотканное из теней. Из его красных глаз сочится потусторонняя энергия."
	icon = 'modular_ss220/antagonists/icons/shadowlings/father_of_shadows.dmi'
	icon_state = "father_of_shadows"
	icon_living = "father_of_shadows"
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	attack_sound = 'sound/misc/demon_attack1.ogg'
	death_sound = 'sound/misc/demon_dies.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	faction = list("demon")
	move_resist = MOVE_FORCE_STRONG
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	see_in_dark = 10
	death_sound = 'sound/shadowdemon/shadowdeath.ogg'
	speed = 1
	maxHealth = 350
	health = 350

	var/thrown_alert
	var/list/obj/structure/shadow_trap/placed_traps = list()
	var/is_converting = FALSE

/mob/living/simple_animal/demon/shadow_father/Login()
	. = ..()
	var/list/L = list(
		"<span class='deadsay'><font size=3><b>Вы Отец Тьмы!</b></font></span>",
		"<b>Вы коварный и подлый антагонист, который должен подготовить эту станцию для прихода своих детей.</b>",
		"<b>Свет - ваш худший враг, но вы не получаете от него урона, находясь в астральной форме.</b>",
		"<b>Подготавливайте ловушки и засады в технических туннелях, после чего заманивайте в них жертв.</b>",
		"<b>Погружайте в тень тела погибших членов экипажа, чтобы, в будущем, превратить их в своих детей.</b>",
		"<b>Накопив достаточно погружённых, издайте свой последний вопль и призовите на станцию тенелингов.</b>",
		"<b><i></i></b>",
		"<br><span class='motd'>Для подробной информации, посетите вики: [wiki_link("Shadowlings")]</span>"
	)
	to_chat(src, chat_box_red(L.Join("<br>")))
	if(!mind)
		return
	var/datum/atom_hud/hud = GLOB.huds[ANTAG_HUD_SHADOW]
	hud.add_hud_to(src)



/mob/living/simple_animal/demon/shadow_father/Initialize(mapload)
	. = ..()
	add_overlay(emissive_appearance(icon, "father_of_shadows_eye_glow_overlay"))
	grant_spells()

/mob/living/simple_animal/demon/shadow_father/Life(seconds, times_fired)
	. = ..()
	var/lum_count = check_darkness()
	var/damage_mod = istype(loc, /obj/effect/dummy/slaughter) ? 0.5 : 1
	if(lum_count > 0.2)
		adjustBruteLoss(40 * damage_mod) // 10 seconds in light
		SEND_SOUND(src, sound('sound/weapons/sear.ogg'))
		to_chat(src, "<span class='biggerdanger'>The light scalds you!</span>")
	else
		adjustBruteLoss(-20)

/mob/living/simple_animal/demon/shadow_father/proc/check_darkness()
	var/turf/T = get_turf(src)
	var/lum_count = T.get_lumcount()
	if(lum_count > 0.2)
		if(!thrown_alert)
			thrown_alert = TRUE
			throw_alert("light", /atom/movable/screen/alert/lightexposure)
		alpha = 255
		speed = initial(speed)
	else
		if(thrown_alert)
			thrown_alert = FALSE
			clear_alert("light")
		alpha = 125
		speed = 0.5
	return lum_count

/mob/living/simple_animal/demon/shadow_father/proc/grant_spells()
	whisper_action.button_overlay_icon = 'modular_ss220/antagonists/icons/shadowlings/shadowlings_actions.dmi'
	whisper_action.button_overlay_icon_state = "father_whisper"
	whisper_action.button_background_icon_state = "shadow_demon_bg"

	var/list/datum/spell/spells_to_grant = list(
		new /datum/spell/bloodcrawl/shadow_crawl/father,
		new /datum/spell/shadowling/veil,
		new /datum/spell/shadowling/screech,
		new /datum/spell/shadowling/glare,
		new /datum/spell/shadowling/self/place_trap/stun,
		new /datum/spell/shadowling/self/place_trap/poison,
		new /datum/spell/shadowling/self/place_trap/blindness,
	)
	for(var/datum/spell/spell in spells_to_grant)
		AddSpell(spell)

/mob/living/simple_animal/demon/shadow_father/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isliving(AM)) // when a living creature is thrown at it, dont knock it back
		return
	..()

/mob/living/simple_animal/demon/shadow_father/UnarmedAttack(atom/A)
	// Pick a random attack sound for each attack
	attack_sound = pick('sound/shadowdemon/shadowattack2.ogg', 'sound/shadowdemon/shadowattack3.ogg', 'sound/shadowdemon/shadowattack4.ogg')
	if(!ishuman(A))
		if(isitem(A))
			A.extinguish_light()
		return ..()
	var/mob/living/carbon/human/target = A
	if(target.stat != DEAD)
		return ..()

	if(isLivingSSD(target) && client.send_ssd_warning(target)) //Similar to revenants, only wrap SSD targets if you've accepted the SSD warning
		return

	if(is_converting)
		to_chat(src, "<span class='notice'>We are already wrapping something.</span>")
		return

	visible_message("<span class='danger'>[src] begins wrapping [target] in shadowy threads.</span>")
	is_converting = TRUE
	if(!do_after(src, 4 SECONDS, FALSE, target = target))
		is_converting = FALSE
		return

	target.visible_message("<span class='warning'><b>[src] envelops [target] into an ethereal cocoon, and darkness begins to creep from it.</b></span>")
	var/obj/structure/shadowcocoon/C = new(get_turf(target))
	target.extinguish_light() // may as well be safe
	target.forceMove(C)
	is_converting = FALSE
