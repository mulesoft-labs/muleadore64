!zone main_screen

.str_header              !pet "MuleSoft San Francisco C64 (1985)", 0
.str_header_line         !fill 40, $A3
!byte 0
.str_visitors            !pet "Welcome to our visitors today", 0
.str_twitter             !pet "Latest from Twitter", 0
.str_weather             !pet "Current weather", 0

visitors_buffer         !pet "waiting for data..."
!fill 235, 0
twitter_buffer          !pet "waiting for data..."
!fill 235, 0
weather_buffer          !pet "waiting for data..."
!fill 235, 0
visitors_scroll_pos !byte 0
visitors_buffer_len !byte 19
.delay !byte 20

main_screen_render
	jsr screen_clear
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
	ldy #4
	+set16im .str_visitors, $fb
	jsr screen_print_str

	; twitter
	ldx #7
	ldy #4
	+set16im .str_twitter, $fb
	jsr screen_print_str

	; weather row
	ldx #16
	ldy #4
	+set16im .str_weather, $fb
	jsr screen_print_str

	jsr main_screen_update_twitter
	jsr main_screen_update_weather
	jsr main_screen_update_visitors

	jsr mule_sprite_init
	jsr smiler_sprite_init
	jsr roller_sprite_init
	jsr twitter_sprite_init
	jsr weather_sprite_init

	; call .update_handler on screen refresh
	sei
	+set16im .update_handler, screen_update_handler_ptr
	cli
	rts

main_screen_update_twitter
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white
	ldx #8
	ldy #4
	+set16im twitter_buffer, $fb
	jsr screen_print_str
	lda #32
.clear_extra_chars
	jsr CHROUT
	cpy #255
	iny
	bcc .clear_extra_chars
	rts

main_screen_update_weather
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white
	ldx #17
	ldy #4
	+set16im weather_buffer, $fb
	jsr screen_print_str
	rts

main_screen_update_visitors
	jsr .do_visitors_scroll
	rts

.update_handler
	jsr mule_sprite_update
	jsr smiler_sprite_update
	jsr roller_sprite_update
	jsr twitter_sprite_update
	jsr weather_sprite_update
	jsr heartbeat_frame_counter
	dec .delay
	bne .dont_delay 
	lda #30
	sta .delay
	jsr .do_visitors_scroll
.dont_delay
	jmp irq_return

.do_visitors_scroll
	+set16im visitors_buffer, $fb
	inc visitors_scroll_pos
	lda visitors_scroll_pos
	cmp visitors_buffer_len
	bne .render_scolling_line_setup
	lda #0			; if pos > len, reset pos
	sta visitors_scroll_pos

.render_scolling_line_setup
	ldx #4
	ldy #4
	clc
	jsr PLOT

	ldy visitors_scroll_pos
	ldx #36

.render_scrolling_line
	cpy visitors_buffer_len
	bmi .next
	ldy #0
.next
	lda ($fb), y
	jsr CHROUT

	iny
	dex
	bne .render_scrolling_line
	rts
