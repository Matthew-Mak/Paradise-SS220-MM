/datum/species/serpentid
	name = "Serpentid"
	name_plural = "Serpentids"
	icobase = 'modular_ss220/species/serpentids/icons/mob/r_serpentid.dmi'
	eyes_icon = 'modular_ss220/species/serpentids/icons/mob/r_serpentid_eyes.dmi'
	blurb = "TODO" //NOT MERGE - Я еще не доработал
	language = "Nabberian"
	coldmod = 0.9
	heatmod = 1.2
	tox_mod = 1.5
	eyes = "serpentid_eyes_s"
	butt_sprite_icon = 'modular_ss220/species/serpentids/icons/mob/r_serpentid_butt.dmi'
	butt_sprite = "serpentid"
	nojumpsuit = TRUE

	species_traits = list(LIPS, NO_HAIR, TTS_TRAIT_ROBOTIZE)
	inherent_traits = list(TRAIT_NOPAIN)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_REPTILE

	dietflags = DIET_OMNI
	taste_sensitivity = TASTE_SENSITIVITY_SHARP
	allowed_consumed_mobs = list(/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/butterfly,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/hostile/poison/bees)

	bodyflags = HAS_SKIN_COLOR | BALD | SHAVED
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	flesh_color = "#34AF10"
	base_color = "#066000"

	exotic_blood = "facid"
	blood_color = "#b0fc22"

	reagent_tag = PROCESS_ORG

	punchdamagehigh = 10

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/serpentid,
		"lungs" =    /obj/item/organ/internal/lungs/serpentid,
		"liver" =    /obj/item/organ/internal/liver/serpentid,
		"kidneys" =  /obj/item/organ/internal/kidneys/serpentid,
		"brain" =    /obj/item/organ/internal/brain/serpentid,
		"eyes" =     /obj/item/organ/internal/eyes/serpentid,
		"ears" =     /obj/item/organ/internal/ears/serpentid,
		//"l_hand" =  /obj/item/organ/internal/cyberimp/arm/toolset/mantisblade/l,
		//"r_hand" =  /obj/item/organ/internal/cyberimp/arm/toolset/mantisblade,
		"chest" =  /obj/item/organ/internal/cyberimp/chest/serpentid_blades,
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/carapace, "descriptor" = "chest"),
		"groin" =  list("path" = /obj/item/organ/external/groin/carapace, "descriptor" = "groin"),
		"head" =   list("path" = /obj/item/organ/external/head/carapace, "descriptor" = "head"),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/carapace, "descriptor" = "left arm"),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/carapace, "descriptor" = "right arm"),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/carapace, "descriptor" = "left leg"),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/carapace, "descriptor" = "right leg"),
		"l_hand" = list("path" = /obj/item/organ/external/hand/carapace, "descriptor" = "left hand"),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/carapace, "descriptor" = "right hand"),
		"l_foot" = list("path" = /obj/item/organ/external/foot/carapace, "descriptor" = "left foot"),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/carapace, "descriptor" = "right foot")
		)

	autohiss_exempt = list("Nabberian")

	scream_verb = "утробно ревёт"
	speech_sounds = list(
		'modular_ss220/species/serpentids/sounds/serpentid_talk_1.ogg',
		'modular_ss220/species/serpentids/sounds/serpentid_talk_2.ogg')
	speech_chance = 20
	male_scream_sound = 'modular_ss220/species/serpentids/sounds/serpentid_shreak.ogg'
	female_scream_sound = 'modular_ss220/species/serpentids/sounds/serpentid_shreak.ogg'
	male_cry_sound = list(
		'modular_ss220/emotes/audio/kidan/cry_kidan_1.ogg')
	female_cry_sound = list(
		'modular_ss220/emotes/audio/kidan/cry_kidan_1.ogg')
	male_giggle_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_laugh.ogg')
	female_giggle_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_laugh.ogg')
	male_laugh_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_laugh.ogg')
	female_laugh_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_laugh.ogg')
	male_sigh_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_sigh.ogg')
	female_sigh_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_sigh.ogg')
	male_moan_sound = list('modular_ss220/species/serpentids/sounds/serpentid_moan.ogg')
	female_moan_sound = list('modular_ss220/species/serpentids/sounds/serpentid_moan.ogg')
	male_cough_sounds = list('modular_ss220/species/serpentids/sounds/serpentid_cough.ogg')
	female_cough_sounds = list('modular_ss220/species/serpentids/sounds/serpentid_cough.ogg')
	male_sneeze_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_sneeze.ogg')
	female_sneeze_sound = list(
		'modular_ss220/species/serpentids/sounds/serpentid_sneeze.ogg')
	male_dying_gasp_sounds = list(
		'modular_ss220/species/serpentids/sounds/serpentid_dying.ogg')
	female_dying_gasp_sounds = list(
		'modular_ss220/species/serpentids/sounds/serpentid_dying.ogg')
	death_sounds = 'modular_ss220/species/serpentids/sounds/serpentid_death.ogg'
	suicide_messages = list(
		"пытается откусить себе усики!",
		"вонзает когти в свои глазницы!",
		"сворачивает себе шею!",
		"разбивает себе панцирь!",
		"протыкает себя клинками!",
		"задерживает дыхание!")

	can_buckle = TRUE
	buckle_lying = FALSE
	var/can_stealth = TRUE
	var/gene_lastcall = 0
	var/list/shift_data = list(
	"head" = list(
		"center" = list("x" = 0, "y" = 9),
		"side" = list("x" = 3, "y" = 0),
		"front" = list("x" = 0, "y" = 0)
	),
	"inhand" = list(
		"center" = list("x" = 0, "y" = 1),
		"side" = list("x" = 0, "y" = 0),
		"front" = list("x" = 0, "y" = 0)
	),
	"belt" = list(
		"center" = list("x" = 0, "y" = 7),
		"side" = list("x" = 5, "y" = 0),
		"front" = list("x" = 0, "y" = 0)
	),
	"back" = list(
		"center" = list("x" = 0, "y" = 7),
		"side" = list("x" = 0, "y" = 0),
		"front" = list("x" = 0, "y" = 0)
	)
	)


/datum/species/serpentid/handle_reagents(mob/living/carbon/human/H, datum/reagent/R)
	return (R.id != SERPENTID_CHEM_REAGENT_ID)

//Перенести на карапас/грудь
/datum/species/serpentid/handle_life(mob/living/carbon/human/H)
	var/armor_count = 0
	var/gene_degradation = 0
	for(var/obj/item/organ/external/limb in H.bodyparts)
		var/allow_part = has_limbs[limb.limb_name]["path"]
		if(limb.type != allow_part)
			gene_degradation += SERPENTID_GENE_DEGRADATION_DAMAGE
		var/limb_armor = limb.brute_dam + limb.burn_dam
		armor_count += limb_armor

	if(gene_lastcall >= SERPENTID_GENE_DEGRADATION_CD && gene_degradation)
		H.adjustCloneLoss(gene_degradation)
		gene_lastcall = 0
	else
		gene_lastcall += 1

	. = ..()

/datum/species/serpentid/on_species_gain(mob/living/carbon/human/H)
	..()
	H.can_buckle = can_buckle
	H.buckle_lying = buckle_lying
	H.update_transform()
	H.AddComponent(/datum/component/footstep, FOOTSTEP_MOB_SLIME, 1, -6)
	H.AddComponent(/datum/component/mob_overlay_shift, shift_data)
	H.AddComponent(/datum/component/gadom_living)
	H.AddComponent(/datum/component/gadom_cargo)
	H.verbs |= /mob/living/carbon/human/proc/emote_gasroar
	H.verbs |= /mob/living/carbon/human/proc/emote_gashiss
	H.verbs |= /mob/living/carbon/human/proc/emote_gaswiggles
	H.verbs -= /mob/living/carbon/human/verb/emote_cough
	H.verbs -= /mob/living/carbon/human/verb/emote_sneeze
	H.verbs -= /mob/living/carbon/human/verb/emote_sniff
	H.verbs -= /mob/living/carbon/human/verb/emote_snore
	H.verbs -= /mob/living/carbon/human/verb/emote_blink
	H.verbs -= /mob/living/carbon/human/verb/emote_blink_r
	H.chat_message_y_offset = 11

/datum/species/serpentid/on_species_loss(mob/living/carbon/human/H)
	..()
	H.verbs -= /mob/living/carbon/human/proc/emote_gasroar
	H.verbs -= /mob/living/carbon/human/proc/emote_gashiss
	H.verbs -= /mob/living/carbon/human/proc/emote_gaswiggles
	H.verbs |= /mob/living/carbon/human/verb/emote_cough
	H.verbs |= /mob/living/carbon/human/verb/emote_sneeze
	H.verbs |= /mob/living/carbon/human/verb/emote_sniff
	H.verbs |= /mob/living/carbon/human/verb/emote_snore
	H.verbs |= /mob/living/carbon/human/verb/emote_blink
	H.verbs |= /mob/living/carbon/human/verb/emote_blink_r

//Работа с инвентарем
/datum/species/serpentid/can_equip(obj/item/I, slot, disable_warning = FALSE, mob/living/carbon/human/H)
	switch(slot)
		if(SLOT_HUD_SHOES)
			return FALSE
		if(SLOT_HUD_GLOVES)
			return FALSE
		if(SLOT_HUD_JUMPSUIT)
			return FALSE
		if(SLOT_HUD_OUTER_SUIT)
			return FALSE
	. = .. ()

//Ограничение на роли антагов (генокрад онли)
/datum/antag_scenario/vampire/New()
	restricted_species += list("Serpentid")
	. = .. ()

/datum/antag_scenario/traitor/New()
	restricted_species += list("Serpentid")
	. = .. ()

/datum/antag_scenario/team/blood_brothers/New()
	restricted_species += list("Serpentid")
	. = .. ()

//Расширение для действий органов серпентидов
/datum/action/item_action/organ_action/toggle/gas

/datum/action/item_action/organ_action/toggle/gas/New(Target)
	..()
	name = "GAS organ selection"
