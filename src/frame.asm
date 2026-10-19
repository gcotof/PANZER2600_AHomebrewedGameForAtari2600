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

    lda PauseFrames
    beq PlayFrame
    dec PauseFrames
    bne FrameLogicDone
    jsr EndPause
    jmp FrameLogicDone
PlayFrame:
    jsr Controls
    jsr Controls2
    jsr LoadSlot1
    jsr HandleFire
    jsr UpdateBullet
    jsr UpdateWall
    jsr UpdateHits
    jsr SaveSlot1
    jsr LoadSlot2
    jsr HandleFire2
    jsr UpdateBullet
    jsr UpdateWall
    jsr UpdateHits
    jsr SaveSlot2
    jsr UpdateRecoil
    jsr UpdateRecoil2
    jsr PickDraw
FrameLogicDone:
    jsr PrepHud

    ; Color del tanque: se aclara mientras se carga el disparo.
    lda FireCharge
    lsr
    lsr
    lsr
    lsr
    lsr                    ; 0..5 con FIRE_HOLD = 180
    clc
    adc #6
    ora #$80               ; $86 en reposo, hasta $8B cargado
    sta COLUP0
    ; Color del tanque 2: verde que se aclara igual ($C6..$CB).
    lda Fire2Charge
    lsr
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$C6
    sta COLUP1

    ; Destello del fondo al disparar.
    lda #BG_COLOR
    ldx FlashFrames
    beq SetBackground
    dec FlashFrames
    lda #FLASH_COLOR
SetBackground:
    ldx Winner
    beq BgStore
    lda PauseFrames
    and #8
    bne BgWinner
    lda #BG_COLOR
    jmp BgStore
BgWinner:
    lda WinnerColors-1,x   ; x = Winner (1 o 2)
BgStore:
    sta COLUBK

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
    lda Facing2
    asl
    asl
    asl
    sta SpriteBase
    lda Turret2Facing
    asl
    asl
    asl
    sta TurretBase
    ldx #7
Compose2Loop:
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
    sta Tank2Rows,x
    dex
    bpl Compose2Loop

    ; --- Posicionamiento horizontal ---
    ; Primero se fijan las posiciones gruesas (RESxx) y los ajustes finos
    ; (HMxx) de AMBOS objetos, y al final se hace UN SOLO HMOVE.
    ; Despues del HMOVE no se escribe ningun HMxx (el TIA tarda ~24 ciclos
    ; en aplicarlo y escribir antes lo corrompe).
    lda TankX
    ldx #0                 ; 0 = player 0
    jsr SetHorizPos

    lda Tank2X
    ldx #1
    jsr SetHorizPos

    lda #0
    sta HMBL               ; sin movimiento fino si no hay bala
    lda BulletActive
    beq ApplyMotion
    lda BulletX
    ldx #4                 ; 4 = ball (la bala)
    jsr SetHorizPos
ApplyMotion:
    sta WSYNC
    sta HMOVE

    ; Muro superior: PF completo hasta que el kernel lo cambie.
    lda #$F0
    sta PF0
    lda #$FF
    sta PF1
    sta PF2
WaitBlank:
    lda INTIM
    bne WaitBlank          ; al salir A = 0
    sta WSYNC
    sta VBLANK             ; A = 0: enciende video
    sta TankByte           ; la fila 0 nunca tiene tanque ni bala
    sta MissileVal
    sta TargetByte
    ldx #0

; Kernel: GRP0 y ENAM0 se escriben al INICIO de la linea (todavia en HBLANK),
; usando datos calculados durante la linea anterior. Asi el tanque y la bala
; no cambian de fila segun su posicion horizontal.
