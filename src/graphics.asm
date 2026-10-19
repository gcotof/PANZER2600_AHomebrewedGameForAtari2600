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
    bcc .InTank
    lda #0
    beq .StoreTank
.InTank:
    tay
    lda CompositeRows,y
.StoreTank:
    sta TankByte

    txa
    sec
    sbc Tank2Y
    cmp #8
    bcc .InTank2
    lda #0
    beq .StoreTank2
.InTank2:
    tay
    lda Tank2Rows,y
.StoreTank2:
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
