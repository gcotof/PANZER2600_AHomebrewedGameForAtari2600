    org $F000
Reset:
    sei
    cld
    ldx #0
    txa
ClearRAM:
    dex
    txs
    pha
    bne ClearRAM

    lda #56
    sta TankX
    lda #START_Y
    sta TankY
    lda #0
    sta Facing
    sta TurretFacing
    sta TurnDelay
    sta DriveDelay
    sta DiagonalPhase
    sta BulletActive
    sta FireLatch
    sta BulletDelay
    lda #192
    sta BulletY
    sta S1Y
    sta S2Y
    lda #0
    sta GRP0
    sta ENAM0
    sta ENABL
    sta GRP1
    sta NUSIZ1
    sta TargetRespawn
    sta TargetHits
    sta NUSIZ0             ; single player, missile width 1
    sta PF1
    sta PF2
    lda #PF_MIRROR         ; CTRLPF bit0=1: la mitad derecha del playfield es un espejo
    sta CTRLPF
    lda #WALL_PF0
    sta PF0
    lda #WALL_COLOR
    sta COLUPF
    lda #120
    sta Tank2X
    lda #START_Y
    sta Tank2Y
    lda #6
    sta Facing2
    sta Turret2Facing
    lda #TANK2_COLOR
    sta COLUP1
    lda #$86
    sta COLUP0
    lda #$22
    sta COLUBK

