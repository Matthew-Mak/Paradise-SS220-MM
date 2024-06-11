/obj/item/reagent_containers/food/condiment/milk/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/flour/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/soymilk/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/rice/empty
	list_reagents = null

/obj/item/reagent_containers/glass/bottle/nutrient/fuel
	name = "\improper канистра с топливом"
	desc = "Содержит в себе топливо. Пить не рекомендуется."
	possible_transfer_amounts = list(1,2,5,10,20,40,80,100)
	list_reagents = list("fuel" = 100)

/obj/structure/decorative_structures/corpse
	name = "\improper кровавое тело"
	icon = 'modular_ss220/dunes_map/icons/dead.dmi'
	icon_state = "deadbody"
	density = 0
	max_integrity = 5
	var/bloodtiles = 8  // number of tiles with blood while pulling

/obj/structure/decorative_structures/corpse/Initialize()
	START_PROCESSING(SSobj, src)
	..()

/obj/structure/decorative_structures/corpse/Destroy()
	playsound(src, 'sound/goonstation/effects/gib.ogg', 30, 0)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/blood/gibs(T)
	new /obj/effect/decal/cleanable/blood(T)
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/decorative_structures/corpse/attack_hand(mob/living/user)
	take_damage(pick(2,3), BRUTE, "melee")
	playsound(src, (pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')), 20, 0)

/obj/structure/decorative_structures/corpse/play_attack_sound()
	return

/obj/structure/decorative_structures/corpse/do_climb()
	return

/obj/structure/decorative_structures/corpse/Move()
	. = ..()
	bloodtiles -= 1
	if(bloodtiles >= 0 && prob(40))
		new /obj/effect/decal/cleanable/blood(get_turf(src))

/obj/structure/decorative_structures/corpse/process()
	for(var/mob/living/carbon/human/H in range(4, src))
		if(prob(15))
			var/obj/item/clothing/mask/M = H.wear_mask
			if(M && (M.flags_cover & MASKCOVERSMOUTH))
				continue
			if(TRAIT_NOBREATH in H.dna.species.species_traits)
				continue
			to_chat(H, "<span class='warning'>Как же воняет...</span>")
			H.fakevomit()

/obj/structure/decorative_structures/corpse/dead1
	name = "\improper гниющий труп"
	icon_state = "deadbody3"
	desc = "Полуразложившийся труп. Ну и вонь."

/obj/structure/decorative_structures/corpse/dead2
	name = "\improper скелетированный труп"
	icon_state = "deadbody2"
	desc = "Его кости уже давно белеют на солнце..."
	bloodtiles = 0

/obj/structure/decorative_structures/corpse/dead2/Destroy()
	playsound(src, 'sound/effects/bone_break_4.ogg', 30, 0)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/remains/human(T)
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/decorative_structures/corpse/dead_on_cross
	name = "\improper шматок плоти"
	icon_state = "deadbody1"
	density = 1
	anchored = 1

/obj/structure/decorative_structures/corpse/dead_on_cross/dead2
	name = "\improper скелет на столбе"
	desc = "Он висит здесь уже очень давно. Бедолага."
	icon_state = "deadbody4"

/obj/structure/sink/kolodec
	name = "\improper колодец"
	desc = "Главное не упасть..."
	icon = 'modular_ss220/dunes_map/icons/kolodec.dmi'
	icon_state = "kolodec"
	density = TRUE
	layer = ABOVE_MOB_LAYER
	var/drop_x = 1
	var/drop_y = 1
	var/drop_z = -1

/obj/structure/sink/kolodec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/largetransparency)

/obj/structure/sink/kolodec/MouseDrop_T(atom/movable/AM)
	. = 0
	if(!do_after(AM, 1 SECONDS, target = src))
		return
	AM.forceMove(src.loc)
	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		. = 1
		INVOKE_ASYNC(src, PROC_REF(drop), thing)

/obj/structure/sink/kolodec/proc/drop(atom/movable/AM)
	if(iscarbon(AM))
		playsound(AM.loc, 'modular_ss220/aesthetics_sounds/sound/wilhelm_scream.ogg', 50)

	if(!AM || QDELETED(AM))
		return
	AM.visible_message("<span class='boldwarning'>[AM] falls into [src]!</span>", "<span class='userdanger'>You stumble and stare into an abyss before you. It stares back, and you fall \
	into the enveloping dark.</span>")
	if(isliving(AM))
		var/mob/living/L = AM
		L.notransform = TRUE
		L.Weaken(20 SECONDS)
	animate(AM, transform = matrix() - matrix(), alpha = 0, color = rgb(0, 0, 0), time = 10)
	for(var/i in 1 to 5)
		//Make sure the item is still there after our sleep
		if(!AM || QDELETED(AM))
			return
		AM.pixel_y--
		sleep(2)

	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return

	if(isliving(AM))
		var/mob/living/fallen_mob = AM
		fallen_mob.notransform = FALSE
		if(fallen_mob.stat != DEAD)
			fallen_mob.adjustBruteLoss(500) //crunch from long fall, want it to be like legion in damage
		return
	for(var/mob/M in AM.contents)
		M.forceMove(src)
	qdel(AM)

/obj/machinery/power/port_gen/pacman/wood
	sheet_path = /obj/item/stack/sheet/wood
	sheet_name = "Wooden Planks"
	time_per_sheet = 25 // same power output, but a 50 sheet stack will last 2 hours at max safe power
	max_sheets = 50
	power_gen = 5000
	max_power_output = 1
	max_safe_output = 1

//car wreck

/obj/structure/decorative_structures/car_wreck
	name = "\improper остов машины"
	desc = "Заржавевший и выпотрошенный наземный транспорт, который активно использовался несколько веков назад."
	icon = 'modular_ss220/dunes_map/icons/wrecks_1.dmi'
	icon_state = "helper"
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 50
	var/list/obj/structure/fillers = list()

/obj/structure/filler_car
	name = "car part"
	density = TRUE
	anchored = TRUE
	invisibility = 101
	var/obj/structure/parent

/obj/structure/filler_car/Destroy()
	parent = null
	return ..()

/obj/structure/filler_car/ex_act()
	return

/obj/structure/decorative_structures/car_wreck/Initialize(mapload)
	. = ..()
	var/list/car_types = list("coupe", "muscle", "sport", "van")
	icon_state = "[pick(car_types)]-[rand(1,5)]"
	AddComponent(/datum/component/largetransparency)

	var/list/occupied = list()
	for(var/direct in list(EAST))
		occupied += get_step(src,direct)
	occupied += locate(x+2,y,z)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F

/obj/structure/decorative_structures/car_wreck/Destroy()
	QDEL_LIST_CONTENTS(fillers)
	return ..()

//statues and stuff

/obj/structure/fluff/desert_construction
	name = "окаменелые останки"
	desc = "Останки какой-то огромной допотопной твари."
	icon = 'modular_ss220/dunes_map/icons/statuelarge.dmi'
	icon_state = "rib"
	density = TRUE
	deconstructible = FALSE
	max_integrity = 500
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/desert_construction/depred_boss
	name = "маяк депредаторов"
	desc = "Ваше приключение оканчивается здесь. Его исход зависит только от Вас."
	icon = 'modular_ss220/dunes_map/icons/marker_giant.dmi'
	icon_state = "marker_giant_active_anim"
	pixel_x = -32
	max_integrity = 2000
	light_power = 2
	light_range = 20
	light_color = COLOR_MAROON

/obj/structure/fluff/desert_construction/holomap
	name = "Голокарта Хирки"
	desc = "Актуальная карта планеты с подробностями региона Убежища."
	icon = 'modular_ss220/dunes_map/icons/statuelarge.dmi'
	icon_state = "holo_map"

/obj/structure/fluff/desert_construction/skull1
	name = "окаменелый череп"
	desc = "Череп какой-то огромной допотопной твари."
	icon_state = "skull"

/obj/structure/fluff/desert_construction/skull2
	name = "окаменелые череп"
	desc = "Череп какой-то огромной допотопной твари."
	icon_state = "skull-half"

/obj/structure/fluff/desert_construction/ribs
	name = "останки"
	desc = "Белеющие на солнце кости местной фауны."
	icon_state = "rib_white"

/obj/structure/fluff/desert_construction/stone1
	name = "скала"
	desc = "Массивный каменный обломок."
	icon_state = "stone1"

/obj/structure/fluff/desert_construction/stone2
	name = "скала"
	desc = "Массивный каменный обломок."
	icon_state = "stone2"

/obj/structure/fluff/desert_construction/obelisk1
	name = "обелиск"
	desc = "Древний обелиск из песчанника, обтесанный и расписаный неизвестными иероглифами."
	icon_state = "obelisk"

/obj/structure/fluff/desert_construction/altar
	name = "кубический алтарь"
	desc = "Геометрически правильное сооружение из черного камня, испускающее тусклый красный свет."
	icon_state = "cube"

/obj/structure/fluff/desert_construction/head1
	name = "массивный каменный бюст"
	desc = "Голова отвратительной твари, выбитая в камне."
	icon_state = "head1"

/obj/structure/fluff/desert_construction/head1/black
	icon_state = "head1_black"

/obj/structure/fluff/desert_construction/crushedhead
	name = "разрушенный бюст"
	desc = "Останки некогда массивной статуи, поддашвейся неумолимой стихии."
	icon_state = "crushedhead"

/obj/structure/fluff/desert_construction/column1
	name = "колонна"
	desc = "Колонна из песчаника."
	icon_state = "column4"

/obj/structure/fluff/desert_construction/column2
	name = "обломок колонны"
	desc = "Разрушенная колонна из песчаника."
	icon_state = "column5"

/obj/structure/fluff/desert_construction/red_rocks
	name = "камень"
	desc = "Небольшой обломок красного песчаника."
	icon_state = "rock"
	density = FALSE
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/desert_construction/red_rocks/Initialize(mapload)
	. = ..()
	icon_state = "[pick("rock")]-[rand(1,4)]"

/obj/structure/fluff/desert_construction/black_obelisk1
	name = "поврежденный чёрный обелиск"
	desc = "Разрушенный ужасающий черный обелиск, несущий запретные знания в своих письменах"
	icon_state = "black_obelisk"

/obj/structure/fluff/desert_construction/huge_columns
	name = "колонна"
	desc = "Колонна из песчаника."
	icon = 'modular_ss220/dunes_map/icons/columns.dmi'
	icon_state = "column1"

/obj/structure/fluff/desert_construction/huge_columns/column3
	name = "колонна"
	desc = "Полуразрушенная колонна из песчаника."
	icon_state = "column3"

/obj/structure/fluff/desert_construction/huge_columns/column4
	name = "колонна"
	desc = "Каменная колонна."
	icon_state = "column2"

/obj/structure/fluff/desert_construction/huge_columns/black_obelisk2
	name = "чёрный обелиск"
	desc = "Ужасающий черный обелиск, несущий запретные знания в своих письменах"
	icon_state = "black_obelisk2"

/obj/structure/fluff/desert_construction/huge_columns/statue1
	name = "монструозная статуя"
	desc = "Статуя отвратительной твари выполненная из черного камня."
	icon_state = "ugly_statue1"

/obj/structure/fluff/desert_construction/huge_head
	name = "огромный каменный бюст"
	desc = "Вы никогда не видели чего-то более устрашающего и омерзительного."
	icon = 'modular_ss220/dunes_map/icons/hugehead.dmi'
	icon_state = "head2"
	pixel_x = -16

/obj/structure/fluff/desert_construction/huge_head/black
	icon_state = "head2_black"

/obj/structure/fluff/desert_construction/huge_head/statue2
	name = "монструозная статуя"
	desc = "Статуя отвратительной твари выполненная из черного камня."
	icon_state = "ugly_statue2"

//barricade
/obj/structure/barricade/beton
	name = "бетонный фундаментный блок"
	desc = "Здоровое бетонное ограждение. Поможет в качестве укрытия."
	icon = 'modular_ss220/dunes_map/icons/barricade.dmi'
	icon_state = "concrete_block"
	base_icon_state = "concrete_block"
	max_integrity = 300
	proj_pass_rate = 10
	pass_flags = LETPASSTHROW
	climbable = TRUE
	stacktype = null

//bars
/obj/structure/bars
	name = "решетка"
	desc = "Решетка камеры из пластали. Вряд ли её получится сломать."
	icon = 'modular_ss220/dunes_map/icons/bars.dmi'
	icon_state = "bars_wall"
	opacity = FALSE
	anchored = TRUE
	can_be_unanchored = FALSE
	density = TRUE
	max_integrity = INFINITY
	obj_integrity = INFINITY

// надо сделать или блок для вида (открыть могут только киданы) или по направлению (открыть только с dir 2)
/obj/structure/mineral_door/bars_door
	name = "решетчатая дверь"
	desc = "Вряд ли её получится сломать."
	icon = 'modular_ss220/dunes_map/icons/bars.dmi'
	icon_state = "bars"
	sheetType = /obj/item/stack/rods
	max_integrity = INFINITY
	obj_integrity = INFINITY

//flask
/obj/item/reagent_containers/drinks/flask/desert
	name = "кожаная фляжка"
	desc = "Кожаная походная фляжка кочевых народов пустыни."
	icon = 'modular_ss220/dunes_map/icons/flask.dmi'
	icon_state = "flask_leather"
	materials = list()
	volume = 80

/obj/item/reagent_containers/drinks/flask/desert/chai
	name = "медный чайник"
	desc = "Медный чайник для кипячения воды и приготовления горячих напитков."
	icon = 'modular_ss220/dunes_map/icons/flask.dmi'
	icon_state = "chai"
	volume = 50
	resistance_flags = FIRE_PROOF

/obj/item/reagent_containers/drinks/flask/ntpremium
	name = "подарочная фляжка"
	desc = "Фляжка с небольшой гравировкой ''NT'', так удачно подаренная компанией неделю назад."
	icon_state = "flask"
	volume = 50
	resistance_flags = FIRE_PROOF

//torch
/obj/structure/wall_torch
	name = "настенный факел"
	desc = "Древний и ненадежный способ освещения помещений."
	icon = 'modular_ss220/dunes_map/icons/walltorch.dmi'
	icon_state = "torchwall"
	anchored = TRUE
	max_integrity = 50
	obj_integrity = 50
	density = FALSE
	light_power = 1
	light_range = 5
	light_color = COLOR_DARK_ORANGE

/obj/structure/wall_torch/Destroy()
	var/turf/T = get_turf(src)
	new /obj/item/flashlight/flare/torch(T)
	STOP_PROCESSING(SSobj, src)
	..()

//mine
/obj/effect/mine/explosive/desert
	icon = 'modular_ss220/dunes_map/icons/mine.dmi'
	icon_state = "desertminearmed"
	faction = list("raider")
	range_heavy = 1
	range_light = 3
	range_flash = 4
	layer = LOW_OBJ_LAYER

//ID card's
/obj/item/card/id/away/kidan
	name = "самодельная идентификационная карта"
	desc = "Грубо припаянный микрочип и пара магнитных полос на пластиковой карточке."
	icon_state = "data"

/obj/item/card/id/away/kidan/Initialize(mapload)
	. = ..()
	var/kidan_name = list (
		"Лопух", "Локатор", "Костыль", "Горбун", "Кубышка", "Мотыль", "Котелок", "Бацилла", "Жаба", "Ворона", "Крыса", "Амеба", "Глиста", "Аскарида",  "Гвоздь", "Робинзон", "Курортник", "Фунт", "Гульден", "Тугрик", "Махно", "Бугор", "Змей", "Лютый", "Шайба", "Мазай", "Абу",
		)
	registered_name = "[pick (kidan_name)]"

/obj/item/card/id/centcom/tanya
	name = "Таня фон Нормандия's ID card"
	desc = "An ID straight from Central Command."
	icon_state = "centcom"
	registered_name = "Таня фон Нормандия"
	assignment = "Normandy Special Forces"
	rank = "Normandy Special Forces"

//sign
/obj/structure/warn_sign
	name = "предупреждающий знак"
	desc = "Ничего хорошего он не говорит..."
	icon = 'modular_ss220/dunes_map/icons/warn.dmi'
	icon_state = "warn"
	density = FALSE
	max_integrity = 5
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

//telecrystal
/obj/structure/telecrystal_deposit
	name = "отложение телекристаллов"
	desc = "Естественные наросты телекристаллов."
	icon = 'modular_ss220/dunes_map/icons/crystal.dmi'
	icon_state = "crystal1"
	anchored = TRUE
	layer = LOW_OBJ_LAYER
	density = FALSE
	max_integrity = 30
	light_power = 2
	light_range = 5
	light_color = COLOR_MAROON

/obj/structure/telecrystal_deposit/Destroy()
	playsound(src, 'sound/effects/pylon_shatter.ogg', 30, 0)
	var/turf/T = get_turf(src)
	new /obj/item/stack/telecrystal/five/native(T)
	..()

/obj/structure/telecrystal_deposit/mini
	icon_state = "crystal3"
	max_integrity = 10
	light_power = 5
	light_range = 1.5

/obj/structure/telecrystal_deposit/medium
	icon = 'icons/effects/vampire_effects.dmi'
	icon_state = "blood_barrier"
	max_integrity = 20
	layer = ABOVE_MOB_LAYER
	density = TRUE

/obj/structure/telecrystal_deposit/huge
	icon_state = "crystal2"
	max_integrity = 50
	light_power = 3
	light_range = 4
	layer = ABOVE_MOB_LAYER
	density = TRUE

/obj/item/stack/telecrystal/five/native
	name = "телекристалл"
	desc = "Его пульсация одновременно приманивает и настораживает."
	icon = 'modular_ss220/dunes_map/icons/crystal.dmi'
	icon_state = "native"
	dynamic_icon_state = FALSE

//CE closet rip meson

/obj/structure/closet/secure_closet/engineering_chief/rip_meson


/obj/structure/closet/secure_closet/engineering_chief/rip_meson/populate_contents()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	new /obj/item/storage/backpack/duffel/engineering(src)
	new /obj/item/areaeditor/blueprints/ce(src)
	new /obj/item/storage/box/permits(src)
	new /obj/item/storage/bag/garment/chief_engineer(src)
	new /obj/item/mod/module/jetpack/advanced(src)
	new /obj/item/cartridge/ce(src)
	new /obj/item/radio/headset/heads/ce(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/multitool(src)
	new /obj/item/holosign_creator/engineering(src)
	new /obj/item/flash(src)
	new /obj/item/door_remote/chief_engineer(src)
	new /obj/item/rpd(src)
	new /obj/item/reagent_containers/drinks/mug/ce(src)
	new /obj/item/clothing/accessory/medal/engineering(src)
	new /obj/item/holosign_creator/atmos(src)
	new /obj/item/rcd/preloaded(src)
	new /obj/item/organ/internal/cyberimp/brain/wire_interface(src)
	new /obj/item/storage/bag/construction(src)

//survival boxes with FLASK (NT premium)

/obj/item/storage/box/survival
	icon_state = "civ_box"

/obj/item/storage/box/survival/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/tank/internals/emergency_oxygen/engi(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/survival(src)
		new /obj/item/flashlight/flare(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)
	else
		new /obj/item/tank/internals/emergency_oxygen(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
		new /obj/item/flashlight/flare/glowstick/emergency(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)


/obj/item/storage/box/survival_vox
	icon_state = "vox_box"

/obj/item/storage/box/survival_vox/populate_contents()
	new /obj/item/clothing/mask/breath/vox(src)
	new /obj/item/tank/internals/emergency_oxygen/nitrogen(src)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/reagent_containers/hypospray/autoinjector/survival(src)
		new /obj/item/flashlight/flare(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)
	else
		new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
		new /obj/item/flashlight/flare/glowstick/emergency(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)

/obj/item/storage/box/survival_plasmaman
	icon_state = "plasma_box"

/obj/item/storage/box/survival_plasmaman/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/tank/internals/emergency_oxygen/plasma(src)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/reagent_containers/hypospray/autoinjector/survival(src)
		new /obj/item/flashlight/flare(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)
	else
		new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
		new /obj/item/flashlight/flare/glowstick/emergency(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)

/obj/item/storage/box/engineer
	icon_state = "eng_box"

/obj/item/storage/box/engineer/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/tank/internals/emergency_oxygen/double(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/survival(src)
		new /obj/item/flashlight/flare(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)
	else
		new /obj/item/tank/internals/emergency_oxygen/engi(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
		new /obj/item/flashlight/flare/glowstick/emergency(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)

/obj/item/storage/box/survival_mining
	icon_state = "min_box"

/obj/item/storage/box/survival_mining/populate_contents()
	new /obj/item/clothing/mask/gas/explorer(src)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/tank/internals/emergency_oxygen/double(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/survival(src)
		new /obj/item/flashlight/flare(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)
	else
		new /obj/item/tank/internals/emergency_oxygen/engi(src)
		new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
		new /obj/item/flashlight/flare/glowstick/emergency(src)
		new /obj/item/reagent_containers/drinks/flask/ntpremium(src)

/obj/item/storage/box/survival_syndi
	icon_state = "syndi_box"

/obj/item/storage/box/survival_syndi/populate_contents()
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/tank/internals/emergency_oxygen/engi/syndi(src)
	new /obj/item/crowbar/small(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/epinephrine(src)
	new /obj/item/reagent_containers/pill/initropidril(src)
	new /obj/item/flashlight/flare/glowstick/red(src)
	new /obj/item/reagent_containers/drinks/flask(src)

/obj/item/storage/box/survival/redneck
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "dnakit"

/obj/item/storage/box/survival/redneck/populate_contents()
	new /obj/item/tank/internals/emergency_oxygen/double(src)
	new /obj/item/reagent_containers/drinks/flask/desert(src)
	new /obj/item/kitchen/knife/combat/survival(src)
	new /obj/item/flashlight/flare(src)
	new /obj/item/stack/medical/bruise_pack/comfrey(src)
	new /obj/item/stack/medical/ointment/aloe(src)

//sarcophagus

/obj/structure/closet/coffin/sarcophagus/full

/obj/structure/closet/coffin/sarcophagus/full/populate_contents()
	new /obj/effect/mob_spawn/human/corpse/skeleton(src)

//cube and VSA

/obj/item/stock_parts/cell/cube
	name = "Куб"
	desc = "Легендарный артефакт, Куб. Пожалуй, самый ценный в обитаемой Галактике. Его гладкая поверхность холодно поблёскивает чернотой."
	maxcharge = 500000
	chargerate = 100
	icon = 'modular_ss220/dunes_map/icons/cube.dmi'
	icon_state = "empty"

/obj/item/stock_parts/cell/cube/process()
	if(percent() == 100)
		icon_state = "charged"
	else
		icon_state = "empty"


/obj/item/stock_parts/cell/cube/New()
	. = ..()
	// charge = 0

/obj/item/stock_parts/cell/cube/Destroy()
	empulse(get_turf(loc), 4, 10, 1)
	explosion(get_turf(loc), 0, 0, 20, 0)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H.name == "Миднайт Блэк")
			qdel(H)
			return
	return ..()



/obj/machinery/bsa/full/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/stock_parts/cell/cube ))
		var/obj/item/stock_parts/cell/cube/C = I
		if(C.charge >= 500000)

			if(!do_after(user, 3 SECONDS, target = src))
				return
			name = "Войдспейс Артиллерия"
			desc = "Эксперементальная дальнобойная артиллерия, несущая в себе необузданную мощь Куба. Да поможет нам Господь..."
			icon = 'modular_ss220/dunes_map/icons/bsa.dmi'
			icon_state = "cannon"
			update_icon()
			reload_cooldown = 600
			C.charge = 0
			pixel_y = -60
			return
	. = ..()

/obj/machinery/bsa/full/fire(mob/user, turf/bullseye, target)
	if(src.name == "Войдспейс Артиллерия")
		var/turf/point = get_front_turf()
		for(var/turf/T in get_line(get_step(point,dir),get_target_turf()))
			T.ex_act(1)
			for(var/atom/A in T)
				A.ex_act(1)

		point.Beam(get_target_turf(), icon_state = "bsa_beam", icon = 'modular_ss220/dunes_map/icons/beam.dmi', time = 50, maxdistance = world.maxx, beam_type = /obj/effect/ebeam/deadly) //ZZZAP
		playsound(src, 'modular_ss220/dunes_map/sound/weapons/VSA.ogg', 200, 1)
		if(istype(target, /obj/item/gps))
			var/obj/item/gps/G = target
			message_admins("[key_name_admin(user)] has launched an artillery strike at GPS named [G.gpstag].")

		else
			message_admins("[key_name_admin(user)] has launched an artillery strike.")//Admin BSA firing, just targets a room, which the explosion says

		log_admin("[key_name(user)] has launched an artillery strike.") // Line below handles logging the explosion to disk
		explosion(bullseye,ex_power,ex_power*2,ex_power*4)

		reload()
		return
	else
		. = ..()


