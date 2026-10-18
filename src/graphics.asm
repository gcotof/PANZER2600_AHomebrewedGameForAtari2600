Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENAM0

    inx                    ; calcular datos de la fila siguiente

    ldy #0
    lda BulletActive
    beq NoBulletRow
    txa
    sec
    sbc BulletY
    cmp #2
    bcs NoBulletRow
    ldy #2
NoBulletRow:
    sty MissileVal

    txa
    sec
    sbc TankY
    cmp #8
    bcs NoTankRow
    tay
    lda CompositeRows,y
    jmp StoreTank
NoTankRow:
    lda #0
StoreTank:
    sta TankByte

    cpx #192
    sta WSYNC
    bne Visible

    lda #0
    sta GRP0
    sta ENAM0
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame

