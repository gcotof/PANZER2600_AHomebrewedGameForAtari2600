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

    lda #76
    sta TankX
    lda #88
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
    sta GRP0
    sta ENAM0
    sta GRP1
    sta NUSIZ1
    sta TargetRespawn
    sta TargetHits
    sta NUSIZ0             ; single player, missile width 1
    lda #112
    sta TargetX
    lda #64
    sta TargetY
    lda #TARGET_COLOR
    sta COLUP1
    lda #$86
    sta COLUP0
    lda #$22
    sta COLUBK

