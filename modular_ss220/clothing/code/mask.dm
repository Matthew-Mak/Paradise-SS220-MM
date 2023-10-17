/obj/item/clothing/mask/fakemoustache/chef
	name = "абсолютно настоящие усы шефа"
	desc = "Осторожно: усы накладные."

/obj/item/clothing/mask/fakemoustache/chef/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		var/static/regex/words = new(@"(?<![a-zA-Zа-яёА-ЯЁ])[a-zA-Zа-яёА-ЯЁ]+?(?![a-zA-Zа-яёА-ЯЁ])", "g")
		message = replacetext(message, words, TYPE_PROC_REF(/obj/item/clothing/mask/fakemoustache/chef, words_replace))

		if(prob(3))
			message += pick(" Равиоли, равиоли, подскажи мне формуоли!"," Мамма-мия!"," Мамма-мия! Какая острая фрикаделька!", " Ла ла ла ла ла фуникули+ фуникуля+!")
	speech_args[SPEECH_MESSAGE] = trim(message)

/obj/item/clothing/mask/fakemoustache/chef/proc/handle_speech()
	SIGNAL_HANDLER

/obj/item/clothing/mask/fakemoustache/chef/proc/words_replace(word)
	var/static/list/italian_words
	if(!italian_words)
		italian_words = strings("italian_replacement.json", "italian")

	var/match = italian_words[lowertext(word)]
	if(!match)
		return word

	if(islist(match))
		match = pick(match)

	if(word == uppertext(word))
		return uppertext(match)

	if(word == capitalize(word))
		return capitalize(match)

	return match

/datum/outfit/job/chef
	mask = /obj/item/clothing/mask/fakemoustache/chef
