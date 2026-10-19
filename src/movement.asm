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
    cmp #TANK_MIN_Y
    bcc SkipY
    cmp #TANK_MAX_Y
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
TankHitsWall:
    ; Callejon libre solo si el sprite completo (8 filas) cabe dentro.
    lda TestY
    cmp #STREET_Y0
    bcc TankStreetNotClear
    cmp #STREET_Y1-7
    bcs TankStreetNotClear
    clc
    rts
TankStreetNotClear:
    lda TestY
    clc
    adc #7                  ; TestY >= Y0-7 (el sprite mide 8 filas)
    cmp ArenaY0
    bcc NoWallHit
    lda TestY
    cmp ArenaY1
    bcs NoWallHit
    lda TestX
    cmp ATLL
    bcc TankRightRect
    cmp ATLH
    bcc TankWallYes
TankRightRect:
    cmp ATRL
    bcc NoWallHit
    cmp ATRH
    bcc TankWallYes
NoWallHit:
    clc
    rts
TankWallYes:
    sec
    rts
