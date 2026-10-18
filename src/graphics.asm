; Milestone 2.4.2: kernel con rutas acotadas.
; Invariante: BulletY y TargetY = 192 cuando no se dibujan.
; En el peor caso (bala + tanque + blanco): ~73 ciclos antes de WSYNC.
; Es importante mantener el orden y NO anadir trabajo a Visible.
Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENAM0
    lda TargetByte
    sta GRP1

    inx                    ; datos de la proxima scanline

    ; Sin rama BulletActive: BulletY=192 cuando la bala no existe.
    ldy #0
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

    ; Sin rama TargetRespawn: TargetY=192 mientras esta oculto.
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
