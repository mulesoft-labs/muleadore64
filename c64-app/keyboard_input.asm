!zone keyboard_input

keyboard_read
		jsr GETIN
		cmp #0
		beq .done
keyboard_input_1

		cmp #'T'
		bne .done
		jsr tweet_screen_render
		jsr main_screen_render

.done
		rts

keyboard_wait
		jsr GETIN
		cmp #0
		beq keyboard_wait
		rts