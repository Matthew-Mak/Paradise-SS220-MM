
/area/station/medical
	ambientsounds = MEDICAL_SOUNDS
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/station/medical/medbay
	name = "Медицинский Отдел"
	icon_state = "medbay"

//Medbay is a large area, these additional areas help level out APC load.
/area/station/medical/medbay2
	name = "Медицинский Отдел"
	icon_state = "medbay"

/area/station/medical/medbay3
	name = "Медицинский Отдел"
	icon_state = "medbay"

/area/station/medical/storage
	name = "Склад Медицинского Отдела"
	icon_state = "medbaystorage"

/area/station/medical/reception
	name = "Ресепшен Медицинского Отдела"
	icon_state = "medbaylobby"

/area/station/medical/psych
	name = "Офис Психолога"
	icon_state = "medbaypsych"

/area/station/medical/break_room
	name = "Комната Отдыха Медицинского Отдела"
	icon_state = "medbaybreak"

/area/station/medical/patients_rooms
	name = "Комнаты Пациентов"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/ward
	name = "Комната Ожидания Медицинского Отдела"
	icon_state = "patientsward"

/area/station/medical/isolation/a
	name = "Комната Изоляции А"
	icon_state = "medbayisoa"

/area/station/medical/isolation/b
	name = "Комната Изоляции Б"
	icon_state = "medbayisob"

/area/station/medical/isolation/c
	name = "Комната Изоляции В"
	icon_state = "medbayisoc"

/area/station/medical/isolation
	name = "Зона Изоляции"
	icon_state = "medbayisoaccess"

/area/station/medical/coldroom
	name = "Морозильная Камера Медицинского Отдела"
	icon_state = "coldroom"


/area/station/medical/storage/secondary
	name = "Дополнительный Склад Медицинского Отдела"
	icon_state = "medbaysecstorage"

/area/station/medical/virology
	name = "Вирусология"
	icon_state = "virology"

/area/station/medical/virology/lab
	name = "Лаборатория Вирусологии"
	icon_state = "virology"

/area/station/medical/morgue
	name = "Морг"
	icon_state = "morgue"
	ambientsounds = SPOOKY_SOUNDS
	is_haunted = TRUE
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/chemistry
	name = "Химическая Лаборатория Медицинского Отдела"
	icon_state = "chem"

/area/station/medical/surgery
	name = "Операционное Отделение"
	icon_state = "surgery"

/area/station/medical/surgery/primary
	name = "Первая Операционная"
	icon_state = "surgery1"

/area/station/medical/surgery/secondary
	name = "Вторая Операционная"
	icon_state = "surgery2"

/area/station/medical/surgery/observation
	name = "Комната Оперативного Наблюдения"
	icon_state = "surgery"

/area/station/medical/cryo
	name = "Криогеника"
	icon_state = "cryo"

/area/station/medical/exam_room
	name = "Комната Осмотра Медицинского Отдела"
	icon_state = "exam_room"

/area/station/medical/cloning
	name = "Лаборатория Клонирования"
	icon_state = "cloning"

/area/station/medical/sleeper
	name = "Центр Медицинского Лечения"
	icon_state = "exam_room"

/area/station/medical/paramedic
	name = "Офис Парамедик"
	icon_state = "paramedic"
