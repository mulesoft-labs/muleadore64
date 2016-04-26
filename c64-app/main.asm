!cpu 6510
!to "./build/test.prg",cbm

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

; Constants
SETLFS = $FFBA
OPEN = $FFC0
SETNAM = $FFBD
READST = $FFB7
CHKOUT = $FFC9
CHROUT = $FFD2
CHKIN = $FFC6
CHRIN = $FFCF
PLOT = $FFF0
GETIN = $FFE4
SETMSG = $FF90
CLOSE = $FFC3
PLOT = $FFF0
SCINIT = $FF81

cur_x !byte 0 

* = $c000                                           ; start address for 6502 code       
    
init
                clc
                ldx #0
                ldy #0
                jsr PLOT


                LDA #$80
                JSR SETMSG          ;TURN ON ERROR MESSAGES

                ;lda #0
                ;sta $d800

                ;sta $d020 ; border
                ;sta $d021 ; background
                lda #23
                sta $d018

                lda %00000110
                sta $0293

                

                lda #2   ; file #
                ldx #2   ; rs-232 device
                ldy #0   ; no cmd
                jsr SETLFS

                lda #0
                jsr SETNAM

                jsr OPEN

                ldx #2   ; select file 2 
                jsr CHKIN

                ;lda #'A'
                ;jsr CHROUT

                jsr READST
                sta $0411
                ldx #6
                stx cur_x
tryagain
                jsr GETIN
                cmp #0
                beq tryagain
                
                ;lda #'B'
                jsr CHROUT

                ldx #0
                cpx #0
                beq tryagain

                lda #2
                jsr CLOSE

                lda #0
                sta $d020 ; border

                lda #0
                sta $0500

                jmp *           ; infinite loop