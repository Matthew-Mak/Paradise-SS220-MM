/datum/server_configuration
	var/datum/configuration_section/gpt/gpt

/datum/server_configuration/load_all_sections()
	. = ..()
	gpt = new()
	safe_load(gpt, "gpt")

/datum/configuration_section/gpt
	protection_state = PROTECTION_PRIVATE
	var/gpt_enabled = FALSE
	var/access_token = ""
	var/endpoint = "https://models.inference.ai.azure.com/chat/completions"
	var/model = "gpt-4o"

/datum/configuration_section/gpt/load_data(list/data)
	CONFIG_LOAD_BOOL(gpt_enabled, data["gpt_enabled"])
	CONFIG_LOAD_STR(access_token, data["access_token"])
	CONFIG_LOAD_STR(endpoint, data["endpoint"])
	CONFIG_LOAD_STR(model, data["model"])

/datum/http_request/vv_get_var(var_name)
	if(var_name == "header")
		return FALSE
	. = ..()
