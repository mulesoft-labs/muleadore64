!zone smiler_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.walk_delay !byte 2
.anim_delay !byte 3

.FRAME_COUNT = 69

;sprite 0
jackson_sprite_init
		lda #155		
		sta $07f8
		lda $d015
		ora #1
		sta $d015
		lda #1			; color 1
		sta $d027

		; bottom right
		lda $d010
		and #%11111110
		sta $d010 		; turn off x-expand

		; lda #20
		; sta $d002
		; lda #210
		; sta $d003

		; top of logo
		lda #160
		sta $d000
		lda #176
		sta $d001

		lda $d01d
		ora #%00000001
		sta $d01d
		lda $d017
		ora #%00000001
		sta $d017
		
		rts


jackson_sprite_update
		jsr .animate
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #3
		stx .anim_delay
		dec .frame_counter
		bne .update_frame
		lda #154
		sta $07f8
		ldx #.FRAME_COUNT
		stx .frame_counter
.update_frame
		inc $07f8
		rts		

.done
		rts


		
