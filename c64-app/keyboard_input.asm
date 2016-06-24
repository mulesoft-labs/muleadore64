!zone keyboard_input

keyboard_read
		jsr GETIN
		cmp #0
		bne .check_input
		rts

.check_input
		cmp #'T'
		bne .keyboard_m
		jsr tweet_screen_render
		jsr keyboard_wait
		jsr main_screen_render
		rts
.keyboard_m
		cmp #'M'
		bne .keyboard_i
		jsr logo_screen_render
		jsr keyboard_wait
		jsr main_screen_render
		rts
.keyboard_i
		cmp #'I'
		bne .keyboard_n
		jsr info_screen_render
		jsr keyboard_wait
		jsr screen_enable_lowercase_chars
		jsr main_screen_render
		rts
.keyboard_n
		cmp #'N'
		bne .keyboard_w
		jsr intro_screen_render
		jsr keyboard_wait
		jsr main_screen_render
		rts

.keyboard_w
		cmp #'S'
		bne .done
		jsr signin_screen_render
		jsr keyboard_wait
		jsr screen_enable_lowercase_chars
		jsr main_screen_render
		rts

.done
		rts

keyboard_wait
		jsr GETIN
		cmp #0
		beq keyboard_wait
		rts