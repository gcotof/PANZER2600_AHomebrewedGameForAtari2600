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
    cmp #8
    bcc SkipX
    cmp #151
    bcs SkipX
    sta TankX
SkipX:
    lda TankY
    clc
    adc StepY
    cmp #8
    bcc SkipY
    cmp #185
    bcs SkipY
    sta TankY
SkipY:
    rts

