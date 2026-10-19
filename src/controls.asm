Controls:
    lda Lock1Frames
    beq ControlsFree
    dec Lock1Frames
    rts                    ; tanque sacudido por el disparo: sin control
ControlsFree:
    lda TurnDelay
    beq ReadTurn
    dec TurnDelay
    jmp ReadDrive
ReadTurn:
    lda SWCHA
    and #$40
    beq TurnLeft
    lda SWCHA
    and #$80
    beq TurnRight
    jmp ReadDrive
TurnLeft:
    lda INPT4
    bmi TurnHullLeft
    lda TurretFacing
    sec
    sbc #1
    and #15
    sta TurretFacing
    jmp TurnFinished
TurnHullLeft:
    lda Facing
    sec
    sbc #1
    and #7
    sta Facing
    jmp TurnFinished
TurnRight:
    lda INPT4
    bmi TurnHullRight
    lda TurretFacing
    clc
    adc #1
    and #15
    sta TurretFacing
    jmp TurnFinished
TurnHullRight:
    lda Facing
    clc
    adc #1
    and #7
    sta Facing
TurnFinished:
    lda #5
    sta TurnDelay
    jmp ReadDrive

