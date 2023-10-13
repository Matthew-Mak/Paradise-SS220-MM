#define CREDIT_ROLL_SPEED 185
#define CREDIT_SPAWN_SPEED 20
#define CREDIT_ANIMATE_HEIGHT (14 * world.icon_size)
#define CREDIT_EASE_DURATION 22

GLOBAL_LIST(end_titles)

/client/var/list/credits

/client/proc/RollCredits()
	set waitfor = FALSE

	LAZYINITLIST(credits)

	if(!GLOB.end_titles)
		GLOB.end_titles = generate_titles()

	if(mob)
		mob.overlay_fullscreen("black",/obj/screen/fullscreen/black)

		if(prefs.sound & SOUND_LOBBY)
			SEND_SOUND(src, sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85 * prefs.get_channel_volume(CHANNEL_LOBBYMUSIC), channel = CHANNEL_LOBBYMUSIC))
	sleep(50)
	var/list/_credits = credits
	verbs += /client/proc/ClearCredits
	for(var/I in GLOB.end_titles)
		if(!credits)
			return
		var/obj/screen/credit/T = new(null, I, src)
		_credits += T
		T.rollem()
		sleep(CREDIT_SPAWN_SPEED)
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)

	ClearCredits()
	verbs -= /client/proc/ClearCredits

/client/proc/ClearCredits()
	set name = "Stop End Titles"
	set category = "OOC"
	verbs -= /client/proc/ClearCredits
	QDEL_NULL(credits)
	mob.clear_fullscreen("black")
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, volume = 85 * prefs.get_channel_volume(CHANNEL_LOBBYMUSIC), channel = CHANNEL_LOBBYMUSIC))


/obj/screen/fullscreen/black
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "black"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = ABOVE_HUD_LAYER


/obj/screen/credit
	icon_state = "blank"
	mouse_opacity = 0
	alpha = 0
	screen_loc = "CENTER-7,CENTER-7"
	plane = HUD_PLANE
	layer = HUD_LAYER
	var/client/parent
	var/matrix/target

/obj/screen/credit/Initialize(mapload, credited, client/P)
	. = ..()
	parent = P
	maptext = {"<div style="font:'Small Fonts'">[credited]</div>"}
	maptext_height = world.icon_size * 2
	maptext_width = world.icon_size * 14

/obj/screen/credit/proc/rollem()
	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	target = M
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	spawn(CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION)
		if(!QDELETED(src))
			animate(src, alpha = 0, transform = target, time = CREDIT_EASE_DURATION)
			sleep(CREDIT_EASE_DURATION)
			qdel(src)
	parent.screen += src

/obj/screen/credit/Destroy()
	if(parent)
		parent.screen -= src
		LAZYREMOVE(parent.credits, src)
		parent = null
	return ..()

/proc/generate_titles()
	RETURN_TYPE(/list)
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/list/possible_titles = list()
	var/chunksize = 0
		/* Establish a big-ass list of potential titles for the "episode". */
	possible_titles += "[pick("ПАДЕНИЕ", "ВОСТАНИЕ", "ПРОБЛЕМЫ", "ПОСЛЕДНЯЯ БИТВА", "ТЕМНАЯ СТОРОНА", "ОПУСТОШЕНИЕ", "УНИЧТОЖЕНИЕ", "КРИЗИС")]\
						[pick("КОСМОНАВТОВ", "ЧЕЛОВЕЧЕСТВА", "ДОСТОИНСТВА", "РАЗУМА", "ШИМПАНЗЕ", "ТОРГОВЫХ АВТОМАТОВ",\
						"КРИСТАЛА СУПЕРМАТЕРИИ", "МЕДБЕЯ", "ИНЖЕНЕРНОГО ОТДЕЛА", "СЛУЖБЫ БЕЗОПАСНОТИ", "ОТДЕЛА ИССЛЕДОВАНИЯ", "ДЕПАРТАМЕНТА СЕРВИСА", "КОМАНДНОГО ОТДЕЛА", "ИССЛЕДОВАТЕЛЕЙ")]"
	possible_titles += "ЭКИПАЖ УЗНАЕТ О [pick("ЛЮБВИ", "НАРКОТИКАХ", "ОПАСНОСТИ УХОДА ОТ НАЛОГОВ", "ЧУВСТВИТЕЛЬНОСТИ КСЕНОСОВ", "МОШЕННИКАХ", "КРУТЕНИИ", "ЗАЩИТЕ ОТ РАДИЦИИ", "САКРАЛЬНОЙ ГЕОМЕТРИИ", "ТЕОРИИ СТРУН", "АБСТРАКТНОЙ МАТЕМАТИКЕ", "БРАЧНЫХ РИТУАЛАХ [pick("УНАТХОВ", "СКРЕЛЛОВ", "ДИОН", "ВУЛЬП", "ВОКСОВ", "БИПСКИ")]", "СИЛЕ ЗЕМЛИ")]"
	possible_titles += "[pick("ПУШКИ! ПОВСЮДУ ПУШКИ!", "МАЛЕНЬКИЙ ВОКСИК", "ЧТО ПРОИСХОДИТ КОГДА БОХ ПОПАДАЕТ В ДРУГОЙ БОХ", "БЕЙ! БЕЙ! БЕЙ!", "СЕКС БОМБА", "ЛЕГЕНДА О ДРЕВНЕМ АРТЕФАКТЕ: ЧАСТЬ [pick("I","II","III","IV","V","VI","VII","VIII","IX", "X", "C","M","L")]")]"
	possible_titles += "[pick("КОСМИЧЕСКОЕ", "СЕКСУАЛЬНОЕ", "ДРАКОНЬЕ", "КОЛДУНСКОЕ", "ПРАЧЕЧНОЕ", "ОРУЖЕЙНОЕ", "РЕКЛАМИРУЮЩЕЕ", "СОБАЧЬЕ", "УГАРНОЕ", "ЧАРОДЕЙСКОЕ", "ПОЛИТИЧЕСКОЕ")] [pick("ЗАДАНИЕ", "ПРЕДЛОЖЕНИЕ", "ПРИКЛЮЧЕНИЕ")]"
	possible_titles += "[pick("ПОВОРОТ НЕ ТУДА", "ОХОТА ЗА ЗЕЛЕНОЙ \"КОЛБАСКОЙ\"", "ЧУЖОЙ ПРОТИВ ТОРГОВОГО АВТОМАТА", "КОСМИЧЕСКИЕ ДАЛЬНОБОЙЩИКИ")]"
	titles += "<center><h1>EPISODE [GLOB.round_id]<br>[pick(possible_titles)]<h1></h1></h1></center>"

	for(var/mob/living/carbon/human/human in GLOB.alive_mob_list | GLOB.dead_mob_list)
		if(findtext(human.real_name,"(mannequin)"))
			continue
		if(ismonkeybasic(human))
			continue
		if(human.last_known_ckey == null)
			continue
		if(!length(cast) && !chunksize)
			chunk += "В съемках участвовали:"
		chunk += "[human.real_name] в роли [uppertext(human.job)]"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(length(chunk))
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	titles += cast

	var/list/corpses = list()

	for(var/mob/living/carbon/human/human in GLOB.dead_mob_list)
		if(human.last_known_ckey == null)
			continue
		else if(human.real_name)
			corpses += human.real_name

	if(length(corpses))
		titles += "<center>Основано на реальных событиях<br>В память о [english_list(corpses)].</center>"

	var/list/staff = list("Съемочная группа:")
	var/list/staffjobs = list("Носильщик кофе", "Оператор", "Надоедливый крикун", "Ответсвенный за лопату", "Хореограф", "Исторический консультант", "Дизайнер костюмов", "Главный редактор", "Исполнительный директор")
	var/list/goodboys = list()
	for(var/client/client)
		if(!client.holder)
			continue

		if(client.holder.rights & (R_DEBUG|R_ADMIN|R_MOD))
			staff += "[uppertext(pick(staffjobs))] - '[client.key]'"
		else if(client.holder.rights & R_MENTOR)
			goodboys += "[client.key]"

	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(length(goodboys))
		titles += "<center>Мальчики на побегушках:<br>[english_list(goodboys)]</center><br>"

	var/disclaimer = "<br>Sponsored by SS220.<br>All rights reserved.<br>\
					 This motion picture is protected under the copyright laws of the Sol Central Government<br> and other nations throughout the galaxy.<br>\
					 Colony of First Publication: [pick("Mars", "Luna", "Earth", "Venus", "Phobos", "Ceres", "Tiamat", "Ceti Epsilon", "Eos", "Pluto", "Ouere",\
					 "Tadmor", "Brahe", "Pirx", "Iolaus", "Saffar", "Gaia")].<br>"
	disclaimer += pick("Use for parody prohibited. PROHIBITED.",
					   "All stunts were performed by underpaid interns. Do NOT try at home.",
					   "SS220 does not endorse behaviour depicted. Attempt at your own risk.",
					   "Any unauthorized exhibition, distribution, or copying of this film or any part thereof (including soundtrack)<br>\
						may result in an ERT being called to storm your home and take it back by force.",
						"The story, all names, characters, and incidents portrayed in this production are fictitious. No identification with actual<br>\
						persons (living or deceased), places, buildings, and products is intended or should be inferred.<br>\
						This film is based on a true story and all individuals depicted are based on real people, despite what we just said.",
						"No person or entity associated	with this film received payment or anything of value, or entered into any agreement, in connection<br>\
						with the depiction of tobacco products, despite the copious amounts	of smoking depicted within.<br>\
						(This disclaimer sponsored by Carcinoma - Carcinogens are our Business!(TM)).",
						"No animals were harmed in the making of this motion picture except for those listed previously as dead. Do not try this at home.")
	titles += "<hr>"
	titles += "<center><span style='font-size:6pt;'>[jointext(disclaimer, null)]</span></center>"

	return titles
