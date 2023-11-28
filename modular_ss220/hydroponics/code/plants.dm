// HydroSeed
/obj/machinery/economy/vending/hydroseeds/Initialize(mapload)
	products += list(
		/obj/item/seeds/cucumber = 3,
		/obj/item/seeds/soya/olive = 3,)
	. = ..()

// Buckwheat
/obj/item/seeds/wheat/oat
	mutatelist = list(/obj/item/seeds/wheat/buckwheat)

/obj/item/seeds/wheat/buckwheat
	name = "семена гречки"
	desc = "Из этого может получиться гречка, а может и нет."
	icon = 'modular_ss220/hydroponics/icons/seeds.dmi'
	icon_state = "seed-buckwheat"
	growing_icon = 'modular_ss220/hydroponics/icons/growing.dmi'
	species = "buckwheat"
	icon_dead = "buckwheat-dead"
	plantname = "Cтебли Гречки"
	product = /obj/item/reagent_containers/food/snacks/grown/buckwheat
	mutatelist = list()

/obj/item/reagent_containers/food/snacks/grown/buckwheat
	seed = /obj/item/seeds/wheat/buckwheat
	name = "гречка"
	desc = "Finally, гречка."
	gender = PLURAL
	icon = 'modular_ss220/hydroponics/icons/plants.dmi'
	icon_state = "buckwheat"
	filling_color = "#8E633C"
	bitesize_mod = 2
	tastes = list("гречка" = 1)
	can_distill = FALSE

// Cucumber
/obj/item/seeds/cucumber
	name = "семена огурцов"
	desc = "Из этих семян вырастут огурцы."
	icon = 'modular_ss220/hydroponics/icons/seeds.dmi'
	icon_state = "seed-cucumber"
	species = "cucumber"
	plantname = "Огуречный Куст"
	product = /obj/item/reagent_containers/food/snacks/grown/cucumber
	lifespan = 40
	endurance = 70
	potency = 30
	yield = 5
	maturation = 8
	weed_rate = 4
	growthstages = 2
	growing_icon = 'modular_ss220/hydroponics/icons/growing.dmi'
	icon_grow = "cucumber-grow"
	icon_dead = "cucumber-dead"
	genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list("water" = 0.15, "kelotane" = 0.04, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/cucumber
	seed = /obj/item/seeds/cucumber
	name = "огурец"
	desc = "Сила земли!"
	icon = 'modular_ss220/hydroponics/icons/plants.dmi'
	icon_state = "cucumber"
	splat_type = /obj/effect/decal/cleanable/plant_smudge
	slice_path = /obj/item/reagent_containers/food/snacks/cucumberslice
	slices_num = 5
	filling_color = "#47FF91"
	tastes = list("огурец" = 1)
	bitesize_mod = 2
	distill_reagent = "enzyme"

// Olives
/obj/item/seeds/soya/olive
	name = "семена оливок"
	desc = "Из этих семян вырастут оливки."
	icon = 'modular_ss220/hydroponics/icons/seeds.dmi'
	icon_state = "seed-olives"
	species = "olives"
	plantname = "Оливковое Деревце"
	product = /obj/item/reagent_containers/food/snacks/grown/olive
	growing_icon = 'modular_ss220/hydroponics/icons/growing.dmi'
	icon_grow = "olives-grow"
	icon_dead = "olives-dead"
	icon_harvest = "olives-harvest"
	mutatelist = list(/obj/item/seeds/soya/olive/charcoal)

/obj/item/reagent_containers/food/snacks/grown/olive
	seed = /obj/item/seeds/soya/olive
	name = "оливки"
	desc = "Любишь их или ненавидишь..."
	icon = 'modular_ss220/hydroponics/icons/plants.dmi'
	icon_state = "olives"
	filling_color = "#161220"
	tastes = list("оливок" = 1)

// Olives Charcoal
/obj/item/seeds/soya/olive/charcoal
	name = "семена угливок"
	desc = "Из этих семян вырастут угливки."
	icon = 'modular_ss220/hydroponics/icons/seeds.dmi'
	icon_state = "seed-charcolives"
	species = "charcolives"
	plantname = "Угливковое Деревце"
	product = /obj/item/reagent_containers/food/snacks/grown/olive/charcoal
	growing_icon = 'modular_ss220/hydroponics/icons/growing.dmi'
	icon_grow = "charcolives-grow"
	icon_dead = "charcolives-dead"
	icon_harvest = "charcolives-harvest"
	reagents_add = list("charcoal" = 0.4, "plantmatter" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/olive/charcoal
	seed = /obj/item/seeds/soya/olive/charcoal
	name = "угливки"
	desc = "Это... маслины?"
	icon = 'modular_ss220/hydroponics/icons/plants.dmi'
	icon_state = "charcolives"
	filling_color = "#000000"
	tastes = list("уголя" = 1)
