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
		cmp #'C'
		rts

keyboard_wait
		jsr GETIN
		cmp #0
		beq keyboard_wait
		rts