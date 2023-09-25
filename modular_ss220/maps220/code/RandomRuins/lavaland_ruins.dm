// Пример добавления руины.
/datum/map_template/ruin/lavaland/example // Вместо "example" писать название руины.
	name = "example" // Имя руины
	id = "example_id" // ID руины
	description = "Пример описания" // Описание руины. Видно только админам.
	prefix = "_maps/map_files220/RandomRuins/LavaRuins/" // Путь до карты, обязательно оставлять таким.
	suffix = "" // .dmm файл руины, вписывать название полностью, пример: suffix = "example.dmm". Саму карту закидывать в "_maps\map_files\RandomRuins\LavaRuins"
	cost = 5 // Вес руины, чем он больше, тем меньше шанс что она заспавнится
	allow_duplicates = FALSE // Разрешает/Запрещает дубликаты руины. TRUE - могут быть дубликаты. FALSE - дубликатов не будет.
	always_place = TRUE // Если вписать эту строчку, руина будет спавнится всегда.
	ci_exclude = /datum/map_template/ruin/lavaland/example // Это не использовать.

// Добавлять свои руины под этими комментариями. Делать это по примеру выше!
// Комментарии УДАЛИТЬ если копируешь пример.
/datum/map_template/ruin/lavaland/scp_facility
	name = "Сдерживание Аномальных Объектов"
	id = "scp_facility"
	description = "Заброшенное место хранения опасных и паранормальных предметов а так же существ."
	prefix = "_maps/map_files220/RandomRuins/LavaRuins/"
	suffix = "scp_facility.dmm"
	cost = 20 // Бесконечная пицца
	allow_duplicates = FALSE
