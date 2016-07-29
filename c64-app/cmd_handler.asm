!zone command_handler

CMD_TWITTER = "1"
CMD_BORDER = "2"
CMD_BG = "3"
CMD_PLAY = "5"
CMD_HEARTBEAT = "6"
CMD_WEATHER = "7"
CMD_VISITORS = "8"
CMD_SIGNIN = "9"
CMD_SHOW_LOGO = "a"
CMD_SHOW_INFO = "b"
CMD_SHOW_TWEET = "c"
CMD_SHOW_MAIN = "d"

heartbeat_tick !byte 0

; ----------------------------------------------------------------------
; Looks at cmd_buffer and executes matching command
; ----------------------------------------------------------------------
command_handler
		lda cmd_buffer
		cmp #CMD_TWITTER
		bne .test_border_cmd
		; handle tweet
		+set16im cmd_buffer + 1, $fb
		+set16im twitter_buffer, $fd
		jsr string_copy
		jsr main_screen_update_twitter
		rts

.test_border_cmd
		cmp #CMD_BORDER
		bne .test_bg_cmd
		lda cmd_buffer + 1
		sta $d020       ; border color
		rts

.test_bg_cmd
		cmp #CMD_BG
		bne .test_play_cmd
		lda cmd_buffer + 1
		sta $d021       ; background color
		rts

.test_play_cmd
		cmp #CMD_PLAY
		bne .test_weather_cmd
		jsr do_beep
		bne .test_weather_cmd
		rts

.test_weather_cmd
		cmp #CMD_WEATHER
		bne .test_visitors
		+set16im cmd_buffer + 1, $fb
		+set16im weather_buffer, $fd
		jsr string_copy
		jsr main_screen_update_weather
		rts

.test_visitors
		cmp #CMD_VISITORS
		bne .test_signin
		+set16im cmd_buffer + 1, $fb
		+set16im visitors_buffer, $fd
		jsr string_copy
		jsr string_len
		; pad the string
		lda #'.'
		sta ($fd), y
		iny
		lda #32
		sta ($fd), y
		iny
		sta ($fd), y
		iny
		sta ($fd), y
		iny
		lda #0
		sta ($fd), y
		sty visitors_buffer_len     ; store string length
		jsr main_screen_update_visitors
		rts

.test_signin
		cmp #CMD_SIGNIN
		bne .test_show_logo
		+set16im cmd_buffer + 1, $fb
		+set16im visitor_name_buffer, $fd
		jsr string_copy
		jsr signin_screen_render
		jsr keyboard_wait
		jsr screen_enable_lowercase_chars
		jsr main_screen_render
		rts

.test_show_logo
		cmp #CMD_SHOW_LOGO
		bne .test_show_info
		jsr logo_screen_render
		rts

.test_show_info
		cmp #CMD_SHOW_INFO
		bne .test_show_tweet
		jsr info_screen_render
		rts

.test_show_tweet
		cmp #CMD_SHOW_TWEET
		bne .test_show_main
		jsr tweet_screen_render
		rts

.test_show_main
		cmp #CMD_SHOW_MAIN
		bne .done
		jsr main_screen_render
		rts

.done
		rts