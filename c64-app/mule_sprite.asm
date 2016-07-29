!zone mule_sprite

ms_pos_x_low !byte 60
ms_pos_x_high !byte 0
.current_frame !byte 0
.walk_delay !byte .WALK_DELAY
.anim_delay !byte 5

.WALK_DELAY = 5
.POS_Y = 227
.FRAME_COUNT = 8

mule_sprite_init
		lda #$80		; $2000 / 64
		sta $07f8		; sprite0 pointer location
		lda $d015
		ora #%00000001
		sta $d015
		lda #1			; color 1
		sta $d027

		;+set16im 260, ms_pos_x_low
		lda #255 
		sta ms_pos_x_low
		lda #80
		sta ms_pos_x_high

		lda #.POS_Y
		sta $d001       ; set sprite x position

		lda $d01d 		; disable double-size
		and #%11111110
		sta $d01d
		lda $d017
		and #%11111110
		sta $d017
		rts


mule_sprite_update
		jsr .walk
		jsr .animate
		rts

.walk
		dec .walk_delay
		bne .done
		lda #.WALK_DELAY
		sta .walk_delay

		ldx ms_pos_x_high
		beq .dec_pos_x_low
		dex
		stx ms_pos_x_high
		jmp .walk_set_positions
.dec_pos_x_low
		dec ms_pos_x_low
		bne .walk_set_positions
		; if low is 0, reset to far-right
		lda #255 
		sta ms_pos_x_low
		lda #80
		sta ms_pos_x_high
		inc $d027		; new color
.walk_set_positions
		jsr .set_x_pos

		rts

.animate
		dec .anim_delay
		bne .done
		ldx #3
		stx .anim_delay
		ldx .current_frame
		inx
		inc $07f8
		cpx #.FRAME_COUNT
		bne .mule_sprite_update_frame
		lda #$80
		sta $07f8
		ldx #0
.mule_sprite_update_frame
		stx .current_frame
		rts

.set_x_pos
		lda ms_pos_x_high
		beq .set_x_pos_low		; if x < 255, branch

set_x_high
		lda ms_pos_x_high
		sta $d000
		lda $d010
		ora #%00000001
		sta $d010 		; turn on x-expand
		rts

.set_x_pos_low
		lda ms_pos_x_low
		sta $d000
		lda $d010
		and #%11111110
		sta $d010 		; turn off x-expand
		rts
		

.done
		rts


		
