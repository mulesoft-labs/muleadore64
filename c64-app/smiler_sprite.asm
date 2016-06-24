!zone smiler_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.anim_pause !byte 20
.anim_delay !byte .ANIM_DELAY

.ANIM_DELAY = 4
.FRAME_COUNT = 16

;sprite6
smiler_sprite_init
		lda #224		
		sta $07fe
		lda $d015
		ora #%01000000
		sta $d015
		lda #1			; color 1
		sta $d027

		lda #25
		sta $d00c
		lda #70
		sta $d00d
		rts

smiler_sprite_update
		lda .anim_pause
		cmp #0
		beq .call_animate
		dec .anim_pause
		bne .done_update
.call_animate
		jsr .animate
.done_update
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #.ANIM_DELAY
		stx .anim_delay
		dec .frame_counter
		bne .update_frame
		lda #223
		sta $07fe
		ldx #.FRAME_COUNT
		stx .frame_counter
		lda #255
		sta .anim_pause
.update_frame
		inc $07fe
		rts		

.done
		rts


		
