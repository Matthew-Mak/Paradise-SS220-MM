
// --------------------------------------------------------------------------------
// ----------------- TERROR SPIDERS: T4 QUEEN OF TERROR ---------------------------
// --------------------------------------------------------------------------------
// -------------: ROLE: gamma-level threat to the whole station, like a blob
// -------------: AI: builds a nest, lays many eggs, attempts to take over the station
// -------------: SPECIAL: spins webs, breaks lights, breaks cameras, webs objects, lays eggs, commands other spiders...
// -------------: TO FIGHT IT: bring an army, and take no prisoners. Mechs are a very good idea.
// -------------: SPRITES FROM: IK3I

/mob/living/simple_animal/hostile/poison/terror_spider/queen
	maxHealth = 340
	health = 340
	damage_coeff = list(BRUTE = 0.7, BURN = 1.1, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
	regeneration = 3
	deathmessage = "Emits a  piercing screech that echoes through the hallways, chilling the hearts of those around, as the spider lifelessly falls to the ground."
	death_sound = 'modular_ss220/events/sound/creatures/terrorspiders/queen_death.ogg'
	melee_damage_lower = 25
	melee_damage_upper = 30
	armour_penetration_flat = 10
	obj_damage = 100
	environment_smash = ENVIRONMENT_SMASH_WALLS
	idle_ventcrawl_chance = 0
	move_resist = MOVE_FORCE_STRONG // no more pushing a several hundred if not thousand pound spider
	force_threshold = 18 // outright immune to anything of force under 18, this means welders can't hurt it, only guns can
	projectilesound = 'modular_ss220/events/sound/creatures/terrorspiders/spit2.ogg'
	projectiletype = /obj/item/projectile/terrorspider/queen
	ranged_cooldown_time = 20
	web_type = /obj/structure/spider/terrorweb/queen/improved
	delay_web = 15
	special_abillity = list(/datum/spell/aoe/terror_shriek_queen)
	can_wrap = FALSE
	spider_intro_text = "Будучи Королевой Ужаса, ваша цель - управление выводком и откладывание яиц. Вы крайне сильны, и со временем будете откладывать всё больше яиц, однако, ваша смерть будет означать поражение, ведь все пауки погибнут."

	var/datum/action/innate/terrorspider/ventsmash/ventsmash_action
	var/datum/action/innate/terrorspider/remoteview/remoteview_action

/mob/living/simple_animal/hostile/poison/terror_spider/queen/grant_eggs()
	spider_lastspawn = world.time
	canlay += getSpiderLevel()
	if(canlay == 1)
		to_chat(src, "<span class='notice'>You have an egg available to lay.</span>")
		SEND_SOUND(src, sound('modular_ss220/events/sound/effects/ping.ogg'))
	else if(canlay > 1)
		to_chat(src, "<span class='notice'>You have [canlay] eggs available to lay.</span>")
		SEND_SOUND(src, sound('modular_ss220/events/sound/effects/ping.ogg'))



/mob/living/simple_animal/hostile/poison/terror_spider/queen/spider_special_action()
	if(!stat && !ckey)
		switch(neststep)
			if(0)
				// No nest. If current location is eligible for nesting, advance to step 1.
				var/ok_to_nest = TRUE
				var/area/new_area = get_area(loc)
				if(new_area)
					if(findtext(new_area.name, "hall"))
						ok_to_nest = FALSE
						// nesting in a hallway would be very stupid - crew would find and kill you almost instantly
				var/numhostiles = 0
				for(var/mob/living/H in oview(10, src))
					if(!istype(H, /mob/living/simple_animal/hostile/poison/terror_spider))
						if(H.stat != DEAD)
							numhostiles += 1
							// nesting RIGHT NEXT TO SOMEONE is even worse
				if(numhostiles > 0)
					ok_to_nest = FALSE
				var/vdistance = 99
				for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(10, src))
					if(!v.welded)
						if(get_dist(src, v) < vdistance)
							entry_vent = v
							vdistance = get_dist(src, v)
				if(!entry_vent)
					ok_to_nest = FALSE
					// don't nest somewhere with no vent - your brood won't be able to get out!
				if(ok_to_nest && entry_vent)
					nest_vent = entry_vent
					neststep = 1
					visible_message("<span class='danger'>\The [src] settles down, starting to build a nest.</span>")
				else if(entry_vent)
					if(!path_to_vent)
						visible_message("<span class='danger'>\The [src] looks around warily - then seeks a better nesting ground.</span>")
						path_to_vent = 1
				else
					neststep = -1
					message_admins("Warning: [ADMIN_LOOKUPFLW(src)] was spawned in an area without a vent! This is likely a mapping/spawn mistake. This mob's AI has been permanently deactivated.")
			if(1)
				// No nest, and we should create one. Start NestMode(), then advance to step 2.
				if(world.time > (lastnestsetup + nestfrequency))
					lastnestsetup = world.time
					neststep = 2
					NestMode()
			if(2)
				// Create initial T2 spiders.
				if(world.time > (lastnestsetup + nestfrequency))
					lastnestsetup = world.time
					spider_lastspawn = world.time
					DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/guardian, 2)
					DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/defiler, 2)
					DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer, 2)
					neststep = 3
			if(3)
				// Create spiders (random types) until nest is full.
				if(world.time > (spider_lastspawn + spider_spawnfrequency))
					if(prob(20))
						if(ai_nest_is_full())
							if(spider_awaymission)
								spider_spawnfrequency = spider_spawnfrequency_stable
							neststep = 4
						else
							spider_lastspawn = world.time
							var/spiders_left_to_spawn = clamp( (spider_max_per_nest - CountSpiders()), 1, 10)
							DoLayTerrorEggs(pick(spider_types_standard), spiders_left_to_spawn)
			if(4)
				// Nest should be full. Otherwise, start replenishing nest (stage 5).
				if(world.time > (spider_lastspawn + spider_spawnfrequency))
					if(prob(20) && !ai_nest_is_full())
						neststep = 5
			if(5)
				// If already replenished, go idle (stage 4). Otherwise, replenish nest.
				if(world.time > (spider_lastspawn + spider_spawnfrequency))
					if(prob(20))
						if(ai_nest_is_full())
							neststep = 4
						else
							spider_lastspawn = world.time
							var/list/spider_array = CountSpidersDetailed(FALSE)
							if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/guardian] < 4)
								DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/guardian, 2)
							else if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/defiler] < 2)
								DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/defiler, 2)
							else if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/destroyer] < 4)
								DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer, 4)
							else
								DoLayTerrorEggs(pick(spider_types_standard), 5)


/mob/living/simple_animal/hostile/poison/terror_spider/queen/ListAvailableEggTypes()
	if(MinutesAlive() >= 25)
		var/list/spider_array = CountSpidersDetailed(TRUE, list(/mob/living/simple_animal/hostile/poison/terror_spider/mother, /mob/living/simple_animal/hostile/poison/terror_spider/defiler, /mob/living/simple_animal/hostile/poison/terror_spider/queen/princess))
		if(spider_array["all"] == 0)
			return list(TS_DESC_DEFILER, TS_DESC_PRINCESS, TS_DESC_MOTHER)

	var/list/valid_types = list(TS_DESC_KNIGHT, TS_DESC_LURKER, TS_DESC_HEALER, TS_DESC_REAPER, TS_DESC_BUILDER)
	var/list/spider_array = CountSpidersDetailed(FALSE, list(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer, /mob/living/simple_animal/hostile/poison/terror_spider/guardian, /mob/living/simple_animal/hostile/poison/terror_spider/widow))
	if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/destroyer] < 3)
		valid_types += TS_DESC_DESTROYER
	if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/guardian] < 3)
		valid_types += TS_DESC_GUARDIAN
	if(spider_array[/mob/living/simple_animal/hostile/poison/terror_spider/widow] < 4)
		valid_types += TS_DESC_WIDOW
	return valid_types

/mob/living/simple_animal/hostile/poison/terror_spider/queen/LayQueenEggs()
	if(stat == DEAD)
		return
	if(!hasnested)
		to_chat(src, "<span class='danger'>You must nest before doing this.</span>")
		return
	if(canlay < 1)
		show_egg_timer()
		return
	var/list/eggtypes = ListAvailableEggTypes()
	var/list/eggtypes_uncapped = list(TS_DESC_KNIGHT, TS_DESC_LURKER, TS_DESC_HEALER, TS_DESC_REAPER, TS_DESC_BUILDER)

	var/eggtype = input("What kind of eggs?") as null|anything in eggtypes
	if(canlay < 1)
		// this was checked before input() but we have to check again to prevent them spam-clicking the popup.
		to_chat(src, "<span class='danger'>Too soon to lay another egg.</span>")
		return
	if(!(eggtype in eggtypes))
		to_chat(src, "<span class='danger'>Unrecognized egg type.</span>")
		return 0

	// Multiple of eggtypes_uncapped can be laid at once. Other types must be laid one at a time (to prevent exploits)
	var/numlings = 1
	if(eggtype in eggtypes_uncapped)
		if(canlay >= 5)
			numlings = input("How many in the batch?") as null|anything in list(1, 2, 3, 4, 5)
		else if(canlay >= 3)
			numlings = input("How many in the batch?") as null|anything in list(1, 2, 3)
		else if(canlay == 2)
			numlings = input("How many in the batch?") as null|anything in list(1, 2)
	if(eggtype == null || numlings == null)
		to_chat(src, "<span class='danger'>Cancelled.</span>")
		return
	// Actually lay the eggs.
	if(canlay < numlings)
		// We have to check this again after the popups, to account for people spam-clicking the button, then doing all the popups at once.
		to_chat(src, "<span class='warning'>Too soon to do this again!</span>")
		return
	canlay -= numlings
	eggslaid += numlings
	switch(eggtype)
		if(TS_DESC_KNIGHT)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/knight, numlings)
		if(TS_DESC_LURKER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/lurker, numlings)
		if(TS_DESC_HEALER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/healer, numlings)
		if(TS_DESC_REAPER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/reaper, numlings)
		if(TS_DESC_BUILDER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/builder, numlings)
		if(TS_DESC_WIDOW)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/widow, numlings)
		if(TS_DESC_GUARDIAN)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/guardian, numlings)
		if(TS_DESC_DESTROYER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer, numlings)
		if(TS_DESC_MOTHER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/mother, numlings)
		if(TS_DESC_DEFILER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/defiler, numlings)
		if(TS_DESC_PRINCESS)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/queen/princess, numlings)
		else
			to_chat(src, "<span class='danger'>Unrecognized egg type.</span>")


/mob/living/simple_animal/hostile/poison/terror_spider/queen/DoQueenScreech(light_range, light_chance, camera_range, camera_chance)
	playsound(src.loc, 'modular_ss220/events/sound/creatures/terrorspiders/queen_shriek.ogg', 100, 1)
	. = ..()





/mob/living/simple_animal/hostile/poison/terror_spider/queen/examine(mob/user)
	. = ..()
	if(!key || stat == DEAD)
		return
	if(!isobserver(user) && !isterrorspider(user))
		return
	. += "<span class='notice'>[p_they(TRUE)] has laid [eggslaid] egg[eggslaid != 1 ? "s" : ""].</span>"
	. += "<span class='notice'>[p_they(TRUE)] has lived for [MinutesAlive()] minutes.</span>"


/obj/item/projectile/terrorspider/queen
	name = "queen venom"
	icon_state = "toxin3"
	damage = 40
	stamina = 40
	damage_type = BURN

/obj/structure/spider/terrorweb/queen/improved
	max_integrity = 30
