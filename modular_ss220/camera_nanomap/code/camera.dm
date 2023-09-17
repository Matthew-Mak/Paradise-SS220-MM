/obj/machinery/computer/security/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	// Show static if can't use the camera
	if(!active_camera?.can_use())
		show_camera_static()
	if(!ui)
		var/user_uid = user.UID()
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			watchers += user_uid
		// Turn on the console
		if(length(watchers) == 1 && is_living)
			if(!silent_console)
				playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
			use_power(active_power_consumption)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			user.client.register_map_obj(plane)
		user.client.register_map_obj(cam_background)
		// Open UI
		ui = new(user, src, ui_key, "CameraConsole220", name, 1200, 600, master_ui, state)
		ui.open()

/obj/machinery/computer/security/ui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			name = active_camera.c_tag,
			status = active_camera.status,
		)
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
			x = C.x,
			y = C.y,
			z = C.z,
			status = C.status
		))
	return data

/obj/machinery/computer/security/ui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	data["stationLevel"] = level_name_to_num(MAIN_STATION)
	return data
