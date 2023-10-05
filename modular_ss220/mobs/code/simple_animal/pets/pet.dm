
/mob/living/simple_animal/pet
	attacktext = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/pet/sloth
	tts_seed = "Peon"
	holder_type = /obj/item/holder/sloth

/mob/living/simple_animal/pet/sloth/paperwork
	name = "Пэйперворк" // Бумажник
	desc = "Любимец Карго - ленивец. Примерно так же полезен, как и остальные каргонцы."
	icon = 'modular_ss220/mobs/icons/mob/pets.dmi'
	icon_state = "cool_sloth"
	icon_living = "cool_sloth"
	icon_dead = "cool_sloth_dead"
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
