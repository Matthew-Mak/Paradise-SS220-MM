/obj/effect/proc_holder/spell/aoe_turf/rathens
	name = "Rathen's Secret"
	desc = "Summons a powerful shockwave around you that tears the appendix and limbs off of enemies."
	charge_max = 500
	clothes_req = 1
	invocation = "ARSE NATH!"
	invocation_type = "shout"
	range = 7
	cooldown_min = 200
	selection_type = "view"
	action_icon_state = "superfart"

/obj/effect/proc_holder/spell/aoe_turf/rathens/cast(list/targets)
	var/mob/user = usr
	var/list/impacted_mobs = list()
	for(var/turf/T in targets)
		for(var/mob/living/carbon/human/H in T)
			if(H == user)
				continue
			impacted_mobs  += H
	if(!impacted_mobs.len)
		to_chat(user, "<span class='danger'>There are no targets in range!</span>")
		revert_cast()
		return 0
	playsound(get_turf(user), 'sound/goonstation/effects/superfart.ogg', 25, 1)
	for(var/mob/living/carbon/human/H in impacted_mobs)
		var/datum/effect/system/harmless_smoke_spread/s = new /datum/effect/system/harmless_smoke_spread
		s.set_up(5, 0, H)
		s.start()
		var/obj/item/organ/internal/appendix/A = H.get_int_organ(/obj/item/organ/internal/appendix)
		if(A)
			A.remove(H)
			A.forceMove(get_turf(H))
			spawn()
				A.throw_at(get_edge_target_turf(H, pick(alldirs)), rand(1, 10), 5)
			H.visible_message("<span class='danger'>[H]'s [A.name] flies out of their body in a magical explosion!</span>",\
							  "<span class='danger'>Your [A.name] flies out of your body in a magical explosion!</span>")
			H.Weaken(2)
		else
			var/obj/effect/decal/cleanable/blood/gibs/G = new/obj/effect/decal/cleanable/blood/gibs(get_turf(H))
			spawn()
				G.throw_at(get_edge_target_turf(H, pick(alldirs)), rand(1, 10), 5)
			H.apply_damage(10, BRUTE, "chest")
			to_chat(H, "<span class='userdanger'>You have no [A.name], but something had to give! Holy shit, what was that?</span>")
			H.Weaken(3)
			for(var/obj/item/organ/external/E in H.organs)
				if(istype(E, /obj/item/organ/external/head))
					continue
				if(istype(E, /obj/item/organ/external/chest))
					continue
				if(istype(E, /obj/item/organ/external/groin))
					continue
				if(prob(7))
					to_chat(H, "<span class='userdanger'>Your [E] was severed by the explosion!</span>")
					E.droplimb(1, DROPLIMB_EDGE, 0, 1)


