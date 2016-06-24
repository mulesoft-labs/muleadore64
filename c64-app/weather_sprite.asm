!zone weather_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.anim_delay !byte .ANIM_DELAY

.ANIM_DELAY = 8
.FRAME_COUNT = 8

;sprite5
weather_sprite_init
		lda #248		
		sta $07fd
		lda $d015
		ora #%00100000
		sta $d015
		lda #15			; color
		sta $d02c

		lda #25
		sta $d00a
		lda #175
		sta $d00b
		rts

weather_sprite_update
		jsr .animate
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #.ANIM_DELAY
		stx .anim_delay
		dec .frame_counter
		bne .update_frame
		lda #247
		sta $07fd
		ldx #.FRAME_COUNT
		stx .frame_counter
.update_frame
		inc $07fd
		rts		

.done
		rts


		
