/datum/credits/halloween

/datum/credits/halloween/New()
	. = ..()
	soundtrack = 'config/credits/sounds/Twin Musicom - Spooky Ride.mp3'

/datum/credits/halloween/fill_credits()
	credits += new /datum/credit/episode_title/halloween()
	credits += new /datum/credit/streamers()
	credits += new /datum/credit/donators/halloween()
	credits += new /datum/credit/crewlist/halloween()
	credits += new /datum/credit/corpses/halloween()
	credits += new /datum/credit/staff/halloween()
	credits += new /datum/credit/disclaimer()

/datum/credits/halloween/setup_credits_for_client(client/client)
	LAZYINITLIST(client.credits)

	var/obj/screen/credit/logo = new /obj/screen/credit/halloween(null, "", client)
	client.credits += logo

/datum/credits/halloween/start_rolling_logo_for_clients(list/clients)
	for(var/client/client in clients)
		if(!client?.credits)
			continue

		var/obj/screen/credit/logo/logo = client.credits[1]
		logo.rollem()

/datum/credit/episode_title/halloween

/datum/credit/episode_title/halloween/New()
	var/episode_title = ""

	var/list/titles = list()

	titles["halloween"] = file2list("config/credits/titles/halloween_titles.txt")

	for(var/possible_titles in titles)
		LAZYREMOVEASSOC(titles, possible_titles, "")

	episode_title = pick(titles["halloween"])

	content += "<center><h1>🎃EPISODE [GLOB.round_id]🎃<br><h1>[episode_title]</h1></h1></center>"

/datum/credit/donators/halloween

/datum/credit/donators/halloween/New()
	var/list/donators = list()
	var/list/chunk = list()

	var/chunksize = 0

	for(var/client/client in GLOB.clients)
		if(!client.donator_level)
			continue
		if(client.holder)
			continue
		if(!length(donators))
			donators += "<hr>"
			donators += "<center><h1>Огромная благодарность меценатам:</h1></center>"

		chunk += "Лепрекону - [client.ckey] за [client.donator_level]-ый уровень подписки"
		chunksize++

		if(chunksize > 2)
			donators += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		donators += "<center>[jointext(chunk,"<br>")]</center>"

	content += donators


/datum/credit/crewlist/halloween

/datum/credit/crewlist/halloween/New()
	var/list/cast = list()
	var/list/chunk = list()
	var/chunksize = 0

	for(var/mob/living/carbon/human/human in GLOB.alive_mob_list | GLOB.dead_mob_list)
		if(findtext(human.real_name,"(mannequin)"))
			continue
		if(ismonkeybasic(human))
			continue
		if(!human.last_known_ckey)
			continue
		if(!human.mind?.assigned_role)
			continue

		if(!length(cast) && !chunksize)
			cast += "<hr>"
			cast += "<center><h1>Актерская труппа:</h1></center>"
		chunk += "[human.real_name] в роли [uppertext(human.mind.assigned_role)]"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	content += cast

/datum/credit/corpses/halloween/New()
	var/list/corpses = list()

	for(var/mob/living/carbon/human/human in GLOB.dead_mob_list)
		if(!human.last_known_ckey)
			continue
		else if(human.real_name)
			corpses += human.real_name

	if(length(corpses))
		content += "<hr>"
		content += "<center><h1>Трупы:<br></h1></center>"
		while(length(corpses) > 10)
			content += "<center>[jointext(corpses, ", ", 1, 10)],</center>"
			corpses.Cut(1, 10)

		if(length(corpses))
			content += "<center>[jointext(corpses, ", ")].</center>"

/datum/credit/staff/halloween

/datum/credit/staff/halloween/New()
	var/list/staff = list()
	var/list/chunk = list()
	var/list/goodboys = list()
	var/list/staffjobs = file2list("config/credits/jobs/halloweenstaffjobs.txt")

	staffjobs.Remove("")

	var/chunksize = 0

	for(var/client/client in GLOB.clients)
		if(!client.holder)
			continue
		if(!length(staff))
			staff += "<hr>"
			staff += "<center><h1>Живые трупы:</h1></center>"

		if(check_rights_client(R_DEBUG|R_ADMIN|R_MOD, FALSE, client))
			chunk += "[uppertext(pick(staffjobs))] - '[client.key]'"
			chunksize++
		else if(check_rights_client(R_MENTOR, FALSE, client))
			goodboys += "[client.key]"

		if(chunksize > 2)
			staff += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		staff += "<center>[jointext(chunk,"<br>")]</center>"

	content += staff

	if(length(goodboys))
		content += "<center><h1>Духи:<br></h1>[english_list(goodboys)]</center><br>"

/obj/screen/credit/halloween
	icon = 'modular_ss220/credits/icons/logo.dmi'
	icon_state = "halloween"
	screen_loc = "CENTER - 2,CENTER + 1"
	appearance_flags = NO_CLIENT_COLOR | TILE_BOUND | PIXEL_SCALE
	alpha = 255

/obj/screen/credit/halloween/Initialize(mapload, credited, client/client)
	. = ..()
	parent.screen += src
	plane++

	transform = transform.Scale(1.5)

	SpinAnimation(5 SECONDS, 1, 1, 20, TRUE)

	var/matrix/matrix = matrix(transform)
	transform = transform.Translate(-8 * world.icon_size, 0)
	animate(src, transform = matrix, time = 5 SECONDS, flags = ANIMATION_PARALLEL)

/obj/screen/credit/halloween/rollem()
	var/matrix/matrix = matrix(transform)
	matrix.Translate(0, SScredits.credit_animate_height)
	animate(src, transform = matrix, time = SScredits.credit_roll_speed)
	addtimer(CALLBACK(src, PROC_REF(delete_credit)), SScredits.credit_roll_speed, TIMER_CLIENT_TIME)
