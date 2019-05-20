!zone main_screen

border !pet "----------------------------------------", 0
title_text 
!pet COLOR_GREEN, "  ** commodore 64 selfie machine **", COLOR_LIGHT_BLUE, 13, 13
!pet "   -in which our 37 year old c64 is", 13
!pet "      connected to everything-", 0

;tweet_hashtag_1 !pet "Connected to MULESOFT #connect17 feed", 0

tweet_hashtag_2 
!pet "    tweet a message or a photo with ", 13, COLOR_GREEN
!pet "     #tdx18 #c64", COLOR_LIGHT_BLUE, " to see it here!", 0

.str_banner !bin "resources/architecture.seq"
!byte 0

main_screen_enter
	jsr mule_logo_sprite_disable
	jsr screen_clear

	lda #COLOR_LIGHT_BLUE
	jsr CHROUT

	; lda #13
	; jsr CHROUT
	; jsr CHROUT

	; lda #COLOR_LIGHT_GREY
	; jsr CHROUT

	ldx #1
	ldy #1
	+set16im title_text, $fb
	jsr screen_print_str

	ldx #6
	ldy #0
	+set16im border, $fb
	jsr screen_print_str

	ldx #21
	ldy #0
	+set16im border, $fb
	jsr screen_print_str	

	ldx #22
	ldy #0
	+set16im tweet_hashtag_2, $fb
	jsr screen_print_str
	rts

main_screen_render_architecture
	lda #COLOR_WHITE
    jsr CHROUT

    ldx #7         ; row
    ldy #0          ; column
    +set16im .str_banner, $fb
    jsr screen_print_str
    rts

