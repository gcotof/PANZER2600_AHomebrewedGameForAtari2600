ReadDrive:
    lda DriveDelay
    beq DriveReady
    dec DriveDelay
    rts
DriveReady:
    lda SWCHA
    and #$10
    bne CheckReverse
    ldx Facing
    lda DeltaX,x
    sta StepX
    lda DeltaY,x
    sta StepY
    jsr MoveSlow
    rts
CheckReverse:
    lda SWCHA
    and #$20
    bne DriveDone
    ldx Facing
    lda DeltaX,x
    eor #$FF
    clc
    adc #1
    sta StepX
    lda DeltaY,x
    eor #$FF
    clc
    adc #1
    sta StepY
    jsr MoveSlow
DriveDone:
    rts
MoveSlow:
    lda #2
    sta DriveDelay
    lda StepX
    beq MoveNow
    lda StepY
    beq MoveNow
    lda DiagonalPhase
    eor #1
    sta DiagonalPhase
    beq OnlyX
    lda #0
    sta StepX
    jmp MoveNow
OnlyX:
    lda #0
    sta StepY
MoveNow:
    jsr ApplyStep
    rts
ApplyStep:
    lda TankX
    clc
    adc StepX
    cmp #TANK_MIN_X
    bcc SkipX
    cmp #TANK_MAX_X
    bcs SkipX
    sta TestX
    lda TankY
    sta TestY
    jsr TankHitsWall
    bcs SkipX
    lda TestX
    sta TankX
SkipX:
    lda TankY
    clc
    adc StepY
    cmp #8
    bcc SkipY
    cmp #185
    bcs SkipY
    sta TestY
    lda TankX
    sta TestX
    jsr TankHitsWall
    bcs SkipY
    lda TestY
    sta TankY
SkipY:
    rts

; Entrada: TestX, TestY. Salida: C=1 si el tanque chocaria con el pilar.
TankHitsWall:
    lda TestX
    cmp #CWALL_TANK_X_LO
    bcc NoWallHit
    cmp #CWALL_TANK_X_HI
    bcs NoWallHit
    lda TestY
    cmp #CWALL_TANK_Y_LO
    bcc NoWallHit
    cmp #CWALL_TANK_Y_HI
    bcs NoWallHit
    sec
    rts
NoWallHit:
    clc
    rts