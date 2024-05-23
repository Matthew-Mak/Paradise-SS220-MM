/datum/species
	var/thirst_drain = THIRST_FACTOR

/datum/species/movement_delay(mob/living/carbon/human/H)
	. = ..()
	if(!has_gravity(H) || HAS_TRAIT(H, TRAIT_IGNORESLOWDOWN))
		return
	if(H.hydration <= HYDRATION_LEVEL_INEFFICIENT && !H.flying)
		. += 1.5

/datum/species/machine/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/abductor/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/golem/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/plasmaman/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/skeleton/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/grey/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/vox/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/antagonist/vampire/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/vampire = mob_override || owner.current
	ADD_TRAIT(vampire, TRAIT_NO_THIRST, "vampire")

/datum/antagonist/vampire/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/vampire = mob_override || owner.current
	REMOVE_TRAIT(vampire, TRAIT_NO_THIRST, "vampire")
