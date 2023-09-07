// Пример добавления руины.
/datum/map_template/ruin/space/example // Вместо "example" писать название руины.
	name = "example" // Имя руины
	id = "example_id" // ID руины
	description = "Пример описания" // Описание руины. Видно только админам.
	prefix = "_maps/map_files220/RandomRuins/SpaceRuins/" // Путь до карты, обязательно оставлять таким.
	suffix = "" // .dmm файл руины, вписывать название полностью, пример: suffix = "example.dmm". Саму карту закидывать в путь префикса.
	cost = 5 // Вес руины, чем он больше, тем меньше шанс что она заспавнится
	allow_duplicates = FALSE // Разрешает/Запрещает дубликаты руины. TRUE - могут быть дубликаты. FALSE - дубликатов не будет.
	always_place = TRUE // Если вписать эту строчку, руина будет спавнится всегда. Использовать ТОЛЬКО для теста! После удалить.
	ci_exclude = /datum/map_template/ruin/space/example // Это не использовать.

// Добавлять свои руины под этими комментариями. Делать это по примеру выше!
// Комментарии УДАЛИТЬ если копируешь пример.
/datum/map_template/ruin/space/mechtransport_new
	name = "Mechtransport"
	id = "mechtransport_new"
	description = "An abandoned unarmed transport ship, a perfect target for the bandit scum."
	prefix = "_maps/map_files220/RandomRuins/SpaceRuins/"
	suffix = "mechtransport_new.dmm"
	cost = 3
	allow_duplicates = FALSE

/datum/map_template/ruin/space/destroyed_infiltrator
	name = "Destroyed Infiltrator Ship"
	id = "destroyed_infiltrator"
	description = "They're loading BSA! But why? Ah, they're going to sho-..."
	prefix = "_maps/map_files220/RandomRuins/SpaceRuins/"
	suffix = "destroyed_infiltrator.dmm"
	cost = 3
	allow_duplicates = FALSE

/datum/map_template/ruin/space/transit_bar
	name = "Transit Bar"
	id = "transit_bar"
	description = "One of the trillion bars in this galaxy, this one looks especially homey and comfy."
	prefix = "_maps/map_files220/RandomRuins/SpaceRuins/"
	suffix = "transit_bar.dmm"
	cost = 1
	allow_duplicates = FALSE
