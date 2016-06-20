!cpu 6510
!to "./build/test.prg",cbm
!zone main
!source "macros.asm"

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

; load resources into memory
!source "load_resources.asm"

; load code into $c000
* = $c000
                jmp .init


screen_update_handler_ptr !word 0

                

.init
                ; disable BASIC rom
                lda $01
                and #%01111111
                sta $01
                jsr screen_clear
                lda #23
                sta $d018

                jsr rs232_open
                jsr main_screen_render
                jsr irq_init

.main_loop
                jsr keyboard_read
                jsr rs232_try_read_byte
                cmp #0
                beq .main_loop  

                ldy #0          ; reset our 'end of command' marker
                cmp #126        ; tilde char means 'end of command'
                bne .add_byte_to_buffer
                ldy #1          ; if tilde, then set Y = 1
                sty .end_of_command
                lda #0          ; replace ~ with \0 so we write the end of the string
.add_byte_to_buffer
                ;inc $d021
                ldx cmd_buffer_ptr
                sta cmd_buffer, x
                inc cmd_buffer_ptr

                jsr heartbeat_reset

                ldy .end_of_command
                cpy #1          ; if not 'end of command', go back around
                bne .main_loop

                jsr command_handler
                ldx #0                  ; set length of buffer back to zero
                stx cmd_buffer_ptr
                stx .end_of_command
                jmp .main_loop

cmd_buffer !fill 250, 0
cmd_buffer_ptr !byte 0
.end_of_command !byte 0


!source "defs.asm"
!source "screen.asm"
!source "rs232.asm"
!source "main_screen.asm"
!source "tweet_screen.asm"
!source "string.asm"
!source "cmd_handler.asm"
!source "keyboard_input.asm"
!source "mule_sprite.asm"
!source "irq.asm"
!source "heartbeat.asm"
!source "logo_screen.asm"
!source "info_screen.asm"
!source "signin_screen.asm"
