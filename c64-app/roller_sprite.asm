!zone roller_sprite

.ms_pos_x_low !byte 60
.ms_pos_x_high !byte 0
.current_frame !byte 0
.walk_delay !byte 2
.anim_delay !byte .ANIM_DELAY

.ANIM_DELAY = 4
.POS_Y = 227
.FRAME_COUNT = 8

;sprite 2
roller_sprite_init
		lda #136		; $2000 / 64
		sta $07fa		; sprite0 pointer location
		lda $d015
		ora #%00000100
		sta $d015
		lda #9			; color 1
		sta $d029

		;+set16im 260, ms_pos_x_low
		lda #255 
		sta .ms_pos_x_low
		lda #58
		sta .ms_pos_x_high

		lda #.POS_Y
		sta $d005       ; set sprite x position
		rts

roller_sprite_update
		jsr .walk
		jsr .animate
		rts

.walk
		dec .walk_delay
		bne .done
		lda #2
		sta .walk_delay

		ldx .ms_pos_x_high
		beq .dec_pos_x_low
		dex
		stx .ms_pos_x_high
		jmp .walk_set_positions
.dec_pos_x_low
		dec .ms_pos_x_low
		bne .walk_set_positions
		; if low is 0, reset to far-right
		lda #255 
		sta .ms_pos_x_low
		lda #80
		sta .ms_pos_x_high
.walk_set_positions
		jsr .set_x_pos

		rts

.animate
		dec .anim_delay
		bne .done
		ldx #.ANIM_DELAY
		stx .anim_delay
		ldx .current_frame
		inx
		inc $07fa
		cpx #.FRAME_COUNT
		bne .mule_sprite_update_frame
		lda #136
		sta $07fa
		ldx #0
.mule_sprite_update_frame
		stx .current_frame
		rts

.set_x_pos
		lda .ms_pos_x_high
		beq .set_x_pos_low		; if x < 255, branch

.set_x_high
		lda .ms_pos_x_high
		sta $d004
		lda $d010
		ora #%00000100
		sta $d010 		; turn on x-expand
		rts

.set_x_pos_low
		lda .ms_pos_x_low
		sta $d004
		lda $d010
		and #%11111011
		sta $d010 		; turn off x-expand
		rts
		

.done
		rts


		
