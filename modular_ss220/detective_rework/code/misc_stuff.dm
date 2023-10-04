/obj/item/clothing/gloves/color/black/forensics
	transfer_prints = FALSE
// Boxes
/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "dnakit"

/obj/item/storage/box/swabs/populate_contents()
	..()
	new /obj/item/forensics/swab(src)
	new /obj/item/forensics/swab(src)
	new /obj/item/forensics/swab(src)
	new /obj/item/forensics/swab(src)
	new /obj/item/forensics/swab(src)
	new /obj/item/forensics/swab(src)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "dnakit"

/obj/item/storage/box/fingerprints/populate_contents()
	..()
	new /obj/item/sample/print(src)
	new /obj/item/sample/print(src)
	new /obj/item/sample/print(src)
	new /obj/item/sample/print(src)
	new /obj/item/sample/print(src)
	new /obj/item/sample/print(src)

// Crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'modular_ss220/detective_rework/icons/forensics.dmi'
	icon_state = "case"
	lefthand_file = 'modular_ss220/detective_rework/icons/items_lefthand.dmi'
	righthand_file = 'modular_ss220/detective_rework/icons/items_righthand.dmi'
	item_state = "case"

/obj/item/storage/briefcase/crimekit/populate_contents()
	..()
	new /obj/item/storage/box/swabs(src)
	new /obj/item/storage/box/fingerprints(src)
	new /obj/item/forensics/sample_kit(src)
	new /obj/item/forensics/sample_kit/powder(src)
	new /obj/item/detective_scanner(src)
