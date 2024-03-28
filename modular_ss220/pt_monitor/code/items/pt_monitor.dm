#define SENSOR_PRESSURE 	(1<<0)
#define SENSOR_TEMPERATURE 	(1<<1)
#define NO_DATA_VALUE  		null
#define MAX_RECORD_SIZE 	20
#define RECORD_INTERVAL     1
#define LONG_RECORD_INTERVAL 15

/datum/design/pt_monitor
	name = "Console Board (Atmospheric Graph Monitor)"
	desc ="Allows for the construction of circuit boards used to build an Atmospheric Graph Monitor."
	id = "pt_monitor"
	req_tech = list("programming" = 2, "engineering" = 3)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/pt_monitor
	category = list("Computer Boards")

/obj/item/circuitboard/pt_monitor
	board_name = "Atmospheric Graph Monitor"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/general_air_control/pt_monitor
	origin_tech = "programming=2;engineering=3"

/obj/machinery/computer/general_air_control/pt_monitor
	name = "Atmospheric graph monitoring console"
	desc = "Used to monitor pressure and temperature of linked analyzer."
	icon = 'modular_ss220/pt_monitor/icons/pt_monitor.dmi'
	icon_screen = "screen"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/pt_monitor

	var/record_size = MAX_RECORD_SIZE
	var/record_interval = RECORD_INTERVAL SECONDS
	var/next_record_time = 0
	var/long_record_interval = LONG_RECORD_INTERVAL SECONDS
	var/next_long_record_time = 0

/obj/machinery/computer/general_air_control/pt_monitor/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosGraphMonitor", name)
		ui.open()

/obj/machinery/computer/general_air_control/pt_monitor/configure_sensors(mob/living/user, obj/item/multitool/M)
	. = ..()
	for(var/sensor_name in sensor_name_data_map)
		if(isnull(sensor_name_data_map[sensor_name]["pressure_history"]))
			sensor_name_data_map[sensor_name]["pressure_history"] = new /list(MAX_RECORD_SIZE)
		if(isnull(sensor_name_data_map[sensor_name]["temperature_history"]))
			sensor_name_data_map[sensor_name]["temperature_history"] = new /list(MAX_RECORD_SIZE)
		if(isnull(sensor_name_data_map[sensor_name]["long_pressure_history"]))
			sensor_name_data_map[sensor_name]["long_pressure_history"] = new /list(MAX_RECORD_SIZE)
		if(isnull(sensor_name_data_map[sensor_name]["long_temperature_history"]))
			sensor_name_data_map[sensor_name]["long_temperature_history"] = new /list(MAX_RECORD_SIZE)

/obj/machinery/computer/general_air_control/pt_monitor/refresh_sensors()
	var/log_long_record = FALSE
	var/current_time = world.time

	if(current_time < next_record_time)
		return
	next_record_time = current_time + record_interval

	if(current_time >= next_long_record_time)
		log_long_record = TRUE
		next_long_record_time = current_time + long_record_interval

	for(var/sensor_name in sensor_name_uid_map)
		var/obj/machinery/atmospherics/atmos_sensor = locateUID(sensor_name_uid_map[sensor_name])
		// Проверка что сенсор существует
		if(QDELETED(atmos_sensor))
			sensor_name_uid_map -= sensor_name
			sensor_name_data_map -= sensor_name
			continue

		var/list/sensor_data = sensor_name_data_map[sensor_name]
		var/list/sensor_pressure_history = sensor_data["pressure_history"]
		var/list/sensor_temperature_history = sensor_data["temperature_history"]
		var/list/sensor_long_pressure_history = sensor_data["long_pressure_history"]
		var/list/sensor_long_temperature_history = sensor_data["long_temperature_history"]
		var/current_pressure
		var/current_temperature

		if(istype(atmos_sensor, /obj/machinery/atmospherics/air_sensor))
			var/obj/machinery/atmospherics/air_sensor/sensor = atmos_sensor
			var/datum/gas_mixture/air_sample = sensor.return_air()
			current_pressure = (sensor.output & SENSOR_PRESSURE) ? air_sample.return_pressure() : NO_DATA_VALUE
			current_temperature = (sensor.output & SENSOR_TEMPERATURE) ? air_sample.return_temperature() : NO_DATA_VALUE
		else if(istype(atmos_sensor, /obj/machinery/atmospherics/meter))
			var/obj/machinery/atmospherics/meter/the_meter = atmos_sensor
			if(the_meter.target)
				var/datum/gas_mixture/meter_air_sample = the_meter.target.return_air()
				current_pressure = meter_air_sample ? meter_air_sample.return_pressure() : NO_DATA_VALUE
				current_temperature = meter_air_sample ? meter_air_sample.return_temperature() : NO_DATA_VALUE
		else
			sensor_name_uid_map -= sensor_name
			sensor_name_data_map -= sensor_name
			CRASH("Sensor of unexpected type was found: [atmos_sensor.type]")

		sensor_pressure_history += current_pressure
		sensor_temperature_history += current_temperature
		if(length(sensor_pressure_history) > record_size)
			sensor_pressure_history.Cut(1, 2)
		if(length(sensor_temperature_history) > record_size)
			sensor_temperature_history.Cut(1, 2)

		if(log_long_record)
			sensor_long_pressure_history += current_pressure
			sensor_long_temperature_history += current_temperature
			if(length(sensor_long_pressure_history) > record_size)
				sensor_long_pressure_history.Cut(1, 2)
			if(length(sensor_long_temperature_history) > record_size)
				sensor_long_temperature_history.Cut(1, 2)

/obj/machinery/computer/general_air_control/pt_monitor/process()
	if((stat & BROKEN) || (sensor_name_uid_map.len < 1))
		return

	refresh_all()

#undef SENSOR_PRESSURE
#undef SENSOR_TEMPERATURE
#undef NO_DATA_VALUE
#undef MAX_RECORD_SIZE
#undef RECORD_INTERVAL
#undef LONG_RECORD_INTERVAL
