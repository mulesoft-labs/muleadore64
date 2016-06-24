!zone intro_screen

.str_text1 
!pet "Hi there!", 0
.str_text2 
!pet "         I'm a Commodore 64 (from 1985).", 0
.str_text3 
!pet " In 1985, I wasn't connected to much", 13
!pet "except beige tape drives, joysticks and CRT tvs.", 0
.str_text4 
!pet " ", REVERSE_VIDEO_ON, ":-(", REVERSE_VIDEO_OFF, 0
.str_text5 
!pet "       In 2016, thanks to ", COLOR_LIGHT_BLUE
!pet "MuleSoft", COLOR_WHITE
!pet ", I am part of an application network!", 13, 13
!pet "It connects me to APIs for Greenhouse,  Envoy, Twitter, "
!pet "Phillips Hue lights and live weather!", 0
.str_text6 !pet " ", REVERSE_VIDEO_ON, ":-)", REVERSE_VIDEO_OFF, 0


intro_screen_render
		sei
		lda #0
		sta screen_update_handler_ptr
		cli
		jsr screen_clear

		ldx #1         ; row
        ldy #0          ; column
        +set16im .str_text1, $fb
        jsr screen_print_str

		ldx #5        ; row
        ldy #0          ; column
        +set16im .str_text2, $fb
        jsr screen_print_str

        jsr keyboard_wait

        ldx #9
        ldy #0
		+set16im .str_text3, $fb
        jsr screen_print_str

        ldx #13
        ldy #0
		+set16im .str_text4, $fb
        jsr screen_print_str

        jsr keyboard_wait

        ldx #16
        ldy #0
		+set16im .str_text5, $fb
        jsr screen_print_str

        ldx #23
        ldy #0
		+set16im .str_text6, $fb
        jsr screen_print_str

        rts


