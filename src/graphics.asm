; Milestone 2.5B: kernel en 3 tramos (arriba / pilar / abajo).
; El cuerpo es identico al 2.4.2; solo cambia el valor de salida del bucle.
; PF2 se escribe justo despues del WSYNC de la transicion (+5 ciclos en 1 linea).
    MAC KERNEL_LINES
.Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENAM0
    lda TargetByte
    sta GRP1

    inx

    ldy #0
    txa
    sec
    sbc BulletY
    cmp #2
    bcs .NoBulletRow
    ldy #2
.NoBulletRow:
    sty MissileVal

    txa
    sec
    sbc TankY
    cmp #8
    bcs .NoTankRow
    tay
    lda CompositeRows,y
    jmp .StoreTank
.NoTankRow:
    lda #0
.StoreTank:
    sta TankByte

    txa
    sec
    sbc TargetY
    cmp #8
    bcs .NoTargetRow
    lda #$FF
    bne .StoreTarget
.NoTargetRow:
    lda #0
.StoreTarget:
    sta TargetByte

    cpx #{1}
    sta WSYNC
    bne .Visible
    ENDM

    KERNEL_LINES CWALL_Y0
    lda #CWALL_PF2
    sta PF2
    KERNEL_LINES CWALL_Y1
    lda #0
    sta PF2
    KERNEL_LINES 192

    lda #0
    sta GRP0
    sta ENAM0
    sta GRP1
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame