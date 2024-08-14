/datum/modpack/credits
	name = "Credits"
	desc = "Добавление титров в конце раунда, основа кода была взята из данного репозитория https://github.com/Baystation12/Baystation12"
	author = "Legendaxe"

/datum/modpack/credits/initialize()
	GLOB.admin_verbs_admin += list(
		/client/proc/toggle_credits
	)
	// Update verbs for admins who connected before subsystem initialization.
	for(var/client/player in GLOB.clients)
		if(!player.holder)
			continue
		player.add_admin_verbs()