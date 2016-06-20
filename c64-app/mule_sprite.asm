!zone mule_sprite

ms_pos_x_low !byte 60
ms_pos_x_high !byte 0
.pos_y !byte 230
.current_frame !byte 0
.walk_delay !byte 2
.anim_delay !byte 3

mule_sprite_init
		lda #$80		; $2000 / 64
		sta $07f8		; sprite0 pointer location
		lda #1			; enable sprite #0
		sta $d015
		lda #1			; color 1
		sta $d027

		;+set16im 260, ms_pos_x_low
		lda #255 
		sta ms_pos_x_low
		lda #80
		sta ms_pos_x_high
		rts

mule_sprite_disable
		lda $d015
		and #$fe		; disable sprite #0
		sta $d015
		rts

mule_sprite_update
		jsr .walk
		jsr .animate
		rts

.walk
		dec .walk_delay
		bne .done
		lda #2
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
.walk_set_positions
		jsr .set_x_pos
		lda .pos_y
		sta $d001       ; set sprite x position

		rts

.animate
		dec .anim_delay
		bne .done
		ldx #3
		stx .anim_delay
		ldx .current_frame
		inx
		inc $07f8
		cpx #8
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
		lda #1
		sta $d010 		; turn on x-expand
		rts

.set_x_pos_low
		lda ms_pos_x_low
		sta $d000
		lda #0
		sta $d010 		; turn off x-expand
		rts
		

.done
		rts


		
