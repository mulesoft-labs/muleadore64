!zone keyboard_input

;up $91
; left 9d
; down $11
; right $1d
keyboard_read
		jsr GETIN
		cmp #0
		bne .check_input
		rts

.check_input
		cmp #'R'
		bne .check_t
		jsr command_handler_reset_for_next_command
		jsr do_beep
		rts

.check_t
		cmp #'T'
		bne .done
		jsr screen_switch_vic_bank_0
		jsr screen_enable_lowercase_chars
		jsr screen_enable_text_mode
		jsr main_screen_enter
		rts

keyboard_wait
		jsr GETIN
		cmp #0
		beq keyboard_wait
		rts

.done
		rts