// MARK: Declensions

// Падежи русского языка
/// Именительный: Кто это? Клоун и ассистуха.
#define NOMINATIVE 1
/// Родительный: Откусить кусок от кого? От клоуна и ассистухи.
#define GENITIVE 2
/// Дательный: Дать полный доступ кому? Клоуну и ассистухе.
#define DATIVE 3
/// Винительный: Обвинить кого? Клоуна и ассистуху.
#define ACCUSATIVE 4
/// Творительный: Возить по полу кем? Клоуном и ассистухой.
#define INSTRUMENTAL 5
/// Предложный: Прохладная история о ком? О клоуне и об ассистухе.
#define PREPOSITIONAL 6

/atom
	/// ru_names = list(NOMINATIVE = "челюсти жизни", GENITIVE = "челюстей жизни", DATIVE = "челюстям жизни", ACCUSATIVE = "челюсти жизни", INSTRUMENTAL = "челюстями жизни", PREPOSITIONAL = "челюстях жизни")
	var/list/ru_names

/**
* Процедура выбора правильного падежа для любого предмета, если у него указан словарь «ru_names», примерно такой:
* ru_names = list(NOMINATIVE = "челюсти жизни", GENITIVE = "челюстей жизни", DATIVE = "челюстям жизни", ACCUSATIVE = "челюсти жизни", INSTRUMENTAL = "челюстями жизни", PREPOSITIONAL = "челюстях жизни")
*/
/atom/proc/declent_ru(case_id, list/ru_names_override)
	var/list/list_to_use = ru_names_override || ru_names
	if(length(list_to_use))
		return list_to_use[case_id] || name
	return name

/// Склонения, например "секунда", "секунды", "секунд".
/proc/declension_ru(num, single_name, double_name, multiple_name)
	if(!isnum(num) || round(num) != num)
		return double_name // fractional numbers
	if(((num % 10) == 1) && ((num % 100) != 11)) // 1, not 11
		return single_name
	if(((num % 10) in 2 to 4) && !((num % 100) in 12 to 14)) // 2, 3, 4, not 12, 13, 14
		return double_name
	return multiple_name // 5, 6, 7, 8, 9, 0

/**
 * ВНИМАНИЕ: Не используйте этот прок, используйте genderize_decode!
 *
 * Местоимения, например "должен", "должна", "должно", "должны".
 *
*/
/proc/genderize_ru(gender, male_word, female_word, neuter_word, multiple_word)
	switch(gender)
		if(MALE)
			return male_word
		if(FEMALE)
			return female_word
		if(NEUTER)
			return neuter_word
		else
			return multiple_word

/**
 * ВНИМАНИЕ: Не используйте этот прок, используйте genderize_decode!
 *
 * Единственное и множественное число, например "бросает", "бросают".
 *
*/
/proc/pluralize_ru(gender, single_word, plural_word)
	return gender == PLURAL ? plural_word : single_word

/**
 * Replaces the `%(SINGLE,PLURAL)%` or `%(MALE,FEMALE,NEUTER,PLURAL)%` message piece accordingly to user gender.
 * Use `*` to deliberatly skip one genderize word: `%(*,FEMALE,*,PLURAL)%`.
 *
 * Example: var/death_message = genderize_decode(user, "изда%(ет,ют)% тихий гортанный звук, зелёная кровь пузырится из %(его,её,его,их)% пасти...")
 *
 * Arguments:
 * * user - Person which pronouns will be used.
 * * msg - The string to modify.
 *
 * Returns the modified msg string.
 *
 */
/proc/genderize_decode(atom/target, msg)
	if(!isatom(target) || !istext(msg))
		stack_trace("Invalid arguments in genderize_decode proc.")
	while(TRUE)
		var/prefix = findtext_char(msg, "%(")
		if(!prefix)
			break
		var/postfix = findtext_char(msg, ")%")
		if(!postfix)
			stack_trace("Genderize string is missing proper ending, expected )%.")
		var/list/pieces = splittext(copytext_char(msg, prefix + 2, postfix), ",")
		switch(length(pieces))
			// Pluralize if only two parts present
			if(2)
				msg = replacetext(splicetext_char(msg, prefix, postfix + 2, pluralize_ru(target.gender, pieces[1], pieces[2])), "*", "")
			// Use full genderize if all four parts exist
			if(4)
				msg = replacetext(splicetext_char(msg, prefix, postfix + 2, genderize_ru(target.gender, pieces[1], pieces[2], pieces[3], pieces[4])), "*", "")
			else
				stack_trace("Invalid data sent to genderize_decode proc.")
	return msg

//////////////////////////////
// MARK: Pronouns
//////////////////////////////
/// Применяет одно из "они", "оно", "он", или "она" в зависимости от пола. Установите TRUE для заглавной буквы.
/datum/proc/ru_p_they(capitalized, temp_gender)
	. = "оно"
	if(capitalized)
		. = capitalize(.)

/// Применяет одно из "их", "его", или "её" в зависимости от пола. Установите TRUE для заглавной буквы.
/datum/proc/ru_p_them(capitalized, temp_gender)
	. = "их"
	if(capitalized)
		. = capitalize(.)

/// Применяет одно из "сами", "само", "сам", или "сама" в зависимости от пола. Установите TRUE для заглавной буквы.
/datum/proc/ru_p_themselves(capitalized, temp_gender)
	. = "само"

/// Применяет "имеет" для единственного числа и "имеют" для множественного ("она имеет" / "они имеют").
/datum/proc/ru_p_have(temp_gender)
	. = "имеет"

/// Применяет "было" для единственного числа и "были" для множественного ("оно было" / "они были").
/datum/proc/ru_p_were(temp_gender)
	. = "было"

/// Применяет "делает" для единственного числа и "делают" для множественного ("она делает" / "они делают").
/datum/proc/ru_p_do(temp_gender)
	. = "делает"

//////////////////////////////
// MARK: Client procs
//////////////////////////////
// Like clients, which do have gender.
/client/ru_p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "они"
	switch(temp_gender)
		if(MALE)
			. = "он"
		if(FEMALE)
			. = "она"
		if(NEUTER)
			. = "оно"
	if(capitalized)
		. = capitalize(.)

/client/ru_p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "их"
	switch(temp_gender)
		if(MALE)
			. = "его"
		if(FEMALE)
			. = "её"
	if(capitalized)
		. = capitalize(.)

/client/ru_p_themselves(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	switch(temp_gender)
		if(MALE)
			. = "сам"
		if(FEMALE)
			. = "сама"
		if(NEUTER)
			. = "само"
		if(PLURAL)
			. = "сами"
	if(capitalized)
		. = capitalize(.)

/client/ru_p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "имеет"
	if(temp_gender == PLURAL)
		. = "имеют"

/client/ru_p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "был"
	switch(temp_gender)
		if(FEMALE)
			. = "была"
		if(NEUTER)
			. = "было"
		if(PLURAL)
			. = "были"

/client/ru_p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "делает"
	if(temp_gender == PLURAL)
		. = "делают"

//////////////////////////////
// MARK: Mob procs
//////////////////////////////
// Mobs (and atoms but atoms don't really matter write your own proc overrides) also have gender!
/mob/ru_p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "они"
	switch(temp_gender)
		if(MALE)
			. = "он"
		if(FEMALE)
			. = "она"
		if(NEUTER)
			. = "оно"
	if(capitalized)
		. = capitalize(.)

/mob/ru_p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "их"
	switch(temp_gender)
		if(MALE)
			. = "его"
		if(FEMALE)
			. = "её"
	if(capitalized)
		. = capitalize(.)

/mob/ru_p_themselves(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	switch(temp_gender)
		if(MALE)
			. = "сам"
		if(FEMALE)
			. = "сама"
		if(NEUTER)
			. = "само"
		if(PLURAL)
			. = "сами"
	if(capitalized)
		. = capitalize(.)

/mob/ru_p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "имеет"
	if(temp_gender == PLURAL)
		. = "имеют"

/mob/ru_p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "был"
	switch(temp_gender)
		if(FEMALE)
			. = "была"
		if(NEUTER)
			. = "было"
		if(PLURAL)
			. = "были"

/mob/ru_p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "делает"
	if(temp_gender == PLURAL)
		. = "делают"

//////////////////////////////
// MARK: Human procs
//////////////////////////////
// Humans need special handling, because they can have their gender hidden
/mob/living/carbon/human/ru_p_they(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/ru_p_them(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/ru_p_themselves(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/ru_p_have(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/ru_p_were(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/ru_p_do(temp_gender)
	temp_gender = get_visible_gender()
	return ..()
