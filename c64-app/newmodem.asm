---------------------------------------------
; These routines were written by George Hug and appeared in the February 1989
; issue of Transactor magazine.  The routines modify (indeed, somewhat replace)
; the RS232 routines in the kernal ROM in order to achieve perfect transmission
; at 300, 1200, and 2400 baud
;---------------------------------------------

tab1   !BYTE $CB 
        !BYTE $01
        !BYTE $42
        !BYTE $04
        !BYTE $33
        !BYTE $13
tab2   !BYTE $A5 
        !BYTE $01
        !BYTE $4D
        !BYTE $03
        !BYTE $52
        !BYTE $0D

patch_rs232_routines
        LDA #<irq  ; Patch IRQ vector
        LDY #>irq
        STA $0318
        STY $0319
        LDA #<chkin ; Patch CHKIN vector
        LDY #>chkin
        STA $031E
        STY $031F
        LDA #<chrout ; Patch CHROUT vector
        LDY #>chrout
        STA $0326
        STY $0327
        RTS 

irq    PHA 
        TXA 
        PHA 
        TYA 
        PHA 
        CLD 
        LDX $DD07
        LDA #$7F
        STA $DD0D
        LDA $DD0D
        BPL i2
        CPX $DD07
        LDY $DD01
        BCS i0
        ORA #$02
        ORA $DD0D
i0     AND $02A1 
        TAX 
        LSR 
        BCC i1
        LDA $DD00
        AND #$FB
        ORA $B5
        STA $DD00
i1     TXA 
        AND #$10
        BEQ i3
slo1   LDA #$CB 
        STA $DD06
shi1   LDA #$01 
        STA $DD07
        LDA #$11
        STA $DD0F
        LDA #$12
        EOR $02A1
        STA $02A1
        STA $DD0D
slo2   LDA #$A5 
        STA $DD06
shi2   LDA #$01 
        STA $DD07
        LDA #$08
        STA $A8
        BNE i6
i2     LDY #$00 
        JMP $FE56

i3     LDA $02A1 
        STA $DD0D
        TXA 
        AND #$02
        BEQ i6
        TYA 
        LSR 
        ROR $AA
        DEC $A8
        BNE i5
        LDY $029B
        LDA $AA
        STA ($F7),Y
        INC $029B
        LDA #$00
        STA $DD0F
        LDA #$12
i4     LDY #$7F 
        STY $DD0D
        STY $DD0D
        EOR $02A1
        STA $02A1
        STA $DD0D
i5     TXA 
        LSR 
i6     BCC i9 
        DEC $B4
        BMI i10
        LDA #$04
        ROR $B6
        BCS i8
i7     LDA #$00 
i8    STA $B5 
i9    JMP $FEBC 
i10    LDY $029D 
        CPY $029E
        BEQ i11
        LDA ($F9),Y
        INC $029D
        STA $B6
        LDA #$09
        STA $B4
        BNE i7
i11    LDX #$00 
        STX $DD0E
        LDA #$01
        BNE i4     ; Just a clever jump

irq2    PHA 
j0     LDA $02A1 
        AND #$03
        BNE j0
        LDA #$10
        STA $DD0D
        LDA #$02
        AND $02A1
        BNE j0
        STA $02A1
        PLA 
        RTS 

chrout PHA 
        LDA $9A
        CMP #$02
        BNE m6
        PLA 
m0     STA $9E 
        STY $97
m1     LDY $029E 
        STA ($F9),Y
        INY 
        CPY $029D
        BEQ m5
        STY $029E
m2     LDA $02A1 
        AND #$01
        BNE m4
        STA $B5
        LDA #$09
        STA $B4
        LDY $029D
        LDA ($F9),Y
        STA $B6
        INC $029D
        LDA $0299
        STA $DD04
        LDA $029A
        STA $DD05
        LDA #$11
        STA $DD0E
        LDA #$81
m3     STA $DD0D
        PHP 
        SEI 
        LDY #$7F
        STY $DD0D
        STY $DD0D
        ORA $02A1
        STA $02A1
        STA $DD0D
        PLP 
m4     CLC
        LDY $97
        LDA $9E
        RTS 

m5     JSR m2
        JMP m1

m6     PLA
        JMP $F1CA

chkin  JSR $F30F 
        BNE n1
        JSR $F31F
        LDA $BA
        CMP #$02
        BNE n2
        STA $99

n0     STA $9E 
        STY $97
        LDA $029A
        AND #$06
        TAY 
        LDA tab1,Y
        STA slo1+1
        LDA tab1+1,Y
        STA shi1+1
        LDA tab2,Y
        STA slo2+1
        LDA tab2+1,Y
        STA shi2+1
        LDA $02A1
        AND #$12
        BNE n4
        STA $DD0F
        LDA #$90
        JMP m3
n1     JMP $F701 

n2     LDA $BA 
        JMP $F21B
n3    STA $9E 
        STY $97
        LDY $029C
        CPY $029B
        BEQ n5
        LDA ($F7),Y
        STA $9E
        INC $029C
n4     CLC 
n5     LDY $97
        LDA $9E
        RTS

.END