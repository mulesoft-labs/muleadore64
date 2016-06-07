!zone screen

screen_clear
		lda #0
		sta $d020       ; border color
		sta $d021       ; background color
		lda #147        ; clear screen
		jsr CHROUT
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
.print_str_loop
		lda ($fb), y
		cmp #0
		beq .print_str_exit
		jsr CHROUT
		iny
		jmp .print_str_loop

.print_str_exit
		rts
