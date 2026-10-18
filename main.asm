; ARMOR DUEL 2600 - Milestone 2.2: projectile + stable positioning
; Joystick: up/down drive, left/right hull, fire+left/right turret.
; Tap fire without turning to launch one projectile.
;
; NOTA: "processor 6502" DEBE ir con sangria (espacios o tab), nunca en la columna 0.

	processor 6502

VSYNC   = $00
VBLANK  = $01
WSYNC   = $02
NUSIZ0  = $04
COLUP0  = $06
COLUP1  = $07
COLUBK  = $09
INPT4   = $0C
RESP0   = $10
RESM0   = $12
GRP0    = $1B
ENAM0   = $1D
HMP0    = $20
HMM0    = $22
HMOVE   = $2A
SWCHA   = $0280
INTIM   = $0284
TIM64T  = $0296

TankX         = $80
TankY         = $81
Facing        = $82
Row           = $83
TurnDelay     = $84
StepX         = $85
StepY         = $86
DriveDelay    = $87
DiagonalPhase = $88
SpriteBase    = $89
TurretFacing  = $8A
TurretBase    = $8B
HullRow       = $8C
BulletX       = $8D
BulletY       = $8E
BulletDX      = $8F
BulletDY      = $90
BulletActive  = $91
FireLatch     = $92
BulletDelay   = $93
CompositeRows = $94    ; 8 bytes: $94..$9B
TankByte      = $9C    ; GRP0 de la siguiente scanline
MissileVal    = $9D    ; ENAM0 de la siguiente scanline

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
    sta NUSIZ0             ; single player, missile width 1
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
    jsr HandleFire
    jsr UpdateBullet

    lda Facing
    asl
    asl
    asl
    sta SpriteBase
    lda TurretFacing
    asl
    asl
    asl
    sta TurretBase

    ; Precompute the 8 OR-combined rows during VBLANK.
    ldx #7
ComposeLoop:
    txa
    clc
    adc SpriteBase
    tay
    lda TankSprites,y
    sta HullRow
    txa
    clc
    adc TurretBase
    tay
    lda TurretSprites,y
    ora HullRow
    sta CompositeRows,x
    dex
    bpl ComposeLoop

    ; --- Posicionamiento horizontal ---
    ; Primero se fijan las posiciones gruesas (RESxx) y los ajustes finos
    ; (HMxx) de AMBOS objetos, y al final se hace UN SOLO HMOVE.
    ; Despues del HMOVE no se escribe ningun HMxx (el TIA tarda ~24 ciclos
    ; en aplicarlo y escribir antes lo corrompe).
    lda TankX
    ldx #0                 ; 0 = player 0
    jsr SetHorizPos

    lda #0
    sta HMM0               ; sin movimiento fino si no hay bala
    lda BulletActive
    beq ApplyMotion
    lda BulletX
    ldx #2                 ; 2 = missile 0
    jsr SetHorizPos
ApplyMotion:
    sta WSYNC
    sta HMOVE

WaitBlank:
    lda INTIM
    bne WaitBlank          ; al salir A = 0
    sta WSYNC
    sta VBLANK             ; A = 0: enciende video
    sta TankByte           ; la fila 0 nunca tiene tanque ni bala
    sta MissileVal
    ldx #0

; Kernel: GRP0 y ENAM0 se escriben al INICIO de la linea (todavia en HBLANK),
; usando datos calculados durante la linea anterior. Asi el tanque y la bala
; no cambian de fila segun su posicion horizontal.
Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENAM0

    inx                    ; calcular datos de la fila siguiente

    ldy #0
    lda BulletActive
    beq NoBulletRow
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

    cpx #192
    sta WSYNC
    bne Visible

    lda #0
    sta GRP0
    sta ENAM0
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame

Controls:
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
    and #7
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
    and #7
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

; Fire is edge-triggered: one shot per button press.
; Holding left/right with fire only rotates the turret.
HandleFire:
    lda INPT4
    bmi FireReleased
    lda FireLatch
    bne FireDone
    lda #1
    sta FireLatch
    lda SWCHA
    and #$C0
    cmp #$C0
    bne FireDone
    lda BulletActive
    bne FireDone
    ; Spawn approximately at the center of the 8x8 sprite.
    lda TankX
    clc
    adc #4
    sta BulletX
    lda TankY
    clc
    adc #4
    sta BulletY
    ldx TurretFacing
    lda DeltaX,x
    sta BulletDX
    lda DeltaY,x
    sta BulletDY
    lda #1
    sta BulletActive
    lda #0
    sta BulletDelay
FireDone:
    rts
FireReleased:
    lda #0
    sta FireLatch
    rts

; Bullet moves one pixel in each active axis every 3 frames.
; Diagonal bullets therefore move faster in Euclidean distance.
UpdateBullet:
    lda BulletActive
    beq BulletDone
    lda BulletDelay
    beq BulletReady
    dec BulletDelay
    rts
BulletReady:
    lda #2
    sta BulletDelay
    lda BulletX
    clc
    adc BulletDX
    cmp #4
    bcc KillBullet
    cmp #156
    bcs KillBullet
    sta BulletX
    lda BulletY
    clc
    adc BulletDY
    cmp #4
    bcc KillBullet
    cmp #188
    bcs KillBullet
    sta BulletY
BulletDone:
    rts
KillBullet:
    lda #0
    sta BulletActive
    rts

DeltaX:
    .byte 0, 1, 1, 1, 0, $FF, $FF, $FF
DeltaY:
    .byte $FF, $FF, 0, 1, 1, 1, 0, $FF

; Posicionamiento horizontal generico (misma rutina validada).
; Entrada: A = posicion X; X = 0 (player 0) o 2 (missile 0).
; RESP0,x y HMP0,x apuntan a RESM0 y HMM0 cuando X = 2.
; NO hace HMOVE: el llamador lo hace una sola vez al final.
SetHorizPos:
    sec
    sta WSYNC
DivideLoop:
    sbc #15
    bcs DivideLoop
    eor #7
    asl
    asl
    asl
    asl
    sta RESP0,x
    sta HMP0,x
    rts

; Compact 6x6 hull with tracks. 8 orientations x 8 rows.
TankSprites:
; North
    .byte %00000000,%01100110,%01100110,%01111110
    .byte %01111110,%01100110,%01100110,%00000000
; NE
    .byte %00000000,%00001110,%00111110,%01111100
    .byte %01111100,%01111000,%01110000,%00000000
; East
    .byte %00000000,%01111110,%00011000,%01111110
    .byte %01111110,%00011000,%01111110,%00000000
; SE
    .byte %00000000,%01110000,%01111000,%01111100
    .byte %01111100,%00111110,%00001110,%00000000
; South
    .byte %00000000,%01100110,%01100110,%01111110
    .byte %01111110,%01100110,%01100110,%00000000
; SW
    .byte %00000000,%00001110,%00011110,%00111110
    .byte %00111110,%01111100,%01110000,%00000000
; West
    .byte %00000000,%01111110,%00011000,%01111110
    .byte %01111110,%00011000,%01111110,%00000000
; NW
    .byte %00000000,%01110000,%01111100,%00111110
    .byte %00111110,%00011110,%00001110,%00000000

TurretSprites:
; North
    .byte %00011000,%00011000,%00011000,%00111100
    .byte %00111100,%00011000,%00000000,%00000000
; NE
    .byte %00000011,%00000110,%00001100,%00111100
    .byte %00111100,%00011000,%00000000,%00000000
; East
    .byte %00000000,%00000000,%00000000,%00111111
    .byte %00111111,%00000000,%00000000,%00000000
; SE
    .byte %00000000,%00000000,%00011000,%00111100
    .byte %00111100,%00001100,%00000110,%00000011
; South
    .byte %00000000,%00000000,%00011000,%00111100
    .byte %00111100,%00011000,%00011000,%00011000
; SW
    .byte %00000000,%00000000,%00011000,%00111100
    .byte %00111100,%00110000,%01100000,%11000000
; West
    .byte %00000000,%00000000,%00000000,%11111100
    .byte %11111100,%00000000,%00000000,%00000000
; NW
    .byte %11000000,%01100000,%00110000,%00111100
    .byte %00111100,%00011000,%00000000,%00000000

    org $FFFC
    .word Reset
    .word Reset