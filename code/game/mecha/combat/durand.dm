/obj/mecha/combat/durand
	desc = "It's time to light some fires and kick some tires."
	name = "Durand Mk. II"
	icon_state = "durand"
	initial_icon = "durand"
	step_in = 4
	dir_in = 1 //Facing North.
	max_integrity = 400
	deflect_chance = 20
	armor = list(melee = 40, bullet = 35, laser = 15, energy = 10, bomb = 20, rad = 50, fire = 100, acid = 100)
	max_temperature = 30000
	infra_luminosity = 8
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand

/obj/mecha/combat/durand/GrantActions(mob/living/user, human_occupant = 0)
	..()
	defense_action.Grant(user, src)

/obj/mecha/combat/durand/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	defense_action.Remove(user)

/obj/mecha/combat/durand/loaded/Initialize(mapload)
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	ME.attach(src)

/obj/mecha/combat/durand/old
	desc = "A retired, third-generation combat exosuit utilized by the Nanotrasen corporation. Originally developed to combat hostile alien lifeforms."
	name = "Durand"
	icon_state = "old_durand"
	initial_icon = "old_durand"
	step_in = 4
	dir_in = 1 //Facing North.
	max_integrity = 400
	deflect_chance = 20
	armor = list(melee = 50, bullet = 35, laser = 15, energy = 15, bomb = 20, rad = 50, fire = 100, acid = 100)
	max_temperature = 30000
	infra_luminosity = 8
	force = 40
	wreckage = /obj/structure/mecha_wreckage/durand/old

/obj/mecha/combat/durand/executioner
	name = "mk. V \"The Executioner\""
	desc = "Dreadnought of the Executioner Order, heavy fire support configuration, made for purge evil and heretics. Extremely durable in close combat."
	icon_state = "executioner"
	initial_icon = "executioner"
	max_temperature = 65000
	step_in = 3
	max_integrity = 350
	deflect_chance = 30
	lights_power = 15 //rise and shine, HUMANKIND!
	force = 40
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 70, "bullet" = 15, "laser" = 5, "energy" = 30, "bomb" = 60, "bio" = 0, "rad" = 100, "fire" = 100, "acid" = 100)
	max_equip = 3
	wreckage = /obj/structure/mecha_wreckage/executioner

/obj/mecha/combat/durand/executioner/GrantActions(mob/living/user, human_occupant = 0)
	..()
	flash_action.Grant(user, src)

/obj/mecha/combat/durand/executioner/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	flash_action.Remove(user)
