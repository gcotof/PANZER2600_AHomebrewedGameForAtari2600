    processor 6502

VSYNC   = $00
VBLANK  = $01
WSYNC   = $02
COLUP0  = $06
COLUBK  = $09
GRP0    = $1B
RESP0   = $10
HMP0    = $20
HMOVE   = $2A
SWCHA   = $0280
TIM64T  = $0296
INTIM   = $0284

TankX   = $80
TankY   = $81
Facing  = $82
Row     = $83
TurnDelay = $84
StepX   = $85
StepY   = $86
DriveDelay = $87
DiagonalPhase = $88

    org $F000
Reset:
    sei
    cld
    ldx #$FF
    txs
    lda #0
ClearRAM:
    sta $80,x
    dex
    bne ClearRAM
    lda #76
    sta TankX
    lda #88
    sta TankY
    lda #0
    sta Facing
    sta TurnDelay
    sta GRP0
    lda #$86
    sta COLUP0
    lda #$22
    sta COLUBK

Frame:
    lda #2
    sta VBLANK
    sta VSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC
    lda #0
    sta VSYNC
    lda #43
    sta TIM64T
    jsr Controls
    jsr PositionPlayer
WaitBlank:
    lda INTIM
    bne WaitBlank
    sta WSYNC
    lda #0
    sta VBLANK
    ldx #0
Visible:
    stx Row
    txa
    sec
    sbc TankY
    cmp #8
    bcs NoTank
    tay
    lda TankSprite,y
    jmp DrawRow
NoTank:
    lda #0
DrawRow:
    sta GRP0
    sta WSYNC
    ldx Row
    inx
    cpx #192
    bne Visible
    lda #0
    sta GRP0
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame

Controls:
    ; Facing: 0=N, 1=NE, 2=E, 3=SE, 4=S, 5=SW, 6=W, 7=NW.
    ; Turning is throttled to one 45-degree step every six frames.
    lda TurnDelay
    beq ReadTurn
    dec TurnDelay
    jmp ReadDrive
ReadTurn:
    lda SWCHA
    and #$40
    bne CheckRight
    lda Facing
    sec
    sbc #1
    and #7
    sta Facing
    lda #5
    sta TurnDelay
    jmp ReadDrive
CheckRight:
    lda SWCHA
    and #$80
    bne ReadDrive
    lda Facing
    clc
    adc #1
    and #7
    sta Facing
    lda #5
    sta TurnDelay

ReadDrive:
    ; Joystick up = forward, down = reverse.
    ; The lookup tables contain signed 8-bit deltas.
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
    ; One movement step every 3 frames (current frame plus 2 waiting).
    lda #2
    sta DriveDelay
    ; Diagonals alternate X and Y instead of stepping both at once.
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
    ; Accept only positions 8..150 horizontally, 8..184 vertically.
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

; Clockwise directions, starting at north (screen Y increases down).
DeltaX:
    .byte 0, 1, 1, 1, 0, $FF, $FF, $FF
DeltaY:
    .byte $FF, $FF, 0, 1, 1, 1, 0, $FF

PositionPlayer:
    lda TankX
    sec                 ; fuera del bucle
    sta WSYNC
Divide15:
    sbc #15             ; 2 ciclos
    bcs Divide15        ; 3 ciclos  -> 5 ciclos = 15 px por iteración

    eor #7
    asl
    asl
    asl
    asl
    sta RESP0           ; posición gruesa
    sta HMP0            ; ajuste fino

    sta WSYNC
    sta HMOVE
    rts

TankSprite:
    .byte %00111100
    .byte %01111110
    .byte %11111111
    .byte %11011011
    .byte %11011011
    .byte %11111111
    .byte %01111110
    .byte %00111100

    org $FFFC
    .word Reset
    .word Reset
