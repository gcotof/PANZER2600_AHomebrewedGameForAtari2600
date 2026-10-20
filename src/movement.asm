ReadDrive:
    lda DriveDelay
    beq DriveReady
    dec DriveDelay
    rts
DriveReady:
    lda FireCharge
    cmp #STOP_AT
    bcs DriveDone                ; ultimos 0.5 s de carga: tanque quieto
    lda SWCHA
    and #$10
    bne CheckReverse
    ldx Facing
    lda HullDeltaX,x
    sta StepX
    lda HullDeltaY,x
    sta StepY
    jsr MoveSlow
    rts
CheckReverse:
    lda SWCHA
    and #$20
    bne DriveDone
    ldx Facing
    lda HullDeltaX,x
    eor #$FF
    clc
    adc #1
    sta StepX
    lda HullDeltaY,x
    eor #$FF
    clc
    adc #1
    sta StepY
    jsr MoveSlow
DriveDone:
    rts
MoveSlow:
    lda FireCharge
    lsr
    lsr
    lsr
    lsr                    ; 0..9 segun la carga
    clc
    adc #2                 ; mas carga = mas frames entre pasos
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
    lda StepX
    beq SkipX
    clc
    adc TankX
    cmp #TANK_MIN_X
    bcc SkipX
    cmp #TANK_MAX_X
    bcs SkipX
    sta TestX
    lda TankY
    sta TestY
    jsr TankHitsX
    bcs SkipX
    lda TestX
    sta TankX
SkipX:
    lda StepY
    beq SkipY
    clc
    adc TankY
    cmp #TANK_MIN_Y
    bcc SkipY
    cmp #TANK_MAX_Y
    bcs SkipY
    sta TestY
    lda TankX
    sta TestX
    jsr TankHitsY
    bcs SkipY
    lda TestY
    sta TankY
SkipY:
    rts
