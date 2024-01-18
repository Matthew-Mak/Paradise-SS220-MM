/datum/action/innate/cult/blood_magic //Blood magic handles the creation of blood spells (formerly talismans)
	name = "Подготовить Магию Крови"
	button_icon_state = "carve"
	desc = "Подготовьте Магию Крови путём высечения рун на вашей плоти. Это сделать проще с <b>руной усиления</b>."
	var/list/spells = list()
	var/channeling = FALSE

/datum/action/innate/cult/blood_magic/Remove()
	for(var/X in spells)
		qdel(X)
	..()

/datum/action/innate/cult/blood_magic/override_location()
	button.ordered = FALSE
	button.screen_loc = DEFAULT_BLOODSPELLS
	button.moved = DEFAULT_BLOODSPELLS

/datum/action/innate/cult/blood_magic/proc/Positioning()
	var/list/screen_loc_split = splittext(button.screen_loc, ",")
	var/list/screen_loc_X = splittext(screen_loc_split[1], ":")
	var/list/screen_loc_Y = splittext(screen_loc_split[2], ":")
	var/pix_X = text2num(screen_loc_X[2])
	for(var/datum/action/innate/cult/blood_spell/B in spells)
		if(B.button.locked)
			var/order = pix_X + spells.Find(B) * 31
			B.button.screen_loc = "[screen_loc_X[1]]:[order],[screen_loc_Y[1]]:[screen_loc_Y[2]]"
			B.button.moved = B.button.screen_loc

/datum/action/innate/cult/blood_magic/Activate()
	var/rune = FALSE
	var/limit = RUNELESS_MAX_BLOODCHARGE
	for(var/obj/effect/rune/empower/R in range(1, owner))
		rune = TRUE
		limit = MAX_BLOODCHARGE
		break
	if(length(spells) >= limit)
		if(rune)
			to_chat(owner, "<span class='cultitalic'>Вы не можете хранить более [MAX_BLOODCHARGE] заклинаний. <b>Выберите заклинание для удаления.</b></span>")
			remove_spell("You cannot store more than [MAX_BLOODCHARGE] spell\s, pick a spell to remove.")
		else
			to_chat(owner, "<span class='cultitalic'>Вы не можете хранить более [RUNELESS_MAX_BLOODCHARGE] заклинаний без руны усиления! <b>Выберите заклинание для удаления.</b></span>")
			remove_spell("Вы не можете хранить более [RUNELESS_MAX_BLOODCHARGE] заклинаний без руны усиления, выберите заклинание на удаления.")
		return
	var/entered_spell_name
	var/datum/action/innate/cult/blood_spell/BS
	var/list/possible_spells = list()

	for(var/I in subtypesof(/datum/action/innate/cult/blood_spell))
		var/datum/action/innate/cult/blood_spell/J = I
		var/cult_name = initial(J.name)
		possible_spells[cult_name] = J
	if(length(spells))
		possible_spells += "(УДАЛИТЬ ЗАКЛИНАНИЕ)"
	entered_spell_name = input(owner, "Выберите заклинание для удаления...", "Выбор заклинаний...") as null|anything in possible_spells
	if(entered_spell_name == "(УДАЛИТЬ ЗАКЛИНАНИЕ)")
		remove_spell()
		return
	BS = possible_spells[entered_spell_name]
	if(QDELETED(src) || owner.incapacitated() || !BS || (rune && !(locate(/obj/effect/rune/empower) in range(1, owner))) || (length(spells) >= limit))
		return

	if(!channeling)
		channeling = TRUE
		to_chat(owner, "<span class='cultitalic'>Вы начинаете высекать руны на своём теле!</span>")
	else
		to_chat(owner, "<span class='warning'>Вы уже вызываете Магию Крови!</span>")
		return

	if(do_after(owner, 100 - rune * 60, target = owner))
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(H.dna && (NO_BLOOD in H.dna.species.species_traits))
				H.cult_self_harm(3 - rune * 2)
			else
				H.bleed(20 - rune * 12)
		var/datum/action/innate/cult/blood_spell/new_spell = new BS(owner)
		spells += new_spell
		new_spell.Grant(owner, src)
		to_chat(owner, "<span class='cult'>Ваши раны сияют мощью, вы подготовили заклинание [new_spell.name]!</span>")
		SSblackbox.record_feedback("tally", "cult_spells_prepared", 1, "[new_spell.name]")
	channeling = FALSE

/datum/action/innate/cult/blood_magic/proc/remove_spell(message = "Выберите заклинание для удаления.")
	var/nullify_spell = input(owner, message, "Current Spells") as null|anything in spells
	if(nullify_spell)
		qdel(nullify_spell)

/datum/action/innate/cult/blood_spell //The next generation of talismans, handles storage/creation of blood magic
	name = "Магия Крови"
	button_icon_state = "telerune"
	desc = "Бойтесь старой крови."
	var/charges = 1
	var/magic_path = null
	var/obj/item/melee/blood_magic/hand_magic
	var/datum/action/innate/cult/blood_magic/all_magic
	var/base_desc //To allow for updating tooltips
	var/invocation = "Hoi there something's wrong!"
	var/health_cost = 0

/datum/action/innate/cult/blood_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/BM)
	if(health_cost)
		desc += "<br>Наносит <u>[health_cost] урона</u> руке за использование."
	base_desc = desc
	desc += "<br><b><u>Осталось [charges] зарядов</u></b>."
	all_magic = BM
	button.ordered = FALSE
	..()

/datum/action/innate/cult/blood_spell/override_location()
	button.locked = TRUE
	all_magic.Positioning()

/datum/action/innate/cult/blood_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
	if(hand_magic)
		qdel(hand_magic)
		hand_magic = null
	..()

/datum/action/innate/cult/blood_spell/IsAvailable()
	if(!iscultist(owner) || owner.incapacitated() || !charges)
		return FALSE
	return ..()

/datum/action/innate/cult/blood_spell/Activate()
	if(owner.holy_check())
		return
	if(magic_path) // If this spell flows from the hand
		if(!hand_magic) // If you don't already have the spell active
			hand_magic = new magic_path(owner, src)
			if(!owner.put_in_hands(hand_magic))
				qdel(hand_magic)
				hand_magic = null
				to_chat(owner, "<span class='warning'>Хотя бы одна рука должна быть пустой для вызова Магии Крови!</span>")
				return
			to_chat(owner, "<span class='cultitalic'>Your wounds glow as you invoke the [name].</span>")

		else // If the spell is active, and you clicked on the button for it
			qdel(hand_magic)
			hand_magic = null

//the spell list

/datum/action/innate/cult/blood_spell/stun
	name = "Оглушение"
	desc = "Ослабит и наложит немоту на жертве при контакте. Атакуйте с кинжалом культа для завершения процесса, оглушая и накладывая немоту на более продолжительное время."
	button_icon_state = "stun"
	magic_path = /obj/item/melee/blood_magic/stun
	health_cost = 10

/datum/action/innate/cult/blood_spell/teleport
	name = "Телепорт"
	desc = "Позволяет вашей рукой телепортировать себя или другого культиста на руну телепорта касанием."
	button_icon_state = "teleport"
	magic_path = /obj/item/melee/blood_magic/teleport
	health_cost = 7

/datum/action/innate/cult/blood_spell/emp
	name = "Электромагнитный импульс"
	desc = "Выпускает ЭМИ, которое воздействует на всех некультистов. <b>ЭМИ будет всё ещё воздействовать на вас.</b>"
	button_icon_state = "emp"
	health_cost = 10
	invocation = "Ta'gh fara'qha fel d'amar det!"

/datum/action/innate/cult/blood_spell/emp/Grant(mob/living/owner)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/oof = FALSE
		for(var/obj/item/organ/external/E in H.bodyparts)
			if(E.is_robotic())
				oof = TRUE
				break
		if(!oof)
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(I.is_robotic())
					oof = TRUE
					break
		if(oof)
			to_chat(owner, "<span class='userdanger'>Вы чувствуете, что это плохая идея.</span>")
	..()

/datum/action/innate/cult/blood_spell/emp/Activate()
	if(owner.holy_check())
		return
	owner.visible_message("<span class='warning'>Тело [owner] начинает светитсья ярко-синим!</span>", \
						"<span class='cultitalic'>Вы произносите проклятые слова, вызывая ЭМИ в вашем теле.</span>")
	owner.emp_act(2)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(empulse), owner, 2, 5, TRUE, "cult")
	owner.whisper(invocation)
	charges--
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/shackles
	name = "Теневые оковы"
	desc = "Позволяет вашим рукам связывать жертв и накладывать на них немоту при успехе."
	button_icon_state = "shackles"
	charges = 4
	magic_path = /obj/item/melee/blood_magic/shackles

/datum/action/innate/cult/blood_spell/construction
	name = "Искажённое строительство"
	desc = "Позволяет вашей руке искажать.<br><u>Converts:</u><br>Plasteel into runed metal<br>50 metal into a construct shell<br>Cyborg shells into construct shells<br>Airlocks into brittle runed airlocks after a delay (harm intent)"
	button_icon_state = "transmute"
	magic_path = "/obj/item/melee/blood_magic/construction"
	health_cost = 12

/datum/action/innate/cult/blood_spell/dagger
	name = "Вызов кинжала"
	desc = "Призывет кинжал, необходимый для начертания рун."
	button_icon_state = "cult_dagger"

/datum/action/innate/cult/blood_spell/dagger/New()
	if(SSticker.mode)
		button_icon_state = SSticker.cultdat.dagger_icon
	..()

/datum/action/innate/cult/blood_spell/dagger/Activate()
	var/turf/T = get_turf(owner)
	owner.visible_message("<span class='warning'>Рука [owner] на мгновение светится красным.</span>", \
						"<span class='cultitalic'>Красное свечение начинает мерцать и обретать форму в вашей руке!</span>")
	var/obj/item/melee/cultblade/dagger/O = new(T)
	if(owner.put_in_hands(O))
		to_chat(owner, "<span class='warning'>[O.name] появляется в руке!</span>")
	else
		owner.visible_message("<span class='warning'>[O.name] появляется у ног [owner]!</span>", \
							"<span class='cultitalic'>[O.name] материализуется у ваших ног.</span>")
	playsound(owner, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))
	charges--
	desc = base_desc
	desc += "<br><b><u>Осталось [charges] зарядов.</u></b>."
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/equipment
	name = "Призыв снаряжения"
	desc = "Позволяет вашей руке призвать снаряжение на себе или на соратнике при касании, включая броню в свободные слоты, болу культа и меч культа."
	button_icon_state = "equip"
	magic_path = /obj/item/melee/blood_magic/armor

/datum/action/innate/cult/blood_spell/horror
	name = "Галлюцинации"
	desc = "Даёт жертве галлюцинации на расстоянии. Тихое и невидимое заклинание."
	button_icon_state = "horror"
	var/obj/effect/proc_holder/horror/PH
	charges = 4

/datum/action/innate/cult/blood_spell/horror/New()
	PH = new()
	PH.attached_action = src
	..()

/datum/action/innate/cult/blood_spell/horror/Destroy()
	var/obj/effect/proc_holder/horror/destroy = PH
	. = ..()
	if(!QDELETED(destroy))
		QDEL_NULL(destroy)

/datum/action/innate/cult/blood_spell/horror/Activate()
	PH.toggle(owner) //the important bit
	return TRUE

/obj/effect/proc_holder/horror
	active = FALSE
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	var/datum/action/innate/cult/blood_spell/attached_action

/obj/effect/proc_holder/horror/Destroy()
	var/datum/action/innate/cult/blood_spell/AA = attached_action
	. = ..()
	if(!QDELETED(AA))
		QDEL_NULL(AA)

/obj/effect/proc_holder/horror/proc/toggle(mob/user)
	if(active)
		remove_ranged_ability(user, "<span class='cult'>Вы рассеиваете магию...</span>")
	else
		add_ranged_ability(user, "<span class='cult'>Вы готовитесь напугать жертву...</span>")

/obj/effect/proc_holder/horror/InterceptClickOn(mob/living/user, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated() || !iscultist(user))
		user.ranged_ability.remove_ranged_ability(user)
		return
	if(user.holy_check())
		return
	var/turf/T = get_turf(ranged_ability_user)
	if(!isturf(T))
		return FALSE
	if(target in view(7, ranged_ability_user))
		if(!ishuman(target) || iscultist(target))
			return
		var/mob/living/carbon/human/H = target
		H.Hallucinate(120 SECONDS)
		attached_action.charges--
		attached_action.desc = attached_action.base_desc
		attached_action.desc += "<br><b><u>Осталось [attached_action.charges] зарядов</u></b>."
		attached_action.UpdateButtonIcon()
		user.ranged_ability.remove_ranged_ability(user, "<span class='cult'><b>[H] был проклят живыми кошмарами!</b></span>")
		if(attached_action.charges <= 0)
			to_chat(ranged_ability_user, "<span class='cult'>Сила заклинания истощена!</span>")
			qdel(src)

/datum/action/innate/cult/blood_spell/veiling
	name = "Сокрытие присутствия"
	desc = "Переключается между сокрытием и показом ближайших культистских построек, шлюзов и рун."
	invocation = "Kla'atu barada nikt'o!"
	button_icon_state = "veiling"
	charges = 10
	var/revealing = FALSE //if it reveals or not

/datum/action/innate/cult/blood_spell/veiling/Activate()
	if(owner.holy_check())
		return
	if(!revealing) // Hiding stuff
		owner.visible_message("<span class='warning'>Толстая серая пыль выходит из руки [owner]!</span>", \
		"<span class='cultitalic'>Вы вызываете заклинание сокрытия, скрывая руны и постройки культа.</span>")
		charges--
		if(!SSticker.mode.cult_risen || !SSticker.mode.cult_ascendant)
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(4)) // If Cult is risen/ascendant.
		else
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(1)) // If Cult is unpowered.
		owner.whisper(invocation)
		for(var/obj/O in range(4, owner))
			O.cult_conceal()
		revealing = TRUE // Switch on use
		name = "Показ рун"
		button_icon_state = "revealing"

	else // Unhiding stuff
		owner.visible_message("<span class='warning'>Вспышка света сияет из руки [owner]!</span>", \
		"<span class='cultitalic'>Вы применяете контрзаклинание, показывая ближайшие руны и постройки культа.</span>")
		charges--
		owner.whisper(invocation)
		if(!SSticker.mode.cult_risen || !SSticker.mode.cult_ascendant)
			playsound(owner, 'sound/misc/enter_blood.ogg', 25, TRUE, SOUND_RANGE_SET(7)) // If Cult is risen/ascendant.
		else
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(1)) // If Cult is unpowered.
		for(var/obj/O in range(5, owner)) // Slightly higher in case we arent in the exact same spot
			O.cult_reveal()
		revealing = FALSE // Switch on use
		name = "Сокрытие рун"
		button_icon_state = "veiling"
	if(charges <= 0)
		qdel(src)
	desc = "[revealing ? "Показывает" : "Скрывает"] ближайшие постройки, шлюзы и руны."
	desc += "<br><b><u>Осталось [charges] зарядов</u></b>."
	UpdateButtonIcon()

/datum/action/innate/cult/blood_spell/manipulation
	name = "Кровавый Обряд"
	desc = "Позволяет вашей руке манипулировать кровью. Используйте на кровавых пятнах или некультстах для поглощения крови для дальнейшего использовани, или используйте на себе или на другом культисте для вылечивания их ран с помощью поглощённой крови. \
		\nИспользуйте данное заклинание в руке для использования продвинутых обрядов, такие как вызов кровавого копья, стрельба кровавыми снарядами из рук и не только!"
	invocation = "Fel'th Dol Ab'orod!"
	button_icon_state = "manip"
	charges = 5
	magic_path = /obj/item/melee/blood_magic/manipulator

// The "magic hand" items
/obj/item/melee/blood_magic
	name = "Магическая аура"
	desc = "Зловещая аура, которая искажает течение реальности вокруг."
	icon = 'icons/obj/items.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	icon_state = "disintegrate"
	item_state = "disintegrate"
	flags = ABSTRACT | DROPDEL

	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	/// Does it have a source, AKA bloody empowerment.
	var/has_source = TRUE
	var/invocation
	var/uses = 1
	var/health_cost = 0 //The amount of health taken from the user when invoking the spell
	var/datum/action/innate/cult/blood_spell/source

/obj/item/melee/blood_magic/New(loc, spell)
	if(has_source)
		source = spell
		uses = source.charges
		health_cost = source.health_cost
	..()

/obj/item/melee/blood_magic/Destroy()
	if(has_source && !QDELETED(source))
		if(uses <= 0)
			source.hand_magic = null
			qdel(source)
			source = null
		else
			source.hand_magic = null
			source.charges = uses
			source.desc = source.base_desc
			source.desc += "<br><b><u>Осталось [uses] зарядов</u></b>."
			source.UpdateButtonIcon()
	return ..()

/obj/item/melee/blood_magic/customised_abstract_text(mob/living/carbon/owner)
	return "<span class='warning'>[owner.p_their(TRUE)] [owner.l_hand == src ? "left hand" : "right hand"] is burning in blood-red fire.</span>"

/obj/item/melee/blood_magic/attack_self(mob/living/user)
	afterattack(user, user, TRUE)

/obj/item/melee/blood_magic/attack(mob/living/M, mob/living/carbon/user)
	if(!iscarbon(user) || !iscultist(user))
		uses = 0
		qdel(src)
		return
	add_attack_logs(user, M, "использовал заклинание культа ([src]) на")
	M.lastattacker = user.real_name

/obj/item/melee/blood_magic/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(invocation)
		user.whisper(invocation)
	if(health_cost && ishuman(user))
		user.cult_self_harm(health_cost)
	if(uses <= 0)
		qdel(src)
	else if(source)
		source.desc = source.base_desc
		source.desc += "<br><b><u>Осталось [uses] зарядов</u></b>."
		source.UpdateButtonIcon()

//The spell effects

//stun
/obj/item/melee/blood_magic/stun
	name = "Аура оглушения"
	desc = "Ослабляет и накладывает немоту на цель при прикосновении. Атакуйте их кинжалом культа для завершения заклинания, оглушая и увеличивая длительность немоты."
	color = RUNE_COLOR_RED
	invocation = "Fuu ma'jin!"

/obj/item/melee/blood_magic/stun/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target) || !proximity)
		return
	var/mob/living/L = target
	if(iscultist(target))
		return
	if(user.holy_check())
		return
	user.visible_message("<span class='warning'>[user] держит [user.p_their()] в руке, которая взрывается во вспышке красного света!</span>", \
							"<span class='cultitalic'>Вы пытаетесь оглушить [L] с помощью заклинания!</span>")

	user.mob_light(LIGHT_COLOR_BLOOD_MAGIC, 3, _duration = 2)

	var/obj/item/nullrod/N = locate() in target
	if(N)
		target.visible_message("<span class='warning'>Святое оружие [target] поглощает красный свет!</span>", \
							"<span class='userdanger'>Ваше святое оружие поглащает ослепляющий свет!</span>")
	else
		to_chat(user, "<span class='cultitalic'>В яркой вспышке света, [L] падает на землю!</span>")

		L.KnockDown(10 SECONDS)
		L.adjustStaminaLoss(60)
		L.apply_status_effect(STATUS_EFFECT_CULT_STUN)
		L.flash_eyes(1, TRUE)
		if(issilicon(target))
			var/mob/living/silicon/S = L
			S.emp_act(EMP_HEAVY)
		else if(iscarbon(target))
			var/mob/living/carbon/C = L
			C.Silence(6 SECONDS)
			C.Stuttering(16 SECONDS)
			C.CultSlur(20 SECONDS)
			C.Jitter(16 SECONDS)
			to_chat(user, "<span class='boldnotice'>Метка оглушения применена! Ударьте цель кинжалом, мечом или or кровавым копьём для их полного оглушения!</span>")
	user.do_attack_animation(target)
	uses--
	..()


//Teleportation
/obj/item/melee/blood_magic/teleport
	name = "Аура телепорта"
	color = RUNE_COLOR_TELEPORT
	desc = "Телепортирует к культисту или к руне при касании."
	invocation = "Sas'so c'arta forbici!"

/obj/item/melee/blood_magic/teleport/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	var/list/duplicaterunecount = list()
	var/atom/movable/teleportee
	if(!iscultist(target) || !proximity)
		to_chat(user, "<span class='warning'>Только культисты могут быть телепортированы с помощью заклинания!</span>")
		return
	if(user != target) // So that the teleport effect shows on the correct mob
		teleportee = target
	else
		teleportee = user

	for(var/R in GLOB.teleport_runes)
		var/obj/effect/rune/teleport/T = R
		var/resultkey = T.listkey
		if(resultkey in teleportnames)
			duplicaterunecount[resultkey]++
			resultkey = "[resultkey] ([duplicaterunecount[resultkey]])"
		else
			teleportnames.Add(resultkey)
			duplicaterunecount[resultkey] = 1
		potential_runes[resultkey] = T

	if(!length(potential_runes))
		to_chat(user, "<span class='warning'>Отсутсвуют руны телепортации!</span>")
		log_game("Teleport spell failed - no other teleport runes")
		return
	if(!is_level_reachable(user.z))
		to_chat(user, "<span class='cultitalic'>Вы слишком далеко от станции для телепортации!</span>")
		log_game("Teleport spell failed - user in away mission")
		return

	var/input_rune_key = input(user, "Выберите, к какой руне телепортироваться.", "Телепорт к руне") as null|anything in potential_runes //we know what key they picked
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(QDELETED(src) || !user || user.l_hand != src && user.r_hand != src || user.incapacitated() || !actual_selected_rune)
		return

	if(HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, "<span class='cultitalic'>Использование заклинания во время оглушения невозможна!</span>")
		return

	uses--

	var/turf/origin = get_turf(teleportee)
	var/turf/destination = get_turf(actual_selected_rune)
	INVOKE_ASYNC(actual_selected_rune, TYPE_PROC_REF(/obj/effect/rune, teleport_effect), teleportee, origin, destination)

	if(is_mining_level(user.z) && !is_mining_level(destination.z)) //No effect if you stay on lavaland
		actual_selected_rune.handle_portal("lava")
	else if(!is_station_level(user.z) || istype(get_area(user), /area/space))
		actual_selected_rune.handle_portal("space", origin)

	if(user == target)
		target.visible_message("<span class='warning'>Из руки [user] сыпется пыль, и [user.p_they()] исчезает[user.p_s()] со вспышкой красного света!</span>", \
		"<span class='cultitalic'>Вы произносите слова и понимаете, что оказались в другом месте!</span>")
	else
		target.visible_message("<span class='warning'>Из руки [user] сыпется пыль, и [target] исчезает со вспышкой красного света!</span>", \
		"<span class='cultitalic'>Вы внезапно оказались в другом месте!</span>")
	destination.visible_message("<span class='warning'>В воздухе доносится гул, и что-то появляется над руной !</span>", null, "<i>Вы слышите гул.</i>")
	teleportee.forceMove(destination)
	return ..()

//Shackles
/obj/item/melee/blood_magic/shackles
	name = "Аура сковывания"
	desc = "Начнёт заковывать жертву при контакте, кратковременно накладывая немоту при успехе."
	invocation = "In'totum Lig'abis!"
	color = "#000000" // black

/obj/item/melee/blood_magic/shackles/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	if(iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		if(C.canBeHandcuffed() || C.get_arm_ignore())
			CuffAttack(C, user)
		else
			user.visible_message("<span class='cultitalic'>У жертвы нехватает рук для завершения заковывания!</span>")
			return
		..()

/obj/item/melee/blood_magic/shackles/proc/CuffAttack(mob/living/carbon/C, mob/living/user)
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, TRUE, SOUND_RANGE_SET(7))
		C.visible_message("<span class='danger'>[user] начинает сковывать [C] с помощью тёмной магии!</span>", \
		"<span class='userdanger'>[user] начинает формировать оковы из тёмной магии вокруг ваших запястий!</span>")
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				C.handcuffed = new /obj/item/restraints/handcuffs/energy/cult/used(C)
				C.update_handcuffed()
				C.Silence(12 SECONDS)
				to_chat(user, "<span class='notice'>Вы заковываете [C].</span>")
				add_attack_logs(user, C, "shackled")
				uses--
			else
				to_chat(user, "<span class='warning'>[C] уже закован.</span>")
		else
			to_chat(user, "<span class='warning'>Вам не удалось заковать[C].</span>")
	else
		to_chat(user, "<span class='warning'>[C] уже закован.</span>")


/obj/item/restraints/handcuffs/energy/cult //For the shackling spell
	name = "Теневые Оковы"
	desc = "Оковы, связывающие ваши запястия при помощи зловещей магии."
	trashtype = /obj/item/restraints/handcuffs/energy/used
	flags = DROPDEL

/obj/item/restraints/handcuffs/energy/cult/used/dropped(mob/user)
	user.visible_message("<span class='danger'>Оковы [user] рассыпаются от разряда тёмной магии!</span>", \
	"<span class='userdanger'>Ваши [name] рассыпаются от разряда тёмной магии!</span>")
	. = ..()


//Construction: Converts 50 metal to a construct shell, plasteel to runed metal, or an airlock to brittle runed airlock
/obj/item/melee/blood_magic/construction
	name = "Искажённая аура"
	desc = "Искажает определённые металлические объекты при касании."
	invocation = "Ethra p'ni dedol!"
	color = "#000000" // black
	var/channeling = FALSE

/obj/item/melee/blood_magic/construction/examine(mob/user)
	. = ..()
	. += {"<u>Зловещее заклинание позволяет превратить:</u>\n
	Пласталь в рунический метал\n
	[METAL_TO_CONSTRUCT_SHELL_CONVERSION] метала в оболочку конструкта\n
	Шлюзы в рунический вариант после небольшой задержки (интент харм)"}

/obj/item/melee/blood_magic/construction/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(user.holy_check())
		return
	if(proximity_flag)
		if(channeling)
			to_chat(user, "<span class='cultitalic'>Вы уже вызываете искажённое строительство!</span>")
			return
		var/turf/T = get_turf(target)

		//Metal to construct shell
		if(istype(target, /obj/item/stack/sheet/metal))
			var/obj/item/stack/sheet/candidate = target
			if(candidate.use(METAL_TO_CONSTRUCT_SHELL_CONVERSION))
				uses--
				to_chat(user, "<span class='warning'>Тёмное облако исходит из вашей руки и вихрится вокруг металла, превращая его в оболочку конструкта!</span>")
				new /obj/structure/constructshell(T)
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))
			else
				to_chat(user, "<span class='warning'>Необходимо [METAL_TO_CONSTRUCT_SHELL_CONVERSION] металла для производства оболочки конструкта!</span>")
				return

		//Plasteel to runed metal
		else if(istype(target, /obj/item/stack/sheet/plasteel))
			var/obj/item/stack/sheet/plasteel/candidate = target
			var/quantity = candidate.amount
			if(candidate.use(quantity))
				uses--
				new /obj/item/stack/sheet/runed_metal(T, quantity)
				to_chat(user, "<span class='warning'>Тёмное облако исходит из вашей руки и вихрится вокруг пластали, превращая его в рунический метал!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))

		//Airlock to cult airlock
		else if(istype(target, /obj/machinery/door/airlock) && !istype(target, /obj/machinery/door/airlock/cult))
			channeling = TRUE
			playsound(T, 'sound/machines/airlockforced.ogg', 50, TRUE, SOUND_RANGE_SET(7))
			do_sparks(5, TRUE, target)
			if(do_after(user, 50, target = target))
				target.narsie_act(TRUE)
				uses--
				user.visible_message("<span class='warning'>Чёрные полосы исходят из руки [user] и цепляются за шлюз, искажая и трансформируя его!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(7))
				channeling = FALSE
			else
				channeling = FALSE
				return
		else
			to_chat(user, "<span class='warning'>Заклинание не сработает на [target]!</span>")
			return
		..()

//Armor: Gives the target a basic cultist combat loadout
/obj/item/melee/blood_magic/armor
	name = "Аура снаряжения"
	desc = "Экипирует культиста с боевым снаряжением культа при касании."
	color = "#33cc33" // green

/obj/item/melee/blood_magic/armor/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	if(iscarbon(target) && proximity)
		uses--
		var/mob/living/carbon/C = target
		var/armour = C.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/cultrobes/alt(user), SLOT_HUD_OUTER_SUIT)
		C.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(user), SLOT_HUD_JUMPSUIT)
		C.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), SLOT_HUD_BACK)
		C.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), SLOT_HUD_SHOES)

		if(C == user)
			qdel(src) //Clears the hands
		C.put_in_hands(new /obj/item/melee/cultblade(user))
		C.put_in_hands(new /obj/item/restraints/legcuffs/bola/cult(user))
		C.visible_message("<span class='warning'>Чужеродная [armour ? "броня" : "снаряжения"] suddenly appears on [C]!</span>")
		..()
//Used by blood rite, to recharge things like viel shifter or the cultest shielded robes
/obj/item/melee/blood_magic/empower
	name = "Кровавая перезарядка"
	desc = "Может быть использована для восстановления прежнего состояния брони и оружия."
	invocation = "Ditans Gut'ura Inpulsa!"
	color = "#9c0651"
	has_source = FALSE //special, only availible for a blood cost.

/obj/item/melee/blood_magic/empower/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(user.holy_check())
		return
	if(proximity_flag)

		// Shielded suit
		if(istype(target, /obj/item/clothing/suit/hooded/cultrobes/cult_shield))
			var/obj/item/clothing/suit/hooded/cultrobes/cult_shield/C = target
			if(C.current_charges < 3)
				uses--
				to_chat(user, "<span class='warning'>Вы усиливаете [target] кровью, перезаряжая их щиты!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(7))
				C.current_charges = 3
				C.shield_state = "shield-cult"
				user.update_inv_wear_suit() // The only way a suit can be clicked on is if its on the floor, in the users bag, or on the user, so we will play it safe if it is on the user.
			else
				to_chat(user, "<span class='warning'>[target] уже полностью заряжен!</span>")
				return

		// Veil Shifter
		else if(istype(target, /obj/item/cult_shift))
			var/obj/item/cult_shift/S = target
			if(S.uses < 4)
				uses--
				to_chat(user, "<span class='warning'>You empower [target] with blood, recharging its ability to shift!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(7))
				S.uses = 4
				S.icon_state = "shifter"
			else
				to_chat(user, "<span class='warning'>[target] is already at full charge!</span>")
				return
		else
			to_chat(user, "<span class='warning'>The spell will not work on [target]!</span>")
			return
		..()

//Blood Rite: Absorb blood to heal cult members or summon weapons
/obj/item/melee/blood_magic/manipulator
	name = "Аура Кровавого Обряда"
	desc = "Поглощайте кровь со всего, чего вы коснётесь. Прикасания к культистам и конструктам лечит их. Используйте в руке для продвинутых обрядов."
	color = "#7D1717"

/obj/item/melee/blood_magic/manipulator/examine(mob/user)
	. = ..()
	. += "Кровавое копьё и кровавый шквал стоит [BLOOD_SPEAR_COST] и [BLOOD_BARRAGE_COST] зарядов соотвестствено."
	. += "Blood orb and blood empower cost [BLOOD_ORB_COST] и [BLOOD_RECHARGE_COST] зарядов соответственно."
	. += "<span class='cultitalic'>Вы собрали [uses] заряд(-ов) крови.</span>"

/obj/item/melee/blood_magic/manipulator/proc/restore_blood(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(uses == 0)
		return
	if(!H.dna || (NO_BLOOD in H.dna.species.species_traits) || !isnull(H.dna.species.exotic_blood))
		return
	if(H.blood_volume >= BLOOD_VOLUME_SAFE)
		return
	var/restore_blood = BLOOD_VOLUME_SAFE - H.blood_volume
	if(uses * 2 < restore_blood)
		H.blood_volume += uses * 2
		to_chat(user, "<span class='danger'>Вы используете последние заряды крови для восстановления, и заклинание расстворяется!</span>")
		uses = 0
	else
		H.blood_volume = BLOOD_VOLUME_SAFE
		uses -= round(restore_blood / 2)
		to_chat(user, "<span class='cult'>Your blood rites have restored [H == user ? "your" : "[H.p_their()]"] blood to safe levels!</span>")

/obj/item/melee/blood_magic/manipulator/proc/heal_human_damage(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(uses == 0)
		return
	var/overall_damage = H.getBruteLoss() + H.getFireLoss() + H.getToxLoss() + H.getOxyLoss()
	if(overall_damage == 0)
		to_chat(user, "<span class='warning'>[H] doesn't require healing!</span>")
		return

	var/ratio = uses / overall_damage
	if(H == user)
		to_chat(user, "<span class='warning'>Your blood healing is far less efficient when used on yourself!</span>")
		ratio *= 0.35 // Healing is half as effective if you can't perform a full heal
		uses -= round(overall_damage) // Healing is 65% more "expensive" even if you can still perform the full heal
	if(ratio > 1)
		ratio = 1
		uses -= round(overall_damage)
		H.visible_message("<span class='warning'>[H] is fully healed by [H == user ? "[H.p_their()]" : "[H]'s"] blood magic!</span>",
			"<span class='cultitalic'>You are fully healed by [H == user ? "your" : "[user]'s"] blood magic!</span>")
	else
		H.visible_message("<span class='warning'>[H] is partially healed by [H == user ? "[H.p_their()]" : "[H]'s"] blood magic.</span>",
			"<span class='cultitalic'>You are partially healed by [H == user ? "your" : "[user]'s"] blood magic.</span>")
		uses = 0
	ratio *= -1
	H.adjustOxyLoss((overall_damage * ratio) * (H.getOxyLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustToxLoss((overall_damage * ratio) * (H.getToxLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustFireLoss((overall_damage * ratio) * (H.getFireLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustBruteLoss((overall_damage * ratio) * (H.getBruteLoss() / overall_damage), FALSE, null, TRUE)
	H.updatehealth()
	playsound(get_turf(H), 'sound/magic/staff_healing.ogg', 25, extrarange = SOUND_RANGE_SET(7))
	new /obj/effect/temp_visual/cult/sparks(get_turf(H))
	user.Beam(H, icon_state="sendbeam", time = 15)

/obj/item/melee/blood_magic/manipulator/proc/heal_cultist(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(H.stat == DEAD)
		to_chat(user, "<span class='warning'>Only a revive rune can bring back the dead!</span>")
		return
	var/charge_loss = uses
	restore_blood(user, H)
	heal_human_damage(user, H)
	charge_loss = charge_loss - uses
	if(!uses)
		to_chat(user, "<span class='danger'>You use the last of your charges to heal [H == user ? "yourself" : "[H]"], and the spell dissipates!</span>")
	else
		to_chat(user, "<span class='cultitalic'>You use [charge_loss] charge\s, and have [uses] remaining.</span>")

/obj/item/melee/blood_magic/manipulator/proc/heal_construct(mob/living/carbon/human/user, mob/living/simple_animal/M)
	if(uses == 0)
		return
	var/missing = M.maxHealth - M.health
	if(!missing)
		to_chat(user, "<span class='warning'>[M] doesn't require healing!</span>")
		return
	if(uses > missing)
		M.adjustHealth(-missing)
		M.visible_message("<span class='warning'>[M] is fully healed by [user]'s blood magic!</span>",
			"<span class='cultitalic'>You are fully healed by [user]'s blood magic!</span>")
		uses -= missing
	else
		M.adjustHealth(-uses)
		M.visible_message("<span class='warning'>[M] is partially healed by [user]'s blood magic!</span>",
			"<span class='cultitalic'>You are partially healed by [user]'s blood magic.</span>")
		uses = 0
	playsound(get_turf(M), 'sound/magic/staff_healing.ogg', 25, extrarange = SOUND_RANGE_SET(7))
	user.Beam(M, icon_state = "sendbeam", time = 10)

/obj/item/melee/blood_magic/manipulator/proc/steal_blood(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(H.stat == DEAD)
		to_chat(user, "<span class='warning'>[H.p_their(TRUE)] blood has stopped flowing, you'll have to find another way to extract it.</span>")
		return
	if(H.AmountCultSlurring())
		to_chat(user, "<span class='danger'>[H.p_their(TRUE)] blood has been tainted by an even stronger form of blood magic, it's no use to us like this!</span>")
		return
	if(!H.dna || (NO_BLOOD in H.dna.species.species_traits) || H.dna.species.exotic_blood != null)
		to_chat(user, "<span class='warning'>[H] does not have any usable blood!</span>")
		return
	if(H.blood_volume <= BLOOD_VOLUME_SAFE)
		to_chat(user, "<span class='warning'>[H] is missing too much blood - you cannot drain [H.p_them()] further!</span>")
		return
	H.blood_volume -= 100
	uses += 50
	user.Beam(H, icon_state = "drainbeam", time = 10)
	playsound(get_turf(H), 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
	H.visible_message("<span class='danger'>[user] has drained some of [H]'s blood!</span>",
					"<span class='userdanger'>[user] has drained some of your blood!</span>")
	to_chat(user, "<span class='cultitalic'>Your blood rite gains 50 charges from draining [H]'s blood.</span>")
	new /obj/effect/temp_visual/cult/sparks(get_turf(H))

// This should really be split into multiple procs
/obj/item/melee/blood_magic/manipulator/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(user.holy_check())
		return
	if(!proximity)
		return ..()
	if(ishuman(target))
		if(iscultist(target))
			heal_cultist(user, target)
			target.clean_blood()
		else
			steal_blood(user, target)
		return

	if(isconstruct(target))
		heal_construct(user, target)
		return

	if(istype(target, /obj/item/blood_orb))
		var/obj/item/blood_orb/candidate = target
		if(candidate.blood)
			uses += candidate.blood
			to_chat(user, "<span class='warning'>You obtain [candidate.blood] blood from the orb of blood!</span>")
			playsound(user, 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
			qdel(candidate)
			return
	blood_draw(target, user)

/obj/item/melee/blood_magic/manipulator/proc/blood_draw(atom/target, mob/living/carbon/human/user)
	var/temp = 0
	var/turf/T = get_turf(target)
	if(!T)
		return
	for(var/obj/effect/decal/cleanable/blood/B in range(T, 2))
		if(B.blood_state == BLOOD_STATE_HUMAN && (B.can_bloodcrawl_in()))
			if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent cheese with footprint spam
				temp += 30
			else
				temp += max((B.bloodiness ** 2) / 800, 1)
		new /obj/effect/temp_visual/cult/turf/open/floor(get_turf(B))
		qdel(B)
	for(var/obj/effect/decal/cleanable/trail_holder/TH in range(T, 2))
		new /obj/effect/temp_visual/cult/turf/open/floor(get_turf(TH))
		qdel(TH)
	if(temp)
		user.Beam(T, icon_state = "drainbeam", time = 15)
		new /obj/effect/temp_visual/cult/sparks(get_turf(user))
		playsound(T, 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
		temp = round(temp)
		to_chat(user, "<span class='cultitalic'>Your blood rite has gained [temp] charge\s from blood sources around you!</span>")
		uses += max(1, temp)

/obj/item/melee/blood_magic/manipulator/attack_self(mob/living/user)
	if(user.holy_check())
		return
	var/list/options = list("Blood Orb (50)" = image(icon = 'icons/obj/cult.dmi', icon_state = "summoning_orb"),
							"Blood Recharge (75)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "blood_charge"),
							"Blood Spear (150)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "bloodspear"),
							"Blood Bolt Barrage (300)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "blood_barrage"))
	var/choice = show_radial_menu(user, src, options)

	switch(choice)
		if("Blood Orb (50)")
			if(uses < BLOOD_ORB_COST)
				to_chat(user, "<span class='warning'>You need [BLOOD_ORB_COST] charges to perform this rite.</span>")
			else
				var/ammount = input("How much blood would you like to transfer? You have [uses] blood.", "How much blood?", 50) as null|num
				if(ammount < 50) // No 1 blood orbs, 50 or more.
					to_chat(user, "<span class='warning'>You need to give up at least 50 blood.</span>")
					return
				if(ammount > uses) // No free blood either
					to_chat(user, "<span class='warning'>You do not have that much blood to give!</span>")
					return
				uses -= ammount
				var/turf/T = get_turf(user)
				qdel(src)
				var/obj/item/blood_orb/rite = new(T)
				rite.blood = ammount
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>A [rite.name] appears in your hand!</span>")
				else
					user.visible_message("<span class='warning'>A [rite.name] appears at [user]'s feet!</span>",
					"<span class='cult'>A [rite.name] materializes at your feet.</span>")

		if("Blood Recharge (75)")
			if(uses < BLOOD_RECHARGE_COST)
				to_chat(user, "<span class='cultitalic'>You need [BLOOD_RECHARGE_COST] charges to perform this rite.</span>")
			else
				var/obj/rite = new /obj/item/melee/blood_magic/empower()
				uses -= BLOOD_RECHARGE_COST
				qdel(src)
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>Your hand glows with power!</span>")
				else
					to_chat(user, "<span class='warning'>You need a free hand for this rite!</span>")
					uses += BLOOD_RECHARGE_COST // Refund the charges
					qdel(rite)

		if("Blood Spear (150)")
			if(uses < BLOOD_SPEAR_COST)
				to_chat(user, "<span class='warning'>You need [BLOOD_SPEAR_COST] charges to perform this rite.</span>")
			else
				uses -= BLOOD_SPEAR_COST
				var/turf/T = get_turf(user)
				qdel(src)
				var/datum/action/innate/cult/spear/S = new(user)
				var/obj/item/cult_spear/rite = new(T)
				S.Grant(user, rite)
				rite.spear_act = S
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>A [rite.name] appears in your hand!</span>")
				else
					user.visible_message("<span class='warning'>A [rite.name] appears at [user]'s feet!</span>",
					"<span class='cult'>A [rite.name] materializes at your feet.</span>")

		if("Blood Bolt Barrage (300)")
			if(uses < BLOOD_BARRAGE_COST)
				to_chat(user, "<span class='cultitalic'>You need [BLOOD_BARRAGE_COST] charges to perform this rite.</span>")
			else
				var/obj/rite = new /obj/item/gun/projectile/shotgun/boltaction/enchanted/arcane_barrage/blood()
				uses -= BLOOD_BARRAGE_COST
				qdel(src)
				user.swap_hand()
				user.drop_item()
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>Both of your hands glow with power!</span>")
				else
					to_chat(user, "<span class='warning'>You need a free hand for this rite!</span>")
					uses += BLOOD_BARRAGE_COST // Refund the charges
					qdel(rite)
