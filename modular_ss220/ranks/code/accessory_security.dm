// =================================
// Воинские и офицерские звания
// =================================
// Officer
/obj/item/clothing/accessory/rank/sec
	icon_state = "holobadge_rank"
	item_state = "gold_id"
	item_color = "holobadge_rank"
	exp_types = list(EXP_TYPE_SECURITY)
	rank_exp_order_dict = list(
		"Рядовой" = 0,
		"Ефрейтор" = 25,
		"Мл. Сержант" = 50,
		"Сержант" = 100, // На момент написания, у среднего СБшника было примерно ~50-100~ часов
		"Ст. Сержант" = 200,
		"Старшина" = 350,

		// Гвардейский состав типа УАУ ОНИ ДО СЮДА ДОШЛИ ПОГЧАМП У НЕГО 1000 часов СБ!!!
		// Не думаю что когда-нибудь вообще их увижу. Но да, они считаются очень крутыми.
		// Если кто-то до этого дойдет - я хочу пожать лично ему руку. Особенно до прапорщика или старшины
		"Гвардии Рядовой" = 1000,
		"Гвардии Ефрейтор" = 1500,
		"Гвардии Сержант" = 2000,
		"Гвардии Старшина" = 3000,
	)

// Detective
/obj/item/clothing/accessory/rank/sec/detective
	add_job_req_exp = TRUE
	rank_exp_order_dict = list(
		"Рядовой" = 0,
		"Ефрейтор" = 25,
		"Мл. Сержант" = 50,
		"Сержант" = 70,
		"Ст. Сержант" = 80,
		"Старшина" = 100,

		// Дослужился до дековских и полицейских званий
		"Сыщик" = 150,
		"Следователь" = 300,
		"Ст. Следователь" = 500,
		"Специалист Бюро" = 700,
		"Инспектор" = 1000,
		"Начальник Исследовательского Бюро" = 3000, // Большие часы. Большое название.
	)

// Warden
/obj/item/clothing/accessory/rank/sec/warden
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	add_job_req_exp = TRUE
	rank_exp_order_dict = list(
		// У Вардена начальный ускоренный курс
		"Рядовой" = 0,
		"Ефрейтор" = 5,
		"Мл. Сержант" = 10,
		"Сержант" = 15,
		"Ст. Сержант" = 30,

		// Дошел до привычных званий
		"Старшина" = 50,
		"Прапорщик" = 100,
		"Ст. Прапорщик" = 300,

		// Уникальные звания, до которых никто не дойдет.
		"Смотритель" = 600,
		"Надзиратель" = 1000,
		"Координатор" = 2000,
		"Верховный Надзиратель" = 3000, // Нафармил
	)

// HOS
/obj/item/clothing/accessory/rank/sec/officer
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	exp_types = list(EXP_TYPE_SECURITY, EXP_TYPE_COMMAND)
	add_job_req_exp = TRUE
	rank_exp_order_dict = list(
		"Мл. Лейтенант" = 0,
		"Лейтенант" = 100,
		"Ст. Лейтенант" = 300,
		"Капитан" = 500,
		"Майор" = 700,

		// Увидеть такого ГСБ - прожить жизнь не зря.
		"Гвардии Лейтенант" = 1000,
		"Гвардии Капитан" = 1500,
		"Гвардии Майор" = 3000,
	)

// Special for spawns
/obj/item/clothing/accessory/rank/sec/officer/supreme
	rank_exp_order_dict = list(
		"Подполковник" = 0,
		"Полковник" = 25,
		"Генерал-майор" = 50,
		"Генерал-лейтенант" = 100,
		"Генерал-полковник" = 200,
		"Верховный Генерал" = 350,

		"Гвардии Полковник" = 500,
		"Гвардии Генерал" = 800,

		"Маршал" = 1000,
	)
