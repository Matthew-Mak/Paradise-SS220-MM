/* Station */
/area/security/checkpoint/south
	name = "\improper Escape Security Checkpoint"

/area/bridge/checkpoint
	name = "\improper Command Checkpoint"

/area/bridge/checkpoint/north
	name = "\improper North Command Checkpoint"

/area/bridge/checkpoint/south
	name = "\improper South Command Checkpoint"

/area/engine/aitransit
	name = "\improper AI Satellite Transfer Point"
	icon_state = "engi"

/area/engine/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engine_hallway"

/area/engine/dronefabricator
	name = "\improper Engineering Drone Fabricator Room"
	icon_state = "engi"

/area/engine/emergency
	name = "\improper Engineering Emergency Supplies"
	icon_state = "emergencystorage"

/area/engine/supermatter_room
	name = "\improper Supermatter Room"
	icon_state = "engi"

/area/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos"

/* CentCom */
/area/centcom220
	name = "\improper ЦК"
	icon_state = "centcom"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	nad_allowed = TRUE

/area/centcom220/evac
	name = "\improper ЦК - Эвакуационный шаттл"
	icon_state = "centcom_evac"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom220/park
	name = "\improper ЦК - Парк"
	icon_state ="centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom220/bar
	name = "\improper ЦК - Бар"
	icon_state ="centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom220/general
	name = "\improper ЦК - Зона персонала"
	icon_state ="centcom"

/area/centcom220/supply
	name = "\improper ЦК - Доставка"
	icon_state ="centcom"

/area/centcom220/admin1
	name = "\improper ЦК - Коридоры ЦК"
	icon_state ="centcom"

/area/centcom220/admin2
	name = "\improper ЦК - Офисы"
	icon_state ="centcom"

/area/centcom220/admin3
	name = "\improper ЦК - ОБР"
	icon_state ="centcom"

/area/centcom220/jail
	name = "\improper ЦК - Тюрьма"
	icon_state ="centcom"
