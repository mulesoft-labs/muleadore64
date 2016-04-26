print_string        
                    ldy #$00
                    lda (arg1_ptr), y
                    ldx #1
print_string_loop   
                    ;ora #$80    ;set bit 7 to  
                    sta $0410, y
                    lda #1
                    sta $d810, y
                    iny
                    lda (arg1_ptr), y
                    cmp #$0
                    bne print_string_loop
                    rts
                    ;jmp print_string_loop
