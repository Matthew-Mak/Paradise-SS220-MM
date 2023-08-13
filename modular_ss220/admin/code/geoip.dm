var/global/geoip_query_counter = 0
var/global/geoip_next_counter_reset = 0
var/global/list/geoip_ckey_updated = list()


/datum/geoip_data
	var/holder = null
	var/status = null
	var/country = null
	var/countryCode = null
	var/region = null
	var/regionName = null
	var/city = null
	var/timezone = null
	var/isp = null
	var/mobile = null
	var/proxy = null
	var/ip = null

/datum/geoip_data/New(client/C, addr)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/geoip_data, get_geoip_data), C, addr)

/client
	var/datum/geoip_data/geoip
	var/url

/client/New(TopicData)
	. = ..()
	if(!geoip)
		geoip = new(src, address)
	url = winget(src, null, "url")

/datum/geoip_data/proc/get_geoip_data(client/C, addr)
	if(!C || !addr)
		return

	if(C?.holder.rights & R_ADMIN)
		status = "admin"
		return

	if(!try_update_geoip(C, addr))
		return

	if(!C)
		return

	if(status == "updated")
		var/msg = "[holder] connected from ([country], [regionName], [city]) using ISP: ([isp]) with IP: ([ip]) Proxy: ([proxy])"
		log_admin(msg)
		if(SSticker.current_state > GAME_STATE_STARTUP && !(C.ckey in geoip_ckey_updated))
			geoip_ckey_updated |= C.ckey
			message_admins(msg)


/datum/geoip_data/proc/try_update_geoip(client/C, addr)
	if(!C || !addr)
		return FALSE

	if(addr == "127.0.0.1")
		addr = "[world.internet_address]"

	if(status != "updated")
		holder = C.ckey

		var/msg = geoip_check(addr)
		if(msg == "limit reached" || msg == "export fail")
			status = msg
			return FALSE

		for(var/data in msg)
			switch(data)
				if("country")
					country = msg[data]
				if("countryCode")
					countryCode = msg[data]
				if("region")
					region = msg[data]
				if("regionName")
					regionName = msg[data]
				if("city")
					city = msg[data]
				if("timezone")
					timezone = msg[data]
				if("isp")
					isp = msg[data]
				if("mobile")
					mobile = msg[data] ? "true" : "false"
				if("proxy")
					proxy = msg[data] ? "true" : "false"
				if("query")
					ip = msg[data]
		status = "updated"
	return TRUE

/proc/geoip_check(addr)
	if(world.time > geoip_next_counter_reset)
		geoip_next_counter_reset = world.time + 900
		geoip_query_counter = 0

	geoip_query_counter++
	if(geoip_query_counter > 130)
		return "limit reached"

	var/list/vl = world.Export("http://ip-api.com/json/[addr]?fields=205599")
	if (!("CONTENT" in vl) || vl["STATUS"] != "200 OK")
		return "export fail"

	var/msg = file2text(vl["CONTENT"])
	return json_decode(msg)

