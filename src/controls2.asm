Controls2:
    lda Lock2Frames
    beq Controls2Free
    dec Lock2Frames
    rts
Controls2Free:
    lda Turn2Delay
    beq ReadTurn2
    dec Turn2Delay
    jmp ReadDrive2
ReadTurn2:
    lda SWCHA
    and #$04
    beq Turn2Left
    lda SWCHA
    and #$08
    beq Turn2Right
    jmp ReadDrive2
Turn2Left:
    lda INPT5
    bmi Turn2HullLeft
    lda Turret2Facing
    sec
    sbc #1
    and #7
    sta Turret2Facing
    jmp Turn2Finished
Turn2HullLeft:
    lda Facing2
    sec
    sbc #1
    and #7
    sta Facing2
    jmp Turn2Finished
Turn2Right:
    lda INPT5
    bmi Turn2HullRight
    lda Turret2Facing
    clc
    adc #1
    and #7
    sta Turret2Facing
    jmp Turn2Finished
Turn2HullRight:
    lda Facing2
    clc
    adc #1
    and #7
    sta Facing2
Turn2Finished:
    lda #5
    sta Turn2Delay
    jmp ReadDrive2
ReadDrive2:
    lda Drive2Delay
    beq Drive2Ready
    dec Drive2Delay
    rts
Drive2Ready:
    lda Fire2Charge
    cmp #STOP_AT
    bcs Drive2Done                ; ultimos 0.5 s de carga: tanque quieto
    lda SWCHA
    and #$01
    bne CheckReverse2
    ldx Facing2
    lda DeltaX,x
    sta StepX
    lda DeltaY,x
    sta StepY
    jmp MoveSlow2
CheckReverse2:
    lda SWCHA
    and #$02
    bne Drive2Done
    ldx Facing2
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
    jmp MoveSlow2
Drive2Done:
    rts
MoveSlow2:
    lda Fire2Charge
    lsr
    lsr
    lsr
    lsr                    ; 0..9 segun la carga
    clc
    adc #2                 ; mas carga = mas frames entre pasos
    sta Drive2Delay
    lda StepX
    beq MoveNow2
    lda StepY
    beq MoveNow2
    lda Diagonal2Phase
    eor #1
    sta Diagonal2Phase
    beq OnlyX2
    lda #0
    sta StepX
    jmp MoveNow2
OnlyX2:
    lda #0
    sta StepY
MoveNow2:
ApplyStep2:
    lda Tank2X
    clc
    adc StepX
    cmp #TANK_MIN_X
    bcc Skip2X
    cmp #TANK_MAX_X
    bcs Skip2X
    sta TestX
    lda Tank2Y
    sta TestY
    jsr TankHitsWall
    bcs Skip2X
    lda TestX
    sta Tank2X
Skip2X:
    lda Tank2Y
    clc
    adc StepY
    cmp #TANK_MIN_Y
    bcc Skip2Y
    cmp #TANK_MAX_Y
    bcs Skip2Y
    sta TestY
    lda Tank2X
    sta TestX
    jsr TankHitsWall
    bcs Skip2Y
    lda TestY
    sta Tank2Y
Skip2Y:
    rts
