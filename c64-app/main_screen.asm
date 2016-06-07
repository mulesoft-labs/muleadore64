!zone main_screen

.str_header              !pet "MuleSoft San Francisco C64 (1985)", 0
.str_header_line         !fill 40, $A3
!byte 0
.str_visitors            !pet "Welcome to visitors", 0
.str_twitter             !pet "Latest from Twitter", 0
.str_weather             !pet "Current weather", 0

visitors_buffer         !pet "waiting for data..."
!fill 235, 0
twitter_buffer          !pet "waiting for data..."
!fill 235, 0
weather_buffer          !pet "waiting for data..."
!fill 235, 0

main_screen_render
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white

	; header row
	ldx #0         ; row
	ldy #4          ; column
	+set16im .str_header, $fb
	jsr screen_print_str

	; header row line
	ldx #1
	ldy #0
	+set16im .str_header_line, $fb
	jsr screen_print_str

	lda #COLOR_GREEN
	jsr CHROUT

	; visitors
	ldx #3
	ldy #0
	+set16im .str_visitors, $fb
	jsr screen_print_str

	; twitter
	ldx #7
	ldy #0
	+set16im .str_twitter, $fb
	jsr screen_print_str

	; weather row
	ldx #16
	ldy #0
	+set16im .str_weather, $fb
	jsr screen_print_str

	jsr main_screen_update_twitter
	jsr main_screen_update_weather
	jsr main_screen_update_visitors

	; call .update_handler on screen refresh
	sei
	+set16im .update_handler, screen_update_handler_ptr
	cli
	rts

main_screen_update_twitter
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white
	ldx #8
	ldy #0
	+set16im twitter_buffer, $fb
	jsr screen_print_str
	rts

main_screen_update_weather
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white
	ldx #17
	ldy #0
	+set16im weather_buffer, $fb
	jsr screen_print_str
	rts

main_screen_update_visitors
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white
	ldx #4
	ldy #0
	+set16im visitors_buffer, $fb
	jsr screen_print_str
	rts

.update_handler
	jsr mule_sprite_update
	jsr heartbeat_frame_counter
	jmp irq_return


