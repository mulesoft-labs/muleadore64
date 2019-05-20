
hb_counter !byte 60
color_tick !byte $1
color_tick_enabled !byte 1

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

		lda color_tick_enabled
		beq irq_return

		dec hb_counter
		bne irq_return
		lda #60
		sta hb_counter
		lda color_tick
		eor #$f
		sta color_tick

		ldx #255
		lda color_tick
-
		sta $d950, x
		sta $d9ff, x
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

