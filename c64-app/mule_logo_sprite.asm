!zone roller_sprite

ms_pos_x !word 0
.current_frame !byte 0
.walk_delay !byte .WALK_DELAY
.anim_delay !byte .ANIM_DELAY

.x_direction !byte 0
.y_direction !byte 0

.ANIM_DELAY = 5
.WALK_DELAY = 1
.POS_Y = 200
.FRAME_COUNT = 8

;sprite 1
mule_logo_sprite_init
		lda #$88		; ($2000 + 512 + 64) / 64
		sta $07f9		; sprite1 pointer location
		lda $d015
		ora #$2			; enable sprite1
		sta $d015
		lda #14			; color 14
		sta $d028

		lda $d017
		ora #$2
		sta $d017

		+set16im 320, ms_pos_x

		lda #.POS_Y
		sta $d003       ; set sprite y position
		rts

mule_logo_sprite_update
		jsr .walk
		jsr .animate
		rts

.walk
		dec .walk_delay
		bne .done
		lda #.WALK_DELAY
		sta .walk_delay
		jsr .check_x_bounds
		jsr .check_y_bounds
		jsr update_x_pos_registers
		rts

.animate
		dec .anim_delay
		bne .done
		ldx #.ANIM_DELAY
		stx .anim_delay
		ldx .current_frame
		inx
		inc $07f9
		cpx #.FRAME_COUNT
		bne .mule_sprite_update_frame
		lda #$88
		sta $07f9
		ldx #0
.mule_sprite_update_frame
		stx .current_frame

.done
		rts

.check_y_bounds
	lda .y_direction
	bne +
	dec $d003
	lda $d003
	cmp #40
	bne ++
	jsr .swap_y_direction
	jmp ++
+
	inc $d003
	lda $d003
	cmp #210
	bne ++
	jsr .swap_y_direction
++
	rts

.check_x_bounds
	lda .x_direction
	bne +
	; moving <-
	+dec16 ms_pos_x
	lda ms_pos_x+1
	bne ++
	lda ms_pos_x
	cmp #20
	bne ++
	jsr .swap_x_direction
	jmp ++
+
	; moving ->
	+inc16 ms_pos_x
	lda ms_pos_x+1
	beq ++
	lda ms_pos_x
	cmp #60
	bne ++
	jsr .swap_x_direction
++
	jsr update_x_pos_registers
	rts

.swap_y_direction
	lda .y_direction
	eor #1
	sta .y_direction
	rts

.swap_x_direction
	lda .x_direction
	eor #1
	sta .x_direction
	rts

update_x_pos_registers
	lda ms_pos_x+1
	beq .set_x_pos_low		; if x < 255, branch
	lda ms_pos_x
	sta $d002
	lda $d010
	ora #%00000010
	sta $d010 		; turn on x-expand
	rts

.set_x_pos_low
	lda ms_pos_x
	sta $d002
	lda $d010
	and #%11111101
	sta $d010 		; turn off x-expand
	rts