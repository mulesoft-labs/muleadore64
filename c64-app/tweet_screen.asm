!zone tweet_screen
.str_tweet_banner !pet "Send a tweet from 1985 as @muleadore64:", 0
.str_sending !pet "Sending data to event ingest API...", 0
.str_complete !pet "Complete. Hit any key to continue.", 0
.tweet_buffer !fill 140, 0

tweet_screen_render
	jsr screen_clear

	; call .update_handler on screen refresh
	sei
	+set16im .update_handler, screen_update_handler_ptr
	cli
	
	lda #COLOR_WHITE
	jsr CHROUT      ; foreground white

	ldx #10
	ldy #0		
	+set16im .str_tweet_banner, $fb
	jsr screen_print_str

	jsr twitter_sprite_init

	ldx #12
	ldy #0
	clc
	jsr PLOT

	ldy #0
.read_keyboard_input
	jsr CHRIN	; read line from keyboard (first call), 
			; subsequent calls will retrieve each byte of that input
	sta .tweet_buffer, y
	iny
	cmp #13
	bne .read_keyboard_input
	lda #0		; write a \0 at end of input
	sta .tweet_buffer, y

	tya
	beq .no_data_entered

	ldx #14
	ldy #0
	+set16im .str_sending, $fb
	jsr screen_print_str

	+set16im .str_complete, $fb
	ldx #17
	ldy #0
	jsr screen_print_str

	lda #'1'	; cmd-type
	jsr rs232_write_byte
	jsr rs232_send_string
	lda #'~'	; cmd-trailer
	jsr rs232_write_byte

.no_data_entered
	rts

.update_handler
	jsr twitter_sprite_update
	jmp irq_return

	


