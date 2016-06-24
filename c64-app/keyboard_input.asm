!zone keyboard_input

.str_light_toggle !pet "2power~", 0
.str_light_0 !pet "20~", 0
.str_light_1 !pet "21~", 0
.str_light_2 !pet "22~", 0
.str_light_3 !pet "23~", 0
.str_light_4 !pet "24~", 0
.str_light_5 !pet "25~", 0
.str_light_6 !pet "26~", 0
.str_light_7 !pet "27~", 0
.str_light_8 !pet "28~", 0
.str_light_9 !pet "29~", 0



keyboard_read
		jsr GETIN
		cmp #0
		bne .check_input
		rts

.check_input
		cmp #'T'
		bne .keyboard_m
		jsr tweet_screen_render
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
		bne .keyboard_l
		jsr signin_screen_render
		jsr keyboard_wait
		jsr screen_enable_lowercase_chars
		jsr main_screen_render
		rts

.keyboard_l
		cmp #'L'
		bne .keyboard_0
		+set16im .str_light_toggle, $fb
		jsr rs232_send_string
		rts
.keyboard_0
		cmp #'0'
		bne .keyboard_1
		+set16im .str_light_0, $fb
		jsr rs232_send_string
		rts

.keyboard_1
		cmp #'1'
		bne .keyboard_2
		+set16im .str_light_1, $fb
		jsr rs232_send_string
		rts
.keyboard_2
		cmp #'2'
		bne .keyboard_3
		+set16im .str_light_2, $fb
		jsr rs232_send_string
		rts
.keyboard_3
		cmp #'3'
		bne .keyboard_4
		+set16im .str_light_3, $fb
		jsr rs232_send_string
		rts
.keyboard_4
		cmp #'4'
		bne .keyboard_5
		+set16im .str_light_4, $fb
		jsr rs232_send_string
		rts
.keyboard_5
		cmp #'5'
		bne .keyboard_6
		+set16im .str_light_5, $fb
		jsr rs232_send_string
		rts
.keyboard_6
		cmp #'6'
		bne .keyboard_7
		+set16im .str_light_6, $fb
		jsr rs232_send_string
		rts
.keyboard_7
		cmp #'7'
		bne .keyboard_8
		+set16im .str_light_7, $fb
		jsr rs232_send_string
		rts
.keyboard_8
		cmp #'8'
		bne .keyboard_9
		+set16im .str_light_8, $fb
		jsr rs232_send_string
		rts
.keyboard_9
		cmp #'9'
		bne .done
		+set16im .str_light_9, $fb
		jsr rs232_send_string
		rts

.done
		rts

keyboard_wait
		jsr GETIN
		cmp #0
		beq keyboard_wait
		rts