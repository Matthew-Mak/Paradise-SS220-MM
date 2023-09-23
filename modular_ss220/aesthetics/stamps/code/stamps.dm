// It's just works :skull:
/obj/item/paper/stamp(obj/item/stamp/S)
	if(S.stampoverlay_custom_icon)
		stamps += (!stamps || stamps == "" ? "<HR>" : "") + "<img src=large_[S.icon_state].png>"
		var/image/stampoverlay = image(S.stampoverlay_custom_icon)
		var/x = rand(-2, 0)
		var/y = rand(-1, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y
		stampoverlay.icon_state = "paper_[S.icon_state]"
		stamp_overlays += stampoverlay

		if(!ico)
			ico = new
		ico += "paper_[S.icon_state]"
		if(!stamped)
			stamped = new
		stamped += S.type

		update_icon(UPDATE_OVERLAYS)
	else
		. = ..()

// TODO: Paperplane overlays code. Now there's no overlays at all on paperplanes because of /obj/item/paperplane/update_overlays()

/obj/item/stamp
	var/stampoverlay_custom_icon

/obj/item/stamp/warden
	name = "warden's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ward"
	item_color = "hosred"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/ploho
	name = "'Very Bad, Redo' rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ploho"
	item_color = "hop"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/bigdeny
	name = "\improper BIG DENY rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-BIGdeny"
	item_color = "redcoat"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/navcom
	name = "Nanotrasen Naval Command rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-navcom"
	item_color = "captain"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/mime
	name = "mime's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-mime"
	item_color = "mime"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/ussp
	name = "old USSP rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ussp"
	item_color = "redcoat"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

// Adding new stamps to the list
/datum/asset/simple/paper/New()
	assets += list(
		"large_stamp-ward.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ward.png',
		"large_stamp-ploho.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ploho.png',
		"large_stamp-BIGdeny.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-BIGdeny.png',
		"large_stamp-navcom.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-navcom.png',
		"large_stamp-mime.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-mime.png',
		"large_stamp-ussp.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ussp.png'
	)
