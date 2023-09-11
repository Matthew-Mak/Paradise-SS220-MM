//Platform Code by Danaleja2005
/obj/structure/platform
	name = "platform"
	icon = 'modular_ss220/objects/icons/platform.dmi'
	icon_state = "metal"
	desc = "A metal platform."
	flags = ON_BORDER
	anchored = FALSE
	climbable = TRUE
	max_integrity = 200
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10, "energy" = 50, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	var/corner = FALSE
	var/material_type = /obj/item/stack/sheet/metal
	var/material_amount = 4
	var/decon_speed

/obj/structure/platform/proc/CheckLayer()
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	else if(corner || dir == NORTH)
		layer = BELOW_MOB_LAYER

/obj/structure/platform/setDir(newdir)
	. = ..()
	CheckLayer()

/obj/structure/platform/Initialize()
	. = ..()
	CheckLayer()

/obj/structure/platform/New()
	..()
	if(corner)
		decon_speed = 20
		density = FALSE
		climbable = FALSE
	else
		decon_speed = 30
	CheckLayer()

/obj/structure/platform/examine(mob/user)
	. = ..()
	. += "<span class='notice'>[src] is [anchored == TRUE ? "screwed" : "unscrewed"] [anchored == TRUE ? "to" : "from"] the floor.</span>"

/obj/structure/platform/verb/rotate()
	set name = "Rotate Platform Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if(anchored)
		to_chat(usr, "<span class='warning'>[src] cannot be rotated while it is screwed to the floor!</span>")
		return FALSE

	var/target_dir = turn(dir, 90)

	setDir(target_dir)
	air_update_turf(1)
	add_fingerprint(usr)
	return TRUE

/obj/structure/platform/verb/revrotate()
	set name = "Rotate Platform Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if(anchored)
		to_chat(usr, "<span class='warning'>[src] cannot be rotated while it is screwed to the floor!</span>")
		return FALSE

	var/target_dir = turn(dir, 270)

	setDir(target_dir)
	air_update_turf(1)
	add_fingerprint(usr)
	return TRUE

/obj/structure/platform/AltClick(mob/user)
	rotate()

//Construction
/obj/structure/platform/screwdriver_act(mob/user, obj/item/I)
	. = TRUE
	to_chat(user, "<span class='notice'>You begin [anchored == TRUE ? "unscrewing" : "screwing"] [src] [anchored == TRUE ? "from" : "to"] the floor.</span>")
	if(!I.use_tool(src, user, decon_speed, volume = I.tool_volume))
		return
	to_chat(user, "<span class='notice'>You [anchored == TRUE ? "unscrew" : "screw"] [src] [anchored == TRUE ? "from" : "to"] the floor.</span>")
	anchored = !anchored

/obj/structure/platform/wrench_act(mob/user, obj/item/I)
	if(user.a_intent != INTENT_HELP)
		return
	. = TRUE
	if(anchored)
		to_chat(user, "<span class='notice'>You cannot disassemble [src], unscrew it first!</span>")
		return
	TOOL_ATTEMPT_DISMANTLE_MESSAGE
	if(!I.use_tool(src, user, decon_speed, volume = I.tool_volume))
		return
	var/obj/item/stack/sheet/G = new material_type(user.loc, material_amount)
	G.add_fingerprint(user)
	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
	TOOL_DISMANTLE_SUCCESS_MESSAGE
	qdel(src)


/obj/structure/platform/CheckExit(atom/movable/O, turf/target)
	if(!anchored)
		CheckLayer()
	if(istype(O, /obj/structure/platform))
		return FALSE
	if(istype(O, /obj/item/projectile))
		return TRUE
	if(corner)
		return !density
	if(O && O.throwing)
		return TRUE
	if(((flags & ON_BORDER) && get_dir(loc, target) == dir))
		return FALSE
	else
		return TRUE

/obj/structure/platform/CanPass(atom/movable/mover, turf/target)
	if(!anchored)
		CheckLayer()
	if(istype(mover, /obj/structure/platform))
		return FALSE
	if(istype(mover, /obj/item/projectile))
		return TRUE
	if(corner)
		return !density
	if(mover && mover.throwing)
		return TRUE
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags & ON_BORDER) && climbable && isliving(mover))//Climbable objects allow you to universally climb over others
		return TRUE
	if(!(flags & ON_BORDER) || get_dir(loc, target) == dir)
		return FALSE
	else
		return TRUE

/obj/structure/platform/do_climb(mob/living/user)
	if(!can_touch(user) || !climbable)
		return
	var/blocking_object = density_check()
	if(blocking_object)
		to_chat(user, "<span class='warning'>You cannot climb over [src], as it is blocked by \a [blocking_object]!</span>")
		return

	var/destination_climb = get_step(src, dir)
	if(is_blocked_turf(destination_climb))
		to_chat(user, "<span class='warning'>You cannot climb over [src], the path is blocked!")
		return
	var/turf/T = src.loc
	if(!T || !istype(T)) return

	if(get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] starts climbing over \the [src]!</span>")
	else
		usr.visible_message("<span class='warning'>[user] starts getting off \the [src]!</span>")
	climber = user
	if(!do_after(user, 50, target = src))
		climber = null
		return

	if(!can_touch(user) || !climbable)
		climber = null
		return

	if(get_turf(user) == get_turf(src))
		usr.loc = get_step(src, dir)
		usr.visible_message("<span class='warning'>[user] leaves \the [src]!</span>")
	else
		usr.loc = get_turf(src)
		usr.visible_message("<span class='warning'>[user] starts climbing over \the [src]!</span>")
	climber = null

/obj/structure/platform/CanAtmosPass()
	return TRUE

//Platform types
/obj/structure/platform/reinforced
	name = "reinforced platform"
	desc = "A robust platform made of plasteel, more resistance for hazard sites."
	icon_state = "plasteel"
	material_type = /obj/item/stack/sheet/plasteel
	max_integrity = 300
	armor = list("melee" = 20, "bullet" = 30, "laser" = 30, "energy" = 100, "bomb" = 50, "bio" = 0, "rad" = 75, "fire" = 100, "acid" = 100)

///Corners
/obj/structure/platform/corner
	name = "platform corner"
	desc = "A metal platform corner."
	icon_state = "metalcorner"
	corner = TRUE
	material_amount = 2

/obj/structure/platform/reinforced/corner
	name = "reinforced platform corner"
	desc = "A robust platform corner made of plasteel, more resistance for hazard sites."
	icon_state = "plasteelcorner"
	corner = TRUE
	material_amount = 2
