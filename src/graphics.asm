Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENAM0
    lda TargetByte
    sta GRP1

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

    lda TargetRespawn
    bne NoTargetRow
    txa
    sec
    sbc TargetY
    cmp #8
    bcs NoTargetRow
    lda #$FF
    bne StoreTarget
NoTargetRow:
    lda #0
StoreTarget:
    sta TargetByte

    cpx #192
    sta WSYNC
    bne Visible

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

