!zone smiler_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.anim_delay !byte .ANIM_DELAY
.anim_direction !byte 0

.ANIM_DELAY = 4
.FRAME_COUNT = 8

;sprite1
twitter_sprite_init
		lda #240		
		sta $07f9
		lda $d015
		ora #%00000010
		sta $d015
		lda #14			; color 1
		sta $d028

		lda #25			; x
		sta $d002
		lda #103 		; y
		sta $d003

		lda #.FRAME_COUNT
		sta .frame_counter
		lda #0
		sta .anim_direction
		rts

twitter_sprite_update
		jsr .animate
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #.ANIM_DELAY
		stx .anim_delay

		dec .frame_counter
		bne .update_frame

		lda .anim_direction
		eor #1
		sta .anim_direction

		ldx #.FRAME_COUNT
		stx .frame_counter
		rts
.update_frame
		lda .anim_direction
		bne .update_frame_backwards
		inc $07f9
		rts
.update_frame_backwards
		dec $07f9
		rts		

.done
		rts


		
