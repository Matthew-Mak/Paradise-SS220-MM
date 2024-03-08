/obj/machinery/vox_trader
	name = "Расчичетчикик"
	desc = "Приемная и расчетная связная машина для ценностей. Проста также как еда воксов."
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "trader-idle-off"
	var/icon_state_on = "trader-idle"
	max_integrity = 5000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = FALSE

	var/cooldown = 3 SECONDS
	var/is_trading_now = FALSE

	var/list/connected_instruments = list()

	// Забавные взаимодействия
	var/angry_count = 0
	var/list/blacklist = list()

	// Данные для подсчета драгоценностей выполнения задачи.
	// Обновляются при первом взаимодействии если есть воксы-рейдеры.
	var/precious_collected_dict = list()
	var/all_values_sum = 0
	var/precious_value
	var/collected_access_list = list()
	var/collected_tech_dict = list()

	// ========= МНОЖИТЕЛИ =========

	// произведения за параметры
	var/tech_mult = 6
	var/weight_mult = 3
	var/force_mult = 5

	// делители за параметры
	var/armor_div = 10
	var/stack_div = 4
	var/temp_div = 5
	var/no_unique_tech_div = 4
	var/denomination_div = 5

	// дополнительные бонусы
	var/integrity_reward = 5
	var/electroprotect_reward = 50
	var/permeability_reward	= 20
	var/highrisk_reward = 500
	var/valuable_highrisk_reward = 1000
	var/value_access_reward = 100
	var/valuable_access_reward = 500
	var/unique_tech_level_reward = 300	// учитываем также множитель за технологии

	// дополнительные списки
	var/list/highrisk_list = list()
	var/list/valuable_highrisk_list = list(
		/obj/item/areaeditor/blueprints/ce,
		/obj/item/disk/nuclear,
		/obj/item/clothing/suit/armor/reactive,
		/obj/item/documents,
	)
	var/list/valuable_access_list = list()	// определяется при инициализации
	var/list/valuable_tech_list = list("bluespace", "syndicate", "combat", "abductor")

	// дополнительные суммы за ценности
	var/list/valuable_objects_dict = list(
		/obj/machinery/nuclearbomb = 5000,
		/obj/item/mod/core = 1000,
		/obj/item/mod = 300,
		)
	var/list/valuable_guns_dict = list(
		/obj/item/gun/energy/taser = 300,
		/obj/item/gun/energy/disabler = 100,
		/obj/item/gun/energy/lasercannon = 400,

		/obj/item/gun/energy/gun/blueshield = 300,
		/obj/item/gun/energy/gun/nuclear = 300,
		/obj/item/gun/energy/gun/advtaser = 500,
		/obj/item/gun/energy/gun = 150,

		/obj/item/gun/energy/pulse = 3000,
		/obj/item/gun/energy/ionrifle = 1000,
		/obj/item/gun/energy/decloner = 500,
		/obj/item/gun/energy/floragun = 500,
		/obj/item/gun/energy/meteorgun = 500,
		/obj/item/gun/energy/mindflayer = 500,
		/obj/item/gun/energy/wormhole_projector = 800,
		/obj/item/gun/energy/laser/instakill = 10000,
		/obj/item/gun/energy/clown = 100,
		/obj/item/gun/energy/plasmacutter/adv = 300,
		/obj/item/gun/energy/laser = 200,

		/obj/item/gun/magic/staff = 10000,
		/obj/item/gun/magic/wand = 5000,
		/obj/item/gun/magic = 2000,

		/obj/item/gun/projectile/automatic/toy = 10,
		/obj/item/gun/projectile/automatic/lasercarbine = 800,
		/obj/item/gun/projectile/automatic/laserrifle = 1000,
		/obj/item/gun/projectile/automatic/pistol = 300,
		/obj/item/gun/projectile/automatic/l6_saw = 3000,
		/obj/item/gun/projectile/automatic/sniper_rifle = 2000,
		/obj/item/gun/projectile/automatic = 500,
		/obj/item/gun/projectile = 300,

		/obj/item/gun/rocketlauncher = 1000,
		/obj/item/gun/medbeam = 2000,
		/obj/item/gun/throw/crossbow = 300,
		/obj/item/gun/syringe = 200,
		)
	// =============================

/obj/machinery/vox_trader/Initialize(mapload)
	. = ..()
	for(var/theft_type in subtypesof(/datum/theft_objective))
		highrisk_list += new theft_type
	valuable_access_list += get_region_accesses(REGION_COMMAND) + get_all_centcom_access() + get_all_syndicate_access() + get_all_misc_access()

/obj/machinery/vox_trader/attack_hand(mob/user)
	if(!try_trade(user))
		. = ..()

/obj/machinery/vox_trader/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/hand_valuer))
		var/obj/item/hand_valuer/valuer = I
		valuer.connect(user, src)

/obj/machinery/vox_trader/attack_ai(mob/user)
	return FALSE	// Ха-ха, глупая железяка не понимает как пользоваться технологиями ВОКСов!

/obj/machinery/vox_trader/proc/check_usable(mob/user)
	. = FALSE
	if(issilicon(user))
		return
	if(!isvox(user))
		to_chat(user, span_notice("Вы осматриваете [src] и не понимаете как оно работает и куда сувать свои пальцы..."))
		return
	if(is_trading_now)
		to_chat(user, span_warning("[src] обрабатываем и пересчитывает ценности. Ожидайте."))
		return
	if(length(blacklist) && (user in blacklist))
		to_chat(user, span_warning("Вы пытаетесь связаться с [src], но никто не отзывается."))
		return
	return TRUE

/obj/machinery/vox_trader/proc/sparks()
	do_sparks(5, 1, get_turf(src))

/obj/machinery/vox_trader/proc/try_trade(mob/user)
	if(!check_usable(user))
		return FALSE
	add_fingerprint(user)
	user.do_attack_animation(src)
	trade_start()
	addtimer(CALLBACK(src, PROC_REF(do_trade), user), cooldown)
	return TRUE

/obj/machinery/vox_trader/proc/do_trade(mob/user)
	var/turf/current_turf = get_turf(src)
	var/list/items_list = current_turf.GetAllContents(7)

	if(!length(items_list))
		trade_cancel()
		return

	INVOKE_ASYNC(src, PROC_REF(make_cash), user, items_list)

/obj/machinery/vox_trader/proc/make_cash(mob/user, list/items_list)
	if(!src || QDELETED(src))
		return

	var/values_sum = get_value(user, items_list)
	if(values_sum <= 10)
		if(values_sum <= 0)
			angry_count++
			switch(angry_count)
				if(3)
					atom_say(span_warning("Вами очень недовольны. Где товар?!"))
				if(4)
					atom_say(span_warning("Вами ОЧЕНЬ недовольны... Нам нужен реальный товар!"))
				if(5)
					atom_say(span_warning("Отправляй товар!"))
				if(6)
					atom_say(span_warning("Что ты щелкаешь как дятел?!"))
				if(7)
					atom_say(span_warning("Или ты будешь отправлять товар или не будешь больше отправлять ничего!"))
				if(8)
					atom_say(span_warning("Я не буду с тобой торговать пока ты не дашь товар!"))
				if(9)
					atom_say(span_warning("Ты шутки шутишь? Товар. Последнее предупреждение."))
				if(10)
					atom_say(span_warning("[user.name], [src] больше не будет с вами торговать!"))
					blacklist.Add(user)	// Докикикировался.
				else
					atom_say(span_warning("Вами недовольны. Где товар?"))
		else
			atom_say(span_notice("Расчет окончен. Средства отправлены на транспортные погашения."))
		trade_cancel()
		return
	if(values_sum > 100)
		all_values_sum += values_sum
		atom_say(span_greenannounce("Расчет окончен. [values_sum > 2000 ? "Крайне ценно!" : "Ценно!"] Ваша доля [values_sum]"))
	else
		atom_say(span_notice("Расчет окончен. Вы бы еще консервных банок насобирали! Ваша доля [values_sum]"))

	angry_count = 0
	trade_cancel()
	beam()
	new /obj/item/stack/vox_cash(get_turf(src), values_sum)

/obj/machinery/vox_trader/proc/trade_start()
	is_trading_now = TRUE
	icon_state = icon_state_on
	sparks()
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 25, 1)

/obj/machinery/vox_trader/proc/trade_cancel()
	is_trading_now = FALSE
	icon_state = initial(icon_state)
	sparks()

/obj/machinery/vox_trader/proc/beam()
	playsound(get_turf(src), 'sound/weapons/contractorbatonhit.ogg', 25, TRUE)
	flick("trader-beam", src)

/obj/machinery/vox_trader/proc/get_value(mob/user, list/items_list, is_visuale_only = FALSE)
	var/values_sum = 0
	var/values_sum_precious = 0 // считаем сумму без скидки, например для хайрисков и уникальных доступов. Оцень ценных вещей.
	var/accepted_access = list()

	// проверка для бонусной диалоговой строки
	var/is_weight = FALSE
	var/is_equip = FALSE
	var/is_tech = FALSE
	var/is_tech_valuable = FALSE
	var/is_tech_unique = FALSE
	var/is_access_unique = FALSE

	for(var/obj/I in items_list)
		if(I.anchored)
			continue

		if(isspacecash(I) || isvoxcash(I)) // воксам не нужны деньги мяса.
			continue

		var/temp_values_sum = 0
		var/temp_values_sum_precious = 0

		// целостность объекта
		if(I.obj_integrity > 0)
			temp_values_sum += round((I.obj_integrity / I.max_integrity) * integrity_reward)

		if(length(I.armor))
			var/temp_val = 0
			var/list/armor_list = I.armor.getList()
			for(var/param in armor_list)
				var/param_value = armor_list[param] == INFINITY ? 500 : armor_list[param]
				if(param_value == 0)
					continue
				var/div = 1
				if(param in list(FIRE, ACID))
					div = armor_div	// избегаем легких очков за часто встречаемые свойства.
				temp_val += div > 1 ? round(param_value / div) : temp_val
			if(temp_val)
				temp_values_sum += temp_val
				is_equip = TRUE

		if(I.force || I.throwforce)
			temp_values_sum += round((I.force + I.throwforce) * force_mult + (throw_speed * throw_range))

		if(istype(I, /obj/item/disk/tech_disk))
			var/obj/item/disk/tech_disk/disk = I
			var/datum/tech/tech = disk.stored
			if(tech)
				I.origin_tech = "[tech.id]=[tech.level]"

		if(I.origin_tech)
			var/list/tech_list = params2list(I.origin_tech)
			for(var/tech in tech_list)
				var/temp_mult = 1
				var/tech_value = text2num(tech_list[tech])
				if(tech in collected_tech_dict)
					if(collected_tech_dict[tech] < tech_value)
						temp_values_sum_precious += unique_tech_level_reward * (tech_value - collected_tech_dict[tech])
						if(!is_visuale_only)
							collected_tech_dict[tech] = tech_value
						is_tech_unique = TRUE
				else
					temp_values_sum_precious += unique_tech_level_reward * tech_value
					if(!is_visuale_only)
						collected_tech_dict += list("[tech]" = tech_value)
					is_tech_unique = TRUE
				if(tech in valuable_tech_list)
					temp_mult = tech_value
					is_tech_valuable = TRUE
				var/excess_mult = text2num(tech_value) > 7 ? 2 : 1	// переизбыток
				temp_values_sum += round(tech_value * temp_mult * excess_mult)
				is_tech = TRUE

		if(istype(I, /obj/item/stack))
			var/obj/item/stack/stack = I
			var/point_value = 1
			if(istype(I, /obj/item/stack/sheet))
				var/obj/item/stack/sheet/sheet = stack
				point_value += sheet.point_value
			temp_values_sum *= round(stack.amount / stack_div * point_value)

		if(istype(I, /obj/item/card/id))
			var/obj/item/card/id/id = I
			for(var/access in id.access)
				if(access in collected_access_list)
					continue
				if(access in valuable_access_list)
					temp_values_sum_precious += valuable_access_reward
					is_access_unique = TRUE
				else
					temp_values_sum_precious += value_access_reward
				accepted_access += access

		if(isitem(I))
			var/temp_value = 0
			var/obj/item/item = I
			temp_value += temp_values_sum / item.toolspeed
			if(item.max_heat_protection_temperature)
				temp_value += item.max_heat_protection_temperature / temp_div
			if(item.siemens_coefficient)
				temp_value += electroprotect_reward * (1 - item.siemens_coefficient)
			if(item.permeability_coefficient)
				temp_value += permeability_reward * (1 - item.permeability_coefficient)
			if(item.w_class)
				temp_value += item.w_class * weight_mult
				if(item.w_class >= WEIGHT_CLASS_BULKY)
					is_weight = TRUE
			temp_values_sum += round(temp_value)

		for(var/datum/theft_objective/objective in highrisk_list)
			if(!istype(I, objective.typepath))
				continue
			var/temp_value = highrisk_reward
			if(objective.special_equipment)
				temp_value *= 2
			if(objective.protected_jobs)
				for(var/job in objective.protected_jobs)
					switch(job)
						if("Captain", "Head Of Security")
							temp_value *= 2
						else
							temp_value *= 1.5
			temp_values_sum_precious += temp_value

			if(I in valuable_highrisk_list)
				temp_values_sum_precious += valuable_highrisk_reward

		for(var/valuable_type in valuable_objects_dict)
			if(!istype(I, valuable_type))
				continue
			temp_values_sum_precious += valuable_objects_dict[valuable_type]
			break

		if(istype(I, /obj/item/gun))
			for(var/valuable_type in valuable_guns_dict)
				if(!istype(I, valuable_type))
					continue
				temp_values_sum_precious += valuable_guns_dict[valuable_type]
				break

		temp_values_sum /= denomination_div	// деноминируем

		//Оцениваем драгоценность для задания
		if(!is_visuale_only)
			precious_grading(user, I, temp_values_sum + temp_values_sum_precious)

		// ____________________________
		// Завершаем рассчет
		values_sum += temp_values_sum
		values_sum_precious += temp_values_sum_precious

		if(!is_visuale_only && (temp_values_sum + temp_values_sum_precious) >= 0)
			qdel(I)

	var/addition_text = ""
	if(length(accepted_access))
		if(!is_visuale_only) // Заносим наши принятые доступы
			collected_access_list += accepted_access
		addition_text += span_boldnotice("\nОценка имеющихся доступов: \n")
		for(var/access in accepted_access)
			var/access_desc = get_access_desc(access)
			if(!access_desc)
				continue
			addition_text += span_notice("[access_desc]; ")
		if(is_access_unique)
			addition_text += span_good("\nИмеются ценные доступы. Очень ценно!")
	if(is_weight)
		addition_text += span_notice("\nТяжесть - значит надежность.")
	if(is_equip)
		addition_text += span_notice("\nХорошее снаряжение. Ценно.")
	if(is_tech)
		addition_text += span_notice("\nТехнологии - ценно!")
	if(is_tech_unique)
		addition_text += span_notice("\nНовые технологии! Очень ценно! Необходимо!")
	if(is_tech_valuable)
		addition_text += span_notice("\nЦенные технологии! Крайне ценно!")

	if(user && addition_text != "")
		to_chat(user, chat_box_notice(addition_text))

 	// Деноминируем кикиридиты и забираем небольшой процент в семью.
	values_sum -= values_sum % 10	// забираем процентик
	values_sum += values_sum_precious // Даем бонус за особые ценности
	return round(values_sum)

/obj/machinery/vox_trader/proc/precious_grading(mob/user, obj/O, value)
	if(!user)
		return
	if(!correct_precious_value(user))
		return
	update_precious_collected_dict(O.name, value)

/obj/machinery/vox_trader/proc/correct_precious_value(mob/user)
	if(precious_value)
		return TRUE
	if(!user)
		return FALSE
	var/list/objectives = user.mind?.get_all_objectives()
	if(!length(objectives))
		return FALSE
	var/datum/objective/raider_steal/objective = locate() in objectives
	precious_value = objective.precious_value
	return TRUE

/obj/machinery/vox_trader/proc/update_precious_collected_dict(object_name, object_value)
	if(!correct_precious_value())
		return
	if(object_value >= precious_value)
		var/precious_data = precious_collected_dict[object_name]
		if(!precious_data)
			precious_collected_dict[object_name] = list("count" = 1, "value" = object_value)
		else
			precious_data["count"]++
			precious_data["value"] = max(precious_data["value"], object_value)

/obj/machinery/vox_trader/proc/synchronize_traders_stats()
	for(var/obj/machinery/vox_trader/trader in GLOB.machines)
		if(trader == src)
			continue

		all_values_sum += trader.all_values_sum

		for(var/access in trader.collected_access_list)
			if(access in collected_access_list)
				continue
			collected_access_list += access

		for(var/tech in trader.collected_tech_dict)
			if(tech in collected_tech_dict)
				collected_tech_dict[tech][1] = max(collected_tech_dict[tech][1], trader.collected_tech_dict[tech][1])
				continue
			collected_tech_dict += tech

		for(var/dict in trader.precious_collected_dict)
			update_precious_collected_dict(trader.precious_collected_dict[dict], trader.precious_collected_dict[dict]["value"])
