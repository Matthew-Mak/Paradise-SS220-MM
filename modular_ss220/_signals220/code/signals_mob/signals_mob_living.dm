// Signals for /mob/living

/mob/living/CanPass(atom/movable/mover, turf/target, height)
	if(SEND_SIGNAL(src, COMSIG_LIVING_CAN_PASS, mover, target, height) & COMPONENT_LIVING_PASSABLE)
		return TRUE
	return ..()

/mob/living/Life(seconds, times_fired)
	SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds, times_fired)
	. = ..()

/mob/living/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	if(SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_MESSAGE_MODE, message_mode, message_pieces, verb, used_radios) & COMPONENT_FORCE_WHISPER)
		whisper_say(message_pieces)
		return TRUE
	. = ..()

/mob/living/carbon/human/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	if(SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_MESSAGE_MODE, message_mode, message_pieces, verb, used_radios) & COMPONENT_FORCE_WHISPER)
		whisper_say(message_pieces)
		return TRUE
	. = ..()
