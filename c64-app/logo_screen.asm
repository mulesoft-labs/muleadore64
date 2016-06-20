!zone logo_screen

.welcome_banner !pet "C64, welcome to 2016!", 0
.welcome_banner2 !pet "( Powered by MuleSoft )", 0

logo_screen_render
		; disable screen update handler
		sei
		lda #0
		sta screen_update_handler_ptr
		cli

		jsr screen_clear
		
		clc
		ldx #24
		ldy #0
		jsr PLOT

		lda #COLOR_LIGHT_BLUE
		jsr CHROUT
		+set16im logo_data, $fb
		ldx #25		; 25 lines
		ldy #0
.render_next_pixel
		lda ($fb), y
		jsr CHROUT
		iny
		cpy #40
		bne .render_next_pixel
		+add16im $fb, 40, $fb
		ldy #0
		dex
		beq .done_logo 	; if we've drawn 25 lines, stop now
		jmp .render_next_pixel

.done_logo
		lda #10
		jsr CHROUT
		jsr CHROUT
		lda #COLOR_WHITE
		jsr CHROUT
		ldx #23         ; row
        ldy #10          ; column
        +set16im .welcome_banner, $fb
        jsr screen_print_str

        ldx #24         ; row
        ldy #9          ; column
        +set16im .welcome_banner2, $fb
        jsr screen_print_str
		rts