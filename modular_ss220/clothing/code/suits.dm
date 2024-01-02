/obj/item/clothing/suit/v_jacket
	name = "куртка V"
	desc = "Куртка так называемого V."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "v_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "v_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/takemura_jacket
	name = "куртка Такэмуры"
	desc = "Куртка так называемого Такэмуры."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "takemura_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "takemura_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_jacket
	name = "куртка Катарины"
	desc = "Куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "katarina_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_cyberjacket
	name = "киберкуртка Катарины"
	desc = "Кибер-куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_cyberjacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "katarina_cyberjacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/hooded/shark_costume
	name = "костюм акулы"
	desc = "Костюм из 'синтетической' кожи акулы, пахнет."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "shark_casual"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "shark_casual"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list(/obj/item/tank/internals/emergency_oxygen)
	hoodtype = /obj/item/clothing/head/hooded/shark_hood

/obj/item/clothing/head/hooded/shark_hood
	name = "акулий капюшон"
	desc = "Капюшон, прикрепленный к костюму акулы."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "shark_casual"
	icon_override = 'modular_ss220/clothing/icons/mob/hats.dmi'
	item_state = "shark_casual"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = BLOCKHAIR
	flags_inv = HIDEEARS

/obj/item/clothing/suit/hooded/shark_costume/light
	name = "светло-голубой костюм акулы"
	icon_state = "shark_casual_light"
	item_state = "shark_casual_light"
	hoodtype = /obj/item/clothing/head/hooded/shark_hood/light

/obj/item/clothing/head/hooded/shark_hood/light
	name = "светло-голубой акулий капюшон"
	icon_state = "shark_casual_light"
	item_state = "shark_casual_light"

/obj/item/clothing/suit/space/deathsquad/officer/syndie
	name = "куртка офицера синдиката"
	desc = "Длинная куртка из высокопрочного волокна."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "jacket_syndie"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "jacket_syndie"

/obj/item/clothing/suit/space/deathsquad/officer/field
	name = "полевая форма офицера флота Нанотрейзен"
	desc = "Парадный плащ, разработанный в качестве массового варианта формы Верховного Главнокомандующего. У этой униформы нет тех же защитных свойств, что и у оригинала, но она все ещё является довольно удобным и стильным предметом гардероба."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ntsc_uniform"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "ntsc_uniform"

/obj/item/clothing/suit/hooded/vi_arcane
	name = "куртка Вай"
	desc = "Слегка потрёпанный жакет боевой девчушки Вай."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "vi_arcane"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "vi_arcane"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	desc = "Капюшон, прикреплённый к жакету Вай."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "vi_arcane"
	icon_override = 'modular_ss220/clothing/icons/mob/hats.dmi'
	item_state = "vi_arcane"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = BLOCKHAIR
	flags_inv = HIDEEARS

/obj/item/clothing/suit/hooded/vi_arcane
	name = "жакет Вай"
	icon_state = "vi_arcane"
	item_state = "vi_arcane"
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	icon_state = "vi_arcane"
	item_state = "vi_arcane"

/obj/item/clothing/suit/soundhand_black_jacket
	name = "черная куртка группы Саундхэнд."
	desc = "Легендарная черная куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_black_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/soundhand_black_jacket/soundhand_black_jacket_tag
	name = "черная куртка с тэгом группы Саундхэнд."
	desc = "Легендарная черная куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_black_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/soundhand_olive_jacket
	name = "оливковая куртка группы Саундхэнд."
	desc = "Легендарная оливковая куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/soundhand_olive_jacket/soundhand_olive_jacket_tag
	name = "оливковая куртка с тэгом группы Саундхэнд."
	desc = "Легендарная оливковая куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/soundhand_brown_jacket
	name = "коричневая куртка группы Саундхэнд."
	desc = "Легендарная коричневая куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/soundhand_brown_jacket/soundhand_brown_jacket_tag
	name = "коричневая куртка с тэгом группы Саундхэнд."
	desc = "Легендарная коричневая куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
