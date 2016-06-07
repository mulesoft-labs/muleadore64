!zone info_screen

.str_text 
!pet "THE HACK:", 13
!pet 13
!pet "2 days to prove the MuleSoft tagline", 13
!pet "'Connect anything. Change everything'", 13
!pet 13
!pet 13
!pet 13
!pet "THE ARCHITECTURE:", 13
!pet 13
!pet "Cloudhub App (serves UI, pollers)", 13
!pet 13
!pet " -> MQ", 13
!pet 13
!pet "  -> RasPi running Mule", 13
!pet 13
!pet "   -> RasPi Serial port", 13
!pet 13
!pet "    -> C64 user-port", 13
!pet 13
!pet "     -> Custom C64 code", 13
!pet 0


info_screen_render
		; disable screen update handler
		sei
		lda #0
		sta screen_update_handler_ptr
		cli
		
		lda #COLOR_WHITE
		jsr CHROUT
 		jsr screen_clear

 		ldx #1         ; row
        ldy #0          ; column
        +set16im .str_text, $fb
        jsr screen_print_str
        rts