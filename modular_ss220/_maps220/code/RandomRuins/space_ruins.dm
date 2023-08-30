// Пример добавления руины.
/datum/map_template/ruin/space/example // Вместо "example" писать название руины.
	name = "example" // Имя руины
	id = "example_id" // ID руины
	description = "Пример описания" // Описание руины. Видно только админам.
	suffix = "" // .dmm файл руины, вписывать название полностью, пример: suffix = "example.dmm". Саму карту закидывать в "_maps\map_files\RandomRuins\SpaceRuins"
	cost = 5 // Вес руины, чем он больше, тем меньше шанс что она заспавнится
	allow_duplicates = FALSE // Разрешает/Запрещает дубликаты руины. TRUE - могут быть дубликаты. FALSE - дубликатов не будет.
	always_place = TRUE // Если вписать эту строчку, руина будет спавнится всегда.
	ci_exclude = /datum/map_template/ruin/space/example // Это не использовать.

// Добавлять свои руины под этими комментариями. Делать это по примеру выше!
// Комментарии УДАЛИТЬ если копируешь пример.

/datum/map_template/ruin/space/space_wildwest
	name = "Space Wild West"
	id = "space_wildwest"
	description = "A captured mining outpost on a lonely asteroid. There are rumors that a horrible structure is entombed in its depths."
	suffix = "space_wildwest.dmm"
	cost = 5
	allow_duplicates = FALSE
	always_place = FALSE

/datum/map_template/ruin/space/mechtransport_new
	name = "Mechtransport"
	id = "mechtransport_new"
	description = "An abandoned unarmed transport ship, a perfect target for the bandit scum."
	suffix = "mechtransport_new.dmm"
	cost = 3
	allow_duplicates = FALSE
	always_place = FALSE

