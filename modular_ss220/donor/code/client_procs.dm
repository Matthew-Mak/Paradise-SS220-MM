#define MAX_SAVE_SLOTS_SS220 5


/datum/client_login_processor/donator_check/proc/CheckAutoDonatorLevel(client/C)
	if(C.holder)
		C.donator_level = 2
		return

	var/is_wl = GLOB.configuration.overflow.reroute_cap == 0.5 ? TRUE : FALSE

	var/datum/db_query/rank_ckey_read = SSdbcore.NewQuery(
		"SELECT admin_rank FROM [is_wl ? "admin" : "admin_wl"] WHERE ckey=:ckey",
			list("ckey" = C.ckey), disable_replace = is_wl)

	if(!rank_ckey_read.warn_execute())
		qdel(rank_ckey_read)
		return

	while(rank_ckey_read.NextRow())
		C.donator_level = 2

	qdel(rank_ckey_read)

/datum/client_login_processor/donator_check/process_result(datum/db_query/Q, client/C)
	if(IsGuestKey(C.ckey))
		return

	CheckAutoDonatorLevel(C)

	while(Q.NextRow())
		var/total = Q.item[1]
		var/donator_level = 0
		switch(total)
			if(220 to 439)
				donator_level = 1
			if(440 to 999)
				donator_level = 2
			if(1000 to 2219)
				donator_level = 3
			if(2220 to 9999)
				donator_level = 4
			if(10000 to INFINITY)
				donator_level = DONATOR_LEVEL_MAX

		C.donator_level = max(donator_level, C.donator_level)


	C.donor_loadout_points()
	C.donor_character_slots()

/datum/client_login_processor/donator_check/get_query(client/C)
	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT CAST(SUM(amount) as UNSIGNED INTEGER) FROM budget
		WHERE ckey=:ckey
			AND is_valid=true
			AND date_start <= NOW()
			AND (NOW() < date_end OR date_end IS NULL)
		GROUP BY ckey
	"}, list("ckey" = C.ckey))

	return query

/client/donor_loadout_points()
	if(!prefs)
		return

	prefs.max_gear_slots = GLOB.configuration.general.base_loadout_points

	switch(donator_level)
		if(1)
			prefs.max_gear_slots += 2
		if(2)
			prefs.max_gear_slots += 4
		if(3)
			prefs.max_gear_slots += 8
		if(4)
			prefs.max_gear_slots += 12
		if(5)
			prefs.max_gear_slots += 16

/client/proc/donor_character_slots()
	if(!prefs)
		return

	prefs.max_save_slots = MAX_SAVE_SLOTS_SS220 + 5 * donator_level

	prefs.character_saves.len = prefs.max_save_slots

#undef MAX_SAVE_SLOTS_SS220
