!zone main
!source "macros.asm"


BASIC_START = $0801
CODE_START = $9000

* = BASIC_START
!byte 12,8,0,0,158
!if CODE_START >= 10000 {!byte 48+((CODE_START/10000)%10)}
!if CODE_START >= 1000 {!byte 48+((CODE_START/1000)%10)}
!if CODE_START >= 100 {!byte 48+((CODE_START/100)%10)}
!if CODE_START >= 10 {!byte 48+((CODE_START/10)%10)}
!byte 48+(CODE_START % 10),0,0,0

; load resources into memory
!source "load_resources.asm"


* = CODE_START
	jmp init


screen_update_handler_ptr !word 0
keyboard_handler_ptr !word 0
flash_screen_on_data !byte 0
.dbg_pos !byte 0
.end_of_command !byte 0
.debug_output_offset !byte 0
in_command !byte 0
text !pet 13, "hello trailhead dx!", 0

init
	

	
	jsr screen_clear
	
	; disable BASIC rom
	lda $01
	and #%11111110
	sta $01

	jsr mule_sprite_init
	;jsr mule_logo_sprite_init
	jsr twitter_sprite_init

	jsr INIT_SID

	jsr patch_rs232_routines

	jsr irq_init
	jsr rs232_open
	jsr main_screen_enter
	jsr main_screen_render_architecture

.main_loop
	jsr keyboard_read
	jsr rs232_try_read_byte

	tay
	lda RSSTAT      ; check if recv buffer was empty
	and #%00001000
	bne .main_loop  ; if bit-3 was set, buffer was empty, no data read
	tya
	
	jsr command_handler
	jmp .main_loop


!source "newmodem.asm"
!source "defs.asm"
!source "screen.asm"
!source "rs232.asm"
!source "string.asm"
!source "keyboard_input.asm"
!source "irq.asm"
!source "memory.asm"
!source "cmd_handler.asm"
!source "shared_resources.asm"
!source "math.asm"
!source "logo_sprite.asm"
!source "mule_sprite.asm"
!source "mule_logo_sprite.asm"
!source "twitter_sprite.asm"
!source "main_screen.asm"
!source "beep.asm"
!source "resources/data_color_wash.asm"

;!if * > $9fff {
;	!error "Program reached ROM: ", * - $d000, " bytes overlap."
;}
