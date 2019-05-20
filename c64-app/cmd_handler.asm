!zone command_handler

heartbeat_tick !byte 0
current_command !byte 0

BITMAP_DATA = 1
COLOR_DATA = 2
TWEET_DATA = 3
ATTRACT_SCREEN = 4

BITMAP_COMMAND_LENGTH = 8000
BITMAP_STREAM_PTR_END = $4000 + BITMAP_COMMAND_LENGTH

command_complete_callback !byte 1,1,$7e,0


; ----------------------------------------------------------------------
; Inputs: A - recieved character
; ----------------------------------------------------------------------
command_handler
		ldx current_command
		cpx #BITMAP_DATA
		bne .check_tweet_data
		
		ldy #0
		sta (BITMAP_STREAM_PTR), y
		lda #$ff
		iny
		sta (BITMAP_STREAM_PTR), y

 		+inc16 BITMAP_STREAM_PTR

 		ldy BITMAP_STREAM_PTR
 		cpy #<BITMAP_STREAM_PTR_END
 		bne .done
 		ldy BITMAP_STREAM_PTR+1
 		cpy #>BITMAP_STREAM_PTR_END
 		bne .done

		; BITMAP_STREAM_PTR = $5f40 - we've finished, reset for next command
		;inc $d020
		jsr command_handler_reset_for_next_command
 		rts

.check_tweet_data
		cpx #TWEET_DATA
		bne .check_new_command
		cmp #$7e  ; if char == '~', it means end of tweet
		bne +
		jsr command_handler_reset_for_next_command
		rts
+
		jsr CHROUT
		rts

.check_new_command
		cpx #0
		bne .done
		jsr command_handler_init_command
		rts

; ----------------------------------------------------------------------
; Initializes a command
; Inputs: A - recieved character
; ----------------------------------------------------------------------
command_handler_init_command 
	cmp #BITMAP_DATA
	bne .check_tweet_init
	sta current_command

	+set16im $4000, BITMAP_STREAM_PTR
	;lda #%11110000		; white/black
	lda #$e6			; light blue/dark blue
	jsr screen_clear_bitmap_to_color
	jsr screen_clear_bitmap_data
	jsr screen_switch_vic_bank_1
	jsr screen_enable_standard_bitmap_mode

	jsr mule_logo_sprite_init
	rts

.check_tweet_init
	cmp #TWEET_DATA
	bne .check_attract_screen
	sta current_command
	jsr screen_switch_vic_bank_0
	jsr screen_enable_text_mode
	jsr main_screen_enter

	ldx #10
	ldy #0
	clc
	jsr PLOT

	lda #COLOR_LIGHT_GREY
	jsr CHROUT
	rts

.check_attract_screen
	cmp #ATTRACT_SCREEN
	bne .done
	sta current_command
	jsr screen_switch_vic_bank_0
	jsr screen_enable_text_mode
	jsr main_screen_enter
	jsr main_screen_render_architecture
	rts

.done
	rts

command_handler_reset_for_next_command
	ldy #0
	sty current_command

	+set16im command_complete_callback, $fb
	jsr rs232_send_string
	rts
