SUBSYSTEM_DEF(modpacks)
	name = "Modpacks"
	init_order = INIT_ORDER_SOUNDS
	flags = SS_NO_FIRE
	var/list/loaded_modpacks = list()

/datum/controller/subsystem/modpacks/Initialize()
	var/list/all_modpacks = subtypesof(/datum/modpack)

	// Pre-init and register all compiled modpacks.
	for(var/datum/modpack/manifest in all_modpacks)
		var/fail_msg = manifest.pre_initialize()
		if(QDELETED(manifest))
			CRASH("Modpack of type [manifest.type] is null or queued for deletion.")
			continue
		if(fail_msg)
			CRASH("Modpack [manifest.name] failed to pre-initialize: [fail_msg].")
			continue
		if(loaded_modpacks[manifest.name])
			CRASH("Attempted to register duplicate modpack name [manifest.name].")
			continue
		loaded_modpacks[manifest.name] = manifest

	// Handle init and post-init (two stages in case a modpack needs to implement behavior based on the presence of other packs).
	for(var/datum/modpack/manifest in all_modpacks)
		var/fail_msg = manifest.initialize()
		if(fail_msg)
			CRASH("Modpack [(istype(manifest) && manifest.name) || "Unknown"] failed to initialize: [fail_msg]")
	for(var/datum/modpack/manifest in all_modpacks)
		var/fail_msg = manifest.post_initialize()
		if(fail_msg)
			CRASH("Modpack [(istype(manifest) && manifest.name) || "Unknown"] failed to post-initialize: [fail_msg]")

	. = ..()

/client/verb/modpacks_list()
	set name = "Modpacks List"
	set category = "OOC"

	if(!mob || !SSmodpacks.initialized)
		return

	if(length(SSmodpacks.loaded_modpacks))
		. = "<hr><br><center><b><font size = 3>Список модификаций</font></b></center><br><hr><br>"
		for(var/datum/modpack/M in SSmodpacks.loaded_modpacks)
			if(M.name)
				. += "<div class = 'statusDisplay'>"
				. += "<center><b>[M.name]</b></center>"

				if(M.desc || M.author)
					. += "<br>"
					if(M.desc)
						. += "<br>Описание: [M.desc]"
					if(M.author)
						. += "<br><i>Автор: [M.author]</i>"
				. += "</div><br>"

		var/datum/browser/popup = new(mob, "modpacks_list", "Список Модификаций", 480, 580)
		popup.set_content(.)
		popup.open()
	else
		to_chat(src, "Этот сервер не использует какие-либо модификации.")
