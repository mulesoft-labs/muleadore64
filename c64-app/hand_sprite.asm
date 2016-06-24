!zone hand_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.anim_delay !byte 3

.FRAME_COUNT = 11

; sprite 3 + 4
hand_sprite_init
		lda #144		; $2000 / 64
		sta $07fb		; sprite3 pointer location
		sta $07fc		; sprite4 pointer location
		lda $d015
		ora #%00011000 	; enable sprite 3 + 4
		sta $d015

		; left hand
		lda #50
		sta $d006
		lda #130
		sta $d007

		; right hand
		lda $d010
		ora #%00010000
		sta $d010 		; turn on x-expand
		lda #30
		sta $d008
		lda #130
		sta $d009

		lda #7			; sprite color
		sta $d02a
		sta $d02b
		rts

hand_sprite_update
		jsr .animate
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #3
		stx .anim_delay
		dec .frame_counter
		bne .update_frame
		lda #143
		sta $07fb
		sta $07fc
		ldx #.FRAME_COUNT
		stx .frame_counter
.update_frame
		inc $07fb
		inc $07fc
		rts		

.done
		rts


		
