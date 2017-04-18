!zone main_screen

border !pet "----------------------------------------", 0
title_text !pet "** MULESOFT :: COMMODORE 64 (1982) **", 0
;tweet_hashtag_1 !pet "Connected to MULESOFT #connect17 feed", 0
description_text 
!pet "     #connect17 feed -> CloudHub", 13
!pet "     -> Anypoint MQ -> Mule on Rasp. Pi", 13
!pet "     -> Commodore 64", 0
tweet_hashtag_2 
!pet "    Tweet a message or a photo with ", 13, COLOR_GREEN
!pet "     #connect17 #c64", COLOR_LIGHT_BLUE, " to see it here!", 0

main_screen_enter
	jsr screen_clear
	jsr screen_enable_lowercase_chars

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


	ldx #3
	ldy #0
	+set16im description_text, $fb
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

	; lda #COLOR_LIGHT_BLUE
	; jsr CHROUT

	; lda #13
	; jsr CHROUT
	rts
