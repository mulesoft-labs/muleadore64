DEFAULT_DELAY = 80

hb_counter !byte DEFAULT_DELAY
color_tick !byte $1
color_tick_state !byte 0
hb_delay !byte DEFAULT_DELAY

irq_init       
		sei             ; disable interrupts
		ldy #$7f        ; 01111111 
		sty $dc0d       ; turn off CIA timer interrupt
		lda $dc0d       ; cancel any pending IRQs
		lda #$01
		sta $d01a       ; enable VIC-II Raster Beam IRQ
		lda $d011       ; bit 7 of $d011 is the 9th bit of the raster line counter.
		and #$7f         ; make sure it is set to 0
		sta $d011
		+set_raster_interrupt 1, irq_line_0
		cli             ; enable interupts
		rts
-
irq_reset_color_swizzler
		lda #DEFAULT_DELAY
		sta hb_counter
		sta hb_delay
		lda #$1
		sta color_tick
		lda #0
		sta color_tick_state
		rts

irq_return_2
		jmp $ea31			; system handler

irq_line_0
		dec $d019			; ack interrupt
		;lda screen_update_handler_ptr
		;beq irq_return
		;jmp (screen_update_handler_ptr)

		jsr PLAY_SID
		jsr mule_sprite_update
		jsr mule_logo_sprite_update
		jsr twitter_sprite_update

		jsr colwash

		; flash once per second
		dec hb_counter
		bne irq_return_2

		; counter down to 0, reset it
		lda hb_delay
		sta hb_counter

		lda color_tick_state

.color_tick_cloudhub
		cmp #0
		bne .color_tick_mq

		ldx #10
		lda color_tick
-
		sta $d990, x
		sta $d990+40, x
		sta $d990+80, x
		sta $d990+120, x
		sta $d990+160, x
		sta $d990+200, x
		sta $d990+240, x
		sta $d990+280, x
		sta $d990+320, x
		dex
		bne -
		inc color_tick_state
		jmp $ea31			; system handler

.color_tick_mq
		cmp #1
		bne .color_tick_pi
		lda color_tick
		ldx #10
-
		sta $d99a, x
		sta $d99a+40, x
		sta $d99a+80, x
		sta $d99a+120, x
		sta $d99a+160, x
		sta $d99a+200, x
		sta $d99a+240, x
		sta $d99a+280, x
		sta $d99a+320, x
		dex
		bne -
		inc color_tick_state
		jmp $ea31			; system handler

.color_tick_pi
		cmp #2
		bne .color_tick_c64
		lda color_tick
		ldx #13
-
		sta $d9a0, x
		sta $d9a0+40, x
		sta $d9a0+80, x
		sta $d9a0+120, x
		sta $d9a0+160, x
		sta $d9a0+200, x
		sta $d9a0+240, x
		sta $d9a0+280, x
		sta $d9a0+320, x
		dex
		bne -
		inc color_tick_state
		jmp $ea31			; system handler

.color_tick_c64
		cmp #20
		bcs .color_tick_reset
		lda color_tick
		ldx #10
-
		sta $d9ad-80, x
		sta $d9ad-40, x
		sta $d9ad, x
		sta $d9ad+40, x
		sta $d9ad+80, x
		sta $d9ad+120, x
		sta $d9ad+160, x
		sta $d9ad+200, x
		sta $d9ad+240, x
		sta $d9ad+280, x
		sta $d9ad+320, x
		dex
		bne -
		lda color_tick
		eor #$f
		sta color_tick
		inc color_tick_state

		lda #15
		sta hb_delay
		sta hb_counter
		jmp irq_return

.color_tick_reset
		; reset delay to 60 ticks
		lda #DEFAULT_DELAY
		sta hb_delay
		; wait for 100 ticks before starting again
		lda #100
		sta hb_counter

		lda #0
		sta color_tick_state
		ldx #40

		; reset next flash to white
		lda #$1
		sta color_tick
		; reset all to light blue
		lda #$e

		-
		sta $d990-80, x
		sta $d990-40, x
		sta $d990, x
		sta $d990+40, x
		sta $d990+80, x
		sta $d990+120, x
		sta $d990+160, x
		sta $d990+200, x
		sta $d990+240, x
		sta $d990+280, x
		sta $d990+320, x
		dex
		bne -

irq_return
		jmp $ea31			; system handler



colwash   ldx #$27        ; load x-register with #$27 to work through 0-39 iterations
          lda color+$27   ; init accumulator with the last color from first color table

cycle1    ldy color-1,x   ; remember the current color in color table in this iteration
          sta color-1,x   ; overwrite that location with color from accumulator
          sta $d800+$25,x     ; put it into Color Ram into column x
          tya             ; transfer our remembered color back to accumulator
          dex             ; decrement x-register to go to next iteration
          bne cycle1      ; repeat if there are iterations left
          sta color+$27   ; otherwise store te last color from accu into color table
          sta $d800+25       ; ... and into Color Ram
                          

 
          rts             ; return from subroutine

