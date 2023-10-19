/datum/cinematic/credits
	is_global = TRUE
	should_lock_watchers = FALSE
	backdrop_type = /obj/screen/fullscreen/cinematic_backdrop/credits

/datum/cinematic/credits/New(watcher, datum/callback/special_callback)
	. = ..()
	screen = new/obj/screen/cinematic/credits(src)

/datum/cinematic/credits/start_cinematic(list/watchers)
	if(!(SEND_GLOBAL_SIGNAL(COMSIG_GLOB_PLAY_CINEMATIC, src) & COMPONENT_GLOB_BLOCK_CINEMATIC))
		. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CINEMATIC_STOPPED_PLAYING, PROC_REF(queue_gone))
	for(var/mob/watching_mob in watchers)
		if(watching_mob.client)
			watching += watching_mob

/datum/cinematic/credits/proc/queue_gone(datum/source, datum/cinematic/other)
	SIGNAL_HANDLER
	UnregisterSignal(SSdcs, COMSIG_GLOB_CINEMATIC_STOPPED_PLAYING)
	start_cinematic(src.watching)

/datum/cinematic/credits/play_cinematic()

	SScredits.roll_credits_for_clients(watching)
	play_cinematic_sound(sound(SScredits.end_titles.soundtrack, volume = 20))

	cleanup_time = SScredits.end_titles.playing_time + 3 SECONDS

	special_callback?.Invoke()

/datum/cinematic/credits/stop_cinematic()
	for(var/client/client in watching)
		SScredits.clear_credits(client)

	UnregisterSignal(SSdcs, COMSIG_GLOB_CINEMATIC_STOPPED_PLAYING)

	. = ..()

/datum/cinematic/credits/remove_watcher(client/no_longer_watching)
	. = ..()

	SScredits.clear_credits(no_longer_watching)

/obj/screen/cinematic/credits
	icon_state = "blank"

/obj/screen/fullscreen/cinematic_backdrop/credits
	alpha = 0

/obj/screen/fullscreen/cinematic_backdrop/credits/Initialize(mapload)
	. = ..()

	animate(src, alpha = 220, time = 3 SECONDS)
