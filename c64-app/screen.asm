!zone screen

screen_clear 
	lda #0
	;sta $d020       ; border color
	;sta $d021       ; background color
	lda #147        ; clear screen
	jsr CHROUT
	rts

screen_enable_lowercase_chars
	lda $d018
	and #%11110001
	ora	#%00000110
	sta $d018
	rts

; ----------------------------------------------------------------------
; A: color to clear to
; ----------------------------------------------------------------------
screen_clear_bitmap_to_color
	ldx #0

-
	sta SCREEN_VRAM, x
	sta SCREEN_VRAM + $100, x
	sta SCREEN_VRAM + $200, x
	sta SCREEN_VRAM + $300, x
	dex
	bne -
	rts

; ----------------------------------------------------------------------
; clear bitmap ram
; ----------------------------------------------------------------------
screen_clear_bitmap_data
	lda #0
	ldx #0
-
	sta BITMAP_VRAM, x
	sta BITMAP_VRAM + $100, x
	sta BITMAP_VRAM + $200, x
	sta BITMAP_VRAM + $300, x
	dex
	bne -
	rts

; ----------------------------------------------------------------------
; X: row
; Y: column
; $FB/$FC: null-terminated string
; ----------------------------------------------------------------------
screen_print_str
	clc
	jsr PLOT
	ldy #0
-
	lda ($fb), y
	cmp #0
	beq +
	jsr CHROUT
	iny
	bne -
	; if we overflowed Y, inc $fc
	inc $fc
	ldy #0
	jmp -

+
	rts


screen_enable_standard_bitmap_mode
	lda $d011
	ora #%00100000
	sta $d011
	rts

screen_enable_text_mode
	lda $d011
	and #%11011111
	sta $d011
	rts

screen_switch_vic_bank_1
	lda $dd00
	and #%11111100
	ora #%00000010		
	sta $dd00			; tell VIC-II to use bank #1

	lda #%10000000
	sta $d018			; bitmap pointer = 0, screen memory = $2000 in bank #1 (so $4000 + $2000)

	rts

screen_switch_vic_bank_0

	lda $dd00
	ora #%00000011		; tell VIC to use bank #0
	sta $dd00

	lda #%00010101
	sta $d018		; screen memory is $400, char mem = 

	rts