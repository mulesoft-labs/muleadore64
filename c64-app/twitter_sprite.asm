!zone twiter_sprite

.pos_y !byte 230
.frame_counter !byte .FRAME_COUNT
.anim_delay !byte .ANIM_DELAY
.anim_direction !byte 0

.ANIM_DELAY = 3
.FRAME_COUNT = 8

; sprite2
twitter_sprite_init
    lda #$90
    sta $07fa
    lda $d015
    ora #%00000100
    sta $d015
    lda #14     ; color 1
    sta $d029

    lda #30     ; x
    sta $d004
    lda #225    ; y
    sta $d005

    lda #.FRAME_COUNT
    sta .frame_counter
    lda #0
    sta .anim_direction
    rts

twitter_sprite_update
    jsr .animate
    rts

.animate
    dec .anim_delay
    bne .done
    ldx #.ANIM_DELAY
    stx .anim_delay

    dec .frame_counter
    bne .update_frame

    lda .anim_direction
    eor #1
    sta .anim_direction

    ldx #.FRAME_COUNT
    stx .frame_counter
    rts
.update_frame
    lda .anim_direction
    bne .update_frame_backwards
    inc $07fa
    rts
.update_frame_backwards
    dec $07fa
    rts   

.done
    rts


    
