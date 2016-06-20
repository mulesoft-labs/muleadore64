
.str_welcome_header !pet "Welcome to MuleSoft San Francisco!", 0
.str_welcome_footer 
	!pet "Please have a seat and Paul White"
	!pet 13 
	!pet "      will be with you shortly.", 0
.color_loop_delay !byte 10
visitor_name_buffer !fill 255, 0

signin_screen_render
	; call .update_handler on screen refresh
	sei
	+set16im .update_handler, screen_update_handler_ptr
	cli

	jsr screen_clear

	ldx #5         ; row
	ldy #3          ; column
	+set16im .str_welcome_header, $fb
	jsr screen_print_str

	ldx #10         ; row
	ldy #10          ; column
	+set16im visitor_name_buffer, $fb
	jsr screen_print_str

	ldx #40
	ldy #0
.color_shift_loop
	tya
	and #$f
	cmp #0
	bne .set_color
	lda #1
.set_color
	sta $d990, x
	iny
	dex
	bne .color_shift_loop


	ldx #15         ; row
	ldy #3         ; column
	+set16im .str_welcome_footer, $fb
	jsr screen_print_str
	rts

.update_handler
	dec .color_loop_delay  ; delay for x frames
	bne .done_update
	lda #20					; reset delay counter
	sta .color_loop_delay

	ldx #40					; 40 chars per row
.color_loop
	lda $d990, x
	adc #1
	inc $d990, x
	dex
	bne .color_loop

.done_update
	jmp irq_return