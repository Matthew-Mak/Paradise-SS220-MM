//Пример добавления руины.
/datum/map_template/ruin/space/example
	name = "example" //Имя руины
	id = "example_id" //ID руины
	description = "Пример описания" //Описание руины. Видно только админам.
	suffix = "" //.dmm файл руины, вписывать название полностью, пример: suffix = "example.dmm. Саму карту закидывать в "_maps\map_files\RandomRuins\SpaceRuins"
	cost = 5 //Вес руины, чем он больше, тем меньше шанс что она заспавнится
	allow_duplicates = FALSE //Разрешает/Запрещает дубликаты руины. TRUE - могут быть дубликаты. FALSE - дубликатов не будет.
	always_place = TRUE //Если вписать эту строчку, руина будет спавнится всегда.
	ci_exclude = /datum/map_template/ruin/space/example //Это не использовать.

//Добавлять свои руины под этим комментарием. Делать это по примеру выше!
