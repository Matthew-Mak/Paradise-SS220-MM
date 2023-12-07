/client/verb/randomtip()
	set category = "OOC"
	set name = "Рандомная подсказка"
	set desc = "Даёт рандомную подсказку"

	var/m

	var/list/randomtips = file2list("strings/tips.txt")
	var/list/memetips = file2list("strings/sillytips.txt")
	if(randomtips.len && prob(95))
		m = pick(randomtips)
	else if(memetips.len)
		m = pick(memetips)

	if(m)
		to_chat(src, "<span class='purple'><b>Tip: </b>[html_encode(m)]</span>")
