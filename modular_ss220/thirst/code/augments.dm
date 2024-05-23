/obj/item/organ/internal/cyberimp/chest/hydration
	name = "Hydration pump implant"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of hydration when you are thirsty."
	implant_color = "#0000AA"
	var/thirst_threshold = HYDRATION_LEVEL_MEDIUM
	var/synthesizing = FALSE
	slot = "stomach_hydration"

/obj/item/organ/internal/cyberimp/chest/hydration/on_life()
	if(synthesizing)
		return
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_NO_THIRST))
		return
	if(owner.hydration <= thirst_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("Вам меньше хочется пить..."))
		owner.adjust_hydration(50)
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 5 SECONDS)

/obj/item/organ/internal/cyberimp/chest/hydration/proc/synth_cool()
	synthesizing = FALSE
